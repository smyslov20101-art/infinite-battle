/// @desc Система сохранений с двумя уровнями
/// permanent_save - данные, загруженные из файла (прошлая сессия)
/// current_session - данные текущей сессии (изменяются в колоде)

// Инициализация системы сохранений
function init_save_system() {
    // Пробуем загрузить основной файл; при провале — резервную копию; иначе — дефолт.
    var loaded = false;
    if (file_exists("save_game.sav")) {
        loaded = load_permanent_save();
    }
    if (!loaded && file_exists("save_game.sav.bak")) {
        LOG("⚠️ Основной файл сохранения повреждён, пробуем резервную копию");
        loaded = load_permanent_save_from("save_game.sav.bak");
    }
    if (!loaded) {
        // Первый запуск или оба файла повреждены — создаём дефолт
        create_default_permanent_save();
    }

    // Копируем permanent данные в current_session
    sync_session_from_permanent();
    
    LOG("=== СИСТЕМА СОХРАНЕНИЙ ИНИЦИАЛИЗИРОВАНА ===");
    LOG("Permanent гены: " + string(global.permanent_save.genes));
    LOG("Permanent кристаллы: " + string(global.permanent_save.crystals));
    LOG("Permanent ник: " + string(global.permanent_save.player_name));
    LOG("Session гены: " + string(global.current_session.genes));
}

// Создание структуры для permanent сохранения
function create_default_permanent_save() {
    var today = scr_get_day_number();
    global.permanent_save = {
        player_name: "Игрок",
        genes: 0,
        deck: [-1, -1, -1, -1],
        heroes: [],
        crystals: 0,
        player_stats: {
            best_time: 0,
            total_kills: 0,
            games_played: 0
        },
        // ===== ПОКУПКА КАРТ =====
        // cards          — текущие 4 карты в магазине
        // auto_refresh_at — Unix timestamp когда карты обновятся автоматически (24 ч)
        // ad_charges     — сколько ещё раз можно обновить за рекламу сегодня (0..3)
        // ad_reset_day   — номер дня, в который последний раз восстановили заряды
        shop_cards_data: {
            cards: [],
            auto_refresh_at: 0,
            ad_charges: 3,
            ad_reset_day: today
        },
        // ===== СУНДУКИ =====
        chests_data: {
            bought: [false, false, false, false],
            auto_refresh_at: 0,
            ad_charges: 3,
            ad_reset_day: today
        },
        wave_rewards_data: {
            genes: 0,
            crystals: 0,
            chests: []
        },
        rating_data: {
            players: [],
            last_update: 0
        },
        // ===== РУЛЕТКА =====
        // free_spin_at — Unix timestamp когда станет доступен бесплатный круг (0 = доступен)
        // ad_charges   — сколько крутов за рекламу доступно сегодня (0..3)
        // ad_reset_day — день последнего сброса
        spin_data: {
            free_spin_at: 0,
            ad_charges: 3,
            ad_reset_day: today
        },
        daily_quests: {
            last_reset_time: 0,
            quest_list: []
        }
    };
    
    // Заполняем дефолтными героями (первые 4)
    for (var i = 0; i < 4; i++) {
        global.permanent_save.deck[i] = i;
    }
    
    // Добавляем тестовые данные для рейтинга
    add_test_rating_data();
    
    LOG("=== СОЗДАН DEFAULT PERMANENT SAVE ===");
}

// Загрузка из файла в permanent_save
// Возвращает true при успехе, false при ошибке/повреждённом файле
function load_permanent_save() {
    return load_permanent_save_from("save_game.sav");
}

function load_permanent_save_from(_filename) {
    var buffer = buffer_load(_filename);
    if (buffer == -1) {
        LOG("Файл сохранения '" + _filename + "' не найден или не открывается");
        return false;
    }

    var json = buffer_read(buffer, buffer_string);
    buffer_delete(buffer);

    // ===== ЗАЩИТА ОТ ПОВРЕЖДЁННОГО ФАЙЛА =====
    var save_data;
    try {
        save_data = json_parse(json);
    } catch (_err) {
        LOG("❌ Ошибка парсинга '" + _filename + "': " + string(_err));
        return false;
    }

    if (!is_struct(save_data)) {
        LOG("❌ Сохранение '" + _filename + "' имеет неверный формат");
        return false;
    }

    // ===== БАЗОВЫЕ ДАННЫЕ (с защитой от отсутствия полей) =====
    var genes = struct_exists(save_data, "genes") ? save_data.genes : 0;

    // Безопасное чтение колоды: если массив отсутствует или короче 4 — добиваем -1
    var deck = [-1, -1, -1, -1];
    if (struct_exists(save_data, "deck") && is_array(save_data.deck)) {
        var deck_src = save_data.deck;
        var deck_len = array_length(deck_src);
        for (var di = 0; di < 4; di++) {
            if (di < deck_len) deck[di] = deck_src[di];
        }
    }
    
    // Данные героев (с проверкой)
    var heroes_save = [];
    if (struct_exists(save_data, "heroes") && array_length(save_data.heroes) > 0) {
        heroes_save = save_data.heroes;
    }
    
    // Кристаллы (с проверкой)
    var crystals = 0;
    if (struct_exists(save_data, "crystals")) {
        crystals = save_data.crystals;
    }
    
    // ===== НИК ИГРОКА =====
    var player_name = "Игрок";
    if (struct_exists(save_data, "player_name")) {
        player_name = save_data.player_name;
        LOG("Загружен ник из файла: " + player_name);
    }
    
    // ===== СТАТИСТИКА ИГРОКА =====
    var player_stats = {
        best_time: 0,
        total_kills: 0,
        games_played: 0
    };
    if (struct_exists(save_data, "player_stats")) {
        player_stats = save_data.player_stats;
        LOG("Загружена статистика из файла:");
        LOG("  best_time: " + string(player_stats.best_time));
        LOG("  total_kills: " + string(player_stats.total_kills));
        LOG("  games_played: " + string(player_stats.games_played));
    }
    
    // ===== УДАЛЯЕМ ЗАГРУЗКУ floors_data =====
    // var floors_data = get_floors_data();
    // if (struct_exists(save_data, "floors_data")) {
    //     floors_data = save_data.floors_data;
    //     LOG("Загружены данные этажей из файла");
    // }
    // =======================================
    
    // ===== ДАННЫЕ МАГАЗИНА (новая схема на Unix-времени) =====
    var today = scr_get_day_number();
    var shop_cards_data = {
        cards: [],
        auto_refresh_at: 0,
        ad_charges: 3,
        ad_reset_day: today
    };
    if (struct_exists(save_data, "shop_cards_data")) {
        var loaded_shop = save_data.shop_cards_data;
        if (struct_exists(loaded_shop, "cards"))           shop_cards_data.cards = loaded_shop.cards;
        if (struct_exists(loaded_shop, "auto_refresh_at")) shop_cards_data.auto_refresh_at = loaded_shop.auto_refresh_at;
        if (struct_exists(loaded_shop, "ad_charges"))      shop_cards_data.ad_charges = loaded_shop.ad_charges;
        if (struct_exists(loaded_shop, "ad_reset_day"))    shop_cards_data.ad_reset_day = loaded_shop.ad_reset_day;
        LOG("Загружены shop_cards_data: auto_refresh_at=" + string(shop_cards_data.auto_refresh_at) +
                           ", ad_charges=" + string(shop_cards_data.ad_charges));
    }

    // ===== ДАННЫЕ СУНДУКОВ (новая схема) =====
    var chests_data = {
        bought: [false, false, false, false],
        auto_refresh_at: 0,
        ad_charges: 3,
        ad_reset_day: today
    };
    if (struct_exists(save_data, "chests_data")) {
        var loaded_chests = save_data.chests_data;
        if (struct_exists(loaded_chests, "bought"))          chests_data.bought = loaded_chests.bought;
        if (struct_exists(loaded_chests, "auto_refresh_at")) chests_data.auto_refresh_at = loaded_chests.auto_refresh_at;
        if (struct_exists(loaded_chests, "ad_charges"))      chests_data.ad_charges = loaded_chests.ad_charges;
        if (struct_exists(loaded_chests, "ad_reset_day"))    chests_data.ad_reset_day = loaded_chests.ad_reset_day;
        LOG("Загружены chests_data: auto_refresh_at=" + string(chests_data.auto_refresh_at) +
                           ", ad_charges=" + string(chests_data.ad_charges));
    }
    
    // ===== ДАННЫЕ НАГРАД =====
    var wave_rewards_data = {
        genes: 0,
        crystals: 0,
        chests: []
    };
    if (struct_exists(save_data, "wave_rewards_data")) {
        wave_rewards_data = save_data.wave_rewards_data;
        LOG("Загружены wave_rewards_data из сохранения:");
        LOG("  genes: " + string(wave_rewards_data.genes));
        LOG("  crystals: " + string(wave_rewards_data.crystals));
        LOG("  chests: " + string(array_length(wave_rewards_data.chests)));
    }
    
    // ===== ДАННЫЕ РЕЙТИНГА =====
    var rating_data = {
        players: [],
        last_update: 0
    };
    if (struct_exists(save_data, "rating_data")) {
        rating_data = save_data.rating_data;
        LOG("Загружены rating_data из сохранения:");
        LOG("  players: " + string(array_length(rating_data.players)));
    }
    
    // ===== ДАННЫЕ РУЛЕТКИ (новая схема) =====
    var spin_data = {
        free_spin_at: 0,
        ad_charges: 3,
        ad_reset_day: today
    };
    if (struct_exists(save_data, "spin_data")) {
        var loaded_spin = save_data.spin_data;
        if (struct_exists(loaded_spin, "free_spin_at")) spin_data.free_spin_at = loaded_spin.free_spin_at;
        if (struct_exists(loaded_spin, "ad_charges"))   spin_data.ad_charges = loaded_spin.ad_charges;
        if (struct_exists(loaded_spin, "ad_reset_day")) spin_data.ad_reset_day = loaded_spin.ad_reset_day;
        LOG("Загружены spin_data: free_spin_at=" + string(spin_data.free_spin_at) +
                           ", ad_charges=" + string(spin_data.ad_charges));
    }

    // ===== ЕЖЕДНЕВНЫЕ ЗАДАНИЯ (раньше терялись при загрузке) =====
    var daily_quests = {
        last_reset_time: 0,
        quest_list: []
    };
    if (struct_exists(save_data, "daily_quests")) {
        var loaded_dq = save_data.daily_quests;
        if (is_struct(loaded_dq)) {
            if (struct_exists(loaded_dq, "last_reset_time")) daily_quests.last_reset_time = loaded_dq.last_reset_time;
            if (struct_exists(loaded_dq, "quest_list") && is_array(loaded_dq.quest_list)) {
                daily_quests.quest_list = loaded_dq.quest_list;
            }
        }
        LOG("Загружены daily_quests: " + string(array_length(daily_quests.quest_list)) + " заданий");
    }

    // Собираем структуру (ad_data удалён — заряды теперь хранятся в spin_data/shop_cards_data/chests_data)
    global.permanent_save = {
        player_name: player_name,
        genes: genes,
        deck: deck,
        heroes: heroes_save,
        crystals: crystals,
        player_stats: player_stats,
        shop_cards_data: shop_cards_data,
        chests_data: chests_data,
        wave_rewards_data: wave_rewards_data,
        rating_data: rating_data,
        spin_data: spin_data,
        daily_quests: daily_quests
    };

    LOG("=== ЗАГРУЗКА СОХРАНЕНИЯ ЗАВЕРШЕНА ===");
    LOG("Источник: " + _filename);
    LOG("Загружено генов: " + string(genes));
    LOG("Загружено кристаллов: " + string(crystals));
    LOG("Загружен ник: " + string(player_name));
    return true;
}

// ===== ФУНКЦИЯ sync_session_from_permanent() =====
function sync_session_from_permanent() {
    LOG("=== СИНХРОНИЗАЦИЯ С PERMANENT ===");
    
    // Проверяем существование permanent_save
    if (!variable_global_exists("permanent_save")) {
        LOG("ОШИБКА: permanent_save не существует! Создаем...");
        create_default_permanent_save();
    }
    
    // Создаем current_session если его нет
    if (!variable_global_exists("current_session")) {
        global.current_session = {};
    }
    
    // ===== 1. БАЗОВЫЕ ДАННЫЕ =====
    global.current_session.genes = global.permanent_save.genes;
    global.current_session.deck = [
        global.permanent_save.deck[0],
        global.permanent_save.deck[1],
        global.permanent_save.deck[2],
        global.permanent_save.deck[3]
    ];
    
    LOG("Гены: " + string(global.current_session.genes));
    LOG("Отряд: " + 
                      string(global.current_session.deck[0]) + "," +
                      string(global.current_session.deck[1]) + "," +
                      string(global.current_session.deck[2]) + "," +
                      string(global.current_session.deck[3]));
    
    // ===== 2. ПРОГРЕСС ГЕРОЕВ =====
    if (struct_exists(global.permanent_save, "heroes") && array_length(global.permanent_save.heroes) > 0) {
        for (var i = 0; i < array_length(global.permanent_save.heroes); i++) {
            var saved_hero = global.permanent_save.heroes[i];
            if (i < array_length(global.heroes)) {
                global.heroes[i].unlocked = saved_hero.unlocked;
                global.heroes[i].level = saved_hero.level;
                global.heroes[i].cards_collected = saved_hero.cards_collected;
                
                if (!struct_exists(saved_hero, "shop_bought")) {
                    global.heroes[i].shop_bought = false;
                } else {
                    global.heroes[i].shop_bought = saved_hero.shop_bought;
                }
                
                if (!struct_exists(saved_hero, "shop_slot")) {
                    global.heroes[i].shop_slot = -1;
                } else {
                    global.heroes[i].shop_slot = saved_hero.shop_slot;
                }
            }
        }
        LOG("Прогресс героев загружен");
    } else {
        LOG("Нет сохраненного прогресса героев");
    }
    
    global.current_session.heroes = global.heroes;
    
    // ===== 3. КРИСТАЛЛЫ =====
    global.crystals = global.permanent_save.crystals;
    LOG("Кристаллы: " + string(global.crystals));
    
    // ===== 4. ЗАГРУЗКА НИКА =====
    if (struct_exists(global.permanent_save, "player_name")) {
        global.player_name = global.permanent_save.player_name;
        LOG("Загружен ник: " + global.player_name);
    } else {
        global.player_name = "Игрок";
        LOG("Ник не найден, установлен 'Игрок'");
    }
    
    // ===== 5. ЗАГРУЗКА СТАТИСТИКИ ИГРОКА =====
    if (!struct_exists(global.permanent_save, "player_stats")) {
        global.permanent_save.player_stats = {
            best_time: 0,
            total_kills: 0,
            games_played: 0
        };
        LOG("Создана новая статистика игрока");
    } else {
        LOG("Загружена статистика игрока:");
        LOG("  Лучшее время: " + string(global.permanent_save.player_stats.best_time));
        LOG("  Всего убийств: " + string(global.permanent_save.player_stats.total_kills));
        LOG("  Сыграно игр: " + string(global.permanent_save.player_stats.games_played));
    }
    
    
    // Шоп/сундуки/рулетка теперь живут прямо в global.permanent_save.{shop_cards_data, chests_data, spin_data}
    // и обновляются напрямую из obj_shop_controller. Отдельных global.shop_cards_data / chests_data / spin_cooldown_data / ad_data больше нет.

    // ===== 11. ЗАГРУЗКА НАГРАД =====
    if (!variable_global_exists("wave_rewards")) {
        global.wave_rewards = {
            genes: 0,
            crystals: 0,
            chests: []
        };
    }
    
    if (struct_exists(global.permanent_save, "wave_rewards_data")) {
        global.wave_rewards.genes = global.permanent_save.wave_rewards_data.genes;
        global.wave_rewards.crystals = global.permanent_save.wave_rewards_data.crystals;
        global.wave_rewards.chests = global.permanent_save.wave_rewards_data.chests;
        
        LOG("=== ЗАГРУЖЕНЫ НАГРАДЫ ===");
        LOG("  genes: " + string(global.wave_rewards.genes));
        LOG("  crystals: " + string(global.wave_rewards.crystals));
        LOG("  chests: " + string(array_length(global.wave_rewards.chests)));
    }
    
    // Для совместимости обновляем wave_rewards_data
    if (!variable_global_exists("wave_rewards_data")) {
        global.wave_rewards_data = {
            genes: 0,
            crystals: 0,
            chests: []
        };
    }
    global.wave_rewards_data.genes = global.wave_rewards.genes;
    global.wave_rewards_data.crystals = global.wave_rewards.crystals;
    global.wave_rewards_data.chests = global.wave_rewards.chests;
    
    // ===== 12. ЗАГРУЗКА РЕЙТИНГА =====
    if (!struct_exists(global.permanent_save, "rating_data")) {
        global.permanent_save.rating_data = {
            players: [],
            last_update: 0
        };
    }
    
    // ===== 13. СИНХРОНИЗИРУЕМ ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ =====
    global.genes = global.current_session.genes;
    global.player_deck = global.current_session.deck;
    
    LOG("=== СИНХРОНИЗАЦИЯ ЗАВЕРШЕНА ===");
    LOG("Итоговые гены: " + string(global.genes));
    LOG("Итоговые кристаллы: " + string(global.crystals));
    LOG("Итоговый ник: " + string(global.player_name));
}

// Сохранение session в permanent и в файл
function commit_session_to_permanent() {
    // Копируем session в permanent
    global.permanent_save.genes = global.current_session.genes;
    for (var i = 0; i < 4; i++) {
        global.permanent_save.deck[i] = global.current_session.deck[i];
    }
    
    // Сохраняем прогресс героев
    var heroes_save = [];
    for (var i = 0; i < array_length(global.heroes); i++) {
        var hero = global.heroes[i];
        var hero_save = {
            id: hero.id,
            unlocked: hero.unlocked,
            level: hero.level,
            cards_collected: hero.cards_collected,
            shop_bought: hero.shop_bought,
            shop_slot: hero.shop_slot
        };
        array_push(heroes_save, hero_save);
    }
    global.permanent_save.heroes = heroes_save;
    
    // Сохраняем кристаллы
    global.permanent_save.crystals = global.crystals;
    
    // Сохраняем ник
    if (variable_global_exists("player_name")) {
        global.permanent_save.player_name = global.player_name;
    }
    
    // Шоп / рулетка / сундуки теперь живут прямо в global.permanent_save.*
    // и обновляются on-the-fly из obj_shop_controller, поэтому здесь дополнительные
    // ручные присваивания не нужны.

    // Сохраняем в файл
    save_permanent_to_file();
}

// Синхронизирует runtime-переменные с permanent_save перед записью на диск.
// Шоп/рулетка/сундуки теперь работают напрямую с global.permanent_save.* —
// дублирующих global.spin_cooldown_data / global.ad_data больше нет.
// Здесь синхронизируем только глобальные «живые» переменные: гены, кристаллы, ник, награды волны.
function sync_runtime_to_permanent() {
    if (!variable_global_exists("permanent_save")) return;

    if (variable_global_exists("wave_rewards")) {
        if (!struct_exists(global.permanent_save, "wave_rewards_data")) {
            global.permanent_save.wave_rewards_data = { genes: 0, crystals: 0, chests: [] };
        }
        global.permanent_save.wave_rewards_data.genes = global.wave_rewards.genes;
        global.permanent_save.wave_rewards_data.crystals = global.wave_rewards.crystals;
        global.permanent_save.wave_rewards_data.chests = global.wave_rewards.chests;
    }
    if (variable_global_exists("crystals")) {
        global.permanent_save.crystals = global.crystals;
    }
    if (variable_global_exists("genes")) {
        global.permanent_save.genes = global.genes;
    }
    if (variable_global_exists("player_name")) {
        global.permanent_save.player_name = global.player_name;
    }
}

// Сохранение permanent в файл
function save_permanent_to_file() {
    if (!variable_global_exists("permanent_save")) {
        LOG("ОШИБКА: permanent_save не существует");
        return;
    }

    // Подтягиваем актуальные runtime-значения перед сериализацией
    sync_runtime_to_permanent();

    var save_data = {
        player_name: global.permanent_save.player_name,
        genes: global.permanent_save.genes,
        deck: global.permanent_save.deck,
        heroes: global.permanent_save.heroes,
        crystals: global.permanent_save.crystals,
        player_stats: global.permanent_save.player_stats,
        shop_cards_data: global.permanent_save.shop_cards_data,
        chests_data: global.permanent_save.chests_data,
        wave_rewards_data: global.permanent_save.wave_rewards_data,
        rating_data: global.permanent_save.rating_data,
        spin_data: global.permanent_save.spin_data,
        daily_quests: global.permanent_save.daily_quests
    };
    
    LOG("=== СОХРАНЕНИЕ В ФАЙЛ ===");
    LOG("player_name: " + string(save_data.player_name));
    LOG("player_stats.best_time: " + string(save_data.player_stats.best_time));

    // ===== АТОМАРНАЯ ЗАПИСЬ С РЕЗЕРВНОЙ КОПИЕЙ =====
    // Шаг 1: пишем в .tmp (если процесс упадёт здесь — основной файл цел)
    // Шаг 2: текущий .sav переименовываем в .bak (если упадём здесь — .bak цел)
    // Шаг 3: .tmp переименовываем в .sav (атомарная замена)
    // На любом шаге у нас всегда есть как минимум один валидный файл.
    var json;
    try {
        json = json_stringify(save_data);
    } catch (_err) {
        LOG("❌ Ошибка сериализации сохранения: " + string(_err));
        return;
    }

    var buffer = buffer_create(string_byte_length(json) + 1, buffer_fixed, 1);
    buffer_write(buffer, buffer_string, json);

    // Шаг 1: пишем во временный файл
    var tmp_name = "save_game.sav.tmp";
    if (file_exists(tmp_name)) file_delete(tmp_name);
    buffer_save(buffer, tmp_name);
    buffer_delete(buffer);

    if (!file_exists(tmp_name)) {
        LOG("❌ Не удалось записать временный файл сохранения");
        return;
    }

    // Шаг 2: если основной файл есть — двигаем его в резервную копию
    if (file_exists("save_game.sav")) {
        if (file_exists("save_game.sav.bak")) file_delete("save_game.sav.bak");
        file_rename("save_game.sav", "save_game.sav.bak");
    }

    // Шаг 3: временный файл → основной
    file_rename(tmp_name, "save_game.sav");

    LOG("✅ Файл сохранения обновлён (атомарно, с резервной копией)");
}

function add_test_rating_data() {
    if (!variable_global_exists("permanent_save")) {
        create_default_permanent_save();
    }
    
    if (!struct_exists(global.permanent_save, "rating_data")) {
        global.permanent_save.rating_data = {
            players: [],
            last_update: 0
        };
    }
    
    var test_names = [
        "ИгрокMaster", "ВоинСвета", "ТемныйЛорд", "Эльфийка", "Гном",
        "МагОгня", "Лучник", "Целитель", "Танк", "Берсерк",
        "НубСик", "Профи", "Легенда", "Чемпион", "Победитель",
        "Стрелок", "МагЛьда", "Жрец", "Паладин", "Архимаг",
        "Друид", "Снайпер", "МечникТеней", "Рыцарь", "Разбойник",
        "Бродяга", "ЛеснойМаг", "Эльф", "Орк", "Гоблин",
        "Тролль", "Дварф", "Некромант", "Вампир", "Оборотень",
        "Ангел", "Демон", "Феникс", "Дракон", "Единорог"
    ];
    
    var players_array = [];
    
    // Генерируем 100 записей
    for (var i = 0; i < 100; i++) {
        // Время уменьшается от 600 секунд (10 минут) до 30 секунд
        var time = 600 - (i * 5.7);
        if (time < 30) time = 30;
        time = floor(time);
        
        // Имя с номером
        var name_index = i % array_length(test_names);
        var name = test_names[name_index] + string(i + 1);
        
        array_push(players_array, {
            name: name,
            time: time
        });
    }
    
    global.permanent_save.rating_data.players = players_array;
    sort_rating();
    save_permanent_to_file();
    
    LOG("=== ДОБАВЛЕНЫ ТЕСТОВЫЕ ДАННЫЕ РЕЙТИНГА (100 ЗАПИСЕЙ) ===");
}

function sort_rating() {
    if (!variable_global_exists("permanent_save")) return;
    
    var players = global.permanent_save.rating_data.players;
    var len = array_length(players);
    
    for (var i = 0; i < len - 1; i++) {
        for (var j = i + 1; j < len; j++) {
            if (players[i].time < players[j].time) {
                var temp = players[i];
                players[i] = players[j];
                players[j] = temp;
            }
        }
    }
}
/// @desc Менеджер героев - хранит все данные и прогресс

// Глобальные переменные
global.heroes = []; // Массив всех героев
global.player_deck = [-1, -1, -1, -1]; // ID героев в отряде (4 слота)
global.genes = 0; // Гены игрока
global.crystals = 0; // Кристаллы игрока

// ===== КОНСТАНТЫ ТИПОВ ГЕРОЕВ =====
global.CLASS_MELEE = "melee";
global.CLASS_RANGED = "ranged";
global.CLASS_MAGE = "mage";
global.CLASS_SUPPORT = "support";

// ===== ЦЕЛЕВЫЕ ПОЗИЦИИ ПО ТИПАМ =====
global.TARGET_POSITIONS = {
    melee: { x: 400, y: 600 },
    ranged: { x: 300, y: 600 },
    mage: { x: 100, y: 600 },
    support: { x: 200, y: 600 }
};

// Максимальное количество героев каждого типа в отряде
global.MAX_PER_CLASS = {
    melee: 1,
    ranged: 1,
    mage: 2,
    support: 2
};

/// @function init_hero_manager()
/// @desc Инициализирует систему героев
function init_hero_manager() {
    // Создаем базовых героев
    create_default_heroes();
    
    // Проверяем, есть ли сохранение
    if (file_exists("save_game.sav")) {
        // Загружаем сохраненный прогресс
        load_game_data();
        LOG("Загружено сохранение. Гены: " + string(global.genes));
    } else {
        // Первый запуск игры - все по умолчанию
        LOG("Первый запуск игры. Гены: 0");
        global.genes = 0;
        
        // Заполняем отряд первыми четырьмя героями
        global.player_deck = [0, 1, 2, 3]; // Новобранец, Новобранец-лучник, Маг огня, Послушник
        
        // Сразу сохраняем
        save_game_data();
    }
}

/// @function create_default_heroes()
/// @desc Создает стандартных героев (20 героев: 8 обычных, 6 редких, 4 эпических, 2 легендарных)
function create_default_heroes() {
    global.heroes = [];
    var hero_id = 0;
    
    // ===== 1. ОБЫЧНЫЕ ГЕРОИ (8 штук) - rarity = 0 =====
    var ordinary_names = [
        "Новобранец",           // ID 0 - warrior
        "Новобранец-лучник",    // ID 1 - archer
        "Маг огня",             // ID 2 - mage
        "Послушник",            // ID 3 - healer
        "Новобранец с щитом",   // ID 4 - tank
        "Разбойник",            // ID 5 - rogue
        "Бродяга с рогаткой",   // ID 6 - slinger
        "Лесной маг"            // ID 7 - forest_mage
    ];
    
    var ordinary_types = [
        "warrior",      // Новобранец
        "archer",       // Новобранец-лучник
        "mage",         // Маг огня
        "healer",       // Послушник
        "tank",         // Новобранец с щитом
        "rogue",        // Разбойник
        "slinger",      // Бродяга с рогаткой
        "forest_mage"   // Лесной маг
    ];
    
    var ordinary_classes = [
        global.CLASS_MELEE,      // Новобранец
        global.CLASS_RANGED,     // Новобранец-лучник
        global.CLASS_MAGE,       // Маг огня
        global.CLASS_SUPPORT,    // Послушник
        global.CLASS_MELEE,      // Новобранец с щитом
        global.CLASS_MELEE,      // Разбойник
        global.CLASS_RANGED,     // Бродяга с рогаткой
        global.CLASS_MAGE        // Лесной маг
    ];
    
    for (var i = 0; i < 8; i++) {
        var hero = create_hero_data_struct();
        hero.id = hero_id++;
        hero.name = ordinary_names[i];
        hero.class_type = ordinary_classes[i];
        hero.original_type = ordinary_types[i];
        hero.rarity = 0; // Обычный
        
        // Настройки для существующих героев
        switch (i) {
            case 0: // Новобранец
                hero.base_hp = 100;
                hero.base_damage = 10;
                hero.unlocked = true;
                hero.cards_collected = 1;
                hero.sprite_small = spr_warrior;
                hero.sprite_large = spr_warrior;
                break;
            case 1: // Новобранец-лучник
                hero.base_hp = 70;
                hero.base_damage = 15;
                hero.unlocked = true;
                hero.cards_collected = 1;
                hero.sprite_small = obj_archer;
                hero.sprite_large = obj_archer;
                break;
            case 2: // Маг огня
                hero.base_hp = 50;
                hero.base_damage = 15;
                hero.unlocked = true;
                hero.cards_collected = 1;
                hero.sprite_small = spr_mage;
                hero.sprite_large = spr_mage;
                break;
            case 3: // Послушник
                hero.base_hp = 60;
                hero.base_damage = 0;
                hero.base_healing = 1;
                hero.unlocked = true;
                hero.cards_collected = 1;
                hero.sprite_small = spr_healer;
                hero.sprite_large = spr_healer;
                break;
            case 4: // Новобранец с щитом
                hero.base_hp = 100;
                hero.base_damage = 0;
                hero.unlocked = false;
                hero.cards_collected = 0;
                hero.sprite_small = spr_tank;
                hero.sprite_large = spr_tank;
                break;
            case 5: // Разбойник
                hero.base_hp = 70;
                hero.base_damage = 12;
                hero.unlocked = false;
                hero.cards_collected = 0;
                hero.sprite_small = spr_rogue;
                hero.sprite_large = spr_rogue;
                hero.color_frame = make_color_rgb(150, 100, 150);
                break;
            case 6: // Бродяга с рогаткой
                hero.base_hp = 60;
                hero.base_damage = 14;
                hero.unlocked = false;
                hero.cards_collected = 0;
                hero.sprite_small = spr_slinger;
                hero.sprite_large = spr_slinger;
                hero.color_frame = make_color_rgb(100, 150, 100);
                break;
            case 7: // Лесной маг
                hero.base_hp = 55;
                hero.base_damage = 13;
                hero.unlocked = false;
                hero.cards_collected = 0;
                hero.sprite_small = spr_forest_mage;
                hero.sprite_large = spr_forest_mage;
                hero.color_frame = make_color_rgb(80, 150, 80);
                break;
        }
        
        if (i >= 4) {
            hero.color_frame = make_color_rgb(180, 180, 180); // Серый для обычных
        }
        array_push(global.heroes, hero);
    }
    
    // ===== 2. РЕДКИЕ ГЕРОИ (6 штук) - rarity = 1 =====
    var rare_names = [
        "Рыцарь",           // ID 8 - knight
        "Стрелок",          // ID 9 - crossbowman
        "Маг льда",         // ID 10 - ice_mage
        "Жрец",             // ID 11 - priest
        "Берсерк",          // ID 12 - berserker
        "Эльфийский лучник" // ID 13 - elf_archer
    ];
    
    var rare_types = [
        "knight",       // рыцарь
        "crossbowman",  // арбалетчик
        "ice_mage",     // маг льда
        "priest",       // жрец
        "berserker",    // берсерк
        "elf_archer"    // эльфийский лучник
    ];
    
    var rare_classes = [
        global.CLASS_MELEE,   // Рыцарь
        global.CLASS_RANGED,  // Стрелок
        global.CLASS_MAGE,    // Маг льда
        global.CLASS_SUPPORT, // Жрец
        global.CLASS_MELEE,   // Берсерк
        global.CLASS_RANGED   // Эльфийский лучник
    ];
    
    for (var i = 0; i < 6; i++) {
        var hero = create_hero_data_struct();
        hero.id = hero_id++;
        hero.name = rare_names[i];
        hero.class_type = rare_classes[i];
        hero.original_type = rare_types[i];
        hero.rarity = 1; // Редкий
        
        hero.base_hp = 80;
        hero.base_damage = 12;
        hero.unlocked = false;
        hero.cards_collected = 0;
        
        // Визуал
        switch (i) {
            case 0: // Рыцарь
                hero.sprite_small = spr_knight;
                hero.sprite_large = spr_knight;
                hero.color_frame = make_color_rgb(100, 100, 255);
                break;
            case 1: // Стрелок
                hero.sprite_small = spr_crossbowman;
                hero.sprite_large = spr_crossbowman;
                hero.color_frame = make_color_rgb(100, 150, 100);
                break;
            case 2: // Маг льда
                hero.sprite_small = spr_ice_mage;
                hero.sprite_large = spr_ice_mage;
                hero.color_frame = make_color_rgb(100, 200, 255);
                break;
            case 3: // Жрец
                hero.sprite_small = spr_priest;
                hero.sprite_large = spr_priest;
                hero.color_frame = make_color_rgb(255, 215, 0);
                break;
            case 4: // Берсерк
                hero.sprite_small = spr_berserker;
                hero.sprite_large = spr_berserker;
                hero.color_frame = make_color_rgb(255, 100, 100);
                break;
            case 5: // Эльфийский лучник
                hero.sprite_small = spr_elf_archer;
                hero.sprite_large = spr_elf_archer;
                hero.color_frame = make_color_rgb(100, 200, 100);
                break;
        }
        
        array_push(global.heroes, hero);
    }
    
   // ===== 3. ЭПИЧЕСКИЕ ГЕРОИ (4 штуки) - rarity = 2 =====
    var epic_names = [
        "Мечник теней",    // ID 14 - shadow_blade (ближник)
        "Снайпер",         // ID 15 - sniper (дальник)
        "Маг молний",      // ID 16 - lightning_mage (маг)
        "Друид"            // ID 17 - druid (помощник)
    ];
    
    var epic_types = [
        "shadow_blade",
        "sniper",
        "lightning_mage",
        "druid"
    ];
    
    var epic_classes = [
        global.CLASS_MELEE,
        global.CLASS_RANGED,
        global.CLASS_MAGE,
        global.CLASS_SUPPORT
    ];
    
    // Спрайты для эпических героев
    var epic_sprites = [
        spr_shadow_blade,    // Мечник теней
        spr_sniper,          // Снайпер
        spr_lightning_mage,  // Маг молний
        spr_druid            // Друид
    ];
    
    for (var i = 0; i < 4; i++) {
        var hero = create_hero_data_struct();
        hero.id = hero_id++;
        hero.name = epic_names[i];
        hero.class_type = epic_classes[i];
        hero.original_type = epic_types[i];
        hero.rarity = 2; // Эпический
        
        // Базовые характеристики (выше среднего)
        hero.base_hp = 85;
        hero.base_damage = 18;
        hero.unlocked = false;
        hero.cards_collected = 0;
        
        // Визуал
        hero.sprite_small = epic_sprites[i];
        hero.sprite_large = epic_sprites[i];
        hero.color_frame = make_color_rgb(180, 80, 255); // Фиолетовый для эпических
        
        array_push(global.heroes, hero);
    }
    
        // ===== 4. ЛЕГЕНДАРНЫЕ ГЕРОИ (2 штуки) - rarity = 3 =====
    var legendary_names = [
        "Паладин",    // ID 18 - paladin (ближник)
        "Архимаг"     // ID 19 - archmage (маг)
    ];
    
    var legendary_types = [
        "paladin",
        "archmage"
    ];
    
    var legendary_classes = [
        global.CLASS_MELEE,
        global.CLASS_MAGE
    ];
    
    // Спрайты для легендарных героев
    var legendary_sprites = [
        spr_paladin,   // Паладин
        spr_archmage   // Архимаг
    ];
    
    for (var i = 0; i < 2; i++) {
        var hero = create_hero_data_struct();
        hero.id = hero_id++;
        hero.name = legendary_names[i];
        hero.class_type = legendary_classes[i];
        hero.original_type = legendary_types[i];
        hero.rarity = 3; // Легендарный
        
        // Базовые характеристики (высокие)
        hero.base_hp = 120;
        hero.base_damage = 25;
        hero.unlocked = false;
        hero.cards_collected = 0;
        
        // Визуал
        hero.sprite_small = legendary_sprites[i];
        hero.sprite_large = legendary_sprites[i];
        hero.color_frame = make_color_rgb(255, 180, 50); // Оранжевый для легендарных
        
        array_push(global.heroes, hero);
    }
    
    // ===== ПРОВЕРКА СПРАЙТОВ ПОСЛЕ СОЗДАНИЯ =====
    LOG("=== ПРОВЕРКА СПРАЙТОВ ПОСЛЕ СОЗДАНИЯ ===");
    for (var i = 0; i < array_length(global.heroes); i++) {
        var hero = global.heroes[i];
        LOG("Герой " + string(i) + ": " + hero.name + 
                          ", sprite_small=" + string(hero.sprite_small) + 
                          ", sprite_exists=" + string(sprite_exists(hero.sprite_small)));
    }
    
    LOG("=== ГЕРОИ СОЗДАНЫ ===");
    LOG("Всего героев: " + string(array_length(global.heroes)));
}

/// @function create_hero_data_struct()
/// @desc Создает структуру данных для героя (переименовано чтобы не конфликтовать)
function create_hero_data_struct() {
    return {
        // Базовые данные
        id: 0,
        name: "",
        class_type: "",
        original_type: "",
        rarity: 0,
        
        shop_bought: false,  // Куплена ли карта в магазине
        shop_slot: -1,       // В каком слоте магазина была куплена
        
        // Характеристики (базовые для уровня 1)
        base_hp: 80,
        base_damage: 10,
        base_healing: 0,
        base_attack_speed: 0.5,
        base_move_speed: 3,
        
        // Прогресс игрока
        unlocked: false,
        level: 1,
        cards_collected: 0,
        cards_for_next_level: [5, 10, 15, 20, 25, 30, 35, 40, 45, 50],
        
        // Цены улучшения в генах для каждого уровня
        upgrade_cost_genes: [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000],
        
        // Визуальные данные
        sprite_small: noone,
        sprite_large: noone,
        color_frame: c_gray,
        
        // Методы
        get_required_cards: function() {
            if (self.level >= 10) return 0;
            return self.cards_for_next_level[self.level - 1];
        },
        
        get_upgrade_cost: function() {
            if (self.level >= 10) return 0;
            return self.upgrade_cost_genes[self.level - 1];
        },
        
        can_upgrade: function() {
            return self.unlocked && 
                   self.level < 10 && 
                   self.cards_collected >= self.get_required_cards();
        },
        
        get_current_hp: function() {
            return floor(self.base_hp * (1 + (self.level - 1) * 0.2));
        },
        
        get_current_damage: function() {
            return floor(self.base_damage * (1 + (self.level - 1) * 0.2));
        },
        
        get_current_healing: function() {
            return floor(self.base_healing * (1 + (self.level - 1) * 0.2));
        }
    };
}

/// @function get_hero_by_id(_id)
/// @desc Возвращает героя по ID
function get_hero_by_id(_id) {
    if (_id < 0 || _id >= array_length(global.heroes)) return noone;
    return global.heroes[_id];
}

/// @function get_class_count_in_deck(_class_type)
/// @desc Возвращает количество героев данного класса в отряде
function get_class_count_in_deck(_class_type) {
    var count = 0;
    for (var i = 0; i < 4; i++) {
        var deck_hero_id = global.player_deck[i];
        if (deck_hero_id >= 0 && deck_hero_id < array_length(global.heroes)) {
            if (global.heroes[deck_hero_id].class_type == _class_type) {
                count++;
            }
        }
    }
    return count;
}

/// @function can_add_hero_to_deck(_hero_id)
/// @desc Проверяет, можно ли добавить героя в отряд
function can_add_hero_to_deck(_hero_id) {
    if (_hero_id < 0 || _hero_id >= array_length(global.heroes)) return false;
    
    var hero = global.heroes[_hero_id];
    var hero_class = hero.class_type;
    
    // Проверяем, нет ли уже такого же героя (по ID)
    for (var i = 0; i < 4; i++) {
        if (global.player_deck[i] == _hero_id) {
            return false;
        }
    }
    
    // Проверяем лимит класса
    var current_count = get_class_count_in_deck(hero_class);
    var max_allowed = global.MAX_PER_CLASS[$ hero_class];
    if (max_allowed == undefined) max_allowed = 1;
    
    return (current_count < max_allowed);
}

/// @function add_hero_to_deck(_hero_id, _slot)
/// @desc Кладёт героя в указанный слот с учётом ЗАМЕНЫ существующего.
///       Лимит класса считается по ДРУГИМ слотам — герой в целевом слоте игнорируется,
///       потому что мы его заменяем. Так работает корректная замена warrior→tank и т.п.
function add_hero_to_deck(_hero_id, _slot) {
    if (_slot < 0 || _slot >= 4) return false;
    if (_hero_id >= 0 && !global.heroes[_hero_id].unlocked) return false;

    // Запрет на дубликата того же героя в другом слоте
    for (var i = 0; i < 4; i++) {
        if (i != _slot && global.player_deck[i] == _hero_id) {
            LOG("Этот герой уже в другом слоте отряда");
            return false;
        }
    }

    // Лимит класса — считаем по другим слотам (целевой исключаем — он будет перезаписан)
    var hero = global.heroes[_hero_id];
    var hero_class = hero.class_type;
    var future_count = 0;
    for (var i = 0; i < 4; i++) {
        if (i == _slot) continue;
        var oid = global.player_deck[i];
        if (oid >= 0 && global.heroes[oid].class_type == hero_class) {
            future_count++;
        }
    }
    var max_allowed = global.MAX_PER_CLASS[$ hero_class];
    if (max_allowed == undefined) max_allowed = 1;

    if (future_count >= max_allowed) {
        LOG("Нельзя положить героя класса " + hero_class + " — лимит уже занят другими слотами");
        return false;
    }

    global.current_session.deck[_slot] = _hero_id;
    global.player_deck[_slot] = _hero_id;

    LOG("=== ОТРЯД ИЗМЕНЕН (SESSION) ===");
    LOG("В слот " + string(_slot) + " положен герой ID=" + string(_hero_id) +
        " (" + hero.name + ", класс " + hero_class + ")");

    commit_session_to_permanent();
    return true;
}

/// @function remove_hero_from_deck(_slot)
/// @desc Убирает героя из отряда
function remove_hero_from_deck(_slot) {
    if (_slot < 0 || _slot >= 4) return false;
    
    global.current_session.deck[_slot] = -1;
    global.player_deck[_slot] = -1;
    
    LOG("=== ОТРЯД ИЗМЕНЕН (SESSION) ===");
    LOG("Удален герой из слота " + string(_slot));
    
    commit_session_to_permanent();
    return true;
}

/// @function upgrade_hero(_hero_id)
/// @desc Улучшает героя на 1 уровень
function upgrade_hero(_hero_id) {
    if (_hero_id < 0 || _hero_id >= array_length(global.heroes)) return false;
    
    var hero = global.heroes[_hero_id];
    
    if (!hero.can_upgrade()) return false;
    if (global.genes < hero.get_upgrade_cost()) return false;
    
    hero.cards_collected -= hero.get_required_cards();
    global.genes -= hero.get_upgrade_cost();
    hero.level++;
    
    update_tree_unlocked_levels_for_hero(_hero_id);
    
    LOG("=== УЛУЧШЕНИЕ ГЕРОЯ ===");
    LOG("Герой: " + hero.name + " теперь уровень " + string(hero.level));
    LOG("Потрачено генов: " + string(hero.get_upgrade_cost()));
    LOG("Осталось генов: " + string(global.genes));
    
    if (variable_global_exists("current_session")) {
        global.current_session.genes = global.genes;
        global.current_session.heroes = global.heroes;
    }
    
    commit_session_to_permanent();
    return true;
}

/// @function add_hero_card(_hero_id, _amount)
/// @desc Добавляет карты героя, разблокирует если нужно
function add_hero_card(_hero_id, _amount) {
    if (_hero_id < 0 || _hero_id >= array_length(global.heroes)) return false;
    
    var hero = global.heroes[_hero_id];
    var was_locked = !hero.unlocked;
    
    hero.cards_collected += _amount;
    
    if (was_locked && hero.cards_collected > 0) {
        hero.unlocked = true;
        LOG("=== ГЕРОЙ РАЗБЛОКИРОВАН! ===");
        LOG("Герой " + hero.name + " теперь доступен в колоде!");
    }
    
    if (variable_global_exists("current_session")) {
        global.current_session.heroes = global.heroes;
    }
    
    commit_session_to_permanent();
    
    LOG("Добавлено " + string(_amount) + " карт героя " + hero.name);
    LOG("Теперь карт: " + string(hero.cards_collected) + 
                      ", Разблокирован: " + string(hero.unlocked));
    
    return true;
}

/// @function is_deck_full()
/// @desc Проверяет, заполнен ли отряд полностью
function is_deck_full() {
    for (var i = 0; i < 4; i++) {
        if (global.player_deck[i] < 0) {
            return false;
        }
    }
    return true;
}

/// @function commit_changes()
/// @desc Сохраняет изменения session в permanent
function commit_changes() {
    commit_session_to_permanent();
}

/// @function discard_changes()
/// @desc Отменяет изменения session
function discard_changes() {
    LOG("=== ОТМЕНА ИЗМЕНЕНИЙ СЕССИИ ===");
    sync_session_from_permanent();
    global.genes = global.current_session.genes;
    global.player_deck = global.current_session.deck;
}

/// @function update_tree_unlocked_levels_for_hero(_hero_id)
/// @desc Обновляет unlocked_levels в дереве прокачки для героя
function update_tree_unlocked_levels_for_hero(_hero_id) {
    var controller = instance_find(obj_game_controller, 0);
    if (!instance_exists(controller)) return;
    
    var hero_data = global.heroes[_hero_id];
    var hero_card_level = hero_data.level;
    
    for (var i = 0; i < 4; i++) {
        var tree = controller.hero_trees[i];
        if (tree != noone && tree.hero_id == _hero_id) {
            LOG("=== ОБНОВЛЕНИЕ ДЕРЕВА ДЛЯ ГЕРОЯ ===");
            LOG("Герой: " + hero_data.name + ", уровень карточки: " + string(hero_card_level));
            LOG("Текущий unlocked_levels дерева: " + string(tree.unlocked_levels));
            break;
        }
    }
}
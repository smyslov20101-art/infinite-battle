/// @function save_game_data()
/// @desc Сохраняет прогресс игрока (гемы, отряд, уровни героев)
function save_game_data() {
    // Сохраняем гемы
    global.genes = global.genes; // Убеждаемся что значение актуально
    
    // Создаем структуру для сохранения
    var save_data = {
        genes: global.genes,
        deck: global.player_deck,
        heroes: []
    };
    
    // Сохраняем прогресс каждого героя
    for (var i = 0; i < array_length(global.heroes); i++) {
        var hero = global.heroes[i];
        var hero_save = {
            id: hero.id,
            unlocked: hero.unlocked,
            level: hero.level,
            cards_collected: hero.cards_collected
        };
        array_push(save_data.heroes, hero_save);
    }
    
    // Сохраняем в JSON файл
    var json = json_stringify(save_data);
    var buffer = buffer_create(string_byte_length(json) + 1, buffer_fixed, 1);
    buffer_write(buffer, buffer_string, json);
    buffer_save(buffer, "save_game.sav");
    buffer_delete(buffer);
    
    LOG("Игра сохранена! Гемы: " + string(global.genes));
}

/// @function load_game_data()
/// @desc Загружает прогресс игрока
function load_game_data() {
    // Проверяем существует ли файл
    if (!file_exists("save_game.sav")) {
        LOG("Нет сохранения, создаем новое");
        return false;
    }
    
    // Загружаем из файла
    var buffer = buffer_load("save_game.sav");
    if (buffer == -1) return false;
    
    var json = buffer_read(buffer, buffer_string);
    buffer_delete(buffer);
    
    var save_data = json_parse(json);
    
    // Загружаем гемы
    if (struct_exists(save_data, "genes")) {
        global.genes = save_data.genes;
    }
    
    // Загружаем отряд
    if (struct_exists(save_data, "deck")) {
        global.player_deck = save_data.deck;
    }
    
    // Загружаем прогресс героев
    if (struct_exists(save_data, "heroes") && array_length(save_data.heroes) > 0) {
        for (var i = 0; i < array_length(save_data.heroes); i++) {
            var hero_save = save_data.heroes[i];
            var hero_id = hero_save.id;
            
            if (hero_id >= 0 && hero_id < array_length(global.heroes)) {
                var hero = global.heroes[hero_id];
                hero.unlocked = hero_save.unlocked;
                hero.level = hero_save.level;
                hero.cards_collected = hero_save.cards_collected;
            }
        }
    }
    
    LOG("Игра загружена! Гемы: " + string(global.genes));
    return true;
}

/// @function add_genes(_amount)
/// @desc Добавляет гемы и сразу сохраняет
function add_genes(_amount) {
    global.genes += _amount;
    save_game_data();
    LOG("Добавлено гемов: " + string(_amount) + ". Всего: " + string(global.genes));
}
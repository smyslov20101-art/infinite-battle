/// @function scr_reset_game()
/// @desc Полностью сбрасывает игру (удаляет сохранение и сбрасывает все данные)

function scr_reset_game() {
    LOG("=== ПОЛНЫЙ СБРОС ИГРЫ ===");
    
    // Удаляем файл сохранения
    if (file_exists("save_game.sav")) {
        file_delete("save_game.sav");
        LOG("Файл сохранения удален");
    }
    
    // Сбрасываем глобальные переменные
    global.genes = 0;
    global.crystals = 0;
    global.player_deck = [0, 1, 2, 3]; // Возвращаем стартовый отряд
    
    // Сбрасываем прогресс героев
    for (var i = 0; i < array_length(global.heroes); i++) {
        var hero = global.heroes[i];
        
        // Первые 4 героя разблокированы, остальные нет
        if (i < 4) {
            hero.unlocked = true;
            hero.level = 1;
            hero.cards_collected = 1;
        } else {
            hero.unlocked = false;
            hero.level = 1;
            hero.cards_collected = 0;
        }
    }
    
    // Сброс шопа/рулетки/сундуков теперь обрабатывается create_default_permanent_save()
    // (вызывается ниже) — отдельные старые globals больше не существуют.

    // Сбрасываем награды
    if (variable_global_exists("wave_rewards")) {
        global.wave_rewards = {
            genes: 0,
            crystals: 0,
            chests: []
        };
    }
    
    // Сбрасываем current_session
    if (variable_global_exists("current_session")) {
        global.current_session.genes = 0;
        global.current_session.deck = [0, 1, 2, 3];
        global.current_session.heroes = global.heroes;
    }
    
    // Сбрасываем permanent_save
    if (variable_global_exists("permanent_save")) {
        create_default_permanent_save();
    }
    
    LOG("=== ИГРА ПОЛНОСТЬЮ СБРОШЕНА ===");
    LOG("Теперь перезайдите в игру для применения изменений");
}
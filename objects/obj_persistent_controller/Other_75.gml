/// Async System Event - obj_persistent_controller

// Проверяем, что событие - закрытие игры
if (async_load[? "event_type"] == "game_end") {
    LOG("=== GAME END EVENT - СОХРАНЯЕМ ВСЕ ДАННЫЕ ===");
    
    // Сохраняем награды
    if (variable_global_exists("wave_rewards_data")) {
        global.permanent_save.wave_rewards_data = global.wave_rewards_data;
        LOG("  Сохранены wave_rewards_data: chests=" + 
                          string(array_length(global.wave_rewards_data.chests)));
    }
    
    // Сохраняем сундуки если магазин существует
    if (instance_exists(obj_shop_controller)) {
        with (obj_shop_controller) {
            save_chests_data();
        }
    }
    
    // Сохраняем все данные
    if (variable_global_exists("permanent_save")) {
        save_permanent_to_file();
    }
}
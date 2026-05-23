/// Step Event - obj_persistent_controller

// Обработка таймера блокировки кликов
if (global.click_blocked) {
    global.click_block_timer -= 1 / room_speed;
    if (global.click_block_timer <= 0) {
        global.click_blocked = false;
    }
}

// Проверяем, не закрывается ли игра
if (game_ending) {
    LOG("=== ИГРА ЗАКРЫВАЕТСЯ - СОХРАНЯЕМ ===");
    
    if (instance_exists(obj_shop_controller)) {
        with (obj_shop_controller) {
            save_chests_data();
        }
    }
    
    if (variable_global_exists("wave_rewards_data")) {
        global.permanent_save.wave_rewards_data = global.wave_rewards_data;
        save_permanent_to_file();
    }
    
    if (variable_global_exists("permanent_save")) {
        save_permanent_to_file();
    }
}
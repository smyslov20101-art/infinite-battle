/// Game End Event - obj_persistent_controller
LOG("=== GAME END EVENT - ПОСТОЯННЫЙ КОНТРОЛЛЕР ===");

// Сохраняем сундуки если магазин существует
if (instance_exists(obj_shop_controller)) {
    with (obj_shop_controller) {
        save_chests_data();
    }
}

 // Сохраняем награды
    if (variable_global_exists("wave_rewards_data")) {
        global.permanent_save.wave_rewards_data = global.wave_rewards_data;
        save_permanent_to_file();
    }

// Сохраняем все данные
if (variable_global_exists("permanent_save")) {
    save_permanent_to_file();
}
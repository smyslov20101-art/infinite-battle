/// Game End Event - obj_data_loader
LOG("=== ИГРА ЗАВЕРШАЕТСЯ - СОХРАНЯЕМ ДАННЫЕ ===");

// Сохраняем награды через объект кнопки
if (instance_exists(obj_rewards_button)) {
    with (obj_rewards_button) {
        LOG("Сохраняем награды перед выходом");
        save_wave_rewards();
    }
}

// Если кнопки нет, но есть wave_rewards - сохраняем напрямую
if (variable_global_exists("wave_rewards") && variable_global_exists("permanent_save")) {
    global.permanent_save.wave_rewards_data = {
        genes: global.wave_rewards.genes,
        crystals: global.wave_rewards.crystals,
        chests: global.wave_rewards.chests
    };
    LOG("Сохранены награды напрямую: " + 
                      string(array_length(global.wave_rewards.chests)) + " сундуков");
}

// Принудительно сохраняем карты магазина
if (instance_exists(obj_shop_controller)) {
    with (obj_shop_controller) {
        LOG("Сохраняем карты магазина перед выходом");
        save_shop_cards();
        
        // Сохраняем состояние сундуков
        LOG("Сохраняем сундуки перед выходом");
        save_chests_data();
    }
}

// Коммитим текущую сессию в permanent
if (variable_global_exists("current_session")) {
    LOG("Текущая сессия: гены=" + string(global.current_session.genes));
    LOG("Текущая сессия: кристаллы=" + string(global.crystals));
    LOG("Отряд: " + 
                      string(global.current_session.deck[0]) + "," +
                      string(global.current_session.deck[1]) + "," +
                      string(global.current_session.deck[2]) + "," +
                      string(global.current_session.deck[3]));
    
    // Сохраняем в permanent
    commit_session_to_permanent();
} else {
    LOG("current_session не существует, создаем permanent из глобальных");
    
    // Если по какой-то причине нет current_session, сохраняем из глобальных
    if (!variable_global_exists("permanent_save")) {
        create_default_permanent_save();
    }
    
    global.permanent_save.genes = global.genes;
    global.permanent_save.crystals = global.crystals;
    for (var i = 0; i < 4; i++) {
        global.permanent_save.deck[i] = global.player_deck[i];
    }
}

// ===== ВАЖНО: СОХРАНЯЕМ ВСЕ ИЗМЕНЕНИЯ В ФАЙЛ =====
if (variable_global_exists("permanent_save")) {
    save_permanent_to_file();
    LOG("Файл сохранения принудительно записан");
}

LOG("=== СОХРАНЕНИЕ ЗАВЕРШЕНО ===");
LOG("Сохранено генов: " + string(global.permanent_save.genes));
LOG("Сохранено кристаллов: " + string(global.permanent_save.crystals));
if (struct_exists(global.permanent_save, "wave_rewards_data")) {
    LOG("Сохранено сундуков: " + 
                      string(array_length(global.permanent_save.wave_rewards_data.chests)));
}
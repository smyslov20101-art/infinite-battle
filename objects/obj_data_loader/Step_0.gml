
/// Step Event - obj_data_loader

// Проверяем, существует ли еще объект ввода ника
if (!instance_exists(obj_name_input)) {
    // Объект ввода ника уничтожен - значит ник сохранен
    
    // Проверяем, не перешли ли уже в главное меню
    if (!variable_global_exists("name_input_completed")) {
        global.name_input_completed = true;
        
        LOG("=== ВВОД НИКА ЗАВЕРШЕН, ПЕРЕХОД В ГЛАВНОЕ МЕНЮ ===");
        
        // Устанавливаем глобальные переменные
        global.genes = global.current_session.genes;
        global.player_deck = global.current_session.deck;
        global.crystals = global.permanent_save.crystals;
        
        LOG("Глобальные гены: " + string(global.genes));
        LOG("Глобальные кристаллы: " + string(global.crystals));
        
        // Переходим в главное меню
        room_goto(room_wave);
        
        // Уничтожаем загрузчик
        instance_destroy();
    }
}
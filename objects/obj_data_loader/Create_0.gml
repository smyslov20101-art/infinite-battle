/// Create Event - obj_data_loader
LOG("=== ЗАГРУЗЧИК ДАННЫХ (SPLASH) ===");
instance_persistent = true;

// ИНИЦИАЛИЗИРУЕМ ГЕНЕРАТОР СЛУЧАЙНЫХ ЧИСЕЛ
randomize();

// Создаем постоянный контроллер если его нет
if (!instance_exists(obj_persistent_controller)) {
    var pc = instance_create_layer(0, 0, "Instances", obj_persistent_controller);
    pc.instance_persistent = true;
    LOG("✅ СОЗДАН ПОСТОЯННЫЙ КОНТРОЛЛЕР");
} else {
    LOG("✅ ПОСТОЯННЫЙ КОНТРОЛЛЕР УЖЕ СУЩЕСТВУЕТ");
}

// Инициализируем систему сохранений
init_save_system();

// ===== ПРОВЕРЯЕМ, НУЖНО ЛИ ПОКАЗАТЬ ОКНО ВВОДА НИКА =====
// Если в permanent_save нет player_name или он пустой/стандартный, показываем окно
if (!variable_global_exists("permanent_save") || 
    !struct_exists(global.permanent_save, "player_name") ||
    global.permanent_save.player_name == "" ||
    global.permanent_save.player_name == "Игрок") {
    
    LOG("✅ НИК НЕ НАЙДЕН, ПОКАЗЫВАЕМ ОКНО ВВОДА");
    
    // Создаем объект для ввода ника
    var name_input = instance_create_layer(0, 0, "Instances", obj_name_input);
    name_input.persistent = false;
    
    // НЕ ЗАПУСКАЕМ ТАЙМЕР! Будем ждать ввода ника
    LOG("⏳ ОЖИДАНИЕ ВВОДА НИКА...");
    
} else {
    // Загружаем ник в глобальную переменную
    global.player_name = global.permanent_save.player_name;
    LOG("✅ ЗАГРУЖЕН НИК: " + global.player_name);
    
    // Устанавливаем глобальные переменные
    global.genes = global.current_session.genes;
    global.player_deck = global.current_session.deck;
    global.crystals = global.permanent_save.crystals;

    LOG("Глобальные гены: " + string(global.genes));
    LOG("Глобальные кристаллы: " + string(global.crystals));
    LOG("Глобальный отряд: " + 
                      string(global.player_deck[0]) + "," +
                      string(global.player_deck[1]) + "," +
                      string(global.player_deck[2]) + "," +
                      string(global.player_deck[3]));
    
    // Запускаем таймер для перехода в главное меню
    alarm[0] = 1;
}
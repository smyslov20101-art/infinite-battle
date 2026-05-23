/// @function scr_cheat_add_crystals(amount)
/// @param amount {real} Количество кристаллов для добавления
/// @desc Добавляет кристаллы с сохранением во все системы

function scr_cheat_add_crystals(amount) {
    // Добавляем в глобальные кристаллы
    global.crystals += amount;
    
    // Добавляем в постоянное сохранение
    if (variable_global_exists("permanent_save")) {
        global.permanent_save.crystals += amount;
    }
    
    LOG("=== ЧИТ: +" + string(amount) + " кристаллов ===");
    LOG("global.crystals: " + string(global.crystals));
    LOG("permanent_save.crystals: " + string(global.permanent_save.crystals));
    
    // Сразу сохраняем в файл
    if (variable_global_exists("permanent_save")) {
        save_permanent_to_file();
    }
}
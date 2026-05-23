/// @function scr_cheat_add_genes(amount)
/// @param amount {real} Количество генов для добавления
/// @desc Добавляет гены с сохранением во все системы

function scr_cheat_add_genes(amount) {
    // Добавляем в глобальные гены
    global.genes += amount;
    
    // Добавляем в текущую сессию
    if (variable_global_exists("current_session")) {
        global.current_session.genes += amount;
    }
    
    // Добавляем в постоянное сохранение
    if (variable_global_exists("permanent_save")) {
        global.permanent_save.genes += amount;
    }
    
    LOG("=== ЧИТ: +" + string(amount) + " генов ===");
    LOG("global.genes: " + string(global.genes));
    LOG("current_session.genes: " + string(global.current_session.genes));
    LOG("permanent_save.genes: " + string(global.permanent_save.genes));
    
    // Сразу сохраняем в файл
    if (variable_global_exists("permanent_save")) {
        save_permanent_to_file();
    }
}
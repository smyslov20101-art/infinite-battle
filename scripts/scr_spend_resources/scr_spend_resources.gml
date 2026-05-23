/// @function scr_spend_resources(genes_cost, crystals_cost)
/// @desc Списывает ресурсы и обновляет все системы сохранения
/// @return {bool} true если достаточно ресурсов и списание прошло успешно

function scr_spend_resources(genes_cost, crystals_cost) {
    // Проверяем хватает ли ресурсов
    if (global.genes < genes_cost) return false;
    if (global.crystals < crystals_cost) return false;
    
    // Списываем
    global.genes -= genes_cost;
    global.crystals -= crystals_cost;
    
    // Обновляем сессию
    if (variable_global_exists("current_session")) {
        global.current_session.genes = global.genes;
        global.current_session.crystals = global.crystals;
    }
    
    // Обновляем постоянное сохранение
    if (variable_global_exists("permanent_save")) {
        global.permanent_save.genes = global.genes;
        global.permanent_save.crystals = global.crystals;
    }
    
    // Сохраняем в файл
    save_permanent_to_file();
    
    LOG("=== РЕСУРСЫ СПИСАНЫ ===");
    LOG("Гены: -" + string(genes_cost) + ", теперь: " + string(global.genes));
    LOG("Кристаллы: -" + string(crystals_cost) + ", теперь: " + string(global.crystals));
    
    return true;
}
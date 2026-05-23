/// @function save_wave_rewards()
/// @desc Сохраняет награды в глобальные данные и в permanent_save

function save_wave_rewards() {
    LOG("=== СОХРАНЕНИЕ НАГРАД ===");
    
    // Проверяем существование wave_rewards_data
    if (!variable_global_exists("wave_rewards_data")) {
        global.wave_rewards_data = {
            genes: 0,
            crystals: 0,
            chests: []
        };
    }
    
    // Проверяем существование wave_rewards
    if (!variable_global_exists("wave_rewards")) {
        global.wave_rewards = {
            genes: 0,
            crystals: 0,
            chests: []
        };
    }
    
    // Сохраняем текущие награды
    global.wave_rewards_data.genes = global.wave_rewards.genes;
    global.wave_rewards_data.crystals = global.wave_rewards.crystals;
    global.wave_rewards_data.chests = global.wave_rewards.chests;
    
    LOG("  genes: " + string(global.wave_rewards.genes));
    LOG("  crystals: " + string(global.wave_rewards.crystals));
    LOG("  chests: " + string(array_length(global.wave_rewards.chests)));
    
    // ===== ВАЖНО: Сохраняем в permanent_save =====
    if (variable_global_exists("permanent_save")) {
        global.permanent_save.wave_rewards_data = global.wave_rewards_data;
        LOG("  Сохранено в permanent_save");
        
        // ПРИНУДИТЕЛЬНО СОХРАНЯЕМ В ФАЙЛ
        save_permanent_to_file();
        LOG("  Файл сохранения записан");
    } else {
        LOG("  ОШИБКА: permanent_save не существует!");
    }
}
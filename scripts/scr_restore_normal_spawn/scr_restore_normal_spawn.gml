/// @function restore_normal_spawn()
/// @desc Восстанавливает нормальный спавн врагов после смерти босса

function restore_normal_spawn() {
    var controller = instance_find(obj_game_controller, 0);
    if (!instance_exists(controller)) return;
    
    // Снимаем флаг босса
    controller.boss_active = false;
    
    // Восстанавливаем настройки спавна
    if (variable_instance_exists(controller, "saved_spawn_interval")) {
        controller.enemy_spawn_interval = controller.saved_spawn_interval;
        controller.enemy_spawn_timer = min(controller.saved_spawn_timer, 1.0); // Не больше 1 секунды
        
        LOG("=== СПАВН ВРАГОВ ВОССТАНОВЛЕН ===");
        LOG("Интервал: " + string_format(controller.enemy_spawn_interval, 1, 2) + " сек");
    }
}
/// @function scr_enemy_reached_end(_enemy_instance)
/// @desc Обрабатывает достижение врагом конца пути

function scr_enemy_reached_end(_enemy_instance) {
    if (!instance_exists(_enemy_instance)) return;
    
    // Уничтожаем врага
    instance_destroy(_enemy_instance);
    
    // Можно добавить логику повреждения базы/жизней игрока
    // Пока просто уничтожаем врага
}
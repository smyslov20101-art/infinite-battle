/// @function find_enemy_ahead(_enemy_instance)
/// @desc Находит врага впереди (учитывает ВСЕ типы врагов)

function find_enemy_ahead(_enemy_instance) {
    if (!instance_exists(_enemy_instance)) return noone;
    
    var current_x = _enemy_instance.x;
    var enemy_ahead = noone;
    var min_distance = _enemy_instance.queue_distance || 90;
    
    with (obj_enemy_base) {
        if (id == _enemy_instance) continue;
        if (!alive) continue;
        
        var horizontal_dist = current_x - x;
        
        if (horizontal_dist > 0 && horizontal_dist < min_distance) {
            enemy_ahead = id;
            min_distance = horizontal_dist;
        }
    }
    
    return enemy_ahead;
}
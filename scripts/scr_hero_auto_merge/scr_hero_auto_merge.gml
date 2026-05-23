/// @function hero_auto_merge(_hero_instance)
/// @desc Автоматическое слияние героев

function hero_auto_merge(_hero_instance) {
    if (!instance_exists(_hero_instance)) return false;
    
    with (_hero_instance) {
        if (state == STATE_DEAD || state == STATE_MERGING) return false;
        
        // Ищем героя на позиции для слияния
        var best_target = noone;
        var best_distance = 1000;
        
        with (obj_hero) {
            if (id != other.id && 
                other.state != STATE_DEAD && 
                other.state != STATE_MERGING &&
                hero_level < 10 &&
                state == STATE_IDLE) {
                
                var dist = point_distance(x, y, other.x, other.y);
                if (dist < best_distance) {
                    best_target = id;
                    best_distance = dist;
                }
            }
        }
        
        // Если нашли цель - начинаем слияние
        if (instance_exists(best_target)) {
            merge_target = best_target;
            hero_state_set(id, STATE_MERGING);
            return true;
        }
    }
    
    return false;
}
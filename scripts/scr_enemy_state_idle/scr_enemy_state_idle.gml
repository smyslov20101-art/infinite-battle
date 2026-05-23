/// @function enemy_state_idle(_enemy_instance)
/// @desc Обработка состояния ОЖИДАНИЯ врага

function enemy_state_idle(_enemy_instance) {
    if (!instance_exists(_enemy_instance)) return;
    
    with (_enemy_instance) {
        // Враги редко бывают в idle, но может пригодиться
        // Например, когда все герои мертвы
        
        // Проверяем, появились ли новые герои
        var hero_found = false;
        with (obj_hero) {
            if (state != STATE_DEAD && x < other.x) {
                hero_found = true;
                target_hero = id;
                break;
            }
        }
        
        if (hero_found) {
            enemy_state_set(id, ENEMY_STATE_MOVING);
        }
    }
}
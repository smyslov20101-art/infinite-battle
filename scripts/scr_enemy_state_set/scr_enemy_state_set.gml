/// @function enemy_state_set(_enemy_instance, _new_state)
/// @desc Меняет состояние врага

function enemy_state_set(_enemy_instance, _new_state) {
    if (!instance_exists(_enemy_instance)) return false;
    
    with (_enemy_instance) {
        if (state == ENEMY_STATE_DEAD && _new_state != ENEMY_STATE_DEAD) return false;
        if (state == _new_state) return false;
        
        var old_state = state;
        state = _new_state;
        state_timer = 0;
        
        // Выход из старого состояния
        switch (old_state) {
            case ENEMY_STATE_ATTACKING:
                // Очищаем цель атаки
                break;
        }
        
        // Вход в новое состояние
        switch (_new_state) {
            case ENEMY_STATE_DEAD:
                // Умираем
                alive = false;
                enemy_die(id);
                break;
                
            case ENEMY_STATE_MOVING:
                // Начинаем движение
                break;
                
            case ENEMY_STATE_ATTACKING:
                // Начинаем атаку
                attack_timer = 0; // Сбрасываем таймер атаки
                break;
        }
        
        return true;
    }
}
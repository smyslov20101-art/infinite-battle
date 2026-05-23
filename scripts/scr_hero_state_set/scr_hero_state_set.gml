/// @function hero_state_set(_hero_instance, _new_state)
/// @desc Меняет состояние героя

function hero_state_set(_hero_instance, _new_state) {
    if (!instance_exists(_hero_instance)) return false;
    
    with (_hero_instance) {
        if (state == STATE_DEAD && _new_state != STATE_DEAD) return false;
        if (state == _new_state) return false;
        
        var old_state = state;
        state = _new_state;
        state_timer = 0;
        
        // Выход из старого состояния
        switch (old_state) {
            case STATE_FIGHTING:
                fight_target = noone;
                break;
            case STATE_MERGING:
                merge_target = noone;
                break;
        }
        
        // Вход в новое состояние
        switch (_new_state) {
            case STATE_DEAD:
                if (variable_instance_exists(id, "die")) {
                    die();
                }
                break;
        }
        
        return true;
    }
}
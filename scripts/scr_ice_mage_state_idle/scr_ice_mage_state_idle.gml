/// @function ice_mage_state_idle(_ice_mage_instance)
/// @desc Обработка состояния ПОКОЙ мага льда

function ice_mage_state_idle(_ice_mage_instance) {
    if (!instance_exists(_ice_mage_instance)) return;
    
    with (_ice_mage_instance) {
        var dist_to_target = point_distance(x, y, target_x, target_y);
        if (dist_to_target > 10) {
            state = STATE_MOVING;
            return;
        }
        
        var closest_enemy = noone;
        var closest_distance = attack_range_idle;
        var mage_x = x;
        var mage_y = y;
        
        with (obj_enemy_base) {
            if (alive && hp > 0 && x > mage_x) {
                var dist = point_distance(x, y, mage_x, mage_y);
                if (dist < closest_distance) {
                    closest_enemy = id;
                    closest_distance = dist;
                }
            }
        }
        
        if (instance_exists(closest_enemy)) {
            attack_timer -= 1 / room_speed;
            if (attack_timer <= 0) {
                scr_create_ice_bolt(id, closest_enemy, damage);
                attack_timer = 1 / attack_speed;
            }
        }
    }
}
/// @function crossbowman_state_fighting(_crossbowman_instance)
/// @desc Обработка состояния БОЯ арбалетчика

function crossbowman_state_fighting(_crossbowman_instance) {
    if (!instance_exists(_crossbowman_instance)) return;
    
    with (_crossbowman_instance) {
        if (!instance_exists(fight_target)) {
            var attack_range = attack_range_moving;
            var attacker_x = x;
            var attacker_y = y;
            
            var new_enemy = noone;
            var closest_dist = attack_range;
            
            with (obj_enemy_base) {
                if (alive && hp > 0 && x > attacker_x) {
                    var dist = point_distance(x, y, attacker_x, attacker_y);
                    if (dist < closest_dist) {
                        new_enemy = id;
                        closest_dist = dist;
                    }
                }
            }
            
            if (instance_exists(new_enemy)) {
                fight_target = new_enemy;
            } else {
                state = STATE_MOVING;
            }
            return;
        }
        
        var dist_to_enemy = point_distance(x, y, fight_target.x, fight_target.y);
        var attack_range = attack_range_moving;
        
        if (dist_to_enemy > attack_range + 50) {
            state = STATE_MOVING;
            fight_target = noone;
            return;
        }
        
        attack_timer -= 1 / room_speed;
        if (attack_timer <= 0) {
            LOG_CAT("🏹 АРБАЛЕТЧИК АТАКУЕТ! Урон: " + string(damage), "combat");
            scr_create_bolt(id, fight_target, damage);
            attack_timer = 1 / attack_speed;
        }
    }
}
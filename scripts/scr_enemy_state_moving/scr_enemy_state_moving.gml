/// @function enemy_state_moving(_enemy_instance)
function enemy_state_moving(_enemy_instance) {
    if (!instance_exists(_enemy_instance)) return;
    
    with (_enemy_instance) {
        // ===== ГОЛОВОКРУЖЕНИЕ (враг не двигается) =====
        if (variable_instance_exists(id, "dizziness_timer") && dizziness_timer > 0) {
            dizziness_timer -= 1 / room_speed;
            if (dizziness_timer > 0) {
                return;
            }
        }
        
        var current_move_speed = move_speed;
        if (variable_instance_exists(id, "move_speed_slow_timer") && move_speed_slow_timer > 0) {
            if (variable_instance_exists(id, "slowed_move_speed")) {
                current_move_speed = slowed_move_speed;
            }
        }
        
        var enemy_ahead = noone;
        with (obj_enemy_base) {
            if (id != other.id && alive && x < other.x && other.x - x < other.queue_distance) {
                enemy_ahead = id;
            }
        }
        
        if (instance_exists(enemy_ahead)) {
            if (is_ranged) {
                if (!variable_instance_exists(id, "target_hero") || !instance_exists(target_hero)) {
                    var closest_hero_for_ranged = noone;
                    var closest_ranged_dist = attack_range;
                    with (obj_hero_base) {
                        if (hp > 0 && x < other.x) {
                            var dist = point_distance(x, y, other.x, other.y);
                            if (dist < closest_ranged_dist) {
                                closest_hero_for_ranged = id;
                                closest_ranged_dist = dist;
                            }
                        }
                    }
                    target_hero = closest_hero_for_ranged;
                }
                if (instance_exists(target_hero)) {
                    var dist_to_hero = point_distance(x, y, target_hero.x, target_hero.y);
                    if (dist_to_hero <= attack_range && dist_to_hero > 100) {
                        state = ENEMY_STATE_ATTACKING;
                        return;
                    }
                }
            }
            return;
        }
        
        if (!variable_instance_exists(id, "target_hero") || !instance_exists(target_hero)) {
            var closest_hero = noone;
            var closest_distance = search_radius;
            with (obj_hero_base) {
                if (hp > 0 && x < other.x) {
                    var dist = point_distance(x, y, other.x, other.y);
                    if (dist < closest_distance) {
                        closest_hero = id;
                        closest_distance = dist;
                    }
                }
            }
            target_hero = closest_hero;
        }
        
        if (instance_exists(target_hero)) {
            var dist_to_hero = point_distance(x, y, target_hero.x, target_hero.y);
            if (is_ranged) {
                if (dist_to_hero <= attack_range) {
                    state = ENEMY_STATE_ATTACKING;
                    return;
                } else {
                    x -= current_move_speed;
                    return;
                }
            }
            if (dist_to_hero > stop_distance) {
                x -= current_move_speed;
            } else {
                state = ENEMY_STATE_ATTACKING;
            }
        } else {
            x -= current_move_speed;
        }
    }
}
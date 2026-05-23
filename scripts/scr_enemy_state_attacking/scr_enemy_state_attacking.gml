/// @function enemy_state_attacking(_enemy_instance)
function enemy_state_attacking(_enemy_instance) {
    if (!instance_exists(_enemy_instance)) return;
    
    with (_enemy_instance) {
        // ===== ГОЛОВОКРУЖЕНИЕ (враг не атакует) =====
        if (variable_instance_exists(id, "dizziness_timer") && dizziness_timer > 0) {
            dizziness_timer -= 1 / room_speed;
            if (dizziness_timer > 0) {
                return;
            }
        }
        
        // ===== СНИЖЕНИЕ УРОНА ОТ ГОЛОВОКРУЖЕНИЯ =====
        var current_damage = damage;
        if (variable_instance_exists(id, "dizziness_damage_reduction_timer") && dizziness_damage_reduction_timer > 0) {
            if (variable_instance_exists(id, "dizziness_damage_mult")) {
                current_damage = floor(current_damage * dizziness_damage_mult);
                dizziness_damage_reduction_timer -= 1 / room_speed;
            }
        }
        
        if (!instance_exists(target_hero) || target_hero.hp <= 0) {
            var new_closest = noone;
            var closest_dist = search_radius;
            with (obj_hero_base) {
                if (hp > 0 && x < other.x) {
                    var dist = point_distance(x, y, other.x, other.y);
                    if (dist < closest_dist) {
                        new_closest = id;
                        closest_dist = dist;
                    }
                }
            }
            if (instance_exists(new_closest)) {
                target_hero = new_closest;
            } else {
                state = ENEMY_STATE_MOVING;
                return;
            }
        }
        
        var dist_to_hero = point_distance(x, y, target_hero.x, target_hero.y);
        var max_distance = stop_distance;
        
        if (is_ranged) {
            max_distance = attack_range + 50;
            var enemy_ahead = noone;
            with (obj_enemy_base) {
                if (id != other.id && alive && x < other.x && other.x - x < 100) {
                    enemy_ahead = id;
                }
            }
            if (!instance_exists(enemy_ahead)) {
                if (dist_to_hero > 70) {
                    x -= move_speed;
                }
            }
            if (dist_to_hero > max_distance) {
                state = ENEMY_STATE_MOVING;
                return;
            }
        } else {
            if (dist_to_hero > stop_distance + 30) {
                state = ENEMY_STATE_MOVING;
                return;
            }
        }
        
        var current_attack_cooldown = attack_cooldown_max;
        if (variable_instance_exists(id, "attack_speed_slow_timer") && attack_speed_slow_timer > 0) {
            if (variable_instance_exists(id, "slowed_attack_speed")) {
                current_attack_cooldown = slowed_attack_speed;
            }
        }
        
        attack_timer -= 1 / room_speed;
        if (attack_timer <= 0) {
            // ===== ПАЛАДИН: ПРОМАХ (каждый 6 удар) =====
            var hit_miss = false;
            if (target_hero.hero_type == "paladin" && variable_instance_exists(target_hero, "next_hit_miss") && target_hero.next_hit_miss) {
                hit_miss = true;
                target_hero.next_hit_miss = false;
                LOG_CAT("🎯❌ ПРОМАХ! Удар по паладину не попал!", "combat");
            }
            
            if (!hit_miss) {
                if (is_ranged) {
                    scr_create_enemy_arrow(id, target_hero, current_damage);
                } else {
                    scr_hero_base_take_damage(target_hero, current_damage, false);
                }
            }
            attack_timer = current_attack_cooldown;
        }
    }
}
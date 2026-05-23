/// @function archmage_state_fighting(_instance)
/// @desc Обработка состояния БОЯ Архимага с поддержкой критов и святого отравления

function archmage_state_fighting(_instance) {
    if (!instance_exists(_instance)) return;
    
    with (_instance) {
        // 1. Проверяем цель
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
            
            // Также проверяем тестовых манекенов
            if (!instance_exists(new_enemy)) {
                with (obj_test_dummy) {
                    if (hp > 0 && x > attacker_x) {
                        var dist = point_distance(x, y, attacker_x, attacker_y);
                        if (dist < closest_dist) {
                            new_enemy = id;
                            closest_dist = dist;
                        }
                    }
                }
            }
            if (!instance_exists(new_enemy)) {
                with (obj_test_dummy_back) {
                    if (hp > 0 && x > attacker_x) {
                        var dist = point_distance(x, y, attacker_x, attacker_y);
                        if (dist < closest_dist) {
                            new_enemy = id;
                            closest_dist = dist;
                        }
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
        
        // 2. Проверяем жив ли враг
        if (!fight_target.alive || fight_target.hp <= 0) {
            fight_target = noone;
            var dist_to_target = point_distance(x, y, target_x, target_y);
            if (dist_to_target > 10) {
                state = STATE_MOVING;
            } else {
                state = STATE_IDLE;
            }
            return;
        }
        
        // 3. Проверяем дистанцию
        var dist_to_enemy = point_distance(x, y, fight_target.x, fight_target.y);
        
        if (dist_to_enemy > attack_range_moving + 50) {
            state = STATE_MOVING;
            fight_target = noone;
            return;
        }
        
        // 4. Атакуем
        attack_timer -= 1 / room_speed;
        if (attack_timer <= 0) {
            LOG_CAT("🔮 АРХИМАГ АТАКУЕТ! Урон: " + string(damage), "combat");
            
            // Рассчитываем урон с учетом крита
            var final_damage = damage;
            var is_crit = false;
            
            // ===== КРИТИЧЕСКИЙ УДАР =====
            if (variable_instance_exists(id, "crit_chance") && crit_chance > 0) {
                var crit_roll = random(100);
                if (crit_roll < crit_chance) {
                    var crit_mult = 2.0;
                    if (variable_instance_exists(id, "crit_damage_mult")) {
                        crit_mult = crit_damage_mult;
                    }
                    final_damage = floor(final_damage * crit_mult);
                    is_crit = true;
                    LOG_CAT("💥 КРИТИЧЕСКИЙ СНАРЯД! Урон: " + string(final_damage) + 
                              " (x" + string(crit_mult) + "), шанс: " + string(crit_chance) + "%", "combat");
                }
            }
            
            // Создаем магический снаряд
            scr_create_archmage_bolt(id, fight_target, final_damage);
            
            // ===== СВЯТОЕ ОТРАВЛЕНИЕ =====
            if (variable_instance_exists(id, "holy_poison_percent") && holy_poison_percent > 0) {
                if (!variable_instance_exists(fight_target, "holy_poison_timer")) {
                    fight_target.holy_poison_timer = 0;
                    fight_target.holy_poison_damage = 0;
                    fight_target.holy_poison_damage_timer = 0;
                }
                var poison_damage = floor(final_damage * holy_poison_percent / 100);
                poison_damage = max(1, poison_damage);
                fight_target.holy_poison_timer = 3.0;
                fight_target.holy_poison_damage = poison_damage;
                LOG_CAT("☠️ СВЯТОЕ ОТРАВЛЕНИЕ! " + string(poison_damage) + " урона/сек на 3 сек", "combat");
            }
            
            // ===== ВАМПИРИЗМ (если есть) =====
            if (variable_instance_exists(id, "lifesteal") && lifesteal > 0) {
                var heal_amount = floor(final_damage * lifesteal / 100);
                if (heal_amount > 0) {
                    var old_hp = hp;
                    hp = min(max_hp, hp + heal_amount);
                    LOG_CAT("💉 ВАМПИРИЗМ: +" + string(hp - old_hp) + " HP", "vampire");
                }
            }
            
            // Сбрасываем таймер атаки
            var current_attack_speed = attack_speed;
            if (variable_instance_exists(id, "attack_speed_bonus") && attack_speed_bonus > 0) {
                current_attack_speed = attack_speed * (1 + attack_speed_bonus / 100);
            }
            attack_timer = 1 / current_attack_speed;
            
            // Визуальный эффект
            image_blend = c_white;
            alarm[0] = 5;
        }
    }
}
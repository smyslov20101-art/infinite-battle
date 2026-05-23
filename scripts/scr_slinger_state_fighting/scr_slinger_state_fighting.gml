/// @function slinger_state_fighting(_slinger_instance)
/// @desc Обработка состояния БОЯ бродяги с рогаткой (с поддержкой критов, оглушения)

function slinger_state_fighting(_slinger_instance) {
    if (!instance_exists(_slinger_instance)) return;
    
    with (_slinger_instance) {
        // 1. Проверяем что цель существует и жива
        if (!instance_exists(fight_target)) {
            // Сохраняем переменные для поиска
            var slinger_attack_range = attack_range_moving;
            var slinger_x = x;
            var slinger_y = y;
            
            // Если цель пропала - ищем нового врага
            var new_enemy = noone;
            var closest_dist = slinger_attack_range;
            
            with (obj_enemy_base) {
                if (alive && hp > 0 && x > slinger_x) {
                    var dist = point_distance(x, y, slinger_x, slinger_y);
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
        
        // 2. Проверяем дистанцию до врага
        var dist_to_enemy = point_distance(x, y, fight_target.x, fight_target.y);
        var slinger_attack_range = attack_range_moving;
        
        // 3. Если враг слишком далеко - возвращаемся к движению
        if (dist_to_enemy > slinger_attack_range + 50) {
            state = STATE_MOVING;
            fight_target = noone;
            return;
        }
        
        // 4. Стреляем во врага
        attack_timer -= 1 / room_speed;
        if (attack_timer <= 0) {
            LOG_CAT("🪨 БРОДЯГА С РОГАТКОЙ АТАКУЕТ В FIGHTING!", "combat");
            
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
                    LOG_CAT("💥 КРИТИЧЕСКИЙ ВЫСТРЕЛ! Урон: " + string(final_damage) + 
                              " (x" + string(crit_mult) + "), шанс: " + string(crit_chance) + "%", "combat");
                }
            }
            
            // Создаем снаряд из рогатки
            scr_create_sling_shot(id, fight_target, final_damage);
            
            // ===== ОГЛУШЕНИЕ (STUN) =====
            if (variable_instance_exists(id, "stun_chance") && stun_chance > 0) {
                LOG_CAT("💫 ПРОВЕРКА ОГЛУШЕНИЯ! Шанс: " + string(stun_chance) + "%", "combat");
                var stun_roll = random(100);
                LOG_CAT("  Выпало: " + string(stun_roll), "combat");
                
                if (stun_roll < stun_chance) {
                    if (!variable_instance_exists(fight_target, "stun_timer")) {
                        fight_target.stun_timer = 0;
                    }
                    fight_target.stun_timer = 2.0; // Оглушение на 2 секунды
                    LOG_CAT("💫 ОГЛУШЕНИЕ СРАБОТАЛО! Цель оглушена на 2 сек (шанс: " + string(stun_chance) + 
                              "%, выпало: " + string(stun_roll) + "%)", "combat");
                } else {
                    LOG_CAT("❌ ОГЛУШЕНИЕ НЕ СРАБОТАЛО (выпало " + string(stun_roll) + 
                              " >= " + string(stun_chance) + ")", "combat");
                }
            }
            
            // Сбрасываем таймер атаки
            var current_attack_speed = attack_speed;
            if (variable_instance_exists(id, "attack_speed_bonus") && attack_speed_bonus > 0) {
                current_attack_speed = attack_speed * (1 + attack_speed_bonus / 100);
            }
            attack_timer = 1 / current_attack_speed;
        }
    }
}
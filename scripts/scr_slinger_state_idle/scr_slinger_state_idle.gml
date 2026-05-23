/// @function slinger_state_idle(_slinger_instance)
/// @desc Обработка состояния ПОКОЙ бродяги с рогаткой (с поддержкой критов, оглушения)

function slinger_state_idle(_slinger_instance) {
    if (!instance_exists(_slinger_instance)) return;
    
    with (_slinger_instance) {
        // Проверяем, на месте ли мы
        var dist_to_target = point_distance(x, y, target_x, target_y);
        if (dist_to_target > 10) {
            state = STATE_MOVING;
            return;
        }
        
        // Ищем ближайшего врага
        var closest_enemy = noone;
        var closest_distance = attack_range_idle;
        var slinger_x = x;
        var slinger_y = y;
        
        with (obj_enemy_base) {
            if (alive && hp > 0 && x > slinger_x) {
                var dist = point_distance(x, y, slinger_x, slinger_y);
                if (dist < closest_distance) {
                    closest_enemy = id;
                    closest_distance = dist;
                }
            }
        }
        
        // Если нашли врага - атакуем
        if (instance_exists(closest_enemy)) {
            attack_timer -= 1 / room_speed;
            
            if (attack_timer <= 0) {
                LOG_CAT("🪨 БРОДЯГА С РОГАТКОЙ АТАКУЕТ В IDLE!", "combat");
                
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
                scr_create_sling_shot(id, closest_enemy, final_damage);
                
                // ===== ОГЛУШЕНИЕ (STUN) =====
                if (variable_instance_exists(id, "stun_chance") && stun_chance > 0) {
                    LOG_CAT("💫 ПРОВЕРКА ОГЛУШЕНИЯ! Шанс: " + string(stun_chance) + "%", "combat");
                    var stun_roll = random(100);
                    LOG_CAT("  Выпало: " + string(stun_roll), "combat");
                    
                    if (stun_roll < stun_chance) {
                        if (!variable_instance_exists(closest_enemy, "stun_timer")) {
                            closest_enemy.stun_timer = 0;
                        }
                        closest_enemy.stun_timer = 2.0; // Оглушение на 2 секунды
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
}
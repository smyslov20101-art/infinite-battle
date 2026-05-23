/// @function ice_mage_state_fighting(_ice_mage_instance)
/// @desc Обработка состояния БОЯ мага льда с поддержкой мороза, бури и льда

function ice_mage_state_fighting(_ice_mage_instance) {
    if (!instance_exists(_ice_mage_instance)) return;
    
    with (_ice_mage_instance) {
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
        
        var dist_to_enemy = point_distance(x, y, fight_target.x, fight_target.y);
        var attack_range = attack_range_moving;
        
        if (dist_to_enemy > attack_range + 50) {
            state = STATE_MOVING;
            fight_target = noone;
            return;
        }
        
        attack_timer -= 1 / room_speed;
        if (attack_timer <= 0) {
            LOG_CAT("❄️ МАГ ЛЬДА АТАКУЕТ! Урон: " + string(damage), "combat");
            
            // Создаем ледяной снаряд
            scr_create_ice_bolt(id, fight_target, damage);
            
            // ===== МОРОЗ (FROST) - замедление движения врага =====
            if (variable_instance_exists(id, "frost_percent") && frost_percent > 0) {
                if (!variable_instance_exists(fight_target, "move_speed_slow_timer")) {
                    fight_target.move_speed_slow_timer = 0;
                    // Сохраняем оригинальную скорость движения, если её нет
                    if (!variable_instance_exists(fight_target, "original_move_speed")) {
                        fight_target.original_move_speed = fight_target.move_speed;
                    }
                }
                fight_target.move_speed_slow_timer = 3.0; // 3 секунды
                
                // Рассчитываем замедленную скорость
                var new_move_speed = fight_target.original_move_speed * (1 - frost_percent / 100);
                new_move_speed = max(0.5, new_move_speed); // Не медленнее 0.5
                fight_target.move_speed = new_move_speed;
                
                // Сохраняем замедленную скорость для отображения в debug
                if (!variable_instance_exists(fight_target, "slowed_move_speed")) {
                    fight_target.slowed_move_speed = new_move_speed;
                }
                fight_target.slowed_move_speed = new_move_speed;
                
                LOG_CAT("❄️ МОРОЗ: враг замедлен на " + string(frost_percent) + 
                          "% (скорость: " + string_format(fight_target.original_move_speed, 1, 2) + 
                          " → " + string_format(new_move_speed, 1, 2) + ")", "combat");
            }
            
            // ===== БУРЯ (BLIZZARD) - замедление атаки врагов =====
            if (variable_instance_exists(id, "blizzard_chance") && blizzard_chance > 0) {
                var blizzard_roll = random(100);
                if (blizzard_roll < blizzard_chance) {
                    // Применяем замедление атаки ко всем врагам на поле
                    var enemies_affected = 0;
                    with (obj_enemy_base) {
                        if (alive && hp > 0) {
                            if (!variable_instance_exists(id, "attack_speed_slow_timer")) {
                                attack_speed_slow_timer = 0;
                                if (!variable_instance_exists(id, "original_attack_cooldown")) {
                                    original_attack_cooldown = attack_cooldown_max;
                                }
                            }
                            attack_speed_slow_timer = 4.0; // 4 секунды
                            
                            // Рассчитываем новую скорость атаки
                            var new_cooldown = original_attack_cooldown * (1 + other.blizzard_slow_percent / 100);
                            attack_cooldown_max = new_cooldown;
                            
                            enemies_affected++;
                        }
                    }
                    // Также применяем к тестовым манекенам
                    with (obj_test_dummy) {
                        if (hp > 0) {
                            if (!variable_instance_exists(id, "attack_speed_slow_timer")) {
                                attack_speed_slow_timer = 0;
                                if (!variable_instance_exists(id, "original_attack_cooldown")) {
                                    original_attack_cooldown = attack_cooldown_max;
                                }
                            }
                            attack_speed_slow_timer = 4.0;
                            var new_cooldown = original_attack_cooldown * (1 + other.blizzard_slow_percent / 100);
                            attack_cooldown_max = new_cooldown;
                            enemies_affected++;
                        }
                    }
                    with (obj_test_dummy_back) {
                        if (hp > 0) {
                            if (!variable_instance_exists(id, "attack_speed_slow_timer")) {
                                attack_speed_slow_timer = 0;
                                if (!variable_instance_exists(id, "original_attack_cooldown")) {
                                    original_attack_cooldown = attack_cooldown_max;
                                }
                            }
                            attack_speed_slow_timer = 4.0;
                            var new_cooldown = original_attack_cooldown * (1 + other.blizzard_slow_percent / 100);
                            attack_cooldown_max = new_cooldown;
                            enemies_affected++;
                        }
                    }
                    LOG_CAT("🌪️ БУРЯ: замедление атаки всех врагов на " + string(blizzard_slow_percent) + 
                              "% на 4 сек, поражено: " + string(enemies_affected) + 
                              " (шанс: " + string(blizzard_chance) + "%, выпало: " + string(blizzard_roll) + "%)", "combat");
                }
            }
            
            // ===== ЛЕД (ICE) - периодический урон по всем врагам =====
            if (variable_instance_exists(id, "ice_chance") && ice_chance > 0 && ice_damage > 0) {
                var ice_roll = random(100);
                if (ice_roll < ice_chance) {
                    // Применяем эффект льда ко всем врагам
                    var enemies_affected = 0;
                    with (obj_enemy_base) {
                        if (alive && hp > 0) {
                            // Инициализируем переменные льда на враге
                            if (!variable_instance_exists(id, "ice_timer")) {
                                ice_timer = 0;
                                ice_damage_per_tick = 0;
                            }
                            ice_timer = 2.0; // 2 секунды
                            ice_damage_per_tick = other.ice_damage; // Урон за тик
                            ice_damage_timer = 0;
                            enemies_affected++;
                        }
                    }
                    // Также применяем к тестовым манекенам
                    with (obj_test_dummy) {
                        if (hp > 0) {
                            if (!variable_instance_exists(id, "ice_timer")) {
                                ice_timer = 0;
                                ice_damage_per_tick = 0;
                            }
                            ice_timer = 2.0;
                            ice_damage_per_tick = other.ice_damage;
                            ice_damage_timer = 0;
                            enemies_affected++;
                        }
                    }
                    with (obj_test_dummy_back) {
                        if (hp > 0) {
                            if (!variable_instance_exists(id, "ice_timer")) {
                                ice_timer = 0;
                                ice_damage_per_tick = 0;
                            }
                            ice_timer = 2.0;
                            ice_damage_per_tick = other.ice_damage;
                            ice_damage_timer = 0;
                            enemies_affected++;
                        }
                    }
                    LOG_CAT("🧊 ЛЕД: нанесение " + string(ice_damage) + 
                              " урона всем врагам на 2 сек, поражено: " + string(enemies_affected) + 
                              " (шанс: " + string(ice_chance) + "%, выпало: " + string(ice_roll) + "%)", "combat");
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
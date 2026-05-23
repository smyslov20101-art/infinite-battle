/// @function mage_state_idle(_mage_instance)
/// @desc Обработка состояния ПОКОЙ мага (стрельба фаерболами с поддержкой критов, горения и мульти-атаки)

function mage_state_idle(_mage_instance) {
    if (!instance_exists(_mage_instance)) return;
    
    with (_mage_instance) {
        // Проверяем, на месте ли мы
        var dist_to_target = point_distance(x, y, target_x, target_y);
        if (dist_to_target > 10) {
            state = STATE_MOVING;
            return;
        }
        
        // Ищем ближайшего врага
        var closest_enemy = noone;
        var closest_distance = attack_range_idle;
        var mage_x = x;
        var mage_y = y;
        
        // Сначала ищем среди obj_enemy_base
        with (obj_enemy_base) {
            if (alive && hp > 0 && x > mage_x) {
                var dist = point_distance(x, y, mage_x, mage_y);
                if (dist < closest_distance) {
                    closest_enemy = id;
                    closest_distance = dist;
                }
            }
        }
        
        // Если не нашли через obj_enemy_base, ищем среди манекенов напрямую
        if (!instance_exists(closest_enemy)) {
            with (obj_test_dummy) {
                if (hp > 0 && x > mage_x) {
                    var dist = point_distance(x, y, mage_x, mage_y);
                    if (dist < closest_distance) {
                        closest_enemy = id;
                        closest_distance = dist;
                    }
                }
            }
        }
        if (!instance_exists(closest_enemy)) {
            with (obj_test_dummy_back) {
                if (hp > 0 && x > mage_x) {
                    var dist = point_distance(x, y, mage_x, mage_y);
                    if (dist < closest_distance) {
                        closest_enemy = id;
                        closest_distance = dist;
                    }
                }
            }
        }
        
        // Если нашли врага - атакуем
        if (instance_exists(closest_enemy)) {
            attack_timer -= 1 / room_speed;
            
            if (attack_timer <= 0) {
                LOG_CAT("🔥 МАГ АТАКУЕТ! Цель: " + string(closest_enemy.object_index), "combat");
                
                // Рассчитываем урон с учетом крита
                var final_damage = damage;
                var is_crit = false;
                
                if (crit_chance > 0) {
                    var crit_roll = random(100);
                    if (crit_roll < crit_chance) {
                        final_damage = floor(final_damage * crit_damage_mult);
                        is_crit = true;
                        LOG_CAT("💥 КРИТИЧЕСКИЙ ФАЕРБОЛ! Урон: " + string(final_damage) + 
                                  " (x" + string(crit_damage_mult) + "), шанс: " + string(crit_chance) + "%", "combat");
                    }
                }
                
                // Создаем фаербол
                var fireball = scr_create_fireball(id, closest_enemy, final_damage);
                
                // ===== ГОРЕНИЕ (BURN) =====
                if (variable_instance_exists(id, "burn_damage") && burn_damage > 0) {
                    if (!variable_instance_exists(closest_enemy, "burn_stacks")) {
                        closest_enemy.burn_stacks = 0;
                        closest_enemy.burn_timer = 0;
                        closest_enemy.burn_damage_per_stack = 0;
                    }
                    
                    if (closest_enemy.burn_damage_per_stack < burn_damage) {
                        closest_enemy.burn_damage_per_stack = burn_damage;
                        LOG_CAT("🔥 Урон горения за стек обновлен: " + string(burn_damage), "combat");
                    }
                    
                    closest_enemy.burn_stacks += 1;
                    closest_enemy.burn_timer = 4.0;
                    
                    var total_burn_damage = closest_enemy.burn_stacks * closest_enemy.burn_damage_per_stack;
                    LOG_CAT("🔥 ГОРЕНИЕ: +1 стек (всего " + string(closest_enemy.burn_stacks) + 
                              ", урон/2 сек: " + string(total_burn_damage) + 
                              ", урон/стек: " + string(closest_enemy.burn_damage_per_stack) + ")", "combat");
                }
                
                // ===== АТАКА ПО ДВУМ ЦЕЛЯМ (MULTI TARGET) =====
                if (variable_instance_exists(id, "multi_target_chance") && multi_target_chance > 0) {
                    LOG_CAT("🎯 ПРОВЕРКА МУЛЬТИ-АТАКИ! Шанс: " + string(multi_target_chance) + "%", "combat");
                    var multi_roll = random(100);
                    LOG_CAT("  Выпало: " + string(multi_roll), "combat");
                    
                    if (multi_roll < multi_target_chance) {
                        LOG_CAT("✅ МУЛЬТИ-АТАКА СРАБОТАЛА!", "combat");
                        
                        // Ищем второго врага (не первого) - ПРЯМОЙ ПЕРЕБОР ВСЕХ ВРАГОВ
                        var second_target = noone;
                        var second_distance = 500; // Большой радиус
                        
                        // 1. Проверяем всех врагов через obj_enemy_base
                        with (obj_enemy_base) {
                            if (id != closest_enemy && alive && hp > 0 && x > mage_x) {
                                var dist = point_distance(x, y, mage_x, mage_y);
                                if (dist < second_distance) {
                                    second_target = id;
                                    second_distance = dist;
                                    LOG_CAT("  Найдена вторая цель через obj_enemy_base: " + string(object_index) + 
                                              ", расстояние: " + string(dist), "combat");
                                }
                            }
                        }
                        
                        // 2. Проверяем передний манекен (если не нашли)
                        if (!instance_exists(second_target)) {
                            with (obj_test_dummy) {
                                if (id != closest_enemy && hp > 0 && x > mage_x) {
                                    var dist = point_distance(x, y, mage_x, mage_y);
                                    if (dist < second_distance) {
                                        second_target = id;
                                        second_distance = dist;
                                        LOG_CAT("  Найдена вторая цель через obj_test_dummy: " + string(object_index), "combat");
                                    }
                                }
                            }
                        }
                        
                        // 3. Проверяем задний манекен (если не нашли)
                        if (!instance_exists(second_target)) {
                            with (obj_test_dummy_back) {
                                if (id != closest_enemy && hp > 0 && x > mage_x) {
                                    var dist = point_distance(x, y, mage_x, mage_y);
                                    if (dist < second_distance) {
                                        second_target = id;
                                        second_distance = dist;
                                        LOG_CAT("  Найдена вторая цель через obj_test_dummy_back: " + string(object_index), "combat");
                                    }
                                }
                            }
                        }
                        
                        // 4. Если все еще не нашли, ищем среди всех врагов без условия x > mage_x
                        if (!instance_exists(second_target)) {
                            with (obj_enemy_base) {
                                if (id != closest_enemy && alive && hp > 0) {
                                    var dist = point_distance(x, y, mage_x, mage_y);
                                    if (dist < second_distance) {
                                        second_target = id;
                                        second_distance = dist;
                                        LOG_CAT("  Найдена вторая цель (без условия x>mage_x): " + string(object_index), "combat");
                                    }
                                }
                            }
                        }
                        
                        if (instance_exists(second_target)) {
                            var second_fireball = scr_create_fireball(id, second_target, final_damage);
                            LOG_CAT("🔥 АТАКА ПО ДВУМ ЦЕЛЯМ! Вторая цель: " + string(second_target.object_index) + 
                                      ", расстояние: " + string(second_distance) + 
                                      ", урон: " + string(final_damage), "combat");
                            
                            // Накладываем горение и на вторую цель
                            if (variable_instance_exists(id, "burn_damage") && burn_damage > 0) {
                                if (!variable_instance_exists(second_target, "burn_stacks")) {
                                    second_target.burn_stacks = 0;
                                    second_target.burn_timer = 0;
                                    second_target.burn_damage_per_stack = 0;
                                }
                                
                                if (second_target.burn_damage_per_stack < burn_damage) {
                                    second_target.burn_damage_per_stack = burn_damage;
                                }
                                
                                second_target.burn_stacks += 1;
                                second_target.burn_timer = 4.0;
                                
                                var total_burn2 = second_target.burn_stacks * second_target.burn_damage_per_stack;
                                LOG_CAT("🔥 ГОРЕНИЕ на второй цели: +1 стек (всего " + string(second_target.burn_stacks) + 
                                          ", урон/2 сек: " + string(total_burn2) + ")", "combat");
                            }
                        } else {
                            LOG_CAT("⚠️ Нет второй цели для мульти-атаки! closest_enemy=" + string(closest_enemy.object_index) + 
                                      ", позиция мага x=" + string(mage_x), "combat");
                            
                            // Выводим список всех врагов на поле для отладки
                            var enemy_list = "";
                            with (obj_enemy_base) {
                                if (alive && hp > 0) {
                                    enemy_list += string(object_index) + "(" + string(x) + "), ";
                                }
                            }
                            LOG_CAT("  Все враги на поле: " + enemy_list, "combat");
                        }
                    } else {
                        LOG_CAT("❌ МУЛЬТИ-АТАКА НЕ СРАБОТАЛА (выпало " + string(multi_roll) + " >= " + string(multi_target_chance) + ")", "combat");
                    }
                }
                
                // Сбрасываем таймер атаки
                var current_attack_speed = attack_speed;
                if (variable_instance_exists(id, "attack_speed_bonus") && attack_speed_bonus > 0) {
                    current_attack_speed = attack_speed * (1 + attack_speed_bonus / 100);
                }
                attack_timer = 1 / current_attack_speed;
                LOG_CAT("  attack_timer сброшен: " + string(attack_timer), "combat");
            }
        }
    }
}
/// @function archer_state_fighting(_archer_instance)
/// @desc Обработка состояния БОЯ лучника с поддержкой критов, кровотечения и двойного выстрела

function archer_state_fighting(_archer_instance) {
    if (!instance_exists(_archer_instance)) return;
    
    with (_archer_instance) {
        // 1. Проверяем что цель существует и жива
        if (!instance_exists(fight_target)) {
            // Сохраняем переменные для поиска
            var archer_attack_range = attack_range_moving;
            var archer_x = x;
            var archer_y = y;
            
            // Если цель пропала - ищем нового врага
            var new_enemy = noone;
            var closest_dist = archer_attack_range;
            
            with (obj_enemy_base) {
                if (alive && x > archer_x) {
                    var dist = point_distance(x, y, archer_x, archer_y);
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
        var archer_attack_range = attack_range_moving;
        
        // 3. Если враг слишком далеко - возвращаемся к движению
        if (dist_to_enemy > archer_attack_range + 50) {
            state = STATE_MOVING;
            fight_target = noone;
            return;
        }
        
        // 4. Стреляем во врага
        attack_timer -= 1 / room_speed;
        if (attack_timer <= 0) {
            LOG_CAT("ЛУЧНИК АТАКУЕТ!", "combat");
            
            // Сохраняем базовый урон
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
            
            // Создаем первую стрелу
            scr_create_arrow(id, fight_target, final_damage);
            
            // ===== ДВОЙНОЙ ВЫСТРЕЛ =====
            var double_shot = false;
            if (variable_instance_exists(id, "double_shot_chance") && double_shot_chance > 0) {
                var double_roll = random(100);
                if (double_roll < double_shot_chance) {
                    double_shot = true;
                    LOG_CAT("🎯 ДВОЙНОЙ ВЫСТРЕЛ! Шанс: " + string(double_shot_chance) + 
                              "% (выпало: " + string(double_roll) + "%)", "combat");
                }
            }
            
            // Если двойной выстрел - создаем вторую стрелу с задержкой
            if (double_shot) {
                // Сохраняем данные для второго выстрела
                second_shot_target = fight_target;
                second_shot_damage = final_damage;
                // Задержка 0.1 секунды (6 кадров при 60 FPS)
                alarm[1] = 6;
            }
            
            // ===== ВАМПИРИЗМ (LIFESTEAL) =====
            if (variable_instance_exists(id, "lifesteal") && lifesteal > 0) {
                var heal_amount = floor(final_damage * lifesteal / 100);
                if (heal_amount > 0) {
                    var old_hp = hp;
                    hp = min(max_hp, hp + heal_amount);
                    var actual_heal = hp - old_hp;
                    if (actual_heal > 0) {
                        LOG_CAT("💉 ВАМПИРИЗМ: +" + string(actual_heal) + " HP (урон: " + string(final_damage) + 
                                  ", " + string(lifesteal) + "% = " + string(heal_amount) + 
                                  ", HP: " + string(floor(old_hp)) + " → " + string(floor(hp)) + ")", "vampire");
                    }
                }
            }
            
            // ===== КРОВОТЕЧЕНИЕ (BLEED) =====
            if (variable_instance_exists(id, "bleed_damage") && bleed_damage > 0) {
                // Инициализируем переменные на враге, если их нет
                if (!variable_instance_exists(fight_target, "bleed_stacks")) {
                    fight_target.bleed_stacks = 0;
                    fight_target.bleed_timer = 0;
                    fight_target.bleed_damage_per_stack = 0;
                }
                
                // Устанавливаем урон за стек ТОЛЬКО если он еще не установлен
                // или если он меньше текущего (для случая апгрейда)
                if (fight_target.bleed_damage_per_stack < bleed_damage) {
                    fight_target.bleed_damage_per_stack = bleed_damage;
                    LOG_CAT("🩸 Урон кровотечения за стек обновлен: " + string(bleed_damage), "bleed");
                }
                
                // Добавляем стек кровотечения
                fight_target.bleed_stacks += 1;
                
                // Сбрасываем таймер кровотечения (продлеваем эффект)
                fight_target.bleed_timer = 3.0;
                
                var total_bleed_damage = fight_target.bleed_stacks * fight_target.bleed_damage_per_stack;
                LOG_CAT("🩸 КРОВОТЕЧЕНИЕ: +1 стек (всего " + string(fight_target.bleed_stacks) + 
                          ", урон/сек: " + string(total_bleed_damage) + 
                          ", урон/стек: " + string(fight_target.bleed_damage_per_stack) + ")", "bleed");
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
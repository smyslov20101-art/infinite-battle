/// @function hero_state_idle(_hero_instance)
/// @desc Обработка состояния ПОКОЙ героя с поддержкой прорубающего урона, вампиризма, кровотечения и двойной атаки

function hero_state_idle(_hero_instance) {
    if (!instance_exists(_hero_instance)) return;
    
    with (_hero_instance) {
        // ===== ПРОВЕРКА ЦЕЛЕВОЙ ПОЗИЦИИ =====
        var dist_to_target = point_distance(x, y, target_x, target_y);
        if (dist_to_target > 10) {
            state = STATE_MOVING;
            return;
        }
        
        var hero_attack_range = attack_range_idle;
        var hero_x = x;
        var hero_y = y;
        var hero_damage = damage;
        
        // 1. Ищем врагов спереди
        var enemy_nearby = false;
        var enemy_to_attack = noone;
        var closest_distance = hero_attack_range;
        
        with (obj_enemy_base) {
            if (hp > 0) {
                var dist = point_distance(x, y, hero_x, hero_y);
                
                if (dist < hero_attack_range) {
                    enemy_nearby = true;
                    
                    if (dist < closest_distance) {
                        enemy_to_attack = id;
                        closest_distance = dist;
                    }
                }
            }
        }
        
        // 2. Если нашли врага - атакуем
        if (enemy_nearby && instance_exists(enemy_to_attack)) {
            attack_timer -= 1 / room_speed;
            
            if (attack_timer <= 0) {
                LOG_CAT("🔥🔥🔥 ГЕРОЙ АТАКУЕТ В IDLE!", "combat");
                
                // Сохраняем урон до возможных модификаторов
                var final_damage = hero_damage;
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
                        LOG_CAT("💥 КРИТИЧЕСКИЙ УДАР! Урон: " + string(final_damage) + 
                                  " (x" + string(crit_mult) + "), шанс: " + string(crit_chance) + "%", "combat");
                    }
                }
                
                // Наносим урон основному врагу
                scr_enemy_take_damage(enemy_to_attack, final_damage);

                // ===== КЛАСС-СПЕЦИФИЧНЫЕ ON-HIT ЭФФЕКТЫ =====
                // Тот же вызов есть в scr_hero_state_fighting. Раньше эффекты
                // (dark_blade, метки паладина) были только в fighting и почти
                // не срабатывали — герой ближнего боя бьёт в основном из idle.
                scr_apply_class_onhit(id, enemy_to_attack);

                // ===== ДВОЙНАЯ АТАКА (DOUBLE ATTACK) =====
                if (variable_instance_exists(id, "double_attack_chance") && double_attack_chance > 0) {
                    LOG_CAT("🎯 ПРОВЕРКА ДВОЙНОЙ АТАКИ В IDLE! Шанс: " + string(double_attack_chance) + "%", "combat");
                    var double_roll = random(100);
                    LOG_CAT("  Выпало: " + string(double_roll), "combat");
                    
                    if (double_roll < double_attack_chance) {
                        scr_enemy_take_damage(enemy_to_attack, final_damage);
                        LOG_CAT("⚔️ ДВОЙНАЯ АТАКА СРАБОТАЛА! +" + string(final_damage) + 
                                  " урона (шанс: " + string(double_attack_chance) + 
                                  "%, выпало: " + string(double_roll) + "%)", "combat");
                    } else {
                        LOG_CAT("❌ ДВОЙНАЯ АТАКА НЕ СРАБОТАЛА (выпало " + string(double_roll) + 
                                  " >= " + string(double_attack_chance) + ")", "combat");
                    }
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
                    if (!variable_instance_exists(enemy_to_attack, "bleed_stacks")) {
                        enemy_to_attack.bleed_stacks = 0;
                        enemy_to_attack.bleed_timer = 0;
                        enemy_to_attack.bleed_damage_per_stack = 0;
                    }
                    
                    if (enemy_to_attack.bleed_damage_per_stack < bleed_damage) {
                        enemy_to_attack.bleed_damage_per_stack = bleed_damage;
                        LOG_CAT("🩸 Урон кровотечения за стек обновлен: " + string(bleed_damage), "bleed");
                    }
                    
                    enemy_to_attack.bleed_stacks += 1;
                    enemy_to_attack.bleed_timer = 3.0;
                    
                    var total_bleed_damage = enemy_to_attack.bleed_stacks * enemy_to_attack.bleed_damage_per_stack;
                    LOG_CAT("🩸 КРОВОТЕЧЕНИЕ: +1 стек (всего " + string(enemy_to_attack.bleed_stacks) + 
                              ", урон/сек: " + string(total_bleed_damage) + 
                              ", урон/стек: " + string(enemy_to_attack.bleed_damage_per_stack) + ")", "bleed");
                }
				
				// ===== БОЛЬШОЕ КРОВОТЕЧЕНИЕ (BIG BLEED) =====
if (variable_instance_exists(id, "big_bleed_chance") && big_bleed_chance > 0) {
    var bleed_roll = random(100);
    if (bleed_roll < big_bleed_chance) {
        if (!variable_instance_exists(fight_target, "big_bleed_timer")) {
            fight_target.big_bleed_timer = 0;
        }
        fight_target.big_bleed_timer = 3.0; // 3 секунды
        fight_target.big_bleed_damage = big_bleed_damage;
        LOG_CAT("🩸💥 БОЛЬШОЕ КРОВОТЕЧЕНИЕ! " + string(big_bleed_damage) + " урона/сек на 3 сек (шанс: " + 
                  string(big_bleed_chance) + "%, выпало: " + string(bleed_roll) + "%)", "combat");
    }
}

// ===== ЗАМЕДЛЕНИЕ АТАКИ ВРАГА (ATTACK SPEED SLOW) =====
if (variable_instance_exists(id, "attack_speed_slow_chance") && attack_speed_slow_chance > 0) {
    var slow_roll = random(100);
    if (slow_roll < attack_speed_slow_chance) {
        if (!variable_instance_exists(fight_target, "attack_speed_slow_timer")) {
            fight_target.attack_speed_slow_timer = 0;
            fight_target.original_attack_speed = fight_target.attack_speed;
        }
        fight_target.attack_speed_slow_timer = 5.0; // 5 секунд
        fight_target.attack_speed = fight_target.original_attack_speed * (1 - attack_speed_slow_percent / 100);
        LOG_CAT("🐢 ЗАМЕДЛЕНИЕ АТАКИ! Скорость атаки врага снижена на " + string(attack_speed_slow_percent) + 
                  "% на 5 сек (шанс: " + string(attack_speed_slow_chance) + "%, выпало: " + string(slow_roll) + "%)", "combat");
    }
}
                
                // ===== ПРОРУБАЮЩИЙ УРОН (CLEAVE) =====
                var has_cleave = false;
                var cleave_dmg = 0;
                
                if (variable_instance_exists(id, "cleave_percent") && cleave_percent > 0) {
                    has_cleave = true;
                    cleave_damage = floor(final_damage * cleave_percent / 100);
                    cleave_dmg = cleave_damage;
                    LOG_CAT("⚡ CLEAVE активирован в IDLE: " + string(cleave_percent) + "%, урон: " + string(cleave_dmg), "cleave");
                }
                
                if (has_cleave && cleave_dmg > 0) {
                    var second_target = noone;
                    var closest_dist = 250;
                    var attacker_x = x;
                    var attacker_y = y;
                    var current_target = enemy_to_attack;
                    
                    LOG_CAT("🔍 Ищем вторую цель в радиусе " + string(closest_dist), "cleave");
                    
                    with (obj_enemy_base) {
                        if (id != current_target && alive && hp > 0) {
                            var dist = point_distance(x, y, attacker_x, attacker_y);
                            if (dist < closest_dist) {
                                second_target = id;
                                closest_dist = dist;
                                LOG_CAT("  Найдена цель на расстоянии " + string(dist), "cleave");
                            }
                        }
                    }
                    
                    if (instance_exists(second_target)) {
                        scr_enemy_take_damage(second_target, cleave_dmg);
                        LOG_CAT("⚡ Прорубающий урон по второй цели в IDLE: " + string(cleave_dmg), "cleave");
                    } else {
                        LOG_CAT("⚡ Нет второй цели для прорубающего урона в радиусе " + string(closest_dist), "cleave");
                    }
                }
                
                // Сбрасываем таймер атаки
                var current_attack_speed = attack_speed;
                if (variable_instance_exists(id, "attack_speed_bonus") && attack_speed_bonus > 0) {
                    current_attack_speed = attack_speed * (1 + attack_speed_bonus / 100);
                }
                attack_timer = 1 / current_attack_speed;
                
                // Визуальный эффект удара
                image_blend = c_white;
                alarm[0] = 5;
            }
        }
    }
}
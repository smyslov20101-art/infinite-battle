/// @function elf_archer_state_idle(_elf_archer_instance)
/// @desc Обработка состояния ПОКОЙ эльфийского лучника (с поддержкой критов, двойного выстрела и оглушения)

function elf_archer_state_idle(_elf_archer_instance) {
    if (!instance_exists(_elf_archer_instance)) return;
    
    with (_elf_archer_instance) {
        // Проверяем, на месте ли мы
        var dist_to_target = point_distance(x, y, target_x, target_y);
        if (dist_to_target > 10) {
            state = STATE_MOVING;
            return;
        }
        
        // Ищем ближайшего врага
        var closest_enemy = noone;
        var closest_distance = attack_range_idle;
        var archer_x = x;
        var archer_y = y;
        
        with (obj_enemy_base) {
            if (alive && hp > 0 && x > archer_x) {
                var dist = point_distance(x, y, archer_x, archer_y);
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
                LOG_CAT("🏹 ЭЛЬФИЙСКИЙ ЛУЧНИК АТАКУЕТ В IDLE! Цель: " + string(closest_enemy.object_index), "combat");
                
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
                
                // Создаем болт
                scr_create_bolt(id, closest_enemy, final_damage);
                
                // ===== ДВОЙНОЙ ВЫСТРЕЛ =====
                if (variable_instance_exists(id, "double_shot_chance") && double_shot_chance > 0) {
                    var double_roll = random(100);
                    if (double_roll < double_shot_chance) {
                        second_shot_target = closest_enemy;
                        second_shot_damage = final_damage;
                        alarm[1] = 6;
                        LOG_CAT("🎯 ДВОЙНОЙ ВЫСТРЕЛ! Шанс: " + string(double_shot_chance) + 
                                  "%, выпало: " + string(double_roll) + "%", "combat");
                    }
                }
                
                // ===== ОГЛУШЕНИЕ ПРИ АТАКЕ =====
                if (variable_instance_exists(id, "stun_on_hit_chance") && stun_on_hit_chance > 0) {
                    var stun_roll = random(100);
                    if (stun_roll < stun_on_hit_chance) {
                        if (!variable_instance_exists(closest_enemy, "stun_timer")) {
                            closest_enemy.stun_timer = 0;
                        }
                        closest_enemy.stun_timer = stun_duration;
                        LOG_CAT("💫 ОГЛУШЕНИЕ СРАБОТАЛО! Враг оглушен на " + string(stun_duration) + 
                                  " сек (шанс: " + string(stun_on_hit_chance) + "%, выпало: " + string(stun_roll) + "%)", "combat");
                    }
                }
                
                // ===== ВАМПИРИЗМ =====
                if (variable_instance_exists(id, "lifesteal") && lifesteal > 0) {
                    var heal_amount = floor(final_damage * lifesteal / 100);
                    if (heal_amount > 0) {
                        var old_hp = hp;
                        hp = min(max_hp, hp + heal_amount);
                        var actual_heal = hp - old_hp;
                        if (actual_heal > 0) {
                            LOG_CAT("💉 ВАМПИРИЗМ: +" + string(actual_heal) + " HP", "vampire");
                        }
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
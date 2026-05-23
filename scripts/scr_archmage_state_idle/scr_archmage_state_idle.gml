/// @function archmage_state_idle(_instance)
/// @desc Обработка состояния ПОКОЙ Архимага

function archmage_state_idle(_instance) {
    if (!instance_exists(_instance)) return;
    
    with (_instance) {
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
        
        with (obj_enemy_base) {
            if (alive && hp > 0 && x > mage_x) {
                var dist = point_distance(x, y, mage_x, mage_y);
                if (dist < closest_distance) {
                    closest_enemy = id;
                    closest_distance = dist;
                }
            }
        }
        
        // Также проверяем тестовых манекенов
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
                LOG_CAT("🔮 АРХИМАГ АТАКУЕТ В IDLE! Цель: " + string(closest_enemy.object_index), "combat");
                
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
                scr_create_archmage_bolt(id, closest_enemy, final_damage);
                
                // ===== СВЯТОЕ ОТРАВЛЕНИЕ =====
                if (variable_instance_exists(id, "holy_poison_percent") && holy_poison_percent > 0) {
                    if (!variable_instance_exists(closest_enemy, "holy_poison_timer")) {
                        closest_enemy.holy_poison_timer = 0;
                        closest_enemy.holy_poison_damage = 0;
                        closest_enemy.holy_poison_damage_timer = 0;
                    }
                    var poison_damage = floor(final_damage * holy_poison_percent / 100);
                    poison_damage = max(1, poison_damage);
                    closest_enemy.holy_poison_timer = 3.0;
                    closest_enemy.holy_poison_damage = poison_damage;
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
            }
        }
    }
}
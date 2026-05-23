/// @function priest_state_idle(_priest_instance)
/// @desc Обработка состояния ПОКОЙ жреца (лечение и баффы)

function priest_state_idle(_priest_instance) {
    if (!instance_exists(_priest_instance)) return;
    
    with (_priest_instance) {
        // Проверяем, на месте ли мы
        var dist_to_target = point_distance(x, y, target_x, target_y);
        if (dist_to_target > 10) {
            state = STATE_MOVING;
            return;
        }
        
        // ===== ЛЕЧЕНИЕ (как было) =====
        heal_timer -= 1 / room_speed;
        
        if (heal_timer <= 0) {
            var priest_range = heal_range;
            var priest_x = x;
            var priest_y = y;
            var priest_healing = healing_power;
            
            // Ищем героя с наименьшим процентом здоровья
            var best_target = noone;
            var lowest_hp_percent = 1.0;
            
            with (obj_hero_base) {
                if (id != _priest_instance && hp > 0 && state != STATE_DEAD) {
                    var dist = point_distance(x, y, priest_x, priest_y);
                    if (dist < priest_range && hp < max_hp) {
                        var hp_percent = hp / max_hp;
                        if (hp_percent < lowest_hp_percent) {
                            best_target = id;
                            lowest_hp_percent = hp_percent;
                        }
                    }
                }
            }
            
            // Лечим
            if (instance_exists(best_target)) {
                with (best_target) {
                    var old_hp = hp;
                    hp = min(max_hp, hp + priest_healing);
                    var healed_amount = hp - old_hp;
                    LOG_CAT("💚 Жрец вылечил " + string(healed_amount) + " HP. Цель: " + string(object_index) + 
                              ", HP: " + string(floor(hp)) + "/" + string(max_hp), "combat");
                }
            }
            
            // Сбрасываем таймер лечения
            heal_timer = 2.5;
        }
        
        // ===== БАФФЫ =====
        // Проверяем шанс срабатывания
        var chance_roll = random(100);
        
        if (chance_roll < buff_chance) {
            // Бафф для мага (увеличение урона)
            if (buff_mage_percent > 0) {
                var mage_found = false;
                with (obj_hero_base) {
                    if (hero_class == global.CLASS_MAGE && hp > 0 && state != STATE_DEAD) {
                        mage_found = true;
                        
                        // Сохраняем оригинальный урон если еще не сохранен
                        if (!variable_instance_exists(id, "original_damage_for_buff")) {
                            original_damage_for_buff = damage;
                        }
                        
                        // Применяем бафф
                        var buff_mult = 1 + (other.buff_mage_percent / 100);
                        damage = original_damage_for_buff * buff_mult;
                        
                        // Устанавливаем таймер баффа
                        if (!variable_instance_exists(id, "mage_buff_timer")) {
                            mage_buff_timer = 0;
                        }
                        mage_buff_timer = 3.0;
                        
                        LOG_CAT("✨ БАФФ МАГА! Урон увеличен на " + string(other.buff_mage_percent) + 
                                  "% (было " + string(original_damage_for_buff) + " → " + string(damage) + 
                                  "), цель: " + string(object_index), "combat");
                    }
                }
                if (!mage_found) {
                    LOG_CAT("✨ Нет мага в отряде для баффа", "combat");
                }
            }
            
            // Бафф для лучника (увеличение скорости атаки)
            if (buff_archer_percent > 0) {
                var archer_found = false;
                with (obj_hero_base) {
                    if (hero_class == global.CLASS_RANGED && hp > 0 && state != STATE_DEAD) {
                        archer_found = true;
                        
                        // Сохраняем оригинальную скорость атаки если еще не сохранена
                        if (!variable_instance_exists(id, "original_attack_speed_for_buff")) {
                            original_attack_speed_for_buff = attack_speed;
                        }
                        
                        // Применяем бафф
                        var buff_mult = 1 + (other.buff_archer_percent / 100);
                        attack_speed = original_attack_speed_for_buff * buff_mult;
                        
                        // Обновляем таймер атаки
                        if (attack_timer > 0) {
                            attack_timer = attack_timer / buff_mult;
                        }
                        
                        // Устанавливаем таймер баффа
                        if (!variable_instance_exists(id, "archer_buff_timer")) {
                            archer_buff_timer = 0;
                        }
                        archer_buff_timer = 3.0;
                        
                        LOG_CAT("🏹✨ БАФФ ЛУЧНИКА! Скорость атаки увеличена на " + string(other.buff_archer_percent) + 
                                  "% (было " + string(original_attack_speed_for_buff) + " → " + string(attack_speed) + 
                                  "), цель: " + string(object_index), "combat");
                    }
                }
                if (!archer_found) {
                    LOG_CAT("🏹✨ Нет лучника в отряде для баффа", "combat");
                }
            }
        }
    }
}
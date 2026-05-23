/// @function healer_state_idle(_healer_instance)
/// @desc Обработка состояния ПОКОЙ хилера (лечение и восстановление щита)

function healer_state_idle(_healer_instance) {
    if (!instance_exists(_healer_instance)) return;
    
    with (_healer_instance) {
        // Проверяем, на месте ли мы
        var dist_to_target = point_distance(x, y, target_x, target_y);
        if (dist_to_target > 10) {
            state = STATE_MOVING;
            return;
        }
        
        // Лечение происходит по таймеру (раз в 3 секунды)
        heal_timer -= 1 / room_speed;
        
        if (heal_timer <= 0) {
            var healer_range = heal_range;
            var healer_x = x;
            var healer_y = y;
            var healer_healing = healing_power;
            var healer_shield_regen = shield_regen;
            var healer_multi_chance = multi_heal_chance;
            
            // ===== 1. Собираем всех раненых героев в радиусе =====
            var injured_heroes = [];
            
            with (obj_hero_base) {
                if (id != _healer_instance && hp > 0 && state != STATE_DEAD) {
                    var dist = point_distance(x, y, healer_x, healer_y);
                    if (dist < healer_range) {
                        var hp_percent = hp / max_hp;
                        if (hp < max_hp) {
                            array_push(injured_heroes, {
                                id: id,
                                hp: hp,
                                max_hp: max_hp,
                                hp_percent: hp_percent,
                                has_shield: variable_instance_exists(id, "shield") ? shield : 0
                            });
                        }
                    }
                }
            }
            
            // ===== 2. Лечение =====
            var healed_count = 0;
            
            if (array_length(injured_heroes) > 0) {
                // Сортируем по проценту HP (самые низкие первые)
                for (var i = 0; i < array_length(injured_heroes) - 1; i++) {
                    for (var j = i + 1; j < array_length(injured_heroes); j++) {
                        if (injured_heroes[i].hp_percent > injured_heroes[j].hp_percent) {
                            var temp = injured_heroes[i];
                            injured_heroes[i] = injured_heroes[j];
                            injured_heroes[j] = temp;
                        }
                    }
                }
                
                // Лечим первую цель
                var target = injured_heroes[0];
                with (target.id) {
                    var old_hp = hp;
                    hp = min(max_hp, hp + healer_healing);
                    var healed_amount = hp - old_hp;
                    healed_count++;
                    LOG_CAT("💚 Хилер вылечил " + string(healed_amount) + " HP. Цель: " + string(object_index) + 
                              ", HP: " + string(floor(hp)) + "/" + string(max_hp), "combat");
                }
                
                // ===== ПРОВЕРКА НА ЛЕЧЕНИЕ ВТОРОЙ ЦЕЛИ =====
                if (array_length(injured_heroes) > 1 && healer_multi_chance > 0) {
                    var multi_roll = random(100);
                    if (multi_roll < healer_multi_chance) {
                        var second_target = injured_heroes[1];
                        with (second_target.id) {
                            var old_hp = hp;
                            hp = min(max_hp, hp + healer_healing);
                            var healed_amount = hp - old_hp;
                            healed_count++;
                            LOG_CAT("💚👥 Хилер вылечил вторую цель! +" + string(healed_amount) + 
                                      " HP. Цель: " + string(object_index) + 
                                      ", шанс: " + string(healer_multi_chance) + "%", "combat");
                        }
                    }
                }
            }
            
            // ===== 3. Восстановление щита (исправлено) =====
            if (healer_shield_regen > 0) {
                var shield_heroes = [];
                
                with (obj_hero_base) {
                    if (id != _healer_instance && hp > 0 && state != STATE_DEAD) {
                        var dist = point_distance(x, y, healer_x, healer_y);
                        if (dist < healer_range) {
                            // Проверяем, есть ли у героя щит
                            if (variable_instance_exists(id, "shield")) {
                                var current_shield = shield;
                                var max_shield_val = current_shield;
                                
                                // Проверяем наличие max_shield
                                if (variable_instance_exists(id, "max_shield")) {
                                    max_shield_val = max_shield;
                                }
                                
                                if (current_shield < max_shield_val) {
                                    array_push(shield_heroes, {
                                        id: id,
                                        shield: current_shield,
                                        max_shield: max_shield_val,
                                        shield_percent: current_shield / max_shield_val
                                    });
                                }
                            }
                        }
                    }
                }
                
                if (array_length(shield_heroes) > 0) {
                    // Сортируем по проценту щита (самые низкие первые)
                    for (var i = 0; i < array_length(shield_heroes) - 1; i++) {
                        for (var j = i + 1; j < array_length(shield_heroes); j++) {
                            if (shield_heroes[i].shield_percent > shield_heroes[j].shield_percent) {
                                var temp = shield_heroes[i];
                                shield_heroes[i] = shield_heroes[j];
                                shield_heroes[j] = temp;
                            }
                        }
                    }
                    
                    // Восстанавливаем щит первой цели
                    var shield_target = shield_heroes[0];
                    with (shield_target.id) {
                        var old_shield = shield;
                        var max_shield_val = shield_target.max_shield;
                        shield = min(max_shield_val, shield + healer_shield_regen);
                        var regened = shield - old_shield;
                        if (regened > 0) {
                            LOG_CAT("🛡️ Хилер восстановил щит на " + string(regened) + 
                                      ". Цель: " + string(object_index) + 
                                      ", щит: " + string(floor(shield)) + "/" + string(max_shield_val), "combat");
                        }
                    }
                }
            }
            
            if (healed_count == 0 && healer_shield_regen == 0) {
                LOG_CAT("💚 Хилер: нет целей для лечения или восстановления щита", "combat");
            } else if (healed_count > 0) {
                LOG_CAT("💚 Хилер вылечил " + string(healed_count) + " целей", "combat");
            }
            
            // Сбрасываем таймер лечения (раз в 3 секунды)
            heal_timer = 3.0;
        }
    }
}
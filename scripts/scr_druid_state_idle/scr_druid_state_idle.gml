/// scr_druid_state_idle.gml
function druid_state_idle(_instance) {
    if (!instance_exists(_instance)) return;
    
    with (_instance) {
        // ===== ЗАЩИТА ОТ ОШИБОК - ИНИЦИАЛИЗАЦИЯ ПЕРЕМЕННЫХ =====
        if (!variable_instance_exists(id, "heal_timer")) heal_timer = 2.5;
        if (!variable_instance_exists(id, "heal_aura_tick_timer")) heal_aura_tick_timer = 0;
        if (!variable_instance_exists(id, "last_stand_triggered")) last_stand_triggered = false;
        if (!variable_instance_exists(id, "heal_aura_timer")) heal_aura_timer = 0;
        if (!variable_instance_exists(id, "heal_aura_cooldown")) heal_aura_cooldown = 0;
        if (!variable_instance_exists(id, "dodge_aura_timer")) dodge_aura_timer = 0;
        if (!variable_instance_exists(id, "dodge_aura_cooldown")) dodge_aura_cooldown = 0;
        if (!variable_instance_exists(id, "dr_aura_timer")) dr_aura_timer = 0;
        if (!variable_instance_exists(id, "dr_aura_cooldown")) dr_aura_cooldown = 0;
        if (!variable_instance_exists(id, "druid_buff_melee_cooldown")) druid_buff_melee_cooldown = 0;
        if (!variable_instance_exists(id, "last_stand_cooldown")) last_stand_cooldown = 0;
        if (!variable_instance_exists(id, "save_melee_cooldown")) save_melee_cooldown = 0;
        if (!variable_instance_exists(id, "protect_melee_cooldown")) protect_melee_cooldown = 0;
        
        var dist_to_target = point_distance(x, y, target_x, target_y);
        if (dist_to_target > 10) {
            state = STATE_MOVING;
            return;
        }
        
        // ===== 1. ОБЫЧНОЕ ЛЕЧЕНИЕ (базовое, как у хилера) =====
        heal_timer -= 1 / room_speed;
        if (heal_timer <= 0) {
            var best_target = noone;
            var lowest_hp_percent = 1.0;
            
            with (obj_hero_base) {
                if (id != _instance && hp > 0 && state != STATE_DEAD && hp < max_hp) {
                    var dist = point_distance(x, y, other.x, other.y);
                    if (dist < other.heal_range) {
                        var hp_percent = hp / max_hp;
                        if (hp_percent < lowest_hp_percent) {
                            best_target = id;
                            lowest_hp_percent = hp_percent;
                        }
                    }
                }
            }
            
            if (instance_exists(best_target)) {
                with (best_target) {
                    var old_hp = hp;
                    hp = min(max_hp, hp + other.healing_power);
                    var healed = hp - old_hp;
                    if (healed > 0) {
                        LOG_CAT("💚 Друид вылечил " + string(healed) + " HP (базовое лечение)", "combat");
                    }
                }
            }
            
            heal_timer = 2.5;
        }
        
        // ===== 2. АКТИВНАЯ АУРА ЛЕЧЕНИЯ (пока активна) =====
        if (heal_aura_percent > 0 && heal_aura_timer > 0) {
            heal_aura_tick_timer -= 1 / room_speed;
            
            if (heal_aura_tick_timer <= 0) {
                var healed_count = 0;
                with (obj_hero_base) {
                    if (hp > 0 && state != STATE_DEAD) {
                        var dist = point_distance(x, y, other.x, other.y);
                        if (dist < other.heal_range) {
                            var heal_amount = floor(max_hp * other.heal_aura_percent / 100);
                            if (heal_amount > 0) {
                                var old_hp = hp;
                                hp = min(max_hp, hp + heal_amount);
                                if (hp > old_hp) {
                                    healed_count++;
                                    LOG_CAT("💚🌿 Аура лечения: +" + string(heal_amount) + " HP (" + string(other.heal_aura_percent) + "%) для " + string(object_index), "combat");
                                }
                            }
                        }
                    }
                }
                if (healed_count > 0) {
                    LOG_CAT("💚🌿 Аура лечения вылечила " + string(healed_count) + " союзников", "combat");
                }
                heal_aura_tick_timer = 1.0;
            }
        }
        
        // ===== 3. АВТОМАТИЧЕСКАЯ АКТИВАЦИЯ АУР =====
        // Проверяем, есть ли союзники в радиусе
        var allies_in_range = 0;
        with (obj_hero_base) {
            if (hp > 0 && state != STATE_DEAD) {
                var dist = point_distance(x, y, other.x, other.y);
                if (dist < other.heal_range) {
                    allies_in_range++;
                }
            }
        }
        
        // Приоритет: Лечение > Снижение урона > Уклонение
        
        // 3.1 АУРА ЛЕЧЕНИЯ (приоритет 1)
        if (heal_aura_percent > 0 && heal_aura_cooldown <= 0 && heal_aura_timer <= 0 && allies_in_range > 0) {
            heal_aura_timer = 3.0;
            heal_aura_cooldown = heal_aura_cooldown_max;
            heal_aura_tick_timer = 0;
            LOG_CAT("💚🌿 АУРА ЛЕЧЕНИЯ АВТОМАТИЧЕСКИ АКТИВИРОВАНА! Лечение " + string(heal_aura_percent) + "% HP/сек на 3 сек", "combat");
        }
        
        // 3.2 АУРА СНИЖЕНИЯ УРОНА (приоритет 2, если аура лечения не активна и не в КД)
        else if (dr_aura_percent > 0 && dr_aura_cooldown <= 0 && dr_aura_timer <= 0 && allies_in_range > 0) {
            dr_aura_timer = 5.0;
            dr_aura_cooldown = dr_aura_cooldown_max;
            
            // Применяем бафф ко всем союзникам
            with (obj_hero_base) {
                if (hp > 0 && state != STATE_DEAD) {
                    var dist = point_distance(x, y, other.x, other.y);
                    if (dist < other.heal_range) {
                        if (!variable_instance_exists(id, "dr_aura_bonus")) {
                            dr_aura_bonus = 0;
                        }
                        dr_aura_bonus += other.dr_aura_percent;
                        if (!variable_instance_exists(id, "damage_reduction_percent")) {
                            damage_reduction_percent = 0;
                        }
                        damage_reduction_percent += other.dr_aura_percent;
                        LOG_CAT("🛡️🌿 Аура снижения урона: -" + string(other.dr_aura_percent) + "% урона для " + string(object_index), "combat");
                    }
                }
            }
            LOG_CAT("🛡️🌿 АУРА СНИЖЕНИЯ УРОНА АВТОМАТИЧЕСКИ АКТИВИРОВАНА! -" + string(dr_aura_percent) + "% урона на 5 сек", "combat");
        }
        
        // 3.3 АУРА УКЛОНЕНИЯ (приоритет 3, если другие ауры не активны)
        else if (dodge_aura_percent > 0 && dodge_aura_cooldown <= 0 && dodge_aura_timer <= 0 && allies_in_range > 0) {
            dodge_aura_timer = 3.0;
            dodge_aura_cooldown = dodge_aura_cooldown_max;
            
            // Применяем бафф ко всем союзникам
            with (obj_hero_base) {
                if (hp > 0 && state != STATE_DEAD) {
                    var dist = point_distance(x, y, other.x, other.y);
                    if (dist < other.heal_range) {
                        if (!variable_instance_exists(id, "dodge_aura_bonus")) {
                            dodge_aura_bonus = 0;
                        }
                        dodge_aura_bonus += other.dodge_aura_percent;
                        if (!variable_instance_exists(id, "dodge_chance")) {
                            dodge_chance = 0;
                        }
                        dodge_chance += other.dodge_aura_percent;
                        LOG_CAT("🌀🌿 Аура уклонения: +" + string(other.dodge_aura_percent) + "% уклонения для " + string(object_index), "combat");
                    }
                }
            }
            LOG_CAT("🌀🌿 АУРА УКЛОНЕНИЯ АВТОМАТИЧЕСКИ АКТИВИРОВАНА! +" + string(dodge_aura_percent) + "% уклонения на 3 сек", "combat");
        }
        
        // ===== 4. АКТИВНАЯ АУРА СНИЖЕНИЯ УРОНА =====
        if (dr_aura_percent > 0 && dr_aura_timer > 0) {
            // Аура активна - бафф уже применен при активации
        }
        
        // ===== 5. АКТИВНАЯ АУРА УКЛОНЕНИЯ =====
        if (dodge_aura_percent > 0 && dodge_aura_timer > 0) {
            // Аура активна - бафф уже применен при активации
        }
        
        // ===== 6. LAST STAND (регенерация при низком HP) =====
        if (last_stand_percent > 0 && !last_stand_triggered && last_stand_cooldown <= 0) {
            var hp_percent = hp / max_hp * 100;
            if (hp_percent < 25) {
                var heal_amount = floor(max_hp * last_stand_percent / 100);
                var old_hp = hp;
                hp = min(max_hp, hp + heal_amount);
                last_stand_triggered = true;
                last_stand_cooldown = last_stand_cooldown_max;
                LOG_CAT("💪🔄 LAST STAND! Друид восстановил " + string(heal_amount) + " HP (" + string(last_stand_percent) + "%)", "combat");
            }
        }
        
        // ===== 7. СПАСЕНИЕ БЛИЖНИКА (SAVE MELEE) =====
        if (save_melee_percent > 0 && save_melee_cooldown <= 0) {
            with (obj_hero_base) {
                if (hero_class == global.CLASS_MELEE && hp > 0 && state != STATE_DEAD) {
                    var dist = point_distance(x, y, other.x, other.y);
                    if (dist < other.heal_range) {
                        var hp_percent = hp / max_hp * 100;
                        if (hp_percent < 10) {
                            var heal_amount = floor(max_hp * other.save_melee_percent / 100);
                            var old_hp = hp;
                            hp = min(max_hp, hp + heal_amount);
                            other.save_melee_cooldown = other.save_melee_cooldown_max;
                            LOG_CAT("💚🆘 ДРУИД СПАС БЛИЖНИКА! Вылечено " + string(heal_amount) + 
                                      " HP (" + string(other.save_melee_percent) + "%) для " + string(object_index), "combat");
                            break;
                        }
                    }
                }
            }
        }
        
        // ===== 8. ЗАЩИТА БЛИЖНИКА (PROTECT MELEE) =====
        if ((protect_melee_dodge > 0 || protect_melee_dr > 0) && protect_melee_cooldown <= 0) {
            with (obj_hero_base) {
                if (hero_class == global.CLASS_MELEE && hp > 0 && state != STATE_DEAD) {
                    var dist = point_distance(x, y, other.x, other.y);
                    if (dist < other.heal_range) {
                        var hp_percent = hp / max_hp * 100;
                        if (hp_percent < 15) {
                            // Применяем бафф защиты
                            if (!variable_instance_exists(id, "protect_melee_active")) {
                                protect_melee_active = false;
                                protect_melee_timer = 0;
                                protect_melee_dodge_bonus = 0;
                                protect_melee_dr_bonus = 0;
                            }
                            
                            protect_melee_active = true;
                            protect_melee_timer = other.protect_melee_duration;
                            protect_melee_dodge_bonus = other.protect_melee_dodge;
                            protect_melee_dr_bonus = other.protect_melee_dr;
                            
                            if (!variable_instance_exists(id, "dodge_chance")) {
                                dodge_chance = 0;
                            }
                            dodge_chance += protect_melee_dodge_bonus;
                            
                            if (!variable_instance_exists(id, "damage_reduction_percent")) {
                                damage_reduction_percent = 0;
                            }
                            damage_reduction_percent += protect_melee_dr_bonus;
                            
                            other.protect_melee_cooldown = other.protect_melee_cooldown_max;
                            
                            LOG_CAT("🛡️🆘 ДРУИД ЗАЩИТИЛ БЛИЖНИКА! +" + string(protect_melee_dodge_bonus) + 
                                      "% уклонения и -" + string(protect_melee_dr_bonus) + 
                                      "% урона для " + string(object_index) + " на " + string(other.protect_melee_duration) + " сек", "combat");
                            break;
                        }
                    }
                }
            }
        }
        
        // ===== 9. ТЕСТОВЫЕ КЛАВИШИ ДЛЯ РУЧНОЙ АКТИВАЦИИ (оставляем для отладки) =====
        // H - ручная активация ауры лечения
        if (keyboard_check_pressed(ord("H")) && heal_aura_percent > 0 && heal_aura_cooldown <= 0 && heal_aura_timer <= 0) {
            heal_aura_timer = 3.0;
            heal_aura_cooldown = heal_aura_cooldown_max;
            heal_aura_tick_timer = 0;
            LOG_CAT("💚🌿 Аура лечения активирована вручную! Лечение " + string(heal_aura_percent) + "% HP/сек", "combat");
        }
        
        // R - ручная активация ауры снижения урона
        if (keyboard_check_pressed(ord("R")) && dr_aura_percent > 0 && dr_aura_cooldown <= 0 && dr_aura_timer <= 0) {
            dr_aura_timer = 5.0;
            dr_aura_cooldown = dr_aura_cooldown_max;
            
            with (obj_hero_base) {
                if (hp > 0 && state != STATE_DEAD) {
                    var dist = point_distance(x, y, other.x, other.y);
                    if (dist < other.heal_range) {
                        if (!variable_instance_exists(id, "dr_aura_bonus")) {
                            dr_aura_bonus = 0;
                        }
                        dr_aura_bonus += other.dr_aura_percent;
                        if (!variable_instance_exists(id, "damage_reduction_percent")) {
                            damage_reduction_percent = 0;
                        }
                        damage_reduction_percent += other.dr_aura_percent;
                        LOG_CAT("🛡️🌿 Аура снижения урона: -" + string(other.dr_aura_percent) + "% урона для " + string(object_index), "combat");
                    }
                }
            }
            LOG_CAT("🛡️🌿 Аура снижения урона активирована вручную! -" + string(dr_aura_percent) + "% урона", "combat");
        }
        
        // D - ручная активация ауры уклонения
        if (keyboard_check_pressed(ord("D")) && dodge_aura_percent > 0 && dodge_aura_cooldown <= 0 && dodge_aura_timer <= 0) {
            dodge_aura_timer = 3.0;
            dodge_aura_cooldown = dodge_aura_cooldown_max;
            
            with (obj_hero_base) {
                if (hp > 0 && state != STATE_DEAD) {
                    var dist = point_distance(x, y, other.x, other.y);
                    if (dist < other.heal_range) {
                        if (!variable_instance_exists(id, "dodge_aura_bonus")) {
                            dodge_aura_bonus = 0;
                        }
                        dodge_aura_bonus += other.dodge_aura_percent;
                        if (!variable_instance_exists(id, "dodge_chance")) {
                            dodge_chance = 0;
                        }
                        dodge_chance += other.dodge_aura_percent;
                        LOG_CAT("🌀🌿 Аура уклонения: +" + string(other.dodge_aura_percent) + "% уклонения для " + string(object_index), "combat");
                    }
                }
            }
            LOG_CAT("🌀🌿 Аура уклонения активирована вручную! +" + string(dodge_aura_percent) + "% уклонения", "combat");
        }
    }
}
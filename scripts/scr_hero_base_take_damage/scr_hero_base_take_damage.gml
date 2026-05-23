/// @function scr_hero_base_take_damage(_hero_instance, _damage_amount, _is_projectile)
/// @desc Наносит урон герою с учетом брони, щита, уклонения и снижения урона

function scr_hero_base_take_damage(_hero_instance, _damage_amount, _is_projectile = false) {
    if (!instance_exists(_hero_instance)) return false;
    
    with (_hero_instance) {
        if (hp <= 0 || state == STATE_DEAD) return false;
        
        // ===== ПАЛАДИН: ТЕЛОХРАНИТЕЛЬ (получает урон вместо союзников) =====
        if (_damage_amount > 0 && hero_type != "paladin" && instance_exists(obj_paladin)) {
            var paladin = instance_find(obj_paladin, 0);
            if (instance_exists(paladin) && paladin.bodyguard_active_timer > 0) {
                LOG_CAT("🛡️👤 ТЕЛОХРАНИТЕЛЬ ЗАЩИТИЛ " + string(object_index) + "! Принял урон: " + string(_damage_amount), "combat");
                scr_hero_base_take_damage(paladin, _damage_amount, _is_projectile);
                return true;
            }
        }
        
        // ===== ДРУИД: ШАНС ПРИНЯТЬ УРОН ВМЕСТО СОЮЗНИКА =====
        if (_damage_amount > 0 && instance_exists(obj_druid) && !variable_instance_exists(id, "is_taunting")) {
            var druid = instance_find(obj_druid, 0);
            if (instance_exists(druid) && druid.hp > 0 && druid.taunt_chance > 0) {
                var taunt_roll = random(100);
                if (taunt_roll < druid.taunt_chance) {
                    druid.is_taunting = true;
                    scr_hero_base_take_damage(druid, _damage_amount, _is_projectile);
                    druid.is_taunting = false;
                    return true;
                }
            }
        }
        
        // ===== ПАЛАДИН: НЕУЯЗВИМОСТЬ =====
        if (hero_type == "paladin" && variable_instance_exists(id, "invuln_timer") && invuln_timer > 0) {
            LOG_CAT("🛡️💫 ПАЛАДИН НЕУЯЗВИМ! Урон " + string(_damage_amount) + " проигнорирован!", "combat");
            return false;
        }
        
        // ===== ПРОВЕРКА НА УКЛОНЕНИЕ (DODGE) =====
        if (variable_instance_exists(id, "dodge_chance") && dodge_chance > 0) {
            var dodge_roll = random(100);
            if (dodge_roll < dodge_chance) {
                LOG_CAT("✅ УКЛОНЕНИЕ! Шанс: " + string(dodge_chance) + 
                          "% (выпало: " + string(dodge_roll) + 
                          "%), урон: " + string(_damage_amount) + " отклонен!", "dodge");
                return false;
            }
        }
        
        // ===== СНИЖЕНИЕ ПОЛУЧАЕМОГО УРОНА (DAMAGE REDUCTION) =====
        var actual_damage = _damage_amount;
        if (variable_instance_exists(id, "damage_reduction_percent") && damage_reduction_percent > 0) {
            var reduction_percent = damage_reduction_percent;
            var reduced = floor(_damage_amount * reduction_percent / 100);
            actual_damage = _damage_amount - reduced;
            LOG_CAT("🛡️ СНИЖЕНИЕ УРОНА: -" + string(reduction_percent) + "% (" + string(reduced) + 
                      " урона поглощено, осталось: " + string(actual_damage) + ")", "combat");
        }
        
        // ===== ДЛЯ СНАРЯДОВ - ИГНОРИРУЕМ DAMAGE_COOLDOWN =====
        if (!_is_projectile) {
            if (damage_cooldown > 0) return false;
        }
        
        var absorbed = 0;
        
        // ===== ЩИТ (ПОГЛОЩАЕТ УРОН ПЕРВЫМ) =====
        if (variable_instance_exists(id, "shield") && shield > 0) {
            var shield_absorb = min(shield, actual_damage);
            shield -= shield_absorb;
            absorbed = shield_absorb;
            actual_damage -= shield_absorb;
            LOG_CAT("🛡️ ЩИТ поглотил " + string(absorbed) + " урона. Щит остался: " + string(shield), "combat");
        }
        
        // ===== БРОНЯ (ПОСТОЯННАЯ) =====
        if (actual_damage > 0 && variable_instance_exists(id, "armor") && armor > 0) {
            var armor_absorb = min(armor, actual_damage);
            actual_damage -= armor_absorb;
            absorbed += armor_absorb;
            LOG_CAT("🛡️ Броня поглотила " + string(armor_absorb) + " урона. Броня осталась: " + string(armor), "combat");
        }
        
        // ===== ВРЕМЕННАЯ БРОНЯ БЕРСЕРКА =====
        if (actual_damage > 0 && variable_instance_exists(id, "temp_armor") && temp_armor > 0) {
            var temp_absorb = min(temp_armor, actual_damage);
            actual_damage -= temp_absorb;
            temp_armor -= temp_absorb;
            absorbed += temp_absorb;
            LOG_CAT("⚡ Временная броня поглотила " + string(temp_absorb) + " урона. Осталось: " + string(temp_armor), "combat");
        }
        
        // Наносим урон здоровью
        var damage_dealt = 0;
        if (actual_damage > 0) {
            hp -= actual_damage;
            damage_dealt = actual_damage;
            LOG_CAT("💔 Герой получил " + string(actual_damage) + " урона. Осталось HP: " + string(floor(hp)), "combat");
        } else {
            LOG_CAT("🛡️ Весь урон поглощен защитой! Итоговый урон: 0", "combat");
        }
        
        // ===== ПАЛАДИН: СТАКИ ЗАЩИТЫ И УРОНА (7 уровень) =====
        if (damage_dealt > 0 && hero_type == "paladin") {
            // Стаки защиты
            if (variable_instance_exists(id, "defense_stacks_max") && defense_stacks_max > 0) {
                if (defense_stacks < max_stacks) {
                    defense_stacks++;
                    if (!variable_instance_exists(id, "damage_reduction_percent")) {
                        damage_reduction_percent = 0;
                    }
                    damage_reduction_percent = defense_stacks;
                    LOG_CAT("🛡️📈 Стак защиты: " + string(defense_stacks) + "/" + string(max_stacks) + 
                              " (-" + string(defense_stacks) + "% урона)", "combat");
                }
            }
            
            // Стаки урона
            if (variable_instance_exists(id, "damage_stacks_max") && damage_stacks_max > 0) {
                if (damage_stacks < max_stacks) {
                    damage_stacks++;
                    var bonus_damage = floor(original_damage * damage_stacks / 100);
                    damage = original_damage + bonus_damage;
                    LOG_CAT("⚔️📈 Стак урона: " + string(damage_stacks) + "/" + string(max_stacks) + 
                              " (+" + string(bonus_damage) + " урона, теперь " + string(damage) + ")", "combat");
                }
            }
            
            // Счетчик для "каждый 6 удар - промах"
            if (variable_instance_exists(id, "every_6th_miss_counter")) {
                every_6th_miss_counter++;
                if (every_6th_miss_counter >= 6) {
                    every_6th_miss_counter = 0;
                    next_hit_miss = true;
                    LOG_CAT("🎯❌ Следующий удар по паладину будет промахом!", "combat");
                }
            }
        }
        
        // ===== ПАССИВНЫЕ СПОСОБНОСТИ ЖРЕЦА (при получении урона ближником) =====
        if (damage_dealt > 0 && instance_exists(obj_priest)) {
            var priest = instance_find(obj_priest, 0);
            if (instance_exists(priest)) {
                var is_melee = (hero_class == global.CLASS_MELEE);
                
                if (is_melee) {
                    if (priest.heal_on_hit_amount > 0) {
                        var old_hp = hp;
                        hp = min(max_hp, hp + priest.heal_on_hit_amount);
                        var healed = hp - old_hp;
                        if (healed > 0) {
                            LOG_CAT("💚 Жрец вылечил " + string(healed) + " HP ближнику " + string(object_index), "combat");
                        }
                    }
                    
                    if (priest.armor_on_hit_amount > 0) {
                        if (!variable_instance_exists(id, "armor")) armor = 0;
                        if (!variable_instance_exists(id, "armor_from_priest")) armor_from_priest = 0;
                        
                        if (armor_from_priest < priest.max_armor_from_ability) {
                            var armor_gain = min(priest.armor_on_hit_amount, priest.max_armor_from_ability - armor_from_priest);
                            armor += armor_gain;
                            armor_from_priest += armor_gain;
                            LOG_CAT("🔧 Жрец дал +" + string(armor_gain) + " брони ближнику", "combat");
                        }
                    }
                }
            }
        }
        
        // ===== ДРУИД: БАФФ БЛИЖНИКА ПРИ ПОЛУЧЕНИИ УРОНА =====
        if (damage_dealt > 0 && instance_exists(obj_druid)) {
            var druid = instance_find(obj_druid, 0);
            if (instance_exists(druid) && druid.druid_buff_melee_chance > 0) {
                var is_melee = (hero_class == global.CLASS_MELEE);
                if (is_melee) {
                    var buff_roll = random(100);
                    if (buff_roll < druid.druid_buff_melee_chance) {
                        if (!variable_instance_exists(druid, "druid_buff_melee_cooldown")) druid.druid_buff_melee_cooldown = 0;
                        if (druid.druid_buff_melee_cooldown <= 0) {
                            var hp_bonus = floor(max_hp * druid.druid_buff_melee_value / 100);
                            max_hp += hp_bonus;
                            hp += hp_bonus;
                            
                            if (!variable_instance_exists(id, "druid_buff_timer")) druid_buff_timer = 0;
                            if (!variable_instance_exists(id, "druid_buff_hp_bonus")) druid_buff_hp_bonus = 0;
                            druid_buff_timer = druid.druid_buff_melee_duration;
                            druid_buff_hp_bonus = hp_bonus;
                            druid.druid_buff_melee_cooldown = 15.0;
                            
                            LOG_CAT("💪🌿 БАФФ ДРУИДА! Макс HP увеличен на " + string(hp_bonus), "combat");
                        }
                    }
                }
            }
        }
        
        // ===== ВРЕМЕННАЯ БРОНЯ БЕРСЕРКА =====
        if (damage_dealt > 0 && hero_type == "berserker") {
            if (variable_instance_exists(id, "temp_armor_chance") && temp_armor_chance > 0) {
                var armor_roll = random(100);
                if (armor_roll < temp_armor_chance) {
                    if (!variable_instance_exists(id, "temp_armor")) temp_armor = 0;
                    if (!variable_instance_exists(id, "temp_armor_timer")) temp_armor_timer = 0;
                    temp_armor = temp_armor_amount;
                    temp_armor_timer = temp_armor_duration;
                    LOG_CAT("🛡️⚡ ВРЕМЕННАЯ БРОНЯ! +" + string(temp_armor_amount) + " брони", "combat");
                }
            }
        }
        
        // ===== ИЛЛЮЗИЯ ДОСПЕХА МЕЧНИКА ТЕНЕЙ =====
        if (damage_dealt > 0 && hero_type == "shadow_blade") {
            if (variable_instance_exists(id, "illusion_chance") && illusion_chance > 0 && illusion_dodge_bonus > 0) {
                var illusion_roll = random(100);
                if (illusion_roll < illusion_chance) {
                    if (!variable_instance_exists(id, "original_dodge_chance")) original_dodge_chance = dodge_chance;
                    illusion_active = true;
                    illusion_timer = 3.0;
                    dodge_chance = original_dodge_chance + illusion_dodge_bonus;
                    LOG_CAT("🛡️👻 ИЛЛЮЗИЯ ДОСПЕХА! Уклонение +" + string(illusion_dodge_bonus) + "%", "combat");
                }
            }
        }
        
        // ===== ОТРАЖЕНИЕ УРОНА (THORN) =====
        if (variable_instance_exists(id, "thorn_percent") && thorn_percent > 0) {
            var reflected_damage = floor(_damage_amount * thorn_percent / 100);
            if (reflected_damage > 0) {
                var attacker = noone;
                if (variable_instance_exists(id, "fight_target") && instance_exists(fight_target)) attacker = fight_target;
                if (!instance_exists(attacker) && variable_instance_exists(id, "target") && instance_exists(target)) attacker = target;
                
                if (instance_exists(attacker) && attacker.alive && attacker.hp > 0) {
                    scr_enemy_take_damage(attacker, reflected_damage);
                    LOG_CAT("🔄 ОТРАЖЕНИЕ УРОНА: " + string(reflected_damage) + " урона врагу", "combat");
                }
            }
        }
        
        // Устанавливаем кулдаун ТОЛЬКО для прямых атак
        if (!_is_projectile) {
            damage_cooldown = damage_cooldown_max;
        }
        
        // Смерть
        if (hp <= 0) {
            state = STATE_DEAD;
            LOG_CAT("=== ГЕРОЙ УМЕР ===", "hero");
            
            var controller = instance_find(obj_game_controller, 0);
            if (instance_exists(controller)) {
                for (var i = 0; i < 4; i++) {
                    if (controller.hero_trees[i] != noone && controller.hero_trees[i].hero_id == hero_id) {
                        controller.hero_trees[i].total_deaths++;
                        break;
                    }
                }
            }
            instance_destroy();
        }
        return true;
    }
}
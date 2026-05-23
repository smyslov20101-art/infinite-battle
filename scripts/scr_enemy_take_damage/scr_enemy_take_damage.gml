/// @function scr_enemy_take_damage(_enemy_instance, _damage_amount)
/// @desc Наносит урон врагу с учётом всех модификаторов (сглаз, проклятье, уязвимость, метка правосудия)

function scr_enemy_take_damage(_enemy_instance, _damage_amount) {
    if (!instance_exists(_enemy_instance)) return false;
    
    // ===== ТЕСТОВЫЕ МАНЕКЕНЫ =====
    if (_enemy_instance.object_index == obj_test_dummy || _enemy_instance.object_index == obj_test_dummy_back) {
        with (_enemy_instance) {
            var final_damage = _damage_amount;
            
            // ===== СГЛАЗ (HEX) =====
            if (variable_instance_exists(id, "hex_damage_mult") && hex_damage_mult > 1) {
                final_damage = floor(final_damage * hex_damage_mult);
                LOG_CAT("👁️ СГЛАЗ! Урон увеличен: " + string(_damage_amount) + " → " + string(final_damage), "combat");
            }
            
            // ===== ПРОКЛЯТЬЕ (CURSE) =====
            if (variable_instance_exists(id, "curse_timer") && curse_timer > 0) {
                if (variable_instance_exists(id, "curse_damage_mult") && curse_damage_mult > 1) {
                    final_damage = floor(final_damage * curse_damage_mult);
                    LOG_CAT("👁️ ПРОКЛЯТЬЕ! Урон увеличен: " + string(_damage_amount) + " → " + string(final_damage), "combat");
                }
            }
            
            // ===== УЯЗВИМОСТЬ (VULNERABILITY) =====
            if (variable_instance_exists(id, "vulnerability_timer") && vulnerability_timer > 0) {
                if (variable_instance_exists(id, "vulnerability_mult")) {
                    final_damage = floor(final_damage * vulnerability_mult);
                    LOG_CAT("🔻 УЯЗВИМОСТЬ! Урон увеличен: " + string(_damage_amount) + " → " + string(final_damage), "combat");
                }
            }
            
            // ===== МЕТКА ПРАВОСУДИЯ (JUSTICE MARK) =====
            if (variable_instance_exists(id, "justice_marks") && justice_marks > 0) {
                if (variable_instance_exists(id, "justice_mark_damage_mult")) {
                    final_damage = floor(final_damage * justice_mark_damage_mult);
                    LOG_CAT("⚖️🔖 МЕТКА ПРАВОСУДИЯ: урон увеличен на " + string((justice_mark_damage_mult - 1) * 100) + "%", "combat");
                }
            }
            
            hp -= final_damage;
            LOG_CAT("🎯 Урон по манекену: " + string(final_damage) + ", осталось HP: " + string(floor(hp)) + "/" + string(max_hp), "combat");
            
            if (hp <= 0) {
                hp = max_hp;
                bleed_stacks = 0;
                bleed_timer = 0;
                bleed_damage_per_stack = 0;
                burn_stacks = 0;
                burn_timer = 0;
                burn_damage_per_stack = 0;
                entangle_timer = 0;
                hex_timer = 0;
                hex_damage_mult = 1.0;
                curse_timer = 0;
                curse_damage_mult = 1.0;
                vulnerability_timer = 0;
                vulnerability_mult = 1.0;
                big_bleed_timer = 0;
                attack_speed_slow_timer = 0;
                justice_marks = 0;
                justice_mark_timer = 0;
                justice_mark_damage_mult = 1.0;
                LOG_CAT("🔄 Манекен возрожден!", "combat");
            }
        }
        return true;
    }
    
    // ===== ОБЫЧНЫЕ ВРАГИ =====
    with (_enemy_instance) {
        if (!alive || hp <= 0) return false;
        
        if (!variable_instance_exists(id, "damage_cooldown_max")) damage_cooldown_max = 0.3;
        if (!variable_instance_exists(id, "damage_cooldown")) damage_cooldown = 0;
        
        var final_damage = _damage_amount;
        
        // ===== СГЛАЗ (HEX) =====
        if (variable_instance_exists(id, "hex_damage_mult") && hex_damage_mult > 1) {
            final_damage = floor(final_damage * hex_damage_mult);
            LOG_CAT("👁️ СГЛАЗ! Урон увеличен: " + string(_damage_amount) + " → " + string(final_damage), "combat");
        }
        
        // ===== ПРОКЛЯТЬЕ (CURSE) =====
        if (variable_instance_exists(id, "curse_timer") && curse_timer > 0) {
            if (variable_instance_exists(id, "curse_damage_mult") && curse_damage_mult > 1) {
                final_damage = floor(final_damage * curse_damage_mult);
                LOG_CAT("👁️ ПРОКЛЯТЬЕ! Урон увеличен: " + string(_damage_amount) + " → " + string(final_damage), "combat");
            }
        }
        
        // ===== УЯЗВИМОСТЬ (VULNERABILITY) =====
        if (variable_instance_exists(id, "vulnerability_timer") && vulnerability_timer > 0) {
            if (variable_instance_exists(id, "vulnerability_mult")) {
                final_damage = floor(final_damage * vulnerability_mult);
                LOG_CAT("🔻 УЯЗВИМОСТЬ! Урон увеличен: " + string(_damage_amount) + " → " + string(final_damage), "combat");
            }
        }
        
        // ===== МЕТКА ПРАВОСУДИЯ (JUSTICE MARK) =====
        if (variable_instance_exists(id, "justice_marks") && justice_marks > 0) {
            if (variable_instance_exists(id, "justice_mark_damage_mult")) {
                final_damage = floor(final_damage * justice_mark_damage_mult);
                LOG_CAT("⚖️🔖 МЕТКА ПРАВОСУДИЯ: урон увеличен на " + string((justice_mark_damage_mult - 1) * 100) + "%", "combat");
            }
        }
        
        // Наносим урон
        hp -= final_damage;
        damage_cooldown = damage_cooldown_max;
        LOG_CAT("Врагу нанесен урон: " + string(final_damage) + ", осталось HP: " + string(hp) + ", тип: " + enemy_type, "combat");
        
        // ===== ОБНОВЛЕНИЕ ТАЙМЕРОВ =====
        if (variable_instance_exists(id, "attack_speed_slow_timer") && attack_speed_slow_timer > 0) {
            attack_speed_slow_timer -= 1 / room_speed;
            if (attack_speed_slow_timer <= 0) {
                if (variable_instance_exists(id, "original_attack_cooldown")) {
                    attack_cooldown_max = original_attack_cooldown;
                }
                attack_speed_slow_timer = 0;
            }
        }
        
        // ===== БОЛЬШОЕ КРОВОТЕЧЕНИЕ (BIG BLEED) =====
        if (variable_instance_exists(id, "big_bleed_timer") && big_bleed_timer > 0) {
            big_bleed_timer -= 1 / room_speed;
            if (big_bleed_timer <= 0) {
                big_bleed_damage = 0;
            } else {
                if (!variable_instance_exists(id, "big_bleed_damage_timer")) big_bleed_damage_timer = 0;
                big_bleed_damage_timer -= 1 / room_speed;
                if (big_bleed_damage_timer <= 0) {
                    if (big_bleed_damage > 0) {
                        hp -= big_bleed_damage;
                        LOG_CAT("🩸💥 БОЛЬШОЕ КРОВОТЕЧЕНИЕ: -" + string(big_bleed_damage) + " HP", "combat");
                        if (hp <= 0) {
                            LOG_CAT("💀 ВРАГ УМЕР ОТ БОЛЬШОГО КРОВОТЕЧЕНИЯ!", "combat");
                            alive = false;
                            var enemy_type_lower = string_lower(enemy_type);
                            if (enemy_type_lower == "miniboss") scr_miniboss_die(id);
                            else if (enemy_type_lower == "boss") boss_die(id);
                            else enemy_die(id);
                            return true;
                        }
                    }
                    big_bleed_damage_timer = 1.0;
                }
            }
        }
        
        // ===== СМЕРТЬ =====
        if (hp <= 0) {
            LOG_CAT("!!! ВРАГ УМИРАЕТ от урона !!!", "combat");
            alive = false;
            var enemy_type_lower = string_lower(enemy_type);
            if (enemy_type_lower == "miniboss") scr_miniboss_die(id);
            else if (enemy_type_lower == "boss") boss_die(id);
            else enemy_die(id);
        }
        return true;
    }
}
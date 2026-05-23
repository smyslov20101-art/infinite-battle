/// @function lightning_mage_state_fighting(_instance)
/// @desc Бой Мага молний (как у мага огня, но на 4 цели)

function lightning_mage_state_fighting(_instance) {
    if (!instance_exists(_instance)) return;
    
    with (_instance) {
        if (!instance_exists(fight_target)) {
            var attack_range = attack_range_moving;
            var attacker_x = x;
            var attacker_y = y;
            
            var new_enemy = noone;
            var closest_dist = attack_range;
            
            with (obj_enemy_base) {
                if (alive && hp > 0 && x > attacker_x) {
                    var dist = point_distance(x, y, attacker_x, attacker_y);
                    if (dist < closest_dist) {
                        new_enemy = id;
                        closest_dist = dist;
                    }
                }
            }
            
            if (!instance_exists(new_enemy)) {
                with (obj_test_dummy) {
                    if (hp > 0 && x > attacker_x) {
                        var dist = point_distance(x, y, attacker_x, attacker_y);
                        if (dist < closest_dist) {
                            new_enemy = id;
                            closest_dist = dist;
                        }
                    }
                }
            }
            if (!instance_exists(new_enemy)) {
                with (obj_test_dummy_back) {
                    if (hp > 0 && x > attacker_x) {
                        var dist = point_distance(x, y, attacker_x, attacker_y);
                        if (dist < closest_dist) {
                            new_enemy = id;
                            closest_dist = dist;
                        }
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
        
        var dist_to_enemy = point_distance(x, y, fight_target.x, fight_target.y);
        
        if (dist_to_enemy > attack_range_moving + 50) {
            state = STATE_MOVING;
            fight_target = noone;
            return;
        }
        
        attack_timer -= 1 / room_speed;
        if (attack_timer <= 0) {
            var final_damage = damage;
            
            // ===== ЦЕПНАЯ МОЛНИЯ =====
            if (chain_lightning_chance > 0) {
                var chain_roll = random(100);
                if (chain_roll < chain_lightning_chance) {
                    var chain_damage = floor(final_damage * chain_lightning_damage_mult);
                    
                    // Сохраняем основную цель для использования внутри with
                    var main_target = fight_target;
                    var mage_x = x;
                    var mage_y = y;
                    
                    // Сначала стреляем в текущую цель
                    scr_create_lightning_bolt(id, main_target, chain_damage);
                    LOG_CAT("⚡ ЦЕПНАЯ МОЛНИЯ: основная цель, урон: " + string(chain_damage), "combat");
                    
                    // Находим ДОПОЛНИТЕЛЬНЫЕ цели (максимум 3)
                    var extra_targets = [];
                    
                    with (obj_enemy_base) {
                        if (id != main_target && alive && hp > 0 && x > mage_x) {
                            array_push(extra_targets, id);
                        }
                    }
                    with (obj_test_dummy) {
                        if (id != main_target && hp > 0 && x > mage_x) {
                            array_push(extra_targets, id);
                        }
                    }
                    with (obj_test_dummy_back) {
                        if (id != main_target && hp > 0 && x > mage_x) {
                            array_push(extra_targets, id);
                        }
                    }
                    
                    var max_extra = min(3, array_length(extra_targets));
                    for (var i = 0; i < max_extra; i++) {
                        var target = extra_targets[i];
                        if (instance_exists(target)) {
                            scr_create_lightning_bolt(id, target, chain_damage);
                            LOG_CAT("⚡ ЦЕПНАЯ МОЛНИЯ: доп. цель " + string(i+1) + ", урон: " + string(chain_damage), "combat");
                        }
                    }
                    
                    LOG_CAT("⚡⚡⚡⚡ ЦЕПНАЯ МОЛНИЯ: поражено " + string(1 + max_extra) + 
                              " целей (шанс: " + string(chain_lightning_chance) + 
                              "%, выпало: " + string(chain_roll) + "%)", "combat");
                    
                    attack_timer = 1 / attack_speed;
                    exit;
                }
            }
            
            // Обычная атака
            scr_create_lightning_bolt(id, fight_target, final_damage);
            LOG_CAT("⚡ ОБЫЧНАЯ МОЛНИЯ! Урон: " + string(final_damage), "combat");
            
            // Оглушение
            if (stun_chance_mage > 0) {
                var stun_roll = random(100);
                if (stun_roll < stun_chance_mage) {
                    if (!variable_instance_exists(fight_target, "stun_timer")) {
                        fight_target.stun_timer = 0;
                    }
                    fight_target.stun_timer = stun_duration_mage;
                    LOG_CAT("💫 ОГЛУШЕНИЕ! Враг оглушен на " + string(stun_duration_mage) + " сек", "combat");
                }
            }
            
            // Уязвимость
            if (vulnerability_chance > 0) {
                var vuln_roll = random(100);
                if (vuln_roll < vulnerability_chance) {
                    if (!variable_instance_exists(fight_target, "vulnerability_timer")) {
                        fight_target.vulnerability_timer = 0;
                        fight_target.vulnerability_mult = 1.0;
                    }
                    fight_target.vulnerability_timer = vulnerability_duration;
                    fight_target.vulnerability_mult = vulnerability_multiplier;
                    LOG_CAT("🔻 УЯЗВИМОСТЬ! Враг получает +30% урона на " + string(vulnerability_duration) + " сек", "combat");
                }
            }
            
            attack_timer = 1 / attack_speed;
        }
    }
}
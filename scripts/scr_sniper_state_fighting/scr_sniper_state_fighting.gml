/// @function sniper_state_fighting(_instance)
/// @desc Бой Снайпера (как у мага огня, но на 3 цели)

function sniper_state_fighting(_instance) {
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
            
            // ===== КРИТ =====
            if (variable_instance_exists(id, "crit_chance") && crit_chance > 0) {
                var crit_roll = random(100);
                if (crit_roll < crit_chance) {
                    var crit_mult = 2.0;
                    if (variable_instance_exists(id, "crit_damage_mult")) {
                        crit_mult = crit_damage_mult;
                    }
                    final_damage = floor(final_damage * crit_mult);
                }
            }
            
            // ===== СЕРЬЕЗНЫЙ ВЫСТРЕЛ =====
            var heavy_shot_activated = false;
            if (heavy_shot_chance > 0) {
                var heavy_roll = random(100);
                if (heavy_roll < heavy_shot_chance) {
                    final_damage = floor(final_damage * heavy_shot_multiplier);
                    heavy_shot_activated = true;
                }
            }
            
            // ===== МУЛЬТИ-ВЫСТРЕЛ (как у мага огня, но на 3 цели) =====
            var multi_activated = false;
            
            if (multi_shot_chance > 0) {
                var multi_roll = random(100);
                if (multi_roll < multi_shot_chance) {
                    multi_activated = true;
                    
                    // Собираем ВСЕХ врагов на поле (без дубликатов)
                    var all_targets = [];
                    var target_ids = [];
                    
                    with (obj_enemy_base) {
                        if (alive && hp > 0) {
                            var already = false;
                            for (var i = 0; i < array_length(target_ids); i++) {
                                if (target_ids[i] == id) { already = true; break; }
                            }
                            if (!already) {
                                array_push(target_ids, id);
                                array_push(all_targets, id);
                            }
                        }
                    }
                    with (obj_test_dummy) {
                        if (hp > 0) {
                            var already = false;
                            for (var i = 0; i < array_length(target_ids); i++) {
                                if (target_ids[i] == id) { already = true; break; }
                            }
                            if (!already) {
                                array_push(target_ids, id);
                                array_push(all_targets, id);
                            }
                        }
                    }
                    with (obj_test_dummy_back) {
                        if (hp > 0) {
                            var already = false;
                            for (var i = 0; i < array_length(target_ids); i++) {
                                if (target_ids[i] == id) { already = true; break; }
                            }
                            if (!already) {
                                array_push(target_ids, id);
                                array_push(all_targets, id);
                            }
                        }
                    }
                    
                    // Сортируем по расстоянию (ближайшие первые)
                    var sorted_targets = [];
                    var sorted_distances = [];
                    
                    for (var i = 0; i < array_length(all_targets); i++) {
                        var t = all_targets[i];
                        var d = point_distance(x, y, t.x, t.y);
                        sorted_targets[i] = t;
                        sorted_distances[i] = d;
                    }
                    
                    for (var i = 0; i < array_length(sorted_targets) - 1; i++) {
                        for (var j = i + 1; j < array_length(sorted_targets); j++) {
                            if (sorted_distances[j] < sorted_distances[i]) {
                                var temp_t = sorted_targets[i];
                                var temp_d = sorted_distances[i];
                                sorted_targets[i] = sorted_targets[j];
                                sorted_distances[i] = sorted_distances[j];
                                sorted_targets[j] = temp_t;
                                sorted_distances[j] = temp_d;
                            }
                        }
                    }
                    
                    // Берем до 3 ближайших целей
                    var max_targets = min(3, array_length(sorted_targets));
                    
                    for (var i = 0; i < max_targets; i++) {
                        var target = sorted_targets[i];
                        if (instance_exists(target)) {
                            scr_create_bolt(id, target, final_damage);
                            LOG_CAT("🎯 МУЛЬТИ-ВЫСТРЕЛ: цель " + string(i+1) + " из " + string(max_targets) + 
                                      ", урон: " + string(final_damage), "combat");
                        }
                    }
                    
                    LOG_CAT("🎯🎯🎯 МУЛЬТИ-ВЫСТРЕЛ: поражено " + string(max_targets) + 
                              " целей (шанс: " + string(multi_shot_chance) + 
                              "%, выпало: " + string(multi_roll) + "%)", "combat");
                    
                    attack_timer = 1 / attack_speed;
                    exit;
                }
            }
            
            // Обычная атака
            if (!multi_activated) {
                scr_create_bolt(id, fight_target, final_damage);
                if (heavy_shot_activated) {
                    LOG_CAT("💥 СЕРЬЕЗНЫЙ ВЫСТРЕЛ! Урон: " + string(final_damage), "combat");
                } else {
                    LOG_CAT("🎯 ОБЫЧНЫЙ ВЫСТРЕЛ! Урон: " + string(final_damage), "combat");
                }
            }
            
            attack_timer = 1 / attack_speed;
        }
    }
}
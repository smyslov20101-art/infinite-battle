/// @function sniper_state_idle(_instance)
/// @desc Обработка состояния ПОКОЙ снайпера (как у мага огня, но на 3 цели)

function sniper_state_idle(_instance) {
    if (!instance_exists(_instance)) return;
    
    with (_instance) {
        var dist_to_target = point_distance(x, y, target_x, target_y);
        if (dist_to_target > 10) {
            state = STATE_MOVING;
            return;
        }
        
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
        
        if (array_length(all_targets) == 0) exit;
        
        // Сортируем по расстоянию
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
        
        var closest_enemy = sorted_targets[0];
        
        attack_timer -= 1 / room_speed;
        if (attack_timer <= 0) {
            var final_damage = damage;
            
            // Крит
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
            
            // Серьезный выстрел
            var heavy_shot_activated = false;
            if (heavy_shot_chance > 0) {
                var heavy_roll = random(100);
                if (heavy_roll < heavy_shot_chance) {
                    final_damage = floor(final_damage * heavy_shot_multiplier);
                    heavy_shot_activated = true;
                }
            }
            
            // Мульти-выстрел (до 3 целей)
            var multi_activated = false;
            
            if (multi_shot_chance > 0) {
                var multi_roll = random(100);
                if (multi_roll < multi_shot_chance) {
                    multi_activated = true;
                    
                    var max_targets = min(3, array_length(sorted_targets));
                    
                    for (var i = 0; i < max_targets; i++) {
                        var target = sorted_targets[i];
                        if (instance_exists(target)) {
                            scr_create_bolt(id, target, final_damage);
                            LOG_CAT("🎯 МУЛЬТИ-ВЫСТРЕЛ (IDLE): цель " + string(i+1) + " из " + string(max_targets) + 
                                      ", урон: " + string(final_damage), "combat");
                        }
                    }
                    
                    LOG_CAT("🎯🎯🎯 МУЛЬТИ-ВЫСТРЕЛ (IDLE): поражено " + string(max_targets) + 
                              " целей (шанс: " + string(multi_shot_chance) + 
                              "%, выпало: " + string(multi_roll) + "%)", "combat");
                    
                    attack_timer = 1 / attack_speed;
                    exit;
                }
            }
            
            // Обычная атака
            if (!multi_activated) {
                scr_create_bolt(id, closest_enemy, final_damage);
                if (heavy_shot_activated) {
                    LOG_CAT("💥 СЕРЬЕЗНЫЙ ВЫСТРЕЛ (IDLE)! Урон: " + string(final_damage), "combat");
                } else {
                    LOG_CAT("🎯 ОБЫЧНЫЙ ВЫСТРЕЛ (IDLE)! Урон: " + string(final_damage), "combat");
                }
            }
            
            attack_timer = 1 / attack_speed;
        }
    }
}
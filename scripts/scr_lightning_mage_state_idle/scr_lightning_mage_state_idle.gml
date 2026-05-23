/// @function lightning_mage_state_idle(_instance)
/// @desc Обработка состояния ПОКОЙ мага молний

function lightning_mage_state_idle(_instance) {
    if (!instance_exists(_instance)) return;
    
    with (_instance) {
        var dist_to_target = point_distance(x, y, target_x, target_y);
        if (dist_to_target > 10) {
            state = STATE_MOVING;
            return;
        }
        
        // Собираем ВСЕХ врагов (каждого по одному разу)
        var all_enemies = [];
        var enemy_ids = [];
        
        with (obj_enemy_base) {
            if (alive && hp > 0) {
                array_push(all_enemies, id);
                array_push(enemy_ids, id);
            }
        }
        with (obj_test_dummy) {
            if (hp > 0) {
                var found = false;
                for (var i = 0; i < array_length(enemy_ids); i++) {
                    if (enemy_ids[i] == id) { found = true; break; }
                }
                if (!found) {
                    array_push(all_enemies, id);
                    array_push(enemy_ids, id);
                }
            }
        }
        with (obj_test_dummy_back) {
            if (hp > 0) {
                var found = false;
                for (var i = 0; i < array_length(enemy_ids); i++) {
                    if (enemy_ids[i] == id) { found = true; break; }
                }
                if (!found) {
                    array_push(all_enemies, id);
                    array_push(enemy_ids, id);
                }
            }
        }
        
        if (array_length(all_enemies) == 0) exit;
        
        // Сортируем по расстоянию
        for (var i = 0; i < array_length(all_enemies) - 1; i++) {
            for (var j = i + 1; j < array_length(all_enemies); j++) {
                var dist_i = point_distance(x, y, all_enemies[i].x, all_enemies[i].y);
                var dist_j = point_distance(x, y, all_enemies[j].x, all_enemies[j].y);
                if (dist_j < dist_i) {
                    var temp = all_enemies[i];
                    all_enemies[i] = all_enemies[j];
                    all_enemies[j] = temp;
                }
            }
        }
        
        attack_timer -= 1 / room_speed;
        if (attack_timer <= 0) {
            var final_damage = damage;
            
            // ===== ЦЕПНАЯ МОЛНИЯ =====
            if (chain_lightning_chance > 0) {
                var chain_roll = random(100);
                if (chain_roll < chain_lightning_chance) {
                    var max_targets = min(4, array_length(all_enemies));
                    var chain_damage = floor(final_damage * chain_lightning_damage_mult);
                    
                    for (var i = 0; i < max_targets; i++) {
                        var target = all_enemies[i];
                        if (instance_exists(target)) {
                            scr_create_lightning_bolt(id, target, chain_damage);
                            LOG_CAT("⚡ ЦЕПНАЯ МОЛНИЯ: цель " + string(i+1) + " (" + string(target.object_index) + "), урон: " + string(chain_damage), "combat");
                        }
                    }
                    
                    LOG_CAT("⚡⚡⚡⚡ ЦЕПНАЯ МОЛНИЯ: поражено " + string(max_targets) + 
                              " целей (шанс: " + string(chain_lightning_chance) + 
                              "%, выпало: " + string(chain_roll) + "%)", "combat");
                    
                    attack_timer = 1 / attack_speed;
                    exit;
                }
            }
            
            // Обычная атака
            scr_create_lightning_bolt(id, all_enemies[0], final_damage);
            LOG_CAT("⚡ ОБЫЧНАЯ МОЛНИЯ! Урон: " + string(final_damage), "combat");
            
            attack_timer = 1 / attack_speed;
        }
    }
}
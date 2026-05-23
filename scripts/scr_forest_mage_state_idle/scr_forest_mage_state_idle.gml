/// @function forest_mage_state_idle(_forest_mage_instance)
/// @desc Обработка состояния ПОКОЙ лесного мага (с поддержкой критов, опутывания и сглаза)

function forest_mage_state_idle(_forest_mage_instance) {
    if (!instance_exists(_forest_mage_instance)) return;
    
    with (_forest_mage_instance) {
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
        
        // Если нашли врага - атакуем
        if (instance_exists(closest_enemy)) {
            attack_timer -= 1 / room_speed;
            
            if (attack_timer <= 0) {
                LOG_CAT("🌿 ЛЕСНОЙ МАГ АТАКУЕТ В IDLE! Цель: " + string(closest_enemy.object_index), "combat");
                
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
                        LOG_CAT("💥 КРИТИЧЕСКИЙ БОЛТ! Урон: " + string(final_damage) + 
                                  " (x" + string(crit_mult) + "), шанс: " + string(crit_chance) + "%", "combat");
                    }
                }
                
                // Создаем болт
                scr_create_forest_bolt(id, closest_enemy, final_damage);
                
                // ===== ОПУТЫВАНИЕ ЛОЗОЙ (ENTANGLE) =====
                if (variable_instance_exists(id, "entangle_chance") && entangle_chance > 0) {
                    LOG_CAT("🌿 ПРОВЕРКА ОПУТЫВАНИЯ! Шанс: " + string(entangle_chance) + "%", "combat");
                    var entangle_roll = random(100);
                    LOG_CAT("  Выпало: " + string(entangle_roll), "combat");
                    
                    if (entangle_roll < entangle_chance) {
                        if (!variable_instance_exists(closest_enemy, "entangle_timer")) {
                            closest_enemy.entangle_timer = 0;
                        }
                        closest_enemy.entangle_timer = 2.0; // Опутывание на 2 секунды
                        LOG_CAT("🌿 ОПУТЫВАНИЕ ЛОЗОЙ СРАБОТАЛО! Цель обездвижена на 2 сек (шанс: " + string(entangle_chance) + 
                                  "%, выпало: " + string(entangle_roll) + "%)", "combat");
                    } else {
                        LOG_CAT("❌ ОПУТЫВАНИЕ НЕ СРАБОТАЛО (выпало " + string(entangle_roll) + 
                                  " >= " + string(entangle_chance) + ")", "combat");
                    }
                }
                
                // ===== СГЛАЗ (HEX) - увеличение получаемого урона на 15% =====
                if (variable_instance_exists(id, "hex_chance") && hex_chance > 0) {
                    LOG_CAT("👁️ ПРОВЕРКА СГЛАЗА! Шанс: " + string(hex_chance) + "%", "combat");
                    var hex_roll = random(100);
                    LOG_CAT("  Выпало: " + string(hex_roll), "combat");
                    
                    if (hex_roll < hex_chance) {
                        if (!variable_instance_exists(closest_enemy, "hex_timer")) {
                            closest_enemy.hex_timer = 0;
                            closest_enemy.hex_damage_mult = 1.15; // +15% урона
                        }
                        closest_enemy.hex_timer = 3.0; // Сглаз на 3 секунды
                        closest_enemy.hex_damage_mult = 1.15;
                        LOG_CAT("👁️ СГЛАЗ СРАБОТАЛ! Цель получает +15% урона на 3 сек (шанс: " + string(hex_chance) + 
                                  "%, выпало: " + string(hex_roll) + "%)", "combat");
                    } else {
                        LOG_CAT("❌ СГЛАЗ НЕ СРАБОТАЛ (выпало " + string(hex_roll) + 
                                  " >= " + string(hex_chance) + ")", "combat");
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
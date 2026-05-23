/// @function boss_state_attacking(_boss_instance)
/// @desc Атака босса (AOE по нескольким целям)

function boss_state_attacking(_boss_instance) {
    if (!instance_exists(_boss_instance)) return;
    
    with (_boss_instance) {
        // 1. Проверяем цель
        if (!instance_exists(target_hero) || target_hero.hp <= 0) {
            state = ENEMY_STATE_MOVING;
            return;
        }
        
        // 2. Проверяем дистанцию
        var dist_to_hero = point_distance(x, y, target_hero.x, target_hero.y);
        
        if (dist_to_hero > attack_range + 50) {
            state = ENEMY_STATE_MOVING;
            return;
        }
        
        // 3. Атакуем с интервалом
        if (attack_timer <= 0) {
            // Находим ближайших героев в радиусе атаки
            var targets = find_closest_heroes_for_boss(id, aoe_targets, aoe_radius);
            
            var targets_hit = 0;
            
            // Наносим урон всем найденным целям
            for (var i = 0; i < array_length(targets); i++) {
                var hero = targets[i];
                if (instance_exists(hero)) {
                   scr_hero_base_take_damage(hero, damage, false);
                    targets_hit++;
                    
                    // Визуальный эффект попадания
                    // with (hero) image_blend = c_red;
                }
            }
            
            LOG("Босс атаковал! Целей поражено: " + string(targets_hit) + 
                              ", Урон: " + string(damage));
            
            // Сброс таймера атаки
            attack_timer = attack_cooldown_max;
            
            // Визуальный эффект атаки босса
            image_blend = c_white;
            alarm[0] = 10; // Вернуть красный цвет через 10 кадров
        }
    }
}

/// @function find_closest_heroes_for_boss(_boss_instance, _max_targets, _radius)
/// @desc Находит ближайших героев к боссу

function find_closest_heroes_for_boss(_boss_instance, _max_targets, _radius) {
    var boss_x = _boss_instance.x;
    var boss_y = _boss_instance.y;
    
    var heroes = [];
    var hero_distances = [];
    
    // Собираем всех героев в радиусе
    with (obj_hero_base) {
        if (hp > 0 && state != STATE_DEAD) {
            var dist = point_distance(x, y, boss_x, boss_y);
            if (dist <= _radius) {
                array_push(heroes, id);
                array_push(hero_distances, dist);
            }
        }
    }
    
    // Сортируем по расстоянию (ближайшие первые)
    var sorted_heroes = [];
    
    for (var i = 0; i < array_length(heroes); i++) {
        sorted_heroes[i] = heroes[i];
    }
    
    // Простая сортировка пузырьком
    for (var i = 0; i < array_length(sorted_heroes) - 1; i++) {
        for (var j = i + 1; j < array_length(sorted_heroes); j++) {
            if (hero_distances[j] < hero_distances[i]) {
                // Меняем местами
                var temp_hero = sorted_heroes[i];
                sorted_heroes[i] = sorted_heroes[j];
                sorted_heroes[j] = temp_hero;
                
                var temp_dist = hero_distances[i];
                hero_distances[i] = hero_distances[j];
                hero_distances[j] = temp_dist;
            }
        }
    }
    
    // Берем не более _max_targets ближайших героев
    var result = [];
    var count = min(_max_targets, array_length(sorted_heroes));
    
    for (var i = 0; i < count; i++) {
        array_push(result, sorted_heroes[i]);
    }
    
    return result;
}
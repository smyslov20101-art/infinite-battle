/// @function miniboss_state_attacking(_miniboss_instance)
/// @desc Атака мини-босса (бьет 2 ближайших героя)

function miniboss_state_attacking(_miniboss_instance) {
    if (!instance_exists(_miniboss_instance)) return;
    
    with (_miniboss_instance) {
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
        
        // 3. Атакуем с интервалом 3 секунды
        if (attack_timer <= 0) {
            // Находим ДВУХ ближайших героев
            var targets = find_closest_heroes(id, aoe_targets, attack_range * 2);
            
            // Наносим урон всем найденным целям
            for (var i = 0; i < array_length(targets); i++) {
                var hero = targets[i];
                if (instance_exists(hero)) {
                    scr_hero_base_take_damage(hero, damage, false);
                    LOG("Мини-босс атаковал героя! Урон: " + string(damage));
                }
            }
            
            // Сброс таймера атаки
            attack_timer = attack_cooldown_max; // 3 секунды
            
            // Визуальный эффект атаки
            image_blend = c_red;
            alarm[0] = 15; // Вернуть желтый цвет через 0.25 секунды (15 кадров)
        }
    }
}

/// @function find_closest_heroes(_miniboss_instance, _max_targets, _radius)
/// @desc Находит ближайших героев к мини-боссу

function find_closest_heroes(_miniboss_instance, _max_targets, _radius) {
    var boss_x = _miniboss_instance.x;
    var boss_y = _miniboss_instance.y;
    
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
    var sorted_distances = [];
    
    for (var i = 0; i < array_length(heroes); i++) {
        sorted_heroes[i] = heroes[i];
        sorted_distances[i] = hero_distances[i];
    }
    
    // Простая сортировка пузырьком
    for (var i = 0; i < array_length(sorted_heroes) - 1; i++) {
        for (var j = i + 1; j < array_length(sorted_heroes); j++) {
            if (sorted_distances[j] < sorted_distances[i]) {
                // Меняем местами
                var temp_hero = sorted_heroes[i];
                var temp_dist = sorted_distances[i];
                
                sorted_heroes[i] = sorted_heroes[j];
                sorted_distances[i] = sorted_distances[j];
                
                sorted_heroes[j] = temp_hero;
                sorted_distances[j] = temp_dist;
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
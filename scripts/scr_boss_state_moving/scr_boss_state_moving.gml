/// @function boss_state_moving(_boss_instance)
/// @desc Движение босса (теперь стоит в очереди)

function boss_state_moving(_boss_instance) {
    if (!instance_exists(_boss_instance)) return;
    
    with (_boss_instance) {
        // 1. Проверяем есть ли враг впереди (в очереди)
        var enemy_ahead = noone;
        
        // Проверяем всех врагов (включая других боссов)
        with (obj_enemy_base) {
            if (id != other.id && alive && x < other.x && other.x - x < queue_distance) {
                enemy_ahead = id;
            }
        }
        
        // 2. Если есть враг впереди - СТОИМ В ОЧЕРЕДИ
        if (instance_exists(enemy_ahead)) {
            // Босс ждет своей очереди, как обычный враг
            return;
        }
        
        // 3. МЫ ПЕРВЫЕ В ОЧЕРЕДИ
        if (!instance_exists(target_hero)) {
            // Ищем ближайшего героя
            var closest_hero = noone;
            var closest_distance = search_radius;
            
            with (obj_hero_base) {
                if (hp > 0 && x < other.x) {
                    var dist = point_distance(x, y, other.x, other.y);
                    if (dist < closest_distance) {
                        closest_hero = id;
                        closest_distance = dist;
                    }
                }
            }
            
            target_hero = closest_hero;
        }
        
        // 4. Если нашли героя
        if (instance_exists(target_hero)) {
            var dist_to_hero = point_distance(x, y, target_hero.x, target_hero.y);
            
            // Если в радиусе атаки - атакуем
            if (dist_to_hero <= attack_range) {
                state = ENEMY_STATE_ATTACKING;
                return;
            } else {
                // Идем к герою
                x -= move_speed;
            }
        } else {
            // Героя нет - просто идем влево
            x -= move_speed;
        }
        
        // Выход за экран
        if (x < -200) {
            instance_destroy();
        }
    }
}
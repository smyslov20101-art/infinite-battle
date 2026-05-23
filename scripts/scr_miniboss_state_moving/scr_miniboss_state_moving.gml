/// @function miniboss_state_moving(_miniboss_instance)
/// @desc Движение мини-босса (с учетом очереди)

function miniboss_state_moving(_miniboss_instance) {
    if (!instance_exists(_miniboss_instance)) return;
    
    with (_miniboss_instance) {
        // 1. Проверяем есть ли враг впереди (в очереди)
        var enemy_ahead = noone;
        
        // Проверяем всех врагов (включая других мини-боссов и боссов)
        with (obj_enemy_base) {
            if (id != other.id && alive && x < other.x && other.x - x < queue_distance) {
                enemy_ahead = id;
            }
        }
        
        // 2. Если есть враг впереди - СТОИМ В ОЧЕРЕДИ
        if (instance_exists(enemy_ahead)) {
            // Но мини-босс может атаковать с дистанции?
            // Если у него есть дальняя атака - мог бы, но у него ближний бой
            // Поэтому просто ждем
            return;
        }
        
        // 3. МЫ ПЕРВЫЕ В ОЧЕРЕДИ
        if (!variable_instance_exists(id, "target_hero") || !instance_exists(target_hero)) {
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
        
        // 5. Выход за экран
        if (x < -200) {
            instance_destroy();
        }
    }
}
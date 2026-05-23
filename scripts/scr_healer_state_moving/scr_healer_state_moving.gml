/// @function healer_state_moving(_healer_instance)
/// @desc Обработка состояния ДВИЖЕНИЯ хилера с проверкой врагов

function healer_state_moving(_healer_instance) {
    if (!instance_exists(_healer_instance)) return;
    
    with (_healer_instance) {
        // Сохраняем переменные хилера
        var healer_range = heal_range;  // Используем радиус лечения как дистанцию обнаружения
        var healer_x = x;
        var healer_y = y;
        
        // ===== ДОБАВЛЕНО: Проверяем врагов на пути =====
        var enemy_nearby = false;
        var closest_enemy = noone;
        var closest_distance = healer_range;
        
        with (obj_enemy_base) {
            if (alive && hp > 0) {
                var dist = point_distance(x, y, healer_x, healer_y);
                
                // Враг должен быть ВПЕРЕДИ и в радиусе
                if (x > healer_x && dist < healer_range) {
                    enemy_nearby = true;
                    
                    if (dist < closest_distance) {
                        closest_enemy = id;
                        closest_distance = dist;
                    }
                }
            }
        }
        
        // ===== ДОБАВЛЕНО: Если враг рядом - останавливаемся =====
        if (enemy_nearby) {
            // Не двигаемся, остаемся на месте
            // Можно добавить состояние "боязни" или просто стоять
            // state = STATE_IDLE; // Раскомментируй если хочешь переходить в IDLE
            LOG("Хилер видит врага в " + string(closest_distance) + " пикселях, останавливается");
            return; // Выходим, не двигаемся
        }
        
        // ===== Если врагов нет - двигаемся к цели =====
        var dist_to_target = point_distance(x, y, target_x, target_y);
        
        if (dist_to_target > move_speed) {
            var dir_x = target_x - x;
            var dir_y = target_y - y;
            
            x += (dir_x / dist_to_target) * move_speed;
            y += (dir_y / dist_to_target) * move_speed;
        } else {
            // Достигли цели
            x = target_x;
            y = target_y;
            state = STATE_IDLE;
        }
    }
}
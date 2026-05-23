function hero_state_moving(_hero_instance) {
    if (!instance_exists(_hero_instance)) return;
    
    with (_hero_instance) {
        // Сохраняем переменные
        var hero_attack_range = attack_range_moving;
        var hero_x = x;
        var hero_y = y;
        
        // 1. Проверяем врагов вокруг
        var enemy_nearby = false;
        var enemy_to_fight = noone;
        var closest_distance = hero_attack_range;
        
        with (obj_enemy_base) {
            if (alive && hp > 0) {
                var dist = point_distance(x, y, hero_x, hero_y);
                
                if (x > hero_x && dist < hero_attack_range) {
                    enemy_nearby = true;
                    
                    if (dist < closest_distance) {
                        enemy_to_fight = id;
                        closest_distance = dist;
                    }
                }
            }
        }
        
        // 2. Если враг рядом - переходим в состояние БОЯ
        if (enemy_nearby && instance_exists(enemy_to_fight)) {
            fight_target = enemy_to_fight;
            state = STATE_FIGHTING;
            return;
        }
        
        // 3. Двигаемся к цели
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
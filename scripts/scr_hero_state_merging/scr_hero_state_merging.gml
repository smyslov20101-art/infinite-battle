function hero_state_merging(_hero_instance) {
    if (!instance_exists(_hero_instance)) return;
    
    with (_hero_instance) {
        // 1. Проверяем цель слияния
        if (!instance_exists(merge_target)) {
            LOG("Цель слияния пропала! ID=" + string(id) + ", тип=" + hero_type);
            
            // Цель пропала - выходим из слияния
            state = STATE_IDLE;
            merge_target = noone;
            
            // Проверяем, нужно ли стать главным
            var main_check = scr_find_main_hero_for_type(hero_type);
            if (!instance_exists(main_check) || main_check == id) {
                is_main_hero = true;
                LOG("Герой становится главным после исчезновения цели");
            }
            
            // Убеждаемся, что у нас есть целевая позиция
            if (target_x == 0 && target_y == 0) {
                set_hero_target_by_class(id);
            }
            return;
        }
        
        // 2. Если цель мертва - отменяем слияние
        if (merge_target.state == STATE_DEAD || merge_target.hp <= 0) {
            LOG("Цель слияния мертва! ID=" + string(id) + ", тип=" + hero_type);
            
            state = STATE_IDLE;
            merge_target = noone;
            
            // Если мы должны были стать главным, но цель умерла - становимся главным
            var main_check = scr_find_main_hero_for_type(hero_type);
            if (!instance_exists(main_check) || main_check == id) {
                is_main_hero = true;
                LOG("Герой становится главным после смерти цели");
            }
            
            // Убеждаемся, что у нас есть целевая позиция
            if (target_x == 0 && target_y == 0) {
                set_hero_target_by_class(id);
            }
            return;
        }
        
        // 3. Рассчитываем дистанцию
        var dist = point_distance(x, y, merge_target.x, merge_target.y);
        
        // 4. Двигаемся к цели
        if (dist > 20) {
            // Плавное движение к цели
            var move_x = merge_target.x - x;
            var move_y = merge_target.y - y;
            
            if (abs(move_x) > 0.5) x += sign(move_x) * move_speed;
            if (abs(move_y) > 0.5) y += sign(move_y) * move_speed;
            
        } else {
            // Достаточно близко - выполняем слияние
            LOG("=== ВЫПОЛНЯЕМ СЛИЯНИЕ ===");
            
            // Выполняем слияние
            if (scr_hero_perform_merge(id, merge_target)) {
                LOG("Слияние успешно завершено!");
            } else {
                LOG("Слияние не удалось!");
                state = STATE_IDLE;
                merge_target = noone;
                
                // Проверяем, нужно ли стать главным
                var main_check = scr_find_main_hero_for_type(hero_type);
                if (!instance_exists(main_check) || main_check == id) {
                    is_main_hero = true;
                }
            }
        }
    }
}
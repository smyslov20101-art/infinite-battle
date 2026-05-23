/// @function tank_state_fighting(_tank_instance)
/// @desc Обработка состояния БОЯ танка (он просто стоит под врагом)

function tank_state_fighting(_tank_instance) {
    if (!instance_exists(_tank_instance)) return;
    
    with (_tank_instance) {
        // 1. Проверяем цель
        if (!instance_exists(fight_target)) {
            // Враг умер или пропал
            fight_target = noone;
            
            // Проверяем, достигли ли мы целевой точки
            var dist_to_target = point_distance(x, y, target_x, target_y);
            if (dist_to_target > 10) {
                state = STATE_MOVING;
            } else {
                state = STATE_IDLE;
            }
            return;
        }
        
        // 2. Проверяем жив ли враг
        if (!fight_target.alive || fight_target.hp <= 0) {
            fight_target = noone;
            var dist_to_target = point_distance(x, y, target_x, target_y);
            if (dist_to_target > 10) {
                state = STATE_MOVING;
            } else {
                state = STATE_IDLE;
            }
            return;
        }
        
        // 3. Проверяем дистанцию до врага
        var dist_to_enemy = point_distance(x, y, fight_target.x, fight_target.y);
        var tank_attack_range = attack_range_moving;
        
        // 4. Если враг далеко - возвращаемся к движению
        if (dist_to_enemy > tank_attack_range + 20) {
            fight_target = noone;
            var dist_to_target = point_distance(x, y, target_x, target_y);
            if (dist_to_target > 10) {
                state = STATE_MOVING;
            } else {
                state = STATE_IDLE;
            }
            return;
        }
        
        // 5. ЕСЛИ МЫ ЗДЕСЬ, ТО МЫ СТОИМ ЛИЦОМ К ЛИЦУ С ВРАГОМ.
        // Танк НИЧЕГО НЕ ДЕЛАЕТ, просто стоит и ждет, пока его ударят.
        // Весь урон он получает через scr_hero_base_take_damage
    }
}
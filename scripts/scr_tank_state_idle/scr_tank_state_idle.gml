/// @function tank_state_idle(_tank_instance)
/// @desc Обработка состояния ПОКОЙ танка (он ищет врага, чтобы встать под него)

function tank_state_idle(_tank_instance) {
    if (!instance_exists(_tank_instance)) return;
    
    with (_tank_instance) {
		
		// ===== ДОБАВЛЯЕМ ПРОВЕРКУ ЦЕЛЕВОЙ ПОЗИЦИИ =====
        // Если мы не на целевой позиции - идем к ней
        var dist_to_target = point_distance(x, y, target_x, target_y);
        if (dist_to_target > 10) {
            state = STATE_MOVING;
            return;
        }
		
        // Сохраняем переменные
        var tank_attack_range = attack_range_idle;
        var tank_x = x;
        var tank_y = y;
        
        // 1. Ищем ближайшего врага спереди
        var enemy_nearby = false;
        var enemy_to_tank = noone;
        var closest_distance = tank_attack_range;
        
        with (obj_enemy_base) {
            if (alive && hp > 0 && x > tank_x) {
                var dist = point_distance(x, y, tank_x, tank_y);
                if (dist < tank_attack_range) {
                    enemy_nearby = true;
                    if (dist < closest_distance) {
                        enemy_to_tank = id;
                        closest_distance = dist;
                    }
                }
            }
        }
        
        // 2. Если нашли врага - переходим в состояние БОЯ, чтобы его танковать
        if (enemy_nearby && instance_exists(enemy_to_tank)) {
            fight_target = enemy_to_tank;
            state = STATE_FIGHTING;
            return;
        }
    }
}
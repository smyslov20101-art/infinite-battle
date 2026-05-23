/// @function archer_state_idle(_archer_instance)
/// @desc Обработка состояния ПОКОЙ лучника

function archer_state_idle(_archer_instance) {
    if (!instance_exists(_archer_instance)) return;
    
    with (_archer_instance) {
		
		// ===== ДОБАВЛЯЕМ ПРОВЕРКУ ЦЕЛЕВОЙ ПОЗИЦИИ =====
        // Если мы не на целевой позиции - идем к ней
        var dist_to_target = point_distance(x, y, target_x, target_y);
        if (dist_to_target > 10) {
            state = STATE_MOVING;
            return;
        }
		
        // Сохраняем переменные
        var archer_attack_range = attack_range_idle;
        var archer_x = x;
        var archer_y = y;
        
        // 1. Ищем ближайшего врага (ИЗМЕНИЛ: obj_enemy_base вместо obj_enemy)
        var closest_enemy = noone;
        var closest_distance = archer_attack_range;
        
        with (obj_enemy_base) { // ← ИЗМЕНИЛ ЗДЕСЬ!
            if (alive && x > archer_x) {
                var dist = point_distance(x, y, archer_x, archer_y);
                if (dist < closest_distance) {
                    closest_enemy = id;
                    closest_distance = dist;
                }
            }
        }
        
        // 2. Если нашли врага - стреляем
        if (instance_exists(closest_enemy)) {
            attack_timer -= 1 / room_speed;
            
            if (attack_timer <= 0) {
                scr_create_arrow(id, closest_enemy, damage);
                attack_timer = 1 / attack_speed;
            }
        }
    }
}
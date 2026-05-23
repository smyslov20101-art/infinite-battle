/// @function mage_state_moving(_mage_instance)
/// @desc Обработка состояния ДВИЖЕНИЯ мага

function mage_state_moving(_mage_instance) {
    if (!instance_exists(_mage_instance)) return;
    
    with (_mage_instance) {
        // Двигаемся к цели
        var dist_to_target = point_distance(x, y, target_x, target_y);
        
        if (dist_to_target > move_speed) {
            var dir_x = target_x - x;
            var dir_y = target_y - y;
            x += (dir_x / dist_to_target) * move_speed;
            y += (dir_y / dist_to_target) * move_speed;
        } else {
            x = target_x;
            y = target_y;
            state = STATE_IDLE;
        }
    }
}
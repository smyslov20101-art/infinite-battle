/// @function handle_projectile_pause(_projectile_instance, _controller)
/// @desc Обрабатывает паузу для снарядов (стрелы, шары)
/// @return {bool} true если снаряд на паузе

function handle_projectile_pause(_projectile_instance, _controller) {
    if (!instance_exists(_projectile_instance)) return false;
    if (!instance_exists(_controller)) return false;
    
    with (_projectile_instance) {
        // Проверяем состояние игры
        var is_paused = (_controller.controller_state == _controller.CONTROLLER_STATE_PAUSE);
        var is_gameover = _controller.game_over;
        
        // Если игра на паузе или окончена
        if (is_paused || is_gameover) {
            // Если снаряд еще не был на паузе - запоминаем позицию
            if (!paused) {
                paused = true;
                paused_x = x;
                paused_y = y;
                paused_image_angle = image_angle;
                // Сохраняем оригинальную гравитацию, если нужно
                if (variable_instance_exists(id, "gravity")) {
                    paused_gravity = gravity;
                }
                LOG("Снаряд заморожен на позиции " + string(x) + "," + string(y));
            }
            // Оставляем снаряд на запомненной позиции
            x = paused_x;
            y = paused_y;
            image_angle = paused_image_angle;
            // Отключаем гравитацию
            if (variable_instance_exists(id, "gravity")) {
                gravity = 0;
            }
            return true; // Снаряд на паузе
        } else {
            // Если игра возобновилась - снимаем паузу
            if (paused) {
                paused = false;
                // Восстанавливаем гравитацию
                if (variable_instance_exists(id, "gravity") && variable_instance_exists(id, "paused_gravity")) {
                    gravity = paused_gravity;
                }
                LOG("Снаряд продолжает движение");
            }
            return false; // Снаряд не на паузе
        }
    }
    return false;
}
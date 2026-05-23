// Step_obj_magic_ball.gml

// Получаем контроллер
var controller = instance_find(obj_game_controller, 0);

// Обрабатываем паузу (для шара своя логика, но используем тот же подход)
if (instance_exists(controller)) {
    var is_paused = (controller.controller_state == controller.CONTROLLER_STATE_PAUSE);
    var is_gameover = controller.game_over;
    
    if (is_paused || is_gameover) {
        if (!paused) {
            paused = true;
            paused_y = y;
            LOG("Шар заморожен на Y=" + string(y));
        }
        y = paused_y;
        exit;
    } else {
        paused = false;
    }
}

// 1. Уменьшаем время жизни
lifetime--;
if (lifetime <= 0) {
    LOG("Шар исчез по времени жизни");
    instance_destroy();
    exit;
}

// 2. Двигаем шар ВНИЗ (только по Y)
y += speed; // speed = 8, direction = 270

// 3. Проверяем достижение цели
if (y >= target_y) {
    LOG("Шар достиг цели Y=" + string(target_y));
    
    // Взрываем шар и наносим урон ВСЕМ врагам в радиусе
    explode_magic_ball(id);
    instance_destroy();
    exit;
}

// 4. Проверяем выход за границы экрана
if (y > room_height + 100) {
    LOG("Шар вышел за нижнюю границу экрана");
    instance_destroy();
}
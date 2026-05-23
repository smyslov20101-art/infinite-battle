/// Step Event - obj_fireball

// Получаем контроллер для паузы
var controller = instance_find(obj_game_controller, 0);

if (instance_exists(controller)) {
    var is_paused = (controller.controller_state == controller.CONTROLLER_STATE_PAUSE);
    var is_gameover = controller.game_over;
    
    if (is_paused || is_gameover) {
        exit;
    }
}

// Уменьшаем время жизни
lifetime--;
if (lifetime <= 0) {
    instance_destroy();
    exit;
}

// Проверяем существование цели
if (!instance_exists(target)) {
    instance_destroy();
    exit;
}

// Проверяем, жива ли цель
if (target.hp <= 0) {
    instance_destroy();
    exit;
}

// Движение по прямой к цели
var dir = point_direction(x, y, target.x, target.y);
x += lengthdir_x(speed, dir);
y += lengthdir_y(speed, dir);
image_angle = dir;

// Проверка столкновения
var dist = point_distance(x, y, target.x, target.y);
if (dist < speed) {
    // Сохраняем информацию о цели до нанесения урона
    var target_exists = instance_exists(target);
    var target_alive = (target_exists && target.hp > 0);
    var target_index = target_exists ? target.object_index : -1;
    
    if (target_alive) {
        scr_enemy_take_damage(target, damage);
        LOG_CAT("🔥 ФАЕРБОЛ ПОПАЛ! Урон: " + string(damage) + ", цель: " + string(target_index), "combat");
    } else {
        LOG_CAT("⚠️ ФАЕРБОЛ ПОПАЛ В МЕРТВУЮ ЦЕЛЬ", "combat");
    }
    instance_destroy();
    exit;
}

// Проверка выхода за границы
if (x < -200 || x > room_width + 200 || y < -200 || y > room_height + 200) {
    instance_destroy();
}
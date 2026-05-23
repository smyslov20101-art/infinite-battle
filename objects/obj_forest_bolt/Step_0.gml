/// Step Event - obj_forest_bolt

// Получаем контроллер
var controller = instance_find(obj_game_controller, 0);

// Пауза
if (instance_exists(controller)) {
    if (controller.controller_state == controller.CONTROLLER_STATE_PAUSE || 
        controller.game_over) {
        exit;
    }
}

// Время жизни
lifetime--;
if (lifetime <= 0) {
    instance_destroy();
    exit;
}

// Проверяем цель
if (!instance_exists(target) || target.hp <= 0) {
    instance_destroy();
    exit;
}

// Движение (уже задано hspeed/vspeed)

// Проверка столкновения
var dist = point_distance(x, y, target.x, target.y);
if (dist < speed) {
    // Попали в цель
    if (instance_exists(target) && target.hp > 0) {
        scr_enemy_take_damage(target, damage);
        LOG_CAT("🌿 БОЛТ ПОПАЛ! Урон: " + string(damage) + 
                  ", цель: " + string(target.object_index), "combat");
    }
    instance_destroy();
    exit;
}

// Проверка выхода за границы
if (x < -200 || x > room_width + 200 || y < -200 || y > room_height + 200) {
    instance_destroy();
}
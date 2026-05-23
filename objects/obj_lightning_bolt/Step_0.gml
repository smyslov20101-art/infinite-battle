/// Step Event - obj_lightning_bolt

// Получаем контроллер для паузы
var controller = instance_find(obj_game_controller, 0);

// Обработка паузы
if (instance_exists(controller)) {
    var is_paused = (controller.controller_state == controller.CONTROLLER_STATE_PAUSE);
    var is_gameover = controller.game_over;
    
    if (is_paused || is_gameover) {
        if (!paused) {
            paused = true;
            paused_x = x;
            paused_y = y;
            paused_image_angle = image_angle;
        }
        x = paused_x;
        y = paused_y;
        image_angle = paused_image_angle;
        exit;
    } else {
        paused = false;
    }
}

// Движение (прямолинейное)
if (hspeed != 0 || vspeed != 0) {
    // Уже движется через hspeed/vspeed
} else {
    // Устанавливаем движение к цели
    if (instance_exists(target)) {
        direction = point_direction(x, y, target.x, target.y);
        hspeed = lengthdir_x(speed, direction);
        vspeed = lengthdir_y(speed, direction);
        image_angle = direction;
    }
}

// Время жизни
lifetime--;
if (lifetime <= 0) {
    instance_destroy();
    exit;
}

// ===== ПРОВЕРКА СТОЛКНОВЕНИЙ ПО ID ЦЕЛИ =====
var hit = noone;
if (instance_exists(target)) {
    LOG("🔍 Цель молнии: object_index=" + string(target.object_index) + 
                       ", is_back=" + string(target.object_index == obj_test_dummy_back));
}
// 1. Если у молнии есть цель и она существует
if (instance_exists(target)) {
    var dist_to_target = point_distance(x, y, target.x, target.y);
    
    // Если молния достаточно близко к своей цели
    if (dist_to_target < 30) {
        hit = target;
    }
}

// 2. Если нашли цель по ID
if (instance_exists(hit) && hit.hp > 0) {
    // Определяем, какой это манекен
    if (hit.object_index == obj_test_dummy_back) {
        LOG_CAT("⚡ МОЛНИЯ ПОПАЛА В ЗАДНИЙ МАНЕКЕН (по ID цели)! Урон: " + string(damage), "combat");
    } else if (hit.object_index == obj_test_dummy) {
        LOG_CAT("⚡ МОЛНИЯ ПОПАЛА В ПЕРЕДНИЙ МАНЕКЕН (по ID цели)! Урон: " + string(damage), "combat");
    } else {
        LOG_CAT("⚡ МОЛНИЯ ПОПАЛА В ВРАГА! Урон: " + string(damage), "combat");
    }
    
    scr_enemy_take_damage(hit, damage);
    instance_destroy();
    exit;
}

// 3. Запасная проверка по расстоянию (если цель вдруг пропала)
var backup_hit = noone;

if (object_exists(obj_test_dummy_back)) {
    with (obj_test_dummy_back) {
        var dist = point_distance(x, y, other.x, other.y);
        if (dist < 25 && hp > 0) {
            backup_hit = id;
            break;
        }
    }
}
if (!instance_exists(backup_hit) && object_exists(obj_test_dummy)) {
    with (obj_test_dummy) {
        var dist = point_distance(x, y, other.x, other.y);
        if (dist < 25 && hp > 0) {
            backup_hit = id;
            break;
        }
    }
}
if (!instance_exists(backup_hit)) {
    with (obj_enemy_base) {
        if (alive && hp > 0) {
            var dist = point_distance(x, y, other.x, other.y);
            if (dist < 25) {
                backup_hit = id;
                break;
            }
        }
    }
}

if (instance_exists(backup_hit)) {
    scr_enemy_take_damage(backup_hit, damage);
    LOG_CAT("⚡ МОЛНИЯ ПОПАЛА (запасная проверка)! Урон: " + string(damage), "combat");
    instance_destroy();
    exit;
}

// Проверка выхода за границы
if (x < -200 || x > room_width + 200 || y < -200 || y > room_height + 200) {
    instance_destroy();
}
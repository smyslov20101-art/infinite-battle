/// Step Event - obj_arrow

// Получаем контроллер
var controller = instance_find(obj_game_controller, 0);

// Обрабатываем паузу
if (handle_projectile_pause(id, controller)) {
    gravity = 0;
    exit; 
}

// ===== ДВИЖЕНИЕ (без изменений) =====
if (hspeed != 0 || vspeed != 0) {
    // Движение уже обрабатывается
} 
else if (arc_height > 0) {
    gravity = 0.1;
    arc_progress += arc_speed;
    
    if (arc_progress <= 1) {
        var t = arc_progress;
        
        if (instance_exists(target) && target.alive) {
            var current_target_x = target.x;
            var current_target_y = target.y;
            
            x = lerp(start_x, current_target_x, t);
            var height_factor = -4 * t * (1 - t) * arc_height;
            y = lerp(start_y, current_target_y, t) + height_factor;
        } else {
            x = lerp(start_x, target_x, t);
            var height_factor = -4 * t * (1 - t) * arc_height;
            y = lerp(start_y, target_y, t) + height_factor;
        }
        
        if (t < 0.99) {
            var next_t = t + 0.01;
            var next_x = lerp(start_x, target_x, next_t);
            var next_y = lerp(start_y, target_y, next_t) + (-4 * next_t * (1 - next_t) * arc_height);
            image_angle = point_direction(x, y, next_x, next_y);
        }
    } else {
        instance_destroy();
    }
}
else {
    gravity = 0.1;
}

// Время жизни
lifetime--;
if (lifetime <= 0) instance_destroy();

// ===== СТОЛКНОВЕНИЯ (ИСПРАВЛЕННЫЙ ПОРЯДОК!) =====
var hit = noone;

// 1. СНАЧАЛА проверяем задний манекен (он дальше по оси X)
if (object_exists(obj_test_dummy_back)) {
    hit = instance_place(x, y, obj_test_dummy_back);
    if (instance_exists(hit) && hit.hp > 0) {
        LOG_CAT("💥 СНАРЯД ПОПАЛ В ЗАДНИЙ МАНЕКЕН! Цель: " + string(hit.object_index) + 
                  ", Урон: " + string(damage), "combat");
        scr_enemy_take_damage(hit, damage);
        instance_destroy();
        exit;
    }
}

// 2. ПОТОМ проверяем передний манекен
if (object_exists(obj_test_dummy)) {
    hit = instance_place(x, y, obj_test_dummy);
    if (instance_exists(hit) && hit.hp > 0) {
        LOG_CAT("💥 СНАРЯД ПОПАЛ В ПЕРЕДНИЙ МАНЕКЕН! Цель: " + string(hit.object_index) + 
                  ", Урон: " + string(damage), "combat");
        scr_enemy_take_damage(hit, damage);
        instance_destroy();
        exit;
    }
}

// 3. ПОТОМ проверяем обычных врагов
hit = instance_place(x, y, obj_enemy_base);
if (instance_exists(hit) && hit.alive && hit.hp > 0) {
    LOG_CAT("💥 СНАРЯД ПОПАЛ В ВРАГА! Цель: " + string(hit.object_index) + 
              ", Урон: " + string(damage), "combat");
    scr_enemy_take_damage(hit, damage);
    instance_destroy();
    exit;
}

// Проверка выхода за границы
if (x < -200 || x > room_width + 200 || y < -200 || y > room_height + 200) {
    instance_destroy();
}
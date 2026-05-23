/// Step Event - obj_enemy_arrow

// Получаем контроллер
var controller = instance_find(obj_game_controller, 0);

// Обрабатываем паузу
if (handle_projectile_pause(id, controller)) {
    gravity = 0;
    exit;
}

gravity = 0.1;

// 1. Время жизни
lifetime--;
if (lifetime <= 0) {
    instance_destroy();
    exit;
}

// ===== ИСПРАВЛЕНО: СНАЧАЛА ПРОВЕРЯЕМ СТОЛКНОВЕНИЕ =====
// Это самая важная проверка - делаем её первой!
var hit = instance_place(x, y, obj_hero_base);
if (instance_exists(hit) && hit.hp > 0) {
    LOG("💥 Стрела попала в героя! Урон: " + string(damage));
    scr_hero_base_take_damage(hit, damage, true);
    instance_destroy();
    exit;
}

// ===== Движение по дуге =====
if (instance_exists(target)) {
    // Проверяем, жива ли цель
    if (target.hp <= 0) {
        // Цель мертва - ищем нового ближайшего героя
        var new_target = noone;
        var closest_dist = 300; // Радиус поиска
        
        with (obj_hero_base) {
            if (hp > 0) {
                var dist = point_distance(x, y, other.x, other.y);
                if (dist < closest_dist) {
                    new_target = id;
                    closest_dist = dist;
                }
            }
        }
        
        if (instance_exists(new_target)) {
            // Перенаправляем стрелу на новую цель
            target = new_target;
            start_x = x;
            start_y = y;
            arc_progress = 0;
            LOG("🎯 Стрела перенаправлена на нового героя");
        } else {
            // Нет целей - уничтожаем стрелу
            instance_destroy();
            exit;
        }
    }
    
    arc_progress += arc_speed;
    
    if (arc_progress <= 1) {
        var t = arc_progress;
        
        // Всегда летим к ТЕКУЩЕЙ позиции цели
        var current_target_x = target.x;
        var current_target_y = target.y;
        
        // Параболическая траектория
        x = lerp(start_x, current_target_x, t);
        
        // Дуга
        var height_factor = -4 * t * (1 - t) * arc_height;
        y = lerp(start_y, current_target_y, t) + height_factor;
        
        // Поворот
        if (t < 0.99) {
            var next_t = t + 0.01;
            var next_x = lerp(start_x, current_target_x, next_t);
            var next_y = lerp(start_y, current_target_y, next_t) + (-4 * next_t * (1 - next_t) * arc_height);
            image_angle = point_direction(x, y, next_x, next_y);
        }
    } else {
        // Достигли конца трапестории - принудительно проверяем попадание
        var final_hit = instance_place(x, y, obj_hero_base);
        if (instance_exists(final_hit) && final_hit.hp > 0) {
            scr_hero_base_take_damage(hit, damage, true);
        }
        instance_destroy();
        exit;
    }
} else {
    // Цели нет - ищем новую цель
    var new_target = noone;
    var closest_dist = 300;
    
    with (obj_hero_base) {
        if (hp > 0) {
            var dist = point_distance(x, y, other.x, other.y);
            if (dist < closest_dist) {
                new_target = id;
                closest_dist = dist;
            }
        }
    }
    
    if (instance_exists(new_target)) {
        target = new_target;
        start_x = x;
        start_y = y;
        arc_progress = 0;
    } else {
        instance_destroy();
        exit;
    }
}

// ===== ДОПОЛНИТЕЛЬНАЯ ПРОВЕРКА СТОЛКНОВЕНИЯ (на случай если пропустили в начале) =====
var hit_again = instance_place(x, y, obj_hero_base);
if (instance_exists(hit_again) && hit_again.hp > 0) {
   scr_hero_base_take_damage(hit, damage, true);
    instance_destroy();
}

// Проверка выхода за границы
if (x < -200 || x > room_width + 200 || y < -200 || y > room_height + 200) {
    instance_destroy();
}
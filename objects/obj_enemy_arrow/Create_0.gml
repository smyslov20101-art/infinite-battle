shooter = noone;
target = noone;
damage = 0;
speed = 8;
gravity = 0.1;
gravity_direction = 270;
lifetime = 120;

// Параметры дуги (как у героя)
arc_height = 120;
arc_progress = 0;
arc_speed = 0.025;
start_x = x;
start_y = y;
target_x = 0;
target_y = 0;

// Новая переменная для паузы
paused = false;
paused_x = 0;
paused_y = 0;
paused_image_angle = 0;
paused_gravity = 0;

// Визуал
if (sprite_exists(spr_arrow)) {
    sprite_index = spr_arrow;
    image_blend = c_red; // Красные стрелы врагов
}
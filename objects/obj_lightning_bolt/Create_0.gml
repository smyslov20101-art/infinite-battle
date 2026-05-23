/// Create Event - obj_lightning_bolt

// Характеристики снаряда
caster = noone;         // Кто создал (Маг молний)
target = noone;         // Цель
damage = 0;             // Урон
speed = 18;             // Скорость полета
direction = 0;          // Направление
lifetime = 120;         // Время жизни (2 секунды при 60 FPS)
depth = -1;
// Для движения
hspeed = 0;
vspeed = 0;
start_x = x;
start_y = y;

// Для паузы
paused = false;
paused_x = 0;
paused_y = 0;
paused_image_angle = 0;

// Визуал
if (sprite_exists(spr_lightning_bolt)) {
    sprite_index = spr_lightning_bolt;
    image_blend = c_white;
} else if (sprite_exists(spr_bolt)) {
    sprite_index = spr_bolt;
    image_blend = c_yellow;
} else if (sprite_exists(spr_arrow)) {
    sprite_index = spr_arrow;
    image_blend = c_yellow;
}

image_angle = direction;
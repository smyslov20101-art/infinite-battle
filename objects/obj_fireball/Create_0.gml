/// Create Event - obj_fireball

// Характеристики фаербола
caster = noone;
target = noone;
damage = 0;
speed = 5;
lifetime = 300;

// Для совместимости
alive = true;

// Для прямолинейного движения
direction = 0;
start_x = 0;
start_y = 0;

// Визуал
if (sprite_exists(spr_fireball)) {
    sprite_index = spr_fireball;
} else {
    sprite_index = -1;
}

// Эффекты
image_blend = c_red;
image_alpha = 1.0;
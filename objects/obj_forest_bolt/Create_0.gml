/// Create Event - obj_forest_bolt

caster = noone;
target = noone;
damage = 0;
speed = 12;
direction = 0;
lifetime = 120;

// Визуал
if (sprite_exists(spr_bolt)) {
    sprite_index = spr_bolt;
    image_blend = c_green;
} else {
    sprite_index = -1;
}

// Движение
hspeed = lengthdir_x(speed, direction);
vspeed = lengthdir_y(speed, direction);
image_angle = direction;
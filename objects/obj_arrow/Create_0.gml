/// Create Event - obj_arrow

shooter = noone;
target = noone;
damage = 0;
speed = 8;
gravity = 0.1;
gravity_direction = 270;
lifetime = 300; // Максимальное время жизни (5 секунд при 60 FPS)

// Переменные для паузы
paused = false;
paused_x = 0;
paused_y = 0;
paused_image_angle = 0;
paused_gravity = 0;

// Переменные для дуги
arc_height = 0;
arc_progress = 0;
arc_speed = 0;
start_x = 0;
start_y = 0;
target_x = 0;
target_y = 0;

// Переменные для прямолинейного полета
hspeed = 0;
vspeed = 0;
direction = 0;
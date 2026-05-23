// Характеристики шара магии
caster = noone;         // Кто создал шар (маг)
damage = 15;            // Урон при взрыве
damage_radius = 50;     // Радиус поражения
target_y = 600;         // Где взрывается (y координата)
speed = 8;              // Скорость падения
lifetime = 300;         // Максимальное время жизни (на случай багов)

// Новая переменная для паузы
paused = false;
paused_y = 0;

// Начальный поворот/анимация
if (sprite_exists(spr_magic_ball)) {
    sprite_index = spr_magic_ball;
    image_angle = random(360); // Случайный поворот для эффекта
}
// Draw Event - obj_healer

// Рисуем спрайт хилера
draw_self();

// ===== ИНТЕРФЕЙС НАД ХИЛЕРОМ =====
draw_set_halign(fa_center);

// 1. КРУЖОК С УРОВНЕМ (САМЫЙ ВЕРХ)
var level_circle_y = y - 80;
var circle_radius = 20;

// Рисуем кружок с цветом уровня
draw_set_color(c_white);
draw_circle(x, level_circle_y, circle_radius, true);

// Обводка кружка
draw_set_color(c_gray);
draw_circle(x, level_circle_y, circle_radius, false);

// Цифра уровня внутри кружка
draw_set_color(c_white);
draw_set_font(fnt_level);
draw_text(x, level_circle_y-10 , string(hero_level));
draw_set_font(fnt_m);

// 2. ПОКАЗАТЕЛИ С ИКОНКАМИ (ПОД КРУЖКОМ)
var stats_y = y - 40;

// ИКОНКА СЕРДЦА (HP) - слева
var heart_x = x - 45;
if (sprite_exists(spr_heart)) {
    draw_sprite(spr_heart, 0, heart_x, stats_y-5);
} else {
    draw_set_color(c_red);
    draw_text(heart_x - 5, stats_y - 20, "❤");
}

// Текст HP рядом с иконкой
draw_set_color(c_white);
draw_text(heart_x + 30, stats_y - 18, string(floor(hp)));

// ИКОНКА ЛЕЧЕНИЯ (вместо меча) - справа
var heal_x = x + 13;
if (sprite_exists(spr_heal)) {
    draw_sprite(spr_heal, 0, heal_x, stats_y-5);
} else {
    draw_set_color(c_green);
    draw_text(heal_x - 5, stats_y - 10, "+");
}

// Текст силы лечения рядом с иконкой
draw_set_color(c_white);
draw_text(heal_x + 20, stats_y - 18, string(healing_power));


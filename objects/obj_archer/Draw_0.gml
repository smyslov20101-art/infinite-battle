// Рисуем спрайт героя
draw_self();

// ===== ИНТЕРФЕЙС НАД ГЕРОЕМ =====
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

// Общий фон для статистики
//draw_set_color(make_color_rgb(40, 40, 60));
//draw_rectangle(x - 70, stats_y - 20, x + 60, stats_y + 8, false);

// ИКОНКА СЕРДЦА (HP) - слева
var heart_x = x - 45;
if (sprite_exists(spr_heart)) {
    // Рисуем спрайт сердечка
    draw_sprite(spr_heart, 0, heart_x, stats_y-5);
} else {
    // Запасной вариант текстом
    draw_set_color(c_red);
    draw_text(heart_x - 5, stats_y - 20, "❤");
}

// Текст HP рядом с иконкой
draw_set_color(c_white);
draw_text(heart_x + 30, stats_y - 18, string(floor(hp)));



// ИКОНКА МЕЧА (УРОН) - справа
var sword_x = x + 13;
if (sprite_exists(spr_sword)) {
    // Рисуем спрайт меча
    draw_sprite(spr_sword, 0, sword_x, stats_y-5);
} else {
    // Запасной вариант текстом
    draw_set_color(c_silver);
    draw_text(sword_x - 5, stats_y - 10, "⚔");
}

// Текст урона рядом с иконкой
draw_set_color(c_white);
draw_text(sword_x + 20, stats_y - 18, string_format(damage, 0, 0));

//alarm[0]
image_blend = c_white;
// Рисуем спрайт мага
draw_self();

// ===== ИНТЕРФЕЙС НАД МАГОМ =====
draw_set_halign(fa_center);

// 1. КРУЖОК С УРОВНЕМ
var level_circle_y = y - 80;
var circle_radius = 20;

draw_set_color(c_white);
draw_circle(x, level_circle_y, circle_radius, true);
draw_set_color(c_gray);
draw_circle(x, level_circle_y, circle_radius, false);

draw_set_color(c_white);
draw_set_font(fnt_level);
draw_text(x, level_circle_y-10 , string(hero_level));
draw_set_font(fnt_m);

// 2. ПОКАЗАТЕЛИ
var stats_y = y - 40;

// ИКОНКА СЕРДЦА (HP)
var heart_x = x - 45;
if (sprite_exists(spr_heart)) {
    draw_sprite(spr_heart, 0, heart_x, stats_y-5);
} else {
    draw_set_color(c_red);
    draw_text(heart_x - 5, stats_y - 20, "❤");
}

draw_set_color(c_white);
draw_text(heart_x + 30, stats_y - 18, string(floor(hp)));

// ИКОНКА МАГИИ (вместо меча)
var magic_x = x + 13;
if (sprite_exists(spr_magic)) { // Нужно создать spr_magic
    draw_sprite(spr_magic, 0, magic_x, stats_y-5);
} else {
    draw_set_color(c_purple);
    draw_text(magic_x - 5, stats_y - 10, "✨"); // Иконка магии
}

// Текст урона рядом с иконкой
draw_set_color(c_white);
draw_text(magic_x + 20, stats_y - 18, string(damage));

draw_set_halign(fa_left);
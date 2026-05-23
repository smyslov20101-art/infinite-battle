// Копируем из obj_enemy Draw
// Проверяем жив ли враг
if (!alive) exit;

// Рисуем спрайт врага
draw_self();

// ===== УПРОЩЕННЫЙ ИНТЕРФЕЙС =====
draw_set_halign(fa_center);

var stats_y = y - 40;
// ИКОНКА СЕРДЦА (HP) - слева
var heart_x = x - 10;
if (sprite_exists(spr_heart)) {
    draw_sprite(spr_heart, 0, heart_x, stats_y-5);
} else {
    draw_set_color(c_red);
    draw_text(heart_x - 5, stats_y - 20, "❤");
}

// Текст HP рядом с иконкой
draw_set_color(c_white);
draw_text(heart_x + 30, stats_y - 18, string(floor(hp)));

// ИКОНКА МЕЧА (УРОН) - справа
var sword_x = x + 13;
if (sprite_exists(spr_sword)) {
    draw_sprite(spr_sword, 0, sword_x-23, stats_y-30);
} else {
    draw_set_color(c_silver);
    draw_text(sword_x - 5, stats_y - 10, "⚔");
}

// Текст урона рядом с иконкой
draw_set_color(c_white);
draw_text(sword_x + 5, stats_y -42, string(floor(damage)));



draw_set_halign(fa_left);
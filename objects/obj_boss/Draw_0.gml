// Рисуем спрайт мини-босса
draw_self();

// ===== ПОЛОСКА ЗДОРОВЬЯ =====


// ===== ОСНОВНОЙ ИНТЕРФЕЙС (как у обычных врагов) =====
draw_set_halign(fa_center);

var stats_y = y - 40;

// ИКОНКА СЕРДЦА
var heart_x = x + 30;
if (sprite_exists(spr_heart)) {
    draw_sprite(spr_heart, 0, heart_x, stats_y-55);
} else {
    draw_set_color(c_red);
    draw_text(heart_x - 5, stats_y - 20, "❤");
}

// Текст HP
draw_set_color(c_white);
draw_text(heart_x + 35, stats_y - 65, string(floor(hp)));

// ИКОНКА УРОНА
var sword_x = x + 53;
if (sprite_exists(spr_sword)) {
    draw_sprite(spr_sword, 0, sword_x-23, stats_y-80);
} else {
    draw_set_color(c_silver);
    draw_text(sword_x - 5, stats_y - 10, "⚔");
}

// Текст урона
draw_set_color(c_white);
draw_text(sword_x + 5, stats_y - 90, string(floor(damage)));

// Метка МИНИ-БОСС
draw_set_color(c_yellow);
draw_text(x + 55, y - 155, "БОСС");

draw_set_halign(fa_left);
draw_set_color(c_white);
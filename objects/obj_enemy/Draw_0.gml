// Draw Event - obj_enemy / obj_enemy_archer

// Проверяем жив ли враг
if (!alive) exit;

// Рисуем спрайт врага
draw_self();

// ===== ИНТЕРФЕЙС НАД ВРАГОМ =====
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_m);

// 1. УРОН (сверху)
var damage_y = y - 60;

// Иконка меча
if (sprite_exists(spr_sword)) {
    draw_sprite(spr_sword, 0, x, damage_y);
} else {
    draw_set_color(c_silver);
    draw_text(x, damage_y, "⚔");
}

// Текст урона ПОД иконкой
draw_set_color(c_white);
draw_text(x, damage_y + 18, string(floor(damage)));

// 2. ЗДОРОВЬЕ (под уроном)
var health_y = y - 25;

// Иконка сердца
if (sprite_exists(spr_heart)) {
    draw_sprite(spr_heart, 0, x, health_y);
} else {
    draw_set_color(c_red);
    draw_text(x, health_y, "❤");
}

// Текст ХР ПОД иконкой
draw_set_color(c_white);
draw_text(x, health_y + 18, string(floor(hp)));

// Возвращаем настройки
draw_set_halign(fa_left);
draw_set_valign(fa_top);
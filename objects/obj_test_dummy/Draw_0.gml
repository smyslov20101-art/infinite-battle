/// Draw Event - obj_test_dummy

// Рисуем спрайт (если есть)
draw_self();

// Если нет спрайта, рисуем круг
if (sprite_index == -1 || !sprite_exists(sprite_index)) {
    draw_set_color(image_blend);
    draw_circle(x, y, 35, true);
    draw_set_color(c_white);
    draw_circle(x, y, 35, false);
    
    // Рисуем надпись "ТЕСТ"
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_set_font(fnt_m);
    draw_text(x, y, "ТЕСТ");
}

// ===== ПОЛОСКА ЗДОРОВЬЯ (ПОДНЯТА ВЫШЕ) =====
var bar_width = 200;
var bar_height = 20;
var bar_x = x - bar_width/2;
var bar_y = y - 170;  // Фиксированное смещение вверх
var hp_percent = hp / max_hp;

// Фон полоски
draw_set_color(c_black);
draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);

// Заполнение (зеленое)
draw_set_color(c_green);
draw_rectangle(bar_x, bar_y, bar_x + bar_width * hp_percent, bar_y + bar_height, false);

// Обводка
draw_set_color(c_white);
draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, true);

// Текст HP
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_m);
draw_text(x, bar_y + bar_height/2, string(floor(hp)) + " / " + string(max_hp));

draw_set_halign(fa_left);
draw_set_valign(fa_top);
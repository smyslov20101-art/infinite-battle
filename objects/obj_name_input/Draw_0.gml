/// Draw Event - obj_name_input

// Затемняем фон
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(0, 0, room_width, room_height, true);
draw_set_alpha(1.0);

// Рамка окна
draw_set_color(c_yellow);
draw_rectangle(window_x, window_y, window_x + window_width, window_y + window_height, false);

// Фон окна
draw_set_color(make_color_rgb(50, 50, 70));
draw_rectangle(window_x + 2, window_y + 2, window_x + window_width - 2, window_y + window_height - 2, false);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Заголовок
draw_set_color(c_yellow);
draw_set_font(fnt_m);
draw_text(window_x + window_width/2, window_y + 50, "ДОБРО ПОЖАЛОВАТЬ!");

// Подзаголовок
draw_set_color(c_white);
draw_set_font(fnt_m);
draw_text(window_x + window_width/2, window_y + 90, "Введите ваш ник:");

// Поле ввода
draw_set_color(make_color_rgb(80, 80, 100));
draw_rectangle(input_x, input_y, input_x + input_width, input_y + input_height, false);

// Текст в поле
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_text(input_x + 10, input_y + input_height/2, player_name);

// Курсор
if (cursor_visible && input_active) {
    var text_width = string_width(player_name);
    draw_set_color(c_white);
    draw_line(input_x + 10 + text_width, input_y + 10, 
              input_x + 10 + text_width, input_y + input_height - 10);
}

// Информация о длине
draw_set_color(make_color_rgb(180, 180, 180));
draw_set_font(fnt_m);
draw_text(input_x + input_width - 50, input_y + input_height + 15, 
          string(string_length(player_name)) + "/" + string(max_name_length));

// Кнопка "СОХРАНИТЬ"
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var btn_color = make_color_rgb(80, 150, 255);
var mouse_over = (mouse_x >= button_x && mouse_x <= button_x + button_width &&
                  mouse_y >= button_y && mouse_y <= button_y + button_height);

if (mouse_over) {
    btn_color = make_color_rgb(120, 180, 255);
}

draw_set_color(btn_color);
draw_rectangle(button_x, button_y, button_x + button_width, button_y + button_height, false);
draw_set_color(c_white);
draw_rectangle(button_x, button_y, button_x + button_width, button_y + button_height, true);
draw_set_font(fnt_m);
draw_text(button_x + button_width/2, button_y + button_height/2, "СОХРАНИТЬ");

// Возвращаем настройки
draw_set_halign(fa_left);
draw_set_valign(fa_top);
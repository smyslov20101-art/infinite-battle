/// Draw Event - obj_test_button

// Фон кнопки
draw_set_color(current_col);
draw_rectangle(x - btn_width/2, y - btn_height/2, 
               x + btn_width/2, y + btn_height/2, false);

// Обводка
draw_set_color(c_black);
draw_rectangle(x - btn_width/2, y - btn_height/2, 
               x + btn_width/2, y + btn_height/2, true);

// Текст
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x, y, btn_text);
draw_set_halign(fa_left);
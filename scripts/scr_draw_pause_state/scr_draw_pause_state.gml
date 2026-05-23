/// @function draw_pause_state()
/// @desc Отрисовка окна паузы

function draw_pause_state() {
    // Затемняем экран (чуть меньше чем при game over)
    draw_set_color(c_black);
    draw_set_alpha(0.5);
    draw_rectangle(0, 0, room_width, room_height, true);
    draw_set_alpha(1.0);
    
    // ===== ОКНО ПАУЗЫ =====
    var window_width = 400;
    var window_height = 250;
    var window_x = (room_width - window_width) / 2;
    var window_y = (room_height - window_height) / 2;
    
    // Рамка окна (желтая для паузы)
    draw_set_color(c_yellow);
    draw_rectangle(window_x - 2, window_y - 2, 
                   window_x + window_width + 2, 
                   window_y + window_height + 2, false);
    
    // Фон окна
    draw_set_color(make_color_rgb(40, 40, 50));
    draw_rectangle(window_x, window_y, 
                   window_x + window_width, 
                   window_y + window_height, false);
    
    // Заголовок "ПАУЗА"
    draw_set_font(fnt_m);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Тень заголовка
    draw_set_color(c_black);
    draw_text(window_x + window_width/2 + 2, window_y + 40 + 2, "ПАУЗА");
    
    // Основной заголовок
    draw_set_color(c_yellow);
    draw_set_font(fnt_m);
    draw_text(window_x + window_width/2, window_y + 40, "ПАУЗА");
    
    // Разделительная линия
    draw_set_color(make_color_rgb(80, 80, 100));
    draw_line(window_x + 30, window_y + 80, 
              window_x + window_width - 30, window_y + 80);
    
    // ===== КНОПКА "ПРОДОЛЖИТЬ" =====
    var btn_width = 180;
    var btn_height = 50;
    var btn_x = window_x + (window_width - btn_width) / 2;
    var btn_y = window_y + 120;
    
    // Проверяем наведение мыши
    var mouse_over_continue = (mouse_x >= btn_x && mouse_x <= btn_x + btn_width &&
                               mouse_y >= btn_y && mouse_y <= btn_y + btn_height);
    
    // Рисуем кнопку "Продолжить"
    if (mouse_over_continue) {
        draw_set_color(make_color_rgb(70, 170, 70)); // Светлее при наведении
    } else {
        draw_set_color(make_color_rgb(50, 130, 50)); // Зеленый
    }
    draw_rectangle(btn_x, btn_y, btn_x + btn_width, btn_y + btn_height, false);
    
    // Обводка кнопки
    draw_set_color(c_white);
    draw_rectangle(btn_x, btn_y, btn_x + btn_width, btn_y + btn_height, true);
    
    // Текст кнопки
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(btn_x + btn_width/2, btn_y + btn_height/2, "ПРОДОЛЖИТЬ");
    
    // ===== КНОПКА "СДАТЬСЯ" =====
    var surrender_btn_y = window_y + 180;
    
    // Проверяем наведение мыши
    var mouse_over_surrender = (mouse_x >= btn_x && mouse_x <= btn_x + btn_width &&
                                mouse_y >= surrender_btn_y && mouse_y <= surrender_btn_y + btn_height);
    
    // Рисуем кнопку "Сдаться"
    if (mouse_over_surrender) {
        draw_set_color(make_color_rgb(200, 70, 70)); // Светлее при наведении
    } else {
        draw_set_color(make_color_rgb(150, 50, 50)); // Красный
    }
    draw_rectangle(btn_x, surrender_btn_y, btn_x + btn_width, surrender_btn_y + btn_height, false);
    
    // Обводка кнопки
    draw_set_color(c_white);
    draw_rectangle(btn_x, surrender_btn_y, btn_x + btn_width, surrender_btn_y + btn_height, true);
    
    // Текст кнопки
    draw_set_color(c_white);
    draw_text(btn_x + btn_width/2, surrender_btn_y + btn_height/2, "СДАТЬСЯ");
    
    // Возвращаем выравнивание
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
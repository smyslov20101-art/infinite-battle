/// Create Event - obj_test_button

btn_text = "ТЕСТ";
btn_width = 120;
btn_height = 60;

// Позиция под кнопкой ИГРАТЬ
x = room_width / 2;
y = room_height / 2 + 250;  // На 100 пикселей ниже кнопки ИГРАТЬ

// Цвета
col = make_color_rgb(100, 100, 150);
hover_col = make_color_rgb(140, 140, 200);
click_col = make_color_rgb(180, 180, 220);
current_col = col;

is_hovered = false;
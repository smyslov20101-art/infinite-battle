/// Create Event - obj_play_button.gml


btn_width = 200;
btn_height = 80;

// Позиция по центру экрана
x = room_width / 2;
y = 750;  // Это центр, кнопка ТЕСТ будет ниже

// Цвета
col = make_color_rgb(50, 150, 50);
hover_col = make_color_rgb(100, 200, 100);
click_col = make_color_rgb(150, 255, 150);
current_col = col;

is_hovered = false;
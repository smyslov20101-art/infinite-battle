/// Create Event - obj_profile_button

// Позиция в правом верхнем углу (под шторкой ресурсов)
x = 62;   // Правый край с отступом
y = 50;                // Высота шторки/2

// Размеры кнопки (для спрайта)
btn_width = 48;
btn_height = 48;

// Цвета (если спрайт не загрузится)
col = make_color_rgb(100, 100, 150);
hover_col = make_color_rgb(140, 140, 200);
current_col = col;

is_hovered = false;

// Состояния окна профиля
PROFILE_STATE_NONE = 0;
PROFILE_STATE_SHOWING = 1;
profile_state = PROFILE_STATE_NONE;

// Параметры окна профиля
window_x = (room_width - 400) / 2;
window_y = (room_height - 400) / 2;
window_width = 400;
window_height = 400;

// Кнопка закрытия
close_button_x = window_x + window_width - 50;
close_button_y = window_y + 10;
close_button_size = 30;

// Кнопка смены ника
change_name_button_x = window_x + (window_width - 180) / 2;
change_name_button_y = window_y + 300;
change_name_button_width = 180;
change_name_button_height = 40;

// Флаг для первого открытия
profile_just_opened = false;
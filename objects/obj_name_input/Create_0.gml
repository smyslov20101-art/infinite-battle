/// Create Event - obj_name_input

// Параметры окна
window_x = (room_width - 500) / 2;
window_y = (room_height - 300) / 2;
window_width = 500;
window_height = 300;

// Поле ввода
input_x = window_x + 50;
input_y = window_y + 150;
input_width = 400;
input_height = 40;

// Текст
player_name = "";
max_name_length = 20;

// Кнопка
button_x = window_x + (window_width - 180) / 2;
button_y = window_y + 220;
button_width = 180;
button_height = 40;

// Состояние
input_active = true;
name_saved = false;

// Мигающий курсор
cursor_timer = 0;
cursor_visible = true;

// Флаг для возврата в профиль
from_profile = false;

LOG("=== ОКНО ВВОДА НИКА СОЗДАНО ===");
/// Create Event - obj_upgrade_window

// Забираем данные из глобальных временных переменных
hero_tree = global.temp_upgrade_hero_tree;
level = global.temp_upgrade_level;
is_left = global.temp_upgrade_is_left;
upgrade_type = global.temp_upgrade_type;
upgrade_value = global.temp_upgrade_value;
upgrade_name = global.temp_upgrade_name;
upgrade_cost = global.temp_upgrade_cost;

// ОЧИЩАЕМ глобальные временные переменные
global.temp_upgrade_hero_tree = noone;
global.temp_upgrade_level = 0;
global.temp_upgrade_is_left = true;
global.temp_upgrade_type = "";
global.temp_upgrade_value = 0;
global.temp_upgrade_name = "";
global.temp_upgrade_cost = 0;

// Параметры окна
window_x = (room_width - 400) / 2;
window_y = (room_height - 300) / 2;
window_width = 400;
window_height = 300;

// Кнопка "Улучшить"
button_x = window_x + (window_width - 180) / 2;
button_y = window_y + window_height - 70;
button_width = 180;
button_height = 40;

// Флаги
just_opened = true;
ignore_first_click = true;  // НОВЫЙ ФЛАГ - игнорируем первый клик после открытия

// Глубина (поверх всего)
depth = -9;

// Глобальный флаг
global.upgrade_window_open = true;

LOG("=== CREATE ОКНО УЛУЧШЕНИЯ ===");
LOG("upgrade_type = " + string(upgrade_type));
LOG("upgrade_value = " + string(upgrade_value));
LOG("upgrade_cost = " + string(upgrade_cost));
LOG("upgrade_name = " + string(upgrade_name));
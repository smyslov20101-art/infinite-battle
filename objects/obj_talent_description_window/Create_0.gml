/// Create Event - obj_talent_description_window

talent_name = "";
talent_description = "";

// СРАЗУ УСТАНАВЛИВАЕМ ФЛАГ
global.talent_desc_window_open = true;
LOG("=== CREATE: УСТАНОВЛЕН ФЛАГ talent_desc_window_open = true ===");

// Размер под рамку Маши из Figma (626×371)
window_width = 626;
window_height = 371;
window_x = (room_width - window_width) / 2;
window_y = (room_height - window_height) / 2 + 50;

// Кнопка "ЗАКРЫТЬ" будет внизу окна
button_x = 0;
button_y = 0;
button_width = 140;
button_height = 45;

just_opened = true;
depth = -7;
global.talent_desc_window_open = true;

LOG("=== ОТКРЫТО ОКНО ОПИСАНИЯ ТАЛАНТА ===");
LOG("Талант: " + talent_name);
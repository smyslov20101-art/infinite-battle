/// Create Event - obj_daily_quests_button

LOG("=== СОЗДАН obj_daily_quests_button ===");

// Размеры кнопки
btn_width = 122;
btn_height = 104;

// Позиция кнопки (установишь в комнате)
x = 62;
y = 145;  // Под кнопкой наград

// Эффекты
is_hovered = false;

// Для отладки
frame_counter = 0;

// ===== СОСТОЯНИЯ ОКНА =====
QUEST_STATE_NONE = 0;
QUEST_STATE_SHOWING = 1;

quest_state = QUEST_STATE_NONE;
LOG("quest_state инициализирован: " + string(quest_state));

// ===== ПАРАМЕТРЫ ОКНА =====
window_x = 0;
window_y = 0;
window_width = 500;
window_height = 400;

// Кнопки в окне (если нужны)
button_x = 0;
button_y = 0;
button_width = 180;
button_height = 40;

// Флаги
quests_just_opened = false;
quest_clicked_id = -1;

// Глубина
depth = -100;
LOG("depth = -100");

LOG("=== obj_daily_quests_button готов ===");
/// Create Event - obj_rewards_button

LOG("=== СОЗДАН obj_rewards_button ===");

// Размеры кнопки
btn_width = 122;
btn_height = 104;

// Позиция кнопки (установишь в комнате)
x = 62;
y = 245;

// Эффекты
is_hovered = false;
normal_alpha = 1;
hover_alpha = 0.8;

// Пульсация
pulse_timer = 0;
pulse_dir = 1;

// Для отладки (счётчик кадров)
frame_counter = 0;  // ← ДОБАВЛЕНА ЭТА СТРОКА!

// ===== СОСТОЯНИЯ ОКНА =====
REWARDS_STATE_NONE = 0;
REWARDS_STATE_SHOWING = 1;
REWARDS_STATE_CHEST_DETAIL = 2;
REWARDS_STATE_CHEST_OPEN = 3;

rewards_state = REWARDS_STATE_NONE;
LOG("rewards_state инициализирован: " + string(rewards_state));

// ===== ПАРАМЕТРЫ ОКНА =====
window_x = 0;
window_y = 0;
window_width = 500;
window_height = 550;

button_x = 0;
button_y = 0;
button_width = 180;
button_height = 40;

// Флаги
rewards_just_opened = false;
chest_just_opened = false;
current_chest = noone;
current_chest_rewards = [];

// Глубина
depth = -100;
LOG("depth = -100");

LOG("=== obj_rewards_button готов ===");
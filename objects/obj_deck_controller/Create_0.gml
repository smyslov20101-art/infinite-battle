/// @desc Контроллер экрана колоды

// Инициализируем систему героев (если еще не инициализирована)
if (!variable_global_exists("heroes")) {
    init_hero_manager();
    LOG("Система героев инициализирована");
}

// Проверяем что у нас есть данные героев
if (array_length(global.heroes) == 0) {
    LOG("Ошибка: массив героев пустой!");
    // Создаем тестовых героев
    init_hero_manager();
}

// Состояния экрана
SCREEN_STATE_LIST = 0;
SCREEN_STATE_HERO_DETAIL = 1;
SCREEN_STATE_SELECT_SLOT = 2;
current_state = SCREEN_STATE_LIST;
selected_hero_id = -1;

// Настройки прокрутки
scroll_y = 0;
scroll_max = 0;
is_dragging = false;
drag_start_y = 0;
scroll_start_y = 0;

card_open_timer = 0;  // Таймер блокировки кнопок после открытия карточки

// Защита от «протекающего» клика из навигации:
// release без предшествующего press в этой комнате — игнорируем.
saw_fresh_press = false;

// Размеры элементов карточек (УВЕЛИЧИМ!)
hero_card_width = 172;      // Было 120
hero_card_height = 223;     // Было 160
hero_card_spacing = 15;     // Увеличил отступ между карточками (было 25)
cards_per_row = 4;

// Область видимости карточек
visible_area_top = 0;
visible_area_bottom = 0;

// Отряд (4 слота сверху) - ПОДНИМЕМ ЕЩЕ ВЫШЕ
slot_width = 100;
slot_height = 140;
slot_spacing = 30;
slots_start_x = (room_width - (4 * slot_width + 3 * slot_spacing)) / 2;
slots_start_y = 160; // БЫЛО 180 - ПОДНИМАЕМ ЧУТЬ ВЫШЕ

// Позиции для списка карточек - НИЖЕ ОТРЯДА
list_start_x = 0;
list_start_y = slots_start_y + slot_height + 40+150;

// Шторка ресурсов (сверху)
resources_height = 80;

// Для проверки клика вне карточки
detail_card_clickable = false;
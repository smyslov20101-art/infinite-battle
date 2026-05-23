/// Create Event - obj_rating_controller

// Параметры скролла
scroll_y = 0;
scroll_max = 0;
is_dragging = false;
drag_start_y = 0;
scroll_start_y = 0;

// Параметры списка
list_start_x = 100;
list_start_y = 200;
list_width = room_width - 200;
row_height = 40;
visible_rows = 20; // Сколько строк видно одновременно

// Заголовки
title_y = 120;

// Данные рейтинга
rating_players = [];
if (variable_global_exists("permanent_save") && 
    struct_exists(global.permanent_save, "rating_data") &&
    array_length(global.permanent_save.rating_data.players) > 0) {
    rating_players = global.permanent_save.rating_data.players;
    LOG("Загружены данные рейтинга: " + string(array_length(rating_players)) + " записей");
} else {
    // Если нет данных, создаем тестовые (100 записей)
    LOG("Нет данных рейтинга, создаем тестовые 100 записей...");
    add_test_rating_data();
    rating_players = global.permanent_save.rating_data.players;
    // Сохраняем в файл
    save_permanent_to_file();
}

// Вычисляем максимальный скролл
var total_rows = array_length(rating_players);
var total_height = total_rows * row_height;
scroll_max = max(0, total_height - visible_rows * row_height);

// Текущий ник игрока
player_name = global.player_name;

// Кнопка "Обновить" (если нужна)
refresh_button_x = room_width - 150;
refresh_button_y = 50;
refresh_button_width = 120;
refresh_button_height = 40;
refresh_button_hovered = false;

LOG("=== РЕЙТИНГ ИНИЦИАЛИЗИРОВАН ===");
LOG("Всего записей: " + string(total_rows));
LOG("Макс скролл: " + string(scroll_max));
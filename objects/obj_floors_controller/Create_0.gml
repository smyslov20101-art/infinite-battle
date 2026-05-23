/// Create Event - obj_floors_controller

// ===== БОЛЬШЕ НЕ ЗАГРУЖАЕМ ДАННЫЕ ЭТАЖЕЙ =====
// Создаем 3 заглушки для событий (теперь 3, не 4)
events_array = array_create(3);

for (var i = 0; i < 3; i++) {
    events_array[i] = {
        id: i + 1,
        name: "СОБЫТИЕ " + string(i + 1),
        status: "coming_soon", // "active", "completed", "coming_soon"
        unlocked: false,
        completed: false
    };
}

// Спрайты для событий
event_sprites = [spr_event1, spr_event2, spr_event3];

// Параметры отрисовки
start_y = 120;           // Начальная Y позиция (после шторки ресурсов)
spacing = 30;            // Расстояние между спрайтами
bottom_padding = 300;    // Дополнительное пустое место под последним спрайтом (для скролла)

// Начальная позиция для карточек
cards_start_x = 0;  // Будет вычисляться в Draw Event
cards_start_y = start_y;

// Область видимости
visible_area_top = 80;           // После шторки ресурсов
visible_area_bottom = room_height - 200; // До кнопок навигации

// ===== РАССЧИТЫВАЕМ SCROLL_MAX =====
var total_height = 0;

for (var i = 0; i < array_length(event_sprites); i++) {
    var spr = event_sprites[i];
    if (sprite_exists(spr)) {
        total_height += sprite_get_height(spr);
        if (i < array_length(event_sprites) - 1) {
            total_height += spacing;
        }
    }
}

// Добавляем пустое место внизу для скролла
total_height += bottom_padding;

var visible_height = visible_area_bottom - visible_area_top;
scroll_max = max(0, total_height - visible_height);

// Параметры скролла
scroll_y = 0;
is_dragging = false;
drag_start_y = 0;
scroll_start_y = 0;

LOG("=== КОНТРОЛЛЕР СОБЫТИЙ ИНИЦИАЛИЗИРОВАН ===");
LOG("Всего событий: " + string(array_length(events_array)));
LOG("Макс скролл: " + string(scroll_max) + " (с доп. пространством " + string(bottom_padding) + ")");
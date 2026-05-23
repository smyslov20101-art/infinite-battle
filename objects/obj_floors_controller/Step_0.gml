/// Step Event - obj_floors_controller

// Проверяем, первый ли это кадр в комнате
if (!variable_instance_exists(id, "room_entered")) {
    room_entered = true;
    LOG("🔄 Вход в комнату СОБЫТИЯ");
}

// Обработка скролла колесиком
if (mouse_wheel_up()) {
    scroll_y -= 30;
    scroll_y = max(0, scroll_y);
}

if (mouse_wheel_down()) {
    scroll_y += 30;
    scroll_y = min(scroll_max, scroll_y);
}

// Обработка перетаскивания для скролла
if (mouse_check_button_pressed(mb_left)) {
    // Проверяем, попали ли в область списка событий
    var mouse_in_list_area = mouse_y >= visible_area_top && mouse_y <= visible_area_bottom;
    
    if (mouse_in_list_area) {
        // Начинаем перетаскивание (клик по событию игнорируем, только скролл)
        is_dragging = true;
        drag_start_y = mouse_y;
        scroll_start_y = scroll_y;
    }
}

// Перетаскивание
if (mouse_check_button(mb_left) && is_dragging) {
    var drag_delta = drag_start_y - mouse_y;
    scroll_y = scroll_start_y + drag_delta;
    scroll_y = clamp(scroll_y, 0, scroll_max);
}

// Конец перетаскивания
if (mouse_check_button_released(mb_left)) {
    is_dragging = false;
}

// Функция больше не нужна — удаляем или оставляем пустую
function check_event_click(_mx, _my, _scroll_y) {
    return -1;  // Всегда возвращаем -1 (ничего не выбрано)
}
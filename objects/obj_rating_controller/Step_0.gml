/// Step Event - obj_rating_controller

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
    // Проверяем, попали ли в область списка
    var list_top = 300;  // table_start_y
    var list_bottom = 300 + visible_rows * row_height;
    var list_left = (room_width - 800) / 2;
    var list_right = list_left + 800;
    
    if (mouse_x >= list_left && mouse_x <= list_right &&
        mouse_y >= list_top && mouse_y <= list_bottom) {
        
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

// Дебаг-скролл по клавише S (только в DEBUG-сборке)
if (DEBUG_BUILD && keyboard_check_pressed(ord("S"))) {
    scroll_y = min(scroll_max, scroll_y + 30);
    LOG("scroll_y = " + string(scroll_y) + " / " + string(scroll_max));
    LOG("rating_players length = " + string(array_length(rating_players)));
    LOG("scroll_max = " + string(scroll_max));
}
/// Step Event - obj_talent_description_window

// Убеждаемся, что флаг открытого окна установлен
if (!global.talent_desc_window_open) {
    global.talent_desc_window_open = true;
}

// Закрытие по ESC
if (IS_BACK_PRESSED) {
    global.talent_desc_window_open = false;
    instance_destroy();
    exit;
}

// Сброс флага после первого кадра
if (just_opened) {
    just_opened = false;
    exit;
}

// Обработка кликов
if (mouse_check_button_released(mb_left)) {
    
    // Кнопка "ЗАКРЫТЬ" - проверяем строго по координатам
    if (mouse_x >= button_x && mouse_x <= button_x + button_width &&
        mouse_y >= button_y && mouse_y <= button_y + button_height) {
        global.talent_desc_window_open = false;
        instance_destroy();
        exit;
    }
    
    // Клик вне окна
    if (mouse_x < window_x || mouse_x > window_x + window_width ||
        mouse_y < window_y || mouse_y > window_y + window_height) {
        global.talent_desc_window_open = false;
        instance_destroy();
        exit;
    }
}

// Блокируем все клики внутри окна (кроме кнопки закрытия)
if (mouse_check_button_pressed(mb_left) || mouse_check_button_released(mb_left)) {
    if (mouse_x >= window_x && mouse_x <= window_x + window_width &&
        mouse_y >= window_y && mouse_y <= window_y + window_height) {
        // Если это не кнопка закрытия - поглощаем клик
        if (!(mouse_x >= button_x && mouse_x <= button_x + button_width &&
              mouse_y >= button_y && mouse_y <= button_y + button_height)) {
            exit;
        }
    }
}
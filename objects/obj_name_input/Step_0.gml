/// Step Event - obj_name_input

// Мигание курсора
cursor_timer += 1 / room_speed;
if (cursor_timer >= 0.5) {
    cursor_timer = 0;
    cursor_visible = !cursor_visible;
}

// ===== ТОЛЬКО ДЛЯ ПК =====
// Пока оставим только ПК-версию для разработки

// Проверяем нажатия клавиш
if (keyboard_check_pressed(vk_anykey)) {
    
    var key = keyboard_lastkey;
    
    // Буквы (A-Z, a-z)
    if ((key >= ord("A") && key <= ord("Z")) || 
        (key >= ord("a") && key <= ord("z"))) {
        
        if (string_length(player_name) < max_name_length) {
            player_name += chr(key);
        }
    }
    
    // Цифры
    if (key >= ord("0") && key <= ord("9")) {
        if (string_length(player_name) < max_name_length) {
            player_name += chr(key);
        }
    }
    
    // Пробел
    if (key == ord(" ")) {
        if (string_length(player_name) < max_name_length) {
            player_name += " ";
        }
    }
    
    // Нижнее подчеркивание и дефис
    if (key == ord("_") || key == ord("-")) {
        if (string_length(player_name) < max_name_length) {
            player_name += chr(key);
        }
    }
}

// Backspace - удаление последнего символа
if (keyboard_check_pressed(vk_backspace)) {
    if (string_length(player_name) > 0) {
        player_name = string_copy(player_name, 1, string_length(player_name) - 1);
    }
}

// Enter - сохранение
if (keyboard_check_pressed(vk_enter)) {
    if (string_length(player_name) > 0) {
        save_player_name();
    }
}

// Обработка клика мыши
if (mouse_check_button_pressed(mb_left)) {
    
    // Проверяем клик по кнопке "СОХРАНИТЬ"
    if (mouse_x >= button_x && mouse_x <= button_x + button_width &&
        mouse_y >= button_y && mouse_y <= button_y + button_height) {
        
        if (string_length(player_name) > 0) {
            save_player_name();
        } else {
            // Если имя пустое, используем "Игрок"
            player_name = "Игрок";
            save_player_name();
        }
    }
}

// Функция сохранения ника
function save_player_name() {
    if (string_length(player_name) == 0) {
        player_name = "Игрок";
    }
    
    // Сохраняем в global
    global.player_name = player_name;
    
    // Сохраняем в permanent_save
    if (variable_global_exists("permanent_save")) {
        global.permanent_save.player_name = player_name;
        
        // ===== ВАЖНО: Сохраняем в файл =====
        save_permanent_to_file();
        LOG("=== НИК СОХРАНЕН В ФАЙЛ: " + player_name + " ===");
    }
    
    LOG("=== НИК СОХРАНЕН: " + player_name + " ===");
    
    // Если мы пришли из профиля, возвращаемся в профиль
    if (variable_instance_exists(id, "from_profile") && from_profile) {
        instance_destroy();
    } else {
        instance_destroy();
    }
}

// Обработка закрытия окна
if (IS_BACK_PRESSED) {
    instance_destroy();
}
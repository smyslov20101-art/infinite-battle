/// Step Event - obj_profile_controller

// Получаем данные игрока
if (variable_global_exists("permanent_save")) {
    player_name = global.permanent_save.player_name;
    player_stats = global.permanent_save.player_stats;
} else {
    player_name = "Игрок";
    player_stats = {
        best_time: 0,
        total_kills: 0,
        games_played: 0
    };
}

// Параметры кнопки "Назад"
back_button_x = 50;
back_button_y = 100;
back_button_width = 100;
back_button_height = 40;

// Параметры кнопки "Сменить ник"
change_name_button_x = (room_width - 500) / 2 + (500 - 180) / 2;
change_name_button_y = 200 + 250 - 50; // card_y + card_height - 50
change_name_button_width = 180;
change_name_button_height = 40;

// Проверка наведения на кнопку "Назад"
back_button_hovered = (mouse_x >= back_button_x && mouse_x <= back_button_x + back_button_width &&
                       mouse_y >= back_button_y && mouse_y <= back_button_y + back_button_height);

// Проверка наведения на кнопку "Сменить ник"
change_name_hovered = (mouse_x >= change_name_button_x && mouse_x <= change_name_button_x + change_name_button_width &&
                       mouse_y >= change_name_button_y && mouse_y <= change_name_button_y + change_name_button_height);

// Обработка кликов
if (mouse_check_button_pressed(mb_left)) {
    
    // Кнопка "Назад"
    if (back_button_hovered) {
        room_goto(room_wave);
    }
    
    // Кнопка "Сменить ник"
    if (change_name_hovered) {
        // Создаем окно ввода ника
        var name_input = instance_create_layer(0, 0, "Instances", obj_name_input);
        name_input.from_profile = true; // Флаг, что пришли из профиля
    }
}
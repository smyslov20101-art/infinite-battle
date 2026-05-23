/// Create Event - obj_profile_controller

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
back_button_x = 100;
back_button_y = 100;
back_button_width = 120;
back_button_height = 40;
back_button_hovered = false;

// Параметры кнопки "Сменить ник"
change_name_button_x = room_width/2 - 90;
change_name_button_y = 500;
change_name_button_width = 180;
change_name_button_height = 40;
change_name_hovered = false;
/// Draw Event - obj_profile_controller

// Фон
draw_set_color(make_color_rgb(30, 30, 40));
draw_rectangle(0, 0, room_width, room_height, true);

// Шторка ресурсов
draw_set_color(make_color_rgb(40, 40, 50));
draw_rectangle(0, 0, room_width, 80, false);

draw_set_color(c_white);
draw_set_font(fnt_m);
draw_set_halign(fa_left);
draw_text(50, 30, "ГЕНЫ: " + string(floor(global.genes)));
draw_text(250, 30, "КРИСТАЛЛЫ: " + string(global.crystals));

// Кнопка "Назад" в левом верхнем углу
back_button_x = 50;
back_button_y = 100;
back_button_width = 100;
back_button_height = 40;

if (back_button_hovered) {
    draw_set_color(make_color_rgb(140, 140, 200));
} else {
    draw_set_color(make_color_rgb(100, 100, 150));
}
draw_rectangle(back_button_x, back_button_y, 
               back_button_x + back_button_width, 
               back_button_y + back_button_height, false);
draw_set_color(c_white);
draw_rectangle(back_button_x, back_button_y, 
               back_button_x + back_button_width, 
               back_button_y + back_button_height, true);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(back_button_x + back_button_width/2, 
          back_button_y + back_button_height/2, "НАЗАД");


// Карточка профиля
var card_x = (room_width - 500) / 2;
var card_y = 200;
var card_width = 500;
var card_height = 250; // Уменьшил высоту

// Рамка
draw_set_color(c_yellow);
draw_rectangle(card_x, card_y, card_x + card_width, card_y + card_height, false);

// Фон карточки
draw_set_color(make_color_rgb(50, 50, 70));
draw_rectangle(card_x + 2, card_y + 2, card_x + card_width - 2, card_y + card_height - 2, false);

// Информация
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_font(fnt_m);

// Ник
draw_text(card_x + 50, card_y + 40, "НИК:");
draw_set_color(c_yellow);
draw_text(card_x + 250, card_y + 40, player_name);

// Лучшее время
draw_set_color(c_white);
draw_text(card_x + 50, card_y + 80, "ЛУЧШЕЕ ВРЕМЯ:");
draw_set_color(c_yellow);

var best_time = player_stats.best_time;
var hours = floor(best_time / 3600);
var minutes = floor((best_time % 3600) / 60);
var seconds = floor(best_time % 60);

var hours_str = string(hours);
if (hours < 10) hours_str = "0" + hours_str;
var minutes_str = string(minutes);
if (minutes < 10) minutes_str = "0" + minutes_str;
var seconds_str = string(seconds);
if (seconds < 10) seconds_str = "0" + seconds_str;

draw_text(card_x + 250, card_y + 80, hours_str + ":" + minutes_str + ":" + seconds_str);

// Убито врагов
draw_set_color(c_white);
draw_text(card_x + 50, card_y + 120, "УБИТО ВРАГОВ:");
draw_set_color(c_yellow);
draw_text(card_x + 250, card_y + 120, string(player_stats.total_kills));

// Сыграно игр
draw_set_color(c_white);
draw_text(card_x + 50, card_y + 160, "СЫГРАНО ИГР:");
draw_set_color(c_yellow);
draw_text(card_x + 250, card_y + 160, string(player_stats.games_played));

// Кнопка "СМЕНИТЬ НИК"
change_name_button_x = card_x + (card_width - 180) / 2;
change_name_button_y = card_y + card_height - 50;
change_name_button_width = 180;
change_name_button_height = 40;

if (change_name_hovered) {
    draw_set_color(make_color_rgb(120, 180, 255));
} else {
    draw_set_color(make_color_rgb(80, 150, 255));
}
draw_rectangle(change_name_button_x, change_name_button_y, 
               change_name_button_x + change_name_button_width, 
               change_name_button_y + change_name_button_height, false);
draw_set_color(c_white);
draw_rectangle(change_name_button_x, change_name_button_y, 
               change_name_button_x + change_name_button_width, 
               change_name_button_y + change_name_button_height, true);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(change_name_button_x + change_name_button_width/2, 
          change_name_button_y + change_name_button_height/2, "СМЕНИТЬ НИК");

// Возвращаем настройки
draw_set_halign(fa_left);
draw_set_valign(fa_top);
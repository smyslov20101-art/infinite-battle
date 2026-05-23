/// Draw Event - obj_upgrade_window

// Сохраняем текущие настройки
var _prev_halign = draw_get_halign();
var _prev_valign = draw_get_valign();
var _prev_color = draw_get_color();
var _prev_alpha = draw_get_alpha();
var _prev_font = draw_get_font();

// Затемняем фон
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(0, 0, room_width, room_height, true);
draw_set_alpha(1.0);

// Рамка окна
draw_set_color(c_yellow);
draw_rectangle(window_x, window_y, window_x + window_width, window_y + window_height, false);

// Фон окна
draw_set_color(make_color_rgb(50, 50, 70));
draw_rectangle(window_x + 2, window_y + 2, window_x + window_width - 2, window_y + window_height - 2, false);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Заголовок
draw_set_color(c_white);
draw_set_font(fnt_m);
draw_text(window_x + window_width/2, window_y + 40, "УЛУЧШЕНИЕ");



// Описание (что даёт)
draw_set_color(c_white);
draw_set_font(fnt_m);

var desc_text = "";
switch (upgrade_type) {
    case "hp": desc_text = "+" + string(upgrade_value) + "% к здоровью"; break;
    case "damage": desc_text = "+" + string(upgrade_value) + "% к урону"; break;
    case "armor": desc_text = "+" + string(upgrade_value) + " к броне"; break;
    case "cleave": desc_text = "+" + string(upgrade_value) + "% к сплешу"; break;
    case "attack_speed": desc_text = "+" + string(upgrade_value) + "% к скорости атаки"; break;
    case "move_speed": desc_text = "+" + string(upgrade_value) + "% к скорости движения"; break;
    case "crit_chance": desc_text = "+" + string(upgrade_value) + "% к шансу крита"; break;
    case "crit_damage": desc_text = "+" + string(upgrade_value) + "% к крит. урону"; break;
    case "lifesteal": desc_text = "+" + string(upgrade_value) + "% вампиризма"; break;
    case "dodge": desc_text = "+" + string(upgrade_value) + "% уклонения"; break;
    case "range": desc_text = "+" + string(upgrade_value) + " к дальности"; break;
    case "regen": desc_text = "Регенерация +" + string(upgrade_value) + " HP/сек"; break;
    case "regen_percent": desc_text = "Регенерация " + string(upgrade_value) + "% от макс HP/сек"; break;
    case "holy_poison": desc_text = "Святое отравление: " + string(upgrade_value) + "% урона/сек на 3 сек"; break;
    case "iceberg": desc_text = "Айсберг: " + string(upgrade_value) + " урона, -30% скор. атаки на 4 сек"; break;
    case "curse": desc_text = "Проклятье: +" + string(upgrade_value) + "% получаемого урона на 4 сек"; break;
    case "song_of_soul": desc_text = "Песнь души: +" + string(upgrade_value) + "% скор. атаки магам на 5 сек"; break;
    case "will_of_chance": desc_text = "Воля случая: +" + string(upgrade_value) + "% шанс крита магам на 5 сек"; break;
    case "phoenix_feather": desc_text = "Феникс: +" + string(upgrade_value) + "% скор. атаки × убийства героя"; break;
    case "dragon_scale": desc_text = "Дракон: +" + string(upgrade_value) + "% урона × минуты игры"; break;
    default: desc_text = upgrade_name;
}

draw_text(window_x + window_width/2, window_y + 140, desc_text);

// Стоимость
draw_set_color(c_yellow);
draw_text(window_x + window_width/2, window_y + 190, "СТОИМОСТЬ: " + string(upgrade_cost) + " 🪙");

// ===== КНОПКА "УЛУЧШИТЬ" =====
// Пересчитываем координаты каждый кадр
button_width = 180;
button_height = 40;
button_x = window_x + (window_width - button_width) / 2;
button_y = window_y + window_height - 70;

var mouse_over = (mouse_x >= button_x && mouse_x <= button_x + button_width &&
                  mouse_y >= button_y && mouse_y <= button_y + button_height);

if (mouse_over) {
    draw_set_color(make_color_rgb(120, 180, 255));
} else {
    draw_set_color(make_color_rgb(80, 150, 255));
}
draw_rectangle(button_x, button_y, button_x + button_width, button_y + button_height, false);

draw_set_color(c_white);
draw_rectangle(button_x, button_y, button_x + button_width, button_y + button_height, true);

draw_set_font(fnt_m);
draw_text(button_x + button_width/2, button_y + button_height/2, "УЛУЧШИТЬ");

// Возвращаем настройки
draw_set_halign(_prev_halign);
draw_set_valign(_prev_valign);
draw_set_color(_prev_color);
draw_set_alpha(_prev_alpha);
draw_set_font(_prev_font);
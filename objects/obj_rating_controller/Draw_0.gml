/// Draw Event - obj_rating_controller

// ===== 1. ФОН УБРАН — рисуется в комнате =====

// ===== 2. ШТОРКА РЕСУРСОВ =====
draw_set_color(make_color_rgb(40, 40, 50));
draw_rectangle(0, 0, room_width, 80, false);

draw_set_color(c_white);
draw_set_font(fnt_main);
draw_set_halign(fa_left);
draw_text(50, 30, "ГЕНЫ: " + string(floor(global.genes)));
draw_text(250, 30, "КРИСТАЛЛЫ: " + string(global.crystals));

// ===== 3. СПРАЙТ spr_top_100 =====
if (sprite_exists(spr_top_100)) {
    var spr_w = sprite_get_width(spr_top_100);
    var spr_h = sprite_get_height(spr_top_100);
    
    var spr_x = room_width / 2;
    var spr_y = 80 + (spr_h / 2);
    
    draw_sprite_ext(spr_top_100, 0, spr_x, spr_y, 1, 1, 0, c_white, 1);
}

// ===== 4. ТАБЛИЦА РЕЙТИНГА =====
var table_width = 800;
var table_start_x = (room_width - table_width) / 2;
var table_start_y = 300;
var table_height = visible_rows * row_height;

// Фон всей таблицы
draw_set_color(make_color_rgb(0, 32, 73));
draw_rectangle(table_start_x - 10, table_start_y - 10, 
               table_start_x + table_width + 10, 
               table_start_y + table_height + 10, true);

// Рисуем список
var total_rows = array_length(rating_players);
var start_index = floor(scroll_y / row_height);
var end_index = min(total_rows - 1, start_index + visible_rows + 1);

for (var i = start_index; i <= end_index; i++) {
    if (i >= total_rows) break;
    
    var player = rating_players[i];
    var y_pos = table_start_y + (i - start_index) * row_height - (scroll_y % row_height);
    
    if (y_pos + row_height < table_start_y || y_pos > table_start_y + visible_rows * row_height) {
        continue;
    }
    
    // Фон строки
    draw_set_color(make_color_rgb(0, 32, 73));
    draw_rectangle(table_start_x, y_pos, table_start_x + table_width, y_pos + row_height, true);
    
    // Подсветка текущего игрока
    var is_current_player = (player.name == global.player_name);
    
    if (is_current_player) {
        // Рисуем обводку строки (цвет #00163C)
        draw_set_color(make_color_rgb(0, 22, 60));
        draw_set_alpha(0.7);
        draw_rectangle(table_start_x, y_pos, table_start_x + table_width, y_pos + row_height, false);
        draw_set_alpha(1.0);
        
        // Стрелка слева
        draw_set_color(make_color_rgb(198, 251, 251));  // #C6FBFB
        draw_set_halign(fa_right);
        draw_text(table_start_x - 10, y_pos + row_height/2, "▶");
    }
    
    // Черная линия между строками
    draw_set_color(c_black);
    draw_line(table_start_x, y_pos + row_height, table_start_x + table_width, y_pos + row_height);
    
    // ===== ВЫБИРАЕМ ЦВЕТ И ШРИФТ ДЛЯ ТЕКСТА =====
    if (is_current_player) {
        draw_set_color(make_color_rgb(198, 251, 251));  // #C6FBFB
        draw_set_font(fnt_main_bold);  // жирный шрифт
    } else {
        draw_set_font(fnt_main);  // обычный шрифт
        
        if (i == 0) {
            draw_set_color(c_yellow);
        } else if (i == 1) {
            draw_set_color(make_color_rgb(192, 192, 192));
        } else if (i == 2) {
            draw_set_color(make_color_rgb(205, 127, 50));
        } else {
            draw_set_color(c_white);
        }
    }
    
    // Место
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(table_start_x + 100, y_pos + row_height/2, string(i+1));
    
    // Имя игрока
    draw_text(table_start_x + table_width/2, y_pos + row_height/2, player.name);
    
    // Время
    var total_seconds = player.time;
    var hours = floor(total_seconds / 3600);
    var minutes = floor((total_seconds % 3600) / 60);
    var seconds = floor(total_seconds % 60);
    
    var hours_str = string(hours);
    if (hours < 10) hours_str = "0" + hours_str;
    var minutes_str = string(minutes);
    if (minutes < 10) minutes_str = "0" + minutes_str;
    var seconds_str = string(seconds);
    if (seconds < 10) seconds_str = "0" + seconds_str;
    
    var time_str = hours_str + ":" + minutes_str + ":" + seconds_str;
    draw_text(table_start_x + table_width - 100, y_pos + row_height/2, time_str);
}

// ===== 5. ИНФОРМАЦИЯ О СКРОЛЛЕ =====
if (scroll_max > 0) {
    draw_set_color(make_color_rgb(100, 100, 120));
    draw_set_halign(fa_right);
    draw_text(room_width - 50, room_height - 50, 
              "Строка " + string(start_index + 1) + "-" + string(min(end_index + 1, total_rows)) + 
              " из " + string(total_rows));
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
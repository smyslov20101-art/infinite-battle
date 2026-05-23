/// @function draw_sets()
/// @desc Рисует блок наборов в магазине

function draw_sets() {
    // Заголовок раздела
    draw_set_color(c_yellow);
    draw_set_halign(fa_center);
    draw_set_font(fnt_m);
    draw_text(room_width/2, sets_start_y - 70 - scroll_y, "НАБОРЫ");
    
    // Центрируем наборы по горизонтали
    var total_width = sets_per_row * set_width + (sets_per_row - 1) * set_spacing;
    var start_x = (room_width - total_width) / 2;
    
    // Рисуем 2 ряда по 4 набора
    for (var row = 0; row < sets_rows; row++) {
        for (var col = 0; col < sets_per_row; col++) {
            var i = row * sets_per_row + col;
            var set = sets[i];
            var set_x = start_x + col * (set_width + set_spacing);
            var set_y = sets_start_y + row * (set_height + set_spacing) - scroll_y;
            
            // Проверяем видимость
            if (set_y + set_height < visible_area_top || set_y > visible_area_bottom) {
                continue;
            }
            
            if (!set.active) {
                // Заглушка
                draw_set_color(make_color_rgb(50, 50, 70));
                draw_rectangle(set_x, set_y, set_x + set_width, set_y + set_height, false);
                
                draw_set_color(c_white);
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_set_font(fnt_m);
                draw_text(set_x + set_width/2, set_y + set_height/2, set.name);
                continue;
            }
            
            // Рамка по цвету набора
            draw_set_color(set.color);
            draw_rectangle(set_x - 2, set_y - 2, set_x + set_width + 2, set_y + set_height + 2, false);
            
            // Фон
            draw_set_color(make_color_rgb(50, 50, 70));
            draw_rectangle(set_x, set_y, set_x + set_width, set_y + set_height, false);
            
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            
            // Иконка в зависимости от типа награды
            var icon_y = set_y + 45;
            
            switch (set.reward_type) {
                case "genes":
                    draw_set_color(c_yellow);
                    draw_circle(set_x + set_width/2, icon_y, 20, false);
                    draw_set_font(fnt_m);
                    draw_text(set_x + set_width/2, icon_y, "💰");
                    break;
                case "crystals":
                    draw_set_color(make_color_rgb(100, 200, 255));
                    draw_circle(set_x + set_width/2, icon_y, 20, false);
                    draw_set_font(fnt_m);
                    draw_text(set_x + set_width/2, icon_y, "💎");
                    break;
                case "chest":
                    if (sprite_exists(spr_chest)) {
                        draw_sprite_ext(spr_chest, 0, set_x + set_width/2, icon_y, 0.5, 0.5, 0, set.color, 1.0);
                    } else {
                        draw_set_color(set.color);
                        draw_rectangle(set_x + 30, icon_y - 12, set_x + set_width - 30, icon_y + 12, false);
                    }
                    break;
            }
            
            // Название с переносом для длинных текстов
            draw_set_color(c_white);
            draw_set_font(fnt_m);
            
            var display_name = set.name;
            var name_y = set_y + 90;
            
            // Если текст длинный - разбиваем на две строки
            if (string_length(set.name) > 12) {
                // Ищем пробел для переноса
                var space_pos = string_pos(" ", set.name);
                if (space_pos > 0) {
                    var line1 = string_copy(set.name, 1, space_pos - 1);
                    var line2 = string_copy(set.name, space_pos + 1, string_length(set.name));
                    
                    // Сокращаем если все еще длинные
                    if (string_length(line1) > 8) line1 = string_copy(line1, 1, 6) + "..";
                    if (string_length(line2) > 8) line2 = string_copy(line2, 1, 6) + "..";
                    
                    draw_text(set_x + set_width/2, name_y - 10, line1);
                    draw_text(set_x + set_width/2, name_y + 5, line2);
                } else {
                    // Нет пробела - просто сокращаем
                    display_name = string_copy(set.name, 1, 10) + "..";
                    draw_text(set_x + set_width/2, name_y, display_name);
                }
            } else {
                // Короткое название - рисуем как есть
                draw_text(set_x + set_width/2, name_y, display_name);
            }
            
            // Цена в рублях
            draw_set_color(c_lime);
            draw_text(set_x + set_width/2, set_y + 120, string(set.price_rub) + " ₽");
        }
    }
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
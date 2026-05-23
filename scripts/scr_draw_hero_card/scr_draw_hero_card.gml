/// @function draw_hero_card(_hero_index, _base_y, _scroll_y, _visible_top, _visible_bottom, _row, _col)
/// @desc Рисует одну карточку героя в сетке
function draw_hero_card(_hero_index, _base_y, _scroll_y, _visible_top, _visible_bottom, _row, _col) {
    if (_hero_index >= array_length(global.heroes)) return;
    
    var hero = global.heroes[_hero_index];
    
    // Размеры
    var hero_card_width = 120;
    var hero_card_height = 160;
    var hero_card_spacing = 25;
    var cards_per_row = 4;
    
    // Вычисляем центрированную позицию
    var total_cards_width = cards_per_row * hero_card_width + (cards_per_row - 1) * hero_card_spacing;
    var list_start_x = (room_width - total_cards_width) / 2;
    
    // Позиция в сетке
    var card_x = list_start_x + _col * (hero_card_width + hero_card_spacing);
    var card_y = _base_y + _row * (hero_card_height + hero_card_spacing) - _scroll_y;
    
    // ПРОВЕРКА ВИДИМОСТИ
    // Полностью вышла за верхнюю границу
    if (card_y + hero_card_height < _visible_top) {
        return;
    }
    // Полностью вышла за нижнюю границу
    if (card_y > _visible_bottom) {
        return;
    }
    
    // Толстая рамка по редкости
    draw_set_color(hero.color_frame);
    draw_rectangle(card_x - 2, card_y - 2, card_x + hero_card_width + 2, card_y + hero_card_height + 2, false);
    
    // Внутренний фон
    if (hero.unlocked) {
        draw_set_color(make_color_rgb(50, 50, 70));
    } else {
        draw_set_color(make_color_rgb(30, 30, 40));
    }
    draw_rectangle(card_x, card_y, card_x + hero_card_width, card_y + hero_card_height, false);
    
    // Спрайт героя (центрируем)
    var sprite_x = card_x + hero_card_width / 2;
    var sprite_y = card_y + 50;
    
    if (sprite_exists(hero.sprite_small) && hero.sprite_small != -1) {
        // Масштабируем спрайт если нужно
        var spr = hero.sprite_small;
        var spr_width = sprite_get_width(spr);
        var spr_height = sprite_get_height(spr);
        
        if (spr_width > 80 || spr_height > 80) {
            // Сохраняем текущую матрицу трансформации
            var matrix = matrix_get(matrix_world);
            // Масштабируем
            var scale_x = 80 / spr_width;
            var scale_y = 80 / spr_height;
            var scale = min(scale_x, scale_y);
            
            matrix_set(matrix_world, matrix_build(sprite_x, sprite_y, 0, 0, 0, 0, scale, scale, 1));
            draw_sprite(spr, 0, 0, 0);
            // Восстанавливаем матрицу
            matrix_set(matrix_world, matrix);
        } else {
            draw_sprite(spr, 0, sprite_x, sprite_y);
        }
    } else {
        // Заглушка - цветной круг
        if (hero.unlocked) {
            draw_set_color(make_color_rgb(70, 70, 120));
        } else {
            draw_set_color(make_color_rgb(50, 50, 80));
        }
        draw_circle(sprite_x, sprite_y, 35, true);
        
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        if (!hero.unlocked) {
            draw_text(sprite_x, sprite_y, "?");
        } else {
            // Первая буква имени
            if (string_length(hero.name) > 0) {
                var first_char = string_copy(hero.name, 1, 1);
                draw_text(sprite_x, sprite_y, first_char);
            }
        }
    }
    
    // Имя героя (снизу под спрайтом)
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_font(fnt_m);
    
    // Сокращаем длинные имена
    var display_name = hero.name;
    if (string_length(hero.name) > 10) {
        display_name = string_copy(hero.name, 1, 8) + "..";
    }
    draw_text(card_x + hero_card_width/2, card_y + 100, display_name);
    
    // Уровень или статус
    if (hero.unlocked) {
        draw_text(card_x + hero_card_width/2, card_y + 120, "Ур. " + string(hero.level));
        
        // Проверка, находится ли герой в отряде
        for (var s = 0; s < 4; s++) {
            if (global.player_deck[s] == hero.id) {
                draw_set_color(c_green);
                draw_text(card_x + hero_card_width/2, card_y + 140, "В отряде");
                break;
            }
        }
    } else {
        draw_set_color(make_color_rgb(180, 180, 180));
        draw_text(card_x + hero_card_width/2, card_y + 120, "Заблокирован");
    }
    
    // Возвращаем выравнивание
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
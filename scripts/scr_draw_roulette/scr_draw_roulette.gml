/// @function draw_roulette()
/// @desc Рисует рулетку со всеми элементами

function draw_roulette() {
    // Применяем скролл к Y-координатам
    var current_roulette_y = roulette_y - scroll_y;
    var current_pointer_y = pointer_y - scroll_y;
    var current_spin_button_y = spin_button_y - scroll_y;
    var current_ad_button_y = ad_button_y - scroll_y;

    // ===== 2. ПОЛУПРОЗРАЧНЫЙ ПРЯМОУГОЛЬНИК (ФОН РУЛЕТКИ) =====
    draw_set_alpha(0.3);
    draw_set_color(c_aqua);
    draw_rectangle(roulette_x, current_roulette_y, 
                   roulette_x + roulette_width, 
                   current_roulette_y + roulette_height, false);
    draw_set_alpha(0.1);
    draw_rectangle(roulette_x, current_roulette_y, 
                   roulette_x + roulette_width, 
                   current_roulette_y + roulette_height, true);
    draw_set_alpha(1.0);
    
    // ===== 3. РИСУЕМ КАРТЫ =====
    var total_cards = array_length(roulette_cards);
    if (total_cards > 0) {
        var card_width_total = card_width + card_spacing;
        
        // Вычисляем начальную позицию
        var start_x = pointer_x - card_width/2 - (scroll_x % card_width_total);
        
        for (var i = -3; i <= 8; i++) {
            var card_x = start_x + i * card_width_total;
            
            // Проверяем, видна ли карта хоть частично
            if (card_x + card_width < roulette_x - 100 || card_x > roulette_x + roulette_width + 100) {
                continue;
            }
            
            // Вычисляем альфа-канал
            var alpha = 1.0;
            
            // Левая граница
            if (card_x < roulette_x) {
                var visible_width = card_x + card_width - roulette_x;
                alpha = visible_width / card_width;
                alpha = max(0, min(1, alpha));
            }
            
            // Правая граница
            if (card_x + card_width > roulette_x + roulette_width) {
                var visible_width = roulette_x + roulette_width - card_x;
                var right_alpha = visible_width / card_width;
                right_alpha = max(0, min(1, right_alpha));
                alpha = min(alpha, right_alpha);
            }
            
            // Вычисляем индекс карты
            var card_index = floor((scroll_x + i * card_width_total) / card_width_total) % total_cards;
            if (card_index < 0) card_index += total_cards;
            
            // Рисуем карту
            if (alpha > 0.05) {
                draw_card(card_index, card_x, current_roulette_y, alpha);
            }
        }
    }
    
    // ===== 4. РИСУЕМ ТОЛСТУЮ РАМКУ ПОВЕРХ КАРТ =====
    draw_set_color(c_aqua);
    draw_set_alpha(0.8);
    
    // Верхняя и нижняя части рамки
    draw_rectangle(roulette_x - 4, current_roulette_y - 4, 
                   roulette_x + roulette_width + 4, current_roulette_y, false);
    draw_rectangle(roulette_x - 4, current_roulette_y + roulette_height, 
                   roulette_x + roulette_width + 4, current_roulette_y + roulette_height + 4, false);
    
    // Левая и правая части рамки (УВЕЛИЧИЛ ШИРИНУ)
    draw_rectangle(roulette_x - 8, current_roulette_y - 4, 
                   roulette_x, current_roulette_y + roulette_height + 4, false);
    draw_rectangle(roulette_x + roulette_width, current_roulette_y - 4, 
                   roulette_x + roulette_width + 8, current_roulette_y + roulette_height + 4, false);
    
    draw_set_alpha(1.0);
    
    // ===== 5. МАСКИРУЕМ КРАЯ (ТОЛЬКО ЛЕВАЯ И ПРАВАЯ) =====
    draw_set_color(make_color_rgb(30, 30, 40));
    
    // Левая маска (широкая, чтобы скрыть уходящие карты)
    draw_rectangle(roulette_x - 100, current_roulette_y - 20, 
                   roulette_x - 4, current_roulette_y + roulette_height + 20, false);
    
    // Правая маска (широкая, чтобы скрыть уходящие карты)
    draw_rectangle(roulette_x + roulette_width + 4, current_roulette_y - 20, 
                   roulette_x + roulette_width + 100, current_roulette_y + roulette_height + 20, false);
    
    // ===== 6. УКАЗАТЕЛЬ (ПОЛЗУНОК) ПОВЕРХ ВСЕГО =====
    draw_set_color(c_red);
    draw_rectangle(pointer_x - pointer_width/2, current_pointer_y,
                   pointer_x + pointer_width/2, current_pointer_y + pointer_height, false);
    
    // Треугольник сверху
    draw_triangle(pointer_x - 10, current_pointer_y,
                  pointer_x + 10, current_pointer_y,
                  pointer_x, current_pointer_y - 15, false);
    
    
}

/// @function draw_card(_index, _x, _y, _alpha)
/// @desc Рисует карту с заданной прозрачностью
function draw_card(_index, _x, _y, _alpha) {
    var card = roulette_cards[_index];
    var card_y = _y + (roulette_height - card_height) / 2;
    
    var prev_alpha = draw_get_alpha();
    
    // Рамка карты
    draw_set_alpha(_alpha);
    draw_set_color(card.color);
    draw_rectangle(_x - 2, card_y - 2, _x + card_width + 2, card_y + card_height + 2, false);
    
    // Фон карты
    draw_set_color(make_color_rgb(50, 50, 70));
    draw_rectangle(_x, card_y, _x + card_width, card_y + card_height, false);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_set_font(fnt_m);
    
    if (card.type == "hero") {
        if (sprite_exists(card.sprite) && card.sprite != -1) {
            draw_sprite_ext(card.sprite, 0, _x + card_width/2, card_y + card_height/2 - 10, 
                           0.5, 0.5, 0, c_white, _alpha);
            draw_set_font(fnt_level);
            draw_text(_x + card_width/2, card_y + card_height - 20, string_copy(card.name, 1, 6));
        } else {
            draw_text(_x + card_width/2, card_y + card_height/2 - 10, "ГЕРОЙ");
            draw_set_font(fnt_level);
            draw_text(_x + card_width/2, card_y + card_height/2 + 15, string_copy(card.name, 1, 8));
        }
    } else if (card.type == "genes") {
        draw_set_font(fnt_m);
        draw_text(_x + card_width/2, card_y + card_height/2 - 10, "ГЕНЫ");
        draw_text(_x + card_width/2, card_y + card_height/2 + 15, string(card.amount));
        draw_set_color(c_yellow);
        draw_circle(_x + card_width/2, card_y + card_height/2 - 25, 8, false);
    } else if (card.type == "crystals") {
        draw_set_font(fnt_m);
        draw_text(_x + card_width/2, card_y + card_height/2 - 10, "КРИСТ.");
        draw_text(_x + card_width/2, card_y + card_height/2 + 15, string(card.amount));
        draw_set_color(make_color_rgb(100, 200, 255));
        draw_circle(_x + card_width/2, card_y + card_height/2 - 25, 8, false);
    }
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(prev_alpha);
}
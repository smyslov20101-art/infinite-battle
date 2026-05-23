/// @function draw_chest_detail()
/// @desc Рисует карточку открытого сундука с наградой

function draw_chest_detail() {
    if (chest_state != CHEST_STATE_SHOWING || current_chest == noone) return;
    
    // Затемняем фон
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, room_width, room_height, true);
    draw_set_alpha(1.0);
    
    var chest = current_chest;
    
    // Рамка по редкости
    draw_set_color(chest.color);
    draw_rectangle(chest_window_x, chest_window_y,
                   chest_window_x + chest_window_width,
                   chest_window_y + chest_window_height, false);
    
    // Фон карточки
    draw_set_color(make_color_rgb(50, 50, 70));
    draw_rectangle(chest_window_x + 2, chest_window_y + 2,
                   chest_window_x + chest_window_width - 2,
                   chest_window_y + chest_window_height - 2, false);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Спрайт сундука
    var sprite_x = chest_window_x + chest_window_width/2;
    var sprite_y = chest_window_y + 100;
    
    if (sprite_exists(spr_chest)) {
        draw_sprite_ext(spr_chest, 0, sprite_x, sprite_y,
                       1.2, 1.2, 0, chest.color, 1.0);
    } else {
        draw_set_color(chest.color);
        draw_rectangle(sprite_x - 40, sprite_y - 30,
                      sprite_x + 40, sprite_y + 30, false);
    }
    
    // Текст редкости
    draw_set_color(chest.color);
    draw_set_font(fnt_m);
    draw_text(sprite_x, chest_window_y + 200, chest.rarity_text + " СУНДУК");
    
    // Заголовок "НАГРАДА:"
    draw_set_color(c_yellow);
    draw_text(sprite_x, chest_window_y + 250, "НАГРАДА:");
    
    // Список наград
    draw_set_color(c_white);
    draw_set_font(fnt_m);
    var y_offset = chest_window_y + 280;
    
    for (var i = 0; i < array_length(chest.rewards); i++) {
        var reward = chest.rewards[i];
        var rarity_text = "";
        
        switch (reward.rarity) {
            case 0: rarity_text = "Обычных"; draw_set_color(make_color_rgb(180, 180, 180)); break;
            case 1: rarity_text = "Редких"; draw_set_color(make_color_rgb(100, 100, 255)); break;
            case 2: rarity_text = "Эпических"; draw_set_color(make_color_rgb(180, 80, 255)); break;
            case 3: rarity_text = "Легендарных"; draw_set_color(make_color_rgb(255, 180, 50)); break;
        }
        
        draw_text(sprite_x, y_offset, string(reward.count) + " " + rarity_text + " карт");
        y_offset += 25;
    }
    
    // Цена
    draw_set_color(c_yellow);
    draw_text(sprite_x, y_offset + 10, "ЦЕНА: " + string(chest.price_genes) + " генов");
    if (chest.price_crystals > 0) {
        draw_set_color(make_color_rgb(100, 200, 255));
        draw_text(sprite_x, y_offset + 35, string(chest.price_crystals) + " кристаллов");
    }
    
    // КНОПКА "КУПИТЬ"
    var btn_color = make_color_rgb(80, 150, 255);
    
    // Проверяем наведение
    var mouse_over = (mouse_x >= chest_button_x && mouse_x <= chest_button_x + chest_button_width &&
                      mouse_y >= chest_button_y && mouse_y <= chest_button_y + chest_button_height);
    
    if (mouse_over) {
        btn_color = make_color_rgb(120, 180, 255);
    }
    
    draw_set_color(btn_color);
    draw_rectangle(chest_button_x, chest_button_y,
                   chest_button_x + chest_button_width,
                   chest_button_y + chest_button_height, false);
    
    draw_set_color(c_white);
    draw_rectangle(chest_button_x, chest_button_y,
                   chest_button_x + chest_button_width,
                   chest_button_y + chest_button_height, true);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_m);
    draw_text(chest_button_x + chest_button_width/2,
              chest_button_y + chest_button_height/2, "КУПИТЬ");
    
    // Возвращаем настройки
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
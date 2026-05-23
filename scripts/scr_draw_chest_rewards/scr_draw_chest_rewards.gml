/// @function draw_chest_rewards()
/// @desc Рисует окно с полученными наградами из сундука в виде сетки

function draw_chest_rewards() {
    if (chest_state != CHEST_STATE_REWARDS || array_length(chest_rewards) == 0) return;
    
    // Затемняем фон
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, room_width, room_height, true);
    draw_set_alpha(1.0);
    
    // Определяем цвет для рамки (берем из первого героя или используем желтый)
    var frame_color = c_yellow;
    if (array_length(chest_rewards) > 0) {
        var first_hero = global.heroes[chest_rewards[0].hero_id];
        frame_color = first_hero.color_frame;
    }
    
    // Рамка окна
    draw_set_color(frame_color);
    draw_rectangle(rewards_window_x, rewards_window_y,
                   rewards_window_x + rewards_window_width,
                   rewards_window_y + rewards_window_height, false);
    
    // Фон окна
    draw_set_color(make_color_rgb(50, 50, 70));
    draw_rectangle(rewards_window_x + 2, rewards_window_y + 2,
                   rewards_window_x + rewards_window_width - 2,
                   rewards_window_y + rewards_window_height - 2, false);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Заголовок
    draw_set_color(c_white);
    draw_set_font(fnt_m);
    draw_text(rewards_window_x + rewards_window_width/2, rewards_window_y + 40, "ВЫ ПОЛУЧИЛИ:");
    
    // Параметры сетки
    var card_size = 70; // Размер карточки
    var card_spacing = 20;
    var cards_per_row = 4;
    
    // Вычисляем начальную позицию для центрирования сетки
    var grid_width = cards_per_row * card_size + (cards_per_row - 1) * card_spacing;
    var start_x = rewards_window_x + (rewards_window_width - grid_width) / 2 + card_size/2;
    var start_y = rewards_window_y + 120;
    
    // Рисуем награды в виде сетки
    for (var i = 0; i < array_length(chest_rewards); i++) {
        var reward = chest_rewards[i];
        var hero = global.heroes[reward.hero_id];
        
        // Вычисляем позицию в сетке
        var row = floor(i / cards_per_row);
        var col = i % cards_per_row;
        
        var card_x = start_x + col * (card_size + card_spacing);
        var card_y = start_y + row * (card_size + card_spacing + 20); // +20 для текста с количеством
        
        // Рамка карточки
        draw_set_color(hero.color_frame);
        draw_rectangle(card_x - card_size/2 - 2, card_y - card_size/2 - 2,
                       card_x + card_size/2 + 2, card_y + card_size/2 + 2, false);
        
        // Фон карточки
        draw_set_color(make_color_rgb(40, 40, 50));
        draw_rectangle(card_x - card_size/2, card_y - card_size/2,
                       card_x + card_size/2, card_y + card_size/2, false);
        
        // Спрайт героя
        if (sprite_exists(hero.sprite_small) && hero.sprite_small != -1) {
            draw_sprite_ext(hero.sprite_small, 0, card_x, card_y, 0.8, 0.8, 0, c_white, 1.0);
        } else {
            // Заглушка если нет спрайта
            draw_set_color(hero.color_frame);
            draw_circle(card_x, card_y, 25, true);
        }
        
        // Количество под карточкой
        draw_set_color(c_white);
        draw_set_font(fnt_m);
        draw_text(card_x, card_y + card_size/2 + 15, "x" + string(reward.count));
    }
    
    // КНОПКА "ПОЛУЧИТЬ"
    var btn_color = make_color_rgb(80, 150, 255);
    
    // Проверяем наведение
    var mouse_over = (mouse_x >= rewards_button_x && mouse_x <= rewards_button_x + rewards_button_width &&
                      mouse_y >= rewards_button_y && mouse_y <= rewards_button_y + rewards_button_height);
    
    if (mouse_over) {
        btn_color = make_color_rgb(120, 180, 255);
    }
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    draw_set_color(btn_color);
    draw_rectangle(rewards_button_x, rewards_button_y,
                   rewards_button_x + rewards_button_width,
                   rewards_button_y + rewards_button_height, false);
    
    draw_set_color(c_white);
    draw_rectangle(rewards_button_x, rewards_button_y,
                   rewards_button_x + rewards_button_width,
                   rewards_button_y + rewards_button_height, true);
    
    draw_set_font(fnt_m);
    draw_text(rewards_button_x + rewards_button_width/2,
              rewards_button_y + rewards_button_height/2, "ПОЛУЧИТЬ");
    
    // Возвращаем настройки
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
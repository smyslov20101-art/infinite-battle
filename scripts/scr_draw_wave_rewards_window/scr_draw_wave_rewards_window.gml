/// @function draw_wave_rewards_window()
/// @desc Рисует окно с наградами из волны

function draw_wave_rewards_window() {
    var rewards = current_wave_rewards;
    
    // Затемняем фон
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, room_width, room_height, true);
    draw_set_alpha(1.0);
    
    // Рамка окна
    draw_set_color(c_yellow);
    draw_rectangle(window_x, window_y,
                   window_x + window_width,
                   window_y + window_height, false);
    
    // Фон окна
    draw_set_color(make_color_rgb(50, 50, 70));
    draw_rectangle(window_x + 2, window_y + 2,
                   window_x + window_width - 2,
                   window_y + window_height - 2, false);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Заголовок
    draw_set_color(c_yellow);
    draw_set_font(fnt_m);
    draw_text(window_x + window_width/2, window_y + 40, "НАГРАДЫ ИЗ ВОЛНЫ");
    
    // Сетка наград
    var grid_start_x = window_x + 50;
    var grid_start_y = window_y + 100;
    var cell_size = 80;
    var cell_spacing = 20;
    var cells_per_row = 4;
    
    // Собираем все награды для отображения
    var rewards_display = [];
    
    if (rewards.genes > 0) {
        array_push(rewards_display, {
            type: "genes",
            amount: rewards.genes,
            color: c_yellow
        });
    }
    
    if (rewards.crystals > 0) {
        array_push(rewards_display, {
            type: "crystals",
            amount: rewards.crystals,
            color: make_color_rgb(100, 200, 255)
        });
    }
    
    for (var i = 0; i < array_length(rewards.chests); i++) {
        var chest = rewards.chests[i];
        var chest_color = c_white;
        
        switch (chest.rarity) {
            case 0: chest_color = make_color_rgb(180, 180, 180); break; // Обычный
            case 1: chest_color = make_color_rgb(100, 100, 255); break; // Редкий
            case 2: chest_color = make_color_rgb(180, 80, 255); break;  // Эпический
            case 3: chest_color = make_color_rgb(255, 180, 50); break;  // Легендарный
        }
        
        array_push(rewards_display, {
            type: "chest",
            rarity: chest.rarity,
            count: chest.count,
            color: chest_color
        });
    }
    
    // Если нет наград, показываем сообщение
    if (array_length(rewards_display) == 0) {
        draw_set_color(c_white);
        draw_set_font(fnt_m);
        draw_text(window_x + window_width/2, window_y + 250, "Нет доступных наград");
    }
    
    // Рисуем сетку
    for (var i = 0; i < array_length(rewards_display); i++) {
        var reward = rewards_display[i];
        var row = floor(i / cells_per_row);
        var col = i % cells_per_row;
        
        var cell_x = grid_start_x + col * (cell_size + cell_spacing);
        var cell_y = grid_start_y + row * (cell_size + cell_spacing + 20);
        
        // Проверяем видимость
        if (cell_y + cell_size < window_y || cell_y > window_y + window_height) {
            continue;
        }
        
        // Рамка
        draw_set_color(reward.color);
        draw_rectangle(cell_x - 2, cell_y - 2, 
                       cell_x + cell_size + 2, 
                       cell_y + cell_size + 2, false);
        
        // Фон
        draw_set_color(make_color_rgb(50, 50, 70));
        draw_rectangle(cell_x, cell_y, 
                       cell_x + cell_size, 
                       cell_y + cell_size, false);
        
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        if (reward.type == "genes") {
            // Рисуем иконку генов
            draw_set_color(c_yellow);
            draw_circle(cell_x + cell_size/2, cell_y + cell_size/2 - 10, 20, false);
            draw_set_font(fnt_m);
            draw_text(cell_x + cell_size/2, cell_y + cell_size/2, "💰");
            draw_text(cell_x + cell_size/2, cell_y + cell_size - 15, "x" + string(reward.amount));
        } 
        else if (reward.type == "crystals") {
            // Рисуем иконку кристаллов
            draw_set_color(make_color_rgb(100, 200, 255));
            draw_circle(cell_x + cell_size/2, cell_y + cell_size/2 - 10, 20, false);
            draw_set_font(fnt_m);
            draw_text(cell_x + cell_size/2, cell_y + cell_size/2, "💎");
            draw_text(cell_x + cell_size/2, cell_y + cell_size - 15, "x" + string(reward.amount));
        }
        else if (reward.type == "chest") {
            // Рисуем сундук
            if (sprite_exists(spr_chest)) {
                draw_sprite_ext(spr_chest, 0, 
                               cell_x + cell_size/2, 
                               cell_y + cell_size/2 - 10,
                               0.6, 0.6, 0, reward.color, 1.0);
            } else {
                // Заглушка, если нет спрайта
                draw_set_color(reward.color);
                draw_rectangle(cell_x + 20, cell_y + 20, 
                              cell_x + cell_size - 20, 
                              cell_y + cell_size - 20, false);
            }
            
            // ОТОБРАЖАЕМ КОЛИЧЕСТВО СУНДУКОВ
            draw_set_font(fnt_m);
            draw_set_color(c_white);
            draw_text(cell_x + cell_size/2, cell_y + cell_size - 15, "x" + string(reward.count));
        }
    }
    
    // Кнопка "ПОЛУЧИТЬ ВСЁ"
    var btn_color = make_color_rgb(80, 150, 255);
    
    var mouse_over = (mouse_x >= button_x && mouse_x <= button_x + button_width &&
                      mouse_y >= button_y && mouse_y <= button_y + button_height);
    
    if (mouse_over) {
        btn_color = make_color_rgb(120, 180, 255);
    }
    
    draw_set_color(btn_color);
    draw_rectangle(button_x, button_y,
                   button_x + button_width,
                   button_y + button_height, false);
    
    draw_set_color(c_white);
    draw_rectangle(button_x, button_y,
                   button_x + button_width,
                   button_y + button_height, true);
    
    draw_set_font(fnt_m);
    draw_text(button_x + button_width/2,
              button_y + button_height/2, "ПОЛУЧИТЬ ВСЁ");
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
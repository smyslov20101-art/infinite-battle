/// @function draw_gameover_state()
/// @desc Отрисовка окна окончания игры с наградами

function draw_gameover_state() {
    // Затемняем весь экран
    draw_set_color(c_black);
    draw_set_alpha(0.5);
    draw_rectangle(0, 0, room_width, room_height, true);
    draw_set_alpha(1.0);
    
    // ===== ОКНО GAME OVER =====
    var window_width = 500;
    var window_height = 550;
    var window_x = (room_width - window_width) / 2;
    var window_y = (room_height - window_height) / 2;
    
    // Рамка окна (красная для Game Over)
    draw_set_color(c_red);
    draw_rectangle(window_x - 2, window_y - 2, 
                   window_x + window_width + 2, 
                   window_y + window_height + 2, false);
    
    // Фон окна
    draw_set_color(make_color_rgb(40, 40, 50));
    draw_rectangle(window_x, window_y, 
                   window_x + window_width, 
                   window_y + window_height, false);
    
    draw_set_font(fnt_m);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Заголовок
    draw_set_color(c_red);
    draw_text(window_x + window_width/2, window_y + 30, "ИГРА ОКОНЧЕНА");
    
    // Разделительная линия
    draw_set_color(make_color_rgb(80, 80, 100));
    draw_line(window_x + 30, window_y + 60, 
              window_x + window_width - 30, window_y + 60);
    
    // Заголовок "НАГРАДЫ"
    draw_set_color(c_yellow);
    draw_text(window_x + window_width/2, window_y + 90, "НАГРАДЫ");
    
    // ===== СЕТКА НАГРАД =====
    var grid_start_x = window_x + 50;
    var grid_start_y = window_y + 130;
    var cell_size = 80;
    var cell_spacing = 20;
    var cells_per_row = 4;
    
    // Собираем все награды в один массив для отображения
    var rewards_display = [];
    
    // Гены
    if (wave_genes > 0) {
        array_push(rewards_display, {
            type: "genes",
            amount: wave_genes,
            color: c_yellow
        });
    }
    
    // Кристаллы
    if (wave_crystals > 0) {
        array_push(rewards_display, {
            type: "crystals",
            amount: wave_crystals,
            color: make_color_rgb(100, 200, 255)
        });
    }
    
    // Сундуки
    for (var i = 0; i < array_length(wave_chests); i++) {
        var chest = wave_chests[i];
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
    
    // Рисуем сетку
    for (var i = 0; i < array_length(rewards_display); i++) {
        var reward = rewards_display[i];
        var row = floor(i / cells_per_row);
        var col = i % cells_per_row;
        
        var cell_x = grid_start_x + col * (cell_size + cell_spacing);
        var cell_y = grid_start_y + row * (cell_size + cell_spacing + 20);
        
        // Проверяем видимость (для оптимизации)
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
            
            // ===== ИСПРАВЛЕНО: ОТОБРАЖАЕМ КОЛИЧЕСТВО СУНДУКОВ =====
            draw_set_font(fnt_m);
            draw_set_color(c_white);
            draw_text(cell_x + cell_size/2, cell_y + cell_size - 15, "x" + string(reward.count));
        }
    }
    
    // ===== КНОПКА "ПОЛУЧИТЬ" =====
    var btn_width = 180;
    var btn_height = 50;
    var btn_x = window_x + (window_width - btn_width) / 2;
    var btn_y = window_y + window_height - 80;
    
    // Проверяем наведение мыши
    var mouse_over = (mouse_x >= btn_x && mouse_x <= btn_x + btn_width &&
                      mouse_y >= btn_y && mouse_y <= btn_y + btn_height);
    
    // Рисуем кнопку
    if (mouse_over) {
        draw_set_color(make_color_rgb(70, 170, 70)); // Светлее при наведении
    } else {
        draw_set_color(make_color_rgb(50, 130, 50)); // Темно-зеленый
    }
    draw_rectangle(btn_x, btn_y, btn_x + btn_width, btn_y + btn_height, false);
    
    // Обводка кнопки
    draw_set_color(c_white);
    draw_rectangle(btn_x, btn_y, btn_x + btn_width, btn_y + btn_height, true);
    
    // Текст кнопки
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(btn_x + btn_width/2, btn_y + btn_height/2, "ПОЛУЧИТЬ");
    
    // Возвращаем выравнивание
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
/// Draw Event - obj_rewards_button

// ===== ОБНОВЛЯЕМ КООРДИНАТЫ ОКНА (каждый кадр!) =====
window_x = (room_width - 500) / 2;
window_y = (room_height - 550) / 2;
window_width = 500;
window_height = 550;

button_x = window_x + (window_width - 180) / 2;
button_y = window_y + 480;
button_width = 180;
button_height = 40;


// ===== РИСУЕМ САМУ КНОПКУ =====
draw_self();

// ===== РИСУЕМ ОКНА =====
if (rewards_state == REWARDS_STATE_SHOWING) {
    draw_rewards_list();
}
else if (rewards_state == REWARDS_STATE_CHEST_DETAIL) {
    draw_text(10, 180, "РИСУЕМ ОКНО CHEST_DETAIL");
    draw_chest_detail_window();
}
else if (rewards_state == REWARDS_STATE_CHEST_OPEN && array_length(current_chest_rewards) > 0) {
    draw_text(10, 180, "РИСУЕМ ОКНО CHEST_OPEN");
    draw_chest_rewards_window();
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);

// =============================================================================
// ФУНКЦИИ ОТРИСОВКИ ОКОН
// =============================================================================

/// @function draw_rewards_list()
/// @desc Рисует окно со списком сундуков
function draw_rewards_list() {
    LOG("draw_rewards_list() ВЫЗВАНА");
    
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
    draw_set_color(c_yellow);
    draw_set_font(fnt_m);
    draw_text(window_x + window_width/2, window_y + 40, "НАГРАДЫ");
    
    // Сетка наград
    var grid_start_x = window_x + 50;
    var grid_start_y = window_y + 100;
    var cell_size = 80;
    var cell_spacing = 20;
    var cells_per_row = 4;
    
    var rewards_display = [];
    
    // Гены
    if (global.wave_rewards.genes > 0) {
        array_push(rewards_display, {
            type: "genes",
            amount: global.wave_rewards.genes,
            color: c_yellow
        });
    }
    
    // Кристаллы
    if (global.wave_rewards.crystals > 0) {
        array_push(rewards_display, {
            type: "crystals",
            amount: global.wave_rewards.crystals,
            color: make_color_rgb(100, 200, 255)
        });
    }
    
    // Сундуки
    for (var i = 0; i < array_length(global.wave_rewards.chests); i++) {
        var chest = global.wave_rewards.chests[i];
        var chest_color = c_white;
        
        switch (chest.rarity) {
            case 0: chest_color = make_color_rgb(180, 180, 180); break;
            case 1: chest_color = make_color_rgb(100, 100, 255); break;
            case 2: chest_color = make_color_rgb(180, 80, 255); break;
            case 3: chest_color = make_color_rgb(255, 180, 50); break;
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
        
        // Рамка
        draw_set_color(reward.color);
        draw_rectangle(cell_x - 2, cell_y - 2, cell_x + cell_size + 2, cell_y + cell_size + 2, false);
        
        // Фон
        draw_set_color(make_color_rgb(50, 50, 70));
        draw_rectangle(cell_x, cell_y, cell_x + cell_size, cell_y + cell_size, false);
        
        if (reward.type == "genes") {
            draw_set_color(c_yellow);
            draw_circle(cell_x + cell_size/2, cell_y + cell_size/2 - 10, 20, false);
            draw_set_font(fnt_m);
            draw_text(cell_x + cell_size/2, cell_y + cell_size/2, "💰");
            draw_text(cell_x + cell_size/2, cell_y + cell_size - 15, "x" + string(reward.amount));
        } 
        else if (reward.type == "crystals") {
            draw_set_color(make_color_rgb(100, 200, 255));
            draw_circle(cell_x + cell_size/2, cell_y + cell_size/2 - 10, 20, false);
            draw_set_font(fnt_m);
            draw_text(cell_x + cell_size/2, cell_y + cell_size/2, "💎");
            draw_text(cell_x + cell_size/2, cell_y + cell_size - 15, "x" + string(reward.amount));
        }
        else if (reward.type == "chest") {
            if (sprite_exists(spr_chest)) {
                draw_sprite_ext(spr_chest, 0, cell_x + cell_size/2, cell_y + cell_size/2 - 10,
                               0.6, 0.6, 0, reward.color, 1.0);
            }
            draw_set_font(fnt_m);
            draw_set_color(c_white);
            draw_text(cell_x + cell_size/2, cell_y + cell_size - 15, "x" + string(reward.count));
        }
    }
    
    // Кнопка "ОТКРЫТЬ ВСЕ"
    draw_set_color(make_color_rgb(80, 150, 255));
    draw_rectangle(button_x, button_y, button_x + button_width, button_y + button_height, false);
    draw_set_color(c_white);
    draw_rectangle(button_x, button_y, button_x + button_width, button_y + button_height, true);
    draw_set_font(fnt_m);
    draw_text(button_x + button_width/2, button_y + button_height/2, "ОТКРЫТЬ ВСЕ");
}

/// @function draw_chest_detail_window()
/// @desc Рисует детальное окно сундука
function draw_chest_detail_window() {
    if (current_chest == noone) return;
    
    LOG("draw_chest_detail_window() ВЫЗВАНА");
    
    // Затемняем фон
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, room_width, room_height, true);
    draw_set_alpha(1.0);
    
    // Определяем цвет в зависимости от редкости
    var chest_color = c_white;
    var rarity_text = "";
    
    switch (current_chest.rarity) {
        case 0: 
            chest_color = make_color_rgb(180, 180, 180); 
            rarity_text = "ОБЫЧНЫЙ СУНДУК";
            break;
        case 1: 
            chest_color = make_color_rgb(100, 100, 255); 
            rarity_text = "РЕДКИЙ СУНДУК";
            break;
        case 2: 
            chest_color = make_color_rgb(180, 80, 255); 
            rarity_text = "ЭПИЧЕСКИЙ СУНДУК";
            break;
        case 3: 
            chest_color = make_color_rgb(255, 180, 50); 
            rarity_text = "ЛЕГЕНДАРНЫЙ СУНДУК";
            break;
    }
    
    // Рамка окна
    draw_set_color(chest_color);
    draw_rectangle(window_x, window_y, window_x + window_width, window_y + window_height, false);
    
    // Фон окна
    draw_set_color(make_color_rgb(50, 50, 70));
    draw_rectangle(window_x + 2, window_y + 2, window_x + window_width - 2, window_y + window_height - 2, false);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Заголовок
    draw_set_color(chest_color);
    draw_set_font(fnt_m);
    draw_text(window_x + window_width/2, window_y + 40, rarity_text);
    
    // Спрайт сундука
    var chest_x = window_x + window_width/2;
    var chest_y = window_y + 150;
    
    if (sprite_exists(spr_chest)) {
        draw_sprite_ext(spr_chest, 0, chest_x, chest_y, 1.0, 1.0, 0, chest_color, 1.0);
    } else {
        draw_set_color(chest_color);
        draw_rectangle(chest_x - 40, chest_y - 30, chest_x + 40, chest_y + 30, false);
    }
    
    // Описание содержимого
    draw_set_color(c_white);
    draw_set_font(fnt_m);
    draw_text(chest_x, window_y + 250, "СОДЕРЖИТ:");
    
    var y_offset = window_y + 280;
    
    if (current_chest.rarity == 0) {
        draw_text(chest_x, y_offset, "5 случайных");
        draw_text(chest_x, y_offset + 25, "обычных героев");
    } else if (current_chest.rarity == 1) {
        draw_text(chest_x, y_offset, "4 редких +");
        draw_text(chest_x, y_offset + 25, "3 обычных героя");
    } else if (current_chest.rarity == 2) {
        draw_text(chest_x, y_offset, "3 эпических +");
        draw_text(chest_x, y_offset + 25, "2 редких + 3 обычных");
    } else if (current_chest.rarity == 3) {
        draw_text(chest_x, y_offset, "1 легендарный +");
        draw_text(chest_x, y_offset + 25, "5 редких + 10 обычных");
    }
    
    // Количество
    draw_set_color(c_yellow);
    draw_text(chest_x, window_y + 350, "КОЛИЧЕСТВО: " + string(current_chest.count));
    
    // КНОПКА "ОТКРЫТЬ"
    var btn_color = make_color_rgb(80, 150, 255);
    
    // Проверяем наведение
    var mouse_over = (mouse_x >= button_x && mouse_x <= button_x + button_width &&
                      mouse_y >= button_y && mouse_y <= button_y + button_height);
    
    if (mouse_over) {
        btn_color = make_color_rgb(120, 180, 255);
    }
    
    draw_set_color(btn_color);
    draw_rectangle(button_x, button_y, button_x + button_width, button_y + button_height, false);
    
    draw_set_color(c_white);
    draw_rectangle(button_x, button_y, button_x + button_width, button_y + button_height, true);
    
    draw_set_font(fnt_m);
    draw_text(button_x + button_width/2, button_y + button_height/2, "ОТКРЫТЬ");
}

/// @function draw_chest_rewards_window()
/// @desc Рисует окно с полученными наградами
function draw_chest_rewards_window() {
    if (array_length(current_chest_rewards) == 0) return;
    
    LOG("draw_chest_rewards_window() ВЫЗВАНА");
    
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
    draw_set_color(c_yellow);
    draw_set_font(fnt_m);
    draw_text(window_x + window_width/2, window_y + 40, "ВЫ ПОЛУЧИЛИ:");
    
    // Сетка наград из сундука
    var grid_start_x = window_x + 50;
    var grid_start_y = window_y + 100;
    var cell_size = 80;
    var cell_spacing = 20;
    var cells_per_row = 4;
    
    // Рисуем сетку
    for (var i = 0; i < array_length(current_chest_rewards); i++) {
        var reward = current_chest_rewards[i];
        var hero = global.heroes[reward.hero_id];
        var row = floor(i / cells_per_row);
        var col = i % cells_per_row;
        
        var cell_x = grid_start_x + col * (cell_size + cell_spacing);
        var cell_y = grid_start_y + row * (cell_size + cell_spacing + 20);
        
        // Рамка
        draw_set_color(hero.color_frame);
        draw_rectangle(cell_x - 2, cell_y - 2, cell_x + cell_size + 2, cell_y + cell_size + 2, false);
        
        // Фон
        draw_set_color(make_color_rgb(50, 50, 70));
        draw_rectangle(cell_x, cell_y, cell_x + cell_size, cell_y + cell_size, false);
        
        // Спрайт героя
        if (sprite_exists(hero.sprite_small) && hero.sprite_small != -1) {
            draw_sprite_ext(hero.sprite_small, 0, cell_x + cell_size/2, cell_y + cell_size/2 - 10,
                           0.6, 0.6, 0, c_white, 1.0);
        }
        
        // Количество
        draw_set_font(fnt_m);
        draw_set_color(c_white);
        draw_text(cell_x + cell_size/2, cell_y + cell_size - 15, "x" + string(reward.count));
    }
    
    // Кнопка "ПОЛУЧИТЬ"
    draw_set_color(make_color_rgb(80, 150, 255));
    draw_rectangle(button_x, button_y, button_x + button_width, button_y + button_height, false);
    draw_set_color(c_white);
    draw_rectangle(button_x, button_y, button_x + button_width, button_y + button_height, true);
    draw_set_font(fnt_m);
    draw_text(button_x + button_width/2, button_y + button_height/2, "ПОЛУЧИТЬ");
}
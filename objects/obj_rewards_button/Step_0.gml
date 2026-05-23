/// Step Event - obj_rewards_button

// ОТЛАДКА: выводим состояние в консоль каждые 60 кадров
if (frame_counter == undefined) frame_counter = 0;
frame_counter++;
if (frame_counter >= 60) {
    LOG("Step: rewards_state = " + string(rewards_state));
    frame_counter = 0;
}

// ===== ЕСЛИ ОКНО ОТКРЫТО - ОБРАБАТЫВАЕМ КЛИКИ В ОКНЕ =====
if (rewards_state != REWARDS_STATE_NONE) {
    
    if (mouse_check_button_pressed(mb_left)) {
        LOG("КЛИК В ОКНЕ! rewards_state = " + string(rewards_state));
        
        // Состояние: список сундуков
        if (rewards_state == REWARDS_STATE_SHOWING) {
            LOG("Обработка SHOWING");
            
            // Проверяем клик по кнопке "ОТКРЫТЬ ВСЕ"
            if (mouse_x >= button_x && mouse_x <= button_x + button_width &&
                mouse_y >= button_y && mouse_y <= button_y + button_height) {
                
                LOG("Клик по кнопке ОТКРЫТЬ ВСЕ");
                
                // Начисляем гены сразу
                if (global.wave_rewards.genes > 0) {
                    global.genes += global.wave_rewards.genes;
                    global.wave_rewards.genes = 0;
                }
                
                // Начисляем кристаллы сразу
                if (global.wave_rewards.crystals > 0) {
                    global.crystals += global.wave_rewards.crystals;
                    global.wave_rewards.crystals = 0;
                }
                
                // Собираем все награды из всех сундуков
                var all_rewards = [];
                
                for (var i = 0; i < array_length(global.wave_rewards.chests); i++) {
                    var chest = global.wave_rewards.chests[i];
                    
                    for (var c = 0; c < chest.count; c++) {
                        var hero_ids = [];
                        
                        switch (chest.rarity) {
                            case 0: hero_ids = get_random_heroes_by_rarity(0, 5); break;
                            case 1: 
                                var rare_ids = get_random_heroes_by_rarity(1, 4);
                                var common_ids = get_random_heroes_by_rarity(0, 3);
                                hero_ids = array_concat(rare_ids, common_ids);
                                break;
                            case 2:
                                var epic_ids = get_random_heroes_by_rarity(2, 3);
                                var rare_ids = get_random_heroes_by_rarity(1, 2);
                                var common_ids = get_random_heroes_by_rarity(0, 3);
                                hero_ids = array_concat(epic_ids, array_concat(rare_ids, common_ids));
                                break;
                            case 3:
                                var leg_ids = get_random_heroes_by_rarity(3, 1);
                                var rare_ids = get_random_heroes_by_rarity(1, 5);
                                var common_ids = get_random_heroes_by_rarity(0, 10);
                                hero_ids = array_concat(leg_ids, array_concat(rare_ids, common_ids));
                                break;
                        }
                        
                        for (var h = 0; h < array_length(hero_ids); h++) {
                            var found = false;
                            for (var r = 0; r < array_length(all_rewards); r++) {
                                if (all_rewards[r].hero_id == hero_ids[h]) {
                                    all_rewards[r].count++;
                                    found = true;
                                    break;
                                }
                            }
                            if (!found) {
                                array_push(all_rewards, {hero_id: hero_ids[h], count: 1});
                            }
                        }
                    }
                }
                
                // Очищаем сундуки
                global.wave_rewards.chests = [];
                
                // СОХРАНЯЕМ ИЗМЕНЕНИЯ
                save_wave_rewards();
                
                // Показываем окно с наградами
                if (array_length(all_rewards) > 0) {
                    current_chest_rewards = all_rewards;
                    rewards_state = REWARDS_STATE_CHEST_OPEN;
                    rewards_just_opened = true;
                } else {
                    rewards_state = REWARDS_STATE_NONE;
                }
                
                save_permanent_to_file();
            }
            
            // Проверяем клики по отдельным сундукам
            var grid_start_x = window_x + 50;
            var grid_start_y = window_y + 100;
            var cell_size = 80;
            var cell_spacing = 20;
            var cells_per_row = 4;
            
            for (var i = 0; i < array_length(global.wave_rewards.chests); i++) {
                var row = floor(i / cells_per_row);
                var col = i % cells_per_row;
                
                var cell_x = grid_start_x + col * (cell_size + cell_spacing);
                var cell_y = grid_start_y + row * (cell_size + cell_spacing + 20);
                
                if (mouse_x >= cell_x && mouse_x <= cell_x + cell_size &&
                    mouse_y >= cell_y && mouse_y <= cell_y + cell_size) {
                    
                    LOG("Клик по сундуку " + string(i));
                    current_chest = {
                        rarity: global.wave_rewards.chests[i].rarity,
                        index: i,
                        count: global.wave_rewards.chests[i].count
                    };
                    rewards_state = REWARDS_STATE_CHEST_DETAIL;
                    chest_just_opened = true;
                    break;
                }
            }
            
            // Клик вне окна — закрываем
            if (mouse_x < window_x || mouse_x > window_x + window_width ||
                mouse_y < window_y || mouse_y > window_y + window_height) {
                LOG("Клик вне окна — закрываем");
                rewards_state = REWARDS_STATE_NONE;
            }
        }
        
        // Состояние: детальное окно сундука
        else if (rewards_state == REWARDS_STATE_CHEST_DETAIL) {
            LOG("Обработка CHEST_DETAIL");
            
            if (mouse_x >= button_x && mouse_x <= button_x + button_width &&
                mouse_y >= button_y && mouse_y <= button_y + button_height) {
                LOG("Клик по кнопке ОТКРЫТЬ");
                
                global.wave_rewards.chests[current_chest.index].count--;
                if (global.wave_rewards.chests[current_chest.index].count <= 0) {
                    array_delete(global.wave_rewards.chests, current_chest.index, 1);
                }
                
                save_wave_rewards();
                
                var hero_ids = [];
                
                switch (current_chest.rarity) {
                    case 0: hero_ids = get_random_heroes_by_rarity(0, 5); break;
                    case 1: 
                        var rare_ids = get_random_heroes_by_rarity(1, 4);
                        var common_ids = get_random_heroes_by_rarity(0, 3);
                        hero_ids = array_concat(rare_ids, common_ids);
                        break;
                    case 2:
                        var epic_ids = get_random_heroes_by_rarity(2, 3);
                        var rare_ids = get_random_heroes_by_rarity(1, 2);
                        var common_ids = get_random_heroes_by_rarity(0, 3);
                        hero_ids = array_concat(epic_ids, array_concat(rare_ids, common_ids));
                        break;
                    case 3:
                        var leg_ids = get_random_heroes_by_rarity(3, 1);
                        var rare_ids = get_random_heroes_by_rarity(1, 5);
                        var common_ids = get_random_heroes_by_rarity(0, 10);
                        hero_ids = array_concat(leg_ids, array_concat(rare_ids, common_ids));
                        break;
                }
                
                current_chest_rewards = [];
                for (var h = 0; h < array_length(hero_ids); h++) {
                    var found = false;
                    for (var r = 0; r < array_length(current_chest_rewards); r++) {
                        if (current_chest_rewards[r].hero_id == hero_ids[h]) {
                            current_chest_rewards[r].count++;
                            found = true;
                            break;
                        }
                    }
                    if (!found) {
                        array_push(current_chest_rewards, {hero_id: hero_ids[h], count: 1});
                    }
                }
                
                rewards_state = REWARDS_STATE_CHEST_OPEN;
                rewards_just_opened = true;
                save_permanent_to_file();
            }
            
            if (mouse_x < window_x || mouse_x > window_x + window_width ||
                mouse_y < window_y || mouse_y > window_y + window_height) {
                LOG("Клик вне окна — возврат к списку");
                rewards_state = REWARDS_STATE_SHOWING;
            }
        }
        
        // Состояние: окно с полученными наградами
        else if (rewards_state == REWARDS_STATE_CHEST_OPEN) {
            LOG("Обработка CHEST_OPEN");
            
            if (mouse_x >= button_x && mouse_x <= button_x + button_width &&
                mouse_y >= button_y && mouse_y <= button_y + button_height) {
                LOG("Клик по кнопке ПОЛУЧИТЬ");
                
                for (var i = 0; i < array_length(current_chest_rewards); i++) {
                    var reward = current_chest_rewards[i];
                    add_hero_card(reward.hero_id, reward.count);
                }
                
                rewards_state = REWARDS_STATE_SHOWING;
                rewards_just_opened = true;
                current_chest_rewards = [];
                current_chest = noone;
                
                save_wave_rewards();
                save_permanent_to_file();
            }
        }
    }
    exit;
}

// ===== ЕСЛИ ОКНО ЗАКРЫТО - ОБРАБАТЫВАЕМ КНОПКУ =====

// Границы кнопки
var left = x - btn_width/2;
var right = x + btn_width/2;
var top = y - btn_height/2;
var bottom = y + btn_height/2;

is_hovered = (mouse_x >= left && mouse_x <= right && 
              mouse_y >= top && mouse_y <= bottom);

// Эффект наведения
if (is_hovered) {
    image_xscale = 1.05;
    image_yscale = 1.05;
} else {
    image_xscale = 1;
    image_yscale = 1;
}

// Пульсация при наличии наград (увеличение/уменьшение размера)
var has_rewards = (global.wave_rewards.genes > 0 || 
                   global.wave_rewards.crystals > 0 || 
                   array_length(global.wave_rewards.chests) > 0);

if (has_rewards) {
    // Пульсация масштаба от 1.0 до 1.15 и обратно
    pulse_timer += 0.05 * pulse_dir;
    if (pulse_timer > 1) {
        pulse_timer = 1;
        pulse_dir = -1;
    } else if (pulse_timer < 0) {
        pulse_timer = 0;
        pulse_dir = 1;
    }
    // Масштабируем от 1.0 до 1.15
    var scale = 1 + (pulse_timer * 0.15);
    image_xscale = scale;
    image_yscale = scale;
    image_alpha = 1;  // Прозрачность не меняем
} else {
    image_xscale = 1;
    image_yscale = 1;
    image_alpha = 1;
}

// КЛИК ПО КНОПКЕ
if (is_hovered && mouse_check_button_pressed(mb_left)) {
    LOG("=== КЛИК ПО КНОПКЕ НАГРАДЫ ===");
    LOG("rewards_state ДО: " + string(rewards_state));
    rewards_state = REWARDS_STATE_SHOWING;
    LOG("rewards_state ПОСЛЕ: " + string(rewards_state));
    rewards_just_opened = true;
}
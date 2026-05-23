/// Step Event - obj_game_controller

// ===== ЧИТ-КЛАВИШИ (только в DEBUG-сборке) =====
if (DEBUG_BUILD) {
    if (keyboard_check_pressed(ord("M"))) {
        coins += 1000;
        LOG("ЧИТ: +1000 монет, теперь: " + string(coins));
    }
}

if (global.upgrade_window_open) {
    exit;
}

// Если открыто окно дерева талантов - игра заморожена
if (variable_global_exists("talent_window_open") && global.talent_window_open) {
    if (IS_BACK_PRESSED) {
        global.talent_window_open = false;
        with (obj_talent_tree_window) { instance_destroy(); }
    }
    exit;
}

// Если открыто окно описания таланта - игра заморожена
if (variable_global_exists("talent_desc_window_open") && global.talent_desc_window_open) {
    if (IS_BACK_PRESSED) {
        global.talent_desc_window_open = false;
        with (obj_talent_description_window) { instance_destroy(); }
    }
    exit;
}

// Обновляем время игры ТОЛЬКО если игра не окончена и не на паузе
if (!game_over && controller_state != CONTROLLER_STATE_PAUSE) {
    game_time += 1 / room_speed;
}

// Проверяем, не прошел ли враг за край (только если игра не окончена)
if (!game_over) {
    check_enemy_passed();
}

// Проверяем жизни
if (current_lives <= 0 && !game_over) {
    wave_genes = session_genes;
    LOG("!!! ПРОИГРЫШ: жизней нет, wave_genes=" + string(wave_genes));
    game_over = true;
    controller_state = CONTROLLER_STATE_GAMEOVER;
}

// ===== ОБРАБОТКА СКРОЛЛА ДЕРЕВЬЕВ =====
if (mouse_y > BATTLE_LINE_Y) {
    // Скролл колесиком
    if (mouse_wheel_up()) {
        tree_scroll_y = max(0, tree_scroll_y - tree_scroll_speed);
    }
    if (mouse_wheel_down()) {
        tree_scroll_y = min(tree_scroll_max, tree_scroll_y + tree_scroll_speed);
    }
    
    // Перетаскивание для скролла
    if (mouse_check_button_pressed(mb_left)) {
        var clicked_on_tree = false;
        
        for (var i = 0; i < tree_settings.count; i++) {
            if (hero_trees[i] == noone) continue;
            
            var tree = hero_trees[i];
            var tree_x = tree_settings.start_x + i * (tree_settings.column_width + tree_settings.column_spacing);
            var tree_y = tree_settings.base_y - tree_scroll_y - 80;
            var sprite_center_y = tree_y + 20;
            
            var sprite_left = tree_x - tree_settings.sprite_size/2;
            var sprite_right = tree_x + tree_settings.sprite_size/2;
            var sprite_top = sprite_center_y - tree_settings.sprite_size/2;
            var sprite_bottom = sprite_center_y + tree_settings.sprite_size/2;
            
            if (mouse_x >= sprite_left && mouse_x <= sprite_right &&
                mouse_y >= sprite_top && mouse_y <= sprite_bottom) {
                clicked_on_tree = true;
                break;
            }
            
            var start_y = sprite_center_y + 120;
            
            for (var level = 0; level < tree_settings.max_levels; level++) {
                var btn_y = start_y + level * tree_settings.level_height;
                
                if (mouse_y >= btn_y - 18 && mouse_y <= btn_y + 18) {
                    var left_btn_x = tree.upgrades[level][0].x;
                    if (mouse_x >= left_btn_x - 18 && mouse_x <= left_btn_x + 18) {
                        clicked_on_tree = true;
                        break;
                    }
                    
                    var right_btn_x = tree.upgrades[level][1].x;
                    if (mouse_x >= right_btn_x - 18 && mouse_x <= right_btn_x + 18) {
                        clicked_on_tree = true;
                        break;
                    }
                }
            }
        }
        
        if (!clicked_on_tree) {
            is_dragging_trees = true;
            drag_trees_start_y = mouse_y;
            scroll_trees_start_y = tree_scroll_y;
        }
    }
}

if (mouse_check_button(mb_left) && is_dragging_trees) {
    var drag_delta = drag_trees_start_y - mouse_y;
    tree_scroll_y = scroll_trees_start_y + drag_delta;
    tree_scroll_y = clamp(tree_scroll_y, 0, tree_scroll_max);
}

if (mouse_check_button_released(mb_left)) {
    is_dragging_trees = false;
}

// ===== ОБРАБОТКА КЛИКОВ ПО ДЕРЕВЬЯМ =====
if (mouse_check_button_pressed(mb_left) && mouse_y > BATTLE_LINE_Y && !game_over && controller_state == CONTROLLER_STATE_WAVE) {
    
    // Проверяем, не открыто ли уже окно улучшения
    if (instance_exists(obj_upgrade_window)) {
        exit;
    }
    
    var click_processed = false;
    
    for (var i = 0; i < tree_settings.count && !click_processed; i++) {
        if (hero_trees[i] == noone) continue;
        
        var tree = hero_trees[i];
        var tree_x = tree_settings.start_x + i * (tree_settings.column_width + tree_settings.column_spacing);
        var tree_y = tree_settings.base_y - tree_scroll_y - 80;
        var sprite_center_y = tree_y + 20;
        
        // ===== ПРОВЕРКА КЛИКА ПО СПРАЙТУ (ПРИЗЫВ) =====
        var sprite_left = tree_x - tree_settings.sprite_size/2;
        var sprite_right = tree_x + tree_settings.sprite_size/2;
        var sprite_top = sprite_center_y - tree_settings.sprite_size/2;
        var sprite_bottom = sprite_center_y + tree_settings.sprite_size/2;
        
        // Проверяем, жив ли уже герой этого типа
        var hero_alive = false;
        with (obj_hero_base) {
            if (hero_id == tree.hero_id && hp > 0) {
                hero_alive = true;
                break;
            }
        }
        
        var sprite_disabled = hero_alive;
        
        if (!sprite_disabled && 
            mouse_x >= sprite_left && mouse_x <= sprite_right &&
            mouse_y >= sprite_top && mouse_y <= sprite_bottom) {
            
            var cost = tree.get_respawn_cost();
            
            if (coins >= cost) {
                coins -= cost;
                
                var hp_bonus = tree.get_total_hp_bonus() / 100;
                var damage_bonus = tree.get_total_damage_bonus() / 100;
                
                var hero_data = global.heroes[tree.hero_id];
                var new_hero = create_hero_instance(hero_data, tree.hero_id, hp_bonus, damage_bonus);
                
                if (instance_exists(new_hero)) {
                    if (tree.summon_count == 0 && tree.unlocked_levels == 0) {
                        tree.unlocked_levels = 1;
                    }
                    tree.summon_count++;
                    LOG("✅ Герой призван! Стоимость: " + string(cost));
                } else {
                    coins += cost;
                }
            }
            
            click_processed = true;
            break;
        }
        
        // ===== ПРОВЕРКА КЛИКОВ ПО КНОПКАМ УЛУЧШЕНИЙ =====
        var start_y = sprite_center_y + 120;
        
        for (var level = 0; level < tree_settings.max_levels && !click_processed; level++) {
            var btn_y = start_y + level * tree_settings.level_height;
            
            // Проверяем статус уровня
            var is_unlocked_by_progress = (level < tree.unlocked_levels);
            var required_hero_level = TREE_LEVEL_REQUIREMENTS[level];
            var hero_data = global.heroes[tree.hero_id];
            var hero_card_level = hero_data.level;
            var meets_card_requirement = (required_hero_level == 0 || hero_card_level >= required_hero_level);
            var is_unlocked = is_unlocked_by_progress && meets_card_requirement;
            var is_locked_by_card = (is_unlocked_by_progress && !meets_card_requirement);
            
            // Проверяем, выбран ли этот уровень
            var level_chosen = false;
            var left_chosen = false;
            var right_chosen = false;
            
            for (var u = 0; u < array_length(tree.chosen_upgrades); u++) {
                if (tree.chosen_upgrades[u].level == level) {
                    level_chosen = true;
                    if (tree.chosen_upgrades[u].type == "hp" || tree.chosen_upgrades[u].type == "armor" || 
                        tree.chosen_upgrades[u].type == "attack_speed" || tree.chosen_upgrades[u].type == "range") {
                        left_chosen = true;
                    } else {
                        right_chosen = true;
                    }
                }
            }
            
            if (level_chosen) continue;
            if (!is_unlocked) continue;
            
            var left_btn_x = tree.upgrades[level][0].x;
            var right_btn_x = tree.upgrades[level][1].x;
            
           // ===== ЛЕВАЯ КНОПКА =====
if (!left_chosen && !right_chosen &&
    mouse_x >= left_btn_x - 18 && mouse_x <= left_btn_x + 18 &&
    mouse_y >= btn_y - 18 && mouse_y <= btn_y + 18) {
    
    // Проверяем, есть ли живой герой на поле
    var hero_exists_on_field = false;
    with (obj_hero_base) {
        if (hero_id == tree.hero_id && hp > 0) {
            hero_exists_on_field = true;
            break;
        }
    }
    
    if (!hero_exists_on_field) {
        LOG("⚠️ Нет живого героя на поле! Нельзя улучшить дерево без героя.");
        click_processed = true;
        break;
    }
    
    var upgrade_cost = tree.get_upgrade_cost(level);
    var left_type = tree.upgrades[level][0].type;
    var left_value = tree.upgrades[level][0].value;
    var left_name = tree.upgrades[level][0].name;
    
    LOG("=== ОТКРЫТИЕ ОКНА (ЛЕВАЯ) ===");
    LOG("Тип: " + left_type + ", стоимость: " + string(upgrade_cost));
    
    // СОХРАНЯЕМ ТЕКУЩЕЕ СОСТОЯНИЕ КОНТРОЛЛЕРА
    var saved_state = controller_state;
    
    // СОХРАНЯЕМ ДАННЫЕ В ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
    global.temp_upgrade_hero_tree = tree;
    global.temp_upgrade_level = level;
    global.temp_upgrade_is_left = true;
    global.temp_upgrade_type = left_type;
    global.temp_upgrade_value = left_value;
    global.temp_upgrade_name = left_name;
    global.temp_upgrade_cost = upgrade_cost;
    
    // СОЗДАЁМ ОКНО
    var upgrade_window = instance_create_layer(0, 0, "Instances", obj_upgrade_window);
    
    click_processed = true;
    break;
}

// ===== ПРАВАЯ КНОПКА =====
if (!left_chosen && !right_chosen &&
    mouse_x >= right_btn_x - 18 && mouse_x <= right_btn_x + 18 &&
    mouse_y >= btn_y - 18 && mouse_y <= btn_y + 18) {
    
    // Проверяем, есть ли живой герой на поле
    var hero_exists_on_field = false;
    with (obj_hero_base) {
        if (hero_id == tree.hero_id && hp > 0) {
            hero_exists_on_field = true;
            break;
        }
    }
    
    if (!hero_exists_on_field) {
        LOG("⚠️ Нет живого героя на поле! Нельзя улучшить дерево без героя.");
        click_processed = true;
        break;
    }
    
    var upgrade_cost = tree.get_upgrade_cost(level);
    var right_type = tree.upgrades[level][1].type;
    var right_value = tree.upgrades[level][1].value;
    var right_name = tree.upgrades[level][1].name;
    
    LOG("=== ОТКРЫТИЕ ОКНА (ПРАВАЯ) ===");
    LOG("Тип: " + right_type + ", стоимость: " + string(upgrade_cost));
    
    // СОХРАНЯЕМ ТЕКУЩЕЕ СОСТОЯНИЕ КОНТРОЛЛЕРА
    var saved_state = controller_state;
    
    // СОХРАНЯЕМ ДАННЫЕ В ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
    global.temp_upgrade_hero_tree = tree;
    global.temp_upgrade_level = level;
    global.temp_upgrade_is_left = false;
    global.temp_upgrade_type = right_type;
    global.temp_upgrade_value = right_value;
    global.temp_upgrade_name = right_name;
    global.temp_upgrade_cost = upgrade_cost;
    
    // СОЗДАЁМ ОКНО
    var upgrade_window = instance_create_layer(0, 0, "Instances", obj_upgrade_window);
    
    click_processed = true;
    break;
}
        }
    }
}

// ===== ЧИТ-КОД: B ДЛЯ ПРИЗЫВА БОССА (только в DEBUG-сборке) =====
if (DEBUG_BUILD && keyboard_check_pressed(ord("B"))) {
    LOG("=== ЧИТ: ПРИЗЫВ БОССА ПО КЛАВИШЕ B ===");

    if (boss_active) {
        LOG("⚠️ Босс уже активен! Нельзя призвать второго.");
    } else if (current_enemies_on_field >= max_enemies_on_field) {
        LOG("⚠️ Лимит врагов достигнут! Нельзя призвать босса.");
    } else {
        var boss = spawn_boss();
        if (instance_exists(boss)) {
            LOG("!!! ЧИТ: БОСС ПРИЗВАН !!!");
        }
    }
}

// ===== ПРОВЕРКА КНОПКИ ПАУЗЫ =====
if (mouse_check_button_pressed(mb_left) && !game_over) {
    if (mouse_x >= pause_button_x && mouse_x <= pause_button_x + pause_button_width &&
        mouse_y >= pause_button_y && mouse_y <= pause_button_y + pause_button_height) {
        controller_state = CONTROLLER_STATE_PAUSE;
    }
}

// Обрабатываем текущее состояние контроллера
switch (controller_state) {
    case CONTROLLER_STATE_WAVE:
        scr_controller_state_wave(id);
        break;
    case CONTROLLER_STATE_PAUSE:
        scr_controller_state_pause(id);
        break;
    case CONTROLLER_STATE_GAMEOVER:
        scr_controller_state_gameover(id);
        break;
}
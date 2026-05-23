/// Step Event - obj_upgrade_window

// Закрытие по ESC
if (IS_BACK_PRESSED) {
    global.upgrade_window_open = false;
    instance_destroy();
    var controller = instance_find(obj_game_controller, 0);
    if (instance_exists(controller)) {
        controller.controller_state = controller.CONTROLLER_STATE_WAVE;
    }
    exit;
}

// Сброс флага после первого кадра
if (just_opened) {
    just_opened = false;
    exit;
}

// ИГНОРИРУЕМ ПЕРВЫЙ КЛИК ПОСЛЕ ОТКРЫТИЯ ОКНА
if (ignore_first_click) {
    if (mouse_check_button_released(mb_left)) {
        ignore_first_click = false;
    }
    exit;
}

// ===== ОБРАБОТКА КЛИКОВ =====
if (mouse_check_button_released(mb_left)) {
    
    // Проверяем клик по кнопке "УЛУЧШИТЬ"
    if (mouse_x >= button_x && mouse_x <= button_x + button_width &&
        mouse_y >= button_y && mouse_y <= button_y + button_height) {
        
        LOG("=== ПОДТВЕРЖДЕНИЕ УЛУЧШЕНИЯ ===");
        LOG("upgrade_type = " + string(upgrade_type));
        LOG("upgrade_cost = " + string(upgrade_cost));
        LOG("is_left = " + string(is_left));  // ← ОТЛАДКА
        
        if (upgrade_type == "") {
            LOG("⚠️ ОШИБКА: upgrade_type пустой");
            global.upgrade_window_open = false;
            instance_destroy();
            var controller = instance_find(obj_game_controller, 0);
            if (instance_exists(controller)) {
                controller.controller_state = controller.CONTROLLER_STATE_WAVE;
            }
            exit;
        }
        
        var _hero_tree = hero_tree;
        var _upgrade_type = upgrade_type;
        var _upgrade_value = upgrade_value;
        var _level = level;
        var _upgrade_cost = upgrade_cost;
        var _hero_id = hero_tree.hero_id;
        var _is_left = is_left;  // ← СОХРАНЯЕМ
        
        // Проверяем, есть ли живой герой на поле
        var hero_exists_on_field = false;
        var target_hero_instance = noone;
        
        with (obj_hero_base) {
            if (hero_id == _hero_id && hp > 0) {
                hero_exists_on_field = true;
                target_hero_instance = id;
                break;
            }
        }
        
        if (!hero_exists_on_field) {
            LOG("⚠️ Нет живого героя на поле!");
            global.upgrade_window_open = false;
            instance_destroy();
            var controller = instance_find(obj_game_controller, 0);
            if (instance_exists(controller)) {
                controller.controller_state = controller.CONTROLLER_STATE_WAVE;
            }
            exit;
        }
        
        // Проверяем хватает ли монет
        var controller = instance_find(obj_game_controller, 0);
        if (instance_exists(controller) && controller.coins >= _upgrade_cost) {
            controller.coins -= _upgrade_cost;
            global.coins = controller.coins;
            
            var ghost = instance_create_layer(100, 600, "Instances", obj_hero_ghost);
            
            with (ghost) {
                sprite_index = _hero_tree.hero_sprite;
                target_hero = target_hero_instance;
                upgrade_type = _upgrade_type;
                upgrade_value = _upgrade_value;
                upgrade_level = _level;
                side = (_is_left ? "left" : "right");  // ← ПЕРЕДАЁМ СТОРОНУ В ПРИЗРАКА!
                x = 100;
                y = 600;
                LOG("👻 Призрак создан для улучшения " + upgrade_type + ", side=" + side);
            }
            
            // ===== ИСПРАВЛЕНО: ДОБАВЛЯЕМ УЛУЧШЕНИЕ С ПРАВИЛЬНЫМ side =====
            var chosen_upgrade = {
                type: _upgrade_type,
                value: _upgrade_value,
                level: _level,
                side: (_is_left ? "left" : "right")  // ← ГЛАВНОЕ ИСПРАВЛЕНИЕ!
            };
            array_push(_hero_tree.chosen_upgrades, chosen_upgrade);
            
            LOG("✅ Добавлено улучшение в дерево: type=" + _upgrade_type + 
                              ", level=" + string(_level) + 
                              ", side=" + chosen_upgrade.side);
            
            if (_hero_tree.unlocked_levels < 10) {
                _hero_tree.unlocked_levels++;
            }
            
            LOG("✅ Улучшение добавлено в дерево");
            
        } else {
            LOG("⚠️ Не хватает монет! Нужно: " + string(_upgrade_cost));
        }
        
        global.upgrade_window_open = false;
        instance_destroy();
        
        if (instance_exists(controller)) {
            controller.controller_state = controller.CONTROLLER_STATE_WAVE;
        }
        exit;
    }
    
    // Проверяем клик вне окна — закрываем без улучшения
    if (mouse_x < window_x || mouse_x > window_x + window_width ||
        mouse_y < window_y || mouse_y > window_y + window_height) {
        
        LOG("=== ОКНО ЗАКРЫТО БЕЗ УЛУЧШЕНИЯ ===");
        global.upgrade_window_open = false;
        instance_destroy();
        
        var controller = instance_find(obj_game_controller, 0);
        if (instance_exists(controller)) {
            controller.controller_state = controller.CONTROLLER_STATE_WAVE;
        }
        exit;
    }
}

// Блокируем клики внутри окна (кроме кнопки улучшения)
if (mouse_check_button_pressed(mb_left) || mouse_check_button_released(mb_left)) {
    if (mouse_x >= window_x && mouse_x <= window_x + window_width &&
        mouse_y >= window_y && mouse_y <= window_y + window_height) {
        if (!(mouse_x >= button_x && mouse_x <= button_x + button_width &&
              mouse_y >= button_y && mouse_y <= button_y + button_height)) {
            exit;
        }
    }
}
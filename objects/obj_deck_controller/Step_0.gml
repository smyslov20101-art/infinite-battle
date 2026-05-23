/// Step Event - obj_deck_controller

// Обновление таймера блокировки кнопок карточки
if (card_open_timer > 0) {
    card_open_timer -= 1 / room_speed;
}

// Если открыто ЛЮБОЕ окно - не обрабатываем клики в колоде
if (global.talent_window_open || global.talent_desc_window_open || global.upgrade_window_open) {
    exit;
}

// Если в режиме детальной карточки
if (current_state == SCREEN_STATE_HERO_DETAIL) {
    
    // Получаем координаты кнопок из переменных контроллера
    var plus_btn_x = 0;
    var plus_btn_y = 0;
    var plus_btn_w = 0;
    var plus_btn_h = 0;
    var tree_btn_x = 0;
    var tree_btn_y = 0;
    var tree_btn_w = 0;
    var tree_btn_h = 0;
    var card_x = 0;
    var card_y = 0;
    var card_w = 0;
    var card_h = 0;
    var detail_hero_id = -1;
    var detail_in_deck = false;
    var detail_class_count = 0;
    var detail_max_allowed = 1;
    
    if (variable_instance_exists(id, "detail_plus_btn_x")) { plus_btn_x = detail_plus_btn_x; }
    if (variable_instance_exists(id, "detail_plus_btn_y")) { plus_btn_y = detail_plus_btn_y; }
    if (variable_instance_exists(id, "detail_plus_btn_w")) { plus_btn_w = detail_plus_btn_w; }
    if (variable_instance_exists(id, "detail_plus_btn_h")) { plus_btn_h = detail_plus_btn_h; }
    if (variable_instance_exists(id, "detail_tree_btn_x")) { tree_btn_x = detail_tree_btn_x; }
    if (variable_instance_exists(id, "detail_tree_btn_y")) { tree_btn_y = detail_tree_btn_y; }
    if (variable_instance_exists(id, "detail_tree_btn_w")) { tree_btn_w = detail_tree_btn_w; }
    if (variable_instance_exists(id, "detail_tree_btn_h")) { tree_btn_h = detail_tree_btn_h; }
    if (variable_instance_exists(id, "detail_card_x")) { card_x = detail_card_x; }
    if (variable_instance_exists(id, "detail_card_y")) { card_y = detail_card_y; }
    if (variable_instance_exists(id, "detail_card_w")) { card_w = detail_card_w; }
    if (variable_instance_exists(id, "detail_card_h")) { card_h = detail_card_h; }
    // ВАЖНО: использовать self.X на правой стороне, иначе локальная var затеняет instance-переменную
    // и присваивание становится `local = local` (= дефолтное значение, не значение из instance).
    // Был баг: кнопка "убрать из отряда" не работала именно из-за этого.
    if (variable_instance_exists(id, "detail_hero_id"))     { detail_hero_id = self.detail_hero_id; }
    if (variable_instance_exists(id, "detail_in_deck"))     { detail_in_deck = self.detail_in_deck; }
    if (variable_instance_exists(id, "detail_class_count")) { detail_class_count = self.detail_class_count; }
    if (variable_instance_exists(id, "detail_max_allowed")) { detail_max_allowed = self.detail_max_allowed; }
    
    if (mouse_check_button_released(mb_left)) {
        var click_on_button = false;
        
        // Проверка клика по кнопке spr_plus (добавить/убрать)
        if (plus_btn_w > 0 && mouse_x >= plus_btn_x && mouse_x <= plus_btn_x + plus_btn_w &&
            mouse_y >= plus_btn_y && mouse_y <= plus_btn_y + plus_btn_h) {
            click_on_button = true;
            
            if (card_open_timer > 0) {
                LOG("=== БЛОКИРОВКА: кнопки карточки заблокированы (таймер) ===");
                exit;
            }
            
            if (detail_in_deck) {
                // Убрать из отряда
                for (var s = 0; s < 4; s++) {
                    if (global.player_deck[s] == detail_hero_id) {
                        if (remove_hero_from_deck(s)) {
                            LOG("Герой убран из слота " + string(s + 1));
                            current_state = SCREEN_STATE_LIST;
                            selected_hero_id = -1;
                        }
                        break;
                    }
                }
            } else {
                // Всегда переходим в режим выбора слота — там подсветим где можно положить.
                // Если ни одного подходящего слота нет, выйдешь по ESC / клику мимо.
                current_state = SCREEN_STATE_SELECT_SLOT;
                // Безопасное логирование — на случай если detail_hero_id ещё не задан
                if (detail_hero_id >= 0 && detail_hero_id < array_length(global.heroes)) {
                    LOG("Выберите слот для размещения " + global.heroes[detail_hero_id].name);
                } else {
                    LOG("Выберите слот (hero_id=" + string(detail_hero_id) + ")");
                }
            }
        }
        
        // Проверка клика по кнопке spr_tree (дерево талантов)
        if (!click_on_button && tree_btn_w > 0 && mouse_x >= tree_btn_x && mouse_x <= tree_btn_x + tree_btn_w &&
            mouse_y >= tree_btn_y && mouse_y <= tree_btn_y + tree_btn_h) {
            click_on_button = true;
            
            if (card_open_timer > 0) {
                LOG("=== БЛОКИРОВКА: кнопки карточки заблокированы (таймер) ===");
                exit;
            }
            
            if (global.talent_window_open) {
                LOG("=== БЛОКИРОВКА: окно дерева уже открыто ===");
                exit;
            }
            
            if (!instance_exists(obj_talent_tree_window)) {
                var tree_window = instance_create_layer(0, 0, "Instances", obj_talent_tree_window);
                tree_window.hero_id = detail_hero_id;
            }
        }
        
        // Проверка клика вне карточки для закрытия (только если не кликнули по кнопке)
        if (!click_on_button) {
            if (mouse_x < card_x || mouse_x > card_x + card_w ||
                mouse_y < card_y || mouse_y > card_y + card_h) {
                current_state = SCREEN_STATE_LIST;
                selected_hero_id = -1;
                card_open_timer = 0;
                LOG("Закрыли карточку (клик вне)");
            }
        }
    }
    
    if (IS_BACK_PRESSED) {
        current_state = SCREEN_STATE_LIST;
        selected_hero_id = -1;
        card_open_timer = 0;
        LOG("Вернулись к списку героев");
    }
    exit;
}

// Если в режиме выбора слота
if (current_state == SCREEN_STATE_SELECT_SLOT) {
    var hero_data = global.heroes[selected_hero_id];
    var hero_class = hero_data.class_type;
    var max_allowed = (hero_class == global.CLASS_MAGE || hero_class == global.CLASS_SUPPORT) ? 2 : 1;

    // Параметры слотов — ОТРАЖАЮТ Draw_0 (центр-смещения)
    var slot_w = 100;
    var slot_h = 100;
    var slot_base_y = 215;
    var slot_offsets = [-265, -90, 90, 265];

    if (mouse_check_button_released(mb_left)) {
        var hit_slot = -1;
        for (var i = 0; i < 4; i++) {
            var cx = (room_width / 2) + slot_offsets[i];
            var cy = slot_base_y + (slot_h / 2);
            if (mouse_x >= cx - slot_w/2 && mouse_x <= cx + slot_w/2 &&
                mouse_y >= cy - slot_h/2 && mouse_y <= cy + slot_h/2) {
                hit_slot = i;
                break;
            }
        }

        if (hit_slot >= 0) {
            // Проверяем, можно ли положить героя в этот слот
            var slot_hero_id = global.player_deck[hit_slot];
            var can_place = true;

            if (slot_hero_id >= 0) {
                // Слот занят — считаем сколько героев нашего класса в ДРУГИХ слотах
                var future_count = 0;
                for (var j = 0; j < 4; j++) {
                    if (j == hit_slot) continue;
                    var oid = global.player_deck[j];
                    if (oid >= 0 && global.heroes[oid].class_type == hero_class) {
                        future_count++;
                    }
                }
                if (future_count >= max_allowed) can_place = false;
            } else {
                // Слот пустой — текущий счёт класса должен быть < max
                if (get_class_count_in_deck(hero_class) >= max_allowed) can_place = false;
            }

            if (can_place) {
                if (add_hero_to_deck(selected_hero_id, hit_slot)) {
                    LOG("Герой " + hero_data.name + " размещён в слот " + string(hit_slot + 1));
                }
                current_state = SCREEN_STATE_LIST;
                selected_hero_id = -1;
                card_open_timer = 0;
            } else {
                LOG("В этот слот нельзя — лимит класса " + hero_class);
            }
        } else {
            // Клик мимо слотов — отменяем выбор
            current_state = SCREEN_STATE_LIST;
            selected_hero_id = -1;
            card_open_timer = 0;
            LOG("Отмена выбора слота");
        }
    }

    if (IS_BACK_PRESSED) {
        current_state = SCREEN_STATE_LIST;
        selected_hero_id = -1;
        card_open_timer = 0;
    }
    exit;
}

// === РЕЖИМ СПИСКА ГЕРОЕВ ===

// ===== ЗАЩИТА ОТ «ПРОТЕКАЮЩЕГО» КЛИКА ИЗ НАВИГАЦИИ =====
// Press на nav-кнопке мог произойти в предыдущей комнате, а release уже здесь —
// это вызывало автоматическое открытие первой карточки. Считаем release настоящим
// только если был полноценный press В ЭТОЙ комнате.
if (mouse_check_button_pressed(mb_left)) {
    saw_fresh_press = true;
}
var real_click = saw_fresh_press && mouse_check_button_released(mb_left);
if (mouse_check_button_released(mb_left)) {
    saw_fresh_press = false; // готовы к следующему циклу
}

// Клик по слотам отряда
if (real_click) {
    // Параметры слотов (ДОЛЖНЫ СОВПАДАТЬ С DRAW EVENT!)
    var slot_width = 100;
    var slot_height = 100;
    var base_slots_start_y = 215;
    var slot_offsets = [-265, -90, 90, 265];
    
    for (var i = 0; i < 4; i++) {
        var slot_center_x = (room_width / 2) + slot_offsets[i];
        var slot_center_y = base_slots_start_y + (slot_height / 2);
        
        var slot_left = slot_center_x - slot_width/2;
        var slot_right = slot_center_x + slot_width/2;
        var slot_top = slot_center_y - slot_height/2;
        var slot_bottom = slot_center_y + slot_height/2;
        
        if (mouse_x >= slot_left && mouse_x <= slot_right &&
            mouse_y >= slot_top && mouse_y <= slot_bottom) {
            
            var hero_id = global.player_deck[i];
            if (hero_id >= 0) {
                selected_hero_id = hero_id;
                current_state = SCREEN_STATE_HERO_DETAIL;
                card_open_timer = 0.3;
                LOG("Открыта карточка героя из слота " + string(i+1) + ": " + global.heroes[hero_id].name);
            }
            exit;
        }
    }
}

// Клик по карточкам героев
if (real_click) {
    var hero_clicked = check_hero_card_click(mouse_x, mouse_y, scroll_y);
    if (hero_clicked >= 0) {
        selected_hero_id = hero_clicked;
        current_state = SCREEN_STATE_HERO_DETAIL;
        card_open_timer = 0.3;
        LOG("Открыта карточка героя из списка: " + global.heroes[hero_clicked].name);
        exit;
    }
}

// Прокрутка
if (mouse_wheel_up()) { scroll_y = max(0, scroll_y - 30); }
if (mouse_wheel_down()) { scroll_y = min(scroll_max, scroll_y + 30); }

// Перетаскивание
if (mouse_check_button_pressed(mb_left)) {
    var mouse_in_list_area = mouse_y >= list_start_y && mouse_y <= room_height - 100;
    if (mouse_in_list_area && check_hero_card_click(mouse_x, mouse_y, scroll_y) < 0) {
        is_dragging = true;
        drag_start_y = mouse_y;
        scroll_start_y = scroll_y;
    }
}

if (mouse_check_button(mb_left) && is_dragging) {
    scroll_y = clamp(scroll_start_y + drag_start_y - mouse_y, 0, scroll_max);
}

if (mouse_check_button_released(mb_left)) {
    is_dragging = false;
}

if (IS_BACK_PRESSED && current_state == SCREEN_STATE_LIST) {
    room_goto(room_wave);
}
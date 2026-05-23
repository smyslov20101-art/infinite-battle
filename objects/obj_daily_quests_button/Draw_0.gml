/// Draw Event - obj_daily_quests_button

// ===== ОБНОВЛЯЕМ КООРДИНАТЫ ОКНА (каждый кадр!) =====
window_x = (room_width - 500) / 2;
window_y = (room_height - 400) / 2;
window_width = 500;
window_height = 400;

// ===== ОТЛАДОЧНАЯ ИНФОРМАЦИЯ НА ЭКРАНЕ =====
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_m);
draw_text(10, 100, "Draw: quest_state = " + string(quest_state));
draw_text(10, 120, "QUEST_STATE_SHOWING = " + string(QUEST_STATE_SHOWING));
draw_text(10, 140, "window_x = " + string(window_x) + " window_y = " + string(window_y));
draw_text(10, 160, "room_width = " + string(room_width) + " room_height = " + string(room_height));

// ===== РИСУЕМ САМУ КНОПКУ =====
draw_self();

// ===== РИСУЕМ ОКНО =====
if (quest_state == QUEST_STATE_SHOWING) {
    draw_text(10, 180, "РИСУЕМ ОКНО ЗАДАНИЙ");
    draw_quests_window();
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);

// =============================================================================
// ФУНКЦИЯ ОТРИСОВКИ ОКНА ЗАДАНИЙ
// =============================================================================

/// @function draw_quests_window()
/// @desc Рисует окно со списком заданий
function draw_quests_window() {
    LOG("draw_quests_window() ВЫЗВАНА");
    
    // ===== ПРОВЕРКА: если daily_quests не инициализированы — инициализируем =====
    if (!variable_global_exists("permanent_save") || 
        !struct_exists(global.permanent_save, "daily_quests") ||
        array_length(global.permanent_save.daily_quests.quest_list) == 0) {
        
        LOG("daily_quests не инициализированы, создаём...");
        init_daily_quests();
    }
    
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
    draw_text(window_x + window_width/2, window_y + 40, "ЕЖЕДНЕВНЫЕ ЗАДАНИЯ");
    
    // Рисуем 3 задания
    var q_list = global.permanent_save.daily_quests.quest_list;
    var start_y = window_y + 90;
    var row_h = 80;
    
    for (var i = 0; i < array_length(q_list); i++) {
        var q_item = q_list[i];
        var quest_y = start_y + i * row_h;
        
        // Рамка задания
        if (q_item.is_completed && !q_item.is_claimed) {
            draw_set_color(c_lime);
        } else if (q_item.is_claimed) {
            draw_set_color(make_color_rgb(80, 80, 80));
        } else {
            draw_set_color(make_color_rgb(80, 80, 100));
        }
        draw_rectangle(window_x + 20, quest_y, window_x + window_width - 20, quest_y + row_h - 10, false);
        
        // Фон задания
        draw_set_color(make_color_rgb(40, 40, 50));
        draw_rectangle(window_x + 22, quest_y + 2, window_x + window_width - 22, quest_y + row_h - 12, false);
        
        // Описание
        draw_set_halign(fa_left);
        draw_set_color(c_white);
        draw_set_font(fnt_m);
        draw_text(window_x + 40, quest_y + 20, q_item.desc);
        
        // Прогресс
        var prog_text = get_quest_progress_text(i);
        draw_set_color(c_yellow);
        draw_text(window_x + 40, quest_y + 45, prog_text);
        
        // Награда
        draw_set_color(c_orange);
        draw_text(window_x + 40, quest_y + 65, 
                  "Награда: " + string(q_item.reward_amount) + " " + 
                  (q_item.reward_type == "genes" ? "генов" : "кристаллов"));
        
        // Кнопка "ПОЛУЧИТЬ"
        if (is_quest_available_for_claim(i)) {
            var btn_w = 100;
            var btn_h = 35;
            var btn_x = window_x + window_width - 80;
            var btn_y = quest_y + row_h/2 - 15;
            
            var mouse_on_btn = (mouse_x >= btn_x && mouse_x <= btn_x + btn_w &&
                                mouse_y >= btn_y && mouse_y <= btn_y + btn_h);
            
            if (mouse_on_btn) {
                draw_set_color(make_color_rgb(120, 180, 255));
            } else {
                draw_set_color(make_color_rgb(80, 150, 255));
            }
            draw_rectangle(btn_x, btn_y, btn_x + btn_w, btn_y + btn_h, false);
            draw_set_color(c_white);
            draw_rectangle(btn_x, btn_y, btn_x + btn_w, btn_y + btn_h, true);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_font(fnt_m);
            draw_text(btn_x + btn_w/2, btn_y + btn_h/2, "ПОЛУЧИТЬ");
            
            // Сохраняем ID задания для клика
            if (mouse_on_btn && mouse_check_button_released(mb_left)) {
                quest_clicked_id = i;
                LOG("quest_clicked_id установлен в " + string(i));
            }
        } else if (q_item.is_claimed) {
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_green);
            draw_text(window_x + window_width - 80, quest_y + row_h/2, "ПОЛУЧЕНО");
        }
    }
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
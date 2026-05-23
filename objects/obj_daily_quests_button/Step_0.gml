/// Step Event - obj_daily_quests_button

// ОТЛАДКА: выводим состояние в консоль каждые 60 кадров
if (frame_counter == undefined) frame_counter = 0;
frame_counter++;
if (frame_counter >= 60) {
    LOG("Step: quest_state = " + string(quest_state));
    frame_counter = 0;
}

// ===== ЕСЛИ ОКНО ОТКРЫТО - ОБРАБАТЫВАЕМ КЛИКИ В ОКНЕ =====
if (quest_state == QUEST_STATE_SHOWING) {
    
    if (mouse_check_button_pressed(mb_left)) {
        LOG("КЛИК В ОКНЕ ЗАДАНИЙ! quest_state = " + string(quest_state));
        
        // Проверяем клик по кнопке получения награды
        if (quest_clicked_id >= 0) {
            LOG("Клик по кнопке ПОЛУЧИТЬ для задания " + string(quest_clicked_id));
            claim_quest_reward(quest_clicked_id);
            quest_clicked_id = -1;
            quest_state = QUEST_STATE_SHOWING;
            quests_just_opened = true;
        }
        
        // Проверяем клик вне окна для закрытия
        if (mouse_x < window_x || mouse_x > window_x + window_width ||
            mouse_y < window_y || mouse_y > window_y + window_height) {
            LOG("Клик вне окна — закрываем");
            quest_state = QUEST_STATE_NONE;
            quest_clicked_id = -1;
        }
    }
    
    // ESC для закрытия
    if (IS_BACK_PRESSED) {
        LOG("ESC — закрываем окно заданий");
        quest_state = QUEST_STATE_NONE;
        quest_clicked_id = -1;
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

// КЛИК ПО КНОПКЕ
if (is_hovered && mouse_check_button_pressed(mb_left)) {
    LOG("=== КЛИК ПО КНОПКЕ ЕЖЕДНЕВНЫХ ЗАДАНИЙ ===");
    LOG("quest_state ДО: " + string(quest_state));
    quest_state = QUEST_STATE_SHOWING;
    LOG("quest_state ПОСЛЕ: " + string(quest_state));
    quests_just_opened = true;
}
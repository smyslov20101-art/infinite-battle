/// @function scr_controller_state_pause(_controller_instance)
/// @desc Обработка состояния ПАУЗЫ

function scr_controller_state_pause(_controller_instance) {
    if (!instance_exists(_controller_instance)) return;
    
    with (_controller_instance) {
        // Параметры окна
        var window_width = 400;
        var window_height = 250;
        var window_x = (room_width - window_width) / 2;
        var window_y = (room_height - window_height) / 2;
        
        // Параметры кнопок
        var btn_width = 180;
        var btn_height = 50;
        var btn_x = window_x + (window_width - btn_width) / 2;
        var continue_btn_y = window_y + 120;
        var surrender_btn_y = window_y + 180;
        
        // Обработка кликов
        if (mouse_check_button_pressed(mb_left)) {
            
            // Проверяем клик по кнопке "ПРОДОЛЖИТЬ"
            if (mouse_x >= btn_x && mouse_x <= btn_x + btn_width &&
                mouse_y >= continue_btn_y && mouse_y <= continue_btn_y + btn_height) {
                
                LOG("Пауза: нажата кнопка ПРОДОЛЖИТЬ");
                controller_state = CONTROLLER_STATE_WAVE;
            }
            
            // Проверяем клик по кнопке "СДАТЬСЯ"
            if (mouse_x >= btn_x && mouse_x <= btn_x + btn_width &&
                mouse_y >= surrender_btn_y && mouse_y <= surrender_btn_y + btn_height) {
                
                LOG("Пауза: нажата кнопка СДАТЬСЯ");
                
                // ВАЖНО: копируем заработанные гены в wave_genes
                wave_genes = session_genes;
                
                LOG("При сдаче: session_genes=" + string(session_genes) + 
                                  ", wave_genes=" + string(wave_genes) +
                                  ", wave_crystals=" + string(wave_crystals));
                
                // Переходим в состояние Game Over
                game_over = true;
                controller_state = CONTROLLER_STATE_GAMEOVER;
            }
            
            // Клик вне окна - просто закрываем паузу (опционально)
            if (mouse_x < window_x || mouse_x > window_x + window_width ||
                mouse_y < window_y || mouse_y > window_y + window_height) {
                // Можно либо закрыть паузу, либо игнорировать
                // controller_state = CONTROLLER_STATE_WAVE;
            }
        }
        
        // ESC для выхода из паузы
        if (IS_BACK_PRESSED) {
            controller_state = CONTROLLER_STATE_WAVE;
        }
    }
	
	LOG("СДАЧА: session_genes=" + string(session_genes) + 
                  ", wave_genes было=" + string(wave_genes));
wave_genes = session_genes;
LOG("СДАЧА: wave_genes стало=" + string(wave_genes));
}
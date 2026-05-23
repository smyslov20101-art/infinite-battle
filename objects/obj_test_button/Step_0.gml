/// Step Event - obj_test_button

var left = x - btn_width/2;
var right = x + btn_width/2;
var top = y - btn_height/2;
var bottom = y + btn_height/2;

is_hovered = (mouse_x >= left && mouse_x <= right && 
              mouse_y >= top && mouse_y <= bottom);

if (is_hovered) {
    current_col = hover_col;
    
    if (mouse_check_button_pressed(mb_left)) {
        current_col = click_col;
        LOG("=== ЗАПУСК ТЕСТОВОЙ КОМНАТЫ ===");
        
        // Переходим в тестовую комнату
        room_goto(room_test);
    }
} else {
    current_col = col;
}
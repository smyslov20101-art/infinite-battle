/// Step Event - obj_play_button

// Проверяем наведение
var left = x - btn_width/2;
var right = x + btn_width/2;
var top = y - btn_height/2;
var bottom = y + btn_height/2;

is_hovered = (mouse_x >= left && mouse_x <= right && 
              mouse_y >= top && mouse_y <= bottom);

// Проверяем, полный ли отряд
var deck_full = true;
for (var i = 0; i < 4; i++) {
    if (global.player_deck[i] < 0) {
        deck_full = false;
        break;
    }
}

if (deck_full) {
    if (is_hovered) {
        current_col = hover_col;
        
        if (mouse_check_button_pressed(mb_left)) {
            current_col = click_col;
            LOG("=== ЗАПУСК БЕСКОНЕЧНОЙ ВОЛНЫ ===");
            
            // Просто переходим в комнату с контроллером
            room_goto(room_endless);
        }
    } else {
        current_col = col;
    }
} else {
    current_col = make_color_rgb(80, 80, 80);
}
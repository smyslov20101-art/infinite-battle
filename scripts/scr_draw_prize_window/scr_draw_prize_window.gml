/// @function draw_prize_window()
/// @desc Рисует окно с выпавшим призом

function draw_prize_window() {
    if (prize_state != PRIZE_STATE_SHOWING || current_prize == noone) return;
    
    // Затемняем фон
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, room_width, room_height, true);
    draw_set_alpha(1.0);
    
    var card = current_prize;
    
    // ===== РАМКА ОКНА =====
    draw_set_color(card.color);
    draw_rectangle(prize_window_x, prize_window_y,
                   prize_window_x + prize_window_width,
                   prize_window_y + prize_window_height, false);
    
    // ===== ФОН ОКНА =====
    draw_set_color(make_color_rgb(50, 50, 70));
    draw_rectangle(prize_window_x + 2, prize_window_y + 2,
                   prize_window_x + prize_window_width - 2,
                   prize_window_y + prize_window_height - 2, false);
    
    // ===== ЗАГОЛОВОК =====
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_font(fnt_m);
    draw_text(prize_window_x + prize_window_width/2, prize_window_y + 30, "ВАШ ПРИЗ!");
    
    // ===== ИЗОБРАЖЕНИЕ ПРИЗА =====
    var prize_center_x = prize_window_x + prize_window_width/2;
    var prize_center_y = prize_window_y + 150;
    
    if (card.type == "hero") {
        // Герой
        if (sprite_exists(card.sprite) && card.sprite != -1) {
            draw_sprite_ext(card.sprite, 0, prize_center_x, prize_center_y - 20,
                           1.0, 1.0, 0, c_white, 1.0);
        } else {
            draw_set_color(card.color);
            draw_circle(prize_center_x, prize_center_y - 20, 50, true);
        }
        
        draw_set_font(fnt_m);
        draw_text(prize_center_x, prize_center_y + 40, card.name);
        draw_set_font(fnt_level);
        draw_text(prize_center_x, prize_center_y + 70, "КАРТА ГЕРОЯ");
        
    } else if (card.type == "genes") {
        // Гены
        draw_set_color(c_yellow);
        draw_circle(prize_center_x, prize_center_y - 20, 40, false);
        draw_set_font(fnt_m);
        draw_text(prize_center_x, prize_center_y - 30, "💰");
        draw_text(prize_center_x, prize_center_y + 40, string(card.amount));
        draw_set_font(fnt_level);
        draw_text(prize_center_x, prize_center_y + 70, "ГЕНОВ");
        
    } else if (card.type == "crystals") {
        // Кристаллы
        draw_set_color(make_color_rgb(100, 200, 255));
        draw_circle(prize_center_x, prize_center_y - 20, 40, false);
        draw_set_font(fnt_m);
        draw_text(prize_center_x, prize_center_y - 30, "💎");
        draw_text(prize_center_x, prize_center_y + 40, string(card.amount));
        draw_set_font(fnt_level);
        draw_text(prize_center_x, prize_center_y + 70, "КРИСТАЛЛОВ");
    }
    
    // ===== КНОПКА "ПОЛУЧИТЬ" =====
    var btn_color = make_color_rgb(80, 150, 255);
    
    // Проверяем наведение
    var mouse_over = (mouse_x >= prize_button_x && mouse_x <= prize_button_x + prize_button_width &&
                      mouse_y >= prize_button_y && mouse_y <= prize_button_y + prize_button_height);
    
    if (mouse_over) {
        btn_color = make_color_rgb(120, 180, 255);
    }
    
    draw_set_color(btn_color);
    draw_rectangle(prize_button_x, prize_button_y,
                   prize_button_x + prize_button_width,
                   prize_button_y + prize_button_height, false);
    
    draw_set_color(c_white);
    draw_rectangle(prize_button_x, prize_button_y,
                   prize_button_x + prize_button_width,
                   prize_button_y + prize_button_height, true);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_m);
    draw_text(prize_button_x + prize_button_width/2,
              prize_button_y + prize_button_height/2, "ПОЛУЧИТЬ");
    
    // Возвращаем настройки
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
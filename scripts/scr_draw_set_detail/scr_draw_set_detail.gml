/// @function draw_set_detail()
/// @desc Рисует карточку набора

function draw_set_detail() {
    if (set_state != SET_STATE_SHOWING || current_set == noone) return;
    
    // Затемняем фон
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, room_width, room_height, true);
    draw_set_alpha(1.0);
    
    var set = current_set;
    
    // Рамка по цвету
    draw_set_color(set.color);
    draw_rectangle(set_window_x, set_window_y,
                   set_window_x + set_window_width,
                   set_window_y + set_window_height, false);
    
    // Фон карточки
    draw_set_color(make_color_rgb(50, 50, 70));
    draw_rectangle(set_window_x + 2, set_window_y + 2,
                   set_window_x + set_window_width - 2,
                   set_window_y + set_window_height - 2, false);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // Иконка
    var sprite_x = set_window_x + set_window_width/2;
    var sprite_y = set_window_y + 120;
    
    switch (set.reward_type) {
        case "genes":
            draw_set_color(c_yellow);
            draw_circle(sprite_x, sprite_y, 40, false);
            draw_set_font(fnt_m);
            draw_text(sprite_x, sprite_y, "💰");
            break;
        case "crystals":
            draw_set_color(make_color_rgb(100, 200, 255));
            draw_circle(sprite_x, sprite_y, 40, false);
            draw_set_font(fnt_m);
            draw_text(sprite_x, sprite_y, "💎");
            break;
        case "chest":
            if (sprite_exists(spr_chest)) {
                draw_sprite_ext(spr_chest, 0, sprite_x, sprite_y, 1.0, 1.0, 0, set.color, 1.0);
            } else {
                draw_set_color(set.color);
                draw_rectangle(sprite_x - 35, sprite_y - 25, sprite_x + 35, sprite_y + 25, false);
            }
            break;
        default:
            draw_set_color(c_gray);
            draw_circle(sprite_x, sprite_y, 40, false);
    }
    
    // Название с переносом
    draw_set_color(c_white);
    draw_set_font(fnt_m);
    
    var name_y = set_window_y + 200;
    var display_name = set.name;
    
    if (string_length(set.name) > 15) {
        var space_pos = string_pos(" ", set.name);
        if (space_pos > 0) {
            var line1 = string_copy(set.name, 1, space_pos - 1);
            var line2 = string_copy(set.name, space_pos + 1, string_length(set.name));
            draw_text(sprite_x, name_y - 15, line1);
            draw_text(sprite_x, name_y, line2);
        } else {
            draw_text(sprite_x, name_y, string_copy(set.name, 1, 12) + "..");
        }
    } else {
        draw_text(sprite_x, name_y, display_name);
    }
    
    // Описание награды
    draw_set_color(c_yellow);
    draw_text(sprite_x, set_window_y + 250, "ВЫ ПОЛУЧИТЕ:");
    
    draw_set_color(c_white);
    draw_set_font(fnt_m);
    
    switch (set.reward_type) {
        case "genes":
            draw_text(sprite_x, set_window_y + 280, string(set.reward_amount) + " генов");
            break;
        case "crystals":
            draw_text(sprite_x, set_window_y + 280, string(set.reward_amount) + " кристаллов");
            break;
        case "chest":
            draw_text(sprite_x, set_window_y + 280, "Легендарный сундук");
            draw_set_font(fnt_m);
            draw_text(sprite_x, set_window_y + 310, "содержит:");
            draw_text(sprite_x, set_window_y + 340, "• 1 легендарная карта");
            draw_text(sprite_x, set_window_y + 365, "• 5 редких карт");
            draw_text(sprite_x, set_window_y + 390, "• 10 обычных карт");
            break;
    }
    
    // Цена
    draw_set_color(c_lime);
    draw_text(sprite_x, set_window_y + 440, "ЦЕНА: " + string(set.price_rub) + " ₽");
    
    // КНОПКА "КУПИТЬ"
    var btn_color = make_color_rgb(80, 150, 255);
    
    // Проверяем наведение
    var mouse_over = (mouse_x >= set_button_x && mouse_x <= set_button_x + set_button_width &&
                      mouse_y >= set_button_y && mouse_y <= set_button_y + set_button_height);
    
    if (mouse_over) {
        btn_color = make_color_rgb(120, 180, 255);
    }
    
    draw_set_color(btn_color);
    draw_rectangle(set_button_x, set_button_y,
                   set_button_x + set_button_width,
                   set_button_y + set_button_height, false);
    
    draw_set_color(c_white);
    draw_rectangle(set_button_x, set_button_y,
                   set_button_x + set_button_width,
                   set_button_y + set_button_height, true);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_m);
    draw_text(set_button_x + set_button_width/2,
              set_button_y + set_button_height/2, "КУПИТЬ");
    
    // Возвращаем настройки
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
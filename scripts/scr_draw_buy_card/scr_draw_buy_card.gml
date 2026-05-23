/// @function draw_buy_card()
/// @desc Рисует карточку покупки героя

function draw_buy_card() {
	
	
	
    if (buy_state != BUY_STATE_SHOWING || buy_card == noone) return;
    
    var card = buy_card;
    var hero = global.heroes[card.hero_id];
    
    // Затемняем фон
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, room_width, room_height, true);
    draw_set_alpha(1.0);
    
    // ===== РАМКА ПО РЕДКОСТИ =====
    draw_set_color(hero.color_frame);
    draw_rectangle(buy_window_x, buy_window_y,
                   buy_window_x + buy_window_width,
                   buy_window_y + buy_window_height, false);
    
    // ===== ФОН КАРТОЧКИ =====
    draw_set_color(make_color_rgb(50, 50, 70));
    draw_rectangle(buy_window_x + 2, buy_window_y + 2,
                   buy_window_x + buy_window_width - 2,
                   buy_window_y + buy_window_height - 2, false);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    // ===== СПРАЙТ ГЕРОЯ =====
    var sprite_x = buy_window_x + buy_window_width/2;
    var sprite_y = buy_window_y + 150;
    
    if (sprite_exists(hero.sprite_large) && hero.sprite_large != -1) {
        draw_sprite(hero.sprite_large, 0, sprite_x, sprite_y);
    } else if (sprite_exists(hero.sprite_small) && hero.sprite_small != -1) {
        draw_sprite_ext(hero.sprite_small, 0, sprite_x, sprite_y, 1.5, 1.5, 0, c_white, 1.0);
    } else {
        draw_set_color(hero.color_frame);
        draw_circle(sprite_x, sprite_y, 50, true);
        draw_set_color(c_white);
        draw_text(sprite_x, sprite_y, "?");
    }
    
    // ===== ИМЯ ГЕРОЯ =====
    draw_set_color(c_white);
    draw_set_font(fnt_m);
    draw_text(sprite_x, buy_window_y + 250, hero.name);
    
    // ===== РЕДКОСТЬ =====
    var rarity_text = "";
    switch (card.rarity) {
        case 0: rarity_text = "Обычный"; break;
        case 1: rarity_text = "Редкий"; break;
        case 2: rarity_text = "Эпический"; break;
        case 3: rarity_text = "Легендарный"; break;
    }
    draw_set_color(hero.color_frame);
    draw_set_font(fnt_level);
    draw_text(sprite_x, buy_window_y + 280, rarity_text);
    
    // ===== ЦЕНА =====
    draw_set_font(fnt_m);
    
    // Гены
    if (card.price_genes > 0) {
        draw_set_color(c_yellow);
        draw_text(sprite_x, buy_window_y + 320, string(card.price_genes) + " генов");
    }
    
    // Кристаллы
    if (card.price_crystals > 0) {
        draw_set_color(make_color_rgb(100, 200, 255));
        draw_text(sprite_x, buy_window_y + 350, string(card.price_crystals) + " кристаллов");
    }
    
    // ===== КНОПКА "КУПИТЬ" =====
    var btn_color = make_color_rgb(80, 150, 255);
    
    // Проверяем наведение
    var mouse_over = (mouse_x >= buy_button_x && mouse_x <= buy_button_x + buy_button_width &&
                      mouse_y >= buy_button_y && mouse_y <= buy_button_y + buy_button_height);
    
    if (mouse_over) {
        btn_color = make_color_rgb(120, 180, 255);
    }
    
    draw_set_color(btn_color);
    draw_rectangle(buy_button_x, buy_button_y,
                   buy_button_x + buy_button_width,
                   buy_button_y + buy_button_height, false);
    
    draw_set_color(c_white);
    draw_rectangle(buy_button_x, buy_button_y,
                   buy_button_x + buy_button_width,
                   buy_button_y + buy_button_height, true);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_m);
    draw_text(buy_button_x + buy_button_width/2,
              buy_button_y + buy_button_height/2, "КУПИТЬ");
    
    // Возвращаем настройки
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
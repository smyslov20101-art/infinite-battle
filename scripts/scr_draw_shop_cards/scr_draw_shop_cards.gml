/// @function draw_shop_cards()
/// @desc Рисует блок покупки карт в магазине

function draw_shop_cards() {
    // Заголовок
    draw_set_color(c_yellow);
    draw_set_halign(fa_center);
    draw_set_font(fnt_m);
    draw_text(room_width/2, shop_cards_y - 70 - scroll_y, shop_cards_title);

    // Таймер авто-обновления — сразу под заголовком
    draw_set_font(fnt_m);
    if (shop_refresh_current > 0) {
        draw_set_color(c_white);
        draw_text(room_width/2, shop_cards_y - 45 - scroll_y, "Авто-обновление через: " + scr_format_time(shop_refresh_current));
    } else {
        draw_set_color(c_lime);
        draw_text(room_width/2, shop_cards_y - 45 - scroll_y, "Карты обновятся при следующем входе");
    }
    
    // Центрируем карты по горизонтали
    var total_width = shop_cards_count * shop_card_width + (shop_cards_count - 1) * shop_card_spacing;
    var start_x = (room_width - total_width) / 2;
    
    // Рисуем 4 карты
    for (var i = 0; i < shop_cards_count; i++) {
        var card_x = start_x + i * (shop_card_width + shop_card_spacing);
        var card_y = shop_cards_y - scroll_y;
        
        // Проверяем, есть ли карта в этом слоте
        if (shop_cards[i] == undefined) {
            // Пустой слот (куплено)
            draw_set_color(make_color_rgb(50, 50, 70));
            draw_rectangle(card_x, card_y, card_x + shop_card_width, card_y + shop_card_height, false);
            
            draw_set_color(c_white);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_font(fnt_m);
            draw_text(card_x + shop_card_width/2, card_y + shop_card_height/2, "КУПЛЕНО");
            continue;
        }
        
        var card = shop_cards[i];
        var hero = global.heroes[card.hero_id];
        
        // Цвет рамки по редкости
        draw_set_color(hero.color_frame);
        draw_rectangle(card_x - 2, card_y - 2, card_x + shop_card_width + 2, card_y + shop_card_height + 2, false);
        
        // Фон карты
        draw_set_color(make_color_rgb(50, 50, 70));
        draw_rectangle(card_x, card_y, card_x + shop_card_width, card_y + shop_card_height, false);
        
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        
        // Спрайт героя
        if (sprite_exists(hero.sprite_small) && hero.sprite_small != -1) {
            draw_sprite_ext(hero.sprite_small, 0, card_x + shop_card_width/2, card_y + 50, 
                           0.5, 0.5, 0, c_white, 1.0);
        } else {
            draw_set_color(hero.color_frame);
            draw_circle(card_x + shop_card_width/2, card_y + 50, 30, true);
        }
        
        // Имя героя
        draw_set_color(c_white);
        draw_set_font(fnt_m);
        var short_name = string_copy(hero.name, 1, 8);
        draw_text(card_x + shop_card_width/2, card_y + 100, short_name);
        
        // ЦЕНЫ
        draw_set_font(fnt_m);
        
        // Гены
        draw_set_color(c_yellow);
        draw_text(card_x + shop_card_width/2, card_y + 120, string(card.price_genes));
        
        // Кристаллы (если есть)
        if (card.price_crystals > 0) {
            draw_set_color(make_color_rgb(100, 200, 255));
            draw_text(card_x + shop_card_width/2, card_y + 140, string(card.price_crystals) + " 💎");
        }
        
        // Редкость
        var rarity_text = "";
        switch (card.rarity) {
            case 0: rarity_text = "ОБЫЧНЫЙ"; break;
            case 1: rarity_text = "РЕДКИЙ"; break;
            case 2: rarity_text = "ЭПИЧЕСКИЙ"; break;
            case 3: rarity_text = "ЛЕГЕНДАРНЫЙ"; break;
        }
        draw_set_font(fnt_m);
        draw_set_color(hero.color_frame);
        draw_text(card_x + shop_card_width/2, card_y - 15, rarity_text);
    }
    
    // Возвращаем выравнивание
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
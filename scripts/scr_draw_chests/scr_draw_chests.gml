/// @function draw_chests()
/// @desc Рисует блок сундуков в магазине + кнопку «Обновить за рекламу» под ними.

function draw_chests() {
    var pchests = global.permanent_save.chests_data;

    // ===== ЗАГОЛОВОК + ТАЙМЕР АВТО-ОБНОВЛЕНИЯ =====
    draw_set_color(c_yellow);
    draw_set_halign(fa_center);
    draw_set_font(fnt_m);
    draw_text(room_width/2, chests_start_y - 70 - scroll_y, "СУНДУКИ");

    draw_set_color(c_white);
    if (chest_refresh_current > 0) {
        draw_text(room_width/2, chests_start_y - 45 - scroll_y, "Авто-обновление через: " + scr_format_time(chest_refresh_current));
    } else {
        draw_set_color(c_lime);
        draw_text(room_width/2, chests_start_y - 45 - scroll_y, "Сундуки обновятся при следующем входе");
    }

    // ===== ОТРИСОВКА 4 СУНДУКОВ =====
    var total_width = 4 * chest_width + 3 * chest_spacing;
    var start_x = (room_width - total_width) / 2;

    for (var i = 0; i < 4; i++) {
        var chest = chests[i];
        var chest_x = start_x + i * (chest_width + chest_spacing);
        var chest_y = chests_start_y - scroll_y;

        if (chest.bought) {
            draw_set_color(make_color_rgb(50, 50, 70));
            draw_rectangle(chest_x, chest_y, chest_x + chest_width, chest_y + chest_height, false);
            draw_set_color(c_white);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_font(fnt_m);
            draw_text(chest_x + chest_width/2, chest_y + chest_height/2, "КУПЛЕНО");
            continue;
        }

        draw_set_color(chest.color);
        draw_rectangle(chest_x - 2, chest_y - 2, chest_x + chest_width + 2, chest_y + chest_height + 2, false);

        draw_set_color(make_color_rgb(50, 50, 70));
        draw_rectangle(chest_x, chest_y, chest_x + chest_width, chest_y + chest_height, false);

        if (sprite_exists(spr_chest)) {
            draw_sprite_ext(spr_chest, 0, chest_x + chest_width/2, chest_y + 60, 0.8, 0.8, 0, chest.color, 1.0);
        }

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);

        draw_set_color(chest.color);
        draw_set_font(fnt_m);
        draw_text(chest_x + chest_width/2, chest_y - 15, chest.rarity_text);

        draw_set_color(c_yellow);
        draw_text(chest_x + chest_width/2, chest_y + 135, string(chest.price_genes));

        if (chest.price_crystals > 0) {
            draw_set_color(make_color_rgb(100, 200, 255));
            draw_text(chest_x + chest_width/2, chest_y + 155, string(chest.price_crystals) + " 💎");
        }
    }

    // ===== КНОПКА «ОБНОВИТЬ ЗА РЕКЛАМУ» ДЛЯ СУНДУКОВ =====
    var charges = pchests.ad_charges;
    var btn_x = (room_width - chest_refresh_button_width) / 2;
    var btn_y = chest_refresh_button_y - scroll_y;

    var mouse_over = (mouse_x >= btn_x && mouse_x <= btn_x + chest_refresh_button_width &&
                      mouse_y >= btn_y && mouse_y <= btn_y + chest_refresh_button_height);

    var btn_color = (charges > 0) ? make_color_rgb(255, 215, 0) : make_color_rgb(100, 100, 100);
    if (mouse_over && charges > 0) btn_color = make_color_rgb(255, 235, 100);

    draw_set_color(btn_color);
    draw_rectangle(btn_x, btn_y, btn_x + chest_refresh_button_width, btn_y + chest_refresh_button_height, false);
    draw_set_color(c_white);
    draw_rectangle(btn_x, btn_y, btn_x + chest_refresh_button_width, btn_y + chest_refresh_button_height, true);

    draw_set_font(fnt_m);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(btn_x + chest_refresh_button_width/2, btn_y + chest_refresh_button_height/2 - 10, "🔄 ОБНОВИТЬ");

    if (charges > 0) {
        draw_text(btn_x + chest_refresh_button_width/2, btn_y + chest_refresh_button_height/2 + 15,
                  "реклама " + string(charges) + "/" + string(AD_CHARGES_MAX));
    } else {
        draw_set_color(c_red);
        draw_text(btn_x + chest_refresh_button_width/2, btn_y + chest_refresh_button_height/2 + 15, "до полуночи");
        draw_set_color(c_white);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

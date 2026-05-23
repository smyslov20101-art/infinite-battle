/// @function draw_refresh_button()
/// @desc Рисует кнопку обновления карт магазина за рекламу + таймер авто-обновления над ней.

function draw_refresh_button() {
    var pcards = global.permanent_save.shop_cards_data;
    var charges = pcards.ad_charges;

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Таймер авто-обновления теперь отрисовывает draw_shop_cards() — сразу под заголовком «ПОКУПКА КАРТ».

    // ===== Кнопка «Обновить за рекламу» =====
    var button_x = (room_width - shop_refresh_button_width) / 2;
    var button_y = shop_refresh_button_y - scroll_y;

    var mouse_over = (mouse_x >= button_x && mouse_x <= button_x + shop_refresh_button_width &&
                      mouse_y >= button_y && mouse_y <= button_y + shop_refresh_button_height);

    var btn_color = (charges > 0) ? make_color_rgb(255, 215, 0) : make_color_rgb(100, 100, 100);
    if (mouse_over && charges > 0) btn_color = make_color_rgb(255, 235, 100);

    draw_set_color(btn_color);
    draw_rectangle(button_x, button_y, button_x + shop_refresh_button_width, button_y + shop_refresh_button_height, false);
    draw_set_color(c_white);
    draw_rectangle(button_x, button_y, button_x + shop_refresh_button_width, button_y + shop_refresh_button_height, true);

    draw_set_font(fnt_m);
    draw_text(button_x + shop_refresh_button_width/2, button_y + shop_refresh_button_height/2 - 10, "🔄 ОБНОВИТЬ");

    if (charges > 0) {
        draw_text(button_x + shop_refresh_button_width/2, button_y + shop_refresh_button_height/2 + 15,
                  "реклама " + string(charges) + "/" + string(AD_CHARGES_MAX));
    } else {
        draw_set_color(c_red);
        draw_text(button_x + shop_refresh_button_width/2, button_y + shop_refresh_button_height/2 + 15, "до полуночи");
        draw_set_color(c_white);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

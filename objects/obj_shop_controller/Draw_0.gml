/// Draw Event - obj_shop_controller

// 1. ФОН
draw_set_color(make_color_rgb(30, 30, 40));
draw_rectangle(0, 0, room_width, room_height, true);

// Локальные ссылки на permanent_save для удобства
var pspin   = global.permanent_save.spin_data;
var pcards  = global.permanent_save.shop_cards_data;
var pchests = global.permanent_save.chests_data;

// 3. РУЛЕТКА
draw_roulette();

// 4. КНОПКИ ПОД РУЛЕТКОЙ (СО СКРОЛЛОМ)
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// ===== КНОПКА «КРУТИТЬ» (бесплатное вращение) =====
var spin_btn_x = roulette_x + (roulette_width - spin_button_width) / 2;
var spin_btn_y = spin_button_y - scroll_y;

if (spin_cooldown_current <= 0) {
    // Доступно — синяя кнопка
    var btn_color = make_color_rgb(80, 150, 255);
    var mouse_over = (mouse_x >= spin_btn_x && mouse_x <= spin_btn_x + spin_button_width &&
                      mouse_y >= spin_btn_y && mouse_y <= spin_btn_y + spin_button_height);
    if (mouse_over) btn_color = make_color_rgb(120, 180, 255);

    draw_set_color(btn_color);
    draw_rectangle(spin_btn_x, spin_btn_y, spin_btn_x + spin_button_width, spin_btn_y + spin_button_height, false);
    draw_set_color(c_white);
    draw_rectangle(spin_btn_x, spin_btn_y, spin_btn_x + spin_button_width, spin_btn_y + spin_button_height, true);

    draw_set_font(fnt_m);
    draw_text(spin_btn_x + spin_button_width/2, spin_btn_y + spin_button_height/2, "КРУТИТЬ");
} else {
    // Перезарядка — серая кнопка с таймером H:MM:SS
    draw_set_color(make_color_rgb(100, 100, 100));
    draw_rectangle(spin_btn_x, spin_btn_y, spin_btn_x + spin_button_width, spin_btn_y + spin_button_height, false);
    draw_set_color(c_white);
    draw_rectangle(spin_btn_x, spin_btn_y, spin_btn_x + spin_button_width, spin_btn_y + spin_button_height, true);

    draw_set_font(fnt_m);
    draw_text(spin_btn_x + spin_button_width/2, spin_btn_y + spin_button_height/2 - 10, "ПЕРЕЗАРЯДКА");
    draw_text(spin_btn_x + spin_button_width/2, spin_btn_y + spin_button_height/2 + 15, scr_format_time(spin_cooldown_current));
}

// ===== КНОПКА «РЕКЛАМА» ДЛЯ РУЛЕТКИ =====
var ad_btn_x = spin_btn_x + spin_button_width + 20;
var ad_btn_y = ad_button_y - scroll_y;

var ad_charges_left = pspin.ad_charges;
var ad_btn_color = (ad_charges_left > 0) ? make_color_rgb(255, 215, 0) : make_color_rgb(100, 100, 100);

var mouse_over_ad = (mouse_x >= ad_btn_x && mouse_x <= ad_btn_x + ad_button_width &&
                     mouse_y >= ad_btn_y && mouse_y <= ad_btn_y + ad_button_height);
if (mouse_over_ad && ad_charges_left > 0) ad_btn_color = make_color_rgb(255, 235, 100);

draw_set_color(ad_btn_color);
draw_rectangle(ad_btn_x, ad_btn_y, ad_btn_x + ad_button_width, ad_btn_y + ad_button_height, false);
draw_set_color(c_white);
draw_rectangle(ad_btn_x, ad_btn_y, ad_btn_x + ad_button_width, ad_btn_y + ad_button_height, true);

draw_set_font(fnt_m);
draw_text(ad_btn_x + ad_button_width/2, ad_btn_y + ad_button_height/2 - 15, "🎬 РЕКЛАМА");

if (ad_charges_left > 0) {
    draw_text(ad_btn_x + ad_button_width/2, ad_btn_y + ad_button_height/2 + 10,
              "осталось " + string(ad_charges_left) + "/" + string(AD_CHARGES_MAX));
} else {
    draw_set_color(c_red);
    draw_text(ad_btn_x + ad_button_width/2, ad_btn_y + ad_button_height/2 + 10, "ЛИМИТ НА СЕГОДНЯ");
    draw_set_color(c_white);
}

// 5. БЛОК ПОКУПКИ КАРТ
draw_shop_cards();

// 6. КНОПКА ОБНОВЛЕНИЯ КАРТ ЗА РЕКЛАМУ
draw_refresh_button();

// 7. СУНДУКИ + кнопка их обновления (вторая отрисовка — внутри draw_chests)
draw_chests();

// 8. НАБОРЫ
draw_sets();

// 2. ШТОРКА РЕСУРСОВ СВЕРХУ
draw_set_color(make_color_rgb(40, 40, 50));
draw_rectangle(0, 0, room_width, 80, false);

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_font(fnt_m);
draw_text(50, 30, "ГЕНЫ: " + string(floor(global.genes)));
draw_text(250, 30, "КРИСТАЛЛЫ: " + string(global.crystals));

// 9. ФОН ДЛЯ НАЗВАНИЯ
var bg_y_start = 80;
var bg_y_end = roulette_y - 20;
draw_set_color(make_color_rgb(35, 35, 45));
draw_rectangle(0, bg_y_start, room_width, bg_y_end, false);
draw_set_color(make_color_rgb(60, 60, 80));
draw_line(0, bg_y_end, room_width, bg_y_end);

// 10. НАЗВАНИЕ
draw_set_color(c_yellow);
draw_set_halign(fa_center);
draw_set_font(fnt_m);
draw_text(room_width/2, 100, "МАГАЗИН");

// 11+. ПОПАПЫ ПОВЕРХ ВСЕГО
draw_set_detail();
draw_prize_window();
draw_buy_card();
draw_chest_detail();
draw_chest_rewards();

// Сброс
draw_set_halign(fa_left);
draw_set_valign(fa_top);

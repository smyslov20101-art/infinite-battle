/// Draw Event - obj_nav_button.gml

// Проверяем, активная ли эта комната
var is_active_room = (target_room == room);

if (sprite_exists(btn_sprite)) {
    // Если это активная комната — рисуем спрайт выше (выезжает вверх)
    if (is_active_room) {
        draw_sprite_ext(btn_sprite, 0, x, y - 25, 1, 1, 0, image_blend, image_alpha);
    } else {
        // Обычная кнопка — рисуем на месте
        draw_sprite_ext(btn_sprite, 0, x, y, 1, 1, 0, image_blend, image_alpha);
    }
} else {
    // Заглушка, если спрайта нет
    draw_set_color(c_red);
    draw_rectangle(x - w/2, y - h/2, x + w/2, y + h/2, false);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(x, y, "НЕТ СПРАЙТА");
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
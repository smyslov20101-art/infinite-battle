/// Draw Event - obj_fireball
depth = -1;
// Рисуем фаербол
if (sprite_exists(sprite_index)) {
    draw_self();
} else {
    // Заглушка - красный круг
    draw_set_color(c_red);
    draw_circle(x, y, 12, true);
    draw_set_color(c_orange);
    draw_circle(x, y, 8, true);
    draw_set_color(c_yellow);
    draw_circle(x, y, 4, true);
}
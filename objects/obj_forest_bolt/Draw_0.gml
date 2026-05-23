/// Draw Event - obj_forest_bolt
depth = -1;
draw_self();

// Если нет спрайта, рисуем круг
if (sprite_index == -1 || !sprite_exists(sprite_index)) {
    draw_set_color(c_green);
    draw_circle(x, y, 8, true);
    draw_set_color(c_lime);
    draw_circle(x, y, 5, true);
}
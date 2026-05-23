// Рисуем стрелу
draw_self();

// Можно добавить след
/*
draw_set_color(c_yellow);
draw_set_alpha(0.3);
for(var i = 0; i < 5; i++) {
    var trail_x = x - lengthdir_x(i * 3, direction);
    var trail_y = y - lengthdir_y(i * 3, direction);
    draw_circle(trail_x, trail_y, 2, false);
}
draw_set_alpha(1);
draw_set_color(c_white);
*/
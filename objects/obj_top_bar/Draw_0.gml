/// Draw Event - obj_top_bar

// Рисуем шторку во всю ширину экрана
var w = room_width;
var top_bar_w = sprite_get_width(spr_top_bar);
var top_bar_h = sprite_get_height(spr_top_bar);
var top_bar_y = top_bar_h / 2;

draw_sprite_ext(spr_top_bar, 0, w/2, top_bar_y, w / top_bar_w, 1, 0, c_white, 1);
/// Draw Event - obj_talent_tree_window

// Затемнение фона
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(0, 0, room_width, room_height, true);
draw_set_alpha(1.0);

// Дерево талантов рисуется на всю площадь окна (без заголовка и рамки — Маша так нарисовала)
if (hero_tree != noone) {
    var start_level = current_page * levels_per_page;
    draw_talent_tree_page(hero_tree, window_x, window_y, window_width, start_level, levels_per_page);
} else {
    draw_set_color(c_red);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_main);
    draw_text(window_x + window_width/2, window_y + window_height/2, "ДЕРЕВО ТАЛАНТОВ НЕ ЗАГРУЖЕНО");
}

// ===== КНОПКИ ПЕРЕЛИСТЫВАНИЯ СТРАНИЦ =====
// Круглые кнопки в неоновом стиле под фоном дерева
var btn_radius = 28;
var btn_y_center = next_button_y + button_height/2;

// Левая кнопка «◀»
var prev_active = (current_page > 0);
var prev_cx = prev_button_x + btn_radius;
var prev_hovered = prev_active &&
    (point_distance(mouse_x, mouse_y, prev_cx, btn_y_center) <= btn_radius);

if (prev_active) {
    draw_set_color(prev_hovered ? make_color_rgb(0x80, 0xF0, 0xFF) : make_color_rgb(0x54, 0xE2, 0xF9));
} else {
    draw_set_color(make_color_rgb(0x30, 0x60, 0x90));
}
// Двойная неоновая обводка
draw_circle(prev_cx, btn_y_center, btn_radius, true);
draw_circle(prev_cx, btn_y_center, btn_radius - 1, true);

// Стрелка влево — треугольник
draw_primitive_begin(pr_trianglelist);
draw_vertex(prev_cx - 10, btn_y_center);
draw_vertex(prev_cx + 6,  btn_y_center - 11);
draw_vertex(prev_cx + 6,  btn_y_center + 11);
draw_primitive_end();

// Правая кнопка «▶»
var next_active = (current_page < total_pages - 1);
var next_cx = next_button_x + btn_radius;
var next_hovered = next_active &&
    (point_distance(mouse_x, mouse_y, next_cx, btn_y_center) <= btn_radius);

if (next_active) {
    draw_set_color(next_hovered ? make_color_rgb(0x80, 0xF0, 0xFF) : make_color_rgb(0x54, 0xE2, 0xF9));
} else {
    draw_set_color(make_color_rgb(0x30, 0x60, 0x90));
}
draw_circle(next_cx, btn_y_center, btn_radius, true);
draw_circle(next_cx, btn_y_center, btn_radius - 1, true);

// Стрелка вправо — треугольник
draw_primitive_begin(pr_trianglelist);
draw_vertex(next_cx + 10, btn_y_center);
draw_vertex(next_cx - 6,  btn_y_center - 11);
draw_vertex(next_cx - 6,  btn_y_center + 11);
draw_primitive_end();

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_main);

// Текст «Страница X из Y» — отдельно под фоном дерева, в полосе пагинации
draw_set_color(make_color_rgb(0xC6, 0xFB, 0xFB));
draw_set_font(fnt_level);
draw_text(window_x + window_width/2, btn_y_center + 20,
          "Страница " + string(current_page + 1) + " из " + string(total_pages));

// ===== КНОПКА ЗАКРЫТИЯ ✕ В ПРАВОМ ВЕРХНЕМ УГЛУ =====
var close_hovered = (point_distance(mouse_x, mouse_y, close_btn_cx, close_btn_cy) <= close_btn_radius);
draw_set_color(close_hovered ? make_color_rgb(0x80, 0xF0, 0xFF) : make_color_rgb(0x54, 0xE2, 0xF9));
draw_circle(close_btn_cx, close_btn_cy, close_btn_radius, true);
draw_circle(close_btn_cx, close_btn_cy, close_btn_radius - 1, true);

var x_size = 11;
draw_line_width(close_btn_cx - x_size, close_btn_cy - x_size, close_btn_cx + x_size, close_btn_cy + x_size, 3);
draw_line_width(close_btn_cx + x_size, close_btn_cy - x_size, close_btn_cx - x_size, close_btn_cy + x_size, 3);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

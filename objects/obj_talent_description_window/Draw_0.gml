/// Draw Event - obj_talent_description_window

// Ленивая загрузка фона-рамки из datafiles
if (!variable_global_exists("tt_desc_frame_loaded") || !global.tt_desc_frame_loaded) {
    global.tt_desc_frame_spr = sprite_add("talent_tree/description_frame.png", 1, false, false, 0, 0);
    global.tt_desc_frame_loaded = true;
}

var _prev_halign = draw_get_halign();
var _prev_valign = draw_get_valign();
var _prev_color = draw_get_color();
var _prev_alpha = draw_get_alpha();
var _prev_font = draw_get_font();

// Затемнение фона
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(0, 0, room_width, room_height, true);
draw_set_alpha(1.0);

// Рамка из Figma (PNG)
draw_set_color(c_white);
draw_sprite_stretched(global.tt_desc_frame_spr, 0, window_x, window_y, window_width, window_height);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Заголовок (название таланта) — бирюзовый акцент Маши
draw_set_color(make_color_rgb(0x54, 0xE2, 0xF9));
draw_set_font(fnt_m);
draw_text(window_x + window_width/2, window_y + 50, talent_name);

// Описание — светло-бирюзовый
draw_set_color(make_color_rgb(0xC6, 0xFB, 0xFB));
draw_set_font(fnt_m);

var desc_lines = string_split_into_lines(talent_description, 520);
var line_height = 24;
var desc_start_y = window_y + 130;

for (var l = 0; l < array_length(desc_lines); l++) {
    draw_text(window_x + window_width/2, desc_start_y + l * line_height, desc_lines[l]);
}

// ===== КНОПКА «ЗАКРЫТЬ» — кружок ✕ в неоновом стиле =====
button_width = 56;
button_height = 56;
button_x = window_x + (window_width - button_width) / 2;
button_y = window_y + window_height - 75;

var btn_radius = 28;
var btn_cx = button_x + btn_radius;
var btn_cy = button_y + btn_radius;
var mouse_over = (point_distance(mouse_x, mouse_y, btn_cx, btn_cy) <= btn_radius);

draw_set_color(mouse_over ? make_color_rgb(0x80, 0xF0, 0xFF) : make_color_rgb(0x54, 0xE2, 0xF9));
draw_circle(btn_cx, btn_cy, btn_radius, true);
draw_circle(btn_cx, btn_cy, btn_radius - 1, true);

// Крестик ✕ — две диагональные линии (примитивами, чтобы не зависеть от шрифта)
var x_size = 11;
draw_line_width(btn_cx - x_size, btn_cy - x_size, btn_cx + x_size, btn_cy + x_size, 3);
draw_line_width(btn_cx + x_size, btn_cy - x_size, btn_cx - x_size, btn_cy + x_size, 3);

draw_set_halign(_prev_halign);
draw_set_valign(_prev_valign);
draw_set_color(_prev_color);
draw_set_alpha(_prev_alpha);
draw_set_font(_prev_font);

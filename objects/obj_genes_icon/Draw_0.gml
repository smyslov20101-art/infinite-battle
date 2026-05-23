/// Draw Event - obj_genes_icon

// Рисуем спрайт ДНК (гены)
draw_self();

// Рисуем количество генов
draw_set_color(c_white);
draw_set_font(fnt_m);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_text(x + text_offset_x, y + text_offset_y, string(floor(global.genes)));
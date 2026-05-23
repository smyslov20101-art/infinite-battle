/// Draw Event - obj_hero_ghost

// Рисуем призрака ПОВЕРХ всего
if (sprite_exists(sprite_index)) {
    // Сохраняем текущую альфу
    var prev_alpha = draw_get_alpha();
    
    // Устанавливаем прозрачность
    draw_set_alpha(image_alpha);
    
    // Рисуем спрайт
    draw_self();
    
    // Возвращаем альфу
    draw_set_alpha(prev_alpha);
} else {
    // Заглушка если нет спрайта
    draw_set_color(c_white);
    draw_set_alpha(image_alpha);
    draw_circle(x, y, 20, true);
    draw_set_alpha(1.0);
}

// Добавляем эффект свечения для видимости
draw_set_color(c_white);
draw_set_alpha(0.2 + 0.2 * sin(current_time * 0.01));
draw_circle(x, y, 25, false);
draw_set_alpha(1.0);
/// Create Event - obj_nav_button.gml

// Данные от создателя
btn_sprite = noone;      // Спрайт кнопки (устанавливается nav_creator)
target_room = noone;     // Целевая комната

// Размеры кнопки (под спрайт)
w = 160;
h = 190;

// Для эффекта наведения
is_hovered = false;
normal_alpha = 1;
hover_alpha = 0.8;

// Глубина — поверх всего!
depth = -10;
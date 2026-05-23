/// Step Event - obj_nav_button.gml

// Проверяем, активная ли эта комната
var is_active_room = (target_room == room);

// Границы кнопки (для проверки кликов)
var left = x - w/2;
var right = x + w/2;
var top = y - h/2;
var bottom = y + h/2;

// Проверяем наведение мыши (только для кликов, без визуальных эффектов)
is_hovered = (mouse_x >= left && mouse_x <= right && 
              mouse_y >= top && mouse_y <= bottom);

// Если это НЕ активная комната
if (!is_active_room) {
    // Если мышь наведена - проверяем клик
    if (is_hovered && mouse_check_button_pressed(mb_left)) {
        LOG("Навигация: " + string(target_room));
        room_goto(target_room);
    }
}

// Активная комната — не обрабатываем клики (уже в этой комнате)
// Визуальный эффект (выезжание вверх) будет в Draw Event
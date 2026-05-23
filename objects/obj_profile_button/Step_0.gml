/// Step Event - obj_profile_button

// Проверяем наведение мыши на кнопку (по спрайту)
var left = x - sprite_width/2;
var right = x + sprite_width/2;
var top = y - sprite_height/2;
var bottom = y + sprite_height/2;

is_hovered = (mouse_x >= left && mouse_x <= right && 
              mouse_y >= top && mouse_y <= bottom);

// Эффект при наведении — увеличиваем размер
if (is_hovered) {
    image_xscale = 1.1;
    image_yscale = 1.1;
} else {
    image_xscale = 1;
    image_yscale = 1;
}

// Клик по кнопке — переходим в комнату профиля
if (is_hovered && mouse_check_button_pressed(mb_left)) {
    LOG("=== ПЕРЕХОД В ПРОФИЛЬ ===");
    room_goto(room_profile);
}
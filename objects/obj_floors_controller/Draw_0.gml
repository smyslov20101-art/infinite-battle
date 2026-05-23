/// Draw Event - obj_floors_controller

// ===== 1. ФОН УБРАН — рисуется в комнате =====

// ===== 2. ШТОРКА РЕСУРСОВ =====
draw_set_color(make_color_rgb(40, 40, 50));
draw_rectangle(0, 0, room_width, 80, false);

draw_set_color(c_white);
draw_set_font(fnt_m);
draw_set_halign(fa_left);
draw_text(50, 30, "ГЕНЫ: " + string(floor(global.genes)));
draw_text(250, 30, "КРИСТАЛЛЫ: " + string(global.crystals));

// ===== 3. РИСУЕМ 3 СПРАЙТА СОБЫТИЙ =====
// Список спрайтов для событий
var event_sprites = [spr_event1, spr_event2, spr_event3];

// Параметры отрисовки
var start_y = 120;           // Начальная Y позиция (подняли выше, так как убрали заголовок)
var spacing = 30;            // Расстояние между спрайтами
var bottom_padding = 200;    // Дополнительное пустое место под последним спрайтом (чтобы можно было проскроллить)

for (var i = 0; i < 3; i++) {
    var event_sprite = event_sprites[i];
    
    if (!sprite_exists(event_sprite)) continue;
    
    // Вычисляем позицию для каждого спрайта
    var sprite_h = sprite_get_height(event_sprite);
    var card_y = start_y + i * (sprite_h + spacing) - scroll_y;
    
    // Проверяем видимость
    if (card_y + sprite_h < 0 || card_y > room_height) {
        continue;
    }
    
    // Центрируем спрайт по горизонтали
    var sprite_w = sprite_get_width(event_sprite);
    var card_x = (room_width - sprite_w) / 2;
    
    // Рисуем спрайт
    draw_sprite_ext(event_sprite, 0, card_x + sprite_w/2, card_y + sprite_h/2, 1, 1, 0, c_white, 1);
}

// ===== 4. ИНФОРМАЦИЯ О СКРОЛЛЕ =====
if (scroll_max > 0) {
    draw_set_color(make_color_rgb(100, 100, 120));
    draw_set_halign(fa_right);
    draw_text(room_width - 50, room_height - 50, 
              "Страница " + string(floor(scroll_y / 300) + 1) + 
              " из " + string(ceil(3 * 300 / 300)));
}

// Возвращаем настройки
draw_set_halign(fa_left);
draw_set_valign(fa_top);
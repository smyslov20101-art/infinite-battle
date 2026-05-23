// Рисуем спрайт героя
draw_self();

// ===== ИНТЕРФЕЙС НАД ГЕРОЕМ =====
draw_set_halign(fa_center);

// 1. КРУЖОК С УРОВНЕМ (САМЫЙ ВЕРХ)
var level_circle_y = y - 80;
var circle_radius = 20;

// Рисуем кружок с цветом уровня
draw_set_color(c_white);
draw_circle(x, level_circle_y, circle_radius, true);

// Обводка кружка
draw_set_color(c_gray);
draw_circle(x, level_circle_y, circle_radius, false);

// Цифра уровня внутри кружка
draw_set_color(c_white);
draw_set_font(fnt_level);
draw_text(x, level_circle_y-10 , string(hero_level));
draw_set_font(fnt_m);

// 2. ПОКАЗАТЕЛИ С ИКОНКАМИ (ПОД КРУЖКОМ)
var stats_y = y - 40;

// Общий фон для статистики
//draw_set_color(make_color_rgb(40, 40, 60));
//draw_rectangle(x - 70, stats_y - 20, x + 60, stats_y + 8, false);

var heart_x = x - 35;  // Ближе к центру
draw_sprite(spr_heart, 0, heart_x, stats_y-5);
draw_text(heart_x + 18, stats_y - 18, string(floor(hp)));  // Текст вплотную


// ИКОНКА МЕЧА
var sword_x = x + 15;  // Чуть правее центра
draw_sprite(spr_sword, 0, sword_x, stats_y-5);
draw_text(sword_x + 18, stats_y - 18, string(floor(damage)));  // Текст вплотную

// ===== НОВОЕ: Отображение брони (если есть) =====
if (armor > 0) {
    var armor_y = y - 20;  // Под уроном и HP
    var armor_x = x;
    
    // Иконка щита
    if (sprite_exists(spr_shield)) {
        draw_sprite(spr_shield, 0, armor_x - 15, armor_y);
    } else {
        draw_set_color(c_gray);
        draw_text(armor_x - 15, armor_y, "🛡️");
    }
    
    // Значение брони
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text(armor_x - 3, armor_y, string(armor));
    draw_set_halign(fa_center);
}

//alarm[0]
image_blend = c_white;
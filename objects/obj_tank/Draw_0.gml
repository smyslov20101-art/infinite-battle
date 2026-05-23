/// Draw Event - obj_tank

// Рисуем спрайт героя
draw_self();

if (sprite_exists(spr_shield_icon)) {
    draw_set_color(c_green);
    draw_text(x - 50, y - 120, "Щит: spr_shield_icon найден");
} else {
    draw_set_color(c_red);
    draw_text(x - 50, y - 120, "Щит: spr_shield_icon НЕ НАЙДЕН!");
}

// ===== ИНТЕРФЕЙС НАД ТАНКОМ =====
draw_set_halign(fa_center);

// 1. КРУЖОК С УРОВНЕМ (САМЫЙ ВЕРХ)
var level_circle_y = y - 80;
var circle_radius = 20;

draw_set_color(c_white);
draw_circle(x, level_circle_y, circle_radius, true);
draw_set_color(c_gray);
draw_circle(x, level_circle_y, circle_radius, false);
draw_set_color(c_white);
draw_set_font(fnt_level);
draw_text(x, level_circle_y - 10, string(hero_level));
draw_set_font(fnt_m);

// 2. ПОКАЗАТЕЛИ
var stats_y = y - 40;

// ИКОНКА СЕРДЦА (HP) - слева
var heart_x = x - 45;
if (sprite_exists(spr_heart)) {
    draw_sprite(spr_heart, 0, heart_x, stats_y - 5);
} else {
    draw_set_color(c_red);
    draw_text(heart_x - 5, stats_y - 20, "❤");
}
draw_set_color(c_white);
draw_text(heart_x + 30, stats_y - 18, string(floor(hp)));

// ===== ИКОНКА ЩИТА (SHIELD) - справа (ИСПОЛЬЗУЕМ spr_shield_icon) =====
var shield_x = x + 13;

if (sprite_exists(spr_shield_icon)) {
    draw_sprite(spr_shield_icon, 0, shield_x, stats_y - 5);
} else {
    // Если нет спрайта, рисуем текстовую иконку
    draw_set_color(c_teal);
    draw_text(shield_x - 5, stats_y - 10, "🛡️");
}

// Текст щита рядом с иконкой
draw_set_color(c_white);
draw_text(shield_x + 20, stats_y - 18, string(shield));

// ===== ДОПОЛНИТЕЛЬНО: ОТОБРАЖЕНИЕ БРОНИ (ИСПОЛЬЗУЕМ spr_shield) =====
if (armor > 0) {
    var armor_y = y - 20;  // Под щитом и HP
    var armor_x = x;
    
    // Иконка брони (spr_shield)
    if (sprite_exists(spr_shield)) {
        draw_sprite(spr_shield, 0, armor_x - 15, armor_y);
    } else {
        draw_set_color(c_gray);
        draw_text(armor_x - 15, armor_y, "🔧");
    }
    
    // Значение брони
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text(armor_x - 3, armor_y, string(armor));
    draw_set_halign(fa_center);
}

draw_set_halign(fa_left);
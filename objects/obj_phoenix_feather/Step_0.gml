/// Step Event - obj_phoenix_feather

// Проверяем существование цели
if (!instance_exists(target_hero) || target_hero.hp <= 0) {
    instance_destroy();
    exit;
}

// Проверяем, жив ли герой
if (target_hero.state == target_hero.STATE_DEAD || target_hero.hp <= 0) {
    instance_destroy();
    exit;
}

// Двигаемся к герою (простая логика без внешней функции)
var dx = target_hero.x - x;
var dy = target_hero.y - y;
var dist = sqrt(dx*dx + dy*dy);

if (dist > 0) {
    var step = min(10, dist);
    x += (dx / dist) * step;
    y += (dy / dist) * step;
}

// Проверяем, достигли ли цели
if (point_distance(x, y, target_hero.x, target_hero.y) < 20) {
    // Получаем количество убитых врагов героем
    var kills = 0;
    if (variable_instance_exists(target_hero, "enemies_killed")) {
        kills = target_hero.enemies_killed;
    }
    
    var bonus = attack_speed_bonus * kills;
    
    if (bonus > 0) {
        // Сохраняем оригинальную скорость атаки если ещё не сохранили
        if (!variable_instance_exists(target_hero, "original_attack_speed_phoenix")) {
            target_hero.original_attack_speed_phoenix = target_hero.attack_speed;
        }
        
        // Применяем бафф
        if (!variable_instance_exists(target_hero, "attack_speed_bonus")) {
            target_hero.attack_speed_bonus = 0;
        }
        target_hero.attack_speed_bonus += bonus;
        
        // Устанавливаем таймер баффа
        if (!variable_instance_exists(target_hero, "attack_speed_bonus_timer")) {
            target_hero.attack_speed_bonus_timer = 0;
        }
        target_hero.attack_speed_bonus_timer = duration;
        target_hero.attack_speed_bonus_value = bonus;
        
        // Пересчитываем скорость атаки
        target_hero.attack_speed = target_hero.original_attack_speed_phoenix * (1 + target_hero.attack_speed_bonus / 100);
        
        LOG("🪶 ФЕНИКС! Герой +" + string(bonus) + "% скор. атаки на " + string(duration) + " сек (убийств: " + string(kills) + ")");
    }
    
    instance_destroy();
    exit;
}

// Проверка выхода за границы
if (x < -500 || x > room_width + 500 || y < -500 || y > room_height + 500) {
    instance_destroy();
}
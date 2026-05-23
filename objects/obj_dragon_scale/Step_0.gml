/// Step Event - obj_dragon_scale

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

// Двигаемся к герою (простая логика)
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
    // Получаем контроллер для минут игры
    var controller = instance_find(obj_game_controller, 0);
    var minutes_played = 1; // Минимум 1 минута, чтобы бафф был не 0
    if (instance_exists(controller)) {
        minutes_played = max(1, floor(controller.game_time / 60));
    }
    
    var bonus = damage_bonus_percent * minutes_played;
    
    if (bonus > 0) {
        // Сохраняем оригинальный урон если ещё не сохранили
        if (!variable_instance_exists(target_hero, "original_damage_dragon")) {
            target_hero.original_damage_dragon = target_hero.damage;
        }
        
        // Применяем бафф
        if (!variable_instance_exists(target_hero, "damage_bonus")) {
            target_hero.damage_bonus = 0;
        }
        target_hero.damage_bonus += bonus;
        
        // Устанавливаем таймер баффа
        if (!variable_instance_exists(target_hero, "damage_bonus_timer")) {
            target_hero.damage_bonus_timer = 0;
        }
        target_hero.damage_bonus_timer = duration;
        target_hero.damage_bonus_value = bonus;
        
        // Пересчитываем урон
        target_hero.damage = target_hero.original_damage_dragon * (1 + target_hero.damage_bonus / 100);
        
        LOG("🐉 ДРАКОН! Герой +" + string(bonus) + "% урона на " + string(duration) + " сек (минут: " + string(minutes_played) + ")");
    }
    
    instance_destroy();
    exit;
}

// Проверка выхода за границы
if (x < -500 || x > room_width + 500 || y < -500 || y > room_height + 500) {
    instance_destroy();
}
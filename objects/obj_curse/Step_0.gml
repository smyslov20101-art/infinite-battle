/// Step Event - obj_curse

// Если уже наложили проклятье на врагов - выходим
if (enemies_hit > 0) {
    exit;
}

// Собираем ближайших врагов
var targets = [];
with (obj_enemy_base) {
    if (alive && hp > 0) {
        var dist = point_distance(x, y, other.x, other.y);
        array_push(targets, {id: id, dist: dist});
    }
}

// Также проверяем тестовых манекенов
with (obj_test_dummy) {
    if (hp > 0) {
        var dist = point_distance(x, y, other.x, other.y);
        array_push(targets, {id: id, dist: dist});
    }
}
with (obj_test_dummy_back) {
    if (hp > 0) {
        var dist = point_distance(x, y, other.x, other.y);
        array_push(targets, {id: id, dist: dist});
    }
}

// Сортируем по расстоянию (ближайшие первые)
for (var i = 0; i < array_length(targets) - 1; i++) {
    for (var j = i + 1; j < array_length(targets); j++) {
        if (targets[i].dist > targets[j].dist) {
            var temp = targets[i];
            targets[i] = targets[j];
            targets[j] = temp;
        }
    }
}

// Накладываем проклятье на max_targets ближайших врагов
var count = min(max_targets, array_length(targets));
for (var i = 0; i < count; i++) {
    var enemy = targets[i].id;
    if (instance_exists(enemy)) {
        // Инициализируем переменные проклятья на враге
        if (!variable_instance_exists(enemy, "curse_timer")) {
            enemy.curse_timer = 0;
            enemy.curse_damage_mult = 1.0;
        }
        enemy.curse_timer = duration;
        enemy.curse_damage_mult = 1 + (damage_mult / 100);
        enemies_hit++;
        LOG("👁️ ПРОКЛЯТЬЕ! Враг получает +" + string(damage_mult) + "% урона на " + string(duration) + " сек");
    }
}

// Если не нашли ни одного врага, всё равно уничтожаемся через таймер
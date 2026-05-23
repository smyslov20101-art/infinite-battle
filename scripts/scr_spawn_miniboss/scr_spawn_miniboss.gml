/// @function spawn_miniboss()
/// @desc Спавнит мини-босса с остановкой спавна обычных врагов

function spawn_miniboss() {
    // 1. Проверяем не активирован ли уже босс
    var controller = instance_find(obj_game_controller, 0);
    if (!instance_exists(controller)) {
        LOG("Ошибка: контроллер не найден!");
        return noone;
    }
    
    if (controller.boss_active) {
        LOG("Нельзя спавнить мини-босса: уже есть активный босс!");
        return noone;
    }
    
    // 2. Проверяем лимит врагов
    if (controller.current_enemies_on_field >= controller.max_enemies_on_field) {
        LOG("Лимит врагов достигнут, не могу спавнить мини-босса");
        return noone;
    }
    
    // 3. Позиция спавна (справа за экраном)
    var boss_x = room_width + 150;
    var boss_y = 600;
    
    // 4. Создаем мини-босса
    var miniboss = instance_create_layer(boss_x, boss_y, "Instances", obj_miniboss);
    
    if (!instance_exists(miniboss)) {
        LOG("Ошибка: не удалось создать мини-босса!");
        return noone;
    }
    
    // 5. Инициализируем мини-босса
    miniboss_init(miniboss);
    
    // 6. Настраиваем характеристики
    var boss_number = 1;
    if (variable_instance_exists(controller, "miniboss_spawn_count")) {
        boss_number = controller.miniboss_spawn_count + 1;
    }
    
    var boss_multiplier = 1 + ((boss_number - 1) * 0.5);
    
    with (miniboss) {
        hp = 1000 * boss_multiplier;
        max_hp = hp;
        damage = 40 * boss_multiplier;
        reward = 200 * boss_multiplier;
        
        move_speed = 1.5 - ((boss_number - 1) * 0.1);
        move_speed = max(0.8, move_speed);
    }
    
    // 7. ВАЖНО: Сохраняем текущие настройки спавна перед изменением
    controller.saved_spawn_interval = controller.enemy_spawn_interval;
    controller.saved_spawn_timer = controller.enemy_spawn_timer;
    
    // 8. Устанавливаем флаги босса
    controller.boss_active = true;
    controller.pause_spawn_on_boss = true;
    
    // 9. Останавливаем спавн обычных врагов (НО СОХРАНЯЕМ ИНТЕРВАЛ)
    controller.enemy_spawn_interval = 9999;
    controller.enemy_spawn_timer = 9999;
    
    // 10. Увеличиваем счетчики
    controller.current_enemies_on_field++;
    
    if (!variable_instance_exists(controller, "miniboss_spawn_count")) {
        controller.miniboss_spawn_count = 1;
    } else {
        controller.miniboss_spawn_count++;
    }
    
    LOG("========================================");
    LOG("=== ПОЯВИЛСЯ МИНИ-БОСС №" + string(boss_number) + "! ===");
    LOG("Сохраненный интервал спавна: " + string(controller.saved_spawn_interval));
    LOG("========================================");
    
    return miniboss;
}
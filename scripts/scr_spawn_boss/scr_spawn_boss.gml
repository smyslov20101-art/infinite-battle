/// @function spawn_boss()
/// @desc Спавнит босса с учетом сложности
/// @return {instance} Созданный босс или noone

function spawn_boss() {
    LOG("=== ПОПЫТКА СПАВНА БОССА ===");
    
    // Получаем контроллер
    var controller = instance_find(obj_game_controller, 0);
    if (!instance_exists(controller)) {
        LOG("Ошибка: контроллер не найден!");
        return noone;
    }
    
    // Проверяем, не активен ли уже босс
    if (controller.boss_active) {
        LOG("Босс уже активен, не спавним нового");
        return noone;
    }
    
    // Проверяем лимит врагов
    if (controller.current_enemies_on_field >= controller.max_enemies_on_field) {
        LOG("Лимит врагов достигнут, не могу спавнить босса");
        return noone;
    }
    
    // Позиция спавна (справа за экраном)
    var boss_x = room_width + 200;
    var boss_y = 600;
    
    // Создаем босса
    var boss = instance_create_layer(boss_x, boss_y, "Instances", obj_boss);
    
    if (!instance_exists(boss)) {
        LOG("Ошибка: не удалось создать босса!");
        return noone;
    }
    
    // Инициализируем босса
    boss_init(boss);
    
    // Настраиваем характеристики в зависимости от сложности и номера появления
    // УМЕНЬШАЕМ МНОЖИТЕЛИ
    
    // Множитель сложности: +5% за уровень вместо +20%
    var difficulty_multiplier = 1 + (controller.difficulty_level * 0.05);
    
    // Номер босса (сколько раз уже появлялся)
    if (!variable_instance_exists(controller, "boss_spawn_count")) {
        controller.boss_spawn_count = 1;
    } else {
        controller.boss_spawn_count++;
    }
    
    var boss_number = controller.boss_spawn_count;
    // Множитель номера: +10% за каждого следующего босса вместо +50%
    var boss_multiplier = 1 + ((boss_number - 1) * 0.1);
    
    with (boss) {
        // Итоговые характеристики
        hp = base_hp * difficulty_multiplier * boss_multiplier;
        max_hp = hp;
        damage = base_damage * difficulty_multiplier * boss_multiplier;
        reward = base_reward * difficulty_multiplier * boss_multiplier;
        
        // Округляем до целых чисел
        hp = floor(hp);
        max_hp = floor(max_hp);
        damage = floor(damage);
        reward = floor(reward);
        
        // Скорость немного уменьшается с каждым боссом
        move_speed = 0.8 - ((boss_number - 1) * 0.02);
        move_speed = max(0.5, move_speed); // Не медленнее 0.5
        
        LOG("--- ХАРАКТЕРИСТИКИ БОССА №" + string(boss_number) + " ---");
        LOG("Уровень сложности: " + string(controller.difficulty_level));
        LOG("Множитель сложности: " + string_format(difficulty_multiplier, 1, 2));
        LOG("Множитель босса: " + string_format(boss_multiplier, 1, 2));
        LOG("Итоговый множитель: " + string_format(difficulty_multiplier * boss_multiplier, 1, 2));
        LOG("HP: " + string(hp));
        LOG("Урон: " + string(damage));
        LOG("Награда: " + string(reward));
    }
    
    // Устанавливаем флаг активного босса
    controller.boss_active = true;
    controller.pause_spawn_on_boss = true;
    
    // Увеличиваем счетчик врагов
    controller.current_enemies_on_field++;
    
    // Сообщение игроку
    LOG("========================================");
    LOG("!!! ВНИМАНИЕ! ПОЯВИЛСЯ БОСС №" + string(boss_number) + " !!!");
    LOG("========================================");
    
    return boss;
}
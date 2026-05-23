/// @function spawn_enemy()
/// @desc Создает врага с применением множителя сложности ТОЛЬКО к hp, damage и reward
/// @return {instance} Созданный враг или noone

function spawn_enemy() {
    // Получаем контроллер
    var controller = instance_find(obj_game_controller, 0);
    if (!instance_exists(controller)) {
        LOG("Ошибка: контроллер не найден!");
        return noone;
    }
    
    // Проверяем лимит врагов
    if (controller.current_enemies_on_field >= controller.max_enemies_on_field) {
        return noone;
    }
    
    var spawn_archer = (controller.difficulty_level >= 2 && random(1) < 0.5);
    var enemy_x = room_width + 100;
    var enemy_y = 600;
    var enemy = noone;
    
    // Множитель сложности (10% за уровень)
    var difficulty_multiplier = 1 + (controller.difficulty_level * 0.1);
    
    if (spawn_archer) {
        enemy = instance_create_layer(enemy_x, enemy_y, "Instances", obj_enemy_archer);
        if (instance_exists(enemy)) {
            // Инициализация с БАЗОВЫМИ значениями
            scr_enemy_archer_init(enemy);
            
            with (enemy) {
                // СОХРАНЯЕМ базовое значение монет для отладки
                var base_coin = coin_reward;
                
                // Применяем множитель ТОЛЬКО к тому, что должно расти со сложностью
                hp = floor(hp * difficulty_multiplier);
                max_hp = hp;
                damage = floor(damage * difficulty_multiplier);
                reward = floor(reward * difficulty_multiplier);
                
                // ===== ИЗМЕНЕНО: МОНЕТЫ ТЕПЕРЬ 5 ДЛЯ ЛУЧНИКА =====
                coin_reward = 5; // Было 2
                
                LOG("Создан лучник: базовые монеты=" + string(base_coin) + 
                                  ", итоговые монеты=" + string(coin_reward) + 
                                  " (теперь 5)");
            }
        }
    } else {
        enemy = instance_create_layer(enemy_x, enemy_y, "Instances", obj_enemy);
        if (instance_exists(enemy)) {
            // Инициализация с БАЗОВЫМИ значениями
            enemy_init(enemy);
            
            with (enemy) {
                // СОХРАНЯЕМ базовое значение монет для отладки
                var base_coin = coin_reward;
                
                // Применяем множитель ТОЛЬКО к тому, что должно расти со сложностью
                hp = floor(hp * difficulty_multiplier);
                max_hp = hp;
                damage = floor(damage * difficulty_multiplier);
                reward = floor(reward * difficulty_multiplier);
                
                // ===== ИЗМЕНЕНО: МОНЕТЫ ТЕПЕРЬ 5 ДЛЯ ОБЫЧНОГО ВРАГА =====
                coin_reward = 5; // Было 1
                
                LOG("Создан враг: базовые монеты=" + string(base_coin) + 
                                  ", итоговые монеты=" + string(coin_reward) + 
                                  " (теперь 5)");
            }
        }
    }
    
    if (instance_exists(enemy)) {
        controller.current_enemies_on_field++;
        LOG("Создан враг: HP=" + string(enemy.hp) + 
                          ", Награда=" + string(enemy.reward) + 
                          ", Монеты=" + string(enemy.coin_reward) +
                          ", Тип=" + enemy.enemy_type);
    }
    
    return enemy;
}
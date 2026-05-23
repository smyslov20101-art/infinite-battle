// Step Event - obj_enemy
// Step Event - obj_enemy (В САМОМ НАЧАЛЕ)
if (!variable_instance_exists(id, "debug_timer")) {
    debug_timer = 0;
}
debug_timer -= 1;
if (debug_timer <= 0) {
    LOG("Step врага ID=" + string(id) + ": coin_reward=" + string(coin_reward));
    debug_timer = 60; // Показывать раз в секунду
}
// Получаем контроллер для проверки состояния игры
var controller = instance_find(obj_game_controller, 0);

// ЕСЛИ ИГРА НА ПАУЗЕ ИЛИ ОКОНЧЕНА - НИЧЕГО НЕ ДЕЛАЕМ
if (instance_exists(controller)) {
    if (controller.controller_state == controller.CONTROLLER_STATE_PAUSE || 
        controller.game_over) {
        exit;
    }
}

// Проверяем, первый ли это Step для этого врага
if (!variable_instance_exists(id, "first_step_done")) {
    first_step_done = true;
    LOG("!!! ПЕРВЫЙ STEP врага ID=" + string(id) + 
                      ", coin_reward=" + string(coin_reward) + 
                      ", hp=" + string(hp));
}


// Проверяем жив ли враг
if (!alive) exit;

// Обновляем таймеры
if (damage_cooldown > 0) damage_cooldown -= 1 / room_speed;

// Обрабатываем состояние
switch (state) {
    case ENEMY_STATE_MOVING:
        enemy_state_moving(id);
        break;
        
    case ENEMY_STATE_ATTACKING:
        enemy_state_attacking(id);
        break;
        
    case ENEMY_STATE_DEAD:
        break;
}
// Step Event - obj_boss

// Получаем контроллер для проверки состояния игры
var controller = instance_find(obj_game_controller, 0);

// Если игра на паузе или окончена - босс замирает
if (instance_exists(controller)) {
    if (controller.controller_state == controller.CONTROLLER_STATE_PAUSE || 
        controller.game_over) {
        exit;
    }
}

// Проверяем жив ли босс
if (!alive) exit;

// Обновляем таймеры
if (damage_cooldown > 0) damage_cooldown -= 1 / room_speed;
attack_timer -= 1 / room_speed;

// Обрабатываем состояние
switch (state) {
    case ENEMY_STATE_MOVING:
        boss_state_moving(id);
        break;
        
    case ENEMY_STATE_ATTACKING:
        boss_state_attacking(id);
        break;
        
    case ENEMY_STATE_DEAD:
        break;
}
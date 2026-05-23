// Step Event - obj_miniboss

// Получаем контроллер для проверки состояния игры
var controller = instance_find(obj_game_controller, 0);

// ЕСЛИ ИГРА НА ПАУЗЕ ИЛИ ОКОНЧЕНА - НИЧЕГО НЕ ДЕЛАЕМ
if (instance_exists(controller)) {
    if (controller.controller_state == controller.CONTROLLER_STATE_PAUSE || 
        controller.game_over) {
        exit;
    }
}

// Проверяем жив ли мини-босс
if (!alive) exit;

// Обновляем таймеры
if (damage_cooldown > 0) damage_cooldown -= 1 / room_speed;
attack_timer -= 1 / room_speed;

// Обрабатываем состояние
switch (state) {
    case ENEMY_STATE_MOVING:
        miniboss_state_moving(id);
        break;
        
    case ENEMY_STATE_ATTACKING:
        miniboss_state_attacking(id);
        break;
        
    case ENEMY_STATE_DEAD:
        break;
}
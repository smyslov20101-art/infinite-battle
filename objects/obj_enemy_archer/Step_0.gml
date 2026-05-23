// Step Event - obj_enemy_archer

// Получаем контроллер для проверки состояния игры
var controller = instance_find(obj_game_controller, 0);

// ЕСЛИ ИГРА НА ПАУЗЕ ИЛИ ОКОНЧЕНА - НИЧЕГО НЕ ДЕЛАЕМ
if (instance_exists(controller)) {
    if (controller.controller_state == controller.CONTROLLER_STATE_PAUSE || 
        controller.game_over) {
        exit;
    }
}

// Проверяем жив ли враг
if (!alive) exit;

// Обновляем таймер получения урона
if (damage_cooldown > 0) damage_cooldown -= 1 / room_speed;

// Обрабатываем текущее состояние
switch (state) {
    case ENEMY_STATE_MOVING:
        enemy_state_moving(id);
        break;
        
    case ENEMY_STATE_ATTACKING:
        enemy_state_attacking(id);
        break;
        
    case ENEMY_STATE_IDLE:
        enemy_state_idle(id);
        break;
        
    case ENEMY_STATE_DEAD:
        break;
}
/// @function check_enemy_passed()
/// @desc Проверяет, не прошел ли враг за левый край экрана
/// @return {bool} true если враг прошел

function check_enemy_passed() {
    var enemy_passed = false;
    var controller = instance_find(obj_game_controller, 0);
    
    if (!instance_exists(controller)) return false;
    
    // Проходим по всем врагам
    with (obj_enemy_base) {
        // Если враг зашел за левый край экрана
        if (x < -50) {
            enemy_passed = true;
            
            // Определяем сколько жизней отнять в зависимости от типа врага
            var damage_to_lives = 1; // По умолчанию 1
            
            if (enemy_type == "miniboss") {
                damage_to_lives = 2; // Мини-босс отнимает 2 жизни
                LOG("!!! МИНИ-БОСС прорвался! -2 жизни !!!");
                
                // ПРИНУДИТЕЛЬНО СБРАСЫВАЕМ ФЛАГИ И ТАЙМЕР
                with (controller) {
                    boss_active = false;
                    pause_spawn_on_boss = false;
                    
                    // СБРАСЫВАЕМ ТАЙМЕР СПАВНА, ЧТОБЫ ОН СРАБОТАЛ БЫСТРЕЕ
                    enemy_spawn_timer = 0.1; // Почти мгновенно
                    
                    LOG("Мини-босс прорвался - спавн возобновлен");
                    LOG("Таймер спавна сброшен до 0.1");
                    LOG("boss_active=" + string(boss_active) + 
                                      ", pause_spawn_on_boss=" + string(pause_spawn_on_boss));
                }
                
            } else if (enemy_type == "boss") {
                damage_to_lives = 3; // Босс отнимает 3 жизни
                LOG("!!! БОСС прорвался! -3 жизни !!!");
                
                // ПРИНУДИТЕЛЬНО СБРАСЫВАЕМ ФЛАГИ И ТАЙМЕР
                with (controller) {
                    boss_active = false;
                    pause_spawn_on_boss = false;
                    
                    // СБРАСЫВАЕМ ТАЙМЕР СПАВНА, ЧТОБЫ ОН СРАБОТАЛ БЫСТРЕЕ
                    enemy_spawn_timer = 0.1; // Почти мгновенно
                    
                    LOG("Босс прорвался - спавн возобновлен");
                    LOG("Таймер спавна сброшен до 0.1");
                }
                
            } else {
                LOG("Враг прорвался! -1 жизнь");
            }
            
            // Уменьшаем жизни в контроллере
            with (controller) {
                current_lives = max(0, current_lives - damage_to_lives);
                LOG("Осталось жизней: " + string(current_lives));
                
                // Проверяем не закончились ли жизни
                if (current_lives <= 0) {
    wave_genes = session_genes;  // ← ЭТО КЛЮЧЕВАЯ СТРОКА
    game_over = true;
    controller_state = CONTROLLER_STATE_GAMEOVER;
}
            }
            
            // Уничтожаем врага
            instance_destroy();
        }
    }
    
    return enemy_passed;
}
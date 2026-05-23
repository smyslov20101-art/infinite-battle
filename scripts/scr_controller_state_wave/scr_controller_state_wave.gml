/// @function scr_controller_state_wave(_controller_instance)
/// @desc Обработка состояния ВОЛНЫ (основной геймплей) - БЕЗ СТАРЫХ КНОПОК

function scr_controller_state_wave(_controller_instance) {
    if (!instance_exists(_controller_instance)) return;
    // ===== ТЕСТОВАЯ КОМНАТА: ОТКЛЮЧАЕМ СПАВН ВРАГОВ =====
if (room == room_test) {
    // В тестовой комнате нет спавна врагов
    // Все враги - только манекен
    return;
}
    with (_controller_instance) {
        // Отладка монет (каждые 100 кадров)
        if (game_time * room_speed % 100 == 0) {
            LOG("Текущие монеты: " + string(coins));
        }
        
        // ===== ЕСЛИ ЭТО РЕЖИМ ЭТАЖА - УСТАНАВЛИВАЕМ НАЧАЛЬНЫЕ ПАРАМЕТРЫ =====
        if (floor_mode && !floor_initialized) {
            // Устанавливаем время игры
            game_time = floor_start_time;
            
            floor_initialized = true;
            
            LOG("=== РЕЖИМ ЭТАЖА ===");
            LOG("Стартовое время: " + string(game_time));
            LOG("Уровень героев: " + string(floor_hero_level));
        }
        
        // ===== УБИРАЕМ ВЕСЬ БЛОК С hero_buttons =====
        // Раньше здесь был цикл for (var i = 0; i < array_length(hero_buttons); i++) 
        // Теперь обработка кликов по героям происходит в Step Event самого контроллера
        // в секции "ОБРАБОТКА КЛИКОВ ПО ЭЛЕМЕНТАМ ИНТЕРФЕЙСА"
        
        // ===== СИСТЕМА СЛОЖНОСТИ =====
        difficulty_timer += 1 / room_speed;
        if (difficulty_timer >= difficulty_interval) {
            difficulty_timer = 0;
            difficulty_level++;
            LOG("Уровень сложности повышен: " + string(difficulty_level));
        }
        
        // ===== СПАВН ВРАГОВ =====
        if (!boss_active && !game_over) {
            if (current_enemies_on_field < max_enemies_on_field) {
                enemy_spawn_timer -= 1 / room_speed;
                
                if (enemy_spawn_timer <= 0) {
                    var enemy = spawn_enemy();
                    
                    // Характеристики врага уже установлены в spawn_enemy()
                    // Ничего не делаем с enemy здесь
                    
                    enemy_spawn_timer = enemy_spawn_interval;
                    enemies_spawned++;
                }
            }
        }
        
        // ===== МИНИ-БОССЫ =====
        if (!boss_active && !game_over && miniboss_timer > 0 && game_time >= miniboss_timer) {
            var miniboss = spawn_miniboss();
            if (instance_exists(miniboss)) {
                miniboss_timer += 600;
                LOG("=== ПОЯВИЛСЯ МИНИ-БОСС! ===");
            }
        }
        
        // ===== БОССЫ =====
        if (!boss_active && !game_over && boss_timer > 0 && game_time >= boss_timer) {
            var boss = spawn_boss();
            if (instance_exists(boss)) {
                boss_timer += 600;
                LOG("=== ПОЯВИЛСЯ БОСС! ===");
            }
        }
        
        // ===== ОБНОВЛЕНИЕ СЧЕТЧИКА ТЕКУЩИХ ВРАГОВ =====
        current_enemies_on_field = instance_number(obj_enemy_base);
		
		// ===== ОБНОВЛЕНИЕ ПРОГРЕССА ЕЖЕДНЕВНЫХ ЗАДАНИЙ (ВЫЖИВАНИЕ) =====
// Обновляем раз в секунду
if (!game_over && controller_state == CONTROLLER_STATE_WAVE) {
    var prev_seconds = floor(game_time - 1/room_speed);
    var current_seconds = floor(game_time);
    if (current_seconds > prev_seconds) {
        update_quest_progress("survival", 1);
    }
}
        
        // ===== ОБРАБОТКА ПАУЗЫ ПО КЛАВИШЕ ESC =====
        if (IS_BACK_PRESSED && !game_over) {
            controller_state = CONTROLLER_STATE_PAUSE;
            LOG("Игра на паузе");
        }
    }
}
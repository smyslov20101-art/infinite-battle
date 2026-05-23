/// @function scr_game_controller_init(_controller_instance)
/// @desc Инициализация контроллера игры

function scr_game_controller_init(_controller_instance) {
    if (!instance_exists(_controller_instance)) return;
    
    with (_controller_instance) {
        // ===== СОСТОЯНИЯ КОНТРОЛЛЕРА =====
        CONTROLLER_STATE_WAVE = 0;
        CONTROLLER_STATE_PAUSE = 1;
        CONTROLLER_STATE_GAMEOVER = 2;
        
        controller_state = CONTROLLER_STATE_WAVE;
        
        // ===== ПЕРЕМЕННЫЕ ИГРЫ =====
        coins = 10;                    // Стартовые монеты
        game_time = 0;
        
        // Гены: общие (хранятся глобально) и заработанные за текущую игру
        total_genes = global.genes;
        session_genes = 0;
        display_genes = 0;
        
        // ===== СИСТЕМА ЖИЗНЕЙ =====
        max_lives = 3;
        current_lives = max_lives;
        game_over = false;
        game_over_timer = 0;
        
        // ===== СИСТЕМА СЛОЖНОСТИ =====
        difficulty_level = 1;
        difficulty_timer = 0;
        difficulty_interval = 30;
        
        // ===== ОБЩИЕ ПАРАМЕТРЫ СПАВНА =====
        spawn_x = 100;
        spawn_y = 600;
        
        // ===== КНОПКА ПАУЗЫ =====
        pause_button_x = room_width / 2 - 50;
        pause_button_y = 20;
        pause_button_width = 100;
        pause_button_height = 40;
        
        pause_button_color = make_color_rgb(100, 100, 100);
        pause_button_hover_color = make_color_rgb(150, 150, 150);
        pause_button_current_color = pause_button_color;
        pause_button_hovered = false;
        
        // ===== ВРАГИ =====
        enemy_spawn_timer = 1;
        enemy_spawn_interval = 1;
        enemy_spawn_interval_base = 1;
        enemies_spawned = 0;
        enemies_killed = 0;
        
        max_enemies_on_field = 5;
        current_enemies_on_field = 0;
        
        // ===== БОССЫ =====
        miniboss_spawn_count = 0;
        boss_spawn_count = 0;
        miniboss_timer = 50;
        boss_timer = 600;
        boss_active = false;
        pause_spawn_on_boss = false;
        
        // ===== БАЗОВЫЕ ХАРАКТЕРИСТИКИ ВРАГОВ =====
        enemy_hp_base = 50;
        enemy_damage_base = 5;
        enemy_reward_base = 5;        // Гены за убийство
        enemy_coin_base = 1;           // Монеты за убийство (НОВОЕ!)
        enemy_spawn_interval_base = 3.0;
        
        // ===== ДОПОЛНИТЕЛЬНЫЕ НАСТРОЙКИ =====
        room_speed = 60;
        
        LOG("=== КОНТРОЛЛЕР ИНИЦИАЛИЗИРОВАН ===");
        LOG("Начальные монеты: " + string(coins));
		/// scr_game_controller_init - в конце функции

// ===== ТЕСТОВАЯ КОМНАТА =====
if (room == room_test) {
    coins = 10000;
    LOG("Тестовая комната: монет = " + string(coins));
}
    }
}
/// @function scr_enemy_archer_init(_enemy_instance)
/// @desc Инициализация врага-лучника

function scr_enemy_archer_init(_enemy_instance) {
    if (!instance_exists(_enemy_instance)) return;
    
    with (_enemy_instance) {
        // ===== ОБЩИЕ ПЕРЕМЕННЫЕ =====
        alive = true;
        
        // Состояния
        ENEMY_STATE_MOVING = 0;
        ENEMY_STATE_ATTACKING = 1;
        ENEMY_STATE_DEAD = 2;
        ENEMY_STATE_IDLE = 3;
        state = ENEMY_STATE_MOVING;
        state_timer = 0;
        
        // Цели
        target_hero = noone;
        
        // Получение урона
        damage_cooldown = 0;
        damage_cooldown_max = 0.3;
        
        // Очередь
        position_in_line = 0;
        follow_target = noone;
        queue_distance = 90;
        waiting_for_clear = false;
        queue_check_timer = 0;
        queue_check_interval = 0.2;
        
        // ===== БАЗОВЫЕ ХАРАКТЕРИСТИКИ (УМЕНЬШЕНЫ) =====
        hp = 20;                    // Было 40
        max_hp = 20;                 // Было 40
        damage = 3;                  // Было 8 (пусть лучники чуть сильнее ближников)
        attack_speed = 0.7;
        attack_timer = 0;
        move_speed = 2.5;
        
        // ===== НАГРАДЫ =====
        reward = 8;                  // Гены за убийство
        coin_reward = 7;              // Монеты за убийство
        
        // ===== БОЕВЫЕ ПАРАМЕТРЫ =====
        stop_distance = 180;
        attack_range = 180;
        search_radius = 250;
        attack_cooldown_max = 1 / attack_speed;
        
        is_ranged = true;
        enemy_type = "archer";
    }
}
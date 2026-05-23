function mage_init(_mage_instance) {
    if (!instance_exists(_mage_instance)) return;
    
    with (_mage_instance) {
        // Инициализируем базовые переменные
        scr_hero_base_init(id);
        
        // ===== ХАРАКТЕРИСТИКИ МАГА =====
        hero_type = "mage";
        max_hp = 50;
        hp = max_hp;
        damage = 15;
        attack_speed = 0.33;   // Атака раз в 3 секунды
        move_speed = 2.0;
        
        // ===== ВАЖНО: Инициализируем таймер атаки =====
        attack_timer = 0;       // Чтобы атаковал сразу
        
        // ===== ПАРАМЕТРЫ ФАЕРБОЛА =====
        projectile_speed = 5;
        projectile_speed_bonus = 0;
        
        // ===== АТАКА ПО НЕСКОЛЬКИМ ЦЕЛЯМ =====
        multi_target_chance = 0;
        
        // ===== ГОРЕНИЕ =====
        burn_damage = 0;
        burn_interval = 2.0;
        
        // ===== КРИТИЧЕСКИЙ УДАР =====
        crit_chance = 0;
        crit_damage_mult = 2.0;
        
        // ===== ЦЕЛЕВАЯ ПОЗИЦИЯ =====
        target_x = 100;
        target_y = 600;
        
        // ===== БОЕВЫЕ ПАРАМЕТРЫ =====
        attack_range_moving = 250;
        attack_range_idle = 400;
        
        // ===== ВИЗУАЛ =====
        image_blend = c_white;
        
        // ===== Устанавливаем состояние IDLE =====
        state = STATE_IDLE;
    }
}
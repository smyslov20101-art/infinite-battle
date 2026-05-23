/// @function boss_init(_boss_instance)
/// @desc Инициализация босса

function boss_init(_boss_instance) {
    if (!instance_exists(_boss_instance)) return;
    
    with (_boss_instance) {
        // Вызываем базовую инициализацию врага
        enemy_init(id);
        
        // ===== ПЕРЕОПРЕДЕЛЯЕМ ХАРАКТЕРИСТИКИ ДЛЯ БОССА =====
        enemy_type = "boss";
        is_boss = true;
        is_ranged = false;
        
        // Базовые характеристики
        base_hp = 2500;
        base_damage = 80;
        base_reward = 500;      // Гены
        base_coin = 200;         // Монеты
        
        // Текущие характеристики
        hp = base_hp;
        max_hp = base_hp;
        damage = base_damage;
        reward = base_reward;
        coin_reward = base_coin;  // Монеты (ОБЯЗАТЕЛЬНО!)
        
        // Скорости
        attack_speed = 0.2;
        move_speed = 0.8;
        
        // Атака
        attack_range = 95;
        stop_distance = 80;
        search_radius = 400;
        attack_cooldown_max = 1 / attack_speed;
        attack_timer = 0;
        
        // AOE атака
        aoe_attack = true;
        aoe_targets = 3;
        aoe_radius = 200;
        
        // Очередь
        queue_distance = 90;
        position_in_line = 0;
        follow_target = noone;
        waiting_for_clear = false;
        queue_check_timer = 0;
        queue_check_interval = 0.2;
        
        // Визуал
        image_xscale = 2.5;
        image_yscale = 2.5;
        image_blend = c_red;
        
        // Полоска здоровья
        show_health_bar = true;
        health_bar_width = 300;
        health_bar_height = 20;
        health_bar_offset_y = -150;
        
        // Коррекция позиции
        y -=24;
        
        LOG("=== БОСС ИНИЦИАЛИЗИРОВАН ===");
    }
}
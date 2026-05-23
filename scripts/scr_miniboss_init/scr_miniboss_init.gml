function miniboss_init(_miniboss_instance) {
    if (!instance_exists(_miniboss_instance)) return;
    
    with (_miniboss_instance) {
        // Вызываем БАЗОВУЮ инициализацию врага
        enemy_init(id);
        
        // ===== ПЕРЕОПРЕДЕЛЯЕМ ХАРАКТЕРИСТИКИ ДЛЯ МИНИ-БОССА =====
        enemy_type = "miniboss";
        is_boss = true;
        is_ranged = false;
        
        // Характеристики
        hp = 1000;
        max_hp = 1000;
        damage = 40;
        attack_speed = 0.33;
        move_speed = 1.5;
        reward = 200;         // Гены за убийство
        coin_reward = 50;      // Монеты за убийство (ОБЯЗАТЕЛЬНО!)
        
        // AOE атака
        aoe_attack = true;
        aoe_targets = 2;
        attack_range = 100;
        
        stop_distance = 90;
        search_radius = 300;
        attack_cooldown_max = 1 / attack_speed;
        
        queue_distance = 90;
        
        // Визуал
        image_blend = c_yellow;
        image_xscale = 1.5;
        image_yscale = 1.5;
        
        show_health_bar = true;
        
        LOG("=== МИНИ-БОСС ИНИЦИАЛИЗИРОВАН ===");
    }
}
function sniper_init(_instance) {
    if (!instance_exists(_instance)) return;
    
    with (_instance) {
        scr_hero_base_init(id);
        
        hero_type = "sniper";
        
        // Базовые характеристики
        max_hp = 65;
        hp = max_hp;
        damage = 22;
        attack_speed = 0.2;
        move_speed = 2.5;
        
        attack_range_moving =550;
        attack_range_idle =600;
        
        target_x = 300;
        target_y = 600;
        
        // ===== НОВЫЕ ПЕРЕМЕННЫЕ ДЛЯ СНАЙПЕРА =====
        // Мульти-выстрел (по 3 противникам)
        multi_shot_chance = 0;      // Шанс активации (%)
        
        // Серьезный выстрел (+250% урона)
        heavy_shot_chance = 0;      // Шанс активации (%)
        heavy_shot_multiplier = 3.5; // Множитель урона (x3.5 = +250%)
        
       
        
        LOG_CAT("Снайпер инициализирован: HP=" + string(hp) + ", Урон=" + string(damage), "hero");
    }
}
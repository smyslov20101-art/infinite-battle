function healer_init(_healer_instance) {
    if (!instance_exists(_healer_instance)) return;
    
    with (_healer_instance) {
        // Инициализируем базовые переменные
        scr_hero_base_init(id);
        
        // ===== ХАРАКТЕРИСТИКИ ХИЛЕРА =====
        hero_type = "healer";
        max_hp = 60;
        hp = max_hp;
        damage = 0;
        healing_power = 1;      // Базовая сила лечения
        
        // ===== НОВЫЕ ПЕРЕМЕННЫЕ =====
        shield_regen = 0;       // Сколько щита восстанавливает за атаку
        multi_heal_chance = 0;  // Шанс лечения двух целей
        
        // ===== ЛЕЧЕНИЕ =====
        heal_timer = 3.0;
        heal_range = 250;
        
        // ===== ПОВЕДЕНИЕ =====
        attack_range_moving = 0;
        attack_range_idle = heal_range;
        
        // ===== ЦЕЛЕВАЯ ПОЗИЦИЯ =====
        target_x = 200;
        target_y = 600;
        
        // ===== ВИЗУАЛ =====
        image_blend = c_green;
    }
}
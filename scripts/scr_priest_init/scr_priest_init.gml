function priest_init(_priest_instance) {
    if (!instance_exists(_priest_instance)) return;
    
    with (_priest_instance) {
        scr_hero_base_init(id);
        
        hero_type = "priest";
        max_hp = 80;
        hp = max_hp;
        damage = 0;
        healing_power = 3;
        attack_speed = 0.5;
        move_speed = 3;
        
        heal_range = 280;
        heal_timer = 2.5;
        
        attack_range_moving = 0;
        attack_range_idle = heal_range;
        
        target_x = 200;
        target_y = 600;
        
        image_blend = c_yellow;
        
        // ===== НОВЫЕ ПЕРЕМЕННЫЕ ДЛЯ ЖРЕЦА =====
        // Баффы
        buff_mage_percent = 0;      // Бонус урона для мага (%)
        buff_archer_percent = 0;    // Бонус скорости атаки для лучника (%)
        buff_chance = 20;           // Базовый шанс срабатывания баффов (20%)
        
        // Пассивные способности
        heal_on_hit_amount = 0;     // Лечение ближника при получении урона
        armor_on_hit_amount = 0;    // Броня ближнику при получении урона
        max_armor_from_ability = 20; // Максимум брони от способности (по умолчанию 20, на 10 уровне 60)
        
        LOG_CAT("Жрец инициализирован: HP=" + string(hp) + ", Лечение=" + string(healing_power), "hero");
    }
}
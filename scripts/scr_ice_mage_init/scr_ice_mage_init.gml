function ice_mage_init(_ice_mage_instance) {
    if (!instance_exists(_ice_mage_instance)) return;
    
    with (_ice_mage_instance) {
        scr_hero_base_init(id);
        
        hero_type = "ice_mage";
        max_hp = 60;
        hp = max_hp;
        damage = 12;
        attack_speed = 0.45;
        move_speed = 2.5;
        
        attack_range_moving = 500;
        attack_range_idle = 550;
        
        target_x = 100;
        target_y = 600;
        
        // ===== НОВЫЕ ПЕРЕМЕННЫЕ ДЛЯ МАГА ЛЬДА =====
        frost_percent = 0;              // Замедление движения врага (%)
        blizzard_chance = 0;            // Шанс активации Бури
        blizzard_slow_percent = 0;      // Замедление атаки врагов от Бури (%)
        ice_chance = 0;                 // Шанс активации Льда
        ice_damage = 0;                 // Урон от Льда
        
        LOG_CAT("Маг льда инициализирован: HP=" + string(hp) + ", Урон=" + string(damage), "hero");
    }
}
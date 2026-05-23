function forest_mage_init(_forest_mage_instance) {
    if (!instance_exists(_forest_mage_instance)) return;
    
    with (_forest_mage_instance) {
        scr_hero_base_init(id);
        
        hero_type = "forest_mage";
        max_hp = 60;
        hp = max_hp;
        damage = 8;
        attack_speed = 0.5;
        move_speed = 2.5;
        
        // ===== УВЕЛИЧИВАЕМ ДАЛЬНОСТЬ АТАКИ =====
        attack_range_moving = 400;    // Было 280
        attack_range_idle = 450;      // Было 300
        
        projectile_speed = 12;
        
        target_x = 100;
        target_y = 600;
        
        image_blend = c_green;
        
        attack_timer = 0;
        
        LOG_CAT("Лесной маг инициализирован: HP=" + string(hp) + ", Урон=" + string(damage) + 
                  ", attack_range=" + string(attack_range_idle), "hero");
    }
}
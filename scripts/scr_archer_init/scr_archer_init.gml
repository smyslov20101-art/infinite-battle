function archer_init(_archer_instance) {
    if (!instance_exists(_archer_instance)) return;
    
    with (_archer_instance) {
        // Инициализируем базовые перемены
        scr_hero_base_init(id);
        
        // ===== ХАРАКТЕРИСТИКИ ЛУЧНИКА =====
        hero_type = "archer";
        max_hp = 70;
        hp = max_hp;
        damage = 15;
        attack_speed = 0.5;
        move_speed = 2.5;
        
        // ===== БОЙ (ДАЛЬНИЙ) =====
        attack_range_moving = 200;
        attack_range_idle = 250;
        
        // ===== СТРЕЛЬБА =====
        projectile_speed = 8;
        projectile_sprite = spr_arrow;
        
     
        
        // ===== ЦЕЛЕВАЯ ПОЗИЦИЯ =====
        target_x = 300;
        target_y = 600;
    }
}
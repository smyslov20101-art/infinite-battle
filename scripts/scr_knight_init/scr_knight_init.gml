function knight_init(_knight_instance) {
    if (!instance_exists(_knight_instance)) return;
    
    with (_knight_instance) {
        scr_hero_base_init(id);
        
        hero_type = "knight";
        max_hp = 120;
        hp = max_hp;
        damage = 14;
        attack_speed = 0.55;
        move_speed = 3;
        
        attack_range_moving = 85;
        attack_range_idle = 90;
        
        target_x = 400;
        target_y = 600;
        
        image_blend = c_white;
        
        LOG_CAT("Рыцарь инициализирован: HP=" + string(hp) + ", Урон=" + string(damage), "hero");
    }
}
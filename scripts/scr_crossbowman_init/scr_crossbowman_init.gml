function crossbowman_init(_crossbowman_instance) {
    if (!instance_exists(_crossbowman_instance)) return;
    
    with (_crossbowman_instance) {
        scr_hero_base_init(id);
        
        hero_type = "crossbowman";
        max_hp = 75;
        hp = max_hp;
        damage = 18;
        attack_speed = 0.65;
        move_speed = 2.8;
        
        attack_range_moving = 200;
        attack_range_idle =200;
        
        target_x = 300;
        target_y = 600;
        
      
        
        LOG_CAT("Стрелок арбалетчик инициализирован: HP=" + string(hp) + ", Урон=" + string(damage), "hero");
    }
}
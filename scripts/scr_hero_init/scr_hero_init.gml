function hero_init(_hero_instance) {
    if (!instance_exists(_hero_instance)) return;
    
    with (_hero_instance) {
        // Инициализируем базовые перемены
        scr_hero_base_init(id);
        
        // ===== ХАРАКТЕРИСТИКИ ВОИНА =====
        hero_type = "warrior";
        max_hp = 100;
        hp = max_hp;
        damage = 10;
        attack_speed = 0.1; //было 0.5 сделали 0.1 для теста кровотечения
        move_speed = 3;
	
		armor = 0;              // Текущая броня
		base_armor = 0;         // Базовая броня (для накопления)

		cleave_damage = 0;      // Дополнительный урон по второй цели
		cleave_percent = 0;     // Процент прорубающего урона (10 = 10%)
        
        // ===== БОЙ (БЛИЖНИЙ) =====
        attack_range_moving = 101;
        attack_range_idle = 101;
        
        // ===== СЛИЯНИЕ =====
        merge_search_timer = 0;          // ДОБАВЬТЕ ЭТО!
        merge_search_interval = 0.3;     // И ЭТО!
        
        // ===== ВИЗУАЛ =====
        image_blend = c_blue;
        
        // ===== ЦЕЛЕВАЯ ПОЗИЦИЯ =====
        target_x = 400;
        target_y = 600;
    }
}
function berserker_init(_berserker_instance) {
    if (!instance_exists(_berserker_instance)) return;
    
    with (_berserker_instance) {
        scr_hero_base_init(id);
        
        hero_type = "berserker";
        max_hp = 90;
        hp = max_hp;
        damage = 16;
        attack_speed = 0.7;
        move_speed = 3.2;
        
        attack_range_moving = 80;
        attack_range_idle = 85;
        
        target_x = 380;
        target_y = 600;
        
        // ===== НОВЫЕ ПЕРЕМЕННЫЕ ДЛЯ БЕРСЕРКА =====
        // Ярость (Rage)
        rage_active = false;            // Активна ли ярость
        rage_attack_speed_bonus = 0;    // Бонус скорости атаки от ярости (%)
        rage_damage_bonus = 0;          // Бонус урона от ярости (%)
        rage_check_timer = 0;           // Таймер проверки ярости
        rage_check_interval = 0.5;      // Проверять каждые 0.5 секунды
        
        // Временная броня при получении урона
        temp_armor_chance = 0;          // Шанс получить временную броню (%)
        temp_armor_amount = 20;         // Количество временной брони
        temp_armor_duration = 3.0;      // Длительность в секундах
        
        // Оригинальные значения для восстановления после ярости
        original_attack_speed = attack_speed;
        original_damage = damage;
        
        LOG_CAT("Берсерк инициализирован: HP=" + string(hp) + ", Урон=" + string(damage), "hero");
    }
}
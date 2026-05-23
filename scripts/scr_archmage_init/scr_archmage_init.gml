/// @function archmage_init(_instance)
/// @desc Инициализация легендарного героя - Архимаг

function archmage_init(_instance) {
    if (!instance_exists(_instance)) return;
    
    with (_instance) {
        scr_hero_base_init(id);
        
        hero_type = "archmage";
        
        // Базовые характеристики
        max_hp = 80;
        hp = max_hp;
        damage = 25;
        attack_speed = 0.5;
        move_speed = 2.5;
        
        attack_range_moving = 350;
        attack_range_idle = 400;
        
        target_x = 100;
        target_y = 600;
        
        // ===== СПОСОБНОСТИ АРХИМАГА =====
        // Регенерация в % от макс HP
        regen_percent = 0;
        regen_percent_timer = 0;
        
        // Святое отравление
        holy_poison_percent = 0;
        
        // Айсберг
        iceberg_damage = 0;
        iceberg_slow = 30;
        iceberg_cooldown = 0;
        iceberg_cooldown_max = 15;
        
        // Проклятье
        curse_damage_mult = 0;
        curse_cooldown = 0;
        curse_cooldown_max = 15;
        
        // Песнь души
        song_of_soul_bonus = 0;
        song_of_soul_cooldown = 0;
        song_of_soul_cooldown_max = 15;
        song_of_soul_active = false;
        song_of_soul_timer = 0;
        
        // Воля случая
        will_of_chance_bonus = 0;
        will_of_chance_cooldown = 0;
        will_of_chance_cooldown_max = 15;
        will_of_chance_active = false;
        will_of_chance_timer = 0;
        
        // Феникс
        phoenix_bonus = 0;
        phoenix_timer = 0;
        phoenix_cooldown_max = 10;
        
        // Дракон
        dragon_bonus = 0;
        dragon_timer = 0;
        dragon_cooldown_max = 10;
        
        LOG_CAT("Архимаг инициализирован: HP=" + string(hp) + ", Урон=" + string(damage), "hero");
    }
}
function shadow_blade_init(_instance) {
    if (!instance_exists(_instance)) return;
    
    with (_instance) {
        scr_hero_base_init(id);
        
        hero_type = "shadow_blade";
        
        // Базовые характеристики
        max_hp = 85;
        hp = max_hp;
        damage = 18;
        attack_speed = 0.65;
        move_speed = 3.5;
        
        attack_range_moving = 80;
        attack_range_idle = 85;
        
        target_x = 400;
        target_y = 600;
        
        // ===== НОВЫЕ ПЕРЕМЕННЫЕ ДЛЯ МЕЧНИКА ТЕНЕЙ =====
        // Темный меч
        dark_blade_chance = 0;         // Шанс активации (%)
        dark_blade_steal_percent = 0;   // Сколько скорости атаки похищается (%)
        
        // Иллюзия доспеха
        illusion_chance = 0;            // Шанс активации при получении урона (%)
        illusion_dodge_bonus = 0;       // Бонус к уклонению (%)
        illusion_timer = 0;             // Таймер действия иллюзии
        illusion_active = false;        // Активна ли иллюзия
        
        // Оригинальное уклонение для восстановления
        original_dodge_chance = 0;
        
        LOG_CAT("Мечник теней инициализирован: HP=" + string(hp) + ", Урон=" + string(damage), "hero");
    }
}
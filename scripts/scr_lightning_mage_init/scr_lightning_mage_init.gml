function lightning_mage_init(_instance) {
    if (!instance_exists(_instance)) return;
    
    with (_instance) {
        scr_hero_base_init(id);
        
        hero_type = "lightning_mage";
        
        // Базовые характеристики
        max_hp = 55;
        hp = max_hp;
        damage = 14;
        attack_speed =0.3;
        move_speed = 2.2;
        
        attack_range_moving = 450;
        attack_range_idle = 500;
        
        target_x = 100;
        target_y = 600;
        
        // ===== НОВЫЕ ПЕРЕМЕННЫЕ ДЛЯ МАГА МОЛНИЙ =====
        // Цепная молния (базовый шанс 50%, урон -25%)
        chain_lightning_chance = 0;        // Базовый шанс 50% (исправлено!)
        chain_lightning_damage_mult = 0.75; // Множитель урона 0.75 (-25%)
        
        // Оглушение
        stun_chance_mage = 0;            // Шанс оглушить врага (%)
        stun_duration_mage = 2.0;        // Длительность оглушения
        
        // Уязвимость
        vulnerability_chance = 0;        // Шанс наложить уязвимость (%)
        vulnerability_multiplier = 1.30; // Множитель получаемого урона
        vulnerability_duration = 4.0;    // Длительность уязвимости
        
        // Бафф магов
        mage_buff_percent = 0;           // Бонус урона для всех магов
        
        LOG_CAT("Маг молний инициализирован: HP=" + string(hp) + ", Урон=" + string(damage) + 
                  ", chain_lightning_chance=" + string(chain_lightning_chance), "hero");
    }
}
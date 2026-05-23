function elf_archer_init(_elf_archer_instance) {
    if (!instance_exists(_elf_archer_instance)) return;
    
    with (_elf_archer_instance) {
        scr_hero_base_init(id);
        
        hero_type = "elf_archer";
        max_hp = 70;
        hp = max_hp;
        damage = 14;
        attack_speed = 0.85;
        move_speed = 3.5;
        
        attack_range_moving = 200;
        attack_range_idle = 260;
        
        target_x = 300;
        target_y = 600;
        
        // ===== НОВЫЕ ПЕРЕМЕННЫЕ ДЛЯ ЭЛЬФИЙСКОГО ЛУЧНИКА =====
        // Оглушение при атаке
        stun_on_hit_chance = 0;     // Шанс оглушить врага (%)
        stun_duration = 2.0;        // Длительность оглушения в секундах
        
        LOG_CAT("Эльфийский лучник инициализирован: HP=" + string(hp) + ", Урон=" + string(damage), "hero");
    }
}
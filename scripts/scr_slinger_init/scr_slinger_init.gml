/// @function slinger_init(_slinger_instance)
/// @desc Инициализация бродяги с рогаткой (быстрая стрельба, низкий урон)

function slinger_init(_slinger_instance) {
    if (!instance_exists(_slinger_instance)) return;
    
    with (_slinger_instance) {
        // Инициализируем базовые переменные
        scr_hero_base_init(id);
        
        // ===== ХАРАКТЕРИСТИКИ БРОДЯГИ С РОГАТКОЙ =====
        hero_type = "slinger";
        max_hp = 65;                    // Чуть больше чем у лучника (70)
        hp = max_hp;
        damage = 12;                    // Меньше чем у лучника (15)
        attack_speed = 0.9;             // Быстрее лучника (0.7)
        move_speed = 3.2;               // Чуть быстрее лучника (2.5)
        
        // ===== БОЙ (ДАЛЬНИЙ) =====
        attack_range_moving = 220;       // Чуть меньше чем у лучника (250)
        attack_range_idle = 260;
        
        // ===== СНАРЯДЫ =====
        projectile_speed = 10;           // Быстрее стрелы (8)
        projectile_sprite = spr_stone;   // Спрайт камня (нужно создать)
        
        // ===== ЦЕЛЕВАЯ ПОЗИЦИЯ =====
        target_x = 280;
        target_y = 600;
        
        // ===== ВИЗУАЛ =====
        image_blend = c_white;
        
        LOG_CAT("Бродяга с рогаткой инициализирован: HP=" + string(hp) + ", Урон=" + string(damage) + 
                  ", Скорость атаки=" + string(attack_speed), "hero");
    }
}
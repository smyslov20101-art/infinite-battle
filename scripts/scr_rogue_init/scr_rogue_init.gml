/// @function rogue_init(_rogue_instance)
/// @desc Инициализация разбойника (высокий урон, низкое HP, быстрый)

function rogue_init(_rogue_instance) {
    if (!instance_exists(_rogue_instance)) return;
    
    with (_rogue_instance) {
        // Инициализируем базовые переменные
        scr_hero_base_init(id);
        
        // ===== ХАРАКТЕРИСТИКИ РАЗБОЙНИКА =====
        hero_type = "rogue";
        max_hp = 60;                    // Меньше чем у воина (100)
        hp = max_hp;
        damage = 18;                    // Больше чем у воина (10)
        attack_speed = 0.6;             // Быстрее воина (0.5)
        move_speed = 4.0;               // Быстрее воина (3)
        
        // ===== БОЙ (БЛИЖНИЙ) =====
        attack_range_moving = 80;
        attack_range_idle = 85;
        
        // ===== ЦЕЛЕВАЯ ПОЗИЦИЯ (чуть ближе к врагу) =====
        target_x = 420;
        target_y = 600;
        
        // ===== ВИЗУАЛ =====
        image_blend = c_white;
        
        LOG_CAT("Разбойник инициализирован: HP=" + string(hp) + ", Урон=" + string(damage) + 
                  ", Скорость атаки=" + string(attack_speed), "hero");
    }
}
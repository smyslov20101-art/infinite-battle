function tank_init(_tank_instance) {
    if (!instance_exists(_tank_instance)) return;
    
    with (_tank_instance) {
        // Сначала вызываем базовую инициализацию всех героев
        scr_hero_base_init(id);
        
        // ===== ХАРАКТЕРИСТИКИ ТАНКА =====
        hero_type = "tank";
        max_hp = 200;
        hp = max_hp;
        damage = 0;            // Танк не наносит урон
        
        // ===== ЩИТ =====
        shield = 5;             // Базовый щит 5
        max_shield = 5;         // Максимальный щит
        shield_regen_timer = 0;
        shield_regen_interval = 2.0;  // Щит восстанавливается каждые 2 секунды
        shield_regen_speed = 0;       // Бонус скорости восстановления (%)
        
        // ===== БРОНЯ =====
        armor = 0;
        armor_regen = 0;
        armor_regen_timer = 0;
        armor_regen_interval = 2.0;
        
        // ===== РЕГЕНЕРАЦИЯ =====
        regen_per_second = 0;
        regen_timer = 0;
        
        // ===== ОТРАЖЕНИЕ =====
        thorn_percent = 0;
        thorn_aoe = false;
        
        // ===== БОЙ =====
        attack_speed = 0.5;
        attack_range_moving = 80;
        attack_range_idle = 85;
        
        // ===== ЦЕЛЕВАЯ ПОЗИЦИЯ =====
        target_x = 400;
        target_y = 600;
        
        // ===== ВИЗУАЛ =====
        image_blend = c_white;
        
        // Проверяем спрайты
        if (sprite_exists(spr_shield_icon)) {
            LOG_CAT("Танк: спрайт щита (spr_shield_icon) найден", "hero");
        } else {
            LOG_CAT("Танк: спрайт щита (spr_shield_icon) НЕ НАЙДЕН!", "hero");
        }
        
        if (sprite_exists(spr_shield)) {
            LOG_CAT("Танк: спрайт брони (spr_shield) найден", "hero");
        } else {
            LOG_CAT("Танк: спрайт брони (spr_shield) НЕ НАЙДЕН!", "hero");
        }
        
        LOG_CAT("Танк инициализирован: HP=" + string(hp) + ", Щит=" + string(shield) + 
                  ", Макс щит=" + string(max_shield) + ", Броня=" + string(armor), "hero");
    }
}
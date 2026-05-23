/// @function scr_hero_base_init(_hero_instance)
/// @desc Инициализация БАЗОВЫХ переменных для всех героев
function scr_hero_base_init(_hero_instance) {
    if (!instance_exists(_hero_instance)) return;
    
    with (_hero_instance) {
        // ===== СОСТОЯНИЯ =====
        STATE_MOVING = 0;
        STATE_FIGHTING = 1;
        STATE_IDLE = 2;
        STATE_MERGING = 3;
        STATE_DEAD = 4;
        
        state = STATE_MOVING;
        state_timer = 0;
        
        // ===== ОСНОВНЫЕ ХАРАКТЕРИСТИКИ =====
        hero_level = 1;
        max_hp = 100;
        hp = max_hp;
        damage = 10;
        attack_speed = 0.5;
        attack_timer = 0;
        
        // ===== КРИТИЧЕСКИЙ УДАР =====
        crit_chance = 0;        // Шанс крита в %
        crit_damage_mult = 2.0; // Множитель крит. урона (x2 по умолчанию)
        
        // ===== ВАМПИРИЗМ =====
        lifesteal = 0;          // % урона, возвращаемый как HP
        
        // ===== БРОНЯ =====
        armor = 0;              // Текущая броня
        armor_from_priest = 0;  // Броня от жреца (для отслеживания лимита)
        
        // ===== ДВИЖЕНИЕ =====
        move_speed = 3;
        
        // ===== БОЙ =====
        fight_target = noone;
        attack_range_moving = 80;
        attack_range_idle = 85;
        
        // ===== СЛИЯНИЕ =====
        merge_target = noone;
        merge_radius = 80;
        merge_speed = 2;
        card_level = 1;
        
        // ===== ВИЗУАЛ =====
        image_blend = c_white;
        image_alpha = 1.0;
        
        // ===== ПОЛУЧЕНИЕ УРОНА =====
        damage_cooldown = 0;
        damage_cooldown_max = 0.5;
        
        // ===== ГЛАВНЫЙ ГЕРОЙ =====
        is_main_hero = false;
        
        // ===== ALARMS =====
        alarm[0] = -1;
        
        // ===== БОНУСЫ ОТ ДЕРЕВА =====
        attack_speed_bonus = 0;     // Бонус скорости атаки (%)
        attack_speed_bonus_timer = 0;
        damage_bonus = 0;           // Бонус урона (%)
        damage_bonus_timer = 0;
        
        // ===== ЭФФЕКТЫ =====
        damage_flash_timer = 0;     // Для визуального эффекта при получении урона
    }
}
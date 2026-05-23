/// @function druid_init(_instance)
/// @desc Инициализация эпического героя - Друид (помощник)

function druid_init(_instance) {
    if (!instance_exists(_instance)) return;
    
    with (_instance) {
        scr_hero_base_init(id);
        
        hero_type = "druid";
        hero_name = "Друид";
        
        // Базовые характеристики
        max_hp = 80;
        hp = max_hp;
        damage = 0;
        healing_power = 5;
        attack_speed = 0.4;
        move_speed = 3.0;
        
        heal_range = 350;
        heal_timer = 2.5;           // ← ДОБАВЛЕНО! Таймер лечения
        
        attack_range_moving = 0;
        attack_range_idle = heal_range;
        
        target_x = 200;
        target_y = 600;
        
        // ===== ПЕРЕМЕННЫЕ ДЛЯ ДРУИДА =====
        
        // Аура лечения
        heal_aura_percent = 0;
        heal_aura_timer = 0;
        heal_aura_cooldown = 0;
        heal_aura_cooldown_max = 15.0;
        heal_aura_tick_timer = 0;
        
        // Аура уклонения
        dodge_aura_percent = 0;
        dodge_aura_timer = 0;
        dodge_aura_cooldown = 0;
        dodge_aura_cooldown_max = 15.0;
        
        // Аура снижения урона
        dr_aura_percent = 0;
        dr_aura_timer = 0;
        dr_aura_cooldown = 0;
        dr_aura_cooldown_max = 15.0;
        
        // Шанс принять урон вместо союзника
        taunt_chance = 0;
        
        // Бафф ближника (+HP при получении урона)
        druid_buff_melee_chance = 0;
        druid_buff_melee_value = 20;
        druid_buff_melee_duration = 5.0;
        druid_buff_melee_cooldown = 0;
        
        // Last Stand (регенерация при низком HP)
        last_stand_percent = 0;
        last_stand_cooldown = 0;
        last_stand_cooldown_max = 40.0;
        last_stand_triggered = false;
        
        // Спасение ближника (лечение при HP < 10%)
        save_melee_percent = 0;
        save_melee_cooldown = 0;
        save_melee_cooldown_max = 50.0;
        
        // Защита ближника (уклонение + снижение урона при HP < 15%)
        protect_melee_dodge = 0;
        protect_melee_dr = 0;
        protect_melee_duration = 10.0;
        protect_melee_cooldown = 0;
        protect_melee_cooldown_max = 60.0;
        
        // Флаг для предотвращения рекурсии при принятии урона
        is_taunting = false;
        
        // Визуал
        image_blend = c_lime;
        
        LOG_CAT("Друид инициализирован: HP=" + string(hp) + ", Лечение=" + string(healing_power), "hero");
    }
}
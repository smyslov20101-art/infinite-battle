/// @function paladin_init(_instance)
function paladin_init(_instance) {
    if (!instance_exists(_instance)) return;
    
    with (_instance) {
        scr_hero_base_init(id);
        
        hero_type = "paladin";
        hero_name = "Паладин";
        
        // Базовые характеристики
        max_hp = 150;
        hp = max_hp;
        damage = 20;
        attack_speed = 0.55;
        move_speed = 3.2;
        original_attack_speed = attack_speed;
        original_damage = damage;
        
        attack_range_moving = 85;
        attack_range_idle = 90;
        
        target_x = 400;
        target_y = 600;
        
        // ===== РЕГЕНЕРАЦИЯ (для совместимости) =====
        regen_per_second = 0;
        regen_timer = 0;
        
        // ===== АУРЫ =====
        aura_hp_percent = 0;
        aura_damage_percent = 0;
        aura_active = false;
        aura_attack_speed_percent = 0;
        
        // ===== ЗАЩИТА =====
        physical_reduction_percent = 0;
        damage_reduction_percent = 0;
        every_6th_miss_counter = 0;
        next_hit_miss = false;
        invuln_timer = 0;
        invuln_cooldown = 0;
        invuln_cooldown_max = 10.0;
        invuln_duration = 2.0;
        
        // ===== СТАКИ =====
        damage_stacks = 0;
        defense_stacks = 0;
        max_stacks = 25;
        damage_stacks_max = false;
        defense_stacks_max = false;
        
        // ===== ПРИЗЫВЫ =====
        guardian_angel_timer = 0;
        guardian_angel_cooldown = 10.0;
        guardian_angel_heal_percent = 0;
        guardian_angel_buff_timer = 0;
        guardian_angel_buff_active = false;
        
        bodyguard_timer = 0;
        bodyguard_cooldown = 15.0;
        bodyguard_active_timer = 0;
        bodyguard_duration = 3.0;
        
        // ===== МЕТКИ ПРАВОСУДИЯ =====
        justice_mark_chance = 0;
        justice_mark_damage_bonus = 6;
        justice_mark_max_stacks = 5;
        attack_counter = 0;
        
        // ===== ГОЛОВОКРУЖЕНИЕ =====
        dizziness_chance = 0;
        dizziness_duration = 2.0;
        dizziness_damage_reduction = 10;
        dizziness_slow_duration = 3.0;
        dizziness_attack_counter = 0;
        
        // ===== СВЯТАЯ БРОНЯ (10 уровень) =====
        holy_armor_layers = 0;
        holy_armor_max_layers = 4;
        holy_armor_phys_reduction_per_layer = 10;
        holy_armor_regen_per_layer = 2;
        
        // ===== БОЖЕСТВЕННОЕ ОРУЖИЕ (10 уровень) =====
        divine_weapon_layers = 0;
        divine_weapon_max_layers = 4;
        divine_weapon_damage_per_layer = 7;
        divine_weapon_self_reduction_per_layer = 5;
        
        LOG_CAT("Паладин инициализирован: HP=" + string(hp) + ", Урон=" + string(damage), "hero");
    }
}
/// Step Event - obj_hero_ghost

// Получаем контроллер для проверки паузы
var controller = instance_find(obj_game_controller, 0);

// Если игра на паузе или окончена - ничего не делаем
if (instance_exists(controller)) {
    if (controller.controller_state == controller.CONTROLLER_STATE_PAUSE || 
        controller.game_over) {
        exit;
    }
}

// Проверяем существование цели
if (!instance_exists(target_hero) || target_hero.hp <= 0) {
    instance_destroy();
    exit;
}

// Двигаемся к цели
var dist = point_distance(x, y, target_hero.x, target_hero.y);

if (dist > move_speed) {
    var dir = point_direction(x, y, target_hero.x, target_hero.y);
    x += lengthdir_x(move_speed, dir);
    y += lengthdir_y(move_speed, dir);
    image_angle = dir;
} else {
    LOG_CAT("=================================", "hero");
    LOG_CAT("ПРИЗРАК ДОСТИГ ЦЕЛИ!", "hero");
    LOG_CAT("Тип улучшения: " + string(upgrade_type), "hero");
    LOG_CAT("Значение: " + string(upgrade_value), "hero");
    LOG_CAT("Цель: " + string(target_hero) + " (hero_id: " + string(target_hero.hero_id) + ")", "hero");
    
    // Применяем улучшение к герою
    with (target_hero) {
        LOG_CAT("ГЕРОЙ: hp=" + string(hp) + ", max_hp=" + string(max_hp) + ", damage=" + string(damage), "hero");
        
        // Проверяем существование переменной armor ДО
        if (variable_instance_exists(id, "armor")) {
            LOG_CAT("armor существует, значение: " + string(armor), "hero");
        } else {
            LOG_CAT("armor НЕ существует", "hero");
        }
        
        // ===== ОБРАБОТКА ВСЕХ ТИПОВ ЧЕРЕЗ CASE =====
        switch (other.upgrade_type) {
            
            case global.UPGRADE_TYPE_HP:
                var current_hp_bonus = hp * (other.upgrade_value / 100);
                var max_hp_bonus = max_hp * (other.upgrade_value / 100);
                hp += current_hp_bonus;
                max_hp += max_hp_bonus;
                LOG_CAT("Призрак улучшил HP: +" + string(other.upgrade_value) + 
                          "% (" + string(floor(current_hp_bonus)) + "/" + string(floor(max_hp_bonus)) + ")", "hero");
                break;
                
            case global.UPGRADE_TYPE_DAMAGE:
                var damage_bonus = damage * (other.upgrade_value / 100);
                damage += damage_bonus;
                LOG_CAT("Призрак улучшил DMG: +" + string(other.upgrade_value) + 
                          "% (" + string(floor(damage_bonus)) + ")", "hero");
                break;
                
            case global.UPGRADE_TYPE_ARMOR:
                LOG_CAT("ARMOR CASE ACTIVATED!", "hero");
                if (!variable_instance_exists(id, "armor")) {
                    LOG_CAT("Создаем переменную armor", "hero");
                    armor = 0;
                }
                var old_armor = armor;
                armor += other.upgrade_value;
                LOG_CAT("БРОНЯ: " + string(old_armor) + " → " + string(armor) + 
                          " (+" + string(other.upgrade_value) + ")", "hero");
                break;
                
            case global.UPGRADE_TYPE_CLEAVE:
                LOG_CAT("CLEAVE CASE ACTIVATED!", "hero");
                if (!variable_instance_exists(id, "cleave_percent")) {
                    LOG_CAT("cleave_percent не существовала, создаем", "hero");
                    cleave_percent = 0;
                }
                var old_cleave = cleave_percent;
                cleave_percent += other.upgrade_value;
                if (!variable_instance_exists(id, "cleave_damage")) {
                    cleave_damage = 0;
                }
                cleave_damage = floor(damage * cleave_percent / 100);
                LOG_CAT("CLEAVE: " + string(old_cleave) + "% → " + string(cleave_percent) + 
                          "% (урон по второй цели: " + string(cleave_damage) + ")", "cleave");
                break;
                
            case global.UPGRADE_TYPE_ATTACK_SPEED:
                if (!variable_instance_exists(id, "attack_speed")) {
                    attack_speed = 0.5;
                }
                var old_speed = attack_speed;
                attack_speed *= (1 + other.upgrade_value / 100);
                if (variable_instance_exists(id, "attack_cooldown_max")) {
                    attack_cooldown_max = 1 / attack_speed;
                }
                LOG_CAT("Призрак улучшил скорость атаки: " + string(old_speed) + " → " + 
                          string(attack_speed) + " (+" + string(other.upgrade_value) + "%)", "hero");
                break;
                
            case global.UPGRADE_TYPE_MOVE_SPEED:
                if (!variable_instance_exists(id, "move_speed")) {
                    move_speed = 3;
                }
                var old_move = move_speed;
                move_speed *= (1 + other.upgrade_value / 100);
                LOG_CAT("Призрак улучшил скорость: " + string(old_move) + " → " + 
                          string(move_speed) + " (+" + string(other.upgrade_value) + "%)", "hero");
                break;
                
            case global.UPGRADE_TYPE_RANGE:
                if (!variable_instance_exists(id, "attack_range_moving")) {
                    attack_range_moving = 80;
                }
                if (!variable_instance_exists(id, "attack_range_idle")) {
                    attack_range_idle = 85;
                }
                attack_range_moving += other.upgrade_value;
                attack_range_idle += other.upgrade_value;
                LOG_CAT("Призрак увеличил дальность: +" + string(other.upgrade_value) + 
                          " (теперь " + string(attack_range_moving) + "/" + string(attack_range_idle) + ")", "hero");
                break;
                
            case global.UPGRADE_TYPE_CRIT_CHANCE:
                if (!variable_instance_exists(id, "crit_chance")) {
                    crit_chance = 0;
                }
                crit_chance += other.upgrade_value;
                LOG_CAT("Призрак добавил шанс крита: +" + string(other.upgrade_value) + 
                          "% (теперь " + string(crit_chance) + "%)", "hero");
                break;
                
            case global.UPGRADE_TYPE_CRIT_DAMAGE:
                if (!variable_instance_exists(id, "crit_damage_mult")) {
                    crit_damage_mult = 2.0;
                }
                crit_damage_mult += other.upgrade_value / 100;
                LOG_CAT("Призрак увеличил крит урон: x" + string(crit_damage_mult) + 
                          " (+" + string(other.upgrade_value) + "%)", "hero");
                break;
				
				case global.UPGRADE_TYPE_REGEN_PERCENT:
    regen_percent = other.upgrade_value;
    LOG_CAT("💚 Архимаг: регенерация " + string(regen_percent) + "% от макс HP/сек", "hero");
    break;

case global.UPGRADE_TYPE_HOLY_POISON:
    holy_poison_percent = other.upgrade_value;
    LOG_CAT("☠️ Архимаг: святое отравление " + string(holy_poison_percent) + "% урона/сек на 3 сек", "hero");
    break;

case global.UPGRADE_TYPE_ICEBERG:
    iceberg_damage = other.upgrade_value;
    LOG_CAT("🧊 Архимаг: айсберг " + string(iceberg_damage) + " урона", "hero");
    break;

case global.UPGRADE_TYPE_CURSE:
    curse_damage_mult = other.upgrade_value;
    LOG_CAT("👁️ Архимаг: проклятье +" + string(curse_damage_mult) + "% урона врагам", "hero");
    break;

case global.UPGRADE_TYPE_SONG_OF_SOUL:
    song_of_soul_bonus = other.upgrade_value;
    LOG_CAT("🎵 Архимаг: песнь души +" + string(song_of_soul_bonus) + "% скор. атаки магам", "hero");
    break;

case global.UPGRADE_TYPE_WILL_OF_CHANCE:
    will_of_chance_bonus = other.upgrade_value;
    LOG_CAT("🎲 Архимаг: воля случая +" + string(will_of_chance_bonus) + "% шанс крита магам", "hero");
    break;

case global.UPGRADE_TYPE_PHOENIX_FEATHER:
    phoenix_bonus = other.upgrade_value;
    LOG_CAT("🪶 Архимаг: феникс +" + string(phoenix_bonus) + "% скор. атаки × убийства", "hero");
    break;

case global.UPGRADE_TYPE_DRAGON_SCALE:
    dragon_bonus = other.upgrade_value;
    LOG_CAT("🐉 Архимаг: дракон +" + string(dragon_bonus) + "% урона × минуты игры", "hero");
    break;
				
				// ===== ПАЛАДИН: АУРА (+HP и +DMG союзникам) =====
case global.UPGRADE_TYPE_PALADIN_AOE_BUFF:
    if (other.upgrade_value == 5) {
        // Левый уровень 1 - HP
        if (!variable_instance_exists(id, "aura_hp_percent")) {
            aura_hp_percent = 0;
        }
        var old_hp_aura = aura_hp_percent;
        aura_hp_percent += other.upgrade_value;
        LOG_CAT("🛡️✨ АУРА ПАЛАДИНА: +" + string(other.upgrade_value) + "% HP союзникам (было " + string(old_hp_aura) + " → " + string(aura_hp_percent) + "%)", "hero");
    } else if (other.upgrade_value == 7) {
        // Правый уровень 1 - DMG
        if (!variable_instance_exists(id, "aura_damage_percent")) {
            aura_damage_percent = 0;
        }
        var old_dmg_aura = aura_damage_percent;
        aura_damage_percent += other.upgrade_value;
        LOG_CAT("🛡️✨ АУРА ПАЛАДИНА: +" + string(other.upgrade_value) + "% урона союзникам (было " + string(old_dmg_aura) + " → " + string(aura_damage_percent) + "%)", "hero");
    }
    break;

// ===== ПАЛАДИН: СНИЖЕНИЕ ФИЗИЧЕСКОГО УРОНА =====
case global.UPGRADE_TYPE_PALADIN_PHYS_REDUCTION:
    if (!variable_instance_exists(id, "physical_reduction_percent")) {
        physical_reduction_percent = 0;
    }
    var old_phys = physical_reduction_percent;
    physical_reduction_percent += other.upgrade_value;
    LOG_CAT("🛡️↓ СНИЖЕНИЕ ФИЗ. УРОНА: +" + string(other.upgrade_value) + "% (было " + string(old_phys) + " → " + string(physical_reduction_percent) + "%)", "hero");
    break;

// ===== ПАЛАДИН: АУРА СКОРОСТИ АТАКИ =====
case global.UPGRADE_TYPE_PALADIN_AOE_ATTACK_SPEED:
    if (!variable_instance_exists(id, "aura_attack_speed_percent")) {
        aura_attack_speed_percent = 0;
    }
    var old_as_aura = aura_attack_speed_percent;
    aura_attack_speed_percent += other.upgrade_value;
    LOG_CAT("⚡✨ АУРА СКОРОСТИ АТАКИ: +" + string(other.upgrade_value) + "% союзникам (было " + string(old_as_aura) + " → " + string(aura_attack_speed_percent) + "%)", "hero");
    break;

// ===== ПАЛАДИН: КАЖДЫЙ 6 УДАР - ПРОМАХ =====
case global.UPGRADE_TYPE_PALADIN_EVERY_6TH_MISS:
    if (!variable_instance_exists(id, "every_6th_miss_counter")) {
        every_6th_miss_counter = 0;
        next_hit_miss = false;
    }
    LOG_CAT("🎯❌ КАЖДЫЙ 6 УДАР - ПРОМАХ! Активировано", "hero");
    break;

// ===== ПАЛАДИН: НЕУЯЗВИМОСТЬ =====
case global.UPGRADE_TYPE_PALADIN_INVULN:
    if (!variable_instance_exists(id, "invuln_duration")) {
        invuln_duration = 0;
        invuln_cooldown_max = 10.0;
        invuln_cooldown = 0;
        invuln_timer = 0;
    }
    invuln_duration = other.upgrade_value;
    LOG_CAT("🛡️💫 НЕУЯЗВИМОСТЬ: на " + string(invuln_duration) + " сек (КД " + string(invuln_cooldown_max) + " сек)", "hero");
    break;

// ===== ПАЛАДИН: СТАКИ ЗАЩИТЫ (7 уровень - левый) =====
case global.UPGRADE_TYPE_PALADIN_DEFENSE_STACKS:
    if (!variable_instance_exists(id, "defense_stacks_max")) {
        defense_stacks_max = true;
        defense_stacks = 0;
        max_stacks = 25;
        damage_reduction_percent = 0;
    }
    LOG_CAT("🛡️📈 СТАКИ ЗАЩИТЫ: за каждый удар -1% получаемого урона (макс 25 стеков)", "hero");
    break;

// ===== ПАЛАДИН: СТАКИ УРОНА (7 уровень - правый) =====
case global.UPGRADE_TYPE_PALADIN_DAMAGE_STACKS:
    if (!variable_instance_exists(id, "damage_stacks_max")) {
        damage_stacks_max = true;
        damage_stacks = 0;
        max_stacks = 25;
        original_damage = damage;
    }
    LOG_CAT("⚔️📈 СТАКИ УРОНА: за каждый удар +1% урона (макс 25 стеков)", "hero");
    break;

// ===== ПАЛАДИН: АНГЕЛ-ХРАНИТЕЛЬ (8 уровень - левый) =====
case global.UPGRADE_TYPE_PALADIN_GUARDIAN_ANGEL:
    if (!variable_instance_exists(id, "guardian_angel_heal_percent")) {
        guardian_angel_heal_percent = 0;
        guardian_angel_timer = 0;
        guardian_angel_cooldown = 10.0;
    }
    var old_angel = guardian_angel_heal_percent;
    guardian_angel_heal_percent += other.upgrade_value;
    LOG_CAT("👼✨ АНГЕЛ-ХРАНИТЕЛЬ: лечение " + string(guardian_angel_heal_percent) + "% HP всем союзникам раз в 10 сек, +7% скор. атаки паладину на 5 сек", "hero");
    break;

// ===== ПАЛАДИН: ТЕЛОХРАНИТЕЛЬ (8 уровень - правый) =====
case global.UPGRADE_TYPE_PALADIN_BODYGUARD:
    if (!variable_instance_exists(id, "bodyguard_duration")) {
        bodyguard_duration = 0;
        bodyguard_cooldown = 15.0;
        bodyguard_timer = 0;
        bodyguard_active_timer = 0;
    }
    bodyguard_duration = other.upgrade_value;
    LOG_CAT("🛡️👤 ТЕЛОХРАНИТЕЛЬ: призывается раз в 15 сек, защищает союзников " + string(bodyguard_duration) + " сек (получает весь урон вместо них)", "hero");
    break;

// ===== ПАЛАДИН: МЕТКА ПРАВОСУДИЯ (9 уровень - левый) =====
case global.UPGRADE_TYPE_PALADIN_JUSTICE_MARK:
    if (!variable_instance_exists(id, "justice_mark_chance")) {
        justice_mark_chance = 0;
        justice_mark_damage_bonus = 6;
        justice_mark_max_stacks = 5;
    }
    var old_mark = justice_mark_chance;
    justice_mark_chance += other.upgrade_value;
    LOG_CAT("⚖️🔖 МЕТКА ПРАВОСУДИЯ: " + string(justice_mark_chance) + "% шанс наложить метку (+6% урона за стек, макс 5 стеков)", "hero");
    break;

// ===== ПАЛАДИН: ГОЛОВОКРУЖЕНИЕ (9 уровень - правый) =====
case global.UPGRADE_TYPE_PALADIN_DIZZINESS:
    if (!variable_instance_exists(id, "dizziness_chance")) {
        dizziness_chance = 0;
        dizziness_duration = 2.0;
        dizziness_damage_reduction = 10;
        dizziness_slow_duration = 3.0;
    }
    var old_dizzy = dizziness_chance;
    dizziness_chance += other.upgrade_value;
    LOG_CAT("🌀😵 ГОЛОВОКРУЖЕНИЕ: " + string(dizziness_chance) + "% шанс обездвижить 2 врагов на 2 сек и снизить их урон на 10% на 3 сек", "hero");
    break;

// ===== ПАЛАДИН: СВЯТАЯ БРОНЯ (10 уровень - левый) =====
case global.UPGRADE_TYPE_PALADIN_HOLY_ARMOR:
    if (!variable_instance_exists(id, "holy_armor_layers")) {
        holy_armor_layers = 0;
        holy_armor_max_layers = 4;
        holy_armor_phys_reduction_per_layer = 10;
        holy_armor_regen_per_layer = 2;
    }
    LOG_CAT("🛡️✨ СВЯТАЯ БРОНЯ: при призыве ангела +1 слой (макс 4). Слой: -10% физ. урона и +2% регенерации", "hero");
    break;

// ===== ПАЛАДИН: БОЖЕСТВЕННОЕ ОРУЖИЕ (10 уровень - правый) =====
case global.UPGRADE_TYPE_PALADIN_DIVINE_WEAPON:
    if (!variable_instance_exists(id, "divine_weapon_layers")) {
        divine_weapon_layers = 0;
        divine_weapon_max_layers = 4;
        divine_weapon_damage_per_layer = 7;
        divine_weapon_self_reduction_per_layer = 5;
    }
    LOG_CAT("⚔️✨ БОЖЕСТВЕННОЕ ОРУЖИЕ: при призыве ангела +1 слой (макс 4). Слой: +7% урона союзникам и -5% урона паладину", "hero");
    break;
				
				case global.UPGRADE_TYPE_DARK_BLADE:
    // ===== ТЕМНЫЙ МЕЧ (похищение скорости атаки) =====
    LOG_CAT("🔥🔥🔥 DARK_BLADE CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "dark_blade_chance")) {
        dark_blade_chance = 0;
        dark_blade_steal_percent = 0;
    }
    
    if (other.upgrade_value == 20) {
        // Первое получение (уровень 2)
        dark_blade_chance = 20;
        dark_blade_steal_percent = 20;
    } else if (other.upgrade_value == 30) {
        // Апгрейд на 5 уровне
        dark_blade_chance = 30;
        dark_blade_steal_percent = 30;
    } else if (other.upgrade_value == 40) {
        // Апгрейд на 10 уровне
        dark_blade_chance = 40;
        dark_blade_steal_percent = 40;
    }
    
    LOG_CAT("🗡️🌑 ТЕМНЫЙ МЕЧ: шанс " + string(dark_blade_chance) + 
              "%, похищение " + string(dark_blade_steal_percent) + 
              "% скор. атаки врага на 3 сек", "combat");
    break;

case global.UPGRADE_TYPE_ARMOR_ILLUSION:
    // ===== ИЛЛЮЗИЯ ДОСПЕХА (уклонение при получении урона) =====
    LOG_CAT("🔥🔥🔥 ARMOR_ILLUSION CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "illusion_chance")) {
        illusion_chance = 0;
        illusion_dodge_bonus = 0;
    }
    
    if (other.upgrade_value == 15) {
        // Первое получение (уровень 2)
        illusion_chance = 20;
        illusion_dodge_bonus = 15;
    } else if (other.upgrade_value == 25) {
        // Апгрейд на 5 уровне
        illusion_chance = 30;
        illusion_dodge_bonus = 25;
    } else if (other.upgrade_value == 35) {
        // Апгрейд на 10 уровне
        illusion_chance = 40;
        illusion_dodge_bonus = 35;
    }
    
    LOG_CAT("🛡️👻 ИЛЛЮЗИЯ ДОСПЕХА: шанс " + string(illusion_chance) + 
              "%, уклонение +" + string(illusion_dodge_bonus) + 
              "% на 3 сек при получении урона", "combat");
    break;
	
	case global.UPGRADE_TYPE_MULTI_SHOT:
    // ===== МУЛЬТИ-ВЫСТРЕЛ (по 3 противникам) =====
    LOG_CAT("🔥🔥🔥 MULTI_SHOT CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "multi_shot_chance")) {
        multi_shot_chance = 0;
    }
    
    var old_multi = multi_shot_chance;
    multi_shot_chance += other.upgrade_value;
    
    LOG_CAT("🎯🎯🎯 МУЛЬТИ-ВЫСТРЕЛ: +" + string(other.upgrade_value) + 
              "% (было " + string(old_multi) + " → " + string(multi_shot_chance) + "%)", "combat");
    break;
	
	case global.UPGRADE_TYPE_CHAIN_LIGHTNING:
    // ===== ЦЕПНАЯ МОЛНИЯ (атака по 4 врагам со штрафом урона) =====
    LOG_CAT("🔥🔥🔥 CHAIN_LIGHTNING CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "chain_lightning_chance")) {
        chain_lightning_chance = 50;  // Базовый шанс 50%
        chain_lightning_damage_mult = 0; // Множитель урона (будет установлен ниже)
    }
    
    // Устанавливаем множитель урона в зависимости от значения
    if (other.upgrade_value == 75) {
        chain_lightning_damage_mult = 0.75;  // -25% урона
        LOG_CAT("⚡⚡⚡⚡ ЦЕПНАЯ МОЛНИЯ: 50% шанс атаки по 4 врагам, урон x0.75", "combat");
    } else if (other.upgrade_value == 85) {
        chain_lightning_damage_mult = 0.85;  // -15% урона
        LOG_CAT("⚡⚡⚡⚡ ЦЕПНАЯ МОЛНИЯ: 50% шанс атаки по 4 врагам, урон x0.85", "combat");
    } else if (other.upgrade_value == 95) {
        chain_lightning_damage_mult = 0.95;  // -5% урона
        LOG_CAT("⚡⚡⚡⚡ ЦЕПНАЯ МОЛНИЯ: 50% шанс атаки по 4 врагам, урон x0.95", "combat");
    }
    break;

case global.UPGRADE_TYPE_STUN_ON_HIT_MAGE:
    // ===== ОГЛУШЕНИЕ ПРИ АТАКЕ =====
    LOG_CAT("🔥🔥🔥 STUN_ON_HIT_MAGE CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "stun_chance_mage")) {
        stun_chance_mage = 0;
        stun_duration_mage = 2.0;
    }
    
    var old_stun = stun_chance_mage;
    stun_chance_mage += other.upgrade_value;
    
    LOG_CAT("💫⚡ ОГЛУШЕНИЕ: +" + string(other.upgrade_value) + 
              "% (было " + string(old_stun) + " → " + string(stun_chance_mage) + 
              "%, длительность " + string(stun_duration_mage) + " сек)", "combat");
    break;

case global.UPGRADE_TYPE_VULNERABILITY:
    // ===== УЯЗВИМОСТЬ (увеличение получаемого урона) =====
    LOG_CAT("🔥🔥🔥 VULNERABILITY CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "vulnerability_chance")) {
        vulnerability_chance = 0;
        vulnerability_multiplier = 1.30;  // +30% урона
        vulnerability_duration = 4.0;
    }
    
    var old_vuln = vulnerability_chance;
    vulnerability_chance += other.upgrade_value;
    
    LOG_CAT("🔻 УЯЗВИМОСТЬ: +" + string(other.upgrade_value) + 
              "% (было " + string(old_vuln) + " → " + string(vulnerability_chance) + 
              "%, множитель x" + string(vulnerability_multiplier) + ")", "combat");
    break;

case global.UPGRADE_TYPE_MAGE_BUFF:
    // ===== БАФФ ВСЕХ МАГОВ =====
    LOG_CAT("🔥🔥🔥 MAGE_BUFF CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "mage_buff_percent")) {
        mage_buff_percent = 0;
    }
    
    var old_buff = mage_buff_percent;
    mage_buff_percent += other.upgrade_value;
    
    LOG_CAT("✨🧙 БАФФ МАГОВ: +" + string(other.upgrade_value) + 
              "% урона всем магам (было " + string(old_buff) + " → " + string(mage_buff_percent) + "%)", "combat");
    
    // Применяем бафф ко всем магам в отряде
    with (obj_hero_base) {
        if (hero_class == global.CLASS_MAGE && hp > 0) {
            if (!variable_instance_exists(id, "original_damage_for_mage_buff")) {
                original_damage_for_mage_buff = damage;
            }
            var buff_mult = 1 + (other.mage_buff_percent / 100);
            damage = original_damage_for_mage_buff * buff_mult;
            LOG_CAT("✨ Маг " + string(object_index) + " получил бафф: урон " + string(damage), "combat");
        }
    }
    break;

case global.UPGRADE_TYPE_HEAVY_SHOT:
    // ===== СЕРЬЕЗНЫЙ ВЫСТРЕЛ (+250% урона) =====
    LOG_CAT("🔥🔥🔥 HEAVY_SHOT CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "heavy_shot_chance")) {
        heavy_shot_chance = 0;
        heavy_shot_multiplier = 3.5; // +250% = x3.5
    }
    
    var old_heavy = heavy_shot_chance;
    heavy_shot_chance += other.upgrade_value;
    
    LOG_CAT("💥💥 СЕРЬЕЗНЫЙ ВЫСТРЕЛ: +" + string(other.upgrade_value) + 
              "% (было " + string(old_heavy) + " → " + string(heavy_shot_chance) + 
              "%, множитель x" + string(heavy_shot_multiplier) + ")", "combat");
    break;
				
	case global.UPGRADE_TYPE_STUN_ON_HIT:
    // ===== ОГЛУШЕНИЕ ПРИ АТАКЕ =====
    LOG_CAT("🔥🔥🔥 STUN_ON_HIT CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "stun_on_hit_chance")) {
        stun_on_hit_chance = 0;
        stun_duration = 2.0;
    }
    
    var old_stun = stun_on_hit_chance;
    stun_on_hit_chance += other.upgrade_value;
    
    LOG_CAT("💫 ОГЛУШЕНИЕ ПРИ АТАКЕ: +" + string(other.upgrade_value) + 
              "% (было " + string(old_stun) + " → " + string(stun_on_hit_chance) + 
              "%, длительность " + string(stun_duration) + " сек)", "combat");
    break;

case global.UPGRADE_TYPE_RAGE:
    // ===== ЯРОСТЬ (активируется при 4+ врагах или боссе) =====
    LOG_CAT("🔥🔥🔥 RAGE CASE ACTIVATED!", "combat");
    
    // Определяем, это первое получение способности или апгрейд
    if (other.upgrade_value == 20) {
        // Первое получение (уровень 3)
        rage_attack_speed_bonus = 20;
        rage_damage_bonus = 20;
        rage_check_timer = 0;
        LOG_CAT("💢 ЯРОСТЬ: активирована! +20% скор. атаки, +20% урона при 4+ врагах или боссе", "combat");
    } else if (other.upgrade_value == 40) {
        // Апгрейд на 7 уровне
        rage_attack_speed_bonus = 40;
        rage_damage_bonus = 40;
        LOG_CAT("💢 ЯРОСТЬ УЛУЧШЕНА! +40% скор. атаки, +40% урона", "combat");
    } else if (other.upgrade_value == 75) {
        // Апгрейд на 10 уровне
        rage_attack_speed_bonus = 75;
        rage_damage_bonus = 70;
        LOG_CAT("💢 ЯРОСТЬ МАКСИМАЛЬНА! +75% скор. атаки, +70% урона", "combat");
    }
    
    // Сохраняем оригинальные значения для восстановления
    if (!variable_instance_exists(id, "original_attack_speed")) {
        original_attack_speed = attack_speed;
    }
    if (!variable_instance_exists(id, "original_damage")) {
        original_damage = damage;
    }
    break;

case global.UPGRADE_TYPE_ARMOR_ON_HIT_TEMP:
    // ===== ВРЕМЕННАЯ БРОНЯ ПРИ ПОЛУЧЕНИИ УРОНА =====
    LOG_CAT("🔥🔥🔥 ARMOR_ON_HIT_TEMP CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "temp_armor_chance")) {
        temp_armor_chance = 0;
        temp_armor_amount = 20;
        temp_armor_duration = 3.0;
    }
    
    var old_chance = temp_armor_chance;
    temp_armor_chance += other.upgrade_value;
    
    LOG_CAT("🛡️⚡ ВРЕМЕННАЯ БРОНЯ: шанс +" + string(other.upgrade_value) + 
              "% (было " + string(old_chance) + " → " + string(temp_armor_chance) + 
              "%, броня +" + string(temp_armor_amount) + " на " + string(temp_armor_duration) + " сек)", "combat");
    break;			

case global.UPGRADE_TYPE_BUFF_MAGE:
    // ===== БАФФ МАГА (увеличение урона) =====
    LOG_CAT("🔥🔥🔥 BUFF_MAGE CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "buff_mage_percent")) {
        buff_mage_percent = 0;
    }
    
    var old_mage = buff_mage_percent;
    buff_mage_percent += other.upgrade_value;
    
    LOG_CAT("✨ БАФФ МАГА: +" + string(other.upgrade_value) + 
              "% урона (было " + string(old_mage) + " → " + string(buff_mage_percent) + "%)", "combat");
    break;

case global.UPGRADE_TYPE_BUFF_ARCHER:
    // ===== БАФФ ЛУЧНИКА (увеличение скорости атаки) =====
    LOG_CAT("🔥🔥🔥 BUFF_ARCHER CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "buff_archer_percent")) {
        buff_archer_percent = 0;
    }
    
    var old_archer = buff_archer_percent;
    buff_archer_percent += other.upgrade_value;
    
    LOG_CAT("🏹✨ БАФФ ЛУЧНИКА: +" + string(other.upgrade_value) + 
              "% скор. атаки (было " + string(old_archer) + " → " + string(buff_archer_percent) + "%)", "combat");
    break;

case global.UPGRADE_TYPE_BUFF_CHANCE:
    // ===== ШАНС СРАБАТЫВАНИЯ БАФФОВ =====
    LOG_CAT("🔥🔥🔥 BUFF_CHANCE CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "buff_chance")) {
        buff_chance = 20;
    }
    
    var old_chance = buff_chance;
    buff_chance += other.upgrade_value;
    
    LOG_CAT("🎲 ШАНС БАФФОВ: +" + string(other.upgrade_value) + 
              "% (было " + string(old_chance) + " → " + string(buff_chance) + "%)", "combat");
    break;

case global.UPGRADE_TYPE_HEAL_ON_HIT:
    // ===== ЛЕЧЕНИЕ БЛИЖНИКА ПРИ ПОЛУЧЕНИИ УРОНА =====
    LOG_CAT("🔥🔥🔥 HEAL_ON_HIT CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "heal_on_hit_amount")) {
        heal_on_hit_amount = 0;
    }
    
    var old_heal = heal_on_hit_amount;
    heal_on_hit_amount += other.upgrade_value;
    
    LOG_CAT("💚🛡️ ЛЕЧЕНИЕ БЛИЖНИКА: +" + string(other.upgrade_value) + 
              " HP (было " + string(old_heal) + " → " + string(heal_on_hit_amount) + ")", "combat");
    break;

case global.UPGRADE_TYPE_ARMOR_ON_HIT:
    // ===== БРОНЯ БЛИЖНИКУ ПРИ ПОЛУЧЕНИИ УРОНА =====
    LOG_CAT("🔥🔥🔥 ARMOR_ON_HIT CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "armor_on_hit_amount")) {
        armor_on_hit_amount = 0;
        max_armor_from_ability = 20;
    }
    
    var old_armor = armor_on_hit_amount;
    armor_on_hit_amount += other.upgrade_value;
    
    // Обновляем максимальную броню для 10 уровня
    if (other.upgrade_value >= 3) {
        max_armor_from_ability = 60;
    }
    
    LOG_CAT("🔧🛡️ БРОНЯ БЛИЖНИКУ: +" + string(other.upgrade_value) + 
              " брони (макс " + string(max_armor_from_ability) + 
              ", было " + string(old_armor) + " → " + string(armor_on_hit_amount) + ")", "combat");
    break;

case global.UPGRADE_TYPE_FROST:
    // ===== МОРОЗ (ЗАМЕДЛЕНИЕ ДВИЖЕНИЯ) =====
    LOG_CAT("🔥🔥🔥 FROST CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "frost_percent")) {
        frost_percent = 0;
    }
    
    var old_frost = frost_percent;
    frost_percent += other.upgrade_value;
    
    LOG_CAT("❄️ МОРОЗ: +" + string(other.upgrade_value) + 
              "% замедления (было " + string(old_frost) + " → " + string(frost_percent) + "%)", "combat");
    break;

case global.UPGRADE_TYPE_BLIZZARD:
    // ===== БУРЯ (ЗАМЕДЛЕНИЕ АТАКИ ВРАГОВ) =====
    LOG_CAT("🔥🔥🔥 BLIZZARD CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "blizzard_chance")) {
        blizzard_chance = 0;
        blizzard_slow_percent = 0;
    }
    
    if (other.upgrade_value >= 30) {
        // Это первое получение умения (15% шанс, замедление 10%)
        blizzard_chance = 15;
        blizzard_slow_percent = other.upgrade_value;  // 10 или 30
    } else {
        // Это увеличение шанса
        blizzard_chance += other.upgrade_value;
    }
    
    LOG_CAT("🌪️ БУРЯ: шанс " + string(blizzard_chance) + 
              "%, замедление атаки " + string(blizzard_slow_percent) + "%", "combat");
    break;

case global.UPGRADE_TYPE_ICE:
    // ===== ЛЕД (ПЕРИОДИЧЕСКИЙ УРОН ПО ВСЕМ ВРАГАМ) =====
    LOG_CAT("🔥🔥🔥 ICE CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "ice_chance")) {
        ice_chance = 0;
        ice_damage = 0;
    }
    
    if (other.upgrade_value == 15) {
        // Это первое получение умения (15% шанс, урон 15)
        ice_chance = 15;
        ice_damage = other.upgrade_value;
    } else {
        // Это апгрейд (увеличение урона)
        ice_damage += other.upgrade_value;
    }
    
    LOG_CAT("🧊 ЛЕД: шанс " + string(ice_chance) + 
              "%, урон " + string(ice_damage) + " по всем врагам", "combat");
    break;
				
				case global.UPGRADE_TYPE_DOUBLE_SHOT:
    // ===== ДВОЙНОЙ ВЫСТРЕЛ =====
    LOG_CAT("🔥🔥🔥 DOUBLE_SHOT CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "double_shot_chance")) {
        double_shot_chance = 0;
    }
    
    var old_double = double_shot_chance;
    double_shot_chance += other.upgrade_value;
    
    LOG_CAT("🏹 ДВОЙНОЙ ВЫСТРЕЛ: +" + string(other.upgrade_value) + 
              "% (было " + string(old_double) + " → " + string(double_shot_chance) + "%)", "combat");
    break;
                
            case global.UPGRADE_TYPE_LIFESTEAL:
                if (!variable_instance_exists(id, "lifesteal")) {
                    lifesteal = 0;
                }
                lifesteal += other.upgrade_value;
                LOG_CAT("Призрак добавил вампиризм: +" + string(other.upgrade_value) + 
                          "% (теперь " + string(lifesteal) + "%)", "vampire");
                break;
                
            case global.UPGRADE_TYPE_DODGE:
                if (!variable_instance_exists(id, "dodge_chance")) {
                    dodge_chance = 0;
                }
                var old_dodge = dodge_chance;
                dodge_chance += other.upgrade_value;
                LOG_CAT("УКЛОНЕНИЕ: +" + string(other.upgrade_value) + 
                          "% (было " + string(old_dodge) + " → " + string(dodge_chance) + "%)", "dodge");
                break;
                
            case global.UPGRADE_TYPE_AOE:
                if (!variable_instance_exists(id, "aoe_radius")) {
                    aoe_radius = 50;
                }
                aoe_radius += other.upgrade_value;
                LOG_CAT("Призрак увеличил радиус АОЕ: +" + string(other.upgrade_value) + 
                          " (теперь " + string(aoe_radius) + ")", "hero");
                break;
                
            case global.UPGRADE_TYPE_BLEED:
                LOG_CAT("BLEED CASE ACTIVATED!", "bleed");
                if (!variable_instance_exists(id, "bleed_damage")) {
                    bleed_damage = 0;
                }
                var old_bleed = bleed_damage;
                bleed_damage += other.upgrade_value;
                LOG_CAT("КРОВОТЕЧЕНИЕ: +" + string(other.upgrade_value) + 
                          " урона/сек (было " + string(old_bleed) + " → " + string(bleed_damage) + ")", "bleed");
                break;
				
				case global.UPGRADE_TYPE_DAMAGE_REDUCTION:
    // ===== СНИЖЕНИЕ ПОЛУЧАЕМОГО УРОНА =====
    LOG_CAT("🔥🔥🔥 DAMAGE_REDUCTION CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "damage_reduction_percent")) {
        damage_reduction_percent = 0;
    }
    
    var old_reduction = damage_reduction_percent;
    damage_reduction_percent += other.upgrade_value;
    
    LOG_CAT("🛡️ СНИЖЕНИЕ УРОНА: +" + string(other.upgrade_value) + 
              "% (было " + string(old_reduction) + " → " + string(damage_reduction_percent) + "%)", "combat");
    break;
    
case global.UPGRADE_TYPE_BIG_BLEED:
    // ===== БОЛЬШОЕ КРОВОТЕЧЕНИЕ =====
    LOG_CAT("🔥🔥🔥 BIG_BLEED CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "big_bleed_chance")) {
        big_bleed_chance = 25; // Базовый шанс 25% на 6 уровне
        big_bleed_damage = 0;
    }
    
    if (other.upgrade_value >= 30) {
        // Это первое получение умения (шанс 25%, урон 30)
        big_bleed_chance = 25;
        big_bleed_damage = other.upgrade_value;
    } else {
        // Это апгрейд (увеличение урона)
        big_bleed_damage += other.upgrade_value;
    }
    
    LOG_CAT("🩸💥 БОЛЬШОЕ КРОВОТЕЧЕНИЕ: урон " + string(big_bleed_damage) + 
              "/сек, шанс " + string(big_bleed_chance) + "%", "combat");
    break;
    
case global.UPGRADE_TYPE_ATTACK_SPEED_SLOW:
    // ===== ЗАМЕДЛЕНИЕ АТАКИ ВРАГА =====
    LOG_CAT("🔥🔥🔥 ATTACK_SPEED_SLOW CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "attack_speed_slow_chance")) {
        attack_speed_slow_chance = 0;
        attack_speed_slow_percent = 0;
    }
    
    if (other.upgrade_value >= 30 && attack_speed_slow_chance == 0) {
        // Это первое получение умения (шанс 20%, замедление 30%)
        attack_speed_slow_chance = 20;
        attack_speed_slow_percent = other.upgrade_value;
    } else if (other.upgrade_value >= 30) {
        // Это увеличение шанса (9 уровень +15% шанса)
        attack_speed_slow_chance += other.upgrade_value - 30;
    } else {
        // Это увеличение замедления (9 уровень +20% замедления)
        attack_speed_slow_percent += other.upgrade_value;
    }
    
    LOG_CAT("🐢 ЗАМЕДЛЕНИЕ АТАКИ: шанс " + string(attack_speed_slow_chance) + 
              "%, замедление " + string(attack_speed_slow_percent) + "%", "combat");
    break;
                
				case global.UPGRADE_TYPE_MULTI_TARGET:
    // ===== АТАКА ПО ДВУМ ЦЕЛЯМ =====
    LOG_CAT("🔥🔥🔥 MULTI_TARGET CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "multi_target_chance")) {
        multi_target_chance = 0;
    }
    
    var old_multi = multi_target_chance;
    multi_target_chance += other.upgrade_value;
    
    LOG_CAT("🎯 АТАКА ПО ДВУМ ЦЕЛЯМ: +" + string(other.upgrade_value) + 
              "% (было " + string(old_multi) + " → " + string(multi_target_chance) + "%)", "combat");
    break;
    
case global.UPGRADE_TYPE_PROJECTILE_SPEED:
    // ===== СКОРОСТЬ СНАРЯДА =====
    LOG_CAT("🔥🔥🔥 PROJECTILE_SPEED CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "projectile_speed_bonus")) {
        projectile_speed_bonus = 0;
    }
    
    var old_speed = projectile_speed_bonus;
    projectile_speed_bonus += other.upgrade_value;
    
    LOG_CAT("⚡ СКОРОСТЬ СНАРЯДА: +" + string(other.upgrade_value) + 
              "% (было " + string(old_speed) + " → " + string(projectile_speed_bonus) + "%)", "combat");
    break;
    
case global.UPGRADE_TYPE_BURN:
    // ===== ГОРЕНИЕ =====
    LOG_CAT("🔥🔥🔥 BURN CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "burn_damage")) {
        burn_damage = 0;
    }
    
    var old_burn = burn_damage;
    burn_damage += other.upgrade_value;
    
    LOG_CAT("🔥 ГОРЕНИЕ: +" + string(other.upgrade_value) + 
              " урона/2 сек (было " + string(old_burn) + " → " + string(burn_damage) + ")", "combat");
    break;
	
	case global.UPGRADE_TYPE_HEAL:
    // ===== СИЛА ЛЕЧЕНИЯ =====
    LOG_CAT("🔥🔥🔥 HEAL CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "healing_power")) {
        healing_power = 1;
    }
    
    var old_heal = healing_power;
    healing_power += other.upgrade_value;
    
    LOG_CAT("💚 СИЛА ЛЕЧЕНИЯ: +" + string(other.upgrade_value) + 
              " (было " + string(old_heal) + " → " + string(healing_power) + ")", "combat");
    break;
    
case global.UPGRADE_TYPE_SHIELD_REGEN:
    // ===== ВОССТАНОВЛЕНИЕ ЩИТА =====
    LOG_CAT("🔥🔥🔥 SHIELD_REGEN CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "shield_regen")) {
        shield_regen = 0;
    }
    
    var old_regen = shield_regen;
    shield_regen += other.upgrade_value;
    
    LOG_CAT("🛡️ ВОССТАНОВЛЕНИЕ ЩИТА: +" + string(other.upgrade_value) + 
              " (было " + string(old_regen) + " → " + string(shield_regen) + ")", "combat");
    break;
	
	case global.UPGRADE_TYPE_SHIELD:
    // ===== ЩИТ =====
    LOG_CAT("🔥🔥🔥 SHIELD CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "shield")) {
        shield = 0;
        max_shield = 0;
    }
    
    var old_shield = max_shield;
    max_shield += other.upgrade_value;
    shield += other.upgrade_value;
    
    LOG_CAT("🛡️ ЩИТ: +" + string(other.upgrade_value) + 
              " (было " + string(old_shield) + " → " + string(max_shield) + ")", "combat");
    break;
    
case global.UPGRADE_TYPE_ARMOR_REGEN:
    // ===== РЕГЕНЕРАЦИЯ БРОНИ =====
    LOG_CAT("🔥🔥🔥 ARMOR_REGEN CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "armor_regen")) {
        armor_regen = 0;
    }
    
    var old_regen = armor_regen;
    armor_regen += other.upgrade_value;
    
    LOG_CAT("🔧 РЕГЕНЕРАЦИЯ БРОНИ: +" + string(other.upgrade_value) + 
              " (было " + string(old_regen) + " → " + string(armor_regen) + ")", "combat");
    break;
    
case global.UPGRADE_TYPE_SHIELD_REGEN_SPEED:
    // ===== СКОРОСТЬ ВОССТАНОВЛЕНИЯ ЩИТА =====
    LOG_CAT("🔥🔥🔥 SHIELD_REGEN_SPEED CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "shield_regen_speed")) {
        shield_regen_speed = 0;
    }
    
    var old_speed = shield_regen_speed;
    shield_regen_speed += other.upgrade_value;
    
    LOG_CAT("⚡ СКОРОСТЬ ВОССТАНОВЛЕНИЯ ЩИТА: +" + string(other.upgrade_value) + 
              "% (было " + string(old_speed) + " → " + string(shield_regen_speed) + "%)", "combat");
    break;
    
case global.UPGRADE_TYPE_THORN:
    // ===== ОТРАЖЕНИЕ УРОНА =====
    LOG_CAT("🔥🔥🔥 THORN CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "thorn_percent")) {
        thorn_percent = 0;
    }
    
    var old_thorn = thorn_percent;
    thorn_percent += other.upgrade_value;
    
    LOG_CAT("🔄 ОТРАЖЕНИЕ УРОНА: +" + string(other.upgrade_value) + 
              "% (было " + string(old_thorn) + " → " + string(thorn_percent) + "%)", "combat");
    break;
    
case global.UPGRADE_TYPE_THORN_AOE:
    // ===== ОТРАЖЕНИЕ ПО ВТОРОЙ ЦЕЛИ =====
    LOG_CAT("🔥🔥🔥 THORN_AOE CASE ACTIVATED!", "combat");
    
    thorn_aoe = true;
    
    LOG_CAT("🌊 ОТРАЖЕНИЕ ПО ВТОРОЙ ЦЕЛИ: Активировано!", "combat");
    break;
    
case global.UPGRADE_TYPE_MULTI_HEAL:
    // ===== ЛЕЧЕНИЕ ДВУХ ЦЕЛЕЙ =====
    LOG_CAT("🔥🔥🔥 MULTI_HEAL CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "multi_heal_chance")) {
        multi_heal_chance = 0;
    }
    
    var old_multi = multi_heal_chance;
    multi_heal_chance += other.upgrade_value;
    
    LOG_CAT("👥 ЛЕЧЕНИЕ ДВУХ ЦЕЛЕЙ: +" + string(other.upgrade_value) + 
              "% (было " + string(old_multi) + " → " + string(multi_heal_chance) + "%)", "combat");
    break;
	
	case global.UPGRADE_TYPE_DOUBLE_ATTACK:
    // ===== ДВОЙНАЯ АТАКА =====
    LOG_CAT("🔥🔥🔥 DOUBLE_ATTACK CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "double_attack_chance")) {
        double_attack_chance = 0;
    }
    
    var old_double = double_attack_chance;
    double_attack_chance += other.upgrade_value;
    
    LOG_CAT("⚔️ ДВОЙНАЯ АТАКА: +" + string(other.upgrade_value) + 
              "% (было " + string(old_double) + " → " + string(double_attack_chance) + "%)", "combat");
    break;
	
	case global.UPGRADE_TYPE_STUN:
    // ===== ОГЛУШЕНИЕ =====
    LOG_CAT("🔥🔥🔥 STUN CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "stun_chance")) {
        stun_chance = 0;
    }
    
    var old_stun = stun_chance;
    stun_chance += other.upgrade_value;
    
    LOG_CAT("💫 ОГЛУШЕНИЕ: +" + string(other.upgrade_value) + 
              "% (было " + string(old_stun) + " → " + string(stun_chance) + "%)", "combat");
    break;
	
	case global.UPGRADE_TYPE_ENTANGLE:
    // ===== ОПУТЫВАНИЕ ЛОЗОЙ =====
    LOG_CAT("🔥🔥🔥 ENTANGLE CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "entangle_chance")) {
        entangle_chance = 0;
    }
    
    var old_entangle = entangle_chance;
    entangle_chance += other.upgrade_value;
    
    LOG_CAT("🌿 ОПУТЫВАНИЕ ЛОЗОЙ: +" + string(other.upgrade_value) + 
              "% (было " + string(old_entangle) + " → " + string(entangle_chance) + "%)", "combat");
    break;
	
	case global.UPGRADE_TYPE_DRUID_HEAL_AURA:
    if (!variable_instance_exists(id, "heal_aura_percent")) {
        heal_aura_percent = 0;
    }
    var old_heal_aura = heal_aura_percent;
    heal_aura_percent += other.upgrade_value;
    LOG_CAT("💚🌿 АУРА ЛЕЧЕНИЯ: +" + string(other.upgrade_value) + 
              "% (было " + string(old_heal_aura) + " → " + string(heal_aura_percent) + "%)", "hero");
    break;

// Аура уклонения
case global.UPGRADE_TYPE_DRUID_DODGE_AURA:
    if (!variable_instance_exists(id, "dodge_aura_percent")) {
        dodge_aura_percent = 0;
    }
    var old_dodge_aura = dodge_aura_percent;
    dodge_aura_percent += other.upgrade_value;
    LOG_CAT("🌀🌿 АУРА УКЛОНЕНИЯ: +" + string(other.upgrade_value) + 
              "% (было " + string(old_dodge_aura) + " → " + string(dodge_aura_percent) + "%)", "hero");
    break;

// Шанс принять урон вместо союзника
case global.UPGRADE_TYPE_DRUID_TAUNT_CHANCE:
    if (!variable_instance_exists(id, "taunt_chance")) {
        taunt_chance = 0;
    }
    var old_taunt = taunt_chance;
    taunt_chance += other.upgrade_value;
    LOG_CAT("🛡️🌿 ПРИНЯТИЕ УРОНА: +" + string(other.upgrade_value) + 
              "% (было " + string(old_taunt) + " → " + string(taunt_chance) + "%)", "hero");
    break;

// Бафф ближника при получении урона
case global.UPGRADE_TYPE_DRUID_BUFF_MELEE:
    if (!variable_instance_exists(id, "druid_buff_melee_chance")) {
        druid_buff_melee_chance = 0;
    }
    var old_buff = druid_buff_melee_chance;
    druid_buff_melee_chance += other.upgrade_value;
    LOG_CAT("💪🌿 БАФФ БЛИЖНИКА: +" + string(other.upgrade_value) + 
              "% (было " + string(old_buff) + " → " + string(druid_buff_melee_chance) + "%)", "hero");
    break;

// Аура снижения урона
case global.UPGRADE_TYPE_DRUID_DAMAGE_REDUCTION_AURA:
    if (!variable_instance_exists(id, "dr_aura_percent")) {
        dr_aura_percent = 0;
    }
    var old_dr = dr_aura_percent;
    dr_aura_percent += other.upgrade_value;
    LOG_CAT("🛡️🌿 АУРА СНИЖЕНИЯ УРОНА: +" + string(other.upgrade_value) + 
              "% (было " + string(old_dr) + " → " + string(dr_aura_percent) + "%)", "hero");
    break;

// Last Stand (регенерация при низком HP)
case global.UPGRADE_TYPE_DRUID_LAST_STAND:
    if (!variable_instance_exists(id, "last_stand_percent")) {
        last_stand_percent = 0;
    }
    var old_last = last_stand_percent;
    last_stand_percent += other.upgrade_value;
    LOG_CAT("💪🔄 LAST STAND: +" + string(other.upgrade_value) + 
              "% (было " + string(old_last) + " → " + string(last_stand_percent) + "%)", "hero");
    break;

// Спасение ближника
case global.UPGRADE_TYPE_DRUID_SAVE_MELEE:
    if (!variable_instance_exists(id, "save_melee_percent")) {
        save_melee_percent = 0;
    }
    var old_save = save_melee_percent;
    save_melee_percent += other.upgrade_value;
    LOG_CAT("💚🆘 СПАСЕНИЕ БЛИЖНИКА: +" + string(other.upgrade_value) + 
              "% (было " + string(old_save) + " → " + string(save_melee_percent) + "%)", "hero");
    break;

// Защита ближника
case global.UPGRADE_TYPE_DRUID_PROTECT_MELEE:
    if (!variable_instance_exists(id, "protect_melee_dodge")) {
        protect_melee_dodge = 0;
    }
    if (!variable_instance_exists(id, "protect_melee_dr")) {
        protect_melee_dr = 0;
    }
    var old_dodge_protect = protect_melee_dodge;
    var old_dr_protect = protect_melee_dr;
    protect_melee_dodge += other.upgrade_value;
    protect_melee_dr += other.upgrade_value;
    LOG_CAT("🛡️🆘 ЗАЩИТА БЛИЖНИКА: +" + string(other.upgrade_value) + 
              "% уклонения (было " + string(old_dodge_protect) + " → " + string(protect_melee_dodge) + "%)" +
              " и -" + string(other.upgrade_value) + "% урона (было " + string(old_dr_protect) + " → " + string(protect_melee_dr) + "%)", "hero");
    break;
    
case global.UPGRADE_TYPE_HEX:
    // ===== СГЛАЗ =====
    LOG_CAT("🔥🔥🔥 HEX CASE ACTIVATED!", "combat");
    
    if (!variable_instance_exists(id, "hex_chance")) {
        hex_chance = 0;
    }
    
    var old_hex = hex_chance;
    hex_chance += other.upgrade_value;
    
    LOG_CAT("👁️ СГЛАЗ: +" + string(other.upgrade_value) + 
              "% (было " + string(old_hex) + " → " + string(hex_chance) + "%)", "combat");
    break;
				
            case global.UPGRADE_TYPE_REGEN:
                LOG_CAT("REGEN CASE ACTIVATED!", "hero");
                if (!variable_instance_exists(id, "regen_per_second")) {
                    regen_per_second = 0;
                }
                var old_regen = regen_per_second;
                regen_per_second += other.upgrade_value;
                LOG_CAT("РЕГЕНЕРАЦИЯ: +" + string(other.upgrade_value) + 
                          " HP/сек (было " + string(old_regen) + " → " + string(regen_per_second) + ")", "hero");
                break;
                
             default:
                LOG_CAT("Неизвестный тип улучшения: " + other.upgrade_type, "hero");
                break;
        }
        
        // ===== ЭТА ЧАСТЬ ВНУТРИ with, ПОСЛЕ switch =====
        var chosen_upgrade = {
            type: other.upgrade_type,
            value: other.upgrade_value,
            level: other.upgrade_level,
            side: other.side  // ← БЕРЁМ ИЗ ПРИЗРАКА!
        };
        
        // Находим дерево героя в контроллере
        var controller = instance_find(obj_game_controller, 0);
        if (instance_exists(controller)) {
            for (var i = 0; i < 4; i++) {
                if (controller.hero_trees[i] != noone && controller.hero_trees[i].hero_id == hero_id) {
                    array_push(controller.hero_trees[i].chosen_upgrades, chosen_upgrade);
                    LOG_CAT("✅ Улучшение добавлено в дерево героя (сторона: " + other.side + ")", "hero");
                    break;
                }
            }
        }
        
        hero_level += 1;
        LOG_CAT("Уровень героя теперь: " + string(hero_level), "hero");
        LOG_CAT("=================================", "hero");
    }  // ← ЗАКРЫВАЕМ with (target_hero)
    
    instance_destroy();  // ← УНИЧТОЖАЕМ ПРИЗРАКА
}
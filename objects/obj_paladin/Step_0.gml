/// Step Event - obj_paladin
event_inherited();

if (state == STATE_DEAD || hp <= 0) exit;

if (state == STATE_MERGING && !instance_exists(merge_target)) {
    state = STATE_IDLE;
    merge_target = noone;
}

// ===== АКТИВНАЯ АУРА (постоянная) =====
if ((aura_hp_percent > 0 || aura_damage_percent > 0) && !aura_active) {
    aura_active = true;
    with (obj_hero_base) {
        if (hp > 0 && state != STATE_DEAD && id != other.id) {
            if (other.aura_hp_percent > 0) {
                if (!variable_instance_exists(id, "paladin_hp_bonus")) paladin_hp_bonus = 0;
                var hp_bonus_amount = floor(max_hp * other.aura_hp_percent / 100);
                max_hp += hp_bonus_amount;
                hp += hp_bonus_amount;
                paladin_hp_bonus += hp_bonus_amount;
                LOG_CAT("🛡️✨ Аура паладина: +" + string(hp_bonus_amount) + " HP для " + string(object_index), "combat");
            }
            if (other.aura_damage_percent > 0) {
                if (!variable_instance_exists(id, "paladin_damage_bonus")) paladin_damage_bonus = 0;
                var dmg_bonus_amount = floor(damage * other.aura_damage_percent / 100);
                damage += dmg_bonus_amount;
                paladin_damage_bonus += dmg_bonus_amount;
                LOG_CAT("🛡️✨ Аура паладина: +" + string(dmg_bonus_amount) + " урона для " + string(object_index), "combat");
            }
        }
    }
}

// ===== АУРА СКОРОСТИ АТАКИ =====
if (aura_attack_speed_percent > 0) {
    with (obj_hero_base) {
        if (hp > 0 && state != STATE_DEAD && id != other.id) {
            if (!variable_instance_exists(id, "paladin_as_bonus")) {
                paladin_as_bonus = 0;
                original_attack_speed_paladin = attack_speed;
            }
            var expected_bonus = other.aura_attack_speed_percent;
            if (paladin_as_bonus != expected_bonus) {
                attack_speed = original_attack_speed_paladin * (1 + expected_bonus / 100);
                paladin_as_bonus = expected_bonus;
                LOG_CAT("⚡✨ Аура скорости атаки паладина: +" + string(expected_bonus) + "% для " + string(object_index), "combat");
            }
        }
    }
}

// ===== ОБНОВЛЕНИЕ ТАЙМЕРОВ =====
if (invuln_timer > 0) invuln_timer -= 1 / room_speed;
if (invuln_cooldown > 0) invuln_cooldown -= 1 / room_speed;

// Активация неуязвимости (6 уровень - правый)
if (invuln_duration > 0 && invuln_cooldown <= 0 && invuln_timer <= 0) {
    invuln_timer = invuln_duration;
    invuln_cooldown = invuln_cooldown_max;
    LOG_CAT("🛡️💫 ПАЛАДИН СТАЛ НЕУЯЗВИМ на " + string(invuln_duration) + " сек!", "combat");
}

// ===== АНГЕЛ-ХРАНИТЕЛЬ (8 уровень - левый) =====
if (guardian_angel_heal_percent > 0) {
    if (guardian_angel_timer > 0) guardian_angel_timer -= 1 / room_speed;
    if (guardian_angel_timer <= 0) {
        guardian_angel_timer = guardian_angel_cooldown;
        
        with (obj_hero_base) {
            if (hp > 0 && state != STATE_DEAD) {
                var heal_amount = floor(max_hp * other.guardian_angel_heal_percent / 100);
                if (heal_amount > 0) {
                    hp = min(max_hp, hp + heal_amount);
                    LOG_CAT("👼✨ Ангел-хранитель вылечил " + string(heal_amount) + " HP для " + string(object_index), "combat");
                }
            }
        }
        
        guardian_angel_buff_active = true;
        guardian_angel_buff_timer = 5.0;
        attack_speed = original_attack_speed * 1.07;
        LOG_CAT("👼✨ Ангел-хранитель: +7% скорости атаки паладину на 5 сек", "combat");
        
        // ===== СВЯТАЯ БРОНЯ: +1 слой при призыве ангела =====
        if (holy_armor_layers < holy_armor_max_layers) {
            holy_armor_layers++;
            LOG_CAT("🛡️✨ СВЯТАЯ БРОНЯ: +1 слой (всего " + string(holy_armor_layers) + "/" + string(holy_armor_max_layers) + ")", "combat");
        }
        
        // ===== БОЖЕСТВЕННОЕ ОРУЖИЕ: +1 слой при призыве ангела =====
        if (divine_weapon_layers < divine_weapon_max_layers) {
            divine_weapon_layers++;
            LOG_CAT("⚔️✨ БОЖЕСТВЕННОЕ ОРУЖИЕ: +1 слой (всего " + string(divine_weapon_layers) + "/" + string(divine_weapon_max_layers) + ")", "combat");
        }
    }
}

if (guardian_angel_buff_active && guardian_angel_buff_timer > 0) {
    guardian_angel_buff_timer -= 1 / room_speed;
    if (guardian_angel_buff_timer <= 0) {
        guardian_angel_buff_active = false;
        attack_speed = original_attack_speed;
        LOG_CAT("👼✨ Бафф ангела-хранителя закончился", "combat");
    }
}

// ===== ТЕЛОХРАНИТЕЛЬ (8 уровень - правый) =====
if (bodyguard_duration > 0) {
    if (bodyguard_timer > 0) bodyguard_timer -= 1 / room_speed;
    if (bodyguard_timer <= 0) {
        bodyguard_timer = bodyguard_cooldown;
        bodyguard_active_timer = bodyguard_duration;
        LOG_CAT("🛡️👤 ТЕЛОХРАНИТЕЛЬ ПРИЗВАН! Защищает союзников " + string(bodyguard_duration) + " сек", "combat");
    }
}

if (bodyguard_active_timer > 0) {
    bodyguard_active_timer -= 1 / room_speed;
    if (bodyguard_active_timer <= 0) {
        LOG_CAT("🛡️👤 Телохранитель закончил защищать союзников", "combat");
    }
}

// ===== СВЯТАЯ БРОНЯ (10 уровень) - обновляем бонусы =====
if (holy_armor_layers > 0) {
    var expected_phys_reduction = holy_armor_layers * holy_armor_phys_reduction_per_layer;
    if (physical_reduction_percent != expected_phys_reduction) {
        physical_reduction_percent = expected_phys_reduction;
        LOG_CAT("🛡️✨ Святая броня: -" + string(physical_reduction_percent) + "% физ. урона", "combat");
    }
    
    var expected_regen = holy_armor_layers * holy_armor_regen_per_layer;
    if (regen_per_second != expected_regen) {
        regen_per_second = expected_regen;
        LOG_CAT("🛡️✨ Святая броня: +" + string(regen_per_second) + " HP/сек регенерации", "combat");
    }
}

// ===== БОЖЕСТВЕННОЕ ОРУЖИЕ (10 уровень) =====
if (divine_weapon_layers > 0) {
    with (obj_hero_base) {
        if (hp > 0 && state != STATE_DEAD && id != other.id) {
            var expected_damage_bonus = other.divine_weapon_layers * other.divine_weapon_damage_per_layer;
            if (!variable_instance_exists(id, "divine_weapon_bonus")) {
                divine_weapon_bonus = 0;
                original_damage_divine = damage;
            }
            if (divine_weapon_bonus != expected_damage_bonus) {
                damage = original_damage_divine * (1 + expected_damage_bonus / 100);
                divine_weapon_bonus = expected_damage_bonus;
                LOG_CAT("⚔️✨ Божественное оружие: +" + string(expected_damage_bonus) + "% урона для " + string(object_index), "combat");
            }
        }
    }
    
    var expected_self_reduction = divine_weapon_layers * divine_weapon_self_reduction_per_layer;
    if (damage_reduction_percent != expected_self_reduction + (defense_stacks > 0 ? defense_stacks : 0)) {
        damage_reduction_percent = expected_self_reduction + (defense_stacks > 0 ? defense_stacks : 0);
        LOG_CAT("⚔️✨ Божественное оружие: -" + string(expected_self_reduction) + "% урона паладину", "combat");
    }
}

switch (state) {
    case STATE_MOVING:
        hero_state_moving(id);
        break;
    case STATE_FIGHTING:
        hero_state_fighting(id);
        break;
    case STATE_IDLE:
        hero_state_idle(id);
        break;
    case STATE_MERGING:
        hero_state_merging(id);
        break;
}
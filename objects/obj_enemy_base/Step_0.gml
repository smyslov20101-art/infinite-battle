/// Step Event - obj_enemy_base (родитель всех врагов)

// Получаем контроллер для проверки состояния игры
var controller = instance_find(obj_game_controller, 0);

// ЕСЛИ ИГРА НА ПАУЗЕ ИЛИ ОКОНЧЕНА - НИЧЕГО НЕ ДЕЛАЕМ
if (instance_exists(controller)) {
    if (controller.controller_state == controller.CONTROLLER_STATE_PAUSE || 
        controller.game_over) {
        exit;
    }
}

// ===== СВЯТОЕ ОТРАВЛЕНИЕ (ARCHMAGE) =====
if (variable_instance_exists(id, "holy_poison_timer") && holy_poison_timer > 0) {
    holy_poison_timer -= 1 / room_speed;
    if (!variable_instance_exists(id, "holy_poison_damage_timer")) {
        holy_poison_damage_timer = 0;
    }
    holy_poison_damage_timer -= 1 / room_speed;
    if (holy_poison_damage_timer <= 0 && holy_poison_damage > 0) {
        hp -= holy_poison_damage;
        LOG_CAT("☠️ СВЯТОЕ ОТРАВЛЕНИЕ: -" + string(holy_poison_damage) + " HP, осталось: " + string(floor(hp)), "combat");
        holy_poison_damage_timer = 1.0;
        
        // Проверяем, не умер ли враг
        if (hp <= 0) {
            LOG_CAT("💀 ВРАГ УМЕР ОТ СВЯТОГО ОТРАВЛЕНИЯ!", "combat");
            alive = false;
            var enemy_type_lower = string_lower(enemy_type);
            if (enemy_type_lower == "miniboss") {
                scr_miniboss_die(id);
            } else if (enemy_type_lower == "boss") {
                boss_die(id);
            } else {
                enemy_die(id);
            }
            exit;
        }
    }
}

// ===== ОПУТЫВАНИЕ ЛОЗОЙ (ENTANGLE) =====
if (variable_instance_exists(id, "entangle_timer") && entangle_timer > 0) {
    entangle_timer -= 1 / room_speed;
    if (entangle_timer > 0) {
        exit;
    }
}

// ===== ПРОКЛЯТЬЕ (CURSE) - увеличение получаемого урона =====
if (variable_instance_exists(id, "curse_timer") && curse_timer > 0) {
    curse_timer -= 1 / room_speed;
    if (curse_timer <= 0) {
        curse_damage_mult = 1.0;
    }
}

// ===== ЛЕД (ICE) - периодический урон =====
if (variable_instance_exists(id, "ice_timer") && ice_timer > 0) {
    ice_timer -= 1 / room_speed;
    if (!variable_instance_exists(id, "ice_damage_timer")) {
        ice_damage_timer = 0;
    }
    ice_damage_timer -= 1 / room_speed;
    
    if (ice_damage_timer <= 0) {
        if (variable_instance_exists(id, "ice_damage_per_tick") && ice_damage_per_tick > 0) {
            hp -= ice_damage_per_tick;
            LOG_CAT("🧊 ЛЕД: -" + string(ice_damage_per_tick) + " HP, осталось: " + string(floor(hp)), "combat");
        }
        ice_damage_timer = 1.0;
    }
}

// ===== БОЛЬШОЕ КРОВОТЕЧЕНИЕ (BIG BLEED) =====
if (variable_instance_exists(id, "big_bleed_timer") && big_bleed_timer > 0) {
    big_bleed_timer -= 1 / room_speed;
    if (big_bleed_timer <= 0) {
        big_bleed_damage = 0;
    } else {
        if (!variable_instance_exists(id, "big_bleed_damage_timer")) {
            big_bleed_damage_timer = 0;
        }
        big_bleed_damage_timer -= 1 / room_speed;
        if (big_bleed_damage_timer <= 0) {
            hp -= big_bleed_damage;
            LOG_CAT("🩸💥 БОЛЬШОЕ КРОВОТЕЧЕНИЕ: -" + string(big_bleed_damage) + 
                      " HP, осталось: " + string(floor(hp)), "combat");
            big_bleed_damage_timer = 1.0;
        }
    }
}

// ===== ВОССТАНОВЛЕНИЕ ПОСЛЕ ТЕМНОГО МЕЧА (скорость врага) =====
if (variable_instance_exists(id, "dark_blade_timer") && dark_blade_timer > 0) {
    dark_blade_timer -= 1 / room_speed;
    if (dark_blade_timer <= 0) {
        if (variable_instance_exists(id, "original_attack_speed")) {
            attack_speed = original_attack_speed;
            if (variable_instance_exists(id, "attack_cooldown_max")) {
                attack_cooldown_max = 1 / attack_speed;
            }
            LOG_CAT("🗡️🌑 Враг восстановил скорость атаки после темного меча", "combat");
        }
        dark_blade_timer = 0;
    }
}

// ===== ЗАМЕДЛЕНИЕ АТАКИ (восстановление скорости) =====
if (variable_instance_exists(id, "attack_speed_slow_timer") && attack_speed_slow_timer > 0) {
    attack_speed_slow_timer -= 1 / room_speed;
    if (attack_speed_slow_timer <= 0) {
        attack_speed = original_attack_speed;
    }
}

// ===== СГЛАЗ (HEX) - обновление таймера =====
if (variable_instance_exists(id, "hex_timer") && hex_timer > 0) {
    hex_timer -= 1 / room_speed;
    if (hex_timer <= 0) {
        hex_damage_mult = 1.0;
    }
}

// ===== ПРОКЛЯТЬЕ (CURSE) - увеличение получаемого урона =====
if (variable_instance_exists(id, "curse_timer") && curse_timer > 0) {
    curse_timer -= 1 / room_speed;
    if (curse_timer <= 0) {
        curse_damage_mult = 1.0;
    }
}

// ===== ОГЛУШЕНИЕ (STUN) =====
if (variable_instance_exists(id, "stun_timer") && stun_timer > 0) {
    stun_timer -= 1 / room_speed;
    if (stun_timer > 0) {
        exit;
    }
}

// ===== ВОССТАНОВЛЕНИЕ СКОРОСТИ ДВИЖЕНИЯ =====
if (variable_instance_exists(id, "move_speed_slow_timer") && move_speed_slow_timer > 0) {
    move_speed_slow_timer -= 1 / room_speed;
    if (move_speed_slow_timer <= 0) {
        if (variable_instance_exists(id, "original_move_speed")) {
            move_speed = original_move_speed;
            LOG_CAT("❄️ Замедление движения прошло, скорость восстановлена", "combat");
        }
        move_speed_slow_timer = 0;
    }
}

// Проверяем жив ли враг
if (!alive) exit;

// ===== ОБРАБОТКА КРОВОТЕЧЕНИЯ (BLEED) =====
if (variable_instance_exists(id, "bleed_stacks") && bleed_stacks > 0) {
    if (!variable_instance_exists(id, "bleed_timer")) {
        bleed_timer = 0;
    }
    
    if (!variable_instance_exists(id, "bleed_damage_per_stack")) {
        bleed_damage_per_stack = 0;
    }
    
    bleed_timer -= 1 / room_speed;
    
    if (bleed_timer <= 0) {
        var bleed_total_damage = bleed_stacks * bleed_damage_per_stack;
        
        if (bleed_total_damage > 0) {
            hp -= bleed_total_damage;
            
            LOG_CAT("🩸 КРОВОТЕЧЕНИЕ: -" + string(bleed_total_damage) + " HP, стеков: " + string(bleed_stacks) + 
                      ", урон/стек: " + string(bleed_damage_per_stack) + 
                      ", осталось HP: " + string(floor(hp)) + "/" + string(max_hp), "bleed");
        }
        
        // Проверяем, не умер ли враг
        if (hp <= 0) {
            LOG_CAT("💀 ВРАГ УМЕР ОТ КРОВОТЕЧЕНИЯ!", "bleed");
            alive = false;
            
            var enemy_type_lower = string_lower(enemy_type);
            if (enemy_type_lower == "miniboss") {
                scr_miniboss_die(id);
            } else if (enemy_type_lower == "boss") {
                boss_die(id);
            } else {
                enemy_die(id);
            }
        }
        
        bleed_timer = 1.0;
    }
}

// ===== ОБРАБОТКА ГОРЕНИЯ (BURN) - раз в 2 секунды =====
if (variable_instance_exists(id, "burn_stacks") && burn_stacks > 0) {
    if (!variable_instance_exists(id, "burn_timer")) {
        burn_timer = 0;
    }
    
    if (!variable_instance_exists(id, "burn_damage_per_stack")) {
        burn_damage_per_stack = 0;
    }
    
    burn_timer -= 1 / room_speed;
    
    if (burn_timer <= 0) {
        var burn_total_damage = burn_stacks * burn_damage_per_stack;
        
        if (burn_total_damage > 0) {
            hp -= burn_total_damage;
            
            LOG_CAT("🔥 ГОРЕНИЕ: -" + string(burn_total_damage) + " HP, стеков: " + string(burn_stacks) + 
                      ", урон/стек: " + string(burn_damage_per_stack) + 
                      ", осталось HP: " + string(floor(hp)) + "/" + string(max_hp), "combat");
        }
        
        // Проверяем, не умер ли враг
        if (hp <= 0) {
            LOG_CAT("💀 ВРАГ УМЕР ОТ ГОРЕНИЯ!", "combat");
            alive = false;
            
            var enemy_type_lower = string_lower(enemy_type);
            if (enemy_type_lower == "miniboss") {
                scr_miniboss_die(id);
            } else if (enemy_type_lower == "boss") {
                boss_die(id);
            } else {
                enemy_die(id);
            }
        }
        
        burn_timer = 2.0;
    }
}

// ===== ОБНОВЛЕНИЕ ТАЙМЕРОВ =====
if (damage_cooldown > 0) damage_cooldown -= 1 / room_speed;
if (attack_timer > 0) attack_timer -= 1 / room_speed;

// ===== ОБРАБОТКА СОСТОЯНИЯ ВРАГА =====
var enemy_type_lower = string_lower(enemy_type);

switch (state) {
    case ENEMY_STATE_MOVING:
        if (enemy_type_lower == "archer") {
            enemy_state_moving(id);
        } else if (enemy_type_lower == "miniboss") {
            miniboss_state_moving(id);
        } else if (enemy_type_lower == "boss") {
            boss_state_moving(id);
        } else {
            enemy_state_moving(id);
        }
        break;
        
    case ENEMY_STATE_ATTACKING:
        if (enemy_type_lower == "archer") {
            enemy_state_attacking(id);
        } else if (enemy_type_lower == "miniboss") {
            miniboss_state_attacking(id);
        } else if (enemy_type_lower == "boss") {
            boss_state_attacking(id);
        } else {
            enemy_state_attacking(id);
        }
        break;
        
    case ENEMY_STATE_IDLE:
        enemy_state_idle(id);
        break;
        
    case ENEMY_STATE_DEAD:
        break;
}
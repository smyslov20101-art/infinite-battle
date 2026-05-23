/// Step Event - obj_hero_base (родитель всех героев)

// Получаем контроллер для проверки состояния игры
var controller = instance_find(obj_game_controller, 0);

// Если игра на паузе или окончена - ничего не делаем
if (instance_exists(controller)) {
    if (controller.controller_state == controller.CONTROLLER_STATE_PAUSE || 
        controller.game_over) {
        exit;
    }
}

// ===== РЕГЕНЕРАЦИЯ (REGEN) - для всех героев =====
if (variable_instance_exists(id, "regen_per_second") && regen_per_second > 0) {
    if (!variable_instance_exists(id, "regen_timer")) {
        regen_timer = 0;
    }
    
    regen_timer -= 1 / room_speed;
    
    if (regen_timer <= 0) {
        var old_hp = hp;
        hp = min(max_hp, hp + regen_per_second);
        var healed = hp - old_hp;
        
        if (healed > 0) {
            LOG_CAT("💚 Регенерация: +" + string(healed) + " HP", "combat");
        }
        
        regen_timer = 1.0;
    }
}

// ===== ВОССТАНОВЛЕНИЕ ПОСЛЕ БАФФА ДРУИДА (увеличение HP) =====
if (variable_instance_exists(id, "druid_buff_timer") && druid_buff_timer > 0) {
    druid_buff_timer -= 1 / room_speed;
    if (druid_buff_timer <= 0) {
        if (variable_instance_exists(id, "druid_buff_hp_bonus") && druid_buff_hp_bonus > 0) {
            max_hp -= druid_buff_hp_bonus;
            hp = min(max_hp, hp);
            LOG_CAT("💪🌿 Бафф друида закончился, макс HP восстановлен до " + string(max_hp), "combat");
            druid_buff_hp_bonus = 0;
        }
    }
}

// ===== ЗАЩИТА ДРУИДА (уклонение + снижение урона) =====
if (variable_instance_exists(id, "protect_melee_active") && protect_melee_active) {
    protect_melee_timer -= 1 / room_speed;
    if (protect_melee_timer <= 0) {
        if (variable_instance_exists(id, "dodge_chance")) {
            dodge_chance -= protect_melee_dodge_bonus;
        }
        if (variable_instance_exists(id, "damage_reduction_percent")) {
            damage_reduction_percent -= protect_melee_dr_bonus;
        }
        protect_melee_active = false;
        LOG_CAT("🛡️ Защита друида закончилась для " + string(object_index), "combat");
    }
}

// ===== АУРА УКЛОНЕНИЯ ОТ ДРУИДА (снятие баффа) =====
if (variable_instance_exists(id, "dodge_aura_bonus") && dodge_aura_bonus > 0) {
    var druid_active = false;
    if (instance_exists(obj_druid)) {
        var druid = instance_find(obj_druid, 0);
        if (instance_exists(druid) && druid.dodge_aura_timer > 0) {
            druid_active = true;
        }
    }
    
    if (!druid_active) {
        if (variable_instance_exists(id, "dodge_chance")) {
            dodge_chance -= dodge_aura_bonus;
        }
        dodge_aura_bonus = 0;
        LOG_CAT("🌀🌿 Аура уклонения закончилась для " + string(object_index), "combat");
    }
}

// ===== АУРА СНИЖЕНИЯ УРОНА ОТ ДРУИДА (снятие баффа) =====
if (variable_instance_exists(id, "dr_aura_bonus") && dr_aura_bonus > 0) {
    var druid_active = false;
    if (instance_exists(obj_druid)) {
        var druid = instance_find(obj_druid, 0);
        if (instance_exists(druid) && druid.dr_aura_timer > 0) {
            druid_active = true;
        }
    }
    
    if (!druid_active) {
        if (variable_instance_exists(id, "damage_reduction_percent")) {
            damage_reduction_percent -= dr_aura_bonus;
        }
        dr_aura_bonus = 0;
        LOG_CAT("🛡️🌿 Аура снижения урона закончилась для " + string(object_index), "combat");
    }
}

// ===== ЭФФЕКТЫ ОТ ЖРЕЦА =====
// Восстановление урона мага после баффа
if (variable_instance_exists(id, "mage_buff_timer") && mage_buff_timer > 0) {
    mage_buff_timer -= 1 / room_speed;
    if (mage_buff_timer <= 0) {
        if (variable_instance_exists(id, "original_damage_for_buff")) {
            damage = original_damage_for_buff;
            LOG_CAT("✨ Бафф мага закончился, урон восстановлен до " + string(damage), "combat");
        }
        mage_buff_timer = 0;
    }
}

// Восстановление скорости атаки лучника после баффа
if (variable_instance_exists(id, "archer_buff_timer") && archer_buff_timer > 0) {
    archer_buff_timer -= 1 / room_speed;
    if (archer_buff_timer <= 0) {
        if (variable_instance_exists(id, "original_attack_speed_for_buff")) {
            attack_speed = original_attack_speed_for_buff;
            attack_timer = min(attack_timer, 1 / attack_speed);
            LOG_CAT("🏹✨ Бафф лучника закончился, скорость атаки восстановлена до " + string(attack_speed), "combat");
        }
        archer_buff_timer = 0;
    }
}

// ===== ОБНОВЛЕНИЕ ОСНОВНЫХ ТАЙМЕРОВ =====
if (attack_timer > 0) attack_timer -= 1 / room_speed;
if (damage_cooldown > 0) damage_cooldown -= 1 / room_speed;

// ===== ЭФФЕКТ ПОДСВЕТКИ ПРИ ПОЛУЧЕНИИ УРОНА =====
if (variable_instance_exists(id, "damage_flash_timer") && damage_flash_timer > 0) {
    damage_flash_timer -= 1 / room_speed;
    if (damage_flash_timer <= 0) {
        image_blend = c_white;
    } else {
        if (floor(damage_flash_timer * 10) % 2 == 0) {
            image_blend = c_red;
        } else {
            image_blend = c_white;
        }
    }
}
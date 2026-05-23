/// Step Event - obj_berserker
event_inherited();

if (state == STATE_DEAD || hp <= 0) exit;

if (variable_instance_exists(id, "temp_armor_timer") && temp_armor_timer > 0) {
    temp_armor_timer -= 1 / room_speed;
    if (temp_armor_timer <= 0) {
        temp_armor = 0;
        LOG_CAT("🛡️⚡ Временная броня закончилась", "combat");
    }
}

// ===== ПРОВЕРКА ЯРОСТИ =====
// Раньше эта логика лежала в scr_berserker_state_idle, но когда берсерка перевели
// на общий hero_state_idle — её забыли перенести. Теперь живёт здесь и работает
// независимо от состояния (idle/moving/fighting).
rage_check_timer -= 1 / room_speed;
if (rage_check_timer <= 0) {
    rage_check_timer = rage_check_interval;

    var enemy_count = instance_number(obj_enemy_base);

    var has_boss = false;
    with (obj_enemy_base) {
        if (enemy_type == "boss" || enemy_type == "miniboss") {
            has_boss = true;
            break;
        }
    }

    var should_rage = (enemy_count >= 4 || has_boss);

    if (should_rage && !rage_active) {
        rage_active = true;
        var speed_mult = 1 + (rage_attack_speed_bonus / 100);
        attack_speed = original_attack_speed * speed_mult;
        var damage_mult = 1 + (rage_damage_bonus / 100);
        damage = original_damage * damage_mult;
        LOG_CAT("💢 ЯРОСТЬ АКТИВИРОВАНА! Врагов: " + string(enemy_count) +
                ", босс: " + string(has_boss) +
                ", скор. атаки: " + string(attack_speed) + ", урон: " + string(damage), "combat");
    } else if (!should_rage && rage_active) {
        rage_active = false;
        attack_speed = original_attack_speed;
        damage = original_damage;
        LOG_CAT("💢 ЯРОСТЬ ДЕАКТИВИРОВАНА! Скорость: " + string(attack_speed) +
                ", урон: " + string(damage), "combat");
    }
}

if (state == STATE_MERGING && !instance_exists(merge_target)) {
    state = STATE_IDLE;
    merge_target = noone;
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
/// Step Event - obj_tank
event_inherited();

if (state == STATE_DEAD || hp <= 0) exit;

// Регенерация брони
if (armor_regen > 0) {
    if (!variable_instance_exists(id, "armor_regen_timer")) armor_regen_timer = 0;
    armor_regen_timer -= 1 / room_speed;
    if (armor_regen_timer <= 0) {
        var old_armor = armor;
        armor += armor_regen;
        LOG_CAT("🔧 Танк восстановил броню: +" + string(armor_regen) + " (было " + string(old_armor) + " → " + string(armor) + ")", "combat");
        armor_regen_timer = 2.0;
    }
}

// Восстановление щита
if (shield < max_shield) {
    if (!variable_instance_exists(id, "shield_regen_timer")) shield_regen_timer = 0;
    shield_regen_timer -= 1 / room_speed;
    if (shield_regen_timer <= 0) {
        var base_regen = max_shield * 0.05;
        var speed_bonus = 1 + (shield_regen_speed / 100);
        var regen_amount = max(1, floor(base_regen * speed_bonus));
        var old_shield = shield;
        shield = min(max_shield, shield + regen_amount);
        if (shield > old_shield) {
            LOG_CAT("🛡️ Танк восстановил щит: +" + string(shield - old_shield) + " (теперь " + string(shield) + "/" + string(max_shield) + ")", "combat");
        }
        shield_regen_timer = 2.0;
    }
}

if (state == STATE_MERGING && !instance_exists(merge_target)) {
    state = STATE_IDLE;
    merge_target = noone;
}

switch (state) {
    case STATE_MOVING:
        // Используем общий moving — логика идентична tank-специфичной.
        hero_state_moving(id);
        break;
    case STATE_FIGHTING:
        tank_state_fighting(id);
        break;
    case STATE_IDLE:
        tank_state_idle(id);
        break;
    case STATE_MERGING:
        hero_state_merging(id);
        break;
}
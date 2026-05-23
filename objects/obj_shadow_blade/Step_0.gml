/// Step Event - obj_shadow_blade
event_inherited();

if (state == STATE_DEAD || hp <= 0) exit;

if (variable_instance_exists(id, "self_speed_timer") && self_speed_timer > 0) {
    self_speed_timer -= 1 / room_speed;
    if (self_speed_timer <= 0) {
        if (variable_instance_exists(id, "original_attack_speed")) {
            attack_speed = original_attack_speed;
            LOG_CAT("🗡️🌑 Эффект темного меча закончился, скорость атаки восстановлена", "combat");
        }
        self_speed_timer = 0;
    }
}

if (variable_instance_exists(id, "illusion_timer") && illusion_timer > 0) {
    illusion_timer -= 1 / room_speed;
    if (illusion_timer <= 0) {
        illusion_active = false;
        if (variable_instance_exists(id, "original_dodge_chance")) {
            dodge_chance = original_dodge_chance;
            LOG_CAT("🛡️👻 Иллюзия доспеха закончилась, уклонение восстановлено", "combat");
        }
        illusion_timer = 0;
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
        hero_state_fighting(id);  // dark_blade перенесён в общий через if (hero_type == "shadow_blade")
        break;
    case STATE_IDLE:
        hero_state_idle(id);
        break;
    case STATE_MERGING:
        hero_state_merging(id);
        break;
}
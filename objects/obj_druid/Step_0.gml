/// Step Event - obj_druid
event_inherited();

if (state == STATE_DEAD || hp <= 0) exit;

if (state == STATE_MERGING && !instance_exists(merge_target)) {
    state = STATE_IDLE;
    merge_target = noone;
}

// ===== ОБНОВЛЕНИЕ ТАЙМЕРОВ АУР ДРУИДА (С ПРОВЕРКАМИ!) =====
if (variable_instance_exists(id, "heal_aura_timer") && heal_aura_timer > 0) heal_aura_timer -= 1 / room_speed;
if (variable_instance_exists(id, "heal_aura_cooldown") && heal_aura_cooldown > 0) heal_aura_cooldown -= 1 / room_speed;
if (variable_instance_exists(id, "dodge_aura_timer") && dodge_aura_timer > 0) dodge_aura_timer -= 1 / room_speed;
if (variable_instance_exists(id, "dodge_aura_cooldown") && dodge_aura_cooldown > 0) dodge_aura_cooldown -= 1 / room_speed;
if (variable_instance_exists(id, "dr_aura_timer") && dr_aura_timer > 0) dr_aura_timer -= 1 / room_speed;
if (variable_instance_exists(id, "dr_aura_cooldown") && dr_aura_cooldown > 0) dr_aura_cooldown -= 1 / room_speed;
if (variable_instance_exists(id, "druid_buff_melee_cooldown") && druid_buff_melee_cooldown > 0) druid_buff_melee_cooldown -= 1 / room_speed;
if (variable_instance_exists(id, "last_stand_cooldown") && last_stand_cooldown > 0) last_stand_cooldown -= 1 / room_speed;
if (variable_instance_exists(id, "save_melee_cooldown") && save_melee_cooldown > 0) save_melee_cooldown -= 1 / room_speed;
if (variable_instance_exists(id, "protect_melee_cooldown") && protect_melee_cooldown > 0) protect_melee_cooldown -= 1 / room_speed;

switch (state) {
    case STATE_MOVING:
        hero_state_moving(id);
        break;
    case STATE_FIGHTING:
        hero_state_fighting(id);
        break;
    case STATE_IDLE:
        druid_state_idle(id);
        break;
    case STATE_MERGING:
        hero_state_merging(id);
        break;
}
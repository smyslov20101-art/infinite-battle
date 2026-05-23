/// Step Event - obj_healer
event_inherited();

if (state == STATE_DEAD || hp <= 0) exit;

if (state == STATE_MERGING && !instance_exists(merge_target)) {
    state = STATE_IDLE;
    merge_target = noone;
}

switch (state) {
    case STATE_MOVING:
        healer_state_moving(id);
        break;
    case STATE_IDLE:
        healer_state_idle(id);
        break;
    case STATE_MERGING:
        hero_state_merging(id);
        break;
}
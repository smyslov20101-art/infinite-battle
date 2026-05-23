/// Step Event - obj_archmage
event_inherited();

if (state == STATE_DEAD || hp <= 0) exit;

// ===== РЕГЕНЕРАЦИЯ В % =====
if (regen_percent > 0) {
    if (!variable_instance_exists(id, "regen_percent_timer")) regen_percent_timer = 0;
    regen_percent_timer -= 1 / room_speed;
    if (regen_percent_timer <= 0) {
        var heal_amount = floor(max_hp * regen_percent / 100);
        if (heal_amount > 0) {
            hp = min(max_hp, hp + heal_amount);
            LOG_CAT("💚 Архимаг: регенерация +" + string(heal_amount) + " HP (" + string(regen_percent) + "%)", "combat");
        }
        regen_percent_timer = 1.0;
    }
}

// ===== АЙСБЕРГ =====
if (iceberg_damage > 0) {
    if (iceberg_cooldown > 0) iceberg_cooldown -= 1 / room_speed;
    if (iceberg_cooldown <= 0) {
        // Создаём айсберг над врагами
        var iceberg = instance_create_layer(x - 100, y - 200, "Instances", obj_iceberg);
        with (iceberg) {
            damage = other.iceberg_damage;
            attack_speed_slow = other.iceberg_slow;
        }
        iceberg_cooldown = iceberg_cooldown_max;
        LOG_CAT("🧊 АРХИМАГ: Айсберг! Урон " + string(iceberg_damage) + ", КД " + string(iceberg_cooldown_max) + " сек", "combat");
    }
}

// ===== ПРОКЛЯТЬЕ =====
if (curse_damage_mult > 0) {
    if (curse_cooldown > 0) curse_cooldown -= 1 / room_speed;
    if (curse_cooldown <= 0) {
        var curse = instance_create_layer(x, y, "Instances", obj_curse);
        with (curse) {
            damage_mult = other.curse_damage_mult;
        }
        curse_cooldown = curse_cooldown_max;
        LOG_CAT("👁️ АРХИМАГ: Проклятье! +" + string(curse_damage_mult) + "% урона, КД " + string(curse_cooldown_max) + " сек", "combat");
    }
}

// ===== ПЕСНЬ ДУШИ =====
if (song_of_soul_bonus > 0) {
    if (song_of_soul_cooldown > 0) song_of_soul_cooldown -= 1 / room_speed;
    if (song_of_soul_cooldown <= 0 && !song_of_soul_active) {
        song_of_soul_active = true;
        song_of_soul_timer = 5.0;
        song_of_soul_cooldown = song_of_soul_cooldown_max;
        
        // Применяем бафф ко всем магам
        with (obj_hero_base) {
            if (hero_class == global.CLASS_MAGE && hp > 0 && state != STATE_DEAD) {
                if (!variable_instance_exists(id, "song_of_soul_bonus_active")) {
                    song_of_soul_bonus_active = 0;
                    original_attack_speed_song = attack_speed;
                }
                attack_speed = original_attack_speed_song * (1 + other.song_of_soul_bonus / 100);
                song_of_soul_bonus_active = other.song_of_soul_bonus;
                LOG_CAT("🎵 ПЕСНЬ ДУШИ! +" + string(other.song_of_soul_bonus) + "% скор. атаки для " + string(object_index), "combat");
            }
        }
        LOG_CAT("🎵 АРХИМАГ: Песнь души! +" + string(song_of_soul_bonus) + "% скор. атаки магам на 5 сек", "combat");
    }
}

if (song_of_soul_active) {
    song_of_soul_timer -= 1 / room_speed;
    if (song_of_soul_timer <= 0) {
        song_of_soul_active = false;
        // Снимаем бафф
        with (obj_hero_base) {
            if (hero_class == global.CLASS_MAGE && hp > 0 && state != STATE_DEAD) {
                if (variable_instance_exists(id, "original_attack_speed_song")) {
                    attack_speed = original_attack_speed_song;
                }
                song_of_soul_bonus_active = 0;
                LOG_CAT("🎵 Песнь души закончилась для " + string(object_index), "combat");
            }
        }
    }
}

// ===== ВОЛЯ СЛУЧАЯ =====
if (will_of_chance_bonus > 0) {
    if (will_of_chance_cooldown > 0) will_of_chance_cooldown -= 1 / room_speed;
    if (will_of_chance_cooldown <= 0 && !will_of_chance_active) {
        will_of_chance_active = true;
        will_of_chance_timer = 5.0;
        will_of_chance_cooldown = will_of_chance_cooldown_max;
        
        // Применяем бафф ко всем магам
        with (obj_hero_base) {
            if (hero_class == global.CLASS_MAGE && hp > 0 && state != STATE_DEAD) {
                if (!variable_instance_exists(id, "will_of_chance_bonus_active")) {
                    will_of_chance_bonus_active = 0;
                    original_crit_chance = crit_chance;
                }
                crit_chance = original_crit_chance + other.will_of_chance_bonus;
                will_of_chance_bonus_active = other.will_of_chance_bonus;
                LOG_CAT("🎲 ВОЛЯ СЛУЧАЯ! +" + string(other.will_of_chance_bonus) + "% шанс крита для " + string(object_index), "combat");
            }
        }
        LOG_CAT("🎲 АРХИМАГ: Воля случая! +" + string(will_of_chance_bonus) + "% шанс крита магам на 5 сек", "combat");
    }
}

if (will_of_chance_active) {
    will_of_chance_timer -= 1 / room_speed;
    if (will_of_chance_timer <= 0) {
        will_of_chance_active = false;
        with (obj_hero_base) {
            if (hero_class == global.CLASS_MAGE && hp > 0 && state != STATE_DEAD) {
                if (variable_instance_exists(id, "original_crit_chance")) {
                    crit_chance = original_crit_chance;
                }
                will_of_chance_bonus_active = 0;
                LOG_CAT("🎲 Воля случая закончилась для " + string(object_index), "combat");
            }
        }
    }
}

// ===== ФЕНИКС (перо) =====
if (phoenix_bonus > 0) {
    if (phoenix_timer > 0) phoenix_timer -= 1 / room_speed;
    if (phoenix_timer <= 0) {
        // Собираем всех живых героев
        var heroes_list = [];
        with (obj_hero_base) {
            if (hp > 0 && state != STATE_DEAD) {
                array_push(heroes_list, id);
            }
        }
        if (array_length(heroes_list) > 0) {
            var random_hero = heroes_list[irandom(array_length(heroes_list) - 1)];
            var feather = instance_create_layer(x, y, "Instances", obj_phoenix_feather);
            with (feather) {
                target_hero = random_hero;
                attack_speed_bonus = other.phoenix_bonus;
            }
            LOG_CAT("🪶 ФЕНИКС! Перо летит к герою", "combat");
        }
        phoenix_timer = phoenix_cooldown_max;
    }
}

// ===== ДРАКОН (чешуя) =====
if (dragon_bonus > 0) {
    if (dragon_timer > 0) dragon_timer -= 1 / room_speed;
    if (dragon_timer <= 0) {
        var heroes_list = [];
        with (obj_hero_base) {
            if (hp > 0 && state != STATE_DEAD) {
                array_push(heroes_list, id);
            }
        }
        if (array_length(heroes_list) > 0) {
            var random_hero = heroes_list[irandom(array_length(heroes_list) - 1)];
            var scale = instance_create_layer(x, y, "Instances", obj_dragon_scale);
            with (scale) {
                target_hero = random_hero;
                damage_bonus_percent = other.dragon_bonus;
            }
            LOG_CAT("🐉 ДРАКОН! Чешуя летит к герою", "combat");
        }
        dragon_timer = dragon_cooldown_max;
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
        archmage_state_fighting(id);
        break;
    case STATE_IDLE:
        archmage_state_idle(id);
        break;
    case STATE_MERGING:
        hero_state_merging(id);
        break;
}
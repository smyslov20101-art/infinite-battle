/// @function scr_apply_class_onhit(_attacker, _target)
/// @desc Класс-специфичные эффекты при попадании по врагу.
///       Вызывается И из STATE_FIGHTING, И из STATE_IDLE — раньше эти эффекты были
///       только в fighting, поэтому почти не срабатывали (герой ближнего боя
///       почти всё время бьёт из idle, стоя на своей позиции).
///       Сейчас здесь: метки правосудия паладина, головокружение паладина,
///       темный меч мечника теней. Новые классовые on-hit эффекты добавлять СЮДА.
/// @param {Id.Instance} _attacker  герой, который ударил
/// @param {Id.Instance} _target    враг, которого ударили

function scr_apply_class_onhit(_attacker, _target) {
    if (!instance_exists(_attacker)) return;
    if (!instance_exists(_target)) return;

    with (_attacker) {
        var _t = _target;

        // ===== ПАЛАДИН: МЕТКА ПРАВОСУДИЯ =====
        if (hero_type == "paladin" && variable_instance_exists(id, "justice_mark_chance") && justice_mark_chance > 0) {
            var mark_roll = random(100);
            if (mark_roll < justice_mark_chance) {
                if (!variable_instance_exists(id, "attack_counter")) attack_counter = 0;
                attack_counter++;

                if (attack_counter % 2 == 0) {
                    if (!variable_instance_exists(_t, "justice_marks")) {
                        _t.justice_marks = 0;
                        _t.justice_mark_timer = 0;
                    }
                    if (_t.justice_marks < justice_mark_max_stacks) {
                        _t.justice_marks++;
                        _t.justice_mark_timer = 5.0;
                        if (!variable_instance_exists(_t, "justice_mark_damage_mult")) {
                            _t.justice_mark_damage_mult = 1.0;
                        }
                        _t.justice_mark_damage_mult = 1 + (_t.justice_marks * justice_mark_damage_bonus / 100);
                        LOG_CAT("⚖️🔖 МЕТКА ПРАВОСУДИЯ! Стеков: " + string(_t.justice_marks), "combat");
                    }
                }
            }
        }

        // ===== ПАЛАДИН: ГОЛОВОКРУЖЕНИЕ =====
        if (hero_type == "paladin" && variable_instance_exists(id, "dizziness_chance") && dizziness_chance > 0) {
            var dizzy_roll = random(100);
            if (dizzy_roll < dizziness_chance) {
                if (!variable_instance_exists(id, "dizziness_attack_counter")) dizziness_attack_counter = 0;
                dizziness_attack_counter++;

                if (dizziness_attack_counter % 3 == 0) {
                    var targets = [];
                    with (obj_enemy_base) {
                        if (alive && hp > 0) {
                            var dist = point_distance(x, y, other.x, other.y);
                            array_push(targets, {id: id, dist: dist});
                        }
                    }
                    for (var i = 0; i < array_length(targets) - 1; i++) {
                        for (var j = i + 1; j < array_length(targets); j++) {
                            if (targets[i].dist > targets[j].dist) {
                                var temp = targets[i];
                                targets[i] = targets[j];
                                targets[j] = temp;
                            }
                        }
                    }
                    var dizzy_count = min(2, array_length(targets));
                    for (var i = 0; i < dizzy_count; i++) {
                        var target = targets[i].id;
                        if (instance_exists(target)) {
                            if (!variable_instance_exists(target, "dizziness_timer")) target.dizziness_timer = 0;
                            target.dizziness_timer = dizziness_duration;
                            if (!variable_instance_exists(target, "dizziness_damage_reduction_timer")) {
                                target.dizziness_damage_reduction_timer = 0;
                                target.dizziness_damage_mult = 1.0;
                            }
                            target.dizziness_damage_reduction_timer = dizziness_slow_duration;
                            target.dizziness_damage_mult = 1 - (dizziness_damage_reduction / 100);
                            LOG_CAT("🌀😵 ГОЛОВОКРУЖЕНИЕ! Враг обездвижен, урон -" + string(dizziness_damage_reduction) + "%", "combat");
                        }
                    }
                }
            }
        }

        // ===== МЕЧНИК ТЕНЕЙ: ТЕМНЫЙ МЕЧ (похищение скорости атаки) =====
        if (hero_type == "shadow_blade" &&
            variable_instance_exists(id, "dark_blade_chance") && dark_blade_chance > 0 &&
            variable_instance_exists(id, "dark_blade_steal_percent") && dark_blade_steal_percent > 0) {
            var dark_roll = random(100);
            if (dark_roll < dark_blade_chance) {
                if (variable_instance_exists(_t, "attack_speed")) {
                    // Сохраняем оригинальную скорость врага, если ещё не сохранена
                    if (!variable_instance_exists(_t, "original_attack_speed")) {
                        _t.original_attack_speed = _t.attack_speed;
                    }
                    // Замедляем врага
                    var slow_mult = 1 - (dark_blade_steal_percent / 100);
                    _t.attack_speed = _t.original_attack_speed * slow_mult;
                    _t.attack_speed = max(0.2, _t.attack_speed);
                    if (variable_instance_exists(_t, "attack_cooldown_max")) {
                        _t.attack_cooldown_max = 1 / _t.attack_speed;
                    }
                    // Таймер восстановления у врага (3 сек)
                    if (!variable_instance_exists(_t, "dark_blade_timer")) {
                        _t.dark_blade_timer = 0;
                    }
                    _t.dark_blade_timer = 3.0;

                    // Ускоряем себя. ВАЖНО: original_attack_speed может быть не задан
                    // в scr_shadow_blade_init / scr_hero_base_init — инициализируем тут,
                    // иначе "variable not set before reading it" при первом срабатывании.
                    if (!variable_instance_exists(id, "original_attack_speed")) {
                        original_attack_speed = attack_speed;
                    }
                    var speed_mult = 1 + (dark_blade_steal_percent / 100);
                    attack_speed = original_attack_speed * speed_mult;
                    if (!variable_instance_exists(id, "self_speed_timer")) {
                        self_speed_timer = 0;
                    }
                    self_speed_timer = 3.0;

                    LOG_CAT("🗡️🌑 ТЕМНЫЙ МЕЧ! Похищено " + string(dark_blade_steal_percent) +
                            "% скорости атаки врага (шанс: " + string(dark_blade_chance) +
                            "%, выпало: " + string(dark_roll) + "%)", "combat");
                }
            }
        }
    }
}

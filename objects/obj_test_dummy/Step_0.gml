/// Step Event - obj_test_dummy

// Получаем контроллер
var controller = instance_find(obj_game_controller, 0);

// Если игра на паузе или окончена - ничего не делаем
if (instance_exists(controller)) {
    if (controller.controller_state == controller.CONTROLLER_STATE_PAUSE || 
        controller.game_over) {
        exit;
    }
}

// ===== ИНИЦИАЛИЗАЦИЯ БАЗОВЫХ ПЕРЕМЕННЫХ (ЕСЛИ НЕ СУЩЕСТВУЮТ) =====
if (!variable_instance_exists(id, "max_hp")) max_hp = 10000;
if (!variable_instance_exists(id, "hp")) hp = max_hp;
if (!variable_instance_exists(id, "damage")) damage = 50;
if (!variable_instance_exists(id, "attack_speed")) attack_speed = 0.2;
if (!variable_instance_exists(id, "attack_timer")) attack_timer = 0;
if (!variable_instance_exists(id, "attack_range")) attack_range = 80;
if (!variable_instance_exists(id, "move_speed")) move_speed = 2.0;
if (!variable_instance_exists(id, "attack_cooldown_max")) attack_cooldown_max = 1 / attack_speed;
if (!variable_instance_exists(id, "original_attack_speed")) original_attack_speed = attack_speed;
if (!variable_instance_exists(id, "is_ranged")) is_ranged = false;
if (!variable_instance_exists(id, "alive")) alive = true;
if (!variable_instance_exists(id, "enemy_type")) enemy_type = "test_dummy";
if (!variable_instance_exists(id, "show_health_bar")) show_health_bar = true;
if (!variable_instance_exists(id, "health_bar_width")) health_bar_width = 200;
if (!variable_instance_exists(id, "health_bar_height")) health_bar_height = 20;
if (!variable_instance_exists(id, "health_bar_offset_y")) health_bar_offset_y = -170;
if (!variable_instance_exists(id, "dummy_id")) dummy_id = 0;
if (!variable_instance_exists(id, "image_blend")) image_blend = c_gray;
if (!variable_instance_exists(id, "image_alpha")) image_alpha = 0.8;

// ===== ИНИЦИАЛИЗАЦИЯ ВСЕХ ПЕРЕМЕННЫХ ЭФФЕКТОВ (ЕСЛИ НЕ СУЩЕСТВУЮТ) =====
if (!variable_instance_exists(id, "bleed_stacks")) bleed_stacks = 0;
if (!variable_instance_exists(id, "bleed_timer")) bleed_timer = 0;
if (!variable_instance_exists(id, "bleed_damage_per_stack")) bleed_damage_per_stack = 0;

if (!variable_instance_exists(id, "burn_stacks")) burn_stacks = 0;
if (!variable_instance_exists(id, "burn_timer")) burn_timer = 0;
if (!variable_instance_exists(id, "burn_damage_per_stack")) burn_damage_per_stack = 0;

if (!variable_instance_exists(id, "ice_timer")) ice_timer = 0;
if (!variable_instance_exists(id, "ice_damage_per_tick")) ice_damage_per_tick = 0;
if (!variable_instance_exists(id, "ice_damage_timer")) ice_damage_timer = 0;

if (!variable_instance_exists(id, "entangle_timer")) entangle_timer = 0;
if (!variable_instance_exists(id, "hex_timer")) hex_timer = 0;
if (!variable_instance_exists(id, "hex_damage_mult")) hex_damage_mult = 1.0;
if (!variable_instance_exists(id, "stun_timer")) stun_timer = 0;

if (!variable_instance_exists(id, "big_bleed_timer")) big_bleed_timer = 0;
if (!variable_instance_exists(id, "big_bleed_damage")) big_bleed_damage = 0;
if (!variable_instance_exists(id, "big_bleed_damage_timer")) big_bleed_damage_timer = 0;

if (!variable_instance_exists(id, "attack_speed_slow_timer")) attack_speed_slow_timer = 0;
if (!variable_instance_exists(id, "move_speed_slow_timer")) move_speed_slow_timer = 0;

// Сохраняем оригинальные значения (после того как move_speed и attack_cooldown_max инициализированы)
if (!variable_instance_exists(id, "original_move_speed")) original_move_speed = move_speed;
if (!variable_instance_exists(id, "original_attack_cooldown")) original_attack_cooldown = attack_cooldown_max;

if (!variable_instance_exists(id, "debug_effect_timer")) debug_effect_timer = 0;

// Проверяем жив ли манекен
if (hp <= 0) {
    // Манекен умер - возрождаем с полным HP и сбрасываем все эффекты
    hp = max_hp;
    bleed_stacks = 0;
    bleed_timer = 0;
    bleed_damage_per_stack = 0;
    burn_stacks = 0;
    burn_timer = 0;
    burn_damage_per_stack = 0;
    ice_timer = 0;
    ice_damage_per_tick = 0;
    ice_damage_timer = 0;
    entangle_timer = 0;
    hex_timer = 0;
    hex_damage_mult = 1.0;
    stun_timer = 0;
    big_bleed_timer = 0;
    big_bleed_damage = 0;
    big_bleed_damage_timer = 0;
    attack_speed_slow_timer = 0;
    move_speed_slow_timer = 0;
    LOG("🔄 Манекен возрожден! HP: " + string(hp));
    exit;
}

// ===== ОБРАБОТКА ОГЛУШЕНИЯ (STUN) =====
if (stun_timer > 0) {
    stun_timer -= 1 / room_speed;
    if (stun_timer > 0) {
        // Если оглушен - не двигается и не атакует
        exit;
    }
}

// ===== ОБРАБОТКА ОПУТЫВАНИЯ (ENTANGLE) =====
if (entangle_timer > 0) {
    entangle_timer -= 1 / room_speed;
    if (entangle_timer > 0) {
        // Если опутан - не двигается и не атакует
        exit;
    }
}

// ===== ВОССТАНОВЛЕНИЕ СКОРОСТИ ДВИЖЕНИЯ ПОСЛЕ МОРОЗА =====
if (move_speed_slow_timer > 0) {
    move_speed_slow_timer -= 1 / room_speed;
    if (move_speed_slow_timer <= 0) {
        move_speed = original_move_speed;
        LOG_CAT("❄️ Замедление движения манекена прошло, скорость восстановлена", "combat");
        move_speed_slow_timer = 0;
    }
}

// ===== ВОССТАНОВЛЕНИЕ СКОРОСТИ АТАКИ ПОСЛЕ ЗАМЕДЛЕНИЯ =====
if (attack_speed_slow_timer > 0) {
    attack_speed_slow_timer -= 1 / room_speed;
    if (attack_speed_slow_timer <= 0) {
        attack_cooldown_max = original_attack_cooldown;
        LOG_CAT("🐢 Замедление атаки манекена прошло, скорость восстановлена", "combat");
        attack_speed_slow_timer = 0;
    }
}

// ===== ОБРАБОТКА КРОВОТЕЧЕНИЯ (BLEED) =====
if (bleed_stacks > 0) {
    bleed_timer -= 1 / room_speed;
    
    if (bleed_timer <= 0) {
        var bleed_total_damage = bleed_stacks * bleed_damage_per_stack;
        hp -= bleed_total_damage;
        
        LOG("🩸 ТЕСТОВЫЙ МАНЕКЕН: Кровотечение -" + string(bleed_total_damage) + 
                          " HP, стеков: " + string(bleed_stacks) + 
                          ", урон/стек: " + string(bleed_damage_per_stack) + 
                          ", осталось HP: " + string(floor(hp)) + "/" + string(max_hp));
        
        if (hp <= 0) {
            hp = max_hp;
            bleed_stacks = 0;
            bleed_timer = 0;
            bleed_damage_per_stack = 0;
            burn_stacks = 0;
            burn_timer = 0;
            burn_damage_per_stack = 0;
            ice_timer = 0;
            ice_damage_per_tick = 0;
            entangle_timer = 0;
            hex_timer = 0;
            stun_timer = 0;
            big_bleed_timer = 0;
            big_bleed_damage = 0;
            attack_speed_slow_timer = 0;
            move_speed_slow_timer = 0;
            LOG("🔄 Манекен возрожден от кровотечения! HP: " + string(hp));
        } else {
            bleed_timer = 1.0;
        }
    }
}

// ===== ОБРАБОТКА ГОРЕНИЯ (BURN) =====
if (burn_stacks > 0) {
    burn_timer -= 1 / room_speed;
    
    if (burn_timer <= 0) {
        var burn_total_damage = burn_stacks * burn_damage_per_stack;
        
        if (burn_total_damage > 0) {
            hp -= burn_total_damage;
            
            LOG("🔥 ТЕСТОВЫЙ МАНЕКЕН: Горение -" + string(burn_total_damage) + 
                              " HP, стеков: " + string(burn_stacks) + 
                              ", урон/стек: " + string(burn_damage_per_stack) + 
                              ", осталось HP: " + string(floor(hp)) + "/" + string(max_hp));
        }
        
        if (hp <= 0) {
            hp = max_hp;
            bleed_stacks = 0;
            bleed_timer = 0;
            bleed_damage_per_stack = 0;
            burn_stacks = 0;
            burn_timer = 0;
            burn_damage_per_stack = 0;
            ice_timer = 0;
            ice_damage_per_tick = 0;
            entangle_timer = 0;
            hex_timer = 0;
            stun_timer = 0;
            big_bleed_timer = 0;
            big_bleed_damage = 0;
            attack_speed_slow_timer = 0;
            move_speed_slow_timer = 0;
            LOG("🔄 Манекен возрожден от горения! HP: " + string(hp));
        } else {
            burn_timer = 2.0;
        }
    }
}

// ===== ОБРАБОТКА ЛЬДА (ICE) =====
if (ice_timer > 0) {
    ice_timer -= 1 / room_speed;
    ice_damage_timer -= 1 / room_speed;
    
    if (ice_damage_timer <= 0) {
        if (ice_damage_per_tick > 0) {
            hp -= ice_damage_per_tick;
            LOG_CAT("🧊 ТЕСТОВЫЙ МАНЕКЕН: Лед -" + string(ice_damage_per_tick) + 
                      " HP, осталось: " + string(floor(hp)) + "/" + string(max_hp), "combat");
        }
        ice_damage_timer = 1.0; // Урон раз в секунду
    }
    
    // Проверка на смерть от льда
    if (hp <= 0) {
        hp = max_hp;
        bleed_stacks = 0;
        bleed_timer = 0;
        bleed_damage_per_stack = 0;
        burn_stacks = 0;
        burn_timer = 0;
        burn_damage_per_stack = 0;
        ice_timer = 0;
        ice_damage_per_tick = 0;
        ice_damage_timer = 0;
        entangle_timer = 0;
        hex_timer = 0;
        stun_timer = 0;
        big_bleed_timer = 0;
        big_bleed_damage = 0;
        attack_speed_slow_timer = 0;
        move_speed_slow_timer = 0;
        LOG("🔄 Манекен возрожден от льда! HP: " + string(hp));
    }
}

// ===== БОЛЬШОЕ КРОВОТЕЧЕНИЕ (BIG BLEED) =====
if (big_bleed_timer > 0) {
    big_bleed_timer -= 1 / room_speed;
    if (big_bleed_timer <= 0) {
        big_bleed_damage = 0;
    } else {
        big_bleed_damage_timer -= 1 / room_speed;
        if (big_bleed_damage_timer <= 0) {
            if (big_bleed_damage > 0) {
                hp -= big_bleed_damage;
                LOG_CAT("🩸💥 БОЛЬШОЕ КРОВОТЕЧЕНИЕ МАНЕКЕНА: -" + string(big_bleed_damage) + 
                          " HP, осталось: " + string(floor(hp)), "combat");
                
                if (hp <= 0) {
                    hp = max_hp;
                    bleed_stacks = 0;
                    bleed_timer = 0;
                    bleed_damage_per_stack = 0;
                    burn_stacks = 0;
                    burn_timer = 0;
                    burn_damage_per_stack = 0;
                    ice_timer = 0;
                    ice_damage_per_tick = 0;
                    entangle_timer = 0;
                    hex_timer = 0;
                    stun_timer = 0;
                    big_bleed_timer = 0;
                    big_bleed_damage = 0;
                    attack_speed_slow_timer = 0;
                    move_speed_slow_timer = 0;
                    LOG("🔄 Манекен возрожден от большого кровотечения! HP: " + string(hp));
                }
            }
            big_bleed_damage_timer = 1.0;
        }
    }
}

// ===== АТАКА МАНЕКЕНА (раз в 5 секунд) =====
attack_timer -= 1 / room_speed;

if (attack_timer <= 0) {
    // Ищем ближайшего героя для атаки
    var closest_hero = noone;
    var closest_dist = 150;
    var dummy_x = x;
    var dummy_y = y;
    
    with (obj_hero_base) {
        if (hp > 0 && state != STATE_DEAD) {
            var dist = point_distance(x, y, dummy_x, dummy_y);
            if (dist < closest_dist) {
                closest_hero = id;
                closest_dist = dist;
            }
        }
    }
    
    if (instance_exists(closest_hero)) {
        // Получаем текущую скорость атаки (может быть замедлена)
        var current_attack_cooldown = attack_cooldown_max;
        if (attack_speed_slow_timer > 0) {
            if (variable_instance_exists(id, "slowed_attack_speed")) {
                current_attack_cooldown = slowed_attack_speed;
            }
        }
        
        // Наносим урон герою
        scr_hero_base_take_damage(closest_hero, damage, false);
        
        LOG("==========================================");
        LOG("🗡️ МАНЕКЕН АТАКУЕТ ГЕРОЯ!");
        LOG("  Урон: " + string(damage));
        
        // Проверяем существование героя перед выводом
        if (instance_exists(closest_hero)) {
            LOG("  Герой: " + string(closest_hero.hero_type) + 
                              ", HP: " + string(floor(closest_hero.hp)) + "/" + string(closest_hero.max_hp));
            
            // ===== ОТЛАДКА ХАРАКТЕРИСТИК ГЕРОЯ =====
            if (variable_instance_exists(closest_hero, "lifesteal") && closest_hero.lifesteal > 0) {
                LOG("  💉 Вампиризм героя: " + string(closest_hero.lifesteal) + "%");
            }
            
            if (variable_instance_exists(closest_hero, "bleed_damage") && closest_hero.bleed_damage > 0) {
                LOG("  🩸 Кровотечение героя: " + string(closest_hero.bleed_damage) + " урона/сек за стек");
            }
            
            if (variable_instance_exists(closest_hero, "cleave_percent") && closest_hero.cleave_percent > 0) {
                LOG("  ⚡ Сплеш героя: " + string(closest_hero.cleave_percent) + "%");
            }
            
            if (variable_instance_exists(closest_hero, "dodge_chance") && closest_hero.dodge_chance > 0) {
                LOG("  🌀 Уворот героя: " + string(closest_hero.dodge_chance) + "%");
            }
            
            if (variable_instance_exists(closest_hero, "armor") && closest_hero.armor > 0) {
                LOG("  🛡️ Броня героя: " + string(closest_hero.armor));
            }
            
            if (variable_instance_exists(closest_hero, "shield") && closest_hero.shield > 0) {
                LOG("  🛡️ Щит героя: " + string(closest_hero.shield) + "/" + string(closest_hero.max_shield));
            }
            
            if (variable_instance_exists(closest_hero, "double_attack_chance") && closest_hero.double_attack_chance > 0) {
                LOG("  ⚔️ Двойная атака: " + string(closest_hero.double_attack_chance) + "%");
            }
        } else {
            LOG("  Герой умер во время атаки!");
        }
        
        LOG("==========================================");
    } else {
        LOG("⚠️ Манекен: нет героев для атаки!");
    }
    
    // Сбрасываем таймер (5 секунд)
    attack_timer = 5.0;
}

// ===== ОТЛАДКА ЭФФЕКТОВ (каждые 5 секунд показываем состояние) =====
debug_effect_timer -= 1 / room_speed;
if (debug_effect_timer <= 0) {
    if (bleed_stacks > 0) {
        LOG("📊 [МАНЕКЕН] Кровотечение: " + string(bleed_stacks) + 
                          " стеков, урон/сек: " + string(bleed_stacks * bleed_damage_per_stack));
    }
    if (burn_stacks > 0) {
        LOG("📊 [МАНЕКЕН] Горение: " + string(burn_stacks) + 
                          " стеков, урон/2 сек: " + string(burn_stacks * burn_damage_per_stack));
    }
    if (ice_timer > 0) {
        LOG("📊 [МАНЕКЕН] Лед: " + string(ice_damage_per_tick) + " урона/сек");
    }
    debug_effect_timer = 5.0;
}
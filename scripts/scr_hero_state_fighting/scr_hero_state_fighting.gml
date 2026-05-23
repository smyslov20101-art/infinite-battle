/// @function hero_state_fighting(_hero_instance)
function hero_state_fighting(_hero_instance) {
    if (!instance_exists(_hero_instance)) return;
    
    with (_hero_instance) {
        if (!instance_exists(fight_target)) {
            fight_target = noone;
            var dist_to_target = point_distance(x, y, target_x, target_y);
            if (dist_to_target > 10) state = STATE_MOVING;
            else state = STATE_IDLE;
            return;
        }
        
        if (!fight_target.alive || fight_target.hp <= 0) {
            fight_target = noone;
            var dist_to_target = point_distance(x, y, target_x, target_y);
            if (dist_to_target > 10) state = STATE_MOVING;
            else state = STATE_IDLE;
            return;
        }
        
        var dist_to_enemy = point_distance(x, y, fight_target.x, fight_target.y);
        if (dist_to_enemy > attack_range_moving + 20) {
            fight_target = noone;
            var dist_to_target = point_distance(x, y, target_x, target_y);
            if (dist_to_target > 10) state = STATE_MOVING;
            else state = STATE_IDLE;
            return;
        }
        
        attack_timer -= 1 / room_speed;
        if (attack_timer <= 0) {
            var final_damage = damage;
            var is_crit = false;
            
            // ===== КРИТ =====
            if (variable_instance_exists(id, "crit_chance") && crit_chance > 0) {
                var crit_roll = random(100);
                if (crit_roll < crit_chance) {
                    var crit_mult = 2.0;
                    if (variable_instance_exists(id, "crit_damage_mult")) crit_mult = crit_damage_mult;
                    final_damage = floor(final_damage * crit_mult);
                    is_crit = true;
                    LOG_CAT("💥 КРИТИЧЕСКИЙ УДАР! Урон: " + string(final_damage), "combat");
                }
            }
            
            scr_enemy_take_damage(fight_target, final_damage);
            
            // ===== ДВОЙНАЯ АТАКА =====
            if (variable_instance_exists(id, "double_attack_chance") && double_attack_chance > 0) {
                var double_roll = random(100);
                if (double_roll < double_attack_chance) {
                    scr_enemy_take_damage(fight_target, final_damage);
                    LOG_CAT("⚔️ ДВОЙНАЯ АТАКА! +" + string(final_damage) + " урона", "combat");
                }
            }
            
            // ===== КЛАСС-СПЕЦИФИЧНЫЕ ON-HIT ЭФФЕКТЫ =====
            // (метки/головокружение паладина, темный меч мечника теней).
            // Вынесено в общий скрипт — тот же вызов есть в scr_hero_state_idle,
            // иначе эффекты почти не срабатывали (герой ближнего боя бьёт из idle).
            scr_apply_class_onhit(id, fight_target);

            // ===== ВАМПИРИЗМ =====
            if (variable_instance_exists(id, "lifesteal") && lifesteal > 0) {
                var heal_amount = floor(final_damage * lifesteal / 100);
                if (heal_amount > 0) {
                    var old_hp = hp;
                    hp = min(max_hp, hp + heal_amount);
                    LOG_CAT("💉 ВАМПИРИЗМ: +" + string(hp - old_hp) + " HP", "vampire");
                }
            }
            
            // ===== КРОВОТЕЧЕНИЕ =====
            if (variable_instance_exists(id, "bleed_damage") && bleed_damage > 0) {
                if (!variable_instance_exists(fight_target, "bleed_stacks")) {
                    fight_target.bleed_stacks = 0;
                    fight_target.bleed_timer = 0;
                    fight_target.bleed_damage_per_stack = 0;
                }
                if (fight_target.bleed_damage_per_stack < bleed_damage) fight_target.bleed_damage_per_stack = bleed_damage;
                fight_target.bleed_stacks += 1;
                fight_target.bleed_timer = 3.0;
                LOG_CAT("🩸 КРОВОТЕЧЕНИЕ: +1 стек (всего " + string(fight_target.bleed_stacks) + ")", "bleed");
            }
            
            // ===== СПЛЕШ =====
            if (variable_instance_exists(id, "cleave_percent") && cleave_percent > 0) {
                var cleave_dmg = floor(final_damage * cleave_percent / 100);
                if (cleave_dmg > 0) {
                    var second_target = noone;
                    var closest_dist = 250;
                    with (obj_enemy_base) {
                        if (id != other.fight_target && alive && hp > 0) {
                            var dist = point_distance(x, y, other.x, other.y);
                            if (dist < closest_dist) {
                                second_target = id;
                                closest_dist = dist;
                            }
                        }
                    }
                    if (instance_exists(second_target)) {
                        scr_enemy_take_damage(second_target, cleave_dmg);
                        LOG_CAT("⚡ СПЛЕШ: " + string(cleave_dmg) + " урона по второй цели", "cleave");
                    }
                }
            }
            
            var current_attack_speed = attack_speed;
            if (variable_instance_exists(id, "attack_speed_bonus") && attack_speed_bonus > 0) {
                current_attack_speed = attack_speed * (1 + attack_speed_bonus / 100);
            }
            attack_timer = 1 / current_attack_speed;
            image_blend = c_white;
            alarm[0] = 5;
        }
    }
}
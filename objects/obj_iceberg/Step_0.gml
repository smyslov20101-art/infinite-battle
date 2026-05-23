/// Step Event - obj_iceberg
// При создании сразу наносим урон
if (enemies_hit == 0) {
    with (obj_enemy_base) {
        if (alive && hp > 0) {
            // Наносим урон
            scr_enemy_take_damage(id, other.damage);
            
            // Замедляем атаку
            if (!variable_instance_exists(id, "attack_speed_slow_timer")) {
                attack_speed_slow_timer = 0;
                original_attack_cooldown = attack_cooldown_max;
            }
            attack_speed_slow_timer = other.slow_duration;
            var slow_mult = 1 - (other.attack_speed_slow / 100);
            attack_cooldown_max = original_attack_cooldown * slow_mult;
            
            if (!variable_instance_exists(id, "slowed_attack_speed")) {
                slowed_attack_speed = attack_cooldown_max;
            }
            slowed_attack_speed = attack_cooldown_max;
            
            other.enemies_hit++;
        }
    }
}
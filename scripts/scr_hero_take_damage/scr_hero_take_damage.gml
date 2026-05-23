function scr_hero_take_damage(_hero_instance, _damage_amount) {
    if (!instance_exists(_hero_instance)) return false;
    
    with (_hero_instance) {
        // Проверяем кулдаун и состояние
        if (damage_cooldown > 0 || hp <= 0 || state == STATE_DEAD) return false;
        
        // Наносим урон
        hp -= _damage_amount;
        damage_cooldown = damage_cooldown_max;
        
        // Смерть
        if (hp <= 0) {
            state = STATE_DEAD;
            
            // Если это был главный герой - ищем нового
            if (is_main_hero) {
                LOG("Главный герой типа " + hero_type + " умер!");
                
                // Ищем нового главного среди живых героев этого типа
                var new_main_hero = scr_find_main_hero_for_type(hero_type);
                if (instance_exists(new_main_hero)) {
                    new_main_hero.is_main_hero = true;
                    LOG("Назначен новый главный герой!");
                }
            }
            
            var controller = instance_find(obj_game_controller, 0);
            if (instance_exists(controller)) {
                controller.heroes_on_field--;
            }
            
            instance_destroy();
        }
        
        return true;
    }
}
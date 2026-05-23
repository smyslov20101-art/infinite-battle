/// @function boss_die(_boss_instance)
/// @desc Обработка смерти босса

function boss_die(_boss_instance) {
    if (!instance_exists(_boss_instance)) return;
    
    var controller = instance_find(obj_game_controller, 0);
    
    if (instance_exists(controller)) {
        // Получаем номер босса
        var boss_number = controller.boss_spawn_count;
        
        // Рассчитываем дополнительную награду
        var boss_rewards = scr_calculate_boss_rewards(boss_number, "boss");
        
        // Добавляем к наградам волны в КОНТРОЛЛЕРЕ
        controller.wave_crystals += boss_rewards.crystals;
        
        // Объединяем сундуки
        for (var i = 0; i < array_length(boss_rewards.chests); i++) {
            var new_chest = boss_rewards.chests[i];
            var found = false;
            
            for (var j = 0; j < array_length(controller.wave_chests); j++) {
                if (controller.wave_chests[j].rarity == new_chest.rarity) {
                    controller.wave_chests[j].count += new_chest.count;
                    found = true;
                    break;
                }
            }
            
            if (!found) {
                array_push(controller.wave_chests, new_chest);
            }
        }
        
        // Награда генами (обычная)
        controller.session_genes += _boss_instance.reward;
        controller.wave_genes += _boss_instance.reward;
        
        controller.enemies_killed++;
        controller.current_enemies_on_field = max(0, controller.current_enemies_on_field - 1);
        
        // Снимаем флаги босса
        controller.boss_active = false;
        controller.pause_spawn_on_boss = false;
        
        // ===== ВАЖНО: Если это режим этажа - показываем окно завершения =====
        if (controller.floor_mode) {
            LOG("  🏁 Режим этажа - показываем окно завершения");
            show_floor_complete();
        } else {
            // Обычный режим - просто устанавливаем флаг
            controller.boss_just_killed = true;
        }
        
        // Восстанавливаем интервал спавна
        if (variable_instance_exists(controller, "saved_spawn_interval")) {
            controller.enemy_spawn_interval = controller.saved_spawn_interval;
            controller.enemy_spawn_timer = 0.5;
        }
        
        LOG("=== БОСС №" + string(boss_number) + " ПОВЕРЖЕН! ===");
    }
    
    instance_destroy(_boss_instance);
}
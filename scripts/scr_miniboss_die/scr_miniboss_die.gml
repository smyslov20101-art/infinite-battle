/// @function scr_miniboss_die(_miniboss_instance)
/// @desc Обработка смерти мини-босса

function scr_miniboss_die(_miniboss_instance) {
    if (!instance_exists(_miniboss_instance)) return;
    
    var controller = instance_find(obj_game_controller, 0);
    
    if (instance_exists(controller)) {
        var miniboss_number = controller.miniboss_spawn_count;
        var boss_rewards = scr_calculate_boss_rewards(miniboss_number, "miniboss");
        
        // Добавляем кристаллы
        controller.wave_crystals += boss_rewards.crystals;
        
        // Добавляем сундуки в wave_chests контроллера
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
        
        controller.session_genes += _miniboss_instance.reward;
        controller.wave_genes += _miniboss_instance.reward;
        controller.enemies_killed++;
        controller.current_enemies_on_field = max(0, controller.current_enemies_on_field - 1);
        
        controller.boss_active = false;
        controller.pause_spawn_on_boss = false;
        
        // ===== ВАЖНО: Если это режим этажа - показываем окно завершения =====
        LOG("=== МИНИ-БОСС №" + string(miniboss_number) + " ПОВЕРЖЕН! ===");
        LOG("controller.floor_mode = " + string(controller.floor_mode));
        LOG("global.current_floor = " + string(global.current_floor));
        
        if (controller.floor_mode) {
            LOG("  🏁 Режим этажа - показываем окно завершения");
            
            // Ставим игру на паузу
            controller.controller_state = controller.CONTROLLER_STATE_PAUSE;
            
            // Показываем окно завершения этажа
            if (instance_exists(obj_floor_complete)) {
                with (obj_floor_complete) {
                    instance_destroy();
                }
            }
            
            var complete_window = instance_create_layer(0, 0, "Instances", obj_floor_complete);
            
            with (complete_window) {
                floor_data = global.current_floor;
                
                LOG("  floor_data = " + string(floor_data));
                
                // Формируем награды
                rewards = [];
                
                // Гены
                array_push(rewards, {
                    type: "genes",
                    amount: floor_data.reward_genes
                });
                
                // Кристаллы
                if (floor_data.reward_crystals > 0) {
                    array_push(rewards, {
                        type: "crystals",
                        amount: floor_data.reward_crystals
                    });
                }
                
                // Сундуки
                if (floor_data.reward_chest_count > 0) {
                    array_push(rewards, {
                        type: "chest",
                        rarity: floor_data.reward_chest_rarity,
                        count: floor_data.reward_chest_count
                    });
                }
                
                LOG("  🎁 Создано окно наград для этажа " + string(floor_data.id));
            }
            
            // Открываем следующий этаж, если еще не пройден
            if (variable_global_exists("current_floor") && global.current_floor != noone) {
                if (!global.current_floor.completed) {
                    if (variable_global_exists("complete_floor")) {
                        complete_floor(global.current_floor.id);
                        LOG("  🔓 Открыт следующий этаж");
                    }
                }
            }
        } else {
            // Обычный режим - просто устанавливаем флаг
            controller.boss_just_killed = true;
            LOG("  Обычный режим - установлен флаг boss_just_killed");
        }
        
        if (variable_instance_exists(controller, "saved_spawn_interval")) {
            controller.enemy_spawn_interval = controller.saved_spawn_interval;
            controller.enemy_spawn_timer = 0.5;
        }
    }
    
    instance_destroy(_miniboss_instance);
}
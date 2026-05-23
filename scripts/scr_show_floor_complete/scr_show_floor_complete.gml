/// @function show_floor_complete()
/// @desc Показывает окно завершения этажа

function show_floor_complete() {
    var controller = instance_find(obj_game_controller, 0);
    if (!instance_exists(controller)) return;
    
    with (controller) {
        // Ставим игру на паузу
        controller_state = CONTROLLER_STATE_PAUSE;
        
        // Показываем окно завершения этажа
        if (instance_exists(obj_floor_complete)) {
            with (obj_floor_complete) {
                instance_destroy();
            }
        }
        
        var complete_window = instance_create_layer(0, 0, "Instances", obj_floor_complete);
        
        with (complete_window) {
            floor_data = global.current_floor;
            
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
        
        // Сбрасываем флаг
        boss_just_killed = false;
        
        // Открываем следующий этаж, если еще не пройден
        if (variable_global_exists("current_floor") && global.current_floor != noone) {
            if (!global.current_floor.completed) {
                if (variable_global_exists("complete_floor")) {
                    complete_floor(global.current_floor.id);
                    LOG("  🔓 Открыт следующий этаж");
                }
            }
        }
    }
}
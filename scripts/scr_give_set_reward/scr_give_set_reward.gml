/// @function give_set_reward(_set)
/// @desc Выдает награду за купленный набор
/// @return {array} Массив наград для отображения (для сундука)

function give_set_reward(_set) {
    LOG("=== ВЫДАЧА НАГРАДЫ ЗА НАБОР ===");
    LOG("Набор: " + _set.name);
    
    switch (_set.reward_type) {
        case "genes":
            scr_cheat_add_genes(_set.reward_amount);
            LOG("Получено генов: " + string(_set.reward_amount));
            return []; // Пустой массив, нет окна наград
            
        case "crystals":
            scr_cheat_add_crystals(_set.reward_amount);
            LOG("Получено кристаллов: " + string(_set.reward_amount));
            return []; // Пустой массив, нет окна наград
            
        case "chest":
            // Открываем сундук (но не списываем ресурсы)
            var chest_index = _set.reward_chest_index;
            
            // Генерируем награды как при открытии сундука
            var rewards = [];
            var chest = chests[chest_index];
            
            for (var r = 0; r < array_length(chest.rewards); r++) {
                var reward = chest.rewards[r];
                var hero_ids = get_random_heroes_by_rarity(reward.rarity, reward.count);
                
                for (var h = 0; h < array_length(hero_ids); h++) {
                    var hero_id = hero_ids[h];
                    var found = false;
                    
                    for (var rr = 0; rr < array_length(rewards); rr++) {
                        if (rewards[rr].hero_id == hero_id) {
                            rewards[rr].count++;
                            found = true;
                            break;
                        }
                    }
                    
                    if (!found) {
                        array_push(rewards, {hero_id: hero_id, count: 1});
                    }
                }
            }
            
            LOG("Сгенерированы награды для сундука:");
            for (var i = 0; i < array_length(rewards); i++) {
                var hero = global.heroes[rewards[i].hero_id];
                LOG("  + " + hero.name + " x" + string(rewards[i].count));
            }
            
            return rewards; // Возвращаем массив наград для отображения
            
        default:
            LOG("Неизвестный тип награды: " + _set.reward_type);
            return [];
    }
}
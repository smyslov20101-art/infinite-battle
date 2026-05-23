/// @function scr_calculate_boss_rewards(boss_number, boss_type)
/// @desc Рассчитывает награду за убийство босса
/// @param boss_number {real} Номер босса (1, 2, 3...)
/// @param boss_type {string} "miniboss" или "boss"
/// @return {struct} Награда {crystals, chests}

function scr_calculate_boss_rewards(boss_number, boss_type) {
    var rewards = {
        crystals: 0,
        chests: []
    };
    
    if (boss_type == "miniboss") {
        // Награда за мини-босса
        switch (boss_number) {
            case 1:
                // 1-й минибосс: 1 обычный сундук
                array_push(rewards.chests, {rarity: 0, count: 1});
                break;
            case 2:
                // 2-й минибосс: 3 обычных сундука + 5 кристаллов
                array_push(rewards.chests, {rarity: 0, count: 3});
                rewards.crystals = 5;
                break;
            case 3:
                // 3-й минибосс: 1 редкий сундук
                array_push(rewards.chests, {rarity: 1, count: 1});
                break;
            case 4:
                // 4-й минибосс: 2 редких сундука + 10 кристаллов
                array_push(rewards.chests, {rarity: 1, count: 2});
                rewards.crystals = 10;
                break;
            case 5:
                // 5-й минибосс: 1 эпический сундук
                array_push(rewards.chests, {rarity: 2, count: 1});
                break;
            default:
                // 6+ минибоссы: прогрессия
                var epic_count = floor((boss_number - 4) / 2);
                if (epic_count > 0) {
                    array_push(rewards.chests, {rarity: 2, count: epic_count});
                }
                rewards.crystals = 10 + (boss_number - 5) * 5;
                break;
        }
    } else {
        // Награда за босса
        switch (boss_number) {
            case 1:
                // 1-й босс: 3 обычных сундука + 10 кристаллов
                array_push(rewards.chests, {rarity: 0, count: 3});
                rewards.crystals = 10;
                break;
            case 2:
                // 2-й босс: 1 редкий сундук
                array_push(rewards.chests, {rarity: 1, count: 1});
                break;
            case 3:
                // 3-й босс: 2 редких сундука + 15 кристаллов
                array_push(rewards.chests, {rarity: 1, count: 2});
                rewards.crystals = 15;
                break;
            case 4:
                // 4-й босс: 1 эпический сундук
                array_push(rewards.chests, {rarity: 2, count: 1});
                break;
            case 5:
                // 5-й босс: 2 эпических сундука + 25 кристаллов
                array_push(rewards.chests, {rarity: 2, count: 2});
                rewards.crystals = 25;
                break;
            case 6:
                // 6-й босс: 1 легендарный сундук
                array_push(rewards.chests, {rarity: 3, count: 1});
                break;
            default:
                // 7+ боссы: легендарные + кристаллы
                var legendary_count = floor((boss_number - 5) / 2);
                if (legendary_count > 0) {
                    array_push(rewards.chests, {rarity: 3, count: legendary_count});
                }
                rewards.crystals = 30 + (boss_number - 6) * 10;
                break;
        }
    }
    
    return rewards;
}
/// @function open_chest(_chest_index)
/// @desc Открывает сундук и выдает награду
/// @param _chest_index {number} Индекс сундука (0-3)
/// @return {bool} true если успешно открыт

function open_chest(_chest_index) {
    if (_chest_index < 0 || _chest_index >= 4) return false;
    
    var chest = chests[_chest_index];
    
    // Проверяем хватает ли ресурсов
    if (global.genes < chest.price_genes) {
        LOG("Не хватает генов! Нужно: " + string(chest.price_genes));
        return false;
    }
    
    if (global.crystals < chest.price_crystals) {
        LOG("Не хватает кристаллов! Нужно: " + string(chest.price_crystals));
        return false;
    }
    
    // Списываем ресурсы
    global.genes -= chest.price_genes;
    global.crystals -= chest.price_crystals;
    
    LOG("=== ОТКРЫТИЕ СУНДУКА ===");
    LOG(chest.rarity_text + " СУНДУК");  // ← ИСПРАВЛЕНО: было chest.name
    
    // Выдаем награду
    var total_cards_added = 0;
    
    for (var r = 0; r < array_length(chest.rewards); r++) {
        var reward = chest.rewards[r];
        var hero_ids = get_random_heroes_by_rarity(reward.rarity, reward.count);
        
        for (var h = 0; h < array_length(hero_ids); h++) {
            var hero_id = hero_ids[h];
            add_hero_card(hero_id, 1);
            total_cards_added++;
            
            var hero = global.heroes[hero_id];
            LOG("  + " + hero.name + " (редкость " + string(hero.rarity) + ")");
        }
    }
    
    LOG("Всего получено карт: " + string(total_cards_added));
    
    // Сохраняем игру
    save_all_data();
    
    return true;
}
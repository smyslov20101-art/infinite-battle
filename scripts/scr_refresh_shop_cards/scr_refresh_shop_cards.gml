/// @function refresh_shop_cards()
/// @desc Генерирует 4 новые карты в магазине согласно шансам редкости.
///       Вызывать из контекста obj_shop_controller — использует instance-переменную shop_cards_count.

function refresh_shop_cards() {
    LOG("=== ОБНОВЛЕНИЕ КАРТ МАГАЗИНА ===");

    // Сбрасываем флаги shop_bought у всех героев
    for (var i = 0; i < array_length(global.heroes); i++) {
        global.heroes[i].shop_bought = false;
        global.heroes[i].shop_slot = -1;
    }

    var new_cards = array_create(shop_cards_count);

    var available = [];
    for (var i = 0; i < array_length(global.heroes); i++) {
        array_push(available, i);
    }
    if (array_length(available) == 0) {
        shop_cards = new_cards;
        return;
    }

    for (var slot = 0; slot < shop_cards_count; slot++) {
        var rarity = 0;
        var chance = random(100);
        if (chance < 60)       rarity = 0;
        else if (chance < 90)  rarity = 1;
        else if (chance < 105) rarity = 2;
        else                   rarity = 3;

        var heroes_of_rarity = [];
        for (var i = 0; i < array_length(available); i++) {
            if (global.heroes[available[i]].rarity == rarity) {
                array_push(heroes_of_rarity, available[i]);
            }
        }
        if (array_length(heroes_of_rarity) == 0) heroes_of_rarity = available;

        var idx = floor(random(array_length(heroes_of_rarity)));
        var selected_hero_id = heroes_of_rarity[idx];

        var price_genes = 0;
        var price_crystals = 0;
        switch (rarity) {
            case 0: price_genes = 1000; break;
            case 1: price_genes = 5000; break;
            case 2: price_genes = 20000; price_crystals = 10; break;
            case 3: price_genes = 50000; price_crystals = 50; break;
        }

        new_cards[slot] = {
            hero_id: selected_hero_id,
            rarity: rarity,
            price_genes: price_genes,
            price_crystals: price_crystals
        };
    }

    shop_cards = new_cards;

    // Сразу синхронизируем в permanent_save (запись на диск — отдельным вызовом save_permanent_to_file)
    if (variable_global_exists("permanent_save") && struct_exists(global.permanent_save, "shop_cards_data")) {
        global.permanent_save.shop_cards_data.cards = new_cards;
    }

    for (var i = 0; i < shop_cards_count; i++) {
        if (shop_cards[i] != undefined) {
            LOG("Слот " + string(i) + ": " + global.heroes[shop_cards[i].hero_id].name);
        }
    }
    LOG("=== КАРТЫ ОБНОВЛЕНЫ ===");
}

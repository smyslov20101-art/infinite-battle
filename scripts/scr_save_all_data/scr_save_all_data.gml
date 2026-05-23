/// @function save_all_data()
/// @desc Сохраняет все данные игры на диск.
///       Шоп/рулетка/сундуки сами обновляют global.permanent_save.* в реальном времени,
///       поэтому здесь только подтягиваем session-данные (гены/колода/герои/кристаллы) и пишем файл.

function save_all_data() {
    LOG("=== СОХРАНЕНИЕ ВСЕХ ДАННЫХ ===");

    if (!variable_global_exists("permanent_save")) {
        LOG("permanent_save не существует, создаем...");
        create_default_permanent_save();
    }

    // Гены и колода: предпочитаем current_session, fallback на глобальные
    if (variable_global_exists("current_session")) {
        global.permanent_save.genes = global.current_session.genes;
        for (var i = 0; i < 4; i++) {
            global.permanent_save.deck[i] = global.current_session.deck[i];
        }
    } else if (variable_global_exists("genes")) {
        global.permanent_save.genes = global.genes;
        if (variable_global_exists("player_deck")) {
            global.permanent_save.deck = global.player_deck;
        }
    }

    // Прогресс героев
    var heroes_save = [];
    for (var i = 0; i < array_length(global.heroes); i++) {
        var hero = global.heroes[i];
        array_push(heroes_save, {
            id: hero.id,
            unlocked: hero.unlocked,
            level: hero.level,
            cards_collected: hero.cards_collected,
            shop_bought: hero.shop_bought,
            shop_slot: hero.shop_slot
        });
    }
    global.permanent_save.heroes = heroes_save;

    // Кристаллы и ник
    if (variable_global_exists("crystals")) {
        global.permanent_save.crystals = global.crystals;
    }
    if (variable_global_exists("player_name")) {
        global.permanent_save.player_name = global.player_name;
    }

    // Награды волны
    if (variable_global_exists("wave_rewards")) {
        global.permanent_save.wave_rewards_data = {
            genes: global.wave_rewards.genes,
            crystals: global.wave_rewards.crystals,
            chests: global.wave_rewards.chests
        };
    }

    // НЕ трогаем shop_cards_data / chests_data / spin_data — они уже актуальны в permanent_save
    // (за их обновление отвечает obj_shop_controller).

    save_permanent_to_file();

    LOG("=== ВСЕ ДАННЫЕ СОХРАНЕНЫ ===");
    LOG("Гены: " + string(global.permanent_save.genes));
    LOG("Кристаллы: " + string(global.permanent_save.crystals));
}

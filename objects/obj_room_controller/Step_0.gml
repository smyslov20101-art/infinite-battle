// При входе в комнату обновляем отображение (один раз)

// ===== ЧИТ-КОДЫ (только в DEBUG-сборке) =====
if (DEBUG_BUILD) {

// Чит: G — +1000 генов (раньше блок был дублирован, оставлен один)
if (keyboard_check_pressed(ord("G"))) {
    scr_cheat_add_genes(1000);
    LOG("ЧИТ: +1000 генов. Теперь: " + string(global.genes));
}

// Чит: C — +100 кристаллов
if (keyboard_check_pressed(ord("C"))) {
    scr_cheat_add_crystals(100);
    LOG("ЧИТ: +100 кристаллов. Теперь: " + string(global.crystals));
}

// Чит: 0 — прокачка всех героев до 15 уровня
if (keyboard_check_pressed(ord("0"))) {
    LOG("=== ЧИТ: ПРОКАЧКА ВСЕХ ГЕРОЕВ ДО 15 УРОВНЯ ===");
    
    var total_upgraded = 0;
    
    for (var i = 0; i < array_length(global.heroes); i++) {
        var hero = global.heroes[i];
        
        // Пропускаем если герой уже 15 уровня
        if (hero.level >= 15) {
            LOG("  " + hero.name + " уже " + string(hero.level) + " уровня");
            continue;
        }
        
        // Разблокируем героя если он заблокирован
        if (!hero.unlocked) {
            hero.unlocked = true;
            LOG("  🔓 " + hero.name + " разблокирован");
        }
        
        // Прокачиваем до 15 уровня
        while (hero.level < 15) {
            // Добавляем карты если нужно
            if (hero.cards_collected < hero.get_required_cards()) {
                hero.cards_collected = hero.get_required_cards();
            }
            // Улучшаем
            hero.level++;
            total_upgraded++;
        }
        
        // Устанавливаем нужное количество карт для следующего уровня (после 15 его нет)
        hero.cards_collected = hero.get_required_cards();
        
        LOG("  ✅ " + hero.name + " → " + string(hero.level) + " уровень");
    }
    
    LOG("=== ПРОКАЧЕНО ГЕРОЕВ: " + string(total_upgraded) + " раз ===");
    
    // Сохраняем изменения
    if (variable_global_exists("current_session")) {
        global.current_session.heroes = global.heroes;
    }
    
    // Сохраняем в permanent
    commit_session_to_permanent();
    
    LOG("📀 Данные сохранены!");
    
    // Если мы в комнате колоды, обновляем отображение
    if (room == room_deck) {
        // Перезагружаем контроллер колоды если нужно
        with (obj_deck_controller) {
            // Обновляем отображение
            event_perform(ev_draw, 0);
        }
    }
}

} // конец блока if (DEBUG_BUILD)

if (room_start != room) {
    room_start = room;
    LOG("Вошли в комнату: " + string(room) + 
                      ", Гены: " + string(global.genes) + 
                      ", Отряд: " + string(global.player_deck[0]) + "," +
                      string(global.player_deck[1]) + "," +
                      string(global.player_deck[2]) + "," +
                      string(global.player_deck[3]));
}

// Можно оставить пустым или добавить логику
// Например, обработка клавиши ESC для возврата
if (IS_BACK_PRESSED) {
    // Возврат в комнату wave (главное меню)
    if (room != room_wave) {
        room_goto(room_wave);
    }
}
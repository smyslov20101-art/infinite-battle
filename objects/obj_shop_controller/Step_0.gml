/// Step Event - obj_shop_controller

// На первом кадре в комнате перемешиваем рулетку для красоты
if (!variable_instance_exists(id, "room_entered")) {
    room_entered = true;
    if (array_length(roulette_cards) > 0) {
        shuffle_roulette();
    }
}

// Игровое время — только для визуального движения карт рулетки в IDLE
game_time_shop += 1 / room_speed;

// ============================================================================
// === БЛОК ТАЙМЕРОВ: РЕАЛЬНОЕ UNIX-ВРЕМЯ ====================================
// ============================================================================
//
// Принцип: вся правда лежит в global.permanent_save.{spin_data, shop_cards_data, chests_data}.
// На каждый кадр считаем «сколько осталось» = `until - now`. Никакого хранения
// «оставшихся секунд» как состояния — иначе при перезаходе оно ломается.
// Сохраняемся только если состояние реально изменилось.

var now_ts = scr_get_unix_timestamp();
var today  = scr_get_day_number();

var pspin   = global.permanent_save.spin_data;
var pcards  = global.permanent_save.shop_cards_data;
var pchests = global.permanent_save.chests_data;

var need_save = false;

// ----- сброс зарядов рекламы в полночь -----
if (pspin.ad_reset_day != today) {
    pspin.ad_charges = AD_CHARGES_MAX;
    pspin.ad_reset_day = today;
    need_save = true;
    LOG("🌙 Сброс зарядов рекламы рулетки (новый день)");
}
if (pcards.ad_reset_day != today) {
    pcards.ad_charges = AD_CHARGES_MAX;
    pcards.ad_reset_day = today;
    need_save = true;
    LOG("🌙 Сброс зарядов рекламы карт (новый день)");
}
if (pchests.ad_reset_day != today) {
    pchests.ad_charges = AD_CHARGES_MAX;
    pchests.ad_reset_day = today;
    need_save = true;
    LOG("🌙 Сброс зарядов рекламы сундуков (новый день)");
}

// ----- авто-обновление карт раз в 24 ч -----
if (now_ts >= pcards.auto_refresh_at) {
    refresh_shop_cards();
    pcards.auto_refresh_at = now_ts + SHOP_AUTO_REFRESH;
    need_save = true;
    LOG("🔄 Авто-обновление карт магазина");
}

// ----- авто-обновление сундуков раз в 24 ч -----
if (now_ts >= pchests.auto_refresh_at) {
    for (var i = 0; i < 4; i++) {
        chests[i].bought = false;
        pchests.bought[i] = false;
    }
    pchests.auto_refresh_at = now_ts + CHEST_AUTO_REFRESH;
    need_save = true;
    LOG("🔄 Авто-обновление сундуков");
}

// ----- пересчитываем отображаемые таймеры (только для отрисовки) -----
spin_cooldown_current = max(0, pspin.free_spin_at - now_ts);
shop_refresh_current  = max(0, pcards.auto_refresh_at - now_ts);
chest_refresh_current = max(0, pchests.auto_refresh_at - now_ts);

if (need_save) {
    save_permanent_to_file();
}

// ============================================================================
// === КОНЕЦ БЛОКА ТАЙМЕРОВ ==================================================
// ============================================================================


// Если открыто окно наград из сундука — обрабатываем только его клики
if (chest_state == CHEST_STATE_REWARDS) {
    if (mouse_check_button_pressed(mb_left)) {
        if (mouse_x >= rewards_button_x && mouse_x <= rewards_button_x + rewards_button_width &&
            mouse_y >= rewards_button_y && mouse_y <= rewards_button_y + rewards_button_height) {

            LOG("=== ПОЛУЧЕНИЕ НАГРАД ИЗ СУНДУКА ===");
            for (var i = 0; i < array_length(chest_rewards); i++) {
                var reward = chest_rewards[i];
                add_hero_card(reward.hero_id, reward.count);
            }
            save_all_data();

            chest_state = CHEST_STATE_NONE;
            chest_rewards = [];
            chest_just_opened = false;
            exit;
        }
    }
    exit;
}

// ===== ОБРАБОТКА ПРОКРУТКИ КОЛЕСИКОМ И ПЕРЕТАСКИВАНИЕМ =====
if (prize_state == PRIZE_STATE_NONE && buy_state == BUY_STATE_NONE &&
    chest_state == CHEST_STATE_NONE && set_state == SET_STATE_NONE) {

    if (mouse_wheel_up())   scroll_y = max(0, scroll_y - 30);
    if (mouse_wheel_down()) scroll_y = min(scroll_max, scroll_y + 30);

    var mouse_in_scroll_area = mouse_y >= visible_area_top && mouse_y <= visible_area_bottom;

    if (mouse_check_button_pressed(mb_left)) {
        var clicked_on_ui = false;

        // Клик по рулетке / кнопкам
        if (mouse_x >= roulette_x && mouse_x <= roulette_x + roulette_width &&
            mouse_y >= roulette_y - scroll_y && mouse_y <= roulette_y + roulette_height - scroll_y) clicked_on_ui = true;

        var spin_btn_x = roulette_x + (roulette_width - spin_button_width) / 2;
        if (mouse_x >= spin_btn_x && mouse_x <= spin_btn_x + spin_button_width &&
            mouse_y >= spin_button_y - scroll_y && mouse_y <= spin_button_y + spin_button_height - scroll_y) clicked_on_ui = true;

        var ad_btn_x_check = spin_btn_x + spin_button_width + 20;
        if (mouse_x >= ad_btn_x_check && mouse_x <= ad_btn_x_check + ad_button_width &&
            mouse_y >= ad_button_y - scroll_y && mouse_y <= ad_button_y + ad_button_height - scroll_y) clicked_on_ui = true;

        // Клик по картам покупки
        var cards_total_width = shop_cards_count * shop_card_width + (shop_cards_count - 1) * shop_card_spacing;
        var cards_start_x = (room_width - cards_total_width) / 2;
        for (var i = 0; i < shop_cards_count; i++) {
            var cx = cards_start_x + i * (shop_card_width + shop_card_spacing);
            var cy = shop_cards_y - scroll_y;
            if (mouse_x >= cx && mouse_x <= cx + shop_card_width &&
                mouse_y >= cy && mouse_y <= cy + shop_card_height) { clicked_on_ui = true; break; }
        }

        // Клик по кнопке обновления карт
        var refresh_btn_x = (room_width - shop_refresh_button_width) / 2;
        var refresh_btn_y = shop_refresh_button_y - scroll_y;
        if (mouse_x >= refresh_btn_x && mouse_x <= refresh_btn_x + shop_refresh_button_width &&
            mouse_y >= refresh_btn_y && mouse_y <= refresh_btn_y + shop_refresh_button_height) clicked_on_ui = true;

        // Клик по сундукам
        var chests_total_width = 4 * chest_width + 3 * chest_spacing;
        var chests_start_x = (room_width - chests_total_width) / 2;
        for (var i = 0; i < 4; i++) {
            var chx = chests_start_x + i * (chest_width + chest_spacing);
            var chy = chests_start_y - scroll_y;
            if (mouse_x >= chx && mouse_x <= chx + chest_width &&
                mouse_y >= chy && mouse_y <= chy + chest_height) { clicked_on_ui = true; break; }
        }

        // Клик по кнопке обновления СУНДУКОВ (новая)
        var chest_refresh_btn_x = (room_width - chest_refresh_button_width) / 2;
        var chest_refresh_btn_y = chest_refresh_button_y - scroll_y;
        if (mouse_x >= chest_refresh_btn_x && mouse_x <= chest_refresh_btn_x + chest_refresh_button_width &&
            mouse_y >= chest_refresh_btn_y && mouse_y <= chest_refresh_btn_y + chest_refresh_button_height) clicked_on_ui = true;

        // Клик по наборам
        var sets_total_width = sets_per_row * set_width + (sets_per_row - 1) * set_spacing;
        var sets_start_x = (room_width - sets_total_width) / 2;
        for (var row = 0; row < sets_rows; row++) {
            for (var col = 0; col < sets_per_row; col++) {
                var sx = sets_start_x + col * (set_width + set_spacing);
                var sy = sets_start_y + row * (set_height + set_spacing) - scroll_y;
                if (mouse_x >= sx && mouse_x <= sx + set_width &&
                    mouse_y >= sy && mouse_y <= sy + set_height) { clicked_on_ui = true; break; }
            }
        }

        if (!clicked_on_ui && mouse_in_scroll_area) {
            is_dragging = true;
            drag_start_y = mouse_y;
            scroll_start_y = scroll_y;
        }
    }

    if (mouse_check_button(mb_left) && is_dragging) {
        var drag_delta = drag_start_y - mouse_y;
        scroll_y = clamp(scroll_start_y + drag_delta, 0, scroll_max);
    }
    if (mouse_check_button_released(mb_left)) {
        is_dragging = false;
    }
}

// ===== АНИМАЦИЯ РУЛЕТКИ =====
if (prize_state == PRIZE_STATE_NONE && buy_state == BUY_STATE_NONE &&
    chest_state == CHEST_STATE_NONE && set_state == SET_STATE_NONE) {
    var total_cards = array_length(roulette_cards);

    if (current_state == SPIN_STATE_IDLE) {
        scroll_x += scroll_speed;
        if (scroll_x > (card_width + card_spacing) * total_cards) {
            scroll_x -= (card_width + card_spacing) * total_cards;
        }
    }
    if (current_state == SPIN_STATE_SPINNING) {
        scroll_x += 20;
        spin_time += 1 / room_speed;
        if (spin_time >= spin_duration) current_state = SPIN_STATE_STOPPING;
    }
    if (current_state == SPIN_STATE_STOPPING) {
        if (scroll_speed > 0.5) {
            scroll_speed *= 0.97;
            scroll_x += scroll_speed;
        } else {
            current_state = SPIN_STATE_IDLE;
            scroll_speed = 0.5;
            determine_prize();
        }
    }
}

// ============================================================================
// === КНОПКА «КРУТИТЬ» (БЕСПЛАТНОЕ ВРАЩЕНИЕ, РАЗ В 3 ЧАСА) ==================
// ============================================================================
if (prize_state == PRIZE_STATE_NONE && buy_state == BUY_STATE_NONE &&
    chest_state == CHEST_STATE_NONE && set_state == SET_STATE_NONE &&
    mouse_check_button_pressed(mb_left)) {

    var spin_btn_x_click = roulette_x + (roulette_width - spin_button_width) / 2;
    var spin_btn_y_click = spin_button_y - scroll_y;

    if (mouse_x >= spin_btn_x_click && mouse_x <= spin_btn_x_click + spin_button_width &&
        mouse_y >= spin_btn_y_click && mouse_y <= spin_btn_y_click + spin_button_height) {

        if (spin_cooldown_current <= 0 && current_state == SPIN_STATE_IDLE) {
            current_state = SPIN_STATE_SPINNING;
            spin_time = 0;
            scroll_speed = 20;
            spin_duration = 3 + random(3);

            pspin.free_spin_at = now_ts + SPIN_FREE_COOLDOWN;
            save_permanent_to_file();

            LOG("🎰 Бесплатный круг! Следующий через 3 часа.");
        } else if (spin_cooldown_current > 0) {
            LOG("Перезарядка: " + scr_format_time(spin_cooldown_current));
        }
    }
}

// ============================================================================
// === КНОПКА «РЕКЛАМА» ДЛЯ РУЛЕТКИ ==========================================
// ============================================================================
if (prize_state == PRIZE_STATE_NONE && buy_state == BUY_STATE_NONE &&
    chest_state == CHEST_STATE_NONE && set_state == SET_STATE_NONE &&
    mouse_check_button_pressed(mb_left)) {

    var spin_btn_x_ad = roulette_x + (roulette_width - spin_button_width) / 2;
    var ad_btn_x_click = spin_btn_x_ad + spin_button_width + 20;
    var ad_btn_y_click = ad_button_y - scroll_y;

    if (mouse_x >= ad_btn_x_click && mouse_x <= ad_btn_x_click + ad_button_width &&
        mouse_y >= ad_btn_y_click && mouse_y <= ad_btn_y_click + ad_button_height) {

        if (current_state == SPIN_STATE_IDLE) {
            if (pspin.ad_charges > 0) {
                pspin.ad_charges -= 1;
                update_quest_progress("ads", 1);

                current_state = SPIN_STATE_SPINNING;
                spin_time = 0;
                scroll_speed = 20;
                spin_duration = 3 + random(3);

                save_permanent_to_file();
                LOG("🎬 Крут за рекламу. Осталось зарядов: " + string(pspin.ad_charges));
            } else {
                LOG("Лимит рекламы для рулетки исчерпан до полуночи");
            }
        }
    }
}

// ============================================================================
// === КНОПКА «ОБНОВИТЬ» В ПОКУПКЕ КАРТ ======================================
// ============================================================================
if (prize_state == PRIZE_STATE_NONE && buy_state == BUY_STATE_NONE &&
    chest_state == CHEST_STATE_NONE && set_state == SET_STATE_NONE &&
    mouse_check_button_pressed(mb_left)) {

    var btn_x = (room_width - shop_refresh_button_width) / 2;
    var btn_y = shop_refresh_button_y - scroll_y;

    if (mouse_x >= btn_x && mouse_x <= btn_x + shop_refresh_button_width &&
        mouse_y >= btn_y && mouse_y <= btn_y + shop_refresh_button_height) {

        if (pcards.ad_charges > 0) {
            pcards.ad_charges -= 1;
            update_quest_progress("ads", 1);

            refresh_shop_cards();
            pcards.auto_refresh_at = now_ts + SHOP_AUTO_REFRESH;

            save_permanent_to_file();
            LOG("🔄 Карты обновлены за рекламу. Осталось зарядов: " + string(pcards.ad_charges));
        } else {
            LOG("Лимит рекламы для карт исчерпан до полуночи");
        }
    }
}

// ============================================================================
// === КНОПКА «ОБНОВИТЬ» ДЛЯ СУНДУКОВ (НОВАЯ) ================================
// ============================================================================
if (prize_state == PRIZE_STATE_NONE && buy_state == BUY_STATE_NONE &&
    chest_state == CHEST_STATE_NONE && set_state == SET_STATE_NONE &&
    mouse_check_button_pressed(mb_left)) {

    var chbtn_x = (room_width - chest_refresh_button_width) / 2;
    var chbtn_y = chest_refresh_button_y - scroll_y;

    if (mouse_x >= chbtn_x && mouse_x <= chbtn_x + chest_refresh_button_width &&
        mouse_y >= chbtn_y && mouse_y <= chbtn_y + chest_refresh_button_height) {

        if (pchests.ad_charges > 0) {
            pchests.ad_charges -= 1;
            update_quest_progress("ads", 1);

            for (var i = 0; i < 4; i++) {
                chests[i].bought = false;
                pchests.bought[i] = false;
            }
            pchests.auto_refresh_at = now_ts + CHEST_AUTO_REFRESH;

            save_permanent_to_file();
            LOG("🔄 Сундуки обновлены за рекламу. Осталось зарядов: " + string(pchests.ad_charges));
        } else {
            LOG("Лимит рекламы для сундуков исчерпан до полуночи");
        }
    }
}

// ============================================================================
// === КЛИК ПО КАРТЕ ПОКУПКИ (открывает окно покупки) ========================
// ============================================================================
if (prize_state == PRIZE_STATE_NONE && chest_state == CHEST_STATE_NONE &&
    set_state == SET_STATE_NONE && mouse_check_button_pressed(mb_left)) {

    var total_width_cards = shop_cards_count * shop_card_width + (shop_cards_count - 1) * shop_card_spacing;
    var start_x_cards = (room_width - total_width_cards) / 2;

    for (var i = 0; i < shop_cards_count; i++) {
        var card_x = start_x_cards + i * (shop_card_width + shop_card_spacing);
        var card_y = shop_cards_y - scroll_y;

        if (mouse_x >= card_x - 2 && mouse_x <= card_x + shop_card_width + 2 &&
            mouse_y >= card_y - 2 && mouse_y <= card_y + shop_card_height + 2) {

            if (shop_cards[i] != undefined) {
                buy_state = BUY_STATE_SHOWING;
                buy_card = shop_cards[i];
                buy_card_index = i;
                exit;
            }
            break;
        }
    }
}

// ============================================================================
// === КЛИК ПО СУНДУКУ (открывает окно покупки сундука) ======================
// ============================================================================
if (chest_state == CHEST_STATE_NONE && buy_state == BUY_STATE_NONE &&
    prize_state == PRIZE_STATE_NONE && set_state == SET_STATE_NONE &&
    mouse_check_button_pressed(mb_left)) {

    var total_width_ch = 4 * chest_width + 3 * chest_spacing;
    var start_x_ch = (room_width - total_width_ch) / 2;

    for (var i = 0; i < 4; i++) {
        var chx = start_x_ch + i * (chest_width + chest_spacing);
        var chy = chests_start_y - scroll_y;

        if (mouse_x >= chx && mouse_x <= chx + chest_width &&
            mouse_y >= chy && mouse_y <= chy + chest_height) {

            if (chests[i].bought) {
                LOG("Сундук уже куплен");
                break;
            }

            chest_state = CHEST_STATE_SHOWING;
            current_chest = chests[i];
            current_chest_index = i;
            chest_just_opened = true;
            break;
        }
    }
}

// ============================================================================
// === КЛИК ПО НАБОРУ ========================================================
// ============================================================================
if (set_state == SET_STATE_NONE && chest_state == CHEST_STATE_NONE &&
    buy_state == BUY_STATE_NONE && prize_state == PRIZE_STATE_NONE &&
    mouse_check_button_pressed(mb_left)) {

    var total_width_sets = sets_per_row * set_width + (sets_per_row - 1) * set_spacing;
    var start_x_sets = (room_width - total_width_sets) / 2;

    for (var row = 0; row < sets_rows; row++) {
        for (var col = 0; col < sets_per_row; col++) {
            var i = row * sets_per_row + col;
            var sx = start_x_sets + col * (set_width + set_spacing);
            var sy = sets_start_y + row * (set_height + set_spacing) - scroll_y;

            if (mouse_x >= sx && mouse_x <= sx + set_width &&
                mouse_y >= sy && mouse_y <= sy + set_height) {

                set_state = SET_STATE_SHOWING;
                current_set = sets[i];
                current_set_index = i;
                set_just_opened = true;
                break;
            }
        }
    }
}

// ============================================================================
// === КЛИК В ОКНЕ ПОКУПКИ СУНДУКА ===========================================
// ============================================================================
if (chest_state == CHEST_STATE_SHOWING && mouse_check_button_pressed(mb_left)) {
    if (chest_just_opened) {
        chest_just_opened = false;
    } else {
        if (mouse_x >= chest_button_x && mouse_x <= chest_button_x + chest_button_width &&
            mouse_y >= chest_button_y && mouse_y <= chest_button_y + chest_button_height) {

            if (scr_spend_resources(current_chest.price_genes, current_chest.price_crystals)) {
                chest_rewards = [];
                for (var r = 0; r < array_length(current_chest.rewards); r++) {
                    var reward = current_chest.rewards[r];
                    var hero_ids = get_random_heroes_by_rarity(reward.rarity, reward.count);
                    for (var h = 0; h < array_length(hero_ids); h++) {
                        var hero_id = hero_ids[h];
                        var found = false;
                        for (var rr = 0; rr < array_length(chest_rewards); rr++) {
                            if (chest_rewards[rr].hero_id == hero_id) {
                                chest_rewards[rr].count++;
                                found = true;
                                break;
                            }
                        }
                        if (!found) array_push(chest_rewards, {hero_id: hero_id, count: 1});
                    }
                }

                chests[current_chest_index].bought = true;
                save_chests_data();
                save_permanent_to_file();

                chest_state = CHEST_STATE_REWARDS;
                chest_just_opened = true;
                current_chest = noone;
                current_chest_index = -1;
            } else {
                LOG("Не хватает ресурсов!");
            }
        } else {
            if (mouse_x < chest_window_x || mouse_x > chest_window_x + chest_window_width ||
                mouse_y < chest_window_y || mouse_y > chest_window_y + chest_window_height) {
                chest_state = CHEST_STATE_NONE;
                current_chest = noone;
                current_chest_index = -1;
            }
        }
    }
}

// ============================================================================
// === КЛИК В ОКНЕ НАБОРА ====================================================
// ============================================================================
if (set_state == SET_STATE_SHOWING && mouse_check_button_pressed(mb_left)) {
    if (set_just_opened) {
        set_just_opened = false;
    } else {
        if (mouse_x >= set_button_x && mouse_x <= set_button_x + set_button_width &&
            mouse_y >= set_button_y && mouse_y <= set_button_y + set_button_height) {

            if (iap_test_mode) {
                var rewards = give_set_reward(current_set);
                if (current_set.reward_type == "chest" && array_length(rewards) > 0) {
                    chest_rewards = rewards;
                    chest_state = CHEST_STATE_REWARDS;
                    chest_just_opened = true;
                }
                set_state = SET_STATE_NONE;
                current_set = noone;
                current_set_index = -1;
            } else {
                LOG("IAP пока не настроены");
                set_state = SET_STATE_NONE;
                current_set = noone;
                current_set_index = -1;
            }
        } else {
            if (mouse_x < set_window_x || mouse_x > set_window_x + set_window_width ||
                mouse_y < set_window_y || mouse_y > set_window_y + set_window_height) {
                set_state = SET_STATE_NONE;
                current_set = noone;
                current_set_index = -1;
            }
        }
    }
}

// ============================================================================
// === КЛИК В ОКНЕ ПОКУПКИ КАРТЫ =============================================
// ============================================================================
if (buy_state == BUY_STATE_SHOWING && mouse_check_button_pressed(mb_left)) {
    if (mouse_x >= buy_button_x && mouse_x <= buy_button_x + buy_button_width &&
        mouse_y >= buy_button_y && mouse_y <= buy_button_y + buy_button_height) {

        var card = buy_card;
        var hero = global.heroes[card.hero_id];

        if (scr_spend_resources(card.price_genes, card.price_crystals)) {
            add_hero_card(card.hero_id, 1);
            hero.shop_bought = true;
            hero.shop_slot = buy_card_index;

            shop_cards[buy_card_index] = undefined;
            save_shop_cards();
            save_all_data();

            buy_state = BUY_STATE_NONE;
            buy_card = noone;
            buy_card_index = -1;
        } else {
            LOG("Недостаточно ресурсов");
        }
    } else {
        if (mouse_x < buy_window_x || mouse_x > buy_window_x + buy_window_width ||
            mouse_y < buy_window_y || mouse_y > buy_window_y + buy_window_height) {
            buy_state = BUY_STATE_NONE;
            buy_card = noone;
            buy_card_index = -1;
        }
    }
}

// ============================================================================
// === КЛИК В ОКНЕ ПРИЗА =====================================================
// ============================================================================
if (prize_state == PRIZE_STATE_SHOWING && mouse_check_button_pressed(mb_left)) {
    if (mouse_x >= prize_button_x && mouse_x <= prize_button_x + prize_button_width &&
        mouse_y >= prize_button_y && mouse_y <= prize_button_y + prize_button_height) {

        if (current_prize.type == "hero") {
            add_hero_card(current_prize.hero_id, 1);
        } else if (current_prize.type == "genes") {
            scr_cheat_add_genes(current_prize.amount);
        } else if (current_prize.type == "crystals") {
            scr_cheat_add_crystals(current_prize.amount);
        }
        save_all_data();

        prize_state = PRIZE_STATE_NONE;
        current_prize = noone;
        current_state = SPIN_STATE_IDLE;
        scroll_speed = 0.5;
    }
}

// ===== ESC для закрытия окон =====
if (prize_state == PRIZE_STATE_SHOWING && IS_BACK_PRESSED) {
    prize_state = PRIZE_STATE_NONE;
    current_prize = noone;
    current_state = SPIN_STATE_IDLE;
    scroll_speed = 0.5;
}
if (buy_state == BUY_STATE_SHOWING && IS_BACK_PRESSED) {
    buy_state = BUY_STATE_NONE;
    buy_card = noone;
    buy_card_index = -1;
}
if (chest_state == CHEST_STATE_SHOWING && IS_BACK_PRESSED) {
    chest_state = CHEST_STATE_NONE;
    current_chest = noone;
    current_chest_index = -1;
}
if (set_state == SET_STATE_SHOWING && IS_BACK_PRESSED) {
    set_state = SET_STATE_NONE;
    current_set = noone;
    current_set_index = -1;
}

// ===== ЧИТ-КЛАВИШИ (только в DEBUG-сборке) =====
if (DEBUG_BUILD) {
    if (keyboard_check_pressed(ord("G"))) scr_cheat_add_genes(10000);
    if (keyboard_check_pressed(ord("C"))) scr_cheat_add_crystals(100);
    if (keyboard_check_pressed(ord("R"))) {
        scr_reset_game();
        game_end();
    }
}

// ============================================================================
// === ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ===============================================
// ============================================================================

/// @function determine_prize()
/// @desc Определяет, какая карта выпала под указателем рулетки
function determine_prize() {
    var total_cards = array_length(roulette_cards);
    if (total_cards == 0) return;

    var card_width_total = card_width + card_spacing;
    var start_x = pointer_x - card_width/2 - (scroll_x mod card_width_total);

    var found_index = -1;
    var found_card = noone;
    var best_distance = 9999;

    for (var i = -5; i <= 5; i++) {
        var card_x = start_x + i * card_width_total;
        var card_index = floor((scroll_x + i * card_width_total) / card_width_total) mod total_cards;
        if (card_index < 0) card_index += total_cards;

        if (pointer_x >= card_x && pointer_x <= card_x + card_width) {
            found_index = card_index;
            found_card = roulette_cards[card_index];
            break;
        }

        var dist_to_card = min(abs(pointer_x - card_x), abs(pointer_x - (card_x + card_width)));
        if (dist_to_card < best_distance) {
            best_distance = dist_to_card;
            found_index = card_index;
            found_card = roulette_cards[card_index];
        }
    }

    if (found_index >= 0 && found_card != noone) {
        result_card = found_index;
        current_prize = found_card;
        prize_state = PRIZE_STATE_SHOWING;
    } else {
        result_card = 0;
        current_prize = roulette_cards[0];
        prize_state = PRIZE_STATE_SHOWING;
    }
}

/// @function debug_shop_cards()
function debug_shop_cards() {
    for (var i = 0; i < shop_cards_count; i++) {
        if (shop_cards[i] != undefined) {
            LOG("  Слот " + string(i) + ": hero_id=" + string(shop_cards[i].hero_id));
        } else {
            LOG("  Слот " + string(i) + ": undefined");
        }
    }
}

/// @function is_struct(_var)
function is_struct(_var) {
    return variable_type(_var) == "struct";
}

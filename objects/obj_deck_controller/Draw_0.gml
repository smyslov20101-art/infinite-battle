/// @desc Отрисовка экрана колоды

// ===== 1. УБИРАЕМ ВСЕ СТАРЫЕ ЗАЛИВКИ И ТЕКСТЫ =====
// Фон теперь рисуется в комнате
// Фон под списком героев УБРАН полностью



// ===== 5. СПИСОК ГЕРОЕВ (БЕЗ ФОНА!) =====
var total_cards_width = cards_per_row * hero_card_width + (cards_per_row - 1) * hero_card_spacing;
list_start_x = (room_width - total_cards_width) / 2;

var draw_top = -200;
var draw_bottom = room_height + 200;

// ОБЫЧНЫЕ ГЕРОИ
var ordinary_y = list_start_y;
var ordinary_text_y = ordinary_y - 25 - scroll_y;
if (ordinary_text_y + 20 > 80 && ordinary_text_y < room_height - 200) {
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_font(fnt_m);
    draw_text(list_start_x+17, ordinary_text_y , "ОБЫЧНЫЕ ГЕРОИ:");
}

for (var row = 0; row < 2; row++) {
    for (var col = 0; col < cards_per_row; col++) {
        var hero_index = row * cards_per_row + col;
        if (hero_index >= 8) break;
        if (hero_index < array_length(global.heroes)) {
            var card_x = list_start_x + col * (hero_card_width + hero_card_spacing);
            var card_y = ordinary_y + row * (hero_card_height + hero_card_spacing) - scroll_y;
            if (card_y + hero_card_height > draw_top && card_y < draw_bottom) {
                draw_single_hero_card(hero_index, card_x, card_y);
            }
        }
    }
}

// РЕДКИЕ ГЕРОИ
var rare_y = ordinary_y + 2 * (hero_card_height + hero_card_spacing) + 40;
var rare_text_y = rare_y - 25 - scroll_y;
if (rare_text_y + 20 > 80 && rare_text_y < room_height - 200) {
    draw_set_color(make_color_rgb(100, 100, 255));
    draw_set_halign(fa_left);
    draw_set_font(fnt_m);
    draw_text(list_start_x+17, rare_text_y, "РЕДКИЕ ГЕРОИ:");
}

for (var row = 0; row < 2; row++) {
    for (var col = 0; col < cards_per_row; col++) {
        var hero_index = 8 + row * cards_per_row + col;
        if (hero_index >= 14) break;
        if (hero_index < array_length(global.heroes)) {
            var card_x = list_start_x + col * (hero_card_width + hero_card_spacing);
            var card_y = rare_y + row * (hero_card_height + hero_card_spacing) - scroll_y;
            if (card_y + hero_card_height > draw_top && card_y < draw_bottom) {
                draw_single_hero_card(hero_index, card_x, card_y);
            }
        }
    }
}

// ЭПИЧЕСКИЕ ГЕРОИ
var epic_y = rare_y + 2 * (hero_card_height + hero_card_spacing) + 40;
var epic_text_y = epic_y - 25 - scroll_y;
if (epic_text_y + 20 > 80 && epic_text_y < room_height - 200) {
    draw_set_color(make_color_rgb(180, 80, 255));
    draw_set_halign(fa_left);
    draw_set_font(fnt_m);
    draw_text(list_start_x+17, epic_text_y, "ЭПИЧЕСКИЕ ГЕРОИ:");
}

for (var row = 0; row < 1; row++) {
    for (var col = 0; col < cards_per_row; col++) {
        var hero_index = 14 + row * cards_per_row + col;
        if (hero_index >= 18) break;
        if (hero_index < array_length(global.heroes)) {
            var card_x = list_start_x + col * (hero_card_width + hero_card_spacing);
            var card_y = epic_y + row * (hero_card_height + hero_card_spacing) - scroll_y;
            if (card_y + hero_card_height > draw_top && card_y < draw_bottom) {
                draw_single_hero_card(hero_index, card_x, card_y);
            }
        }
    }
}

// ЛЕГЕНДАРНЫЕ ГЕРОИ
var legendary_y = epic_y + 1 * (hero_card_height + hero_card_spacing) + 40;
var legendary_text_y = legendary_y - 25 - scroll_y;
if (legendary_text_y + 20 > 80 && legendary_text_y < room_height - 200) {
    draw_set_color(make_color_rgb(255, 180, 50));
    draw_set_halign(fa_left);
    draw_set_font(fnt_m);
    draw_text(list_start_x+17, legendary_text_y, "ЛЕГЕНДАРНЫЕ ГЕРОИ:");
}

for (var row = 0; row < 1; row++) {
    for (var col = 0; col < 2; col++) {
        var hero_index = 18 + row * cards_per_row + col;
        if (hero_index >= 20) break;
        if (hero_index < array_length(global.heroes)) {
            var card_x = list_start_x + col * (hero_card_width + hero_card_spacing);
            var card_y = legendary_y + row * (hero_card_height + hero_card_spacing) - scroll_y;
            if (card_y + hero_card_height > draw_top && card_y < draw_bottom) {
                draw_single_hero_card(hero_index, card_x, card_y);
            }
        }
    }
}

// ===== 2. ШТОРКА ОТРЯДА (spr_party) =====
var party_spr = spr_party;
if (sprite_exists(party_spr)) {
    var spr_w = sprite_get_width(party_spr);   // 800
    var spr_h = sprite_get_height(party_spr);  // 336
    
    var party_x = room_width / 2;
    var party_y = 80 + (spr_h / 2);
    
    draw_sprite_ext(party_spr, 0, party_x, party_y, 1, 1, 0, c_white, 1);
}

// ===== 3. ОТРЯД (4 слота) — индивидуальные позиции =====
var slot_width = 100;
var slot_height = 100;
var base_slots_start_y = 215;  // Сдвиг всех слотов вниз на 50

// Индивидуальные смещения по X (от центра экрана)
var slot_offsets = [-265, -90, 90, 265];

// ===== Если мы в режиме выбора слота — заранее вычислим, какие слоты подходят =====
// Это нужно для пульсации/подсветки. Логика та же что в Step_0.
var slot_eligible = [false, false, false, false];
var in_select_mode = (current_state == SCREEN_STATE_SELECT_SLOT && selected_hero_id >= 0);

if (in_select_mode) {
    var place_hero = global.heroes[selected_hero_id];
    var place_class = place_hero.class_type;
    var place_max = (place_class == global.CLASS_MAGE || place_class == global.CLASS_SUPPORT) ? 2 : 1;

    for (var k = 0; k < 4; k++) {
        var k_hero = global.player_deck[k];
        var k_ok = true;
        if (k_hero >= 0) {
            // Считаем, сколько героев нашего класса в ДРУГИХ слотах после замены
            var other_count = 0;
            for (var m = 0; m < 4; m++) {
                if (m == k) continue;
                var mid = global.player_deck[m];
                if (mid >= 0 && global.heroes[mid].class_type == place_class) other_count++;
            }
            if (other_count >= place_max) k_ok = false;
        } else {
            if (get_class_count_in_deck(place_class) >= place_max) k_ok = false;
        }
        slot_eligible[k] = k_ok;
    }
}

// Пульсация для подсветки (синусоида)
var pulse = (sin(current_time / 150) + 1) / 2;   // 0..1 каждые ~940мс

draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

for (var i = 0; i < 4; i++) {
    // Центр слота = центр экрана + смещение
    var slot_center_x = (room_width / 2) + slot_offsets[i];
    var slot_center_y = base_slots_start_y + (slot_height / 2);

    var hero_id = global.player_deck[i];

    // ===== ПОДСВЕТКА ПОДХОДЯЩИХ СЛОТОВ В РЕЖИМЕ ВЫБОРА =====
    if (in_select_mode) {
        if (slot_eligible[i]) {
            // Зелёное пульсирующее свечение
            draw_set_color(make_color_rgb(80, 255, 120));
            draw_set_alpha(0.3 + pulse * 0.5);
            draw_circle(slot_center_x, slot_center_y - 5, 45 + pulse * 8, false);
            draw_set_alpha(1.0);
        } else {
            // Затемняем неподходящие
            draw_set_color(c_black);
            draw_set_alpha(0.55);
            draw_circle(slot_center_x, slot_center_y - 5, 42, false);
            draw_set_alpha(1.0);
        }
    }

    if (hero_id >= 0 && hero_id < array_length(global.heroes)) {
        var hero = global.heroes[hero_id];

        // Рисуем иконку героя (центрируем по центру слота)
        if (sprite_exists(hero.sprite_small) && hero.sprite_small != -1) {
            draw_sprite_ext(hero.sprite_small, 0, slot_center_x, slot_center_y - 5, 0.9, 0.9, 0, c_white, 1);
        } else {
            draw_set_color(hero.color_frame);
            draw_circle(slot_center_x, slot_center_y - 5, 35, true);
        }

        // Номер уровня (маленький в правом верхнем углу)
        draw_set_color(c_white);
        draw_set_font(fnt_level);
        draw_set_halign(fa_right);
        draw_set_valign(fa_top);
        draw_text(slot_center_x + 45, slot_center_y - 50, string(hero.level));

        // Имя героя (под кружком)
        draw_set_font(fnt_m);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_text(slot_center_x, slot_center_y + 35, hero.name);

    } else {
        // Пустой слот — рисуем плюсик
        draw_set_color(make_color_rgb(150, 150, 170));
        draw_set_alpha(0.7);
        draw_circle(slot_center_x, slot_center_y - 5, 30, true);
        draw_set_alpha(1.0);
        draw_set_color(c_white);
        draw_set_font(fnt_m);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(slot_center_x, slot_center_y - 5, "+");
    }

    // ===== РАМКА-ОБВОДКА ПОДХОДЯЩИХ СЛОТОВ ПОВЕРХ ГЕРОЯ =====
    if (in_select_mode && slot_eligible[i]) {
        draw_set_color(make_color_rgb(120, 255, 160));
        draw_set_alpha(0.6 + pulse * 0.4);
        draw_circle(slot_center_x, slot_center_y - 5, 42, true);
        draw_circle(slot_center_x, slot_center_y - 5, 43, true);
        draw_set_alpha(1.0);
    }
}

// ===== Подсказка вверху экрана в режиме выбора слота =====
if (in_select_mode) {
    var hint_y = 90;
    draw_set_font(fnt_m);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Подложка
    draw_set_color(c_black);
    draw_set_alpha(0.6);
    draw_rectangle(room_width/2 - 280, hint_y - 18, room_width/2 + 280, hint_y + 18, false);
    draw_set_alpha(1.0);

    // Текст
    var has_any_eligible = false;
    for (var e = 0; e < 4; e++) if (slot_eligible[e]) { has_any_eligible = true; break; }

    if (has_any_eligible) {
        draw_set_color(make_color_rgb(120, 255, 160));
        draw_text(room_width/2, hint_y, "Выберите слот для героя «" + global.heroes[selected_hero_id].name + "»");
    } else {
        draw_set_color(make_color_rgb(255, 120, 120));
        draw_text(room_width/2, hint_y, "Нет подходящих слотов — сначала уберите героя того же класса");
    }
}

// Сброс выравнивания
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// ===== 4. ШТОРКА РЕСУРСОВ (сверху) =====
draw_set_color(make_color_rgb(40, 40, 50));
draw_rectangle(0, 0, room_width, 80, false);

draw_set_color(c_white);
draw_set_font(fnt_m);
draw_set_halign(fa_left);
draw_text(50, 35, "ГЕНЫ: " + string(global.genes));
draw_text(250, 35, "КРИСТАЛЛЫ: " + string(global.crystals));

// ===== 7. ВЫЧИСЛЯЕМ SCROLL_MAX =====
var total_height = legendary_y + hero_card_height - list_start_y;
var extra_space = 100;
var visible_height = (room_height - 200) - list_start_y;
scroll_max = max(0, total_height + extra_space - visible_height);
scroll_y = clamp(scroll_y, 0, scroll_max);

// ===== 8. ДЕТАЛЬНАЯ КАРТОЧКА =====
if (current_state == SCREEN_STATE_HERO_DETAIL && selected_hero_id >= 0) {
    draw_hero_detail_card(selected_hero_id);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
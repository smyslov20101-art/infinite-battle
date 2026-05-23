/// @function draw_hero_detail_card(_hero_id)
/// @desc Рисует детальную карточку героя (размер 536x809)

function draw_hero_detail_card(_hero_id) {
    // Если открыто окно дерева талантов или описания - не обрабатываем клики в карточке
    if (global.talent_window_open || global.talent_desc_window_open) {
        return;
    }
    
    // Получаем контроллер для проверки таймера блокировки кнопок
    var controller = instance_find(obj_deck_controller, 0);
    var buttons_blocked = false;
    if (instance_exists(controller) && controller.card_open_timer > 0) {
        buttons_blocked = true;
    }
    
    if (_hero_id < 0 || _hero_id >= array_length(global.heroes)) return;
    
    var hero = global.heroes[_hero_id];
    
    // НОВЫЕ РАЗМЕРЫ КАРТОЧКИ (536x809)
    var card_width = 536;
    var card_height = 809;
    var card_x = (room_width - card_width) / 2;
    var card_y = (room_height - card_height) / 2;
    
    // Определяем спрайт для открытой карточки
    var open_card_sprite = noone;
    
    switch (hero.original_type) {
        case "warrior": open_card_sprite = spr_open_desk_warrior; break;
        case "archer": open_card_sprite = spr_open_desk_archer; break;
        case "mage": open_card_sprite = spr_open_desk_mage; break;
        case "healer": open_card_sprite = spr_open_desk_healer; break;
        case "tank": open_card_sprite = spr_open_desk_tank; break;
        case "rogue": open_card_sprite = spr_open_desk_rogue; break;
        case "slinger": open_card_sprite = spr_open_desk_slinger; break;
        case "forest_mage": open_card_sprite = spr_open_desk_forest_mage; break;
        case "knight": open_card_sprite = spr_open_desk_knight; break;
        case "crossbowman": open_card_sprite = spr_open_desk_crossbowman; break;
        case "ice_mage": open_card_sprite = spr_open_desk_ice_mage; break;
        case "priest": open_card_sprite = spr_open_desk_priest; break;
        case "berserker": open_card_sprite = spr_open_desk_berserker; break;
        case "elf_archer": open_card_sprite = spr_open_desk_elf_archer; break;
        case "shadow_blade": open_card_sprite = spr_open_desk_shadow_blade; break;
        case "sniper": open_card_sprite = spr_open_desk_sniper; break;
        case "lightning_mage": open_card_sprite = spr_open_desk_lightning_mage; break;
        case "druid": open_card_sprite = spr_open_desk_druid; break;
        case "paladin": open_card_sprite = spr_open_desk_paladin; break;
        case "archmage": open_card_sprite = spr_open_desk_archmage; break;
        default: open_card_sprite = spr_open_desk_warrior; break;
    }
    
    // Затемняем фон
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, room_width, room_height, true);
    draw_set_alpha(1.0);
    
    // Рисуем спрайт открытой карточки
    if (sprite_exists(open_card_sprite)) {
        draw_sprite_ext(open_card_sprite, 0, card_x + card_width/2, card_y + card_height/2, 1, 1, 0, c_white, 1);
    } else {
        // Запасной вариант — если спрайта нет
        draw_set_color(hero.color_frame);
        draw_rectangle(card_x, card_y, card_x + card_width, card_y + card_height, false);
        draw_set_color(make_color_rgb(50, 50, 70));
        draw_rectangle(card_x + 2, card_y + 2, card_x + card_width - 2, card_y + card_height - 2, false);
        
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_set_font(fnt_main);
        draw_text(card_x + card_width/2, card_y + card_height/2, hero.name);
    }
    
    // ===== 1. УРОВЕНЬ ГЕРОЯ (правый верхний угол) =====
    var level_x = card_x + card_width - 55;
    var level_y = card_y + 50;
    
    draw_set_font(fnt_level);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    if (hero.level >= 15) {
        draw_set_color(c_white);
        draw_text(level_x, level_y, "MAX");
    } else {
        draw_set_color(c_white);
        draw_text(level_x, level_y, string(hero.level));
    }
    
    // ===== 2. КНОПКА "ДОБАВИТЬ/УБРАТЬ" (spr_plus) =====
    var plus_btn_size = 48;
    var plus_btn_x = card_x + card_width - 186 - plus_btn_size/2;
    var plus_btn_y = card_y + 14;
    
    if (sprite_exists(spr_plus)) {
        draw_sprite_ext(spr_plus, 0, plus_btn_x + plus_btn_size/2, plus_btn_y + plus_btn_size/2, 1, 1, 0, c_white, 1);
    }
    
    // ===== 3. КНОПКА "ДЕРЕВО ТАЛАНТОВ" (spr_tree) =====
    var tree_btn_size = 64;
    var tree_btn_x = card_x + 33;
    var tree_btn_y = card_y + card_height - 100;
    
    if (sprite_exists(spr_tree)) {
        draw_sprite_ext(spr_tree, 0, tree_btn_x + tree_btn_size/2, tree_btn_y + tree_btn_size/2, 1, 1, 0, c_white, 1);
    }
    
    // ===== СОХРАНЯЕМ КООРДИНАТЫ ДЛЯ STEP EVENT =====
    if (instance_exists(controller)) {
        controller.detail_plus_btn_x = plus_btn_x;
        controller.detail_plus_btn_y = plus_btn_y;
        controller.detail_plus_btn_w = plus_btn_size;
        controller.detail_plus_btn_h = plus_btn_size;
        
        controller.detail_tree_btn_x = tree_btn_x;
        controller.detail_tree_btn_y = tree_btn_y;
        controller.detail_tree_btn_w = tree_btn_size;
        controller.detail_tree_btn_h = tree_btn_size;
        
        controller.detail_card_x = card_x;
        controller.detail_card_y = card_y;
        controller.detail_card_w = card_width;
        controller.detail_card_h = card_height;
        controller.detail_hero_id = _hero_id;
        
        // Проверяем, есть ли герой уже в отряде
        var in_deck = false;
        for (var i = 0; i < 4; i++) {
            if (global.player_deck[i] == _hero_id) {
                in_deck = true;
                break;
            }
        }
        controller.detail_in_deck = in_deck;
        
        var hero_class = hero.class_type;
        var class_count = get_class_count_in_deck(hero_class);
        var max_allowed = 1;
        if (hero_class == global.CLASS_MELEE) max_allowed = 1;
        else if (hero_class == global.CLASS_RANGED) max_allowed = 1;
        else if (hero_class == global.CLASS_MAGE) max_allowed = 2;
        else if (hero_class == global.CLASS_SUPPORT) max_allowed = 2;
        
        controller.detail_class_count = class_count;
        controller.detail_max_allowed = max_allowed;
    }
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
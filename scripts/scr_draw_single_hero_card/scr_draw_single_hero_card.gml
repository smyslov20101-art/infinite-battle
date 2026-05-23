/// @function draw_single_hero_card(_hero_index, _x, _y)
/// @desc Рисует одну карточку героя (спрайты Bottom Center, размер 172x223)

function draw_single_hero_card(_hero_index, _x, _y) {
    if (_hero_index >= array_length(global.heroes)) return;
    
    var hero = global.heroes[_hero_index];
    
    // Размеры карточки
    var hero_card_width = 172;
    var hero_card_height = 223;
    
    // Определяем спрайт карточки
    var card_sprite = noone;
    
    // ЕСЛИ ГЕРОЙ ЗАБЛОКИРОВАН - ИСПОЛЬЗУЕМ СПРАЙТ-ЗАГЛУШКУ
    if (!hero.unlocked) {
        switch (hero.rarity) {
            case 0: card_sprite = spr_unlook_desk_1; break;  // Обычный
            case 1: card_sprite = spr_unlook_desk_2; break;  // Редкий
            case 2: card_sprite = spr_unlook_desk_3; break;  // Эпический
            case 3: card_sprite = spr_unlook_desk_4; break;  // Легендарный
            default: card_sprite = spr_unlook_desk_1; break;
        }
    } else {
        // ГЕРОЙ РАЗБЛОКИРОВАН - ИСПОЛЬЗУЕМ ЕГО СПРАЙТ
        switch (hero.original_type) {
            case "warrior": card_sprite = spr_desk_warrior; break;
            case "archer": card_sprite = spr_desk_archer; break;
            case "mage": card_sprite = spr_desk_mage; break;
            case "healer": card_sprite = spr_desk_healer; break;
            case "tank": card_sprite = spr_desk_tank; break;
            case "rogue": card_sprite = spr_desk_rogue; break;
            case "slinger": card_sprite = spr_desk_slinger; break;
            case "forest_mage": card_sprite = spr_desk_forest_mage; break;
            case "knight": card_sprite = spr_desk_knight; break;
            case "crossbowman": card_sprite = spr_desk_crossbowman; break;
            case "ice_mage": card_sprite = spr_desk_ice_mage; break;
            case "priest": card_sprite = spr_desk_priest; break;
            case "berserker": card_sprite = spr_desk_berserker; break;
            case "elf_archer": card_sprite = spr_desk_elf_archer; break;
            case "shadow_blade": card_sprite = spr_desk_shadow_blade; break;
            case "sniper": card_sprite = spr_desk_sniper; break;
            case "lightning_mage": card_sprite = spr_desk_lightning_mage; break;
            case "druid": card_sprite = spr_desk_druid; break;
            case "paladin": card_sprite = spr_desk_paladin; break;
            case "archmage": card_sprite = spr_desk_archmage; break;
            default: card_sprite = spr_desk_warrior; break;
        }
    }
    
    // Рисуем спрайт карточки (если существует)
    if (sprite_exists(card_sprite)) {
        var draw_y = _y + hero_card_height;
        draw_sprite_ext(card_sprite, 0, _x + hero_card_width/2, draw_y, 1, 1, 0, c_white, 1);
    } else {
        // Запасной вариант — если спрайта нет
        draw_set_color(hero.color_frame);
        draw_rectangle(_x - 2, _y - 2, _x + hero_card_width + 2, _y + hero_card_height + 2, false);
        draw_set_color(make_color_rgb(50, 50, 70));
        draw_rectangle(_x, _y, _x + hero_card_width, _y + hero_card_height, false);
    }
    
    // ===== 1. УРОВЕНЬ ГЕРОЯ (правый верхний угол) =====
    var level_x = _x + hero_card_width - 37;
    var level_y = _y + 33;
    
    draw_set_color(c_white);
    draw_set_font(fnt_level);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    if (hero.unlocked) {
        draw_text(level_x, level_y, string(hero.level));
    } 
    
    // ===== 2. ПРОГРЕСС КАРТ (снизу) =====
    if (hero.unlocked && hero.level < 15) {
        var required = hero.get_required_cards();
        var current = hero.cards_collected;
        var progress_text = string(current) + "/" + string(required);
        
        var progress_x = _x + hero_card_width/2;
        var progress_y = _y + hero_card_height - 34;
        
        draw_set_color(c_white);
        draw_set_font(fnt_small);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(progress_x, progress_y, progress_text);
    } else if (hero.unlocked && hero.level >= 15) {
        var progress_x = _x + hero_card_width/2;
        var progress_y = _y + hero_card_height - 34;
        
        draw_set_color(c_white);
        draw_set_font(fnt_small);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(progress_x, progress_y, "MAX");
    } else if (!hero.unlocked) {
        var required = 1;
        var current = hero.cards_collected;
        var progress_text = string(current) + "/" + string(required);
        
        var progress_x = _x + hero_card_width/2;
        var progress_y = _y + hero_card_height - 30;
        
        draw_set_color(make_color_rgb(180, 180, 180));
        draw_set_font(fnt_small);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(progress_x, progress_y, progress_text);
    }
    
    // Возвращаем выравнивание
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
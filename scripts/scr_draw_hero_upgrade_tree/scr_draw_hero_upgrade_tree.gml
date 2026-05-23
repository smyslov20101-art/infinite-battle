/// @function draw_hero_upgrade_tree(_x, _y, _width, _tree)
/// @desc Рисует красивое дерево прокачки для одного героя

function draw_hero_upgrade_tree(_x, _y, _width, _tree) {
    if (_tree == noone || !is_struct(_tree)) return;
    
    // ===== ОСНОВНЫЕ ПАРАМЕТРЫ =====
    var sprite_size = 80;
    var sprite_x = _x + _width/2;
    var sprite_y = _y + sprite_size/2;
    
    var level_height = 65; // Расстояние между уровнями
    var max_levels = 5;    // Максимум 5 уровней
    
    // ===== ФОН КОЛОНКИ =====
    // Темный фон
    draw_set_color(make_color_rgb(25, 25, 35));
    draw_rectangle(_x - 5, _y - 10, _x + _width + 5, _y + sprite_size + 40 + max_levels * level_height + 30, false);
    
    // Рамка
    draw_set_color(make_color_rgb(80, 80, 100));
    draw_rectangle(_x - 5, _y - 10, _x + _width + 5, _y + sprite_size + 40 + max_levels * level_height + 30, true);
    
    // ===== СПРАЙТ ГЕРОЯ =====
    // Рамка спрайта
    draw_set_color(make_color_rgb(100, 100, 150));
    draw_rectangle(sprite_x - sprite_size/2 - 3, sprite_y - sprite_size/2 - 3,
                   sprite_x + sprite_size/2 + 3, sprite_y + sprite_size/2 + 3, false);
    
    // Фон спрайта
    draw_set_color(make_color_rgb(50, 50, 70));
    draw_rectangle(sprite_x - sprite_size/2, sprite_y - sprite_size/2,
                   sprite_x + sprite_size/2, sprite_y + sprite_size/2, true);
    
    // Спрайт героя
    if (struct_exists(_tree, "hero_sprite") && _tree.hero_sprite != -1 && sprite_exists(_tree.hero_sprite)) {
        draw_sprite(_tree.hero_sprite, 0, sprite_x, sprite_y);
    } else {
        // Цветная заглушка
        if (struct_exists(_tree, "hero_class")) {
            switch (_tree.hero_class) {
                case "melee": draw_set_color(c_blue); break;
                case "ranged": draw_set_color(c_green); break;
                case "mage": draw_set_color(c_purple); break;
                case "support": draw_set_color(c_yellow); break;
                default: draw_set_color(c_gray);
            }
        } else {
            draw_set_color(c_blue);
        }
        draw_circle(sprite_x, sprite_y, 30, true);
        
        // Первая буква имени
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_font(fnt_m);
        
        if (struct_exists(_tree, "hero_name") && _tree.hero_name != "") {
            var first_char = string_char_at(_tree.hero_name, 1);
            draw_text(sprite_x, sprite_y, first_char);
        } else {
            draw_text(sprite_x, sprite_y, "?");
        }
    }
    
    // ===== ИНФОРМАЦИЯ НАД СПРАЙТОМ =====
    draw_set_halign(fa_center);
    
    // Имя героя
    draw_set_color(c_white);
    draw_set_font(fnt_m);
    if (struct_exists(_tree, "hero_name")) {
        draw_text(sprite_x, sprite_y - sprite_size/2 - 25, _tree.hero_name);
    }
    
    // Количество доступных уровней
    draw_set_color(c_yellow);
    draw_set_font(fnt_m);
    if (struct_exists(_tree, "unlocked_levels")) {
        draw_text(sprite_x, sprite_y - sprite_size/2 - 45, "УРОВЕНЬ " + string(_tree.unlocked_levels));
    }
    
    // ===== СТОИМОСТЬ ПРИЗЫВА =====
    var cost = 10;
    if (struct_exists(_tree, "get_summon_cost") && is_method(_tree.get_summon_cost)) {
        cost = _tree.get_summon_cost();
    }
    
    // Фон для цены
    draw_set_color(make_color_rgb(40, 40, 50));
    draw_rectangle(sprite_x - 60, sprite_y + sprite_size/2 + 5, 
                   sprite_x + 60, sprite_y + sprite_size/2 + 35, true);
    
    // Текст цены
    draw_set_color(c_yellow);
    draw_set_font(fnt_m);
    draw_text(sprite_x, sprite_y + sprite_size/2 + 20, "⚡ " + string(cost) + " 🪙");
    
    // ===== ДЕРЕВО УЛУЧШЕНИЙ =====
    var start_upgrade_y = _y + sprite_size + 60;
    
    // Вертикальная линия (ствол дерева)
    draw_set_color(make_color_rgb(150, 150, 150));
    draw_line(sprite_x, start_upgrade_y - 20, sprite_x, start_upgrade_y + max_levels * level_height);
    
    for (var level = 0; level < max_levels; level++) {
        var upgrade_y = start_upgrade_y + level * level_height;
        
        // Определяем статус уровня
        var is_unlocked = false;
        var is_chosen = false;
        var is_current = false;
        
        if (struct_exists(_tree, "unlocked_levels")) {
            is_unlocked = (level < _tree.unlocked_levels);
        }
        
        // Проверяем, выбран ли этот уровень
        if (struct_exists(_tree, "chosen_upgrades") && is_array(_tree.chosen_upgrades)) {
            for (var u = 0; u < array_length(_tree.chosen_upgrades); u++) {
                if (is_struct(_tree.chosen_upgrades[u]) && 
                    struct_exists(_tree.chosen_upgrades[u], "level") &&
                    _tree.chosen_upgrades[u].level == level) {
                    is_chosen = true;
                    break;
                }
            }
        }
        
        // Текущий доступный невыбранный уровень
        if (struct_exists(_tree, "unlocked_levels")) {
            is_current = (level == _tree.unlocked_levels - 1 && !is_chosen);
        }
        
        // Горизонтальные ветки
        if (is_unlocked) {
            draw_set_color(c_yellow);
        } else {
            draw_set_color(make_color_rgb(80, 80, 80));
        }
        draw_line(sprite_x, upgrade_y, sprite_x + 40, upgrade_y);
        draw_line(sprite_x, upgrade_y, sprite_x - 40, upgrade_y);
        
        // ===== ЛЕВАЯ КНОПКА (HP) =====
        var btn_left_center_x = sprite_x - 40;  // Центр левой кнопки
        
        // ОТЛАДКА: покажем границы кнопки для текущего уровня
        if (is_current) {
            LOG("🎨 ОТРИСОВКА: Левая кнопка для " + _tree.hero_name + 
                              ", уровень " + string(level) + 
                              ", центр X=" + string(btn_left_center_x) + 
                              ", Y=" + string(upgrade_y) +
                              ", границы X: [" + string(btn_left_center_x - 18) + ", " + string(btn_left_center_x + 18) + "]" +
                              ", границы Y: [" + string(upgrade_y - 18) + ", " + string(upgrade_y + 18) + "]");
        }
        
        if (is_chosen) {
            // Уже выбрано - зеленая галочка
            draw_set_color(c_green);
            draw_rectangle(btn_left_center_x - 18, upgrade_y - 18, 
                           btn_left_center_x + 18, upgrade_y + 18, false);
            draw_set_color(c_white);
            draw_set_font(fnt_m);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(btn_left_center_x, upgrade_y, "✓");
        } else if (is_current) {
            // Текущий доступный уровень - красное сердечко
            draw_set_color(c_red);
            draw_rectangle(btn_left_center_x - 18, upgrade_y - 18, 
                           btn_left_center_x + 18, upgrade_y + 18, false);
            draw_set_color(c_white);
            draw_set_font(fnt_m);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(btn_left_center_x, upgrade_y, "❤");
        } else if (is_unlocked) {
            // Уже пройденный уровень (но не выбран) - серая кнопка
            draw_set_color(make_color_rgb(80, 80, 80));
            draw_rectangle(btn_left_center_x - 18, upgrade_y - 18, 
                           btn_left_center_x + 18, upgrade_y + 18, false);
            draw_set_color(make_color_rgb(150, 150, 150));
            draw_set_font(fnt_m);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(btn_left_center_x, upgrade_y, "❤");
        } else {
            // Заблокированный уровень - темная кнопка с вопросом
            draw_set_color(make_color_rgb(50, 50, 60));
            draw_rectangle(btn_left_center_x - 18, upgrade_y - 18, 
                           btn_left_center_x + 18, upgrade_y + 18, false);
            draw_set_color(make_color_rgb(80, 80, 90));
            draw_set_font(fnt_m);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(btn_left_center_x, upgrade_y, "?");
        }
        
        // ===== ПРАВАЯ КНОПКА (DAMAGE) =====
        var btn_right_center_x = sprite_x + 40;  // Центр правой кнопки
        
        // ОТЛАДКА: покажем границы кнопки для текущего уровня
        if (is_current) {
            LOG("🎨 ОТРИСОВКА: Правая кнопка для " + _tree.hero_name + 
                              ", уровень " + string(level) + 
                              ", центр X=" + string(btn_right_center_x) + 
                              ", Y=" + string(upgrade_y) +
                              ", границы X: [" + string(btn_right_center_x - 18) + ", " + string(btn_right_center_x + 18) + "]" +
                              ", границы Y: [" + string(upgrade_y - 18) + ", " + string(upgrade_y + 18) + "]");
        }
        
        if (is_chosen) {
            // Уже выбрано - зеленая галочка
            draw_set_color(c_green);
            draw_rectangle(btn_right_center_x - 18, upgrade_y - 18, 
                           btn_right_center_x + 18, upgrade_y + 18, false);
            draw_set_color(c_white);
            draw_set_font(fnt_m);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(btn_right_center_x, upgrade_y, "✓");
        } else if (is_current) {
            // Текущий доступный уровень - оранжевый меч
            draw_set_color(c_orange);
            draw_rectangle(btn_right_center_x - 18, upgrade_y - 18, 
                           btn_right_center_x + 18, upgrade_y + 18, false);
            draw_set_color(c_white);
            draw_set_font(fnt_m);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(btn_right_center_x, upgrade_y, "⚔");
        } else if (is_unlocked) {
            // Уже пройденный уровень (но не выбран) - серая кнопка
            draw_set_color(make_color_rgb(80, 80, 80));
            draw_rectangle(btn_right_center_x - 18, upgrade_y - 18, 
                           btn_right_center_x + 18, upgrade_y + 18, false);
            draw_set_color(make_color_rgb(150, 150, 150));
            draw_set_font(fnt_m);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(btn_right_center_x, upgrade_y, "⚔");
        } else {
            // Заблокированный уровень - темная кнопка с вопросом
            draw_set_color(make_color_rgb(50, 50, 60));
            draw_rectangle(btn_right_center_x - 18, upgrade_y - 18, 
                           btn_right_center_x + 18, upgrade_y + 18, false);
            draw_set_color(make_color_rgb(80, 80, 90));
            draw_set_font(fnt_m);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(btn_right_center_x, upgrade_y, "?");
        }
        
        // ===== ТЕКСТ УЛУЧШЕНИЙ ПОД КНОПКАМИ =====
        if (struct_exists(_tree, "upgrades") && is_array(_tree.upgrades) && 
            level < array_length(_tree.upgrades)) {
            
            var upgrades = _tree.upgrades[level];
            
            if (is_array(upgrades) && array_length(upgrades) >= 2) {
                draw_set_font(fnt_level);
                draw_set_halign(fa_center);
                
                // Левый текст (HP)
                if (is_struct(upgrades[0]) && struct_exists(upgrades[0], "name")) {
                    if (is_unlocked) {
                        draw_set_color(c_white);
                    } else {
                        draw_set_color(make_color_rgb(100, 100, 100));
                    }
                    draw_text(btn_left_center_x, upgrade_y + 25, upgrades[0].name);
                }
                
                // Правый текст (Damage)
                if (is_struct(upgrades[1]) && struct_exists(upgrades[1], "name")) {
                    if (is_unlocked) {
                        draw_set_color(c_white);
                    } else {
                        draw_set_color(make_color_rgb(100, 100, 100));
                    }
                    draw_text(btn_right_center_x, upgrade_y + 25, upgrades[1].name);
                }
            }
        }
    }
    
    // ===== ИТОГОВЫЕ БОНУСЫ ВНИЗУ =====
    if (struct_exists(_tree, "chosen_upgrades") && is_array(_tree.chosen_upgrades)) {
        var total_hp = 0;
        var total_damage = 0;
        
        for (var u = 0; u < array_length(_tree.chosen_upgrades); u++) {
            if (is_struct(_tree.chosen_upgrades[u])) {
                if (_tree.chosen_upgrades[u].type == "hp") {
                    total_hp += _tree.chosen_upgrades[u].value;
                } else if (_tree.chosen_upgrades[u].type == "damage") {
                    total_damage += _tree.chosen_upgrades[u].value;
                }
            }
        }
        
        if (total_hp > 0 || total_damage > 0) {
            var bonus_y = _y + sprite_size + 40 + max_levels * level_height + 15;
            
            draw_set_color(c_yellow);
            draw_set_font(fnt_m);
            draw_set_halign(fa_center);
            
            var bonus_text = "";
            if (total_hp > 0) bonus_text += "❤ +" + string(total_hp) + "% ";
            if (total_damage > 0) bonus_text += "⚔ +" + string(total_damage) + "%";
            
            draw_text(sprite_x, bonus_y, bonus_text);
        }
    }
    
    draw_set_halign(fa_left);
}
/// Draw Event - obj_game_controller

// ===== 1. СНАЧАЛА РИСУЕМ ДЕРЕВЬЯ (САМЫЙ НИЖНИЙ СЛОЙ) =====
for (var i = 0; i < tree_settings.count; i++) {
    if (hero_trees[i] == noone) continue;
    
    var tree = hero_trees[i];
    var tree_x = tree_settings.start_x + i * (tree_settings.column_width + tree_settings.column_spacing);
    var tree_y = tree_settings.base_y - tree_scroll_y - 80;
    
    // Проверяем, видимо ли дерево (с учетом 10 уровней)
    var tree_full_height = 10 * tree_settings.level_height + 120;
    if (tree_y + tree_full_height < 0 || tree_y - 35 > room_height) continue;
    
    // Проверяем, жив ли герой
    var hero_alive = false;
    with (obj_hero_base) {
        if (hero_id == tree.hero_id && hp > 0) {
            hero_alive = true;
            break;
        }
    }
    
    // Спрайт заблокирован (серый), только если герой жив
    var sprite_disabled = hero_alive;
    
    // Определяем цвет в зависимости от класса героя
    var class_color = c_blue;
    var class_color_light = make_color_rgb(100, 100, 255);
    var class_color_dark = make_color_rgb(40, 40, 80);
    var disabled_color = make_color_rgb(80, 80, 80);
    
    switch (tree.hero_class) {
        case global.CLASS_MELEE: 
            class_color = c_blue;
            class_color_light = make_color_rgb(100, 100, 255);
            class_color_dark = make_color_rgb(40, 40, 80);
            break;
        case global.CLASS_RANGED: 
            class_color = c_green;
            class_color_light = make_color_rgb(100, 255, 100);
            class_color_dark = make_color_rgb(40, 80, 40);
            break;
        case global.CLASS_MAGE: 
            class_color = c_purple;
            class_color_light = make_color_rgb(180, 100, 255);
            class_color_dark = make_color_rgb(60, 40, 80);
            break;
        case global.CLASS_SUPPORT: 
            class_color = c_yellow;
            class_color_light = make_color_rgb(255, 255, 100);
            class_color_dark = make_color_rgb(80, 80, 40);
            break;
    }
    
    // Если спрайт заблокирован - используем серые цвета
    if (sprite_disabled) {
        class_color = disabled_color;
        class_color_light = make_color_rgb(100, 100, 100);
        class_color_dark = make_color_rgb(50, 50, 50);
    }
    
    // ===== РАСШИРЕННЫЙ ФОН КОЛОНКИ (ДЛЯ 10 УРОВНЕЙ) =====
    var background_height = 10 * tree_settings.level_height + 120;
    draw_set_color(make_color_rgb(20, 20, 30));
    draw_rectangle(tree_x - 125, tree_y - 35, tree_x + 75, tree_y + background_height, false);
    
    // Внутренняя подсветка сверху
    draw_set_color(class_color_dark);
    draw_set_alpha(0.3);
    draw_rectangle(tree_x - 123, tree_y - 33, tree_x + 73, tree_y - 20, false);
    draw_set_alpha(1.0);
    
    // Рамка колонки
    draw_set_color(class_color);
    draw_set_alpha(0.3);
    draw_rectangle(tree_x - 125, tree_y - 35, tree_x + 75, tree_y + background_height, true);
    draw_set_alpha(1.0);
    
    // ===== СПРАЙТ =====
    var sprite_center_x = tree_x;
    var sprite_center_y = tree_y + 20;
    
    // Внешнее свечение (только если не заблокирован)
    if (!sprite_disabled) {
        draw_set_color(class_color);
        draw_set_alpha(0.2);
        draw_circle(sprite_center_x, sprite_center_y, tree_settings.sprite_size/2 + 8, false);
        draw_set_alpha(1.0);
    }
    
    // Рамка спрайта
    draw_set_color(class_color_light);
    draw_rectangle(sprite_center_x - tree_settings.sprite_size/2 - 3, 
                   sprite_center_y - tree_settings.sprite_size/2 - 3,
                   sprite_center_x + tree_settings.sprite_size/2 + 3, 
                   sprite_center_y + tree_settings.sprite_size/2 + 3, false);
    
    // Внутренняя рамка
    draw_set_color(class_color_dark);
    draw_rectangle(sprite_center_x - tree_settings.sprite_size/2 - 1, 
                   sprite_center_y - tree_settings.sprite_size/2 - 1,
                   sprite_center_x + tree_settings.sprite_size/2 + 1, 
                   sprite_center_y + tree_settings.sprite_size/2 + 1, false);
    
    // Фон спрайта с градиентом
    for (var g = 0; g < tree_settings.sprite_size; g += 5) {
        var alpha = 0.7 - (g / tree_settings.sprite_size) * 0.3;
        draw_set_color(class_color_dark);
        draw_set_alpha(alpha);
        draw_rectangle(sprite_center_x - tree_settings.sprite_size/2, 
                       sprite_center_y - tree_settings.sprite_size/2 + g,
                       sprite_center_x + tree_settings.sprite_size/2, 
                       sprite_center_y - tree_settings.sprite_size/2 + g + 5, false);
    }
    draw_set_alpha(1.0);
    
    // Спрайт героя (НЕ РИСУЕМ ЕСЛИ ПРИЗВАН!)
    if (!sprite_disabled) {
        if (sprite_exists(tree.hero_sprite)) {
            draw_sprite(tree.hero_sprite, 0, sprite_center_x, sprite_center_y);
        } else {
            draw_set_color(class_color_light);
            draw_circle(sprite_center_x, sprite_center_y, 30, true);
        }
    }
    
    // ===== ЦЕНА ПРИЗЫВА =====
    var hero_alive_for_price = false;
    with (obj_hero_base) {
        if (hero_id == tree.hero_id && hp > 0) {
            hero_alive_for_price = true;
            break;
        }
    }
    
    // Фон для цены
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_set_alpha(0.5);
    draw_rectangle(sprite_center_x - 50, sprite_center_y + 70, sprite_center_x + 50, sprite_center_y + 100, false);
    draw_set_alpha(1.0);
    
    // Рамка цены
    draw_set_color(class_color);
    draw_set_alpha(0.3);
    draw_rectangle(sprite_center_x - 50, sprite_center_y + 70, sprite_center_x + 50, sprite_center_y + 100, true);
    draw_set_alpha(1.0);
    
    // Текст цены
    draw_set_color(c_yellow);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    if (hero_alive_for_price) {
        draw_set_color(c_red);
        draw_text(sprite_center_x, sprite_center_y + 85, "В БОЮ");
    } else {
        var cost = tree.get_respawn_cost();
        draw_set_color(c_yellow);
        draw_text(sprite_center_x, sprite_center_y + 85, "⚡ " + string(cost) + " 🪙");
        
        if (tree.total_deaths > 0) {
            draw_set_font(fnt_level);
            draw_set_color(make_color_rgb(255, 100, 100));
            draw_text(sprite_center_x, sprite_center_y + 105, "штраф: " + string(tree.total_deaths * 5));
            draw_set_font(fnt_m);
        }
    }
    
    // ===== КНОПКИ УЛУЧШЕНИЙ =====
    var start_y = sprite_center_y + 120;
    
    // Рисуем линии соединения (ствол дерева)
    draw_set_color(class_color);
    draw_set_alpha(0.3);
    for (var level = 0; level < tree_settings.max_levels; level++) {
        var btn_y = start_y + level * tree_settings.level_height;
        draw_line(sprite_center_x, sprite_center_y + 80, sprite_center_x, btn_y - 20);
    }
    draw_set_alpha(1.0);
    
    for (var level = 0; level < tree_settings.max_levels; level++) {
        var btn_y = start_y + level * tree_settings.level_height;
        
        // Проверяем статус уровня
        var is_unlocked_by_progress = (level < tree.unlocked_levels);
        
        // Проверяем, соответствует ли уровень требованиям по уровню карточки героя
        var required_hero_level = TREE_LEVEL_REQUIREMENTS[level];
        var hero_data = global.heroes[tree.hero_id];
        var hero_card_level = hero_data.level;
        
        var meets_card_requirement = (required_hero_level == 0 || hero_card_level >= required_hero_level);
        
        // Уровень доступен только если и прогресс дерева позволяет, И карточка героя достаточного уровня
        var is_unlocked = is_unlocked_by_progress && meets_card_requirement;
        
        // Флаг: уровень заблокирован из-за карточки
        var is_locked_by_card = (is_unlocked_by_progress && !meets_card_requirement);
        
        // ===== ИСПРАВЛЕНО: Проверяем, выбран ли этот уровень, используя поле side =====
        var level_chosen = false;
        var left_chosen = false;
        var right_chosen = false;
        
        for (var u = 0; u < array_length(tree.chosen_upgrades); u++) {
            if (tree.chosen_upgrades[u].level == level) {
                level_chosen = true;
                
                // ВСЕГДА используем поле side
                if (variable_struct_exists(tree.chosen_upgrades[u], "side")) {
                    if (tree.chosen_upgrades[u].side == "left") {
                        left_chosen = true;
                    } else if (tree.chosen_upgrades[u].side == "right") {
                        right_chosen = true;
                    }
                } else {
                    // Для старых сохранений: определяем по типу и добавляем поле side
                    if (tree.chosen_upgrades[u].type == "hp" || tree.chosen_upgrades[u].type == "armor" || 
                        tree.chosen_upgrades[u].type == "attack_speed" || tree.chosen_upgrades[u].type == "range") {
                        left_chosen = true;
                        tree.chosen_upgrades[u].side = "left";
                    } else {
                        right_chosen = true;
                        tree.chosen_upgrades[u].side = "right";
                    }
                }
            }
        }
        
        // Сохраняем координаты кнопок
        tree.upgrades[level][0].x = sprite_center_x - 40;
        tree.upgrades[level][0].y = btn_y;
        tree.upgrades[level][1].x = sprite_center_x + 40;
        tree.upgrades[level][1].y = btn_y;
        
        // Горизонтальные ветки
        draw_set_color(class_color);
        draw_set_alpha(0.3);
        draw_line(sprite_center_x - 30, btn_y, sprite_center_x + 30, btn_y);
        draw_set_alpha(1.0);
        
        // ===== ЛЕВАЯ КНОПКА =====
        var btn_left_x = sprite_center_x - 40;
        var left_type = tree.upgrades[level][0].type;
        var left_name = tree.upgrades[level][0].name;
        var left_value = tree.upgrades[level][0].value;
        
        // Тень кнопки
        draw_set_color(c_black);
        draw_set_alpha(0.3);
        draw_rectangle(btn_left_x - 18 + 2, btn_y - 18 + 2, btn_left_x + 18 + 2, btn_y + 18 + 2, false);
        draw_set_alpha(1.0);
        
        if (left_chosen) {
            draw_set_color(c_green);
            draw_rectangle(btn_left_x - 18, btn_y - 18, btn_left_x + 18, btn_y + 18, false);
            draw_set_color(c_white);
            draw_set_font(fnt_m);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(btn_left_x, btn_y, "✓");
            
        } else if (is_locked_by_card) {
            draw_set_color(make_color_rgb(80, 80, 80));
            draw_rectangle(btn_left_x - 18, btn_y - 18, btn_left_x + 18, btn_y + 18, false);
            draw_set_color(make_color_rgb(180, 180, 180));
            draw_set_font(fnt_m);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(btn_left_x, btn_y, "🔒");
            
        } else if (is_unlocked && !level_chosen && !right_chosen) {
            var icon_color = variable_struct_get(global.UPGRADE_COLORS, left_type);
            var icon = variable_struct_get(global.UPGRADE_ICONS, left_type);
            
            if (is_undefined(icon_color)) icon_color = c_white;
            if (is_undefined(icon)) icon = "?";
            
            draw_set_color(icon_color);
            draw_rectangle(btn_left_x - 18, btn_y - 18, btn_left_x + 18, btn_y + 18, false);
            draw_set_color(c_white);
            draw_set_font(fnt_m);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(btn_left_x, btn_y, icon);
            
        } else {
            draw_set_color(make_color_rgb(50, 50, 60));
            draw_rectangle(btn_left_x - 18, btn_y - 18, btn_left_x + 18, btn_y + 18, false);
            draw_set_color(make_color_rgb(80, 80, 90));
            draw_set_font(fnt_m);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(btn_left_x, btn_y, "?");
        }
        
        // ===== СТОИМОСТЬ ПОД ЛЕВОЙ КНОПКОЙ =====
        if (is_unlocked && !level_chosen && !right_chosen) {
            var upgrade_cost = tree.get_upgrade_cost(level);
            draw_set_color(c_yellow);
            draw_set_font(fnt_level);
            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            draw_text(btn_left_x, btn_y + 25, string(upgrade_cost));
            draw_text(btn_left_x, btn_y + 38, "🪙");
        }
        
        // ===== ПРАВАЯ КНОПКА =====
        var btn_right_x = sprite_center_x + 40;
        var right_type = tree.upgrades[level][1].type;
        var right_name = tree.upgrades[level][1].name;
        var right_value = tree.upgrades[level][1].value;
        
        // Тень кнопки
        draw_set_color(c_black);
        draw_set_alpha(0.3);
        draw_rectangle(btn_right_x - 18 + 2, btn_y - 18 + 2, btn_right_x + 18 + 2, btn_y + 18 + 2, false);
        draw_set_alpha(1.0);
        
        if (right_chosen) {
            draw_set_color(c_green);
            draw_rectangle(btn_right_x - 18, btn_y - 18, btn_right_x + 18, btn_y + 18, false);
            draw_set_color(c_white);
            draw_set_font(fnt_m);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(btn_right_x, btn_y, "✓");
            
        } else if (is_locked_by_card) {
            draw_set_color(make_color_rgb(80, 80, 80));
            draw_rectangle(btn_right_x - 18, btn_y - 18, btn_right_x + 18, btn_y + 18, false);
            draw_set_color(make_color_rgb(180, 180, 180));
            draw_set_font(fnt_m);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(btn_right_x, btn_y, "🔒");
            
        } else if (is_unlocked && !level_chosen && !left_chosen) {
            var icon_color = variable_struct_get(global.UPGRADE_COLORS, right_type);
            var icon = variable_struct_get(global.UPGRADE_ICONS, right_type);
            
            if (is_undefined(icon_color)) icon_color = c_white;
            if (is_undefined(icon)) icon = "?";
            
            draw_set_color(icon_color);
            draw_rectangle(btn_right_x - 18, btn_y - 18, btn_right_x + 18, btn_y + 18, false);
            draw_set_color(c_white);
            draw_set_font(fnt_m);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(btn_right_x, btn_y, icon);
            
        } else {
            draw_set_color(make_color_rgb(50, 50, 60));
            draw_rectangle(btn_right_x - 18, btn_y - 18, btn_right_x + 18, btn_y + 18, false);
            draw_set_color(make_color_rgb(80, 80, 90));
            draw_set_font(fnt_m);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(btn_right_x, btn_y, "?");
        }
        
        // ===== СТОИМОСТЬ ПОД ПРАВОЙ КНОПКОЙ =====
        if (is_unlocked && !level_chosen && !left_chosen) {
            var upgrade_cost = tree.get_upgrade_cost(level);
            draw_set_color(c_yellow);
            draw_set_font(fnt_level);
            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            draw_text(btn_right_x, btn_y + 25, string(upgrade_cost));
            draw_text(btn_right_x, btn_y + 38, "🪙");
        }
        
        // Подсказка о требуемом уровне карточки (если заблокировано карточкой)
        if (is_locked_by_card) {
            var req_level = TREE_LEVEL_REQUIREMENTS[level];
            draw_set_color(c_yellow);
            draw_set_font(fnt_level);
            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            
        }
    }
    
    
}

// ===== 2. ФОН ИГРОВОЙ ЗОНЫ =====
draw_set_color(make_color_rgb(20, 20, 30));
draw_rectangle(0, 0, room_width, BATTLE_LINE_Y, false);

// ===== 3. РАЗДЕЛИТЕЛЬНАЯ ПОЛОСА =====
draw_set_color(make_color_rgb(255, 255, 0));
draw_set_alpha(0.3);
for (var l = 0; l < 3; l++) {
    draw_line(0, BATTLE_LINE_Y - 2 + l*2, room_width, BATTLE_LINE_Y - 2 + l*2);
}
draw_set_alpha(1.0);

// ===== 4. ВРАГИ =====
with (obj_enemy_base) {
    var _prev_halign = draw_get_halign();
    var _prev_valign = draw_get_valign();
    var _prev_color = draw_get_color();
    var _prev_alpha = draw_get_alpha();
    var _prev_font = draw_get_font();
    
    draw_self();
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_set_alpha(1.0);
    draw_set_font(fnt_m);
    
    var damage_y = y - 80;
    if (sprite_exists(spr_sword)) {
        draw_sprite(spr_sword, 0, x - 15, damage_y);
    } else {
        draw_set_color(c_silver);
        draw_text(x - 15, damage_y, "⚔");
    }
    draw_set_halign(fa_left);
    draw_text(x - 3, damage_y, string(floor(damage)));
    draw_set_halign(fa_center);
    
    var health_y = y - 50;
    if (sprite_exists(spr_heart)) {
        draw_sprite(spr_heart, 0, x - 15, health_y);
    } else {
        draw_set_color(c_red);
        draw_text(x - 15, health_y, "❤");
    }
    draw_set_halign(fa_left);
    draw_text(x - 3, health_y, string(floor(hp)));
    
    if (enemy_type == "miniboss") {
        draw_set_halign(fa_center);
        draw_set_color(c_yellow);
        draw_set_font(fnt_m);
        draw_text(x, y - 110, "МИНИ-БОСС");
    } else if (enemy_type == "boss") {
        draw_set_halign(fa_center);
        draw_set_color(c_red);
        draw_set_font(fnt_m);
        draw_text(x, y - 110, "БОСС");
    }
    
    draw_set_halign(_prev_halign);
    draw_set_valign(_prev_valign);
    draw_set_color(_prev_color);
    draw_set_alpha(_prev_alpha);
    draw_set_font(_prev_font);
}

// ===== 5. ГЕРОИ =====
with (obj_hero_base) {
    var _prev_halign = draw_get_halign();
    var _prev_valign = draw_get_valign();
    var _prev_color = draw_get_color();
    var _prev_alpha = draw_get_alpha();
    var _prev_font = draw_get_font();
    
    draw_self();
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_set_alpha(1.0);
    draw_set_font(fnt_m);
    
    // Броня (самая верхняя)
    if (variable_instance_exists(id, "armor") && armor > 0) {
        var armor_y = y - 105;
        if (sprite_exists(spr_shield)) {
            draw_sprite(spr_shield, 0, x - 15, armor_y);
        } else {
            draw_set_color(c_gray);
            draw_text(x - 15, armor_y, "🛡️");
        }
        draw_set_halign(fa_left);
        draw_set_color(c_white);
        draw_text(x - 3, armor_y, string(armor));
        draw_set_halign(fa_center);
    }
    
    // Урон / Лечение / Щит (в зависимости от типа героя)
    var damage_y = y - 80;
    
    // ===== ОПРЕДЕЛЯЕМ ТИП ГЕРОЯ И РИСУЕМ СООТВЕТСТВУЮЩУЮ ИКОНКУ =====
    
    // Проверяем на жреца (priest)
    if (hero_type == "priest") {
        // Жрец - показывает лечение
        if (sprite_exists(spr_heal)) {
            draw_sprite(spr_heal, 0, x - 15, damage_y);
        } else {
            draw_set_color(c_green);
            draw_text(x - 15, damage_y, "+");
        }
        draw_set_halign(fa_left);
        draw_text(x - 3, damage_y, string(healing_power));
    }
    // Проверяем на танка
    else if (hero_type == "tank") {
        // Танк - показывает щит
        if (sprite_exists(spr_shield_icon)) {
            draw_sprite(spr_shield_icon, 0, x - 15, damage_y);
        } else {
            draw_set_color(c_teal);
            draw_text(x - 15, damage_y, "🛡️");
        }
        draw_set_halign(fa_left);
        draw_text(x - 3, damage_y, string(shield));
    }
    // Проверяем на хилера (healer)
    else if (hero_type == "healer") {
        // Хилер - показывает лечение
        if (sprite_exists(spr_heal)) {
            draw_sprite(spr_heal, 0, x - 15, damage_y);
        } else {
            draw_set_color(c_green);
            draw_text(x - 15, damage_y, "+");
        }
        draw_set_halign(fa_left);
        draw_text(x - 3, damage_y, string(healing_power));
    }
    // Остальные герои - показывают урон
    else {
        if (sprite_exists(spr_sword)) {
            draw_sprite(spr_sword, 0, x - 15, damage_y);
        } else {
            draw_set_color(c_silver);
            draw_text(x - 15, damage_y, "⚔");
        }
        draw_set_halign(fa_left);
        draw_text(x - 3, damage_y, string_format(damage, 0, 0));
    }
    
    // Здоровье
    var health_y = y - 50;
    if (sprite_exists(spr_heart)) {
        draw_sprite(spr_heart, 0, x - 15, health_y);
    } else {
        draw_set_color(c_red);
        draw_text(x - 15, health_y, "❤");
    }
    draw_set_halign(fa_left);
    draw_text(x - 3, health_y, string(floor(hp)));
    draw_set_halign(fa_center);
    
    // Кружок с уровнем
    var level_circle_y = y + 60;
    var circle_radius = 20;
    draw_set_color(c_white);
    draw_circle(x, level_circle_y, circle_radius, true);
    draw_set_color(c_gray);
    draw_circle(x, level_circle_y, circle_radius, false);
    draw_set_color(c_white);
    draw_set_font(fnt_level);
    draw_text(x, level_circle_y, string(hero_level));
    
    draw_set_halign(_prev_halign);
    draw_set_valign(_prev_valign);
    draw_set_color(_prev_color);
    draw_set_alpha(_prev_alpha);
    draw_set_font(_prev_font);
}

// ===== 6. СНАРЯДЫ =====
with (obj_arrow) { draw_self(); }
with (obj_enemy_arrow) { draw_self(); }
with (obj_magic_ball) { draw_self(); }

// ===== 7. ПРИЗРАКИ =====
with (obj_hero_ghost) { draw_self(); }

// ===== 8. ИНФОРМАЦИЯ =====
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fnt_m);
draw_set_color(c_white);

draw_set_color(make_color_rgb(30, 30, 40));
draw_rectangle(30, 30, 250, 240, false);

draw_set_color(c_yellow);
draw_text(50, 50, "МОНЕТЫ: " + string_format(coins, 0, 1));
draw_set_color(c_white);
draw_text(50, 80, "ВРЕМЯ: " + string_format(game_time, 0, 1) + "s");
draw_text(50, 110, "ГЕНЫ: " + string(floor(session_genes)));
draw_text(50, 140, "СЛОЖНОСТЬ: " + string(difficulty_level));

if (floor_mode) {
    var floor_id = 0;
    if (variable_global_exists("current_floor") && global.current_floor != noone) {
        floor_id = global.current_floor.id;
    }
    if (floor_id > 0) {
        draw_set_color(c_yellow);
        draw_set_halign(fa_center);
        draw_text(room_width/2, 100, "ЭТАЖ " + string(floor_id));
    }
}

// Сердечки
draw_set_halign(fa_right);
var heart_x = room_width - 50;
var heart_y = 50;
var heart_spacing = 40;

for (var i = 0; i < max_lives; i++) {
    if (i < current_lives) {
        draw_set_color(c_red);
    } else {
        draw_set_color(make_color_rgb(60, 60, 60));
    }
    if (sprite_exists(spr_heart)) {
        draw_sprite(spr_heart, 0, heart_x - i * heart_spacing, heart_y);
    } else {
        draw_text(heart_x - i * heart_spacing, heart_y, "❤");
    }
}

// Кнопка паузы
if (!game_over) {
    var pause_hovered = (mouse_x >= pause_button_x && mouse_x <= pause_button_x + pause_button_width &&
                         mouse_y >= pause_button_y && mouse_y <= pause_button_y + pause_button_height);
    
    draw_set_color(c_black);
    draw_set_alpha(0.3);
    draw_rectangle(pause_button_x + 2, pause_button_y + 2, 
                   pause_button_x + pause_button_width + 2, 
                   pause_button_y + pause_button_height + 2, true);
    draw_set_alpha(1.0);
    
    draw_set_color(pause_hovered ? pause_button_hover_color : pause_button_color);
    draw_rectangle(pause_button_x, pause_button_y, 
                   pause_button_x + pause_button_width, 
                   pause_button_y + pause_button_height, true);
    draw_set_color(c_white);
    draw_rectangle(pause_button_x, pause_button_y, 
                   pause_button_x + pause_button_width, 
                   pause_button_y + pause_button_height, true);
    
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(pause_button_x + pause_button_width/2, 
              pause_button_y + pause_button_height/2, "ПАУЗА");
}

// Состояния
switch (controller_state) {
    case CONTROLLER_STATE_PAUSE:
        draw_pause_state();
        break;
    case CONTROLLER_STATE_GAMEOVER:
        draw_gameover_state();
        break;
}

// Подсказки для тестовой комнаты
if (room == room_test) {
    draw_set_color(c_yellow);
    draw_set_halign(fa_left);
    draw_set_valign(fa_bottom);
    draw_set_font(fnt_m);
    
    var hint_y = room_height - 900;
    draw_text(20, hint_y, "=== ТЕСТОВЫЕ ЧИТЫ ===");
    draw_text(20, hint_y + 25, "ENTER - 100 урона всем героям");
    draw_text(20, hint_y + 50, "1 - 10 урона всем героям");
    draw_text(20, hint_y + 75, "2 - полное лечение всех героев");
    draw_text(20, hint_y + 100, "3 - восстановление щитов");
}

if (variable_global_exists("upgrade_window_open") && global.upgrade_window_open) {
    // Окно рисуется само в своем Draw Event
    // Здесь можно нарисовать затемнение фона, но не обязательно
    exit;
}
// Сброс настроек
draw_set_alpha(1.0);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
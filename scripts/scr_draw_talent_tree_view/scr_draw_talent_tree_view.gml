/// @function draw_talent_tree_view(_tree, _win_x, _win_y, _win_width, _scroll_y)
/// @desc Рисует дерево талантов в окне просмотра

function draw_talent_tree_view(_tree, _win_x, _win_y, _win_width, _scroll_y) {
    if (_tree == noone) return;
    
    var tree_x = _win_x + _win_width/2;
    var tree_y = _win_y + 100 - _scroll_y;
    
    // Получаем реальное количество уровней в дереве
    var max_levels = array_length(_tree.upgrades);
    if (max_levels == 0) return;
    
    // Определяем цвет класса
    var class_color = c_blue;
    switch (_tree.hero_class) {
        case global.CLASS_MELEE: class_color = c_blue; break;
        case global.CLASS_RANGED: class_color = c_green; break;
        case global.CLASS_MAGE: class_color = c_purple; break;
        case global.CLASS_SUPPORT: class_color = c_yellow; break;
    }
    
    var start_y = tree_y;
    var level_height = 90;
    
    // Рисуем ствол дерева
    draw_set_color(class_color);
    draw_set_alpha(0.3);
    for (var level = 0; level < max_levels; level++) {
        var btn_y = start_y + level * level_height;
        draw_line(tree_x, start_y - 20, tree_x, btn_y - 20);
    }
    draw_set_alpha(1.0);
    
    // Рисуем каждый уровень
    for (var level = 0; level < max_levels; level++) {
        var btn_y = start_y + level * level_height;
        
        // Проверяем, выбран ли уровень
var left_chosen = false;
var right_chosen = false;

for (var u = 0; u < array_length(_tree.chosen_upgrades); u++) {
    if (_tree.chosen_upgrades[u].level == level) {
        if (variable_struct_exists(_tree.chosen_upgrades[u], "side")) {
            if (_tree.chosen_upgrades[u].side == "left") {
                left_chosen = true;
            } else if (_tree.chosen_upgrades[u].side == "right") {
                right_chosen = true;
            }
        } else {
            if (_tree.chosen_upgrades[u].type == "hp" || _tree.chosen_upgrades[u].type == "armor" || 
                _tree.chosen_upgrades[u].type == "attack_speed" || _tree.chosen_upgrades[u].type == "range") {
                left_chosen = true;
            } else {
                right_chosen = true;
            }
        }
    }
}
        
        // Горизонтальные ветки
        draw_set_color(class_color);
        draw_set_alpha(0.3);
        draw_line(tree_x - 35, btn_y, tree_x + 35, btn_y);
        draw_set_alpha(1.0);
        
        // ===== ЛЕВАЯ КНОПКА =====
        var btn_left_x = tree_x - 55;
        
        if (array_length(_tree.upgrades[level]) > 0) {
            var left_type = _tree.upgrades[level][0].type;
            var left_value = _tree.upgrades[level][0].value;
            var left_name = _tree.upgrades[level][0].name;
            
            // Сохраняем координаты кнопки для проверки клика
            _tree.upgrades[level][0].x = btn_left_x;
            _tree.upgrades[level][0].y = btn_y;
            
            draw_set_alpha(0.8);
            if (left_chosen) {
                draw_set_color(c_green);
                draw_rectangle(btn_left_x - 20, btn_y - 20, btn_left_x + 20, btn_y + 20, false);
                draw_set_color(c_white);
                draw_set_font(fnt_m);
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_text(btn_left_x, btn_y, "✓");
            } else {
                var icon_color = variable_struct_get(global.UPGRADE_COLORS, left_type);
                var icon = variable_struct_get(global.UPGRADE_ICONS, left_type);
                if (is_undefined(icon_color)) icon_color = c_white;
                if (is_undefined(icon)) icon = "?";
                
                draw_set_color(icon_color);
                draw_rectangle(btn_left_x - 20, btn_y - 20, btn_left_x + 20, btn_y + 20, false);
                draw_set_color(c_white);
                draw_set_font(fnt_m);
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_text(btn_left_x, btn_y, icon);
            }
            
            // Номер уровня
            draw_set_color(c_white);
            draw_set_font(fnt_level);
            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            draw_text(btn_left_x, btn_y - 30, "Ур. " + string(level + 1));
        }
        
        // ===== ПРАВАЯ КНОПКА =====
        var btn_right_x = tree_x + 55;
        
        if (array_length(_tree.upgrades[level]) > 1) {
            var right_type = _tree.upgrades[level][1].type;
            var right_value = _tree.upgrades[level][1].value;
            var right_name = _tree.upgrades[level][1].name;
            
            // Сохраняем координаты кнопки для проверки клика
            _tree.upgrades[level][1].x = btn_right_x;
            _tree.upgrades[level][1].y = btn_y;
            
            if (right_chosen) {
                draw_set_color(c_green);
                draw_rectangle(btn_right_x - 20, btn_y - 20, btn_right_x + 20, btn_y + 20, false);
                draw_set_color(c_white);
                draw_set_font(fnt_m);
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_text(btn_right_x, btn_y, "✓");
            } else {
                var icon_color = variable_struct_get(global.UPGRADE_COLORS, right_type);
                var icon = variable_struct_get(global.UPGRADE_ICONS, right_type);
                if (is_undefined(icon_color)) icon_color = c_white;
                if (is_undefined(icon)) icon = "?";
                
                draw_set_color(icon_color);
                draw_rectangle(btn_right_x - 20, btn_y - 20, btn_right_x + 20, btn_y + 20, false);
                draw_set_color(c_white);
                draw_set_font(fnt_m);
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_text(btn_right_x, btn_y, icon);
            }
            
            // Номер уровня
            draw_set_color(c_white);
            draw_set_font(fnt_level);
            draw_set_halign(fa_center);
            draw_set_valign(fa_top);
            draw_text(btn_right_x, btn_y - 30, "Ур. " + string(level + 1));
        }
    }
    
    draw_set_alpha(1.0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
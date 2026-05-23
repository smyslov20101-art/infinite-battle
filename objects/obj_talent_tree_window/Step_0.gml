/// Step Event - obj_talent_tree_window

// Убеждаемся, что флаг открытого окна установлен сразу при создании
if (!global.talent_window_open && !just_opened) {
    global.talent_window_open = true;
    LOG("=== УСТАНОВЛЕН ФЛАГ talent_window_open = true ===");
}

// Если дерево ещё не создано и hero_id уже установлен
if (hero_tree == noone && hero_id >= 0) {
    // Проверяем, существует ли контроллер игры
    var controller = instance_find(obj_game_controller, 0);
    if (instance_exists(controller)) {
        // Ищем дерево для этого героя в контроллере
        for (var i = 0; i < 4; i++) {
            if (controller.hero_trees[i] != noone && controller.hero_trees[i].hero_id == hero_id) {
                hero_tree = controller.hero_trees[i];
                LOG("=== ДЕРЕВО НАЙДЕНО В КОНТРОЛЛЕРЕ для героя ID=" + string(hero_id));
                break;
            }
        }
    }
    
    // Если всё ещё не нашли, создаём новое дерево
    if (hero_tree == noone) {
        var tree_data = get_hero_tree_data(hero_id);
        var hero = global.heroes[hero_id];
        
        hero_tree = {
            hero_id: hero_id,
            hero_name: hero.name,
            hero_type: hero.original_type,
            hero_class: hero.class_type,
            hero_sprite: hero.sprite_small,
            unlocked_levels: 0,
            current_level: 0,
            chosen_upgrades: [],
            upgrades: tree_data,
            base_cost: 10,
            summon_count: 0,
            total_deaths: 0,
            base_upgrade_cost: 12,
            upgrade_cost_multiplier: 1.5,
            
            get_summon_cost: function() {
                return floor(self.base_cost * (1 + self.summon_count * 0.5));
            },
            
            get_respawn_cost: function() {
                var base = 10;
                var death_penalty = self.total_deaths * 5;
                var upgrade_bonus = array_length(self.chosen_upgrades) * 3;
                return floor(base + death_penalty + upgrade_bonus);
            },
            
            get_upgrade_cost: function(_level) {
                return floor(self.base_upgrade_cost * power(self.upgrade_cost_multiplier, _level));
            },
            
            get_total_hp_bonus: function() {
                var total = 0;
                for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                    if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_HP) {
                        total += self.chosen_upgrades[u].value;
                    }
                }
                return total;
            },
            
            get_total_damage_bonus: function() {
                var total = 0;
                for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                    if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_DAMAGE) {
                        total += self.chosen_upgrades[u].value;
                    }
                }
                return total;
            },
            
            get_total_armor: function() {
                var total = 0;
                for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                    if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_ARMOR) {
                        total += self.chosen_upgrades[u].value;
                    }
                }
                return total;
            },
            
            get_total_cleave: function() {
                var total = 0;
                for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                    if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_CLEAVE) {
                        total += self.chosen_upgrades[u].value;
                    }
                }
                return total;
            },
            
            get_total_attack_speed: function() {
                var total = 0;
                for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                    if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_ATTACK_SPEED) {
                        total += self.chosen_upgrades[u].value;
                    }
                }
                return total;
            },
            
            get_total_crit_chance: function() {
                var total = 0;
                for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                    if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_CRIT_CHANCE) {
                        total += self.chosen_upgrades[u].value;
                    }
                }
                return total;
            },
            
            get_total_crit_damage: function() {
                var total = 0;
                for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                    if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_CRIT_DAMAGE) {
                        total += self.chosen_upgrades[u].value;
                    }
                }
                return total;
            },
            
            get_total_lifesteal: function() {
                var total = 0;
                for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                    if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_LIFESTEAL) {
                        total += self.chosen_upgrades[u].value;
                    }
                }
                return total;
            },
            
            get_total_dodge: function() {
                var total = 0;
                for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                    if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_DODGE) {
                        total += self.chosen_upgrades[u].value;
                    }
                }
                return total;
            }
        };
        LOG("=== СОЗДАНО НОВОЕ ДЕРЕВО для героя ID=" + string(hero_id));
    }
}

// ПРОВЕРКА: если hero_tree всё ещё noone — выходим, чтобы не было ошибок
if (hero_tree == noone) {
    LOG("=== ОШИБКА: hero_tree не загружен! hero_id=" + string(hero_id));
    // Пытаемся ещё раз найти в контроллере
    var controller = instance_find(obj_game_controller, 0);
    if (instance_exists(controller)) {
        for (var i = 0; i < 4; i++) {
            if (controller.hero_trees[i] != noone && controller.hero_trees[i].hero_id == hero_id) {
                hero_tree = controller.hero_trees[i];
                LOG("=== ДЕРЕВО НАЙДЕНО ПРИ ПОВТОРНОЙ ПОПЫТКЕ");
                break;
            }
        }
    }
    if (hero_tree == noone) {
        exit;
    }
}

// Закрытие по ESC
if (IS_BACK_PRESSED) {
    global.talent_window_open = false;
    LOG("=== СБРОШЕН ФЛАГ talent_window_open (ESC) ===");
    instance_destroy();
    exit;
}

// Сброс флага после первого кадра
if (just_opened) {
    just_opened = false;
    exit;
}

// ===== КНОПКА ЗАКРЫТИЯ ✕ =====
if (mouse_check_button_released(mb_left)) {
    if (point_distance(mouse_x, mouse_y, close_btn_cx, close_btn_cy) <= close_btn_radius) {
        global.talent_window_open = false;
        LOG("=== СБРОШЕН ФЛАГ talent_window_open (клик по ✕) ===");
        instance_destroy();
        exit;
    }
}

// ===== КНОПКИ НАВИГАЦИИ =====
if (mouse_check_button_released(mb_left)) {
    // Кнопка "НАЗАД" (левая)
    if (mouse_x >= prev_button_x && mouse_x <= prev_button_x + button_width &&
        mouse_y >= prev_button_y && mouse_y <= prev_button_y + button_height) {
        if (current_page > 0) {
            current_page--;
        }
        exit;
    }
    
    // Кнопка "ВПЕРЁД" (правая)
    if (mouse_x >= next_button_x && mouse_x <= next_button_x + button_width &&
        mouse_y >= next_button_y && mouse_y <= next_button_y + button_height) {
        if (current_page < total_pages - 1) {
            current_page++;
        }
        exit;
    }
}

// ===== КЛИКИ ПО КНОПКАМ ТАЛАНТОВ =====
if (mouse_check_button_released(mb_left) && hero_tree != noone && !global.talent_desc_window_open) {
    var max_levels = array_length(hero_tree.upgrades);
    var start_level = current_page * levels_per_page;
    var end_level = min(start_level + levels_per_page, max_levels);
    
    for (var level = start_level; level < end_level; level++) {
        // Проверяем левую кнопку
        if (array_length(hero_tree.upgrades[level]) > 0) {
            var left_btn = hero_tree.upgrades[level][0];
            if (struct_exists(left_btn, "x") && struct_exists(left_btn, "y")) {
                var left_x = left_btn.x;
                var left_y = left_btn.y;
                
                if (mouse_x >= left_x - 45 && mouse_x <= left_x + 45 &&
                    mouse_y >= left_y - 45 && mouse_y <= left_y + 45) {
                    
                    var talent_name = hero_tree.upgrades[level][0].name;
                    var talent_type = hero_tree.upgrades[level][0].type;
                    var talent_value = hero_tree.upgrades[level][0].value;
                    var talent_description = get_talent_description(talent_type, talent_value);
                    
                    var desc_window = instance_create_layer(0, 0, "Instances", obj_talent_description_window);
                    desc_window.talent_name = talent_name;
                    desc_window.talent_description = talent_description;
                    
                    exit;
                }
            }
        }
        
        // Проверяем правую кнопку
        if (array_length(hero_tree.upgrades[level]) > 1) {
            var right_btn = hero_tree.upgrades[level][1];
            if (struct_exists(right_btn, "x") && struct_exists(right_btn, "y")) {
                var right_x = right_btn.x;
                var right_y = right_btn.y;
                
                if (mouse_x >= right_x - 45 && mouse_x <= right_x + 45 &&
                    mouse_y >= right_y - 45 && mouse_y <= right_y + 45) {
                    
                    var talent_name = hero_tree.upgrades[level][1].name;
                    var talent_type = hero_tree.upgrades[level][1].type;
                    var talent_value = hero_tree.upgrades[level][1].value;
                    var talent_description = get_talent_description(talent_type, talent_value);
                    
                    var desc_window = instance_create_layer(0, 0, "Instances", obj_talent_description_window);
                    desc_window.talent_name = talent_name;
                    desc_window.talent_description = talent_description;
                    
                    exit;
                }
            }
        }
    }
}

// Клик вне окна — закрываем
if (mouse_check_button_released(mb_left)) {
    if (mouse_x < window_x || mouse_x > window_x + window_width ||
        mouse_y < window_y || mouse_y > window_y + window_height) {
        global.talent_window_open = false;
        LOG("=== СБРОШЕН ФЛАГ talent_window_open (клик вне) ===");
        instance_destroy();
        exit;
    }
}

// Блокируем любые клики внутри окна (кроме кнопок навигации и талантов)
if (mouse_check_button_pressed(mb_left) || mouse_check_button_released(mb_left)) {
    if (mouse_x >= window_x && mouse_x <= window_x + window_width &&
        mouse_y >= window_y && mouse_y <= window_y + window_height) {
        // Проверяем, не над кнопками ли навигации
        var over_nav_button = (mouse_x >= prev_button_x && mouse_x <= prev_button_x + button_width &&
                               mouse_y >= prev_button_y && mouse_y <= prev_button_y + button_height) ||
                              (mouse_x >= next_button_x && mouse_x <= next_button_x + button_width &&
                               mouse_y >= next_button_y && mouse_y <= next_button_y + button_height) ||
                              (point_distance(mouse_x, mouse_y, close_btn_cx, close_btn_cy) <= close_btn_radius);
        
        // Проверяем, не над кнопками ли талантов
        var over_talent = false;
        if (hero_tree != noone) {
            var max_levels = array_length(hero_tree.upgrades);
            var start_level = current_page * levels_per_page;
            var end_level = min(start_level + levels_per_page, max_levels);
            
            for (var level = start_level; level < end_level && !over_talent; level++) {
                if (array_length(hero_tree.upgrades[level]) > 0) {
                    var left_btn = hero_tree.upgrades[level][0];
                    if (struct_exists(left_btn, "x") && mouse_x >= left_btn.x - 45 && mouse_x <= left_btn.x + 45 &&
                        mouse_y >= left_btn.y - 45 && mouse_y <= left_btn.y + 45) {
                        over_talent = true;
                    }
                }
                if (!over_talent && array_length(hero_tree.upgrades[level]) > 1) {
                    var right_btn = hero_tree.upgrades[level][1];
                    if (struct_exists(right_btn, "x") && mouse_x >= right_btn.x - 45 && mouse_x <= right_btn.x + 45 &&
                        mouse_y >= right_btn.y - 45 && mouse_y <= right_btn.y + 45) {
                        over_talent = true;
                    }
                }
            }
        }
        
        // Клик мимо узлов/кнопок навигации — закрываем окно (мобильный паттерн)
        if (!over_nav_button && !over_talent && mouse_check_button_released(mb_left)) {
            global.talent_window_open = false;
            LOG("=== СБРОШЕН ФЛАГ talent_window_open (клик в пустоту) ===");
            instance_destroy();
            exit;
        }
    }
}
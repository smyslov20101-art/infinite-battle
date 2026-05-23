/// Create Event - obj_talent_tree_window

// Получаем hero_id из аргументов (он должен быть передан при создании)
hero_id = -1;
hero_tree = noone;

LOG("=== CREATE ОКНА ДЕРЕВА ТАЛАНТОВ ===");
LOG("Переданный hero_id = " + string(hero_id));

// Если hero_id не передан, пробуем получить из глобальной переменной
if (hero_id < 0 && variable_global_exists("pending_hero_id")) {
    hero_id = global.pending_hero_id;
    global.pending_hero_id = -1;
    LOG("Взяли hero_id из pending_hero_id: " + string(hero_id));
}

// Если всё ещё нет, пробуем найти в контроллере
if (hero_id < 0) {
    var controller = instance_find(obj_game_controller, 0);
    if (instance_exists(controller)) {
        // Ищем первый непустой слот в отряде
        for (var i = 0; i < 4; i++) {
            if (global.player_deck[i] >= 0) {
                hero_id = global.player_deck[i];
                LOG("Взяли hero_id из отряда: " + string(hero_id));
                break;
            }
        }
    }
}

// СРАЗУ УСТАНАВЛИВАЕМ ФЛАГ
global.talent_window_open = true;
LOG("=== CREATE: УСТАНОВЛЕН ФЛАГ talent_window_open = true ===");

// Параметры окна (под фон Маши 800×800 из Figma)
window_x = (room_width - 800) / 2;
window_y = (room_height - 950) / 2;
window_width = 800;
window_height = 950;

// Параметры страниц
current_page = 0;
levels_per_page = 5;
total_pages = 2;

// Кнопки навигации — круглые ◀ ▶ в неоновом стиле (диаметр 56)
button_width = 56;
button_height = 56;
prev_button_x = window_x + 60;
prev_button_y = window_y + 780; // внутри фона дерева, у «корней» (не залазит на рамку)
next_button_x = window_x + window_width - 60 - button_width;
next_button_y = window_y + 780;

// Кнопка закрытия — кружок ✕ в правом верхнем углу
close_btn_radius = 28;
close_btn_cx = window_x + window_width - 60;
close_btn_cy = window_y + 90;

just_opened = true;
depth = -5;

// Загружаем дерево для героя
if (hero_id >= 0) {
    var controller = instance_find(obj_game_controller, 0);
    if (instance_exists(controller)) {
        // Ищем дерево в контроллере
        for (var i = 0; i < 4; i++) {
            if (controller.hero_trees[i] != noone && controller.hero_trees[i].hero_id == hero_id) {
                hero_tree = controller.hero_trees[i];
                LOG("=== ДЕРЕВО ЗАГРУЖЕНО ИЗ КОНТРОЛЛЕРА для героя ID=" + string(hero_id));
                break;
            }
        }
    }
    
    // Если не нашли в контроллере, создаём новое дерево
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
} else {
    LOG("=== ОШИБКА: hero_id = -1, дерево не может быть загружено ===");
}

LOG("=== ОТКРЫТО ОКНО ДЕРЕВА ТАЛАНТОВ ===");
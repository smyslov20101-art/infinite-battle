/// Create Event - obj_game_controller

LOG("=== СОЗДАНИЕ GAME CONTROLLER ===");

// ПРИНУДИТЕЛЬНО инициализируем героев, если их нет
if (!variable_global_exists("heroes") || array_length(global.heroes) == 0) {
    LOG("!!! global.heroes пуст, инициализируем ПРИНУДИТЕЛЬНО !!!");
    init_hero_manager();
} else {
    LOG("Система героев уже инициализирована, длина: " + string(array_length(global.heroes)));
}

// Обновляем глобальные переменные из current_session
if (variable_global_exists("current_session")) {
    global.genes = global.current_session.genes;
    global.player_deck = global.current_session.deck;
    
    LOG("Загружено из current_session:");
    LOG("Гены: " + string(global.genes));
    LOG("Отряд: " + 
                      string(global.player_deck[0]) + "," +
                      string(global.player_deck[1]) + "," +
                      string(global.player_deck[2]) + "," +
                      string(global.player_deck[3]));
} else {
    LOG("!!! current_session не существует, использую глобальные значения");
    global.player_deck = [0, 1, 2, 3];
}

// ===== СБРАСЫВАЕМ ПЕРЕМЕННЫЕ ИГРЫ =====
wave_genes = 0;
wave_crystals = 0;
wave_chests = [];
coins = 10;
session_genes = 0;
total_genes = global.genes;

// ===== ДАННЫЕ ДЛЯ ЭТАЖЕЙ =====
floor_mode = false;
floor_start_time = 0;
floor_hero_level = 1;
floor_tap_level = 1;
floor_initialized = false;
boss_just_killed = false;

// Включение нужных категорий для теста
debug_enable_category("combat");
debug_enable_category("dodge");
debug_enable_category("vampire");

// ===== ПРОВЕРЯЕМ ДАННЫЕ ЭТАЖА =====
if (variable_global_exists("current_floor") && global.current_floor != noone) {
    LOG_CAT("Загружены данные этажа: " + string(global.current_floor.id), "general");
    floor_mode = true;
    floor_start_time = global.current_floor.time_start;
    floor_hero_level = global.current_floor.hero_level;
    floor_tap_level = global.current_floor.tap_level;
} else {
    LOG_CAT("Режим бесконечной волны", "general");
}

// Инициализируем контроллер игры
scr_game_controller_init(id);

// ===== СОСТОЯНИЯ КОНТРОЛЛЕРА =====
CONTROLLER_STATE_WAVE = 0;
CONTROLLER_STATE_PAUSE = 1;
CONTROLLER_STATE_GAMEOVER = 2;
controller_state = CONTROLLER_STATE_WAVE;

// ===== ПЕРЕМЕННЫЕ ИГРЫ =====
game_time = 0;
game_over = false;
game_over_timer = 0;

// ===== СИСТЕМА ЖИЗНЕЙ =====
max_lives = 3;
current_lives = max_lives;

// ===== СИСТЕМА СЛОЖНОСТИ =====
difficulty_level = 1;
difficulty_timer = 0;
difficulty_interval = 30;

// ===== ПАРАМЕТРЫ СПАВНА =====
spawn_x = 100;
spawn_y = 600;
enemy_spawn_timer = 1;
enemy_spawn_interval = 1;
enemy_spawn_interval_base = 1;
enemies_spawned = 0;
enemies_killed = 0;
max_enemies_on_field = 5;
current_enemies_on_field = 0;

// ===== БОССЫ =====
miniboss_spawn_count = 0;
boss_spawn_count = 0;
miniboss_timer = 300;
boss_timer = 600;
boss_active = false;
pause_spawn_on_boss = false;

// ===== БАЗОВЫЕ ХАРАКТЕРИСТИКИ ВРАГОВ =====
enemy_hp_base = 25;
enemy_damage_base = 2;
enemy_reward_base = 5;
enemy_coin_base = 1;
enemy_spawn_interval_base = 3.0;

// ===== КНОПКА ПАУЗЫ =====
pause_button_x = room_width / 2 - 50;
pause_button_y = 20;
pause_button_width = 100;
pause_button_height = 40;
pause_button_color = make_color_rgb(100, 100, 100);
pause_button_hover_color = make_color_rgb(150, 150, 150);
pause_button_current_color = pause_button_color;
pause_button_hovered = false;

// ===== НОВЫЕ ПЕРЕМЕННЫЕ ДЛЯ ИНТЕРФЕЙСА =====
BATTLE_LINE_Y = 700;
TREE_BASE_Y = 700;
INTERFACE_SCROLL_Y = 0;
INTERFACE_SCROLL_MAX = 500;
INTERFACE_SCROLL_SPEED = 30;
is_dragging_interface = false;
drag_interface_start_y = 0;
scroll_interface_start_y = 0;

// ===== ПРОВЕРКА СПРАЙТОВ ГЕРОЕВ =====
LOG_CAT("=== ПРОВЕРКА СПРАЙТОВ ГЕРОЕВ ===", "general");
for (var i = 0; i < array_length(global.heroes); i++) {
    var hero = global.heroes[i];
    var sprite_id = hero.sprite_small;
    LOG_CAT("Герой " + string(i) + ": " + hero.name + 
              ", sprite_small=" + string(sprite_id) + 
              ", sprite_exists=" + string(sprite_exists(sprite_id)), "general");
}

// ===== ПРОВЕРЯЕМ, ЧТО ГЕРОИ ИНИЦИАЛИЗИРОВАНЫ =====
LOG_CAT("=== ПРОВЕРКА global.heroes ===", "general");
if (variable_global_exists("heroes")) {
    LOG_CAT("global.heroes существует, длина: " + string(array_length(global.heroes)), "general");
    
    if (array_length(global.heroes) == 0) {
        LOG_CAT("!!! global.heroes пуст, инициализируем снова !!!", "general");
        init_hero_manager();
    }
    
    for (var h = 0; h < min(5, array_length(global.heroes)); h++) {
        LOG_CAT("  Герой " + string(h) + ": " + global.heroes[h].name, "general");
    }
} else {
    LOG_CAT("global.heroes НЕ существует! Инициализируем...", "general");
    init_hero_manager();
}

// ===== ФУНКЦИЯ СОЗДАНИЯ ДЕРЕВА ДЛЯ ГЕРОЯ =====
function create_hero_upgrade_tree(_hero_id) {
    if (_hero_id < 0 || _hero_id >= array_length(global.heroes)) return noone;
    
    var hero_data = global.heroes[_hero_id];
    
    // Получаем данные дерева для этого героя (10 уровней из scr_hero_trees_data.gml)
    var tree_data = get_hero_tree_data(_hero_id);
    
    var tree = {
        // Основные данные
        hero_id: _hero_id,
        hero_name: hero_data.name,
        hero_type: hero_data.original_type,
        hero_class: hero_data.class_type,
        hero_sprite: hero_data.sprite_small,
        
        // Прогресс дерева
        unlocked_levels: 0,
        current_level: 0,
        
        // Выбранные улучшения
        chosen_upgrades: [],
        
        // Данные улучшений (10 уровней)
        upgrades: tree_data,
        
        // Базовая стоимость призыва
        base_cost: 10,
        
        // Счетчик призывов
        summon_count: 0,
        
        // Счетчик смертей
        total_deaths: 0,
        
        // Базовая стоимость улучшения
        base_upgrade_cost: 12,
        upgrade_cost_multiplier: 1.5,
        
        // Функция получения текущей стоимости призыва
        get_summon_cost: function() {
            return floor(self.base_cost * (1 + self.summon_count * 0.5));
        },
        
        // Функция получения стоимости респавна
        get_respawn_cost: function() {
            var base = 10;
            var death_penalty = self.total_deaths * 5;
            var upgrade_bonus = array_length(self.chosen_upgrades) * 3;
            return floor(base + death_penalty + upgrade_bonus);
        },
        
        // Функция получения стоимости улучшения для конкретного уровня
        get_upgrade_cost: function(_level) {
            return floor(self.base_upgrade_cost * power(self.upgrade_cost_multiplier, _level));
        },
        
        // ===== ФУНКЦИИ ПОЛУЧЕНИЯ БОНУСОВ =====
        get_total_hp_bonus: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_HP) {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        },
        
        get_total_damage_reduction: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_DAMAGE_REDUCTION) {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        },
        
        get_total_big_bleed: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_BIG_BLEED) {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        },
        
        get_total_attack_speed_slow: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_ATTACK_SPEED_SLOW) {
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
        
        get_total_move_speed: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_MOVE_SPEED) {
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
        },
        
        get_total_range: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_RANGE) {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        },
        
        get_total_aoe: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_AOE) {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        },
        
        get_total_bleed: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_BLEED) {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        },
        
        get_total_regen: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_REGEN) {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        },
        
        get_total_multi_target: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_MULTI_TARGET) {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        },
        
        get_total_projectile_speed: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_PROJECTILE_SPEED) {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        },
        
        get_total_burn: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_BURN) {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        },
        
        get_total_heal: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_HEAL) {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        },
        
        get_total_shield_regen: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_SHIELD_REGEN) {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        },
        
        get_total_multi_heal: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_MULTI_HEAL) {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        },
        
        get_total_shield: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_SHIELD) {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        },
        
        get_total_armor_regen: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_ARMOR_REGEN) {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        },
        
        get_total_shield_regen_speed: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_SHIELD_REGEN_SPEED) {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        },
        
        get_total_thorn: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_THORN) {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        },
        
        get_total_entangle: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_ENTANGLE) {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        },
        
        get_total_hex: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_HEX) {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        },
        
        get_total_thorn_aoe: function() {
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_THORN_AOE) {
                    return true;
                }
            }
            return false;
        },
        
        get_total_stun: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_STUN) {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        },
        
        get_total_double_attack: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_DOUBLE_ATTACK) {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        },
        
        get_total_double_shot: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == global.UPGRADE_TYPE_DOUBLE_SHOT) {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        }
    };
    
    return tree;
}

// ===== НАСТРОЙКИ ДЕРЕВЬЕВ =====
tree_settings = {
    count: 4,                    // Количество деревьев
    column_width: 150,           // Ширина колонки
    column_spacing: 40,          // Расстояние между колонками
    sprite_size: 80,             // Размер спрайта
    level_height: 75,            // Высота между уровнями
    base_y: 850,                 // Базовая Y координата
    max_levels: 10               // Максимальное количество уровней - 10!
};

// Вычисляем начальную X позицию для центрирования
var total_width = tree_settings.count * tree_settings.column_width + 
                  (tree_settings.count - 1) * tree_settings.column_spacing;
tree_settings.start_x = (room_width - total_width) / 2 + tree_settings.column_width / 2;

// ===== СОЗДАЕМ 4 ДЕРЕВА С ИСПОЛЬЗОВАНИЕМ ДАННЫХ ИЗ scr_hero_trees_data =====
hero_trees = array_create(tree_settings.count);

for (var i = 0; i < tree_settings.count; i++) {
    var hero_id = global.player_deck[i];
    
    if (hero_id >= 0 && hero_id < array_length(global.heroes)) {
        hero_trees[i] = create_hero_upgrade_tree(hero_id);
        
        if (hero_trees[i] != noone) {
            LOG_CAT("Создано дерево для героя: " + global.heroes[hero_id].name + 
                      ", уровней: " + string(array_length(hero_trees[i].upgrades)), "tree");
        } else {
            LOG_CAT("ОШИБКА: не удалось создать дерево для героя ID=" + string(hero_id), "tree");
            hero_trees[i] = noone;
        }
    } else {
        hero_trees[i] = noone;
        LOG_CAT("Слот " + string(i) + ": нет героя", "tree");
    }
}

// ===== ПЕРЕМЕННЫЕ ДЛЯ СКРОЛЛА =====
tree_scroll_y = 0;
var tree_total_height = 10 * tree_settings.level_height + 200;
var visible_height = room_height - tree_settings.base_y + 100;
tree_scroll_max = max(0, tree_total_height - visible_height);
tree_scroll_speed = 30;
is_dragging_trees = false;
drag_trees_start_y = 0;
scroll_trees_start_y = 0;

// ===== ТРЕБОВАНИЯ ДЛЯ УРОВНЕЙ ДЕРЕВА (по уровню карточки героя) =====
// Индекс = уровень дерева (0-9), значение = требуемый уровень карточки
TREE_LEVEL_REQUIREMENTS = [
    0,  // Уровень 1 (индекс 0) - всегда открыт
    0,  // Уровень 2 (индекс 1) - всегда открыт
    0,  // Уровень 3 (индекс 2) - всегда открыт
    0,  // Уровень 4 (индекс 3) - всегда открыт
    0,  // Уровень 5 (индекс 4) - всегда открыт
    2,  // Уровень 6 (индекс 5) - требуется 2 уровень карточки
    5,  // Уровень 7 (индекс 6) - требуется 5 уровень карточки
    8,  // Уровень 8 (индекс 7) - требуется 8 уровень карточки
    12, // Уровень 9 (индекс 8) - требуется 12 уровень карточки
    15  // Уровень 10 (индекс 9) - требуется 15 уровень карточки
];

// ===== ТЕСТОВАЯ КОМНАТА =====
if (room == room_test) {
    coins = 10000;
    LOG_CAT("=== ТЕСТОВАЯ КОМНАТА: монет = " + string(coins), "general");
    
    // Удаляем существующих манекенов
    with (obj_test_dummy) {
        instance_destroy();
    }
    with (obj_test_dummy_back) {
        instance_destroy();
    }
    
    // Создаем манекенов
    var dummy1 = instance_create_layer(480, 600, "Instances", obj_test_dummy);
    var dummy2 = instance_create_layer(580, 600, "Instances", obj_test_dummy_back);
    
    LOG_CAT("Созданы манекены: передний x=480, задний x=580", "general");
}

// ===== ВРЕМЕННО: для совместимости =====
test_tree = noone;
hero_upgrade_trees = hero_trees; // Для обратной совместимости
// Функция для миграции старых улучшений (добавляет поле side)
function migrate_upgrades_side(_tree) {
    if (_tree == noone) return;
    for (var u = 0; u < array_length(_tree.chosen_upgrades); u++) {
        if (!variable_struct_exists(_tree.chosen_upgrades[u], "side")) {
            // Определяем сторону по типу
            if (_tree.chosen_upgrades[u].type == "hp" || _tree.chosen_upgrades[u].type == "armor" || 
                _tree.chosen_upgrades[u].type == "attack_speed" || _tree.chosen_upgrades[u].type == "range") {
                _tree.chosen_upgrades[u].side = "left";
            } else {
                _tree.chosen_upgrades[u].side = "right";
            }
        }
    }
}

// После создания деревьев, применяем миграцию
for (var i = 0; i < tree_settings.count; i++) {
    if (hero_trees[i] != noone) {
        migrate_upgrades_side(hero_trees[i]);
    }
}
LOG_CAT("=== КОНТРОЛЛЕР ИНИЦИАЛИЗИРОВАН ===", "general");
LOG_CAT("Начальные монеты: " + string(coins), "general");
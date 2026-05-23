// Функция создания дерева для героя
function create_hero_upgrade_tree(_hero_id) {
    if (_hero_id < 0 || _hero_id >= array_length(global.heroes)) return noone;
    
    var hero_data = global.heroes[_hero_id];
    
    // Данные улучшений для каждого уровня
    var upgrades = [
        // Уровень 1
        [
            { type: "hp", value: 20, name: "+20% HP" },
            { type: "damage", value: 20, name: "+20% урона" }
        ],
        // Уровень 2
        [
            { type: "hp", value: 30, name: "+30% HP" },
            { type: "damage", value: 30, name: "+30% урона" }
        ],
        // Уровень 3
        [
            { type: "hp", value: 50, name: "+50% HP" },
            { type: "damage", value: 50, name: "+50% урона" }
        ],
        // Уровень 4
        [
            { type: "hp", value: 75, name: "+75% HP" },
            { type: "damage", value: 75, name: "+75% урона" }
        ],
        // Уровень 5
        [
            { type: "hp", value: 100, name: "+100% HP" },
            { type: "damage", value: 100, name: "+100% урона" }
        ]
    ];
    
    var tree = {
        // Основные данные
        hero_id: _hero_id,
        hero_name: hero_data.name,
        hero_type: hero_data.original_type,
        hero_class: hero_data.class_type,
        hero_sprite: hero_data.sprite_small,
        
        // ===== ВАЖНО: Добавляем unlocked_levels =====
        unlocked_levels: 0,        // Сколько уровней доступно (0 = все заблокированы)
        current_level: 0,          // Для отображения (совпадает с unlocked_levels)
        
        // Выбранные улучшения
        chosen_upgrades: [],
        
        // Данные улучшений
        upgrades: upgrades,
        
        // Базовая стоимость призыва
        base_cost: 10,
        
        // Счетчик призывов (для увеличения стоимости)
        summon_count: 0,
        
        // Функция получения текущей стоимости
        get_summon_cost: function() {
            return floor(self.base_cost * (1 + self.summon_count * 0.5));
        },
        
        // Функция получения HP бонуса
        get_total_hp_bonus: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == "hp") {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        },
        
        // Функция получения Damage бонуса
        get_total_damage_bonus: function() {
            var total = 0;
            for (var u = 0; u < array_length(self.chosen_upgrades); u++) {
                if (self.chosen_upgrades[u].type == "damage") {
                    total += self.chosen_upgrades[u].value;
                }
            }
            return total;
        }
    };
    
    return tree;
}
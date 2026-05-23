/// @function create_hero_data()
/// @desc Создает структуру данных для героя
function create_hero_data() {
    return {
        // Базовые данные
        id: 0,
        name: "",
        class_type: "", // "melee", "ranged", "mage", "support" - ЭТО ТИП ГЕРОЯ
        original_type: "", // Для совместимости со старым кодом ("warrior", "archer" и т.д.)
        rarity: 0, // 0-обычный, 1-редкий, 2-эпический, 3-легендарный
        
		// В функции create_hero_data() добавьте поле:
shop_bought: false,  // Куплена ли карта в магазине (для слота)
shop_slot: -1,       // В каком слоте магазина была куплена (-1 если не куплена)
        // Характеристики (базовые для уровня 1)
        base_hp: 80,
        base_damage: 10,
        base_healing: 0, // для хилера
        base_attack_speed: 0.5,
        base_move_speed: 3,
        
        // Прогресс игрока
        unlocked: false,
        level: 1,
        cards_collected: 0,
        cards_for_next_level: [5, 10, 15, 20, 25, 30, 35, 40, 45, 50],
        
        // Цены улучшения в генах для каждого уровня
        upgrade_cost_genes: [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000],
        
        // Визуальные данные
        sprite_small: noone,
        sprite_large: noone,
        color_frame: c_gray,
        
        // Методы
        get_required_cards: function() {
            if (self.level >= 10) return 0;
            return self.cards_for_next_level[self.level - 1];
        },
        
        get_upgrade_cost: function() {
            if (self.level >= 10) return 0;
            return self.upgrade_cost_genes[self.level - 1];
        },
        
        can_upgrade: function() {
            return self.unlocked && 
                   self.level < 10 && 
                   self.cards_collected >= self.get_required_cards();
        },
        
        // Получить текущие характеристики с учетом уровня
        get_current_hp: function() {
            return floor(self.base_hp * (1 + (self.level - 1) * 0.2)); // floor для целого числа
        },
        
        get_current_damage: function() {
            return floor(self.base_damage * (1 + (self.level - 1) * 0.2));
        },
        
        get_current_healing: function() {
            return floor(self.base_healing * (1 + (self.level - 1) * 0.2));
        }
    };
}

// ===== КОНСТАНТЫ ТИПОВ ГЕРОЕВ =====
global.CLASS_MELEE = "melee";
global.CLASS_RANGED = "ranged";
global.CLASS_MAGE = "mage";
global.CLASS_SUPPORT = "support";

// ===== ЦЕЛЕВЫЕ ПОЗИЦИИ ПО ТИПАМ =====
global.TARGET_POSITIONS = {
    melee: { x: 400, y: 600 },
    ranged: { x: 300, y: 600 },
    mage: { x: 100, y: 600 },
    support: { x: 200, y: 600 }
};

// Максимальное количество героев каждого типа в отряде
global.MAX_PER_CLASS = {
    melee: 1,
    ranged: 1,
    mage: 2,
    support: 2
};
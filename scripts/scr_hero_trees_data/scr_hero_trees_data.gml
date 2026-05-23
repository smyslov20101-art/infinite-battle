/// @desc Данные деревьев прокачки для всех героев (10 уровней)

// ===== КОНСТАНТЫ ТИПОВ УЛУЧШЕНИЙ =====
global.UPGRADE_TYPE_HP = "hp";//хп
global.UPGRADE_TYPE_DAMAGE = "damage";//урон
global.UPGRADE_TYPE_ARMOR = "armor";//броня
global.UPGRADE_TYPE_CLEAVE = "cleave";//сплеш
global.UPGRADE_TYPE_ATTACK_SPEED = "attack_speed";//скорость атаки
global.UPGRADE_TYPE_MOVE_SPEED = "move_speed";//скорость передвижения
global.UPGRADE_TYPE_CRIT_CHANCE = "crit_chance";//шанс крита
global.UPGRADE_TYPE_CRIT_DAMAGE = "crit_damage";//критический урон
global.UPGRADE_TYPE_LIFESTEAL = "lifesteal";//вампиризм
global.UPGRADE_TYPE_DODGE = "dodge";//уклонение
global.UPGRADE_TYPE_RANGE = "range";//дальность атаки
global.UPGRADE_TYPE_AOE = "aoe";//глобальный урон
global.UPGRADE_TYPE_BLEED = "bleed";//кровотечение
global.UPGRADE_TYPE_REGEN = "regen";//регенерация здоровья
global.UPGRADE_TYPE_DOUBLE_SHOT = "double_shot";//двойной выстрел
global.UPGRADE_TYPE_DOUBLE_ATTACK = "double_attack";   // Двойная атака
global.UPGRADE_TYPE_MULTI_TARGET = "multi_target";   // Атака по нескольким целям
global.UPGRADE_TYPE_PROJECTILE_SPEED = "projectile_speed"; // Скорость снаряда
global.UPGRADE_TYPE_BURN = "burn";  // Горение
global.UPGRADE_TYPE_HEAL = "heal";           // Сила лечения
global.UPGRADE_TYPE_SHIELD_REGEN = "shield_regen";  // Восстановление щита
global.UPGRADE_TYPE_MULTI_HEAL = "multi_heal";      // Лечение двух целей
global.UPGRADE_TYPE_SHIELD = "shield";              // Щит
global.UPGRADE_TYPE_ARMOR_REGEN = "armor_regen";    // Регенерация брони
global.UPGRADE_TYPE_SHIELD_REGEN_SPEED = "shield_regen_speed"; // Скорость восстановления щита
global.UPGRADE_TYPE_THORN = "thorn";                // Отражение урона
global.UPGRADE_TYPE_THORN_AOE = "thorn_aoe";        // Отражение по второй цели
global.UPGRADE_TYPE_STUN = "stun";   // Оглушение
global.UPGRADE_TYPE_ENTANGLE = "entangle";   // Опутывание лозой (стан)
global.UPGRADE_TYPE_HEX = "hex";             // Сглаз (увеличение получаемого урона)
global.UPGRADE_TYPE_DAMAGE_REDUCTION = "damage_reduction";   // Снижение получаемого урона
global.UPGRADE_TYPE_BIG_BLEED = "big_bleed";                 // Большое кровотечение
global.UPGRADE_TYPE_ATTACK_SPEED_SLOW = "attack_speed_slow"; // Замедление атаки врага
global.UPGRADE_TYPE_FROST = "frost";           // Замедление движения врага
global.UPGRADE_TYPE_BLIZZARD = "blizzard";     // Буря - замедление атаки врагов
global.UPGRADE_TYPE_ICE = "ice";               // Лед - периодический урон по всем врагам
global.UPGRADE_TYPE_BUFF_MAGE = "buff_mage";       // Бафф мага (+урон)
global.UPGRADE_TYPE_BUFF_ARCHER = "buff_archer";   // Бафф лучника (+скорость атаки)
global.UPGRADE_TYPE_BUFF_CHANCE = "buff_chance";   // Шанс срабатывания баффов
global.UPGRADE_TYPE_HEAL_ON_HIT = "heal_on_hit";   // Лечение ближника при получении урона
global.UPGRADE_TYPE_ARMOR_ON_HIT = "armor_on_hit"; // Броня ближнику при получении урона
global.UPGRADE_TYPE_RAGE = "rage";                 // Ярость (активируется при 4+ врагах или боссе)
global.UPGRADE_TYPE_ARMOR_ON_HIT_TEMP = "armor_on_hit_temp"; // Броня на время при получении урона
global.UPGRADE_TYPE_STUN_ON_HIT = "stun_on_hit";   // Оглушение противника при атаке
global.UPGRADE_TYPE_DARK_BLADE = "dark_blade";       // Темный меч - похищение скорости атаки
global.UPGRADE_TYPE_ARMOR_ILLUSION = "armor_illusion"; // Иллюзия доспеха - уклонение при получении
global.UPGRADE_TYPE_MULTI_SHOT = "multi_shot";     // Выстрел по 3 противникам
global.UPGRADE_TYPE_HEAVY_SHOT = "heavy_shot";     // Серьезный выстрел (+250% урона)
global.UPGRADE_TYPE_CHAIN_LIGHTNING = "chain_lightning";  // Цепная молния (атака по 4 врагам)
global.UPGRADE_TYPE_STUN_ON_HIT_MAGE = "stun_on_hit_mage"; // Оглушение при атаке
global.UPGRADE_TYPE_VULNERABILITY = "vulnerability";      // Уязвимость (+30% получаемого урона)
global.UPGRADE_TYPE_MAGE_BUFF = "mage_buff";              // Бафф всех магов (+урон)
global.UPGRADE_TYPE_DRUID_HEAL_AURA = "druid_heal_aura";           // Аура лечения союзников
global.UPGRADE_TYPE_DRUID_DODGE_AURA = "druid_dodge_aura";         // Аура уклонения союзникам
global.UPGRADE_TYPE_DRUID_TAUNT_CHANCE = "druid_taunt_chance";     // Шанс принять урон вместо союзника
global.UPGRADE_TYPE_DRUID_BUFF_MELEE = "druid_buff_melee";         // Бафф ближника (+HP при получении урона)
global.UPGRADE_TYPE_DRUID_DAMAGE_REDUCTION_AURA = "druid_damage_reduction_aura"; // Аура снижения урона
global.UPGRADE_TYPE_DRUID_LAST_STAND = "druid_last_stand";         // Регенерация при низком HP
global.UPGRADE_TYPE_DRUID_SAVE_MELEE = "druid_save_melee";         // Лечение ближника при критическом HP
global.UPGRADE_TYPE_DRUID_PROTECT_MELEE = "druid_protect_melee";   // Защита ближника при низком HP
global.UPGRADE_TYPE_PALADIN_AOE_BUFF = "paladin_aoe_buff";           // Аура +HP и +DMG
global.UPGRADE_TYPE_PALADIN_PHYS_REDUCTION = "paladin_phys_reduction"; // Снижение физ. урона
global.UPGRADE_TYPE_PALADIN_DOUBLE_ATTACK = "double_attack";          // Уже есть
global.UPGRADE_TYPE_PALADIN_AOE_ATTACK_SPEED = "paladin_aoe_attack_speed"; // Аура скорости атаки
global.UPGRADE_TYPE_PALADIN_EVERY_6TH_MISS = "paladin_every_6th_miss"; // Каждый 6 удар - промах
global.UPGRADE_TYPE_PALADIN_SPLASH = "cleave";                         // Уже есть (сплеш)
global.UPGRADE_TYPE_PALADIN_INVULN = "paladin_invuln";                // Невосприимчивость к урону
global.UPGRADE_TYPE_PALADIN_DAMAGE_STACKS = "paladin_damage_stacks";  // Стаки урона
global.UPGRADE_TYPE_PALADIN_DEFENSE_STACKS = "paladin_defense_stacks"; // Стаки защиты
global.UPGRADE_TYPE_PALADIN_GUARDIAN_ANGEL = "paladin_guardian_angel"; // Ангел-хранитель
global.UPGRADE_TYPE_PALADIN_BODYGUARD = "paladin_bodyguard";          // Телохранитель
global.UPGRADE_TYPE_PALADIN_JUSTICE_MARK = "paladin_justice_mark";    // Метка правосудия
global.UPGRADE_TYPE_PALADIN_DIZZINESS = "paladin_dizziness";          // Головокружение
global.UPGRADE_TYPE_PALADIN_HOLY_ARMOR = "paladin_holy_armor";        // Святая броня
global.UPGRADE_TYPE_PALADIN_DIVINE_WEAPON = "paladin_divine_weapon";  // Божественное оружи
global.UPGRADE_TYPE_REGEN_PERCENT = "regen_percent";        // Регенерация в % от макс HP
global.UPGRADE_TYPE_HOLY_POISON = "holy_poison";           // Святое отравление
global.UPGRADE_TYPE_ICEBERG = "iceberg";                   // Айсберг
global.UPGRADE_TYPE_CURSE = "curse";                       // Большое проклятье
global.UPGRADE_TYPE_SONG_OF_SOUL = "song_of_soul";         // Песнь души
global.UPGRADE_TYPE_WILL_OF_CHANCE = "will_of_chance";     // Воля случая
global.UPGRADE_TYPE_PHOENIX_FEATHER = "phoenix_feather";   // Перо феникса
global.UPGRADE_TYPE_DRAGON_SCALE = "dragon_scale";         // Чешуя дракона

// ===== ИКОНКИ ДЛЯ ТИПОВ УЛУЧШЕНИЙ =====
global.UPGRADE_ICONS = {
    hp: "❤",
    damage: "⚔",
    armor: "🛡️",
    cleave: "⚡",
    attack_speed: "⚡",
    move_speed: "👟",
    crit_chance: "🎯",
    crit_damage: "💥",
    lifesteal: "💉",
    dodge: "🌀",
    range: "🏹",
    aoe: "🌊",
    bleed: "🩸",      // Новая иконка
    regen: "💚" ,     // Новая иконка
	double_shot: "➡️➡️" , // Две стрелы
	multi_target: "🎯",
    projectile_speed: "⚡",
    burn: "🔥"  ,
	heal: "💚",
    shield_regen: "🛡️+",
    multi_heal: "👥",
	shield: "🛡️",
    armor_regen: "🔧",
    shield_regen_speed: "⚡",
    thorn: "🔄",
    thorn_aoe: "🌊",
	double_attack: "➡️➡️",  // Две стрелы/удара
	 stun: "💫"  , // Звездочка для оглушения
	 entangle: "🌿",   // Лоза
    hex: "👁️"       ,  // Сглаз
	damage_reduction: "🛡️↓",
    big_bleed: "🩸💥",
    attack_speed_slow: "🐢",
	frost: "❄️",         // Иконка для мороза
    blizzard: "🌪️",      // Иконка для бури
    ice: "🧊",            // Иконка для льда
	buff_mage: "✨",
    buff_archer: "🏹✨",
    buff_chance: "🎲",
    heal_on_hit: "💚🛡️",
    armor_on_hit: "🔧🛡️",
	rage: "💢",
    armor_on_hit_temp: "🛡️⚡",
	 stun_on_hit: "💫",
	 dark_blade: "🗡️🌑",
    armor_illusion: "🛡️👻",
	multi_shot: "🎯🎯🎯",
    heavy_shot: "💥💥",
	chain_lightning: "⚡⚡⚡⚡",
    stun_on_hit_mage: "💫⚡",
    vulnerability: "🔻",
    mage_buff: "✨🧙",
	druid_heal_aura: "💚🌿",
	druid_dodge_aura: "🌀🌿",
	druid_taunt_chance: "🛡️🌿",
	druid_buff_melee: "💪🌿",
	druid_damage_reduction_aura: "🛡️↓🌿",
	druid_last_stand: "💪🔄",
	druid_save_melee: "💚🆘",
	druid_protect_melee: "🛡️🆘",
	paladin_aoe_buff: "🛡️✨",
	paladin_phys_reduction: "🛡️↓",
	paladin_aoe_attack_speed: "⚡✨",
	paladin_every_6th_miss: "🎯❌",
	paladin_invuln: "🛡️💫",
	paladin_damage_stacks: "⚔️📈",
	paladin_defense_stacks: "🛡️📈",
	paladin_guardian_angel: "👼✨",
	paladin_bodyguard: "🛡️👤",
	paladin_justice_mark: "⚖️🔖",
	paladin_dizziness: "🌀😵",
	paladin_holy_armor: "🛡️✨",
	paladin_divine_weapon: "⚔️✨",
	holy_poison: "☠️",
    iceberg: "🧊",
    curse: "👁️",
    song_of_soul: "🎵",
    will_of_chance: "🎲",
    phoenix_feather: "🪶",
    dragon_scale: "🐉",
};

// ===== ЦВЕТА ДЛЯ ТИПОВ УЛУЧШЕНИЙ =====
global.UPGRADE_COLORS = {
    hp: c_red,
    damage: c_orange,
    armor: c_gray,
    cleave: c_purple,
    attack_speed: c_aqua,
    move_speed: c_lime,
    crit_chance: c_yellow,
    crit_damage: c_red,
    lifesteal: c_green,
    dodge: c_teal,
    range: c_blue,
    aoe: c_fuchsia,
    bleed: c_red,     // Красный для кровотечения
    regen: c_lime ,    // Салатовый для регенерации
	double_shot: c_orange,
	multi_target: c_orange,
    projectile_speed: c_aqua,
    burn: c_red,
	heal: c_lime,
    shield_regen: c_teal,
    multi_heal: c_aqua,
	shield: c_teal,
    armor_regen: c_gray,
    shield_regen_speed: c_aqua,
    thorn: c_red,
    thorn_aoe: c_orange,
	double_attack: c_orange,
	stun: c_yellow,
	entangle: c_green,
    hex: c_purple,
	damage_reduction: c_teal,
    big_bleed: c_red,
    attack_speed_slow: c_purple,
	frost: c_aqua,
    blizzard: c_teal,
    ice: c_blue,
	buff_mage: c_purple,
    buff_archer: c_orange,
    buff_chance: c_yellow,
    heal_on_hit: c_lime,
    armor_on_hit: c_gray,
	rage: c_red,
    armor_on_hit_temp: c_orange,
	stun_on_hit: c_yellow,
	dark_blade: c_purple,
    armor_illusion: c_teal,
	 multi_shot: c_orange,
    heavy_shot: c_red,
	chain_lightning: c_yellow,
    stun_on_hit_mage: c_orange,
    vulnerability: c_red,
    mage_buff: c_purple,
	druid_heal_aura: c_lime,
	druid_dodge_aura: c_teal,
	druid_taunt_chance: c_orange,
	druid_buff_melee: c_red,
	druid_damage_reduction_aura: c_blue,
	druid_last_stand: c_green,
	druid_save_melee: c_yellow,
	druid_protect_melee: c_purple,
	paladin_aoe_buff: c_yellow,
	paladin_phys_reduction: c_teal,
	paladin_aoe_attack_speed: c_aqua,
	paladin_every_6th_miss: c_orange,
	paladin_invuln: c_white,
	paladin_damage_stacks: c_red,
	paladin_defense_stacks: c_blue,
	paladin_guardian_angel: c_yellow,
	paladin_bodyguard: c_gray,
	paladin_justice_mark: c_orange,
	paladin_dizziness: c_purple,
	paladin_holy_armor: c_yellow,
	paladin_divine_weapon: c_orange,
	holy_poison: c_green,
    iceberg: c_aqua,
    curse: c_purple,
    song_of_soul: c_yellow,
    will_of_chance: c_orange,
    phoenix_feather: c_red,
    dragon_scale: c_orange,
};

// ===== ДАННЫЕ ДЕРЕВЬЕВ ДЛЯ КАЖДОГО ГЕРОЯ (10 УРОВНЕЙ) =====

// Новобранец (ID: 0) - полное дерево на 10 уровней
global.HERO_TREE_0 = [
    // Уровень 1
    [
        { type: global.UPGRADE_TYPE_HP, value: 20, name: "+20% HP" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 20, name: "+20% урона" }
    ],
    // Уровень 2
    [
        { type: global.UPGRADE_TYPE_ARMOR, value: 5, name: "+5 брони" },
        { type: global.UPGRADE_TYPE_CLEAVE, value: 10, name: "+10% сплеш" }
    ],
    // Уровень 3
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 10, name: "+10% скор. атаки" },
        { type: global.UPGRADE_TYPE_DODGE, value: 50, name: "+50% уворот" }
    ],
    // Уровень 4
    [
        { type: global.UPGRADE_TYPE_HP, value: 25, name: "+25% HP" },
        { type: global.UPGRADE_TYPE_ARMOR, value: 10, name: "+10 брони" }
    ],
    // Уровень 5
    [
        { type: global.UPGRADE_TYPE_DODGE, value: 5, name: "+5% уворот" },
        { type: global.UPGRADE_TYPE_CLEAVE, value: 10, name: "+10% сплеш" }
    ],
    // Уровень 6
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 15, name: "+15% скор. атаки" },
        { type: global.UPGRADE_TYPE_BLEED, value: 1, name: "Кровотечение 1 урон/сек" }
    ],
    // Уровень 7
    [
        { type: global.UPGRADE_TYPE_HP, value: 30, name: "+30% HP" },
        { type: global.UPGRADE_TYPE_LIFESTEAL, value: 15, name: "+15% вампиризма" }
    ],
    // Уровень 8
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 25, name: "+25% урона" },
        { type: global.UPGRADE_TYPE_CLEAVE, value: 15, name: "+15% сплеш" }
    ],
    // Уровень 9
    [
        { type: global.UPGRADE_TYPE_REGEN, value: 20, name: "Реген 20 HP/сек" },
        { type: global.UPGRADE_TYPE_DODGE, value: 10, name: "+10% уворот" }
    ],
    // Уровень 10
    [
        { type: global.UPGRADE_TYPE_HP, value: 40, name: "+40% HP" },
        { type: global.UPGRADE_TYPE_BLEED, value: 3, name: "+3 урон кровотечения" }
    ]
];

// Новобранец-лучник (ID: 1) - полное дерево на 10 уровней
global.HERO_TREE_1 = [
    // Уровень 1
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 10, name: "+10% урона" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 10, name: "+10% скор. атаки" }
    ],
    // Уровень 2
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 15, name: "+15% скор. атаки" },
        { type: global.UPGRADE_TYPE_BLEED, value: 1, name: "Кровотечение 1 урон/сек" }
    ],
    // Уровень 3
    [
        { type: global.UPGRADE_TYPE_CRIT_DAMAGE, value: 30, name: "+30% крит. урон" },
        { type: global.UPGRADE_TYPE_DODGE, value: 10, name: "+10% уворот" }
    ],
    // Уровень 4
    [
        { type: global.UPGRADE_TYPE_CRIT_CHANCE, value: 15, name: "+15% шанс крита" },
        { type: global.UPGRADE_TYPE_BLEED, value: 1, name: "+1 урон кровотечения" }
    ],
    // Уровень 5
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 20, name: "+20% скор. атаки" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 20, name: "+20% урона" }
    ],
    // Уровень 6
    [
        { type: global.UPGRADE_TYPE_CRIT_CHANCE, value: 20, name: "+20% шанс крита" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 20, name: "+20% урона" }
    ],
    // Уровень 7
    [
        { type: global.UPGRADE_TYPE_DOUBLE_SHOT, value: 25, name: "+25% шанс двойного выстрела" },
        { type: global.UPGRADE_TYPE_CRIT_DAMAGE, value: 35, name: "+35% крит. урон" }
    ],
    // Уровень 8
    [
        { type: global.UPGRADE_TYPE_DODGE, value: 15, name: "+15% уворот" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 25, name: "+25% скор. атаки" }
    ],
    // Уровень 9
    [
        { type: global.UPGRADE_TYPE_CRIT_CHANCE, value: 20, name: "+20% шанс крита" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 30, name: "+30% урона" }
    ],
    // Уровень 10
    [
        { type: global.UPGRADE_TYPE_CRIT_DAMAGE, value: 40, name: "+40% крит. урон" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 30, name: "+30% скор. атаки" }
    ]
];

// Маг огня (ID: 2) - полное дерево на 10 уровней
global.HERO_TREE_2 = [
    // Уровень 1
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 15, name: "+15% урона" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 10, name: "+10% скор. атаки" }
    ],
    // Уровень 2
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 15, name: "+15% скор. атаки" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 20, name: "+20% урона" }
    ],
    // Уровень 3
    [
        { type: global.UPGRADE_TYPE_MULTI_TARGET, value: 10, name: "+10% шанс атаки по 2 врагам" },
        { type: global.UPGRADE_TYPE_CRIT_CHANCE, value: 10, name: "+10% шанс крита" }
    ],
    // Уровень 4
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 20, name: "+20% урона" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 10, name: "+10% скор. атаки" }
    ],
    // Уровень 5
    [
        { type: global.UPGRADE_TYPE_PROJECTILE_SPEED, value: 10, name: "+10% скор. снаряда" },
        { type: global.UPGRADE_TYPE_CRIT_DAMAGE, value: 30, name: "+30% крит. урон" }
    ],
    // Уровень 6
    [
        { type: global.UPGRADE_TYPE_BURN, value: 5, name: "Горение 5 урона/2 сек" },
        { type: global.UPGRADE_TYPE_MULTI_TARGET, value: 15, name: "+15% шанс атаки по 2 врагам" }
    ],
    // Уровень 7
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 20, name: "+20% скор. атаки" },
        { type: global.UPGRADE_TYPE_MULTI_TARGET, value: 15, name: "+15% шанс атаки по 2 врагам" }
    ],
    // Уровень 8
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 30, name: "+30% урона" },
        { type: global.UPGRADE_TYPE_BURN, value: 10, name: "+10 урон горения за стак" }
    ],
    // Уровень 9
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 25, name: "+25% скор. атаки" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 35, name: "+35% урона" }
    ],
    // Уровень 10
    [
        { type: global.UPGRADE_TYPE_MULTI_TARGET, value: 20, name: "+20% шанс атаки по 2 врагам" },
        { type: global.UPGRADE_TYPE_BURN, value: 15, name: "+15 урон горения за стак" }
    ]
];

// Послушник (ID: 3) - хилер, полное дерево на 10 уровней
global.HERO_TREE_3 = [
    // Уровень 1
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 10, name: "+10% скор. лечения" },
        { type: global.UPGRADE_TYPE_HEAL, value: 3, name: "+3 лечение" }
    ],
    // Уровень 2
    [
        { type: global.UPGRADE_TYPE_SHIELD_REGEN, value: 5, name: "+5 восстановление щита" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 10, name: "+10% скор. лечения" }
    ],
    // Уровень 3
    [
        { type: global.UPGRADE_TYPE_HP, value: 20, name: "+20% HP" },
        { type: global.UPGRADE_TYPE_DODGE, value: 10, name: "+10% уворот" }
    ],
    // Уровень 4
    [
        { type: global.UPGRADE_TYPE_HP, value: 20, name: "+20% HP" },
        { type: global.UPGRADE_TYPE_HEAL, value: 5, name: "+5 лечение" }
    ],
    // Уровень 5
    [
        { type: global.UPGRADE_TYPE_DODGE, value: 15, name: "+15% уворот" },
        { type: global.UPGRADE_TYPE_SHIELD_REGEN, value: 5, name: "+5 восстановление щита" }
    ],
    // Уровень 6
    [
        { type: global.UPGRADE_TYPE_MULTI_HEAL, value: 15, name: "+15% шанс лечения 2-х целей" },
        { type: global.UPGRADE_TYPE_HEAL, value: 8, name: "+8 лечение" }
    ],
    // Уровень 7
    [
        { type: global.UPGRADE_TYPE_MULTI_HEAL, value: 15, name: "+15% шанс лечения 2-х целей" },
        { type: global.UPGRADE_TYPE_SHIELD_REGEN, value: 7, name: "+7 восстановление щита" }
    ],
    // Уровень 8
    [
        { type: global.UPGRADE_TYPE_DODGE, value: 15, name: "+15% уворот" },
        { type: global.UPGRADE_TYPE_HP, value: 25, name: "+25% HP" }
    ],
    // Уровень 9
    [
        { type: global.UPGRADE_TYPE_MULTI_HEAL, value: 20, name: "+20% шанс лечения 2-х целей" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 20, name: "+20% скор. лечения" }
    ],
    // Уровень 10
    [
        { type: global.UPGRADE_TYPE_SHIELD_REGEN, value: 10, name: "+10 восстановление щита" },
        { type: global.UPGRADE_TYPE_HEAL, value: 12, name: "+12 лечение" }
    ]
];

// Новобранец с щитом (ID: 4) - танк, полное дерево на 10 уровней
global.HERO_TREE_4 = [
    // Уровень 1
    [
        { type: global.UPGRADE_TYPE_HP, value: 20, name: "+20% HP" },
        { type: global.UPGRADE_TYPE_SHIELD, value: 10, name: "+10 щит" }
    ],
    // Уровень 2
    [
        { type: global.UPGRADE_TYPE_HP, value: 25, name: "+25% HP" },
        { type: global.UPGRADE_TYPE_DODGE, value: 10, name: "+10% уворот" }
    ],
    // Уровень 3
    [
        { type: global.UPGRADE_TYPE_ARMOR, value: 5, name: "+5 брони" },
        { type: global.UPGRADE_TYPE_ARMOR_REGEN, value: 5, name: "+5 реген. брони" }
    ],
    // Уровень 4
    [
        { type: global.UPGRADE_TYPE_SHIELD_REGEN_SPEED, value: 15, name: "+15% скор. восст. щита" },
        { type: global.UPGRADE_TYPE_REGEN, value: 7, name: "Реген 7 HP/сек" }
    ],
    // Уровень 5
    [
        { type: global.UPGRADE_TYPE_SHIELD, value: 20, name: "+20 щит" },
        { type: global.UPGRADE_TYPE_ARMOR, value: 10, name: "+10 брони" }
    ],
    // Уровень 6
    [
        { type: global.UPGRADE_TYPE_DODGE, value: 15, name: "+15% уворот" },
        { type: global.UPGRADE_TYPE_THORN, value: 10, name: "+10% отражение урона" }
    ],
    // Уровень 7
    [
        { type: global.UPGRADE_TYPE_HP, value: 25, name: "+25% HP" },
        { type: global.UPGRADE_TYPE_REGEN, value: 10, name: "Реген 10 HP/сек" }
    ],
    // Уровень 8
    [
        { type: global.UPGRADE_TYPE_THORN, value: 10, name: "+10% отражение урона" },
        { type: global.UPGRADE_TYPE_SHIELD_REGEN_SPEED, value: 20, name: "+20% скор. восст. щита" }
    ],
    // Уровень 9
    [
        { type: global.UPGRADE_TYPE_HP, value: 35, name: "+35% HP" },
        { type: global.UPGRADE_TYPE_ARMOR, value: 20, name: "+20 брони" }
    ],
    // Уровень 10
    [
        { type: global.UPGRADE_TYPE_THORN_AOE, value: 1, name: "Отражение по 2-й цели" },
        { type: global.UPGRADE_TYPE_DODGE, value: 20, name: "+20% уворот" }
    ]
];

// Разбойник (ID: 5) - полное дерево на 10 уровней
global.HERO_TREE_5 = [
    // Уровень 1
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 15, name: "+15% урона" },
        { type: global.UPGRADE_TYPE_HP, value: 15, name: "+15% HP" }
    ],
    // Уровень 2
    [
        { type: global.UPGRADE_TYPE_DODGE, value: 10, name: "+10% уворот" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 15, name: "+15% скор. атаки" }
    ],
    // Уровень 3
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 20, name: "+20% урона" },
        { type: global.UPGRADE_TYPE_ARMOR, value: 10, name: "+10 брони" }
    ],
    // Уровень 4
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 25, name: "+25% урона" },
        { type: global.UPGRADE_TYPE_DODGE, value: 15, name: "+15% уворот" }
    ],
    // Уровень 5
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 20, name: "+20% скор. атаки" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 25, name: "+25% урона" }
    ],
    // Уровень 6
    [
        { type: global.UPGRADE_TYPE_DOUBLE_ATTACK, value: 10, name: "+10% шанс двойной атаки" },
        { type: global.UPGRADE_TYPE_HP, value: 25, name: "+25% HP" }
    ],
    // Уровень 7
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 25, name: "+25% скор. атаки" },
        { type: global.UPGRADE_TYPE_ARMOR, value: 15, name: "+15 брони" }
    ],
    // Уровень 8
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 30, name: "+30% урона" },
        { type: global.UPGRADE_TYPE_HP, value: 30, name: "+30% HP" }
    ],
    // Уровень 9
    [
        { type: global.UPGRADE_TYPE_DOUBLE_ATTACK, value: 15, name: "+15% шанс двойной атаки" },
        { type: global.UPGRADE_TYPE_HP, value: 35, name: "+35% HP" }
    ],
    // Уровень 10
    [
        { type: global.UPGRADE_TYPE_ARMOR, value: 20, name: "+20 брони" },
        { type: global.UPGRADE_TYPE_CLEAVE, value: 20, name: "+20% сплеш" }
    ]
];

// Бродяга с рогаткой (ID: 6) - полное дерево на 10 уровней
global.HERO_TREE_6 = [
    // Уровень 1
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 15, name: "+15% урона" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 10, name: "+10% скор. атаки" }
    ],
    // Уровень 2
    [
        { type: global.UPGRADE_TYPE_STUN, value: 15, name: "+15% шанс оглушить" },
        { type: global.UPGRADE_TYPE_DODGE, value: 10, name: "+10% уворот" }
    ],
    // Уровень 3
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 15, name: "+15% скор. атаки" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 20, name: "+20% урона" }
    ],
    // Уровень 4
    [
        { type: global.UPGRADE_TYPE_CRIT_DAMAGE, value: 35, name: "+35% крит. урон" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 20, name: "+20% урона" }
    ],
    // Уровень 5
    [
        { type: global.UPGRADE_TYPE_CRIT_CHANCE, value: 30, name: "+30% шанс крита" },
        { type: global.UPGRADE_TYPE_HP, value: 20, name: "+20% HP" }
    ],
    // Уровень 6
    [
        { type: global.UPGRADE_TYPE_STUN, value: 20, name: "+20% шанс оглушить" },
        { type: global.UPGRADE_TYPE_CRIT_DAMAGE, value: 35, name: "+35% крит. урон" }
    ],
    // Уровень 7
    [
        { type: global.UPGRADE_TYPE_DODGE, value: 20, name: "+20% уворот" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 20, name: "+20% скор. атаки" }
    ],
    // Уровень 8
    [
        { type: global.UPGRADE_TYPE_STUN, value: 20, name: "+20% шанс оглушить" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 25, name: "+25% скор. атаки" }
    ],
    // Уровень 9
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 25, name: "+25% урона" },
        { type: global.UPGRADE_TYPE_CRIT_CHANCE, value: 35, name: "+35% шанс крита" }
    ],
    // Уровень 10
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 30, name: "+30% скор. атаки" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 30, name: "+30% урона" }
    ]
];

// Лесной маг (ID: 7) - полное дерево на 10 уровней
global.HERO_TREE_7 = [
    // Уровень 1
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 15, name: "+15% урона" },
        { type: global.UPGRADE_TYPE_HP, value: 10, name: "+10% HP" }
    ],
    // Уровень 2
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 15, name: "+15% скор. атаки" },
        { type: global.UPGRADE_TYPE_DODGE, value: 15, name: "+15% уворот" }
    ],
    // Уровень 3
    [
        { type: global.UPGRADE_TYPE_ENTANGLE, value: 15, name: "+15% шанс опутать лозой" },
        { type: global.UPGRADE_TYPE_HEX, value: 15, name: "+15% шанс сглазить" }
    ],
    // Уровень 4
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 20, name: "+20% урона" },
        { type: global.UPGRADE_TYPE_HP, value: 15, name: "+15% HP" }
    ],
    // Уровень 5
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 20, name: "+20% скор. атаки" },
        { type: global.UPGRADE_TYPE_HP, value: 20, name: "+20% HP" }
    ],
    // Уровень 6
    [
        { type: global.UPGRADE_TYPE_DODGE, value: 20, name: "+20% уворот" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 25, name: "+25% урона" }
    ],
    // Уровень 7
    [
        { type: global.UPGRADE_TYPE_ENTANGLE, value: 20, name: "+20% шанс опутать лозой" },
        { type: global.UPGRADE_TYPE_HEX, value: 20, name: "+20% шанс сглазить" }
    ],
    // Уровень 8
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 20, name: "+20% скор. атаки" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 30, name: "+30% урона" }
    ],
    // Уровень 9
    [
        { type: global.UPGRADE_TYPE_HP, value: 25, name: "+25% HP" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 35, name: "+35% урона" }
    ],
    // Уровень 10
    [
        { type: global.UPGRADE_TYPE_ENTANGLE, value: 30, name: "+30% шанс опутать лозой" },
        { type: global.UPGRADE_TYPE_HEX, value: 30, name: "+30% шанс сглазить" }
    ]
];

// Рыцарь (ID: 8) - полное дерево на 10 уровней
global.HERO_TREE_8 = [
    // Уровень 1
    [
        { type: global.UPGRADE_TYPE_HP, value: 20, name: "+20% HP" },
        { type: global.UPGRADE_TYPE_ARMOR, value: 15, name: "+15 брони" }
    ],
    // Уровень 2
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 15, name: "+15% скор. атаки" },
        { type: global.UPGRADE_TYPE_REGEN, value: 7, name: "Реген 7 HP/сек" }
    ],
    // Уровень 3
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 20, name: "+20% урона" },
        { type: global.UPGRADE_TYPE_DAMAGE_REDUCTION, value: 15, name: "-15% получаемый урон" }
    ],
    // Уровень 4
    [
        { type: global.UPGRADE_TYPE_HP, value: 25, name: "+25% HP" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 20, name: "+20% скор. атаки" }
    ],
    // Уровень 5
    [
        { type: global.UPGRADE_TYPE_DAMAGE_REDUCTION, value: 15, name: "-15% получаемый урон" },
        { type: global.UPGRADE_TYPE_ARMOR, value: 25, name: "+25 брони" }
    ],
    // Уровень 6
    [
        { type: global.UPGRADE_TYPE_BIG_BLEED, value: 30, name: "Кровотечение 30 урон/сек" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED_SLOW, value: 30, name: "Замедление атаки врага на 30%" }
    ],
    // Уровень 7
    [
        { type: global.UPGRADE_TYPE_REGEN, value: 15, name: "Реген 15 HP/сек" },
        { type: global.UPGRADE_TYPE_HP, value: 30, name: "+30% HP" }
    ],
    // Уровень 8
    [
        { type: global.UPGRADE_TYPE_ARMOR, value: 35, name: "+35 брони" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 30, name: "+30% скор. атаки" }
    ],
    // Уровень 9
    [
        { type: global.UPGRADE_TYPE_BIG_BLEED, value: 10, name: "+10 урон кровотечения" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED_SLOW, value: 20, name: "+20% замедление атаки" }
    ],
    // Уровень 10
    [
        { type: global.UPGRADE_TYPE_ARMOR, value: 45, name: "+45 брони" },
        { type: global.UPGRADE_TYPE_HP, value: 50, name: "+50% HP" }
    ]
];

// Стрелок (ID: 9) - полное дерево на 10 уровней
global.HERO_TREE_9 = [
    // Уровень 1
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 20, name: "+20% скор. атаки" },
        { type: global.UPGRADE_TYPE_HP, value: 15, name: "+15% HP" }
    ],
    // Уровень 2
    [
        { type: global.UPGRADE_TYPE_CRIT_DAMAGE, value: 35, name: "+35% крит. урон" },
        { type: global.UPGRADE_TYPE_DODGE, value: 15, name: "+15% уворот" }
    ],
    // Уровень 3
    [
        { type: global.UPGRADE_TYPE_CRIT_CHANCE, value: 20, name: "+20% шанс крита" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 20, name: "+20% урона" }
    ],
    // Уровень 4
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 25, name: "+25% скор. атаки" },
        { type: global.UPGRADE_TYPE_REGEN, value: 5, name: "Реген 5 HP/сек" }
    ],
    // Уровень 5
    [
        { type: global.UPGRADE_TYPE_CRIT_DAMAGE, value: 40, name: "+40% крит. урон" },
        { type: global.UPGRADE_TYPE_CRIT_CHANCE, value: 20, name: "+20% шанс крита" }
    ],
    // Уровень 6
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 30, name: "+30% скор. атаки" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 25, name: "+25% урона" }
    ],
    // Уровень 7
    [
        { type: global.UPGRADE_TYPE_CRIT_DAMAGE, value: 50, name: "+50% крит. урон" },
        { type: global.UPGRADE_TYPE_DODGE, value: 15, name: "+15% уворот" }
    ],
    // Уровень 8
    [
        { type: global.UPGRADE_TYPE_CRIT_CHANCE, value: 20, name: "+20% шанс крита" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 30, name: "+30% урона" }
    ],
    // Уровень 9
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 35, name: "+35% скор. атаки" },
        { type: global.UPGRADE_TYPE_REGEN, value: 15, name: "Реген 15 HP/сек" }
    ],
    // Уровень 10
    [
        { type: global.UPGRADE_TYPE_DOUBLE_ATTACK, value: 40, name: "+40% шанс двойной атаки" },
        { type: global.UPGRADE_TYPE_CRIT_DAMAGE, value: 60, name: "+60% крит. урон" }
    ]
];

// Маг льда (ID: 10) - полное дерево на 10 уровней
global.HERO_TREE_10 = [
    // Уровень 1
    [
        { type: global.UPGRADE_TYPE_DODGE, value: 10, name: "+10% уклонение" },
        { type: global.UPGRADE_TYPE_HP, value: 15, name: "+15% HP" }
    ],
    // Уровень 2
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 15, name: "+15% урона" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 20, name: "+20% скор. атаки" }
    ],
    // Уровень 3
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 20, name: "+20% урона" },
        { type: global.UPGRADE_TYPE_FROST, value: 10, name: "Мороз: замедление 10%" }
    ],
    // Уровень 4
    [
        { type: global.UPGRADE_TYPE_HP, value: 20, name: "+20% HP" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 20, name: "+20% скор. атаки" }
    ],
    // Уровень 5
    [
        { type: global.UPGRADE_TYPE_DODGE, value: 15, name: "+15% уклонение" },
        { type: global.UPGRADE_TYPE_FROST, value: 15, name: "Мороз: замедление +15%" }
    ],
    // Уровень 6
    [
        { type: global.UPGRADE_TYPE_BLIZZARD, value: 15, name: "Буря: 15% шанс замедлить атаку врагов на 10% (4 сек)" },
        { type: global.UPGRADE_TYPE_ICE, value: 15, name: "Лед: 15% шанс нанести 15 урона всем врагам (2 сек)" }
    ],
    // Уровень 7
    [
        { type: global.UPGRADE_TYPE_FROST, value: 15, name: "Мороз: замедление +15%" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 25, name: "+25% урона" }
    ],
    // Уровень 8
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 30, name: "+30% урона" },
        { type: global.UPGRADE_TYPE_HP, value: 35, name: "+35% HP" }
    ],
    // Уровень 9
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 20, name: "+20% скор. атаки" },
        { type: global.UPGRADE_TYPE_FROST, value: 15, name: "Мороз: замедление +15%" }
    ],
    // Уровень 10
    [
        { type: global.UPGRADE_TYPE_BLIZZARD, value: 30, name: "Буря: замедление атаки врагов +30%" },
        { type: global.UPGRADE_TYPE_ICE, value: 20, name: "Лед: +20 урона от льда" }
    ]
];

// Жрец (ID: 11) - полное дерево на 10 уровней
global.HERO_TREE_11 = [
    // Уровень 1
    [
        { type: global.UPGRADE_TYPE_HP, value: 15, name: "+15% HP" },
        { type: global.UPGRADE_TYPE_DODGE, value: 10, name: "+10% уклонение" }
    ],
    // Уровень 2
    [
        { type: global.UPGRADE_TYPE_BUFF_MAGE, value: 5, name: "Бафф мага: +5% урона магу на 3 сек (шанс 20%)" },
        { type: global.UPGRADE_TYPE_BUFF_ARCHER, value: 10, name: "Бафф лучника: +10% скор. атаки лучнику на 3 сек (шанс 20%)" }
    ],
    // Уровень 3
    [
        { type: global.UPGRADE_TYPE_BUFF_CHANCE, value: 10, name: "+10% шанс срабатывания баффов" },
        { type: global.UPGRADE_TYPE_ARMOR, value: 10, name: "+10 брони" }
    ],
    // Уровень 4
    [
        { type: global.UPGRADE_TYPE_HP, value: 20, name: "+20% HP" },
        { type: global.UPGRADE_TYPE_DODGE, value: 10, name: "+10% уклонение" }
    ],
    // Уровень 5
    [
        { type: global.UPGRADE_TYPE_BUFF_MAGE, value: 10, name: "Бафф мага: +10% урона (всего +15%)" },
        { type: global.UPGRADE_TYPE_BUFF_ARCHER, value: 15, name: "Бафф лучника: +15% скор. атаки (всего +25%)" }
    ],
    // Уровень 6
    [
        { type: global.UPGRADE_TYPE_HEAL_ON_HIT, value: 5, name: "Лечение ближника 5 HP при получении урона" },
        { type: global.UPGRADE_TYPE_ARMOR_ON_HIT, value: 2, name: "Броня ближнику +2 (макс 20) при получении урона" }
    ],
    // Уровень 7
    [
        { type: global.UPGRADE_TYPE_BUFF_CHANCE, value: 15, name: "+15% шанс срабатывания баффов" },
        { type: global.UPGRADE_TYPE_ARMOR, value: 15, name: "+15 брони" }
    ],
    // Уровень 8
    [
        { type: global.UPGRADE_TYPE_HP, value: 25, name: "+25% HP" },
        { type: global.UPGRADE_TYPE_DODGE, value: 15, name: "+15% уклонение" }
    ],
    // Уровень 9
    [
        { type: global.UPGRADE_TYPE_BUFF_MAGE, value: 15, name: "Бафф мага: +15% урона (всего +30%)" },
        { type: global.UPGRADE_TYPE_BUFF_ARCHER, value: 20, name: "Бафф лучника: +20% скор. атаки (всего +45%)" }
    ],
    // Уровень 10
    [
        { type: global.UPGRADE_TYPE_HEAL_ON_HIT, value: 15, name: "Лечение ближника 15 HP при получении урона" },
        { type: global.UPGRADE_TYPE_ARMOR_ON_HIT, value: 3, name: "Броня ближнику +3 (макс 60) при получении урона" }
    ]
];

// Берсерк (ID: 12) - полное дерево на 10 уровней
global.HERO_TREE_12 = [
    // Уровень 1
    [
        { type: global.UPGRADE_TYPE_HP, value: 20, name: "+20% HP" },
        { type: global.UPGRADE_TYPE_ARMOR, value: 10, name: "+10 брони" }
    ],
    // Уровень 2
    [
        { type: global.UPGRADE_TYPE_DODGE, value: 10, name: "+10% уклонение" },
        { type: global.UPGRADE_TYPE_REGEN, value: 10, name: "Регенерация +10 HP/сек" }
    ],
    // Уровень 3
    [
        { type: global.UPGRADE_TYPE_RAGE, value: 20, name: "Ярость: +20% скор. атаки и +20% урона (4+ врага или босс)" },
        { type: global.UPGRADE_TYPE_CLEAVE, value: 15, name: "+15% сплеш" }
    ],
    // Уровень 4
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 20, name: "+20% урона" },
        { type: global.UPGRADE_TYPE_HP, value: 25, name: "+25% HP" }
    ],
    // Уровень 5
    [
        { type: global.UPGRADE_TYPE_DOUBLE_ATTACK, value: 20, name: "+20% шанс двойной атаки" },
        { type: global.UPGRADE_TYPE_ARMOR_ON_HIT_TEMP, value: 15, name: "15% шанс получить +20 брони на 3 сек при получении урона" }
    ],
    // Уровень 6
    [
        { type: global.UPGRADE_TYPE_HP, value: 30, name: "+30% HP" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 25, name: "+25% урона" }
    ],
    // Уровень 7
    [
        { type: global.UPGRADE_TYPE_RAGE, value: 40, name: "Ярость: +40% скор. атаки и +40% урона" },
        { type: global.UPGRADE_TYPE_CLEAVE, value: 20, name: "+20% сплеш" }
    ],
    // Уровень 8
    [
        { type: global.UPGRADE_TYPE_DOUBLE_ATTACK, value: 20, name: "+20% шанс двойной атаки" },
        { type: global.UPGRADE_TYPE_ARMOR_ON_HIT_TEMP, value: 15, name: "+15% шанс получить +20 брони (всего 30%)" }
    ],
    // Уровень 9
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 30, name: "+30% урона" },
        { type: global.UPGRADE_TYPE_HP, value: 35, name: "+35% HP" }
    ],
    // Уровень 10
    [
        { type: global.UPGRADE_TYPE_RAGE, value: 75, name: "Ярость: +75% скор. атаки и +70% урона" },
        { type: global.UPGRADE_TYPE_CLEAVE, value: 25, name: "+25% сплеш" }
    ]
];

// Эльфийский лучник (ID: 13) - полное дерево на 10 уровней
global.HERO_TREE_13 = [
    // Уровень 1
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 20, name: "+20% скор. атаки" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 15, name: "+15% урона" }
    ],
    // Уровень 2
    [
        { type: global.UPGRADE_TYPE_CRIT_CHANCE, value: 15, name: "+15% шанс крита" },
        { type: global.UPGRADE_TYPE_CRIT_DAMAGE, value: 30, name: "+30% крит. урон" }
    ],
    // Уровень 3
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 25, name: "+25% скор. атаки" },
        { type: global.UPGRADE_TYPE_DODGE, value: 15, name: "+15% уклонение" }
    ],
    // Уровень 4
    [
        { type: global.UPGRADE_TYPE_DOUBLE_SHOT, value: 20, name: "+20% шанс двойного выстрела" },
        { type: global.UPGRADE_TYPE_STUN_ON_HIT, value: 10, name: "10% шанс оглушить врага на 2 сек" }
    ],
    // Уровень 5
    [
        { type: global.UPGRADE_TYPE_CRIT_CHANCE, value: 15, name: "+15% шанс крита" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 30, name: "+30% скор. атаки" }
    ],
    // Уровень 6
    [
        { type: global.UPGRADE_TYPE_CRIT_DAMAGE, value: 40, name: "+40% крит. урон" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 25, name: "+25% урона" }
    ],
    // Уровень 7
    [
        { type: global.UPGRADE_TYPE_DOUBLE_SHOT, value: 25, name: "+25% шанс двойного выстрела" },
        { type: global.UPGRADE_TYPE_STUN_ON_HIT, value: 15, name: "+15% шанс оглушить врага (всего 25%)" }
    ],
    // Уровень 8
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 35, name: "+35% скор. атаки" },
        { type: global.UPGRADE_TYPE_CRIT_CHANCE, value: 20, name: "+20% шанс крита" }
    ],
    // Уровень 9
    [
        { type: global.UPGRADE_TYPE_CRIT_DAMAGE, value: 45, name: "+45% крит. урон" },
        { type: global.UPGRADE_TYPE_HP, value: 25, name: "+25% HP" }
    ],
    // Уровень 10
    [
        { type: global.UPGRADE_TYPE_DOUBLE_SHOT, value: 30, name: "+30% шанс двойного выстрела" },
        { type: global.UPGRADE_TYPE_STUN_ON_HIT, value: 20, name: "+20% шанс оглушить врага (всего 45%)" }
    ]
];

// Мечник теней (ID: 14) - полное дерево на 10 уровней
global.HERO_TREE_14 = [
    // Уровень 1
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 20, name: "+20% скор. атаки" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 20, name: "+20% урона" }
    ],
    // Уровень 2
    [
        { type: global.UPGRADE_TYPE_DARK_BLADE, value: 20, name: "Темный меч: 20% шанс похитить 20% скор. атаки врага на 3 сек" },
        { type: global.UPGRADE_TYPE_ARMOR_ILLUSION, value: 15, name: "Иллюзия доспеха: 20% шанс получить +15% уклонения на 3 сек при получении урона" }
    ],
    // Уровень 3
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 25, name: "+25% урона" },
        { type: global.UPGRADE_TYPE_CRIT_DAMAGE, value: 35, name: "+35% крит. урон" }
    ],
    // Уровень 4
    [
        { type: global.UPGRADE_TYPE_LIFESTEAL, value: 15, name: "+15% вампиризма" },
        { type: global.UPGRADE_TYPE_CRIT_CHANCE, value: 20, name: "+20% шанс крита" }
    ],
    // Уровень 5
    [
        { type: global.UPGRADE_TYPE_DARK_BLADE, value: 30, name: "Темный меч: 30% шанс похитить 30% скор. атаки врага" },
        { type: global.UPGRADE_TYPE_ARMOR_ILLUSION, value: 25, name: "Иллюзия доспеха: 30% шанс получить +25% уклонения" }
    ],
    // Уровень 6
    [
        { type: global.UPGRADE_TYPE_CRIT_DAMAGE, value: 40, name: "+40% крит. урон" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 35, name: "+35% урона" }
    ],
    // Уровень 7
    [
        { type: global.UPGRADE_TYPE_CLEAVE, value: 25, name: "+25% сплеш" },
        { type: global.UPGRADE_TYPE_CRIT_CHANCE, value: 25, name: "+25% шанс крита" }
    ],
    // Уровень 8
    [
        { type: global.UPGRADE_TYPE_HP, value: 35, name: "+35% HP" },
        { type: global.UPGRADE_TYPE_CRIT_DAMAGE, value: 50, name: "+50% крит. урон" }
    ],
    // Уровень 9
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 40, name: "+40% урона" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 40, name: "+40% скор. атаки" }
    ],
    // Уровень 10
    [
        { type: global.UPGRADE_TYPE_DARK_BLADE, value: 40, name: "Темный меч: 40% шанс похитить 40% скор. атаки врага" },
        { type: global.UPGRADE_TYPE_ARMOR_ILLUSION, value: 35, name: "Иллюзия доспеха: 40% шанс получить +35% уклонения" }
    ]
];

// Снайпер (ID: 15) - полное дерево на 10 уровней
global.HERO_TREE_15 = [
    // Уровень 1
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 20, name: "+20% урона" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 25, name: "+25% скор. атаки" }
    ],
    // Уровень 2
    [
        { type: global.UPGRADE_TYPE_CRIT_DAMAGE, value: 50, name: "+50% крит. урон" },
        { type: global.UPGRADE_TYPE_CRIT_CHANCE, value: 20, name: "+20% шанс крита" }
    ],
    // Уровень 3
    [
        { type: global.UPGRADE_TYPE_MULTI_SHOT, value: 10, name: "10% шанс выстрелить по 3 противникам" },
        { type: global.UPGRADE_TYPE_HEAVY_SHOT, value: 10, name: "10% шанс совершить серьезный выстрел (+250% урона)" }
    ],
    // Уровень 4
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 30, name: "+30% скор. атаки" },
        { type: global.UPGRADE_TYPE_CRIT_DAMAGE, value: 60, name: "+60% крит. урон" }
    ],
    // Уровень 5
    [
        { type: global.UPGRADE_TYPE_HP, value: 30, name: "+30% HP" },
        { type: global.UPGRADE_TYPE_CRIT_CHANCE, value: 25, name: "+25% шанс крита" }
    ],
    // Уровень 6
    [
        { type: global.UPGRADE_TYPE_MULTI_SHOT, value: 15, name: "+15% шанс выстрелить по 3 противникам (всего 25%)" },
        { type: global.UPGRADE_TYPE_HEAVY_SHOT, value: 15, name: "+15% шанс серьезного выстрела (всего 25%)" }
    ],
    // Уровень 7
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 35, name: "+35% скор. атаки" },
        { type: global.UPGRADE_TYPE_CRIT_CHANCE, value: 25, name: "+25% шанс крита" }
    ],
    // Уровень 8
    [
        { type: global.UPGRADE_TYPE_CRIT_DAMAGE, value: 70, name: "+70% крит. урон" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 40, name: "+40% урона" }
    ],
    // Уровень 9
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 50, name: "+50% урона" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 40, name: "+40% скор. атаки" }
    ],
    // Уровень 10
    [
        { type: global.UPGRADE_TYPE_MULTI_SHOT, value: 25, name: "+25% шанс выстрелить по 3 противникам (всего 50%)" },
        { type: global.UPGRADE_TYPE_HEAVY_SHOT, value: 25, name: "+25% шанс серьезного выстрела (всего 50%)" }
    ]
];

// Маг молний (ID: 16) - полное дерево на 10 уровней
global.HERO_TREE_16 = [
    // Уровень 1
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 20, name: "+20% урона" },
        { type: global.UPGRADE_TYPE_DODGE, value: 15, name: "+15% уклонение" }
    ],
    // Уровень 2
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 25, name: "+25% скор. атаки" },
        { type: global.UPGRADE_TYPE_HP, value: 20, name: "+20% HP" }
    ],
    // Уровень 3
    [
        { type: global.UPGRADE_TYPE_CHAIN_LIGHTNING, value: 75, name: "50% шанс атаки по 4 врагам (урон -25%)" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 30, name: "+30% скор. атаки" }
    ],
    // Уровень 4
    [
        { type: global.UPGRADE_TYPE_STUN_ON_HIT_MAGE, value: 10, name: "10% шанс оглушить врага на 2 сек" },
        { type: global.UPGRADE_TYPE_VULNERABILITY, value: 10, name: "10% шанс увеличить получаемый урон врага на 30% на 4 сек" }
    ],
    // Уровень 5
    [
        { type: global.UPGRADE_TYPE_CHAIN_LIGHTNING, value: 85, name: "50% шанс атаки по 4 врагам (урон -15%)" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 30, name: "+30% урона" }
    ],
    // Уровень 6
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 35, name: "+35% урона" },
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 30, name: "+30% скор. атаки" }
    ],
    // Уровень 7
    [
        { type: global.UPGRADE_TYPE_STUN_ON_HIT_MAGE, value: 15, name: "+15% шанс оглушить врага (всего 25%)" },
        { type: global.UPGRADE_TYPE_VULNERABILITY, value: 15, name: "+15% шанс уязвимости (всего 25%)" }
    ],
    // Уровень 8
    [
        { type: global.UPGRADE_TYPE_CHAIN_LIGHTNING, value: 95, name: "50% шанс атаки по 4 врагам (урон -5%)" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 40, name: "+40% урона" }
    ],
    // Уровень 9
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 35, name: "+35% скор. атаки" },
        { type: global.UPGRADE_TYPE_MAGE_BUFF, value: 40, name: "Урон всех магов +40%" }
    ],
    // Уровень 10
    [
        { type: global.UPGRADE_TYPE_STUN_ON_HIT_MAGE, value: 20, name: "+20% шанс оглушить врага (всего 45%)" },
        { type: global.UPGRADE_TYPE_VULNERABILITY, value: 20, name: "+20% шанс уязвимости (всего 45%)" }
    ]
];
// Друид (ID: 17) - полное дерево на 10 уровней
global.HERO_TREE_17 = [
    // Уровень 1
    [
        { type: global.UPGRADE_TYPE_HP, value: 25, name: "+25% HP" },
        { type: global.UPGRADE_TYPE_DODGE, value: 15, name: "+15% уклонение" }
    ],
    // Уровень 2
    [
        { type: global.UPGRADE_TYPE_DRUID_HEAL_AURA, value: 5, name: "Аура лечения: 5% HP/сек союзникам (15 сек КД)" },
        { type: global.UPGRADE_TYPE_DRUID_DODGE_AURA, value: 10, name: "Аура уклонения: +10% уклонения союзникам (15 сек КД)" }
    ],
    // Уровень 3
    [
        { type: global.UPGRADE_TYPE_DRUID_TAUNT_CHANCE, value: 15, name: "15% шанс принять урон вместо союзника" },
        { type: global.UPGRADE_TYPE_DRUID_BUFF_MELEE, value: 20, name: "При получении урона ближником: +20% HP на 5 сек (15 сек КД)" }
    ],
    // Уровень 4
    [
        { type: global.UPGRADE_TYPE_DRUID_DAMAGE_REDUCTION_AURA, value: 10, name: "Аура снижения урона: -10% урона всем союзникам (15 сек КД)" },
        { type: global.UPGRADE_TYPE_HP, value: 30, name: "+30% HP" }
    ],
    // Уровень 5
    [
        { type: global.UPGRADE_TYPE_DRUID_HEAL_AURA, value: 10, name: "Аура лечения: 10% HP/сек союзникам (15 сек КД)" },
        { type: global.UPGRADE_TYPE_DRUID_DODGE_AURA, value: 20, name: "Аура уклонения: +20% уклонения союзникам (15 сек КД)" }
    ],
    // Уровень 6
    [
        { type: global.UPGRADE_TYPE_DRUID_DAMAGE_REDUCTION_AURA, value: 15, name: "Аура снижения урона: -15% урона всем союзникам (15 сек КД)" },
        { type: global.UPGRADE_TYPE_HP, value: 40, name: "+40% HP" }
    ],
    // Уровень 7
    [
        { type: global.UPGRADE_TYPE_DRUID_TAUNT_CHANCE, value: 15, name: "+15% шанс принять урон вместо союзника (всего 30%)" },
        { type: global.UPGRADE_TYPE_DRUID_BUFF_MELEE, value: 20, name: "+20% шанс баффа ближника (всего 40%)" }
    ],
    // Уровень 8
    [
        { type: global.UPGRADE_TYPE_HP, value: 50, name: "+50% HP" },
        { type: global.UPGRADE_TYPE_DRUID_LAST_STAND, value: 50, name: "Регенерация 50% HP при HP <25% (40 сек КД)" }
    ],
    // Уровень 9
    [
        { type: global.UPGRADE_TYPE_DRUID_DAMAGE_REDUCTION_AURA, value: 35, name: "Аура снижения урона: -35% урона всем союзникам (15 сек КД)" },
        { type: global.UPGRADE_TYPE_DRUID_TAUNT_CHANCE, value: 20, name: "+20% шанс принять урон вместо союзника (всего 50%)" }
    ],
    // Уровень 10
    [
        { type: global.UPGRADE_TYPE_DRUID_SAVE_MELEE, value: 40, name: "Лечение ближника на 40% HP при HP <10% (50 сек КД)" },
        { type: global.UPGRADE_TYPE_DRUID_PROTECT_MELEE, value: 30, name: "При HP <15%: +30% уклонения и -30% урона на 10 сек (60 сек КД)" }
    ]
];

// Паладин (ID: 18) - полное дерево на 10 уровней
global.HERO_TREE_18 = [
    // Уровень 1
    [
        { type: global.UPGRADE_TYPE_PALADIN_AOE_BUFF, value: 5, name: "Аура: +5% HP и +7% урона всем союзникам" },
        { type: global.UPGRADE_TYPE_PALADIN_AOE_BUFF, value: 7, name: "Аура: +5% HP и +7% урона всем союзникам" }
    ],
    // Уровень 2
    [
        { type: global.UPGRADE_TYPE_PALADIN_PHYS_REDUCTION, value: 10, name: "-10% получаемого физического урона" },
        { type: global.UPGRADE_TYPE_DOUBLE_ATTACK, value: 50, name: "+50% шанс двойной атаки" }
    ],
    // Уровень 3
    [
        { type: global.UPGRADE_TYPE_HP, value: 10, name: "+10% HP" },
        { type: global.UPGRADE_TYPE_REGEN, value: 4, name: "Регенерация 4% от макс HP/сек" }
    ],
    // Уровень 4
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 30, name: "+30% скорость атаки" },
        { type: global.UPGRADE_TYPE_PALADIN_AOE_ATTACK_SPEED, value: 10, name: "Аура: +10% скорости атаки всем союзникам" }
    ],
    // Уровень 5
    [
        { type: global.UPGRADE_TYPE_PALADIN_EVERY_6TH_MISS, value: 1, name: "Каждый 6 удар по паладину - 100% промах" },
        { type: global.UPGRADE_TYPE_DODGE, value: 15, name: "+15% уворот" }
    ],
    // Уровень 6
    [
        { type: global.UPGRADE_TYPE_CLEAVE, value: 15, name: "+15% сплеш" },
        { type: global.UPGRADE_TYPE_PALADIN_INVULN, value: 2, name: "Невосприимчивость к урону на 2 сек (КД 10 сек)" }
    ],
    // Уровень 7
    [
        { type: global.UPGRADE_TYPE_PALADIN_DEFENSE_STACKS, value: 1, name: "За каждый удар: -1% получаемого урона (макс 25 стеков)" },
        { type: global.UPGRADE_TYPE_PALADIN_DAMAGE_STACKS, value: 1, name: "За каждый удар: +1% урона (макс 25 стеков)" }
    ],
    // Уровень 8
    [
        { type: global.UPGRADE_TYPE_PALADIN_GUARDIAN_ANGEL, value: 5, name: "Ангел-хранитель: раз в 10 сек лечит 5% HP всем и дает +7% скор. атаки на 5 сек" },
        { type: global.UPGRADE_TYPE_PALADIN_BODYGUARD, value: 3, name: "Телохранитель: раз в 15 сек, 3 сек получает весь урон вместо союзников" }
    ],
    // Уровень 9
    [
        { type: global.UPGRADE_TYPE_PALADIN_JUSTICE_MARK, value: 40, name: "40% шанс метки правосудия (+6% урона по цели, макс 5 стеков)" },
        { type: global.UPGRADE_TYPE_PALADIN_DIZZINESS, value: 50, name: "50% шанс головокружения у 2 врагов на 2 сек (-10% урона на 3 сек)" }
    ],
    // Уровень 10
    [
        { type: global.UPGRADE_TYPE_PALADIN_HOLY_ARMOR, value: 10, name: "Святая броня: -10% физ. урона и +2% регенерации за слой (макс 4)" },
        { type: global.UPGRADE_TYPE_PALADIN_DIVINE_WEAPON, value: 7, name: "Божественное оружие: +7% урона союзникам и -5% урона паладину за слой (макс 4)" }
    ]
];

// Архимаг (ID: 19) - полное дерево на 10 уровней
global.HERO_TREE_19 = [
    // Уровень 1
    [
        { type: global.UPGRADE_TYPE_HP, value: 20, name: "+20% HP" },
        { type: global.UPGRADE_TYPE_REGEN_PERCENT, value: 3, name: "Регенерация 3% от макс HP/сек" }
    ],
    // Уровень 2
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 15, name: "+15% урона" },
        { type: global.UPGRADE_TYPE_HOLY_POISON, value: 6, name: "Святое отравление: 6% урона/сек на 3 сек" }
    ],
    // Уровень 3
    [
        { type: global.UPGRADE_TYPE_ATTACK_SPEED, value: 15, name: "+15% скор. атаки" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 15, name: "+15% урона" }
    ],
    // Уровень 4
    [
        { type: global.UPGRADE_TYPE_MAGE_BUFF, value: 15, name: "Аура: +15% скор. атаки всем магам" },
        { type: global.UPGRADE_TYPE_MAGE_BUFF, value: 15, name: "Аура: +15% урона всем магам" }
    ],
    // Уровень 5
    [
        { type: global.UPGRADE_TYPE_ICEBERG, value: 100, name: "Айсберг: 100 урона, -30% скор. атаки врагам на 4 сек (КД 15 сек)" },
        { type: global.UPGRADE_TYPE_CURSE, value: 20, name: "Проклятье: +20% получаемого урона 3 врагам на 4 сек (КД 15 сек)" }
    ],
    // Уровень 6
    [
        { type: global.UPGRADE_TYPE_HP, value: 20, name: "+20% HP магам и помощникам" },
        { type: global.UPGRADE_TYPE_DODGE, value: 15, name: "+15% уворот магам и помощникам" }
    ],
    // Уровень 7
    [
        { type: global.UPGRADE_TYPE_SONG_OF_SOUL, value: 20, name: "Песнь души: +20% скор. атаки магам на 5 сек (КД 15 сек)" },
        { type: global.UPGRADE_TYPE_WILL_OF_CHANCE, value: 35, name: "Воля случая: +35% шанс крита магам на 5 сек (КД 15 сек)" }
    ],
    // Уровень 8
    [
        { type: global.UPGRADE_TYPE_DAMAGE, value: 25, name: "+25% урона всем магам" },
        { type: global.UPGRADE_TYPE_REGEN, value: 5, name: "Регенерация 5 HP/сек магам и помощникам" }
    ],
    // Уровень 9
    [
        { type: global.UPGRADE_TYPE_CRIT_DAMAGE, value: 60, name: "+60% крит. урон" },
        { type: global.UPGRADE_TYPE_CRIT_CHANCE, value: 40, name: "+40% шанс крита" }
    ],
    // Уровень 10
    [
        { type: global.UPGRADE_TYPE_PHOENIX_FEATHER, value: 10, name: "Феникс: перо (+10% скор. атаки × убийства героя) на 3 сек" },
        { type: global.UPGRADE_TYPE_DRAGON_SCALE, value: 20, name: "Дракон: чешуя (+20% урона × минуты игры) на 3 сек" }
    ]
];

// Для остальных героев (ID 5-19) - стандартное дерево (можно потом настроить)
// Создаем стандартное дерево на 10 уровней
global.HERO_TREE_DEFAULT = [
    // Уровень 1
    [
        { type: global.UPGRADE_TYPE_HP, value: 20, name: "+20% HP" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 20, name: "+20% урона" }
    ],
    // Уровень 2
    [
        { type: global.UPGRADE_TYPE_HP, value: 20, name: "+20% HP" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 20, name: "+20% урона" }
    ],
    // Уровень 3
    [
        { type: global.UPGRADE_TYPE_HP, value: 20, name: "+20% HP" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 20, name: "+20% урона" }
    ],
    // Уровень 4
    [
        { type: global.UPGRADE_TYPE_HP, value: 20, name: "+20% HP" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 20, name: "+20% урона" }
    ],
    // Уровень 5
    [
        { type: global.UPGRADE_TYPE_HP, value: 20, name: "+20% HP" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 20, name: "+20% урона" }
    ],
    // Уровень 6
    [
        { type: global.UPGRADE_TYPE_HP, value: 30, name: "+30% HP" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 30, name: "+30% урона" }
    ],
    // Уровень 7
    [
        { type: global.UPGRADE_TYPE_HP, value: 30, name: "+30% HP" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 30, name: "+30% урона" }
    ],
    // Уровень 8
    [
        { type: global.UPGRADE_TYPE_HP, value: 30, name: "+30% HP" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 30, name: "+30% урона" }
    ],
    // Уровень 9
    [
        { type: global.UPGRADE_TYPE_HP, value: 40, name: "+40% HP" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 40, name: "+40% урона" }
    ],
    // Уровень 10
    [
        { type: global.UPGRADE_TYPE_HP, value: 50, name: "+50% HP" },
        { type: global.UPGRADE_TYPE_DAMAGE, value: 50, name: "+50% урона" }
    ]
];

function get_hero_tree_data(_hero_id) {
    switch (_hero_id) {
        case 0: return global.HERO_TREE_0;
        case 1: return global.HERO_TREE_1;
        case 2: return global.HERO_TREE_2;
        case 3: return global.HERO_TREE_3;
        case 4: return global.HERO_TREE_4;
        case 5: return global.HERO_TREE_5;
        case 6: return global.HERO_TREE_6;
        case 7: return global.HERO_TREE_7;
        case 8: return global.HERO_TREE_8;
        case 9: return global.HERO_TREE_9;
        case 10: return global.HERO_TREE_10;
        case 11: return global.HERO_TREE_11;
        case 12: return global.HERO_TREE_12;
        case 13: return global.HERO_TREE_13;
        case 14: return global.HERO_TREE_14;
        case 15: return global.HERO_TREE_15;
        case 16: return global.HERO_TREE_16;
        case 17: return global.HERO_TREE_17;
        case 18: return global.HERO_TREE_18;
        case 19: return global.HERO_TREE_19;
        default: return global.HERO_TREE_DEFAULT;
    }
}
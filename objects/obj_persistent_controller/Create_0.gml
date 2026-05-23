/// Create Event - obj_persistent_controller
LOG("=== СОЗДАН ПОСТОЯННЫЙ КОНТРОЛЛЕР ===");
instance_persistent = true;

global.persistent_controller = id;

// Глобальные флаги для окон
global.talent_window_open = false;
global.talent_desc_window_open = false;
global.upgrade_window_open = false;

// Защита от двойных кликов
global.click_blocked = false;
global.click_block_timer = 0;

LOG("=== ГЛОБАЛЬНЫЕ ФЛАГИ ИНИЦИАЛИЗИРОВАНЫ ===");

// ===== ФЛАГ ЗАКРЫТИЯ ИГРЫ (ДОБАВЛЕНО!) =====
game_ending = false;

// Временные данные для окна улучшения
global.temp_upgrade_hero_tree = noone;
global.temp_upgrade_level = 0;
global.temp_upgrade_is_left = true;
global.temp_upgrade_type = "";
global.temp_upgrade_value = 0;
global.temp_upgrade_name = "";
global.temp_upgrade_cost = 0;

// ===== НАСТРОЙКА ОТЛАДКИ =====
global.DEBUG_ENABLED = true;

// Для тестового режима
if (room == room_test) {
    debug_setup_test_mode();
}

if (!variable_global_exists("heroes")) {
    init_hero_manager();
}

// ===== СОХРАНЯЕМ ВРЕМЯ ЗАПУСКА ИГРЫ =====
if (!variable_global_exists("game_start_time")) {
    global.game_start_time = date_current_datetime();
    LOG_CAT("Сохранено время запуска игры", "save");
}

// ===== ДАННЫЕ ТЕКУЩЕГО ЭТАЖА =====
if (!variable_global_exists("current_floor")) {
    global.current_floor = noone;
}

// ===== ФУНКЦИЯ ДЛЯ ПОЛУЧЕНИЯ СЕКУНД С ЗАПУСКА ИГРЫ =====
global.get_seconds_since_start = function() {
    return floor(date_second_span(date_current_datetime(), global.game_start_time));
};

deck_data = {
    slot0: -1,
    slot1: -1,
    slot2: -1,
    slot3: -1
};

// Данные шопа/рулетки/сундуков теперь живут ВНУТРИ global.permanent_save,
// и создаются автоматически в create_default_permanent_save() / load_permanent_save_from().
// Дублирующих global.shop_cards_data / global.chests_data / global.spin_cooldown_data / global.ad_data
// больше нет — это был источник рассинхрона.

// Кристаллы НЕ инициализируем здесь. По двум причинам:
// 1. scr_hero_manager верхнеуровневый код уже выставил global.crystals = 0 при загрузке скриптов.
// 2. obj_data_loader.Create стартует РАНЬШЕ нас и уже загружает кристаллы из save'а.
//    Если бы мы тут сбрасывали в 0, мы бы затирали корректное значение из сохранения.

update_from_global = function() {
    deck_data.slot0 = global.player_deck[0];
    deck_data.slot1 = global.player_deck[1];
    deck_data.slot2 = global.player_deck[2];
    deck_data.slot3 = global.player_deck[3];
};

update_from_global();

// Загрузку сохранений делает obj_data_loader через init_save_system() сразу после
// создания этого контроллера, так что здесь повторно вызывать не нужно — иначе
// загрузка делалась бы дважды.

init_daily_quests();
LOG_CAT("=== ПОСТОЯННЫЙ КОНТРОЛЛЕР ГОТОВ ===", "general");
/// @function debug_log(_message, _category = "general")
/// @desc Универсальная функция отладки с категориями

// ============================================================================
// === МАКРОСЫ ДЛЯ ДЕБАГА =====================================================
// ============================================================================
// LOG(...)     — заменяет show_debug_message(...)
// LOG_CAT(...) — заменяет debug_log(...) с категорией
//
// В release-сборке (DEBUG_BUILD = false в scr_get_unix_timestamp.gml):
//   - оба макроса превращаются в `if (false) ...` — мёртвый код,
//     компилятор GameMaker (YYC) выпиливает его полностью,
//     включая склейку строк типа "Гены: " + string(global.genes).
// В dev-сборке (DEBUG_BUILD = true):
//   - работают как обычные вызовы, как раньше.
//
// ВАЖНО: в новом коде используй LOG / LOG_CAT, а не show_debug_message / debug_log.
#macro LOG     if (DEBUG_BUILD) show_debug_message
#macro LOG_CAT if (DEBUG_BUILD) debug_log

// ============================================================================
// === КНОПКА «НАЗАД» ДЛЯ РАЗНЫХ ПЛАТФОРМ =====================================
// ============================================================================
// IS_BACK_PRESSED ловит «назад» из всех источников:
//   • vk_escape — клавиатура ПК (дев-тестинг) И аппаратная кнопка «Назад» на Android
//                 (GameMaker маппит её на vk_escape автоматически)
//   • mb_right  — правая кнопка мыши (удобно при тестировании в IDE)
//
// На iOS аппаратной кнопки нет — там нужен on-screen back button или свайп,
// это отдельная задача когда дойдём до iOS-сборки.
#macro IS_BACK_PRESSED (keyboard_check_pressed(vk_escape) || mouse_check_button_pressed(mb_right))

// Глобальные настройки отладки
global.DEBUG_ENABLED = true;

// Категории отладки
global.DEBUG_CATEGORIES = {
    general: true,     // Общая
    combat: true,      // Бой (урон, атаки)
    hero: true,        // Герои (призыв, смерть, улучшения)
    enemy: true,       // Враги (спавн, смерть)
    boss: true,        // Боссы
    bleed: true,       // Кровотечение
    vampire: true,     // Вампиризм
    dodge: true,       // Уклонение
    cleave: true,      // Сплеш
    tree: true,        // Дерево прокачки
    shop: false,       // Магазин (по умолчанию выключен)
    rating: false,     // Рейтинг
    save: false        // Сохранение
};

function debug_log(_message, _category = "general") {
    if (!global.DEBUG_ENABLED) return;
    
    // Проверяем, включена ли эта категория
    if (global.DEBUG_CATEGORIES[$ _category] == false) return;
    
    // Добавляем время и категорию
    var time_str = string_format(current_time / 1000, 1, 2);
    LOG("[" + time_str + "][" + string_upper(_category) + "] " + _message);
}

// Функция для временного включения категории
function debug_enable_category(_category) {
    global.DEBUG_CATEGORIES[$ _category] = true;
    LOG_CAT("Категория " + _category + " включена", "debug");
}

// Функция для временного отключения категории
function debug_disable_category(_category) {
    global.DEBUG_CATEGORIES[$ _category] = false;
    LOG_CAT("Категория " + _category + " отключена", "debug");
}

function debug_setup_test_mode() {
    global.DEBUG_CATEGORIES = {
        general: false,    // Выключить общую
        combat: true,      // Бой - включить
        hero: false,       // Выключить призыв героев
        enemy: false,      // Выключить врагов
        boss: false,
        bleed: true,
        vampire: true,
        dodge: true,
        cleave: false,
        tree: false,
        shop: false,
        rating: false,
        save: false
    };
    LOG_CAT("=== ТЕСТОВЫЙ РЕЖИМ ОТЛАДКИ ВКЛЮЧЕН ===", "debug");
}
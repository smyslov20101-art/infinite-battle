/// Create Event - obj_shop_controller
/// Магазин: рулетка, покупка карт, сундуки, наборы.
/// Все таймеры — на Unix-времени, идут даже когда игра закрыта.

if (!variable_global_exists("heroes") || array_length(global.heroes) == 0) {
    init_hero_manager();
}

// Гарантируем что permanent_save с шоп-секциями существует
if (!variable_global_exists("permanent_save")) {
    create_default_permanent_save();
}

init_roulette();
shuffle_roulette();

// ===== ИНТЕРВАЛЫ И ЛИМИТЫ =====
SPIN_FREE_COOLDOWN = 10800;   // 3 часа между бесплатными вращениями рулетки
SHOP_AUTO_REFRESH  = 86400;   // 24 часа между автообновлениями карт магазина
CHEST_AUTO_REFRESH = 86400;   // 24 часа между автообновлениями сундуков
AD_CHARGES_MAX     = 3;       // Сколько раз в день можно использовать "Обновить за рекламу"

// ===== ВРЕМЯ В МАГАЗИНЕ (только для визуального движения карт рулетки) =====
game_time_shop = 0;

// ===== СОСТОЯНИЕ РУЛЕТКИ =====
SPIN_STATE_IDLE = 0;
SPIN_STATE_SPINNING = 1;
SPIN_STATE_STOPPING = 2;
current_state = SPIN_STATE_IDLE;

// ===== ПЕРЕМЕННЫЕ СКРОЛЛА =====
scroll_y = 0;
scroll_max = 0;
is_dragging = false;
drag_start_y = 0;
scroll_start_y = 0;

visible_area_top = 80;
visible_area_bottom = room_height - 200;

// ===== РУЛЕТКА: UI =====
roulette_x = 100;
roulette_y = 200;
roulette_width = 600;
roulette_height = 180;

card_width = 80;
card_height = 120;
card_spacing = 10;
cards_per_row = 1;

pointer_x = roulette_x + roulette_width / 2;
pointer_y = roulette_y + 130;
pointer_width = 4;
pointer_height = roulette_height - 130;

spin_button_x = roulette_x + (roulette_width - 150) / 2;
spin_button_y = roulette_y + roulette_height + 30;
spin_button_width = 150;
spin_button_height = 50;

ad_button_x = spin_button_x + spin_button_width + 20;
ad_button_y = spin_button_y;
ad_button_width = 150;
ad_button_height = 50;

// Анимация рулетки
scroll_x = 0;
scroll_speed = 0.5;
current_speed = 0;
spin_time = 0;
spin_duration = 180;
result_card = -1;

// Отображаемые «остались X секунд» — будут обновляться каждый кадр в Step
spin_cooldown_current   = 0;
shop_refresh_current    = 0;
chest_refresh_current   = 0;

// ===== ОКНО ПРИЗА =====
PRIZE_STATE_NONE = 0;
PRIZE_STATE_SHOWING = 1;
prize_state = PRIZE_STATE_NONE;
current_prize = noone;

prize_window_x = (room_width - 400) / 2;
prize_window_y = (room_height - 500) / 2;
prize_window_width = 400;
prize_window_height = 500;

prize_button_x = prize_window_x + (prize_window_width - 180) / 2;
prize_button_y = prize_window_y + 400;
prize_button_width = 180;
prize_button_height = 40;

// ===== ПОКУПКА КАРТ =====
shop_cards_y = roulette_y + roulette_height + 180;
shop_card_width = 120;
shop_card_height = 160;
shop_card_spacing = 30;
shop_cards_count = 4;

shop_cards = array_create(4);

shop_refresh_button_y = shop_cards_y + shop_card_height + 30;
shop_refresh_button_width = 200;
shop_refresh_button_height = 50;

shop_cards_title = "ПОКУПКА КАРТ";

// ===== КАРТОЧКА ПОКУПКИ =====
BUY_STATE_NONE = 0;
BUY_STATE_SHOWING = 1;
buy_state = BUY_STATE_NONE;
buy_card = noone;
buy_card_index = -1;

buy_window_x = (room_width - 400) / 2;
buy_window_y = (room_height - 500) / 2;
buy_window_width = 400;
buy_window_height = 500;

buy_button_x = buy_window_x + (buy_window_width - 180) / 2;
buy_button_y = buy_window_y + 400;
buy_button_width = 180;
buy_button_height = 40;

// ===== СУНДУКИ =====
CHEST_STATE_NONE = 0;
CHEST_STATE_SHOWING = 1;
CHEST_STATE_REWARDS = 2;
chest_state = CHEST_STATE_NONE;
current_chest = noone;
current_chest_index = -1;
chest_just_opened = false;

chest_rewards = [];

chests_start_y = shop_refresh_button_y + shop_refresh_button_height + 80;
chest_width = 120;
chest_height = 160;
chest_spacing = 30;

// НОВАЯ кнопка обновления сундуков за рекламу (по аналогии с покупкой карт)
chest_refresh_button_y = chests_start_y + chest_height + 30;
chest_refresh_button_width = 200;
chest_refresh_button_height = 50;

chests = array_create(4);

var chest_data = [
    {
        rarity: 0, price_genes: 10000, price_crystals: 0,
        rewards: [{rarity: 0, count: 5}],
        color: make_color_rgb(180, 180, 180), rarity_text: "ОБЫЧНЫЙ"
    },
    {
        rarity: 1, price_genes: 20000, price_crystals: 0,
        rewards: [{rarity: 1, count: 4}, {rarity: 0, count: 3}],
        color: make_color_rgb(100, 100, 255), rarity_text: "РЕДКИЙ"
    },
    {
        rarity: 2, price_genes: 40000, price_crystals: 50,
        rewards: [{rarity: 2, count: 3}, {rarity: 1, count: 2}, {rarity: 0, count: 3}],
        color: make_color_rgb(180, 80, 255), rarity_text: "ЭПИЧЕСКИЙ"
    },
    {
        rarity: 3, price_genes: 100000, price_crystals: 100,
        rewards: [{rarity: 3, count: 1}, {rarity: 1, count: 5}, {rarity: 0, count: 10}],
        color: make_color_rgb(255, 180, 50), rarity_text: "ЛЕГЕНДАРНЫЙ"
    }
];
for (var i = 0; i < 4; i++) {
    chests[i] = chest_data[i];
    chests[i].bought = false;
}

// ===== НАБОРЫ =====
SET_STATE_NONE = 0;
SET_STATE_SHOWING = 1;
set_state = SET_STATE_NONE;
current_set = noone;
current_set_index = -1;
set_just_opened = false;

// Сдвигаем наборы ниже кнопки обновления сундуков
sets_start_y = chest_refresh_button_y + chest_refresh_button_height + 80;
set_width = 120;
set_height = 160;
set_spacing = 30;
sets_per_row = 4;
sets_rows = 2;
sets_count = 8;

sets = array_create(sets_count);

var set_data = [
    {name: "100000 ГЕНОВ",   price_rub: 250, reward_type: "genes",    reward_amount: 100000, color: make_color_rgb(255, 215, 0),   active: true, sku: "genes_100000"},
    {name: "100 КРИСТАЛЛОВ", price_rub: 200, reward_type: "crystals", reward_amount: 100,    color: make_color_rgb(100, 200, 255), active: true, sku: "crystals_100"},
    {name: "500 КРИСТАЛЛОВ", price_rub: 500, reward_type: "crystals", reward_amount: 500,    color: make_color_rgb(100, 200, 255), active: true, sku: "crystals_500"},
    {name: "ЛЕГЕНДАРНЫЙ СУНДУК", price_rub: 999, reward_type: "chest", reward_chest_index: 3, color: make_color_rgb(255, 180, 50), active: true, sku: "chest_legendary"},
    {name: "СКОРО", price_rub: 0, reward_type: "coming_soon", color: make_color_rgb(100, 100, 100), active: false},
    {name: "СКОРО", price_rub: 0, reward_type: "coming_soon", color: make_color_rgb(100, 100, 100), active: false},
    {name: "СКОРО", price_rub: 0, reward_type: "coming_soon", color: make_color_rgb(100, 100, 100), active: false},
    {name: "СКОРО", price_rub: 0, reward_type: "coming_soon", color: make_color_rgb(100, 100, 100), active: false}
];
for (var i = 0; i < sets_count; i++) {
    sets[i] = set_data[i];
}

set_window_x = (room_width - 400) / 2;
set_window_y = (room_height - 500) / 2;
set_window_width = 400;
set_window_height = 500;

set_button_x = set_window_x + (set_window_width - 180) / 2;
set_button_y = set_window_y + 400;
set_button_width = 180;
set_button_height = 40;

iap_test_mode = true;

chest_window_x = (room_width - 400) / 2;
chest_window_y = (room_height - 500) / 2;
chest_window_width = 400;
chest_window_height = 500;

chest_button_x = chest_window_x + (chest_window_width - 180) / 2;
chest_button_y = chest_window_y + 400;
chest_button_width = 180;
chest_button_height = 40;

rewards_window_x = (room_width - 400) / 2;
rewards_window_y = (room_height - 500) / 2;
rewards_window_width = 400;
rewards_window_height = 500;

rewards_button_x = rewards_window_x + (rewards_window_width - 180) / 2;
rewards_button_y = rewards_window_y + 400;
rewards_button_width = 180;
rewards_button_height = 40;

// ============================================================================
// === ИНИЦИАЛИЗАЦИЯ ШОП-ДАННЫХ ИЗ PERMANENT_SAVE НА UNIX-ВРЕМЕНИ =============
// ============================================================================

var now_ts = scr_get_unix_timestamp();
var today  = scr_get_day_number();

var pspin   = global.permanent_save.spin_data;
var pcards  = global.permanent_save.shop_cards_data;
var pchests = global.permanent_save.chests_data;

var need_initial_save = false;

// --- сброс зарядов рекламы в полночь ---
if (pspin.ad_reset_day != today) {
    pspin.ad_charges = AD_CHARGES_MAX;
    pspin.ad_reset_day = today;
    need_initial_save = true;
}
if (pcards.ad_reset_day != today) {
    pcards.ad_charges = AD_CHARGES_MAX;
    pcards.ad_reset_day = today;
    need_initial_save = true;
}
if (pchests.ad_reset_day != today) {
    pchests.ad_charges = AD_CHARGES_MAX;
    pchests.ad_reset_day = today;
    need_initial_save = true;
}

// --- если карты ещё ни разу не генерировались — генерируем и ставим таймер 24ч ---
if (pcards.auto_refresh_at <= 0 || array_length(pcards.cards) == 0) {
    refresh_shop_cards();
    pcards.auto_refresh_at = now_ts + SHOP_AUTO_REFRESH;
    need_initial_save = true;
}

// --- если у сундуков ещё нет таймера обновления — ставим 24ч от сейчас ---
if (pchests.auto_refresh_at <= 0) {
    pchests.auto_refresh_at = now_ts + CHEST_AUTO_REFRESH;
    need_initial_save = true;
}

// --- если auto_refresh_at УЖЕ в прошлом (игрок не заходил больше суток) — обновляем сразу ---
if (now_ts >= pcards.auto_refresh_at) {
    refresh_shop_cards();
    pcards.auto_refresh_at = now_ts + SHOP_AUTO_REFRESH;
    need_initial_save = true;
}
if (now_ts >= pchests.auto_refresh_at) {
    for (var i = 0; i < 4; i++) pchests.bought[i] = false;
    pchests.auto_refresh_at = now_ts + CHEST_AUTO_REFRESH;
    need_initial_save = true;
}

// --- грузим текущие карты в локальный массив для отрисовки ---
if (array_length(pcards.cards) > 0) {
    shop_cards = array_create(shop_cards_count);
    for (var i = 0; i < shop_cards_count; i++) {
        var loaded_card = pcards.cards[i];
        if (loaded_card != undefined && is_struct(loaded_card) && struct_exists(loaded_card, "hero_id")) {
            shop_cards[i] = {
                hero_id: loaded_card.hero_id,
                rarity: loaded_card.rarity,
                price_genes: loaded_card.price_genes,
                price_crystals: loaded_card.price_crystals
            };
        } else {
            shop_cards[i] = undefined;
        }
    }
}

// --- грузим состояние сундуков ---
for (var i = 0; i < 4; i++) {
    chests[i].bought = pchests.bought[i];
}

// --- начальные значения отображаемых таймеров ---
spin_cooldown_current = max(0, pspin.free_spin_at - now_ts);
shop_refresh_current  = max(0, pcards.auto_refresh_at - now_ts);
chest_refresh_current = max(0, pchests.auto_refresh_at - now_ts);

// ===== РАСЧЕТ МАКСИМАЛЬНОГО СКРОЛЛА =====
var content_top = roulette_y - 50;
var content_bottom = sets_start_y + (sets_rows * set_height) + ((sets_rows - 1) * set_spacing) + 100;
var content_height = content_bottom - content_top;
var visible_height = visible_area_bottom - visible_area_top;
scroll_max = max(0, content_height - visible_height);

// Если что-то реально изменилось при инициализации — сохраняем один раз
if (need_initial_save) {
    save_permanent_to_file();
}

LOG("=== МАГАЗИН ИНИЦИАЛИЗИРОВАН ===");
LOG("Сейчас (Unix): " + string(now_ts));
LOG("Сегодня (день): " + string(today));
LOG("Заряды рекламы — рулетка: " + string(pspin.ad_charges) +
                   ", карты: " + string(pcards.ad_charges) +
                   ", сундуки: " + string(pchests.ad_charges));
LOG("До авто-обновления карт: " + string(shop_refresh_current) + " сек");
LOG("До авто-обновления сундуков: " + string(chest_refresh_current) + " сек");
LOG("До бесплатного крута: " + string(spin_cooldown_current) + " сек");

/// @function scr_update_timers_from_timestamps()
/// @desc DEPRECATED. Раньше пересчитывала таймеры магазина из старых полей
///       (global.spin_cooldown_data, global.shop_cards_data.refresh_24_until и т.д.).
///       После перехода на Unix-time все таймеры обновляются прямо в Step Event
///       obj_shop_controller на основе global.permanent_save.*.
///       Оставлено как no-op для совместимости с возможными старыми вызовами.

function scr_update_timers_from_timestamps() {
    // intentionally empty
}

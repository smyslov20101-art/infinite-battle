/// @function reset_ad_limit()
/// @desc Сбрасывает счетчик рекламы (новый день)

function reset_ad_limit() {
    ad_used_today = 0;
    ad_last_reset_day = floor(global.real_time_shop / 86400); // Текущий день
    LOG("=== ЛИМИТ РЕКЛАМЫ СБРОШЕН ===");
    LOG("Новый день, можно смотреть рекламу " + string(ad_max_per_day) + " раза");
}
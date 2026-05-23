/// @function debug_reset_ad()
/// @desc Сбрасывает лимит рекламы (для тестирования)

function debug_reset_ad() {
    ad_used_today = 0;
    LOG("=== ТЕСТ: ЛИМИТ РЕКЛАМЫ СБРОШЕН ===");
}
/// @function scr_get_unix_timestamp()
/// @desc Возвращает текущий Unix timestamp в секундах (UTC).
///       Это РЕАЛЬНОЕ время с 1970 года, не зависит от того,
///       сколько времени игра уже запущена. Идёт даже когда игра закрыта.
/// @return {real} Unix timestamp

// ===== ГЛОБАЛЬНЫЙ ФЛАГ СБОРКИ =====
// true  → разработка: работают чит-клавиши (G, C, R, M, B, 0, S, …).
// false → релиз: все читы компилируются в no-op. Меняй ПЕРЕД сборкой apk/ipa.
#macro DEBUG_BUILD true

// Опорная точка: 2000-01-01 00:00:00 UTC.
// Берём 2000 а не 1970, потому что GameMaker бросает ошибку
// "invalid date conversion" на дате 1 января 1970 (краевой кейс OLE-дат).
// 2000-01-01 в Unix-времени = 946 684 800 секунд.
#macro UNIX_EPOCH_REF_DATE_Y 2000
#macro UNIX_EPOCH_REF_DATE_M 1
#macro UNIX_EPOCH_REF_DATE_D 1
#macro UNIX_EPOCH_REF_OFFSET 946684800

function scr_get_unix_timestamp() {
    var current_date = date_current_datetime();
    var reference = date_create_datetime(UNIX_EPOCH_REF_DATE_Y, UNIX_EPOCH_REF_DATE_M, UNIX_EPOCH_REF_DATE_D, 0, 0, 0);
    // date_second_span(date1, date2) = date2 - date1
    var seconds_since_2000 = date_second_span(reference, current_date);
    return floor(seconds_since_2000 + UNIX_EPOCH_REF_OFFSET);
}

/// @function scr_get_day_number()
/// @desc Возвращает номер текущего календарного дня в МСК (UTC+3).
///       Каждый день в полночь по МСК номер увеличивается на 1.
///       Используется для сброса ежедневных лимитов (например, 3 заряда рекламы).
/// @return {real} номер дня

function scr_get_day_number() {
    var msk_time = date_inc_hour(date_current_datetime(), 3);
    var reference = date_create_datetime(UNIX_EPOCH_REF_DATE_Y, UNIX_EPOCH_REF_DATE_M, UNIX_EPOCH_REF_DATE_D, 0, 0, 0);
    return floor(date_second_span(reference, msk_time) / 86400);
}

/// @function scr_format_time(_seconds)
/// @desc Форматирует количество секунд как H:MM:SS (или MM:SS если меньше часа).
///       Примеры: 3661 → "1:01:01", 65 → "01:05", 5 → "00:05".
/// @param {real} _seconds  количество секунд
/// @return {string}

function scr_format_time(_seconds) {
    _seconds = max(0, floor(_seconds));
    var h = floor(_seconds / 3600);
    var m = floor((_seconds mod 3600) / 60);
    var s = _seconds mod 60;

    var mm = (m < 10 ? "0" : "") + string(m);
    var ss = (s < 10 ? "0" : "") + string(s);

    if (h > 0) return string(h) + ":" + mm + ":" + ss;
    return mm + ":" + ss;
}

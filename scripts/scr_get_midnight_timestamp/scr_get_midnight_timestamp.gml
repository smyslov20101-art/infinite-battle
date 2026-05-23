/// @function scr_get_midnight_timestamp()
/// @desc Возвращает Unix timestamp следующей полуночи по московскому времени (UTC+3).
///       Использует ту же опорную точку (2000-01-01), что и scr_get_unix_timestamp(),
///       чтобы избежать ошибки GameMaker на дате 1 января 1970.
/// @return {real} Unix timestamp в секундах

function scr_get_midnight_timestamp() {
    var msk_time = date_inc_hour(date_current_datetime(), 3);

    var year = date_get_year(msk_time);
    var month = date_get_month(msk_time);
    var day = date_get_day(msk_time);

    // Следующая полночь = текущий день + 1, 00:00:00
    var last_day = date_days_in_month(date_create_datetime(year, month, 1, 0, 0, 0));
    if (day >= last_day) {
        day = 1;
        month++;
        if (month > 12) {
            month = 1;
            year++;
        }
    } else {
        day++;
    }

    var next_midnight_msk = date_create_datetime(year, month, day, 0, 0, 0);
    var next_midnight_utc = date_inc_hour(next_midnight_msk, -3);

    var reference = date_create_datetime(UNIX_EPOCH_REF_DATE_Y, UNIX_EPOCH_REF_DATE_M, UNIX_EPOCH_REF_DATE_D, 0, 0, 0);
    var seconds_since_ref = date_second_span(reference, next_midnight_utc);
    return floor(seconds_since_ref + UNIX_EPOCH_REF_OFFSET);
}

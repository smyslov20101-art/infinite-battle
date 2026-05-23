/// @function save_shop_cards()
/// @desc Синхронизирует текущие карты в магазине с permanent_save.
///       Запись на диск делается отдельно — save_permanent_to_file().

function save_shop_cards() {
    if (!variable_global_exists("permanent_save")) return;
    if (!struct_exists(global.permanent_save, "shop_cards_data")) return;

    global.permanent_save.shop_cards_data.cards = shop_cards;
}

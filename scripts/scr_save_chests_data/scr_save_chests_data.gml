/// @function save_chests_data()
/// @desc Синхронизирует состояние сундуков (bought[]) с permanent_save.
///       Запись на диск делается отдельно — save_permanent_to_file().

function save_chests_data() {
    if (!variable_global_exists("permanent_save")) return;
    if (!struct_exists(global.permanent_save, "chests_data")) return;

    for (var i = 0; i < 4; i++) {
        global.permanent_save.chests_data.bought[i] = chests[i].bought;
    }
}

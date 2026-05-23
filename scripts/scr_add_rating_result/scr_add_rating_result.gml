/// @function add_rating_result(_player_name, _time)
/// @desc Добавляет результат игрока в рейтинг
/// @param _player_name {string} Имя игрока
/// @param _time {real} Время выживания в секундах

function add_rating_result(_player_name, _time) {
    if (!variable_global_exists("permanent_save")) return false;
    
    // Создаем структуру рейтинга если её нет
    if (!struct_exists(global.permanent_save, "rating_data")) {
        global.permanent_save.rating_data = {
            players: [],
            last_update: 0
        };
    }
    
    var players = global.permanent_save.rating_data.players;
    
    // Проверяем, есть ли уже такой игрок
    var found = false;
    for (var i = 0; i < array_length(players); i++) {
        if (players[i].name == _player_name) {
            found = true;
            // Если новое время лучше - обновляем
            if (_time > players[i].time) {
                players[i].time = _time;
                LOG("Обновлен результат игрока " + _player_name + ": " + string(_time));
            }
            break;
        }
    }
    
    // Если игрока нет - добавляем
    if (!found) {
        array_push(players, {
            name: _player_name,
            time: _time
        });
        LOG("Добавлен новый игрок в рейтинг: " + _player_name + " - " + string(_time));
    }
    
    // Сортируем рейтинг
    sort_rating();
    
    // Оставляем только топ-100
    if (array_length(players) > 100) {
        array_resize(players, 100);
    }
    
    // Обновляем время последнего изменения
    global.permanent_save.rating_data.last_update = current_time;
    
    // Сохраняем в файл
    save_permanent_to_file();
    
    return true;
}
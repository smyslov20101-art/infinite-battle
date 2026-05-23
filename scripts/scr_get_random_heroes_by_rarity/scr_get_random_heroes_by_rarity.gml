/// @function get_random_heroes_by_rarity(_rarity, _count)
/// @desc Возвращает массив случайных героев указанной редкости (могут повторяться)
/// @param _rarity {number} 0-обычный, 1-редкий, 2-эпический, 3-легендарный
/// @param _count {number} Количество героев
/// @return {array} Массив ID героев

function get_random_heroes_by_rarity(_rarity, _count) {
    var result = [];
    
    // Собираем всех героев указанной редкости (ДАЖЕ ЕСЛИ ЗАБЛОКИРОВАНЫ!)
    var heroes_of_rarity = [];
    for (var i = 0; i < array_length(global.heroes); i++) {
        if (global.heroes[i].rarity == _rarity) {
            array_push(heroes_of_rarity, i);
        }
    }
    
    // Если нет героев такой редкости, возвращаем пустой массив
    if (array_length(heroes_of_rarity) == 0) {
        LOG("ВНИМАНИЕ: Нет героев редкости " + string(_rarity));
        return result;
    }
    
    // Выбираем случайных героев (с повторениями)
    for (var j = 0; j < _count; j++) {
        var random_index = floor(random(array_length(heroes_of_rarity)));
        array_push(result, heroes_of_rarity[random_index]);
    }
    
    return result;
}
/// @function check_hero_card_click(_mx, _my, _scroll_y)
/// @desc Проверяет, попал ли клик в карточку героя (по спрайту!)
function check_hero_card_click(_mx, _my, _scroll_y) {
    // Параметры сетки (НОВЫЕ РАЗМЕРЫ!)
    var hero_card_width = 172;
    var hero_card_height = 223;
    var hero_card_spacing = 15;  // Отступ между карточками
    var cards_per_row = 4;
    var total_cards_width = cards_per_row * hero_card_width + (cards_per_row - 1) * hero_card_spacing;
    var list_start_x = (room_width - total_cards_width) / 2;
    var list_start_y = 490; // 160 + 140 + 40 + 150 = 490
    
    // Дополнительные параметры
    var nav_top = room_height - 200;  // Верхняя граница кнопок навигации
    var resources_bottom = 80;        // Нижняя граница шторки ресурсов
    
    // Если клик вне сетки по горизонтали
    if (_mx < list_start_x || _mx > list_start_x + total_cards_width) {
        return -1;
    }
    
    // Если клик под кнопками навигации
    if (_my > nav_top) {
        return -1;
    }
    
    // Если клик выше шторки ресурсов
    if (_my < resources_bottom) {
        return -1;
    }
    
    // Определяем колонку
    var click_x = _mx - list_start_x;
    var click_y = _my - list_start_y + _scroll_y;  // Учитываем скролл
    
    var col = -1;
    for (var c = 0; c < cards_per_row; c++) {
        var card_left = c * (hero_card_width + hero_card_spacing);
        var card_right = card_left + hero_card_width;
        if (click_x >= card_left && click_x <= card_right) {
            col = c;
            break;
        }
    }
    
    if (col == -1) return -1;
    
    // ОТЛАДКА: выводим координаты клика
    LOG("=== КЛИК ПО КАРТОЧКЕ ===");
    LOG("click_x = " + string(click_x) + ", click_y = " + string(click_y));
    LOG("scroll_y = " + string(_scroll_y));
    
    // Определяем строку и вычисляем индекс героя
    var hero_index = -1;
    
    // Группа 1: ОБЫЧНЫЕ ГЕРОИ (индексы 0-7) - 2 ряда
    var row_height = hero_card_height + hero_card_spacing;
    var ordinary_start_y = 0;  // Относительно list_start_y
    
    if (click_y >= ordinary_start_y && click_y < ordinary_start_y + 2 * row_height) {
        var row = floor((click_y - ordinary_start_y) / row_height);
        hero_index = row * cards_per_row + col;
        if (hero_index >= 0 && hero_index < 8) {
            LOG("ОБЫЧНЫЙ: ряд " + string(row) + ", колонка " + string(col) + ", индекс = " + string(hero_index));
            return hero_index;
        }
    }
    
    // Группа 2: РЕДКИЕ ГЕРОИ (индексы 8-13) - 2 ряда
    var rare_start_y = ordinary_start_y + 2 * row_height + 40;
    
    if (click_y >= rare_start_y && click_y < rare_start_y + 2 * row_height) {
        var row = floor((click_y - rare_start_y) / row_height);
        hero_index = 8 + row * cards_per_row + col;
        if (hero_index >= 8 && hero_index < 14) {
            LOG("РЕДКИЙ: ряд " + string(row) + ", колонка " + string(col) + ", индекс = " + string(hero_index));
            return hero_index;
        }
    }
    
    // Группа 3: ЭПИЧЕСКИЕ ГЕРОИ (индексы 14-17) - 1 ряд
    var epic_start_y = rare_start_y + 2 * row_height + 40;
    
    if (click_y >= epic_start_y && click_y < epic_start_y + row_height) {
        hero_index = 14 + col;
        if (hero_index >= 14 && hero_index < 18) {
            LOG("ЭПИЧЕСКИЙ: колонка " + string(col) + ", индекс = " + string(hero_index));
            return hero_index;
        }
    }
    
    // Группа 4: ЛЕГЕНДАРНЫЕ ГЕРОИ (индексы 18-19) - 1 ряд, только 2 колонки
    var legendary_start_y = epic_start_y + row_height + 40;
    
    if (click_y >= legendary_start_y && click_y < legendary_start_y + row_height) {
        if (col < 2) {
            hero_index = 18 + col;
            LOG("ЛЕГЕНДАРНЫЙ: колонка " + string(col) + ", индекс = " + string(hero_index));
            return hero_index;
        }
    }
    
    LOG("КЛИК НЕ ПОПАЛ НИ В ОДНУ КАРТОЧКУ");
    return -1;
}
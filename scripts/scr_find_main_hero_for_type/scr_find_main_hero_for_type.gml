function scr_find_main_hero_for_type(_hero_type) {
    var main_hero = noone;
    var oldest_time = 999999;
    var living_heroes = 0;
    
    LOG("Поиск главного героя типа " + _hero_type);
    
    // Сначала считаем сколько живых героев этого типа
    with (obj_hero_base) {
        if (state != STATE_DEAD && hero_type == _hero_type) {
            living_heroes++;
        }
    }
    
    LOG("Найдено живых героев типа " + _hero_type + ": " + string(living_heroes));
    
    // Ищем живого героя этого типа
    with (obj_hero_base) {
        if (state != STATE_DEAD && hero_type == _hero_type) {
            // Если уже есть главный - сразу возвращаем его
            if (is_main_hero) {
                LOG("Найден существующий главный герой ID=" + string(id) + 
                                  " (тип: " + hero_type + ")");
                return id;
            }
            
            // Иначе ищем самого старого (по времени создания)
            if (state_timer < oldest_time) {
                oldest_time = state_timer;
                main_hero = id;
            }
        }
    }
    
    if (instance_exists(main_hero)) {
        // Назначаем нового главного
        with (main_hero) {
            is_main_hero = true;
            LOG("Назначен новый главный герой ID=" + string(id) + 
                              " (тип: " + hero_type + ")");
            
            // Убеждаемся, что у героя есть целевая позиция
            if (target_x == 0 && target_y == 0) {
                set_hero_target_by_class(id);
            }
        }
    } else {
        LOG("Главный герой не найден, живых героев: " + string(living_heroes));
    }
    
    return main_hero;
}
/// @function scr_find_main_hero_for_class(_hero_class)
/// @desc Находит главного героя указанного класса
function scr_find_main_hero_for_class(_hero_class) {
    var main_hero = noone;
    var oldest_time = 999999;
    
    LOG("Поиск главного героя класса " + _hero_class);
    
    // Ищем живого героя этого класса
    with (obj_hero_base) {
        if (state != STATE_DEAD && hero_class == _hero_class) {
            // Если уже есть главный - сразу возвращаем его
            if (is_main_hero) {
                LOG("Найден существующий главный герой ID=" + string(id));
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
        LOG("Назначен новый главный герой ID=" + string(main_hero.id));
    } else {
        LOG("Главный герой не найден");
    }
    
    return main_hero;
}
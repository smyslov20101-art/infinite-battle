/// @function scr_hero_perform_merge(_hero_instance, _target_hero)
/// @desc ВЫПОЛНЯЕТ слияние двух героев с учетом бонусов от дерева прокачки

function scr_hero_perform_merge(_hero_instance, _target_hero) {
    if (!instance_exists(_hero_instance) || !instance_exists(_target_hero)) {
        return false;
    }
    
    // Сохраняем характеристики и бонусы сливающегося героя
    var merging_hp = _hero_instance.hp;
    var merging_max_hp = _hero_instance.max_hp;
    var merging_damage = _hero_instance.damage;
    var merging_bonus_hp = _hero_instance.bonus_hp_multiplier || 1.0;
    var merging_bonus_damage = _hero_instance.bonus_damage_multiplier || 1.0;
    
    // Улучшаем главного героя (цель слияния)
    with (_target_hero) {
        // Увеличиваем уровень
        hero_level += 1;
        
        // Сохраняем текущее соотношение HP
        var hp_ratio = hp / max_hp;
        
        // Добавляем максимальное здоровье от сливающегося героя с учетом его бонусов
        var hp_gain = merging_max_hp;
        max_hp += hp_gain;
        
        // Восстанавливаем HP с учетом соотношения + дополнительное лечение от слияния
        hp = (max_hp - hp_gain) * hp_ratio + hp_gain; // Полностью исцеляем добавленное здоровье
        
        // Добавляем урон от сливающегося героя
        damage += merging_damage;
        
        // Накапливаем бонусы
        bonus_hp_multiplier = (bonus_hp_multiplier || 1.0) * merging_bonus_hp;
        bonus_damage_multiplier = (bonus_damage_multiplier || 1.0) * merging_bonus_damage;
        
        LOG("=== СЛИЯНИЕ ВЫПОЛНЕНО ===");
        LOG("Новый уровень: " + string(hero_level));
        LOG("HP: " + string(floor(hp)) + "/" + string(floor(max_hp)));
        LOG("Урон: " + string(floor(damage)));
        LOG("Бонус HP: x" + string(bonus_hp_multiplier));
        LOG("Бонус урона: x" + string(bonus_damage_multiplier));
    }
    
    // Уменьшаем счетчик героев в контроллере
    var controller = instance_find(obj_game_controller, 0);
    if (instance_exists(controller)) {
        // Здесь можно обновлять счетчики если нужно
    }
    
    // Уничтожаем сливающегося героя
    instance_destroy(_hero_instance);
    
    return true;
}
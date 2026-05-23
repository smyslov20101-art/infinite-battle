/// @function scr_create_magic_ball(_mage_instance, _ball_x)
/// @desc Создает шар магии в указанной позиции X

function scr_create_magic_ball(_mage_instance, _ball_x) {
    // 1. Проверка входных параметров
    if (!instance_exists(_mage_instance)) {
        LOG("Ошибка scr_create_magic_ball: маг не существует!");
        return noone;
    }
    
    // 2. Сохраняем характеристики мага
    var mage_damage = _mage_instance.damage;
    var mage_ball_speed = 8; // Фиксированная скорость
    var mage_damage_radius = 150; // Фиксированный радиус взрыва
    var mage_aoe_min = _mage_instance.aoe_range_min || 400;
    var mage_aoe_max = _mage_instance.aoe_range_max || 700;
    
    // 3. Позиция создания
    var ball_x = _ball_x; // Центр зоны (550)
    var ball_y = -50; // Сверху экрана
    
    // 4. Проверка существования объекта шара
    if (!object_exists(obj_magic_ball)) {
        LOG("Критическая ошибка: obj_magic_ball не существует!");
        return noone;
    }
    
    // 5. Создание экземпляра шара
    var ball = instance_create_layer(ball_x, ball_y, "Instances", obj_magic_ball);
    
    if (!instance_exists(ball)) {
        LOG("Ошибка: не удалось создать экземпляр шара!");
        return noone;
    }
    
    // 6. Настройка характеристик шара
    with (ball) {
        // === ОБЯЗАТЕЛЬНО: Обнуляем любые унаследованные скорости ===
        hspeed = 0;
        vspeed = 0;
        direction = 0;
        gravity = 0;
        gravity_direction = 0;
        
        // === Ручная настройка движения ===
        speed = mage_ball_speed;      // Скорость падения = 8
        direction = 270;              // Направление вниз (270 градусов)
        
        // === Характеристики от мага ===
        caster = _mage_instance;      // Ссылка на создавшего мага
        damage = mage_damage;         // Урон от мага
        damage_radius = mage_damage_radius; // Радиус взрыва = 150
        
        // === Зона поражения (для отладки/будущих улучшений) ===
        aoe_min_x = mage_aoe_min;     // 400
        aoe_max_x = mage_aoe_max;     // 700
        
        // === Параметры движения ===
        target_y = 600;               // Где взрываться (y координата)
        lifetime = 300;               // Максимальное время жизни
        
        // === Визуальные настройки ===
        if (sprite_exists(spr_magic_ball)) {
            sprite_index = spr_magic_ball;
            image_alpha = 1.0;
            image_blend = c_white;
        }
        
        // === Отладочная информация ===
        creation_time = current_time;
        
        
    }
    
    return ball;
}
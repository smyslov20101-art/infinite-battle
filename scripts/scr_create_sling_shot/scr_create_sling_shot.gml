/// @function scr_create_sling_shot(_shooter, _target, _damage)
/// @desc Создает снаряд из рогатки (летит по высокой дуге)

function scr_create_sling_shot(_shooter, _target, _damage) {
    if (!instance_exists(_shooter) || !instance_exists(_target)) {
        LOG_CAT("❌ ОШИБКА: shooter или target не существует!", "combat");
        return noone;
    }
    
    // Используем obj_arrow для снарядов (у него есть логика дуги)
    var projectile = instance_create_layer(_shooter.x, _shooter.y, "Instances", obj_arrow);
    
    with (projectile) {
        shooter = _shooter;
        target = _target;
        damage = _damage;
        
        // ===== ПАРАМЕТРЫ ДУГИ (КАК У ЛУЧНИКА) =====
        speed = 10;                     // Скорость полета
        arc_height = 140;               // Высокая дуга
        arc_progress = 0;
        arc_speed = 0.025;              // Скорость движения по дуге
        
        start_x = x;
        start_y = y;
        
        // Для наведения (как у стрелы)
        flight_phase = 0;
        homing_strength = 0.2;
        homing_active = false;
        
        // ===== ВИЗУАЛ =====
        if (sprite_exists(spr_stone)) {
            sprite_index = spr_stone;
            image_blend = c_white;
        } else if (sprite_exists(spr_arrow)) {
            sprite_index = spr_arrow;
            image_blend = c_brown;
        }
        
        LOG_CAT("🪨 КАМЕНЬ ИЗ РОГАТКИ СОЗДАН! Урон: " + string(damage) + 
                  ", скорость: " + string(speed) + ", дуга: " + string(arc_height), "combat");
    }
    
    return projectile;
}
/// @function scr_create_lightning_bolt(_caster, _target, _damage)
/// @desc Создает молнию для Мага молний (использует obj_lightning_bolt)

function scr_create_lightning_bolt(_caster, _target, _damage) {
    if (!instance_exists(_caster) || !instance_exists(_target)) {
        LOG_CAT("❌ ОШИБКА: caster или target не существует!", "combat");
        return noone;
    }
    
    // Создаем отдельный объект для молнии
    var projectile = instance_create_layer(_caster.x, _caster.y, "Instances", obj_lightning_bolt);
    
    with (projectile) {
        caster = _caster;
        target = _target;
        damage = _damage;
        
        // Скорость и направление
        speed = 18;
        direction = point_direction(x, y, target.x, target.y);
        hspeed = lengthdir_x(speed, direction);
        vspeed = lengthdir_y(speed, direction);
        image_angle = direction;
        
        start_x = x;
        start_y = y;
        
        LOG_CAT("⚡ МОЛНИЯ МАГА МОЛНИЙ! Урон: " + string(damage) + 
                  ", цель: " + string(target.object_index) + 
                  ", направление: " + string(direction), "combat");
    }
    
    return projectile;
}
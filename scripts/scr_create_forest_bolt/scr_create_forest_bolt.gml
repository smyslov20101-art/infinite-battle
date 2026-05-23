/// @function scr_create_forest_bolt(_caster, _target, _damage)
/// @desc Создает болт лесного мага (использует obj_forest_bolt)

function scr_create_forest_bolt(_caster, _target, _damage) {
    if (!instance_exists(_caster) || !instance_exists(_target)) {
        LOG_CAT("❌ ОШИБКА: caster или target не существует!", "combat");
        return noone;
    }
    
    var bolt = instance_create_layer(_caster.x, _caster.y, "Instances", obj_forest_bolt);
    
    with (bolt) {
        caster = _caster;
        target = _target;
        damage = _damage;
        
        // Направление к цели
        direction = point_direction(x, y, target.x, target.y);
        hspeed = lengthdir_x(speed, direction);
        vspeed = lengthdir_y(speed, direction);
        image_angle = direction;
        
        LOG_CAT("🌿 БОЛТ ЛЕСНОГО МАГА СОЗДАН! Урон: " + string(damage) + 
                  ", направление: " + string(direction), "combat");
    }
    
    return bolt;
}
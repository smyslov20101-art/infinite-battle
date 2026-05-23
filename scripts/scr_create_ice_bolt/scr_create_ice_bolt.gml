/// @function scr_create_ice_bolt(_caster, _target, _damage)
/// @desc Создает ледяной снаряд мага льда

function scr_create_ice_bolt(_caster, _target, _damage) {
    if (!instance_exists(_caster) || !instance_exists(_target)) {
        LOG_CAT("❌ ОШИБКА: caster или target не существует!", "combat");
        return noone;
    }
    
    var projectile = instance_create_layer(_caster.x, _caster.y, "Instances", obj_arrow);
    
    with (projectile) {
        caster = _caster;
        target = _target;
        damage = _damage;
        
        // ===== ВАЖНО: Устанавливаем hspped и vspeed для движения =====
        speed = 10;
        direction = point_direction(x, y, target.x, target.y);
        
        // Устанавливаем горизонтальную и вертикальную скорость
        hspeed = lengthdir_x(speed, direction);
        vspeed = lengthdir_y(speed, direction);
        
        // Отключаем гравитацию и дугу
        gravity = 0;
        arc_height = 0;
        arc_progress = 0;
        arc_speed = 0;
        
        start_x = x;
        start_y = y;
        
        // Визуал - ледяной снаряд (spr_bol с голубым цветом)
        if (sprite_exists(spr_ice_bolt)) {
            sprite_index = spr_ice_bolt;
            image_blend = c_aqua;
        } else if (sprite_exists(spr_arrow)) {
            sprite_index = spr_arrow;
            image_blend = c_aqua;
        }
        
        // Поворот в сторону движения
        image_angle = direction;
        
        LOG_CAT("❄️ ЛЕДЯНОЙ СНАРЯД СОЗДАН! Урон: " + string(damage) + 
                  ", скорость: " + string(speed) + 
                  ", направление: " + string(direction), "combat");
    }
    
    return projectile;
}
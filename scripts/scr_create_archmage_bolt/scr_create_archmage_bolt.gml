/// @function scr_create_archmage_bolt(_caster, _target, _damage)
/// @desc Создает магический снаряд Архимага (использует spr_archmage_bolt)

function scr_create_archmage_bolt(_caster, _target, _damage) {
    if (!instance_exists(_caster) || !instance_exists(_target)) {
        LOG_CAT("❌ ОШИБКА: caster или target не существует!", "combat");
        return noone;
    }
    
    var projectile = instance_create_layer(_caster.x, _caster.y, "Instances", obj_arrow);
    
    with (projectile) {
        caster = _caster;
        target = _target;
        damage = _damage;
        
        // Скорость снаряда архимага - средняя
        speed = 12;
        direction = point_direction(x, y, target.x, target.y);
        
        hspeed = lengthdir_x(speed, direction);
        vspeed = lengthdir_y(speed, direction);
        
        gravity = 0;
        arc_height = 0;
        arc_progress = 0;
        arc_speed = 0;
        
        start_x = x;
        start_y = y;
        
        // Визуал - спрайт архимага
        if (sprite_exists(spr_archmage_bolt)) {
            sprite_index = spr_archmage_bolt;
            image_blend = c_white;
        } else if (sprite_exists(spr_fireball)) {
            sprite_index = spr_fireball;
            image_blend = c_fuchsia;
        } else if (sprite_exists(spr_arrow)) {
            sprite_index = spr_arrow;
            image_blend = c_fuchsia;
        }
        
        image_angle = direction;
        
        LOG_CAT("🔮 МАГИЧЕСКИЙ СНАРЯД АРХИМАГА! Урон: " + string(damage) + 
                  ", скорость: " + string(speed), "combat");
    }
    
    return projectile;
}
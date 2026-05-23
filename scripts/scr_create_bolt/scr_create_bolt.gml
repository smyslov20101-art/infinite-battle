/// @function scr_create_bolt(_shooter, _target, _damage)
/// @desc Создает болт/арбалетный снаряд (летит по прямой)

function scr_create_bolt(_shooter, _target, _damage) {
    if (!instance_exists(_shooter) || !instance_exists(_target)) {
        LOG_CAT("❌ ОШИБКА: shooter или target не существует!", "combat");
        return noone;
    }
    
    var projectile = instance_create_layer(_shooter.x, _shooter.y, "Instances", obj_arrow);
    
    with (projectile) {
        shooter = _shooter;
        target = _target;
        damage = _damage;
        
        // ===== ВАЖНО: Устанавливаем hspped и vspeed для движения =====
        speed = 14;
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
        
        // Визуал - болт (spr_bol)
        if (sprite_exists(spr_bol)) {
            sprite_index = spr_bol;
            image_blend = c_white;
        } else if (sprite_exists(spr_arrow)) {
            sprite_index = spr_arrow;
            image_blend = c_white;
        }
        
        // Поворот в сторону движения
        image_angle = direction;
        
        LOG_CAT("🏹 БОЛТ СОЗДАН! Урон: " + string(damage) + 
                  ", скорость: " + string(speed) + 
                  ", направление: " + string(direction), "combat");
    }
    
    return projectile;
}
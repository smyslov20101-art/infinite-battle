function scr_create_fireball(_caster, _target, _damage) {
    LOG_CAT("=== scr_create_fireball ВЫЗВАН ===", "combat");
    LOG_CAT("  caster: " + string(_caster), "combat");
    LOG_CAT("  target: " + string(_target), "combat");
    LOG_CAT("  damage: " + string(_damage), "combat");
    
    if (!instance_exists(_caster) || !instance_exists(_target)) {
        LOG_CAT("❌ ОШИБКА: caster или target не существует!", "combat");
        return noone;
    }
    
    var projectile_speed = 5;
    if (variable_instance_exists(_caster, "projectile_speed")) {
        projectile_speed = _caster.projectile_speed;
    }
    if (variable_instance_exists(_caster, "projectile_speed_bonus") && _caster.projectile_speed_bonus > 0) {
        projectile_speed = projectile_speed * (1 + _caster.projectile_speed_bonus / 100);
    }
    
    var fireball = instance_create_layer(_caster.x, _caster.y, "Instances", obj_fireball);
    
    with (fireball) {
        caster = _caster;
        target = _target;
        damage = _damage;
        speed = projectile_speed;
        start_x = x;
        start_y = y;
        direction = point_direction(x, y, target.x, target.y);
        
        LOG_CAT("🔥 ФАЕРБОЛ СОЗДАН! Урон: " + string(damage) + 
                  ", скорость: " + string(speed) + 
                  ", цель: " + string(target.object_index) + 
                  ", позиция: " + string(x) + "," + string(y), "combat");
    }
    
    return fireball;
}
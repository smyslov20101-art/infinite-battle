/// @function scr_create_enemy_arrow(_shooter, _target, _damage)
/// @desc Создает стрелу врага-лучника с высокой дугой

function scr_create_enemy_arrow(_shooter, _target, _damage) {
    if (!instance_exists(_shooter) || !instance_exists(_target)) return noone;
    
    var arrow = instance_create_layer(_shooter.x, _shooter.y, "Instances", obj_enemy_arrow);
    
    with (arrow) {
        shooter = _shooter;
        target = _target;
        damage = _damage;
        
        // ВЫСОКАЯ ДУГА - особенно для ближней стрельбы!
        // Чем ближе цель, тем выше дуга
        var dist_to_target = point_distance(x, y, target.x, target.y);
        
        if (dist_to_target < 100) {
            // Очень близко - ОЧЕНЬ высокая дуга!
            arc_height = 200;
        } else if (dist_to_target < 180) {
            // Средняя дистанция - высокая дуга
            arc_height = 150;
        } else {
            // Далеко - нормальная дуга
            arc_height = 120;
        }
        
        arc_progress = 0;
        arc_speed = 0.025;
        
        start_x = x;
        start_y = y;
        
        // Визуал
        if (sprite_exists(spr_enemy_arrow)) {
            sprite_index = spr_enemy_arrow;
        } else if (sprite_exists(spr_arrow)) {
            sprite_index = spr_arrow;
            image_blend = c_red; // Красные стрелы врагов
        }
        
        // Отладка
        // LOG("Стрела врага: дуга=" + string(arc_height) + ", дистанция=" + string_format(dist_to_target, 0, 1));
    }
    
    return arrow;
}
/// @function scr_create_arrow(_shooter, _target, _damage)
/// @desc Создает стрелу с высокой дугой и самонаведением

function scr_create_arrow(_shooter, _target, _damage) {
    if (!instance_exists(_shooter) || !instance_exists(_target)) return noone;
    
    var arrow = instance_create_layer(_shooter.x, _shooter.y, "Instances", obj_arrow);
    
    with (arrow) {
        shooter = _shooter;
        target = _target;
        damage = _damage;
        
        // Параметры дуги
        speed = 8;
        arc_height = 150; // Высокая дуга!
        arc_progress = 0;
        arc_speed = 0.025; // Скорость движения по дуге
        
        // Стартовая и конечная точки
        start_x = x;
        start_y = y;
        
        // Сначала цель - текущая позиция врага
        target_x = target.x;
        target_y = target.y;
        
        // Фазы полета
        flight_phase = 0; // 0 = взлет, 1 = наведение, 2 = падение
        
        // Наведение
        homing_strength = 0.2; // Сила наведения (0-1)
        homing_active = false; // Когда включается наведение
        
        // Визуал
        if (sprite_exists(spr_arrow)) {
            sprite_index = spr_arrow;
        }
        
        LOG("Стрела создана с самонаведением!");
    }
    
    return arrow;
}
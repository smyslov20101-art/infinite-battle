function explode_magic_ball(_ball_instance) {
    if (!instance_exists(_ball_instance)) return;
    
    var ball_x = _ball_instance.x;
    var ball_y = _ball_instance.y;
    var damage_amount = _ball_instance.damage;
    
    // Используем ЗОНУ из характеристик шара
    var aoe_min_x = 400;
    var aoe_max_x = 700;
    var aoe_height = room_height;
    
    // Находим ВСЕХ врагов в зоне 400-700 по X
    var enemies_hit = 0;
    
    with (obj_enemy_base) {
        if (alive && hp > 0) {
            // Проверяем попадание в ЗОНУ, а не в радиус круга
            if (x >= aoe_min_x && x <= aoe_max_x) {
                // Враг в зоне - наносим урон
                scr_enemy_take_damage(id, damage_amount);
                enemies_hit++;
                
                // Визуальный эффект (опционально)
               // image_blend = c_purple;
               // alarm[0] = 10;
            }
        }
    }
    
    // Визуальный эффект взрыва (можно добавить позже)
    // instance_create_layer(ball_x, ball_y, "Effects", obj_explosion);
    
    // Отладка
    if (enemies_hit > 0) {
        LOG("Шар взорвался! Зона: " + string(aoe_min_x) + "-" + string(aoe_max_x) + 
                          ", Поражено врагов: " + string(enemies_hit) + 
                          ", Урон: " + string(damage_amount) + " каждому");
    }
}
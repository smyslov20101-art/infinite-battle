/// Create Event - obj_iceberg
depth = -3;  // Поверх всего
alarm[0] = 60;   // Самоуничтожение через 1 секунду (60 кадров при 60 FPS)

// Визуал
if (sprite_exists(spr_iceberg)) {
    sprite_index = spr_iceberg;
    image_alpha = 0.8;
} else {
    // Если нет спрайта, рисуем большой синий круг
    image_blend = c_aqua;
}

// Параметры атаки
damage = 100;
attack_speed_slow = 30;  // Замедление атаки на 30%
slow_duration = 4;        // Длительность 4 секунды
enemies_hit = 0;
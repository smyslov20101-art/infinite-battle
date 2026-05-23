/// Create Event - obj_test_dummy
depth = -1;
// Уникальный ID для манекена
dummy_id = 0; // Будет установлен при создании

// Характеристики манекена
max_hp = 10000;
hp = max_hp;
damage = 50;
attack_speed = 1;
attack_timer = 0;
attack_range = 80;
is_ranged = false;

// Переменные для совместимости с obj_enemy_base
alive = true;
damage_cooldown = 0;
damage_cooldown_max = 0.3;
state = 0;
enemy_type = "test_dummy";
attack_cooldown_max = 1.0;  // Для совместимости с замедлением
original_attack_cooldown = 1.0;
attack_speed_slow_timer = 0;

// Переменные для кровотечения
bleed_stacks = 0;
bleed_timer = 0;
bleed_damage_per_stack = 1;

// Переменные для отладки
debug_bleed_timer = 0;

// Настройки HP бара
show_health_bar = true;
health_bar_width = 200;
health_bar_height = 20;
health_bar_offset_y = -170;

// Визуал
image_blend = c_gray;
image_alpha = 0.8;

// Цвета для разных манекенов (чтобы различать)
if (dummy_id == 1) {
    image_blend = c_gray;
} else if (dummy_id == 2) {
    image_blend = make_color_rgb(150, 150, 100); // Желтоватый оттенок
}

// Отладка
LOG("=== ТЕСТОВЫЙ МАНЕКЕН #" + string(dummy_id) + " СОЗДАН ===");
LOG("HP: " + string(hp) + "/" + string(max_hp));
LOG("Позиция: " + string(x) + "," + string(y));
/// Create Event - obj_test_dummy_back
depth = -1;
// Характеристики манекена
max_hp = 10000;
hp = max_hp;
damage = 1;
attack_speed = 0.2;
attack_timer = 0;
attack_range = 80;
is_ranged = false;

// Переменные для совместимости с obj_enemy_base
alive = true;
damage_cooldown = 0;
damage_cooldown_max = 0.3;
state = 0;
enemy_type = "test_dummy_back";
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
health_bar_offset_y = -180;

// Визуал - желтоватый оттенок для отличия
image_blend = make_color_rgb(200, 180, 100);
image_alpha = 1.0;

// Отладка
LOG("=== ЗАДНИЙ МАНЕКЕН СОЗДАН ===");
LOG("Позиция: " + string(x) + "," + string(y));
LOG("Спрайт: " + string(sprite_index) + ", существует: " + string(sprite_exists(sprite_index)));
LOG("Маска коллизии: " + string(mask_index));
LOG("HP: " + string(hp) + "/" + string(max_hp));
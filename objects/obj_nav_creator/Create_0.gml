/// Create Event - obj_nav_creator.gml
LOG("=== СОЗДАЮ ЭЛЕМЕНТЫ ИНТЕРФЕЙСА ===");

// ============================================================================
// 1. СОЗДАНИЕ ВЕРХНЕЙ ШТОРКИ (только фон)
// ============================================================================
var top_bar = instance_create_layer(room_width/2, 40, "Instances", obj_top_bar);
top_bar.depth = -5;
LOG("Создана верхняя шторка");

// ============================================================================
// 2. СОЗДАНИЕ КНОПКИ ПРОФИЛЯ
// ============================================================================
var profile_btn = instance_create_layer(62, 50, "Instances", obj_profile_button);
profile_btn.depth = -6;
LOG("Создана кнопка профиля");

// ============================================================================
// 3. СОЗДАНИЕ ИКОНКИ ГЕНОВ
// ============================================================================
var genes_icon = instance_create_layer(470, 50, "Instances", obj_genes_icon);
genes_icon.depth = -6;
LOG("Создана иконка генов");

// ============================================================================
// 4. СОЗДАНИЕ ИКОНКИ КРИСТАЛЛОВ
// ============================================================================
var crystals_icon = instance_create_layer(670, 50, "Instances", obj_crystals_icon);
crystals_icon.depth = -6;
LOG("Создана иконка кристаллов");

// ============================================================================
// 5. СОЗДАНИЕ КНОПОК НИЖНЕЙ НАВИГАЦИИ (во всех комнатах)
// ============================================================================
var btn_width = 160;
var btn_height = 190;
var btn_spacing = 0;

var btn_sprites = [spr_desk, spr_events, spr_fight, spr_shop, spr_rating];
var target_rooms = [room_deck, room_floors, room_wave, room_shop, room_rating];

var total_width = 5 * btn_width + 4 * btn_spacing;
var start_x = (room_width - total_width) / 2 + btn_width / 2;
var btn_y = room_height - btn_height / 2;

for (var i = 0; i < 5; i++) {
    var btn_x = start_x + i * (btn_width + btn_spacing);
    
    var btn = instance_create_layer(btn_x, btn_y, "Instances", obj_nav_button);
    btn.btn_sprite = btn_sprites[i];
    btn.target_room = target_rooms[i];
    btn.depth = -10;
    
    LOG("Создана кнопка навигации для комнаты: " + string(target_rooms[i]));
}

// ============================================================================
// 6. КНОПКИ НАГРАД И ЗАДАНИЙ - ТОЛЬКО В КОМНАТЕ room_wave
// ============================================================================
if (room == room_wave) {
    
    // Кнопка НАГРАДЫ
    var rewards_btn = instance_create_layer(70, 100, "Instances", obj_rewards_button);
    rewards_btn.depth = -6;
    LOG("Создана кнопка наград (только в room_wave)");
    
    // Кнопка ЕЖЕДНЕВНЫХ ЗАДАНИЙ
    var daily_btn = instance_create_layer(70, 214, "Instances", obj_daily_quests_button);
    daily_btn.depth = -6;
    LOG("Создана кнопка ежедневных заданий (только в room_wave)");
}

// Уничтожаем себя после создания
instance_destroy();
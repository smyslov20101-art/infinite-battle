// Create Event - obj_tank

// Инициализация через скрипт
tank_init(id);

// Добавить в конце:
hero_id = -1;
hero_class = "";

// Устанавливаем спрайт для щита
if (sprite_exists(spr_shield_icon)) {
    shield_sprite = spr_shield_icon;
}
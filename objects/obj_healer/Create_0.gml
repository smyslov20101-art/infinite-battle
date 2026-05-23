// Create Event - obj_healer

// Инициализация через скрипт
healer_init(id);

// Устанавливаем зеленый цвет
image_blend = c_green;

// Добавить в конце:
hero_id = -1; // Будет установлен при создании
hero_class = ""; // Будет установлен при создании

// ОТЛАДКА УБРАНА - она теперь в create_hero_instance
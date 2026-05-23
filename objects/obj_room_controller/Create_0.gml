// Определяем название и описание комнаты
room_name = "";
room_description = "";
room_start = -1; // Для отслеживания смены комнаты

switch (room) {
    case room_deck:
        room_name = "КОЛОДА";
        room_description = "Выбери 4 героя для битвы";
        break;
        
    case room_wave:
        room_name = "БЕСКОНЕЧНАЯ ВОЛНА";
        room_description = "Защищай базу сколько сможешь";
        break;
        
    case room_floors:
        // МЕНЯЕМ НАЗВАНИЕ
        room_name = "СОБЫТИЯ";
        room_description = "Скоро здесь появятся новые испытания";
        break;
        
   case room_shop:
        room_name = "МАГАЗИН";
        room_description = "Покупай наборы и открывай сундуки";
        break;
        
    case room_rating:
        room_name = "РЕЙТИНГ";
        room_description = "Топ игроков";
        break;
        
    default:
        room_name = "НЕИЗВЕСТНАЯ КОМНАТА";
        room_description = "";
}

LOG("Загружена комната: " + room_name);
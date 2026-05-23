/// @function init_roulette()
/// @desc Заполняет рулетку картами на основе открытых героев

function init_roulette() {
    roulette_cards = [];
    
    LOG("=== ИНИЦИАЛИЗАЦИЯ РУЛЕТКИ ===");
    
    // ПРОВЕРКА: если героев нет - инициализируем
    if (!variable_global_exists("heroes") || array_length(global.heroes) == 0) {
        LOG("ВНИМАНИЕ: global.heroes пуст! Инициализируем...");
        init_hero_manager();
    }
    
    LOG("Всего героев: " + string(array_length(global.heroes)));
    
    // ===== 1. ДОБАВЛЯЕМ КАРТЫ ГЕРОЕВ =====
    var hero_cards_added = 0;
    
    // УБИРАЕМ принудительное открытие всех героев!
    // for (var i = 0; i < array_length(global.heroes); i++) {
    //     global.heroes[i].unlocked = true;
    // }
    
    for (var i = 0; i < array_length(global.heroes); i++) {
        var hero = global.heroes[i];
        
        // Если герой открыт - добавляем его карты
        if (hero.unlocked) {
            var count = 0;
            
            // Определяем количество карт по редкости
            switch (hero.rarity) {
                case 0: count = 4; break;  // Обычный: 4 карты
                case 1: count = 3; break;  // Редкий: 3 карты
                case 2: count = 2; break;  // Эпический: 2 карты
                case 3: count = 1; break;  // Легендарный: 1 карта
            }
            
            LOG("Герой " + hero.name + " (редкость " + string(hero.rarity) + ") добавляет " + string(count) + " карт");
            
            // Добавляем карты героя
            for (var j = 0; j < count; j++) {
                var card = {
                    type: "hero",
                    hero_id: i,
                    name: hero.name,
                    rarity: hero.rarity,
                    color: hero.color_frame,
                    sprite: hero.sprite_small
                };
                array_push(roulette_cards, card);
                hero_cards_added++;
            }
        } else {
            LOG("Герой " + hero.name + " пропущен (заблокирован)");
        }
    }
    
    // ===== 2. ДОБАВЛЯЕМ КАРТЫ С ГЕНАМИ =====
    var gene_rewards = [1000, 2000, 3000, 5000, 10000];
    for (var i = 0; i < 5; i++) {
        var card = {
            type: "genes",
            amount: gene_rewards[i],
            name: string(gene_rewards[i]) + " генов",
            color: make_color_rgb(255, 215, 0)  // Золотой
        };
        array_push(roulette_cards, card);
    }
    
    // ===== 3. ДОБАВЛЯЕМ КАРТЫ С КРИСТАЛЛАМИ =====
    var crystal_rewards = [10, 25, 50];
    for (var i = 0; i < 3; i++) {
        var card = {
            type: "crystals",
            amount: crystal_rewards[i],
            name: string(crystal_rewards[i]) + " кристаллов",
            color: make_color_rgb(100, 200, 255)  // Голубой
        };
        array_push(roulette_cards, card);
    }
    
    LOG("=== РУЛЕТКА ЗАПОЛНЕНА ===");
    LOG("Всего карт: " + string(array_length(roulette_cards)));
    LOG("Карт героев: " + string(hero_cards_added));
    LOG("Карт генов: 5");
    LOG("Карт кристаллов: 3");
    
    // Перемешиваем карты
    shuffle_roulette();
}
/// @function shuffle_roulette()
/// @desc Перемешивает карты в рулетке
function shuffle_roulette() {
    var len = array_length(roulette_cards);
    
    // Простое перемешивание (алгоритм Фишера-Йетса)
    for (var i = len - 1; i > 0; i--) {
        var j = floor(random(i + 1));
        var temp = roulette_cards[i];
        roulette_cards[i] = roulette_cards[j];
        roulette_cards[j] = temp;
    }
    
    LOG("Карты перемешаны");
}
/// @function get_talent_description(_type, _value)
/// @desc Возвращает полное описание таланта

function get_talent_description(_type, _value) {
    switch (_type) {
        case "hp": return "Увеличивает максимальное здоровье героя на " + string(_value) + "%.";
        case "damage": return "Увеличивает урон героя на " + string(_value) + "%.";
        case "armor": return "Добавляет " + string(_value) + " единиц брони. Броня поглощает урон при получении.";
        case "cleave": return "Добавляет " + string(_value) + "% урона по второй цели. Отлично против нескольких врагов.";
        case "attack_speed": return "Увеличивает скорость атаки героя на " + string(_value) + "%.";
        case "move_speed": return "Увеличивает скорость передвижения героя на " + string(_value) + "%.";
        case "crit_chance": return "Увеличивает шанс нанести критический удар на " + string(_value) + "%.";
        case "crit_damage": return "Увеличивает урон критической атаки на " + string(_value) + "%.";
        case "lifesteal": return "Восстанавливает " + string(_value) + "% от нанесённого урона в виде здоровья.";
        case "dodge": return "Даёт " + string(_value) + "% шанс полностью избежать получения урона.";
        case "range": return "Увеличивает дальность атаки на " + string(_value) + " единиц.";
        case "regen": return "Восстанавливает " + string(_value) + " здоровья каждую секунду.";
        case "regen_percent": return "Восстанавливает " + string(_value) + "% от максимального здоровья каждую секунду.";
        case "holy_poison": return "Накладывает отравление на врага. Жертва теряет " + string(_value) + "% от нанесённого урона каждую секунду в течение 3 секунд.";
        case "iceberg": return "Создаёт айсберг над противниками, нанося " + string(_value) + " урона и замедляя скорость атаки на 30% на 4 секунды. Перезарядка 15 секунд.";
        case "curse": return "Проклинает ближайших врагов, увеличивая получаемый ими урон на " + string(_value) + "% на 4 секунды. Перезарядка 15 секунд.";
        case "song_of_soul": return "Увеличивает скорость атаки всех магов в отряде на " + string(_value) + "% на 5 секунд. Перезарядка 15 секунд.";
        case "will_of_chance": return "Увеличивает шанс критической атаки всех магов в отряде на " + string(_value) + "% на 5 секунд. Перезарядка 15 секунд.";
        case "phoenix_feather": return "Раз в 10 секунд дарует перо случайному герою. Перо даёт +" + string(_value) + "% к скорости атаки за каждого убитого врага на 3 секунды.";
        case "dragon_scale": return "Раз в 10 секунд дарует чешую случайному герою. Чешуя даёт +" + string(_value) + "% к урону за каждую минуту игры на 3 секунды.";
        case "mage_buff": return "Увеличивает урон всех магов в отряде на " + string(_value) + "%.";
        case "stun": return "Даёт " + string(_value) + "% шанс оглушить врага при атаке на 2 секунды.";
        case "entangle": return "Даёт " + string(_value) + "% шанс опутать врага лозой, обездвиживая его на 2 секунды.";
        case "hex": return "Даёт " + string(_value) + "% шанс наложить сглаз, увеличивающий получаемый врагом урон на 15% на 3 секунды.";
        default: return "Улучшает характеристики героя.";
    }
}
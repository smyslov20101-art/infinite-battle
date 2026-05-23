/// @function set_hero_target_by_class(_hero_instance)
/// @desc Устанавливает целевую позицию героя в зависимости от его класса или типа

function set_hero_target_by_class(_hero_instance) {
    if (!instance_exists(_hero_instance)) return;
    
    with (_hero_instance) {
        // Если у героя нет hero_id, используем hero_type
        if (!variable_instance_exists(id, "hero_id") || hero_id < 0) {
            // По старому типу (для совместимости)
            switch (hero_type) {
                // Ближники (CLASS_MELEE)
                case "warrior":
                case "tank":
                case "rogue":
                case "berserker":
                case "knight":
                    target_x = 400;
                    target_y = 600;
                    break;
                    
                // Дальники (CLASS_RANGED)
                case "archer":
                case "slinger":
                case "crossbowman":
                case "elf_archer":
                    target_x = 300;
                    target_y = 600;
                    break;
                    
                // Маги (CLASS_MAGE)
                case "mage":
                case "forest_mage":
                case "ice_mage":
                    target_x = 100;
                    target_y = 600;
                    break;
                    
                // Поддержка (CLASS_SUPPORT)
                case "healer":
                case "priest":
                    target_x = 200;
                    target_y = 600;
                    break;
                    
                default:
                    target_x = 400;
                    target_y = 600;
                    LOG_CAT("Неизвестный тип героя: " + hero_type + ", установлена позиция по умолчанию", "hero");
            }
            return;
        }
        
        // По классу из карточки героя
        var hero_data = global.heroes[hero_id];
        var class_type = hero_data.class_type;
        
        switch (class_type) {
            case global.CLASS_MELEE:
                target_x = 400;
                target_y = 600;
                break;
                
            case global.CLASS_RANGED:
                target_x = 300;
                target_y = 600;
                break;
                
            case global.CLASS_MAGE:
                target_x = 100;
                target_y = 600;
                break;
                
            case global.CLASS_SUPPORT:
                target_x = 200;
                target_y = 600;
                break;
                
            default:
                target_x = 400;
                target_y = 600;
                LOG_CAT("Неизвестный класс героя: " + class_type + ", установлена позиция по умолчанию", "hero");
        }
        
        LOG_CAT("Герой " + hero_data.name + " (класс " + class_type + 
                  ") получил целевую позицию: " + string(target_x) + "," + string(target_y), "hero");
    }
}
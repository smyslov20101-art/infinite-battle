/// @function create_hero_instance(_hero_data, _hero_id, _bonus_hp, _bonus_damage)
/// @desc Создает экземпляр героя на поле с возможными бонусами

function create_hero_instance(_hero_data, _hero_id, _bonus_hp = 0, _bonus_damage = 0) {
    LOG_CAT("create_hero_instance ВЫЗВАН для hero_id=" + string(_hero_id) + 
              ", имя=" + _hero_data.name + 
              ", тип=" + _hero_data.original_type, "hero");
    
    var spawn_x = 100;
    var spawn_y = 600;
    var new_hero = noone;
    
    switch (_hero_data.original_type) {
        // ===== ОБЫЧНЫЕ ГЕРОИ =====
        case "warrior":
            new_hero = instance_create_layer(spawn_x, spawn_y, "Instances", obj_hero);
            if (instance_exists(new_hero)) {
                with (new_hero) hero_init(id);
            }
            break;
            
        case "archer":
            new_hero = instance_create_layer(spawn_x, spawn_y, "Instances", obj_archer);
            if (instance_exists(new_hero)) {
                with (new_hero) archer_init(id);
            }
            break;
            
        case "mage":
            new_hero = instance_create_layer(spawn_x, spawn_y, "Instances", obj_mage);
            if (instance_exists(new_hero)) {
                with (new_hero) mage_init(id);
            }
            break;
            
        case "healer":
            new_hero = instance_create_layer(spawn_x, spawn_y, "Instances", obj_healer);
            if (instance_exists(new_hero)) {
                with (new_hero) healer_init(id);
            }
            break;
            
        case "tank":
            new_hero = instance_create_layer(spawn_x, spawn_y, "Instances", obj_tank);
            if (instance_exists(new_hero)) {
                with (new_hero) tank_init(id);
            }
            break;
            
        case "rogue":
            new_hero = instance_create_layer(spawn_x, spawn_y, "Instances", obj_rogue);
            if (instance_exists(new_hero)) {
                with (new_hero) rogue_init(id);
            }
            break;
            
        case "slinger":
            new_hero = instance_create_layer(spawn_x, spawn_y, "Instances", obj_slinger);
            if (instance_exists(new_hero)) {
                with (new_hero) slinger_init(id);
            }
            break;
            
        case "forest_mage":
            new_hero = instance_create_layer(spawn_x, spawn_y, "Instances", obj_forest_mage);
            if (instance_exists(new_hero)) {
                with (new_hero) forest_mage_init(id);
            }
            break;
            
        // ===== РЕДКИЕ ГЕРОИ =====
        case "knight":
            new_hero = instance_create_layer(spawn_x, spawn_y, "Instances", obj_knight);
            if (instance_exists(new_hero)) {
                with (new_hero) knight_init(id);
            }
            break;
            
        case "crossbowman":
            new_hero = instance_create_layer(spawn_x, spawn_y, "Instances", obj_crossbowman);
            if (instance_exists(new_hero)) {
                with (new_hero) crossbowman_init(id);
            }
            break;
            
        case "ice_mage":
            new_hero = instance_create_layer(spawn_x, spawn_y, "Instances", obj_ice_mage);
            if (instance_exists(new_hero)) {
                with (new_hero) ice_mage_init(id);
            }
            break;
            
        case "priest":
            new_hero = instance_create_layer(spawn_x, spawn_y, "Instances", obj_priest);
            if (instance_exists(new_hero)) {
                with (new_hero) priest_init(id);
            }
            break;
            
        case "berserker":
            new_hero = instance_create_layer(spawn_x, spawn_y, "Instances", obj_berserker);
            if (instance_exists(new_hero)) {
                with (new_hero) berserker_init(id);
            }
            break;
            
        case "elf_archer":
            new_hero = instance_create_layer(spawn_x, spawn_y, "Instances", obj_elf_archer);
            if (instance_exists(new_hero)) {
                with (new_hero) elf_archer_init(id);
            }
            break;
            
        // ===== ЭПИЧЕСКИЕ ГЕРОИ =====
        case "shadow_blade":
            new_hero = instance_create_layer(spawn_x, spawn_y, "Instances", obj_shadow_blade);
            if (instance_exists(new_hero)) {
                with (new_hero) shadow_blade_init(id);
            }
            break;
            
        case "sniper":
            new_hero = instance_create_layer(spawn_x, spawn_y, "Instances", obj_sniper);
            if (instance_exists(new_hero)) {
                with (new_hero) sniper_init(id);
            }
            break;
            
        case "lightning_mage":
            new_hero = instance_create_layer(spawn_x, spawn_y, "Instances", obj_lightning_mage);
            if (instance_exists(new_hero)) {
                with (new_hero) lightning_mage_init(id);
            }
            break;
            
        case "druid":
            new_hero = instance_create_layer(spawn_x, spawn_y, "Instances", obj_druid);
            if (instance_exists(new_hero)) {
                with (new_hero) druid_init(id);
            }
            break;
            
        // ===== ЛЕГЕНДАРНЫЕ ГЕРОИ =====
        case "paladin":
            new_hero = instance_create_layer(spawn_x, spawn_y, "Instances", obj_paladin);
            if (instance_exists(new_hero)) {
                with (new_hero) paladin_init(id);
            }
            break;
            
        case "archmage":
            new_hero = instance_create_layer(spawn_x, spawn_y, "Instances", obj_archmage);
            if (instance_exists(new_hero)) {
                with (new_hero) archmage_init(id);
            }
            break;
            
        default:
            LOG_CAT("НЕИЗВЕСТНЫЙ ТИП ГЕРОЯ: " + _hero_data.original_type, "hero");
            return noone;
    }
    
    // Настраиваем нового героя, если он создан
    if (instance_exists(new_hero)) {
        with (new_hero) {
            hero_id = _hero_id;
            hero_class = _hero_data.class_type;
            hero_type = _hero_data.original_type;
            
            // Получаем уровень из дерева прокачки
            var controller = instance_find(obj_game_controller, 0);
            var tree_upgrades_count = 0;
            
            if (instance_exists(controller)) {
                for (var i = 0; i < 4; i++) {
                    var tree = controller.hero_trees[i];
                    if (tree != noone && tree.hero_id == _hero_id) {
                        tree_upgrades_count = array_length(tree.chosen_upgrades);
                        LOG_CAT("Найдено дерево для героя, выбранных улучшений: " + string(tree_upgrades_count), "hero");
                        break;
                    }
                }
            }
            
            hero_level = 1 + tree_upgrades_count;
            
            var base_hp = _hero_data.get_current_hp();
            var base_damage = _hero_data.get_current_damage();
            
            hp = base_hp * (1 + _bonus_hp);
            max_hp = hp;
            damage = base_damage * (1 + _bonus_damage);
            
            bonus_hp_multiplier = 1 + _bonus_hp;
            bonus_damage_multiplier = 1 + _bonus_damage;
            
            set_hero_target_by_class(id);
            is_main_hero = true;
            
            LOG_CAT("Герой создан: " + _hero_data.name + 
                      ", hero_id=" + string(hero_id) + 
                      ", hero_class=" + hero_class +
                      ", hero_level=" + string(hero_level) +
                      ", выбранных улучшений=" + string(tree_upgrades_count) +
                      ", HP=" + string(floor(hp)) + 
                      ", Урон=" + string(floor(damage)), "hero");
        }
    } else {
        LOG_CAT("НЕ УДАЛОСЬ СОЗДАТЬ ГЕРОЯ типа " + _hero_data.original_type, "hero");
    }
    
    return new_hero;
}
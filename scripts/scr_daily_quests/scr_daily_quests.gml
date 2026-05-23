/// ============================================================================
/// scr_daily_quests.gml
/// Система ежедневных заданий
/// ============================================================================

/// @function init_daily_quests()
/// @desc Инициализирует ежедневные задания, если их нет
function init_daily_quests() {
    if (!variable_global_exists("permanent_save")) return;
    if (!struct_exists(global.permanent_save, "daily_quests")) {
        global.permanent_save.daily_quests = {
            last_reset_time: 0,
            quest_list: []
        };
    }
    
    // Если массив заданий пуст или не соответствует количеству
    if (array_length(global.permanent_save.daily_quests.quest_list) != 3) {
        global.permanent_save.daily_quests.quest_list = [
            {
                id: 0,
                quest_type: "ads",
                target: 3,
                current_progress: 0,
                is_completed: false,
                is_claimed: false,
                reward_type: "crystals",
                reward_amount: 5,
                desc: "Посмотреть 3 рекламы",
                progress_text: "просмотрено"
            },
            {
                id: 1,
                quest_type: "kills",
                target: 100,
                current_progress: 0,
                is_completed: false,
                is_claimed: false,
                reward_type: "genes",
                reward_amount: 1000,
                desc: "Убить 100 врагов",
                progress_text: "убито"
            },
            {
                id: 2,
                quest_type: "survival",
                target: 900,
                current_progress: 0,
                is_completed: false,
                is_claimed: false,
                reward_type: "crystals",
                reward_amount: 5,
                desc: "Выжить 15 минут в бесконечной волне",
                progress_text: "секунд"
            }
        ];
        LOG("Созданы дефолтные задания");
    }
    
    // Проверяем, нужно ли сбросить задания
    check_daily_quests_reset();
}

/// @function check_daily_quests_reset()
/// @desc Проверяет, прошло ли 24 часа с последнего сброса
function check_daily_quests_reset() {
    if (!variable_global_exists("permanent_save")) return;
    
    // Используем системное время через date_current_datetime()
    var base_date = date_create_datetime(2024, 1, 1, 0, 0, 0);
    var now_sec = date_second_span(date_current_datetime(), base_date);
    var last_reset_sec = global.permanent_save.daily_quests.last_reset_time;
    
    LOG("check_daily_quests_reset: now_sec=" + string(now_sec) + ", last_reset_sec=" + string(last_reset_sec));
    
    // Если сброс ещё не производился (last_reset_sec == 0)
    if (last_reset_sec == 0) {
        // Просто устанавливаем текущее время, НЕ сбрасываем задания
        global.permanent_save.daily_quests.last_reset_time = now_sec;
        save_permanent_to_file();
        LOG("Установлен last_reset_time = " + string(now_sec));
        return;
    }
    
    // Если прошло 24 часа — сбрасываем задания
    if ((now_sec - last_reset_sec) >= 86400) {
        reset_daily_quests();
        global.permanent_save.daily_quests.last_reset_time = now_sec;
        save_permanent_to_file();
        LOG("=== ЕЖЕДНЕВНЫЕ ЗАДАНИЯ СБРОШЕНЫ ===");
    }
}

/// @function reset_daily_quests()
/// @desc Сбрасывает прогресс всех заданий
function reset_daily_quests() {
    if (!variable_global_exists("permanent_save")) return;
    
    var q_list = global.permanent_save.daily_quests.quest_list;
    for (var i = 0; i < array_length(q_list); i++) {
        q_list[i].current_progress = 0;
        q_list[i].is_completed = false;
        q_list[i].is_claimed = false;
    }
    LOG("Прогресс всех заданий сброшен");
}

/// @function update_quest_progress(_type, _amount)
/// @desc Обновляет прогресс задания
function update_quest_progress(_type, _amount) {
    if (!variable_global_exists("permanent_save")) return;
    
    var q_list = global.permanent_save.daily_quests.quest_list;
    var updated = false;
    
    for (var i = 0; i < array_length(q_list); i++) {
        var q_item = q_list[i];
        if (q_item.quest_type == _type && !q_item.is_completed && !q_item.is_claimed) {
            q_item.current_progress += _amount;
            if (q_item.current_progress >= q_item.target) {
                q_item.current_progress = q_item.target;
                q_item.is_completed = true;
                LOG("✅ ЗАДАНИЕ ВЫПОЛНЕНО: " + q_item.desc);
            }
            updated = true;
            LOG("Обновлён прогресс: " + _type + " = " + string(q_item.current_progress) + "/" + string(q_item.target));
        }
    }
    
    if (updated) {
        save_permanent_to_file();
    }
}

/// @function claim_quest_reward(_quest_id)
/// @desc Выдаёт награду за выполненное задание
function claim_quest_reward(_quest_id) {
    if (!variable_global_exists("permanent_save")) return false;
    
    var q_list = global.permanent_save.daily_quests.quest_list;
    if (_quest_id < 0 || _quest_id >= array_length(q_list)) return false;
    
    var q_item = q_list[_quest_id];
    
    if (!q_item.is_completed || q_item.is_claimed) return false;
    
    // Выдаём награду
    if (q_item.reward_type == "genes") {
        scr_cheat_add_genes(q_item.reward_amount);
    } else if (q_item.reward_type == "crystals") {
        scr_cheat_add_crystals(q_item.reward_amount);
    }
    
    q_item.is_claimed = true;
    save_permanent_to_file();
    
    LOG("🎁 НАГРАДА ПОЛУЧЕНА: " + q_item.desc + 
                      " (+" + string(q_item.reward_amount) + " " + q_item.reward_type + ")");
    
    return true;
}

/// @function get_quest_progress_text(_quest_id)
/// @desc Возвращает прогресс задания в виде строки
function get_quest_progress_text(_quest_id) {
    if (!variable_global_exists("permanent_save")) return "";
    
    var q_list = global.permanent_save.daily_quests.quest_list;
    if (_quest_id < 0 || _quest_id >= array_length(q_list)) return "";
    
    var q_item = q_list[_quest_id];
    
    if (q_item.is_claimed) {
        return "ПОЛУЧЕНО";
    } else if (q_item.is_completed) {
        return "ГОТОВО К ПОЛУЧЕНИЮ!";
    } else {
        return string(q_item.current_progress) + "/" + string(q_item.target) + " " + q_item.progress_text;
    }
}

/// @function is_quest_available_for_claim(_quest_id)
/// @desc Проверяет, можно ли получить награду
function is_quest_available_for_claim(_quest_id) {
    if (!variable_global_exists("permanent_save")) return false;
    
    var q_list = global.permanent_save.daily_quests.quest_list;
    if (_quest_id < 0 || _quest_id >= array_length(q_list)) return false;
    
    var q_item = q_list[_quest_id];
    return (q_item.is_completed && !q_item.is_claimed);
}

/// @function debug_reset_daily_quests()
/// @desc Принудительно сбрасывает задания (для тестирования)
function debug_reset_daily_quests() {
    reset_daily_quests();
    if (variable_global_exists("permanent_save")) {
        var base_date = date_create_datetime(2024, 1, 1, 0, 0, 0);
        global.permanent_save.daily_quests.last_reset_time = date_second_span(date_current_datetime(), base_date);
        save_permanent_to_file();
    }
    LOG("=== ПРИНУДИТЕЛЬНЫЙ СБРОС ЗАДАНИЙ ===");
}
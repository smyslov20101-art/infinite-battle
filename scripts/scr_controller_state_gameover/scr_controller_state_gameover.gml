/// @function scr_controller_state_gameover(_controller_instance)
/// @desc Обработка состояния КОНЦА ИГРЫ

function scr_controller_state_gameover(_controller_instance) {
    if (!instance_exists(_controller_instance)) return;
    
    with (_controller_instance) {
        game_over_timer += 1 / room_speed;
        
        var window_width = 500;
        var window_height = 550;
        var window_x = (room_width - window_width) / 2;
        var window_y = (room_height - window_height) / 2;
        
        var btn_width = 180;
        var btn_height = 50;
        var btn_x = window_x + (window_width - btn_width) / 2;
        var btn_y = window_y + window_height - 80;
        
        if (mouse_check_button_pressed(mb_left)) {
            if (mouse_x >= btn_x && mouse_x <= btn_x + btn_width &&
                mouse_y >= btn_y && mouse_y <= btn_y + btn_height) {
                
                LOG("=== ПОЛУЧЕНИЕ НАГРАД ===");
                
                // 1. Начисляем гены сразу
                if (wave_genes > 0) {
                    global.genes += wave_genes;
                    if (variable_global_exists("current_session")) {
                        global.current_session.genes = global.genes;
                    }
                    LOG("  ✅ + " + string(wave_genes) + " генов");
                }
                
                // 2. Начисляем кристаллы сразу
                if (wave_crystals > 0) {
                    global.crystals += wave_crystals;
                    LOG("  ✅ + " + string(wave_crystals) + " кристаллов");
                }
                
                // 3. Сохраняем сундуки в глобальные награды
                if (array_length(wave_chests) > 0) {
                    LOG("  📦 Получено сундуков:");
                    for (var i = 0; i < array_length(wave_chests); i++) {
                        var new_chest = wave_chests[i];
                        var found = false;
                        
                        for (var j = 0; j < array_length(global.wave_rewards.chests); j++) {
                            if (global.wave_rewards.chests[j].rarity == new_chest.rarity) {
                                global.wave_rewards.chests[j].count += new_chest.count;
                                found = true;
                                LOG("    - редкость " + string(new_chest.rarity) + 
                                                  " x" + string(new_chest.count) + 
                                                  " (теперь всего " + string(global.wave_rewards.chests[j].count) + ")");
                                break;
                            }
                        }
                        
                        if (!found) {
                            array_push(global.wave_rewards.chests, {
                                rarity: new_chest.rarity,
                                count: new_chest.count
                            });
                            LOG("    - новый тип: редкость " + string(new_chest.rarity) + 
                                              " x" + string(new_chest.count));
                        }
                    }
                }
                
                // ===== ДОБАВЛЯЕМ РЕЗУЛЬТАТ В РЕЙТИНГ ТОЛЬКО ДЛЯ БЕСКОНЕЧНОЙ ВОЛНЫ =====
                if (!floor_mode && game_time > 0) {
                    var player_name = global.player_name;
                    
                    // Добавляем в рейтинг
                    if (variable_global_exists("add_rating_result")) {
                        add_rating_result(player_name, game_time);
                        LOG("  📊 Результат добавлен в рейтинг: " + player_name + 
                                          " - " + string(game_time) + " сек");
                    }
                    
                    // ===== ОБНОВЛЯЕМ СТАТИСТИКУ ИГРОКА =====
                    if (variable_global_exists("permanent_save")) {
                        // Убеждаемся, что структура player_stats существует
                        if (!struct_exists(global.permanent_save, "player_stats")) {
                            global.permanent_save.player_stats = {
                                best_time: 0,
                                total_kills: 0,
                                games_played: 0
                            };
                        }
                        
                        // Обновляем лучшее время
                        if (game_time > global.permanent_save.player_stats.best_time) {
                            global.permanent_save.player_stats.best_time = game_time;
                            LOG("  🏆 НОВЫЙ РЕКОРД! " + string(game_time) + " сек");
                        }
                        
                        // Обновляем количество убийств
                        global.permanent_save.player_stats.total_kills += enemies_killed;
                        
                        // Обновляем количество игр
                        global.permanent_save.player_stats.games_played += 1;
                        
                        LOG("  📊 Статистика обновлена:");
                        LOG("    Убито врагов: " + string(global.permanent_save.player_stats.total_kills));
                        LOG("    Сыграно игр: " + string(global.permanent_save.player_stats.games_played));
                        
                        // Сохраняем изменения
                        save_permanent_to_file();
                    }
                } else if (floor_mode) {
                    LOG("  🏁 Режим этажа - результат не добавляется в рейтинг");
                    // В режиме этажа окно завершения показывается сразу при убийстве босса
                    // или при достижении времени конца этажа, поэтому здесь ничего не делаем
                }
                
                // ===== СБРАСЫВАЕМ РЕЖИМ ЭТАЖА ПЕРЕД ВОЗВРАТОМ =====
                if (floor_mode) {
                    floor_mode = false;
                    // Не сбрасываем global.current_floor, он может понадобиться для окна завершения
                }
                
                // Сохраняем награды
                save_wave_rewards();
                
                // Сохраняем все данные
                save_all_data();
                
                LOG("=== ВОЗВРАТ В ГЛАВНОЕ МЕНЮ ===");
                room_goto(room_wave);
            }
        }
    }
}
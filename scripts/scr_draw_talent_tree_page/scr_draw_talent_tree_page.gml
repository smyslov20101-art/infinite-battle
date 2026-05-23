/// @function draw_talent_tree_page(_tree, _win_x, _win_y, _win_width, _start_level, _levels_count)
/// @desc Рисует страницу дерева талантов (5 уровней) как ГОТОВЫЙ PNG из Figma.
///       Сам фон уже содержит все ветки, узлы и иконки — поверх рисуем только подсветку
///       выбранных талантов. Координаты узлов нужны для определения клика (в Step попапа).
///       Спрайты лежат в datafiles/talent_tree/<hero_type>/page1.png + page2.png.

// ===== ЛЕНИВАЯ ЗАГРУЗКА СПРАЙТОВ (по hero_type, с кэшем) =====
/// @function tt_ensure_loaded(_hero_type)
/// @desc Загружает page1+page2 для указанного hero_type один раз и кэширует.
///       Если файлов для героя ещё нет — fallback на warrior (на время разработки).
/// @returns {Struct} { page1, page2 }
function tt_ensure_loaded(_hero_type) {
    if (!variable_global_exists("tt_pages_cache")) {
        global.tt_pages_cache = {};
    }

    // Уже грузили этого героя?
    if (variable_struct_exists(global.tt_pages_cache, _hero_type)) {
        return variable_struct_get(global.tt_pages_cache, _hero_type);
    }

    var folder = "talent_tree/" + _hero_type + "/";
    var path1 = folder + "page1.png";
    var path2 = folder + "page2.png";

    // Если файлов для этого героя нет — fallback на warrior
    if (!file_exists(path1) || !file_exists(path2)) {
        LOG("=== ДТ: файлы для '" + _hero_type + "' не найдены, fallback на warrior ===");
        if (_hero_type != "warrior") {
            var fallback = tt_ensure_loaded("warrior");
            // Закэшируем тот же результат под этим hero_type, чтобы не бить file_exists каждый кадр
            variable_struct_set(global.tt_pages_cache, _hero_type, fallback);
            return fallback;
        }
        // warrior сам не нашёлся — это уже фатальная ошибка ассетов
        LOG("=== ДТ-ОШИБКА: даже warrior page1/page2 отсутствуют в datafiles/talent_tree/warrior/ ===");
        var dummy = { page1: -1, page2: -1 };
        variable_struct_set(global.tt_pages_cache, _hero_type, dummy);
        return dummy;
    }

    var pages = {
        page1: sprite_add(path1, 1, false, false, 0, 0),
        page2: sprite_add(path2, 1, false, false, 0, 0)
    };

    variable_struct_set(global.tt_pages_cache, _hero_type, pages);
    LOG("=== ДТ-СПРАЙТЫ ЗАГРУЖЕНЫ для '" + _hero_type + "' (page1+page2) ===");
    return pages;
}

function draw_talent_tree_page(_tree, _win_x, _win_y, _win_width, _start_level, _levels_count) {
    if (_tree == noone) return;

    // hero_type из дерева (заполняется при создании в obj_talent_tree_window)
    var hero_type = variable_struct_exists(_tree, "hero_type") ? _tree.hero_type : "warrior";
    var pages = tt_ensure_loaded(hero_type);

    // ===== ФОН СТРАНИЦЫ (готовое изображение из Figma 800×800) =====
    var bg_size = 800;
    var bg_x = _win_x + (_win_width - bg_size) / 2;
    var bg_y = _win_y + 50; // 50px сверху на заголовок «ДЕРЕВО ТАЛАНТОВ» + имя героя

    var is_page2 = (_start_level >= 5);
    var page_spr = is_page2 ? pages.page2 : pages.page1;

    if (page_spr != -1) {
        draw_set_alpha(1.0);
        draw_set_color(c_white);
        draw_sprite_stretched(page_spr, 0, bg_x, bg_y, bg_size, bg_size);
    }

    // ===== КООРДИНАТЫ ЦЕНТРОВ УЗЛОВ внутри фона (взяты из Figma) =====
    // i=0 → Ур.1 (низ), i=4 → Ур.5 (верх) — «снизу вверх», как растёт дерево
    var node_positions = [
        [[246, 543], [554, 543]], // ур.1 (низ)
        [[187, 439], [611, 439]], // ур.2
        [[192, 327], [606, 327]], // ур.3
        [[232, 222], [568, 221]], // ур.4
        [[310, 137], [487, 137]]  // ур.5 (верх)
    ];
    var node_radius = 37; // радиус кружка-слота для хит-теста и обводки

    var max_levels = array_length(_tree.upgrades);

    for (var i = 0; i < _levels_count; i++) {
        var level = _start_level + i;
        if (level >= max_levels) break;

        // Какие стороны выбраны на этом уровне
        var left_chosen = false;
        var right_chosen = false;
        for (var u = 0; u < array_length(_tree.chosen_upgrades); u++) {
            if (_tree.chosen_upgrades[u].level == level) {
                if (variable_struct_exists(_tree.chosen_upgrades[u], "side")) {
                    if (_tree.chosen_upgrades[u].side == "left")  left_chosen  = true;
                    if (_tree.chosen_upgrades[u].side == "right") right_chosen = true;
                } else {
                    var ut = _tree.chosen_upgrades[u].type;
                    if (ut == "hp" || ut == "armor" || ut == "attack_speed" || ut == "range") {
                        left_chosen = true;
                    } else {
                        right_chosen = true;
                    }
                }
            }
        }

        // ===== ЛЕВЫЙ УЗЕЛ =====
        if (array_length(_tree.upgrades[level]) > 0) {
            var lx = bg_x + node_positions[i][0][0];
            var ly = bg_y + node_positions[i][0][1];

            // Сохраняем координаты для Step (проверка клика)
            _tree.upgrades[level][0].x = lx;
            _tree.upgrades[level][0].y = ly;

            if (left_chosen) {
                // Зелёная двойная обводка выбранного узла
                draw_set_alpha(1.0);
                draw_set_color(c_lime);
                draw_circle(lx, ly, node_radius + 2, true);
                draw_circle(lx, ly, node_radius + 3, true);
            }
        }

        // ===== ПРАВЫЙ УЗЕЛ =====
        if (array_length(_tree.upgrades[level]) > 1) {
            var rx = bg_x + node_positions[i][1][0];
            var ry = bg_y + node_positions[i][1][1];

            _tree.upgrades[level][1].x = rx;
            _tree.upgrades[level][1].y = ry;

            if (right_chosen) {
                draw_set_alpha(1.0);
                draw_set_color(c_lime);
                draw_circle(rx, ry, node_radius + 2, true);
                draw_circle(rx, ry, node_radius + 3, true);
            }
        }
    }

    // Сброс
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

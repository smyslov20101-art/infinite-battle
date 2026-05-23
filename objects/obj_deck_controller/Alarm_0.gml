/// Alarm 0 Event - obj_deck_controller
if (global.pending_hero_id >= 0 && !instance_exists(obj_talent_tree_window)) {
    var tree_window = instance_create_layer(0, 0, "Instances", obj_talent_tree_window);
    tree_window.hero_id = global.pending_hero_id;
    global.pending_hero_id = -1;
}
global.tree_window_opening = false;
function enemy_die(_enemy_instance) {
    if (!instance_exists(_enemy_instance)) return;
    
    var controller = instance_find(obj_game_controller, 0);
    if (!instance_exists(controller)) {
        instance_destroy(_enemy_instance);
        return;
    }
    
    // ДОБАВЬ ЭТО:
    LOG("=== enemy_die START ===");
    LOG("  _enemy_instance.coin_reward = " + string(_enemy_instance.coin_reward));
    
    var reward_genes = floor(_enemy_instance.reward);
    var reward_coins = floor(_enemy_instance.coin_reward);
    
    LOG("  reward_genes = " + string(reward_genes));
    LOG("  reward_coins = " + string(reward_coins));
    
    controller.session_genes += reward_genes;
    controller.wave_genes += reward_genes;
    controller.coins += reward_coins;
    
    LOG("=== ВРАГ УБИТ ===");
    LOG("  Тип: " + string(_enemy_instance.enemy_type));
    LOG("  + " + string(reward_genes) + " генов");
    LOG("  + " + string(reward_coins) + " монет");
    LOG("  Всего монет: " + string(controller.coins));
    LOG("==================");
    
    controller.enemies_killed++;
	update_quest_progress("kills", 1);
    controller.current_enemies_on_field--;
    
    instance_destroy(_enemy_instance);
}
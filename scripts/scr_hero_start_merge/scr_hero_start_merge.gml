function hero_start_merge(_hero_instance, _target_hero) {
    // ПРОСТО начинаем слияние без проверок!
    if (!instance_exists(_hero_instance) || !instance_exists(_target_hero)) {
        return false;
    }
    
    with (_hero_instance) {
        merge_target = _target_hero;
        state = STATE_MERGING;
        LOG("Начато принудительное слияние!");
    }
    
    return true;
}
/// Alarm 1 Event - obj_archer

if (instance_exists(second_shot_target)) {
    // Создаем вторую стрелу
    scr_create_arrow(id, second_shot_target, second_shot_damage);
    LOG_CAT("🏹 Второй выстрел!", "combat");
}

second_shot_target = noone;
second_shot_damage = 0;
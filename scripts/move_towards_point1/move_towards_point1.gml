/// @function move_towards_point(_current, _target, _speed)
/// @desc Плавное движение к точке
/// @param _current {number} Текущая координата
/// @param _target {number} Целевая координата  
/// @param _speed {number} Скорость движения
/// @return {number} Новая координата

function move_towards_point(_current, _target, _speed) {
    if (_speed <= 0) return _current;
    
    var diff = _target - _current;
    var distance = abs(diff);
    
    if (distance <= _speed) {
        return _target; // Достигли цели
    } else {
        return _current + (diff / distance) * _speed; // Двигаемся к цели
    }
}
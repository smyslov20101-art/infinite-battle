/// @function is_array(_var)
/// @desc Проверяет, является ли переменная массивом
/// @param _var {any} Переменная для проверки
/// @return {bool} true если это массив, false если нет

function is_array(_var) {
    return variable_type(_var) == "array";
}
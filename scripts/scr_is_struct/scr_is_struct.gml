/// @function is_struct(_var)
/// @desc Проверяет, является ли переменная структурой
/// @param _var {any} Переменная для проверки
/// @return {bool} true если это структура, false если нет

function is_struct(_var) {
    return variable_type(_var) == "struct";
}
/// @function string_split_into_lines(_text, _max_width)
/// @desc Разбивает текст на строки по ширине
function string_split_into_lines(_text, _max_width) {
    var result = [];
    var words = string_split(_text, " ");
    var current_line = "";
    
    for (var i = 0; i < array_length(words); i++) {
        var test_line = current_line;
        if (string_length(current_line) > 0) {
            test_line += " ";
        }
        test_line += words[i];
        
        if (string_width(test_line) > _max_width) {
            array_push(result, current_line);
            current_line = words[i];
        } else {
            current_line = test_line;
        }
    }
    
    if (string_length(current_line) > 0) {
        array_push(result, current_line);
    }
    
    return result;
}

/// @function string_split(_str, _delimiter)
/// @desc Разбивает строку на массив по разделителю
function string_split(_str, _delimiter) {
    var result = [];
    var pos = 0;
    var delim_len = string_length(_delimiter);
    
    while (true) {
        var next_pos = string_pos(_delimiter, string_copy(_str, pos + 1, string_length(_str) - pos));
        if (next_pos == 0) {
            array_push(result, string_copy(_str, pos + 1, string_length(_str) - pos));
            break;
        }
        array_push(result, string_copy(_str, pos + 1, next_pos - 1));
        pos += next_pos + delim_len - 1;
    }
    
    return result;
}
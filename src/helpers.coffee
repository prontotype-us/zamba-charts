add = (a, b) -> a + b

sum = (numbers) ->
    numbers.reduce add, 0

empty_padding = {
    left: 0
    right: 0
    top: 0
    bottom: 0
}

exports.transformPadding = (padding=0) ->
    if typeof padding == 'number'
        padding = {left: padding, right: padding, top: padding, bottom: padding}

    padding = Object.assign {}, empty_padding, padding


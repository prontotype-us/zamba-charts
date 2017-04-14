d3 = require 'd3'

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

exports.interpretColor = (color, value) ->
    if typeof color == 'string'
        return color
    else if typeof color == 'function'
        value = value.id or value._id or value.name or value.key or value
        return color(value)
    else
        return '#999'


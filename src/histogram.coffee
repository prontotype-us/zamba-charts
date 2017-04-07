React = require 'react'
d3 = require 'd3'
StackedBarChart = require './stacked-bar'
helpers = require './helpers'

EPSILON = 0.001

get = (key, from) ->
    if typeof key == 'function'
        key(from)
    else
        from[key]

sortBy = (key, list) ->
    list.sort (a, b) ->
        if get(key, a) > get(key, b)
            return 1
        else if get(key, a) < get(key, b)
            return -1
        else
            return 0

groupBy = (key, list) ->
    grouped = {}
    sortBy key, list
    for item in list
        value = get key, item
        grouped[value] ||= []
        grouped[value].push item
    return grouped

module.exports = Histogram = React.createClass
    getDefaultProps: ->
        width: 100
        height: 100
        padding: 0
        x_axis: {}
        y_axis: {}

    binData: ->
        {data, bin_key, min, max, n_bins, bin_size, group_key} = @props

        x_extent = d3.extent data, (d) -> d.x

        if min?
            x_extent[0] = min
        else
            min = x_extent[0]
        if max?
            x_extent[1] = max
        else
            max = x_extent[1]

        if bin_size?
            n_bins = Math.ceil((max - min) / bin_size)
        else
            n_bins ||= 10
            bin_size = (max - min) / (n_bins)

        pointInRange = (min, max) -> (d) ->
            if bin_key?
                point = d[bin_key]
            else
                point = d
            (point.x >= min) and (point.x < max)

        bins = [0...n_bins].map (bi) ->
            b_min = min + (bi * bin_size)
            b_max = min + ((bi + 1) * bin_size)
            in_this_bin = data.filter pointInRange b_min, b_max
            grouped = groupBy group_key, in_this_bin

            return {
                x0: b_min
                x: b_min
                x1: b_max
                grouped
            }

        # Include right edge
        in_edge_bin = data.filter pointInRange max, max + EPSILON
        grouped = groupBy group_key, in_edge_bin
        for group_value, group of grouped
            for item in group
                bins[n_bins - 1].grouped[group_value] ||= []
                bins[n_bins - 1].grouped[group_value].push item

        return [bins, x_extent, n_bins]

    render: ->
        {width, height, padding, data, x, y, r, axis_size, title, x_axis, y_axis, color, onClick} = @props

        padding = helpers.transformPadding padding
        [bins, x_extent, n_bins] = @binData()

        data_by_group = {}
        y_max = 0

        # Ys and Y total on bins
        for bin in bins
            total = 0
            for group_value, group of bin.grouped
                data_by_group[group_value] ||= []
                group.y0 = total
                group.y = group.length
                group.y1 = group.y0 + group.y
                total += group.y
                data_by_group[group_value].push {
                    x: bin.x
                    x0: bin.x0
                    x1: bin.x1
                    y0: group.y0
                    y1: group.y1
                }
            if total > y_max
                y_max = total

        datas = []
        for group_value, data of data_by_group
            data.key = group_value
            datas.push data

        x_axis.ticks ||= n_bins

        x = d3.scaleLinear()
            .domain(x_extent)
            .range([padding.left, width - padding.right])

        y = d3.scaleLinear()
            .domain([0, y_max])
            .range([height - padding.bottom, padding.top])

        <StackedBarChart {...@props} data=bins x=x y=y bar_width={(width - padding.left - padding.right) / (n_bins) - 1} />


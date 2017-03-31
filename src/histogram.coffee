d3 = require 'd3'
React = require 'react'
BarChart = require './bar'
Chart = require './chart'
{transformPadding} = require './helpers'

EPSILON = 0.001

module.exports = Histogram = React.createClass
    getDefaultProps: ->
        width: 100
        height: 100
        padding: 0

    binData: ->
        {data, bin_key, min, max, n_bins, bin_size} = @props

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

            return {
                x: b_min
                y: in_this_bin.length
            }

        # Include right edge
        edge_data = data.filter pointInRange max, max + EPSILON
        bins[n_bins - 1].y += edge_data.length

        return [bins, x_extent, n_bins]

    render: ->
        {width, height, padding, data, x, y, axis_size, title} = @props

        padding = transformPadding padding
        [bins, x_extent, n_bins] = @binData()

        x = d3.scaleLinear()
            .domain(x_extent)
            .range([padding.left, width - padding.right])

        y = d3.scaleLinear()
            .domain([0, d3.max(bins, (d) -> d.y)])
            .range([height - padding.bottom, padding.top])

        <Chart data=bins x=x y=y width=width height=height padding=padding x_axis={ticks: n_bins}>
            <BarChart bar_width={(width - padding.left - padding.right) / (n_bins) - 2} />
        </Chart>


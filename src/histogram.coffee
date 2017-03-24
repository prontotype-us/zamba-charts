d3 = require 'd3'
React = require 'react'
BarChart = require './bar'
Chart = require './chart'

module.exports = Histogram = React.createClass

    binData: ->
        {data, bin_key, min, max, n_bins, bin_size} = @props
        values = data.map (d) -> d.value || d
        if !@props.min?
            min = Math.min(values...)
        if !@props.max?
            max = Math.max(values...)

        if bin_size?
            n_bins = Math.ceil((max - min) / bin_size)
        else
            n_bins ||= 10
            bin_size = (max - min) / n_bins

        bins = [0..n_bins].map (t) ->
            s_min = min + (t * bin_size)
            s_max = min + ((t + 1) * bin_size) - 1
            in_this_bin = values.filter (s) ->
                if bin_key?
                    val = s[bin_key]
                else
                    val = s
                (val < s_max) && (val > s_min)

            return {
                x: (s_max + s_min) / 2
                y: in_this_bin.length
            }

        return bins

    render: ->

        {width, height, data, x, y, axis_size, min, max, n_bins, title, bin_size} = @props

        bins = @binData()
        values = data.map (d) -> d.value || d

        if !@props.min?
            min = Math.min(values...)
        if !@props.max?
            max = Math.max(values...)

        x = d3.scaleLinear()
            .domain([min, max])
            .range([0, width])
        y = d3.scaleLinear()
            .domain([0, d3.max(bins, (d) -> d.y)])
            .range([height, 0])

        <Chart width=width height=height data=bins title=title axis_size=axis_size >
            <BarChart
                axis_size=axis_size
                x=x
                y=y />
        </Chart>

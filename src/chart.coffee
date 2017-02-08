React = require 'react'
d3 = require 'd3'
{XAxis, YAxis} = require './axes'

module.exports = Chart = React.createClass
    getDefaultProps: ->
        padding: 20

    render: ->
        {width, height, data, title, children, adjust, padding} = @props

        width -= (padding * 2)
        height -= padding

        x_extent = d3.extent(data, (d) -> d.x)
        if adjust
            x_extent[0] -= 0.5
            x_extent[1] += 0.5
        y_extent = d3.extent(data, (d) -> d.y)
        if false
            y_extent = [0, d3.max(data, (d) -> d.y)]

        x = d3.scaleLinear()
            .range([0, width])
            .domain(x_extent)
        y = d3.scaleLinear()
            .range([height, 0])
            .domain(y_extent)

        <div className='chart' style={position: 'relative', padding: padding}>
            {React.cloneElement children, {width, height, data, x, y}}
            <XAxis x=x width=width height=padding />
            <YAxis y=y width=padding height=height />
        </div>


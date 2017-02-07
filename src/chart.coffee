React = require 'react'
d3 = require 'd3'

padding = 20

XAxis = React.createClass
    render: ->
        {width, height, x} = @props

        <svg className='axis x-axis' style={{width, height, position: 'absolute', bottom: 0, left: padding}}>
            {x.ticks(width / 40).map (t) ->
                <text x={x(t)} y={height - 6} textAnchor='middle'>{t}</text>
            }
        </svg>

YAxis = React.createClass
    render: ->
        {width, height, y} = @props

        <svg className='axis y-axis' style={{width, height, position: 'absolute', left: 0, top: padding}}>
            {y.ticks(height / 20).map (t) ->
                <text y={y(t) + 6} x={width/2} textAnchor='middle'>{t}</text>
            }
        </svg>

module.exports = Chart = React.createClass
    render: ->
        {width, height, data, title, children, adjust} = @props

        width -= (padding * 2)
        height -= padding

        x_extent = d3.extent(data, (d) -> d.x)
        if adjust
            x_extent[0] -= 0.5
            x_extent[1] += 0.5

        x = d3.scaleLinear()
            .domain(x_extent)
            .range([0, width])
        y = d3.scaleLinear()
            .domain([0, d3.max(data, (d) -> d.y)])
            .range([height, 0])

        <div className='chart' style={position: 'relative', padding: padding}>
            {React.cloneElement children, {width, height, data, x, y}}
            <XAxis x=x width=width height=padding />
            <YAxis y=y width=padding height=height />
        </div>


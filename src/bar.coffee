React = require 'react'
d3 = require 'd3'

module.exports = BarChart = React.createClass
    getDefaultProps: ->
        color: '#000'

    render: ->
        {width, height, data, x, y} = @props

        x_extent = d3.extent(data, (d) -> d.x)
        bar_width = Math.floor(width / data.length - 1)
        # x_extent[1] += 1

        x ||= d3.scaleLinear()
            .domain(x_extent)
            .range([0, width])
        y ||= d3.scaleLinear()
            .domain([0, d3.max(data, (d) -> d.y)])
            .range([height, 0])

        <svg style={{width, height}}>
            {data.map (d, di) =>
                <rect 
                    key=di
                    x={x(d.x) - bar_width/2}
                    y={y(d.y)}
                    width={bar_width}
                    height={height - y(d.y)}
                    fill=@props.color
                />
            }
        </svg>


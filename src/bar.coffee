React = require 'react'
d3 = require 'd3'
helpers = require './helpers'

module.exports = BarChart = React.createClass
    getDefaultProps: ->
        color: d3.scaleOrdinal d3.schemeCategory10

    shouldComponentUpdate: (next_props, next_state) ->
        if next_props.data.length != @props.data.length
            return true
        else if (next_props.width != @props.width) or (next_props.height != @props.height)
            return true
        else if (next_props.y != @props.y) or (next_props.x != @props.x)
            return true
        else
            return false

    render: ->
        {width, height, padding, data, x, y, bar_width, adjust, color, onClick} = @props
        x_extent = d3.extent(data, (d) -> d.x)
        bar_width ||= width / (data.length + 1)
        x_extent[1] += bar_width
        bar_gap = 0

        x ||= d3.scaleLinear()
            .domain(x_extent)
            .range([0, width])
        y ||= d3.scaleLinear()
            .domain([0, d3.max(data, (d) -> d.y)])
            .range([height, 0])

        <svg className='bar-chart' style={{width, height, position: 'absolute', top: 0}}>
            {data.map (d, di) =>
                console.log 'd', d
                last_y = y(d.y0 or y.domain()[0])
                this_y = y(d.y1 or d.y)
                this_x = x(d.x)
                <rect 
                    onClick={onClick?.bind(null, d)}
                    key=di
                    x={this_x}
                    y={this_y}
                    width={bar_width}
                    height={last_y - this_y}
                    fill={helpers.interpretColor(color)}
                />
            }
        </svg>


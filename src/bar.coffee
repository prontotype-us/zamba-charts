React = require 'react'
d3 = require 'd3'
helpers = require './helpers'
Chart = require './chart'

module.exports = BarChart = React.createClass
    mixins: [Chart]

    xDomain: ->
        x_extent = d3.extent(@props.data, (d) -> d.x)
        x_extent[1] += 1
        return x_extent

    renderChart: ->
        {width, height, padding, data, bar_width, adjust, color, onClick} = @props
        {x, y} = @state
        bar_width ||= width / (data.length) - 1
        bar_gap = 0

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


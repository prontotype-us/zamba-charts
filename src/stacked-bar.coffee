React = require 'react'
d3 = require 'd3'
Chart = require './chart'
helpers = require './helpers'

module.exports = class StackedBarChart extends Chart
    multi: true

    renderChart: ->
        {width, height, padding, data, x, y, r, bar_width, color, onClick} = @props
        x_extent = d3.extent(data, (d) -> d.x)
        bar_width ||= Math.floor(width / data.length - 1)
        bar_gap = 0
        r ||= 0

        <svg className='bar-chart' style={{width, height, position: 'absolute', top: 0}}>
            {data.map (d, di) =>
                <g transform="translate(#{x(d.x)})" onClick={onClick?.bind(null, d)}>
                    {
                        for group_value, group of d.grouped
                            last_y = y(group.y0)
                            this_y = y(group.y1)

                            <rect key=group_value
                                y={this_y + bar_gap}
                                rx=r
                                ry=r
                                width={bar_width}
                                height={last_y - this_y - bar_gap}
                                fill={helpers.interpretColor(color, group_value)}
                            />
                    }
                </g>
            }
        </svg>


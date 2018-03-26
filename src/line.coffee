React = require 'preact'
d3 = require 'd3'
Chart = require './chart'
helpers = require './helpers'

module.exports = class LineChart extends Chart

    renderChart: ->
        {width, height, data, curve, fill, color} = @props
        {x, y} = @state
        console.log '[LineChart.render] data=', data

        line = d3.line()
            .curve if curve then d3.curveMonotoneX else d3.curveLinear
            .x (d) -> x(d.x)
            .y (d) -> y(d.y)

        d = line data

        <svg className='line-chart' style={{width, height, position: 'absolute', top: 0}}>
            {if fill
                first_point = {x: x.domain()[0], y: y.domain()[0]}
                last_point = {x: x.domain()[1], y: y.domain()[0]}
                da = line [first_point].concat(data).concat([last_point])
                <path 
                    d=da
                    fill={helpers.interpretColor(color, 0)}
                    opacity=0.2
                    stroke='none'
                />
            }
            <path 
                d=d
                fill='none'
                stroke={helpers.interpretColor(color, 0)}
                strokeWidth=2
            />
        </svg>


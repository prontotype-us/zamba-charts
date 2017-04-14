React = require 'react'
d3 = require 'd3'
Chart = require './chart'
helpers = require './helpers'

module.exports = MultiLineChart = React.createClass
    mixins: [Chart]

    multi: true

    renderChart: ->
        {width, height, data, curve, fill, color} = @props
        {x, y} = @state
        console.log '[MultiLineChart.render] data=', data

        line = d3.line()
            .curve if curve then d3.curveMonotoneX else d3.curveLinear
            .x (d) -> x(d.x)
            .y (d) -> y(d.y)

        <svg className='line-chart' style={{width, height, position: 'absolute', top: 0}}>
            {data.map (data, di) ->
                d = line data
                <g key=di>
                    {if fill
                        first_point = {x: x.domain()[0], y: y.domain()[0]}
                        last_point = {x: x.domain()[1], y: y.domain()[0]}
                        da = line [first_point].concat(data).concat([last_point])
                        <path
                            d=da
                            fill={helpers.interpretColor(color, data)}
                            opacity=0.2
                            stroke='none'
                        />
                    }
                    <path
                        d=d
                        fill='none'
                        stroke={helpers.interpretColor(color, data)}
                        strokeWidth=2
                    />
                </g>
            }
        </svg>


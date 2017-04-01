React = require 'react'
d3 = require 'd3'
helpers = require './helpers'

module.exports = LineChart = React.createClass
    getDefaultProps: ->
        curve: true
        fill: false

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
        {width, height, data, x, y, curve, fill, color} = @props
        console.log '[LineChart.render] data=', data

        x_extent = d3.extent(data, (d) -> d.x)
        y_extent = d3.extent(data, (d) -> d.y)

        x ||= d3.scaleLinear()
            .domain(x_extent)
            .range([0, width])
        y ||= d3.scaleLinear()
            .domain(y_extent)
            .range([height, 0])

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
                    fill={helpers.interpretColor(color)}
                    opacity=0.2
                    stroke='none'
                />
            }
            <path 
                d=d
                fill='none'
                stroke={helpers.interpretColor(color)}
                strokeWidth=2
            />
        </svg>


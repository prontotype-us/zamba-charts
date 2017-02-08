React = require 'react'
d3 = require 'd3'

module.exports = LineChart = React.createClass
    getDefaultProps: ->
        color: '#000'
        curve: true
        fill: true

    render: ->
        {width, height, data, x, y, curve, fill} = @props

        x ||= d3.scaleLinear()
            .domain(d3.extent(data, (d) -> d.x))
            .range([0, width])
        y ||= d3.scaleLinear()
            .domain([0, d3.max(data, (d) -> d.y)])
            .range([height, 0])

        line = d3.line()
            .curve if curve then d3.curveMonotoneX else d3.curveLinear
            .x (d) -> x(d.x)
            .y (d) -> y(d.y)

        d = line data

        <svg className='line-chart' style={{width, height}}>
            {if fill
                da = line data
                <path 
                    d=da
                    fill=@props.color
                    opacity=0.2
                    stroke='none'
                />
            }
            <path 
                d=d
                fill='none'
                stroke=@props.color
                strokeWidth=2
            />
        </svg>


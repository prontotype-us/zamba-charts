React = require 'react'
d3 = require 'd3'

ChartMixin = require './common'

module.exports = ScatterChart = React.createClass
    mixins: [ChartMixin]
    getDefaultProps: ->
        color: '#000'
        curve: true
        fill: true

    render: ->
        {width, height, data, x, y, axis_size} = @props
        x_extent = d3.extent(data, (d) -> d.x)
        y_extent = d3.extent(data, (d) -> d.y)
        x ||= d3.scaleLinear()
            .domain(x_extent)
            .range([0, width])
        y ||= d3.scaleLinear()
            .domain([0, y_extent])
            .range([height, 0])

        <svg className='scatter-chart' style={{width, height}}>
            {data.map (d, i) =>
                if renderPoint = @props?.options?.renderPoint
                    renderPoint d, {x, y}, i
                else
                    <circle className='dot' r=3 key=i
                        cx=x(d.x)
                        cy=y(d.y)
                        fill={d.color}
                    />
            }
        </svg>

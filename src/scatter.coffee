React = require 'react'
d3 = require 'd3'
Chart = require './chart'
helpers = require './helpers'

module.exports = ScatterChart = React.createClass
    mixins: [Chart]

    renderChart: ->
        {width, height, data, color, r} = @props
        {x, y} = @state
        r ||= 4

        <svg className='scatter-chart' style={{width, height, position: 'absolute'}}>
            {data.map (d, i) =>
                if renderPoint = @props?.options?.renderPoint
                    renderPoint d, {x, y}, i
                else
                    <circle className='dot' key=i
                        r=r
                        cx=x(d.x)
                        cy=y(d.y)
                        fill={helpers.interpretColor color, d}
                        onClick={onClick?.bind(null, data[di])}
                    />
            }
        </svg>

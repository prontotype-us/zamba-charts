React = require 'preact'
d3 = require 'd3'
Chart = require './chart-preact'

module.exports = class LabeledBarChart extends Chart

    renderChart: ->
        # This is built off bins rather than coordinates
        {width, height, data, x, y, options, axis_size} = @props
        if options?
            {bar_padding, bar_width} = options
        num_bars = data.length
        bar_padding ||= 10

        x_extent = d3.extent([0, width])
        cell_width = Math.floor(width / num_bars - 1)

        y ||= d3.scaleLinear()
            .domain([0, d3.max(data, (d) -> d.y)])
            .range([height, 0])

        <svg className='bar-chart' style={{width, height, position: 'absolute'}}>
            {data.map (d, di) =>
                <rect 
                    key=di
                    x={cell_width*(di)}
                    y={y(d.y)}
                    width={bar_width || (cell_width - bar_padding)}
                    height={height - y(d.y)}
                    fill={d.color || @props.color}
                    onClick={onClick?.bind(null, data[di])}
                />
            }
        </svg>

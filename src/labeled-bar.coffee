React = require 'preact'
d3 = require 'd3'
Chart = require './chart'

module.exports = class LabeledBarChart extends Chart

    renderChart: ->
        # This is built off bins rather than coordinates
        {width, height, data, x, y, options, axis_size} = @props
        {x, y} = @state
        if options?
            {bar_padding, bar_width, horizontal} = options
        num_bars = data.length
        bar_padding ||= 10

        x_extent = d3.extent([0, width])
        cell_width = Math.floor(width / num_bars - 1)

        y ||= d3.scaleLinear()
            .domain([0, d3.max(data, (d) -> d.y)])
            .range([height, 0])

        chart_height = height + 2 * 25
        <svg className='bar-chart' style={{width, height: chart_height, position: 'absolute'}} height=chart_height width=width>
            {data.map (d, di) =>
                <g className='bar'>
                    {d.label?.split(' ').map (l, i_label) ->
                        label_width = 6.5 * l.length
                        label_x = cell_width * (di + 0.5) - label_width / 2
                        label_y = height + bar_padding + (15*(i_label+1))
                        # label_x = cell_width * cell_index
                        if horizontal
                            # TODO: improve label positioning
                            label_y_tmp = label_y
                            label_x_tmp = label_x
                            label_x = label_y
                            label_y = label_x_tmp
                        <text className='label' y=label_y x=label_x width={cell_width} >{l}</text>}
                    <rect 
                        key=di
                        x={cell_width*(di + 0.5) - bar_width / 2}
                        y={y(d.y)}
                        width={bar_width || (cell_width - bar_padding)}
                        height={height - y(d.y)}
                        fill={d.color || @props.color}
                        onClick={onClick?.bind(null, data[di])}
                    />
                </g>
            }
        </svg>

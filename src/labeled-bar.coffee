React = require 'preact'
d3 = require 'd3'
Chart = require './chart'

module.exports = class LabeledBarChart extends Chart
    chartHeight: ->
        max_label_length = 
        if rotate = @props.x_axis?.rotate
            max_label_length = 0
            @props.data.forEach (d) ->
                if d?.label?.length > max_label_length
                    max_label_length = d.label.length
            label_height = max_label_length * 6 * Math.sin(Math.PI * Math.abs(rotate) / 180)
        else
            label_height = 8
        height = @props.height + (@props.el_padding || 0) + 15 + label_height
        return height

    renderChart: ->
        # This is built off bins rather than coordinates
        {width, height, data, x, y, options, axis_size} = @props
        {x, y} = @state
        if options?
            {bar_padding, bar_width, horizontal} = options
        num_bars = data.length
        bar_padding ||= 10
        rotate_labels = @props.x_axis?.rotate

        x_extent = d3.extent([0, width])
        cell_width = Math.floor(width / num_bars - 1)

        y ||= d3.scaleLinear()
            .domain([0, d3.max(data, (d) -> d.y)])
            .range([height, 0])

        chart_height = height + 2 * 25
        <svg className='bar-chart' style={{width, height: chart_height, position: 'absolute'}} height=chart_height width=width>
            {data.map (d, di) =>
                <g className='bar'>
                    {
                        l = d.label
                        label_width = 6.5 * l.length
                        label_height = 8
                        label_x = cell_width * (di + 0.5)
                        label_y = height + bar_padding + 15
                        if rotate_labels > 0
                            text_anchor = 'start'
                        else if rotate_labels < 0
                            text_anchor = 'end'
                        else
                            text_anchor = 'middle'
                        if horizontal
                            # TODO: improve label positioning
                            label_y_tmp = label_y
                            label_x_tmp = label_x
                            label_x = label_y
                            label_y = label_x_tmp
                        <text className='label' y=label_y x=label_x width={cell_width} text-anchor=text_anchor transform="rotate(#{rotate_labels},#{label_x},#{label_y})" >{l}</text>
                    }
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

React = require 'react'
d3 = require 'd3'
Chart = require './chart'

add = (a, b) -> a + b

sum = (numbers) ->
    numbers.reduce add, 0

module.exports = LabeledMultiBarChart = React.createClass
    mixins: [Chart]

    renderChart: ->
        {width, height, data, x, y, colors, options, colorer} = @props
        {bar_padding, bar_width, spread, horizontal} = options
        bar_padding ||= 10
        if !spread
            num_bars = data.length
            x_extent = d3.extent([0, width])
            cell_width = Math.floor(width / num_bars - 1)
            total_ys = data.map (d) -> sum(Object.keys(d.values).map (k) -> d.values[k])
            y_extent = Math.max(total_ys...)
            y = d3.scaleLinear()
                .domain([0, y_extent])
                .range([0, height])

            total_x = -1

            <svg className='bar-chart' style={{width, height}}>
                {data.map (d, i_data) =>
                    total_x++
                    total_y = 0
                    <g className='bar' key=i_data >
                        {d.label?.split(' ').map (l, i_label) ->
                            label_y = height + (15*(i_label+1))
                            label_x = cell_width * total_x
                            if horizontal
                                # TODO: improve label positioning
                                label_y_tmp = label_y
                                label_x_tmp = label_x
                                label_x = label_y
                                label_y = label_x_tmp
                            <text className='label' y=label_y x=label_x width={cell_width} >{l}</text>}
                        {Object.keys(d.values).map (segment_key) ->
                            value = d.values[segment_key]
                            total_y = total_y + value
                            segment_color = colorer?(segment_key) || d.color || @props.colors[segment_key]

                            y_pos = height - y(total_y)
                            x_pos = cell_width*(total_x)
                            segment_width = bar_width || (cell_width - bar_padding)
                            segment_height = y(value)

                            if horizontal
                                tmp = {}
                                tmp.height = segment_height
                                tmp.y_pos = y_pos
                                segment_height = segment_width
                                segment_width = tmp.height
                                y_pos = x_pos
                                x_pos = tmp.y_pos

                            <rect 
                                key={i_data + '.' + segment_key}
                                y=y_pos
                                x=x_pos
                                width=segment_width
                                height=segment_height
                                fill={segment_color}
                            />
                        }
                    </g>
                }
            </svg>

        else
            num_bars = 0
            y_max = 0
            bar_padding ||= 1
            all_ys = data.map (d) ->
                Object.keys(d.values).map (k) ->
                    num_bars++;
                    value = d.values[k]
                    if y_max < value
                        y_max = value

                    return value
            num_bars += (data.length-1)
            x_extent = d3.extent([0, width])
            cell_width = Math.floor(width / num_bars - 1)

            y = d3.scaleLinear()
                .domain([0, y_max])
                .range([0, height])

            total_x = -1
            # Height for labels
            chart_height = height + 4 * bar_padding
            <svg className='bar-chart' style={{width, height: chart_height}}>
                {data.map (d, i_data) =>
                    total_y = 0
                    total_x++
                    <g className='bar' key=i_data >
                        {d.label?.split(' ').map (l, i_label) ->
                            label_x = cell_width * total_x
                            label_y = height + bar_padding + (15*(i_label+1))
                            if horizontal
                                # TODO: improve label positioning
                                label_y_tmp = label_y
                                label_x_tmp = label_x
                                label_x = label_y
                                label_y = label_x_tmp
                            <text className='label' y=label_y x=label_x width={cell_width} >{l}</text>}
                        {Object.keys(d.values).map (segment_key) ->
                            value = d.values[segment_key]
                            total_y = total_y + value
                            segment_color = colorer?(segment_key) || d.color || colors?[segment_key] || "#333"
                            x_pos = cell_width * total_x
                            y_pos = height - y(value)
                            segment_width = bar_width || (cell_width - bar_padding)
                            segment_height = y(value)

                            if horizontal
                                tmp = {}
                                tmp.height = segment_height
                                tmp.y_pos = y_pos
                                segment_height = segment_width
                                segment_width = tmp.height
                                y_pos = x_pos
                                x_pos = tmp.y_pos

                            total_x++
                            <rect 
                                key={i_data + '.' + segment_key}
                                y=y_pos
                                x=x_pos
                                width=segment_width
                                height=segment_height
                                fill={segment_color}
                            />
                        }
                    </g>
                }
            </svg>

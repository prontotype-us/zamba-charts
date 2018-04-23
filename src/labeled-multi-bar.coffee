React = require 'preact'
d3 = require 'd3'
Chart = require './chart'

add = (a, b) -> a + b

sum = (numbers) ->
    numbers.reduce add, 0

EL_PADDING = 10

module.exports = class LabeledMultiBarChart extends Chart

    renderChart: ->
        {width, height, data, x, y, colors, options, markers, colorer} = @props
        {bar_padding, bar_width, spread, horizontal, el_padding} = options
        bar_padding ||= 10
        el_padding ||= EL_PADDING
        if !spread
            num_bars = data.length
            x_extent = d3.extent([0, width])
            cell_width = Math.floor(width / num_bars - 1)
            total_ys = data.map (d) -> sum(Object.keys(d.values).map (k) -> d.values[k])
            y_extent = Math.max(total_ys...)
            y = d3.scaleLinear()
                .domain([0, y_extent])
                .range([0, height])

            cell_index = -1
            # Height for labels
            chart_height = height + 4 * bar_padding
            <svg className='bar-chart' style={{width, height: chart_height}} width=width height=chart_height>
                {data.map (d, i_data) =>
                    cell_index++
                    total_y = 0
                    <g className='bar' key=i_data>
                        {d.label?.split(' ').map (l, i_label) ->
                            label_width = 6.5 * l.length
                            label_x = cell_width * (i_data + 0.5) - label_width / 2
                            label_y = height + el_padding + (15*(i_label+1))
                            # label_x = cell_width * cell_index
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
                            segment_width = bar_width || (cell_width - bar_padding)
                            segment_height = y(value)

                            left_padding = (cell_width - segment_width) / 2
                            y_pos = height - y(total_y)
                            x_pos = left_padding + cell_width*(cell_index)

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
            markers.forEach (marker) ->
                if y_max < marker.value
                    y_max = marker.value
            num_bars += (data.length-1)
            x_extent = d3.extent([0, width])
            cell_width = Math.floor(width / num_bars - 1)

            y = d3.scaleLinear()
                .domain([0, y_max])
                .range([0, height])
            cell_index = -1
            # Height for labels
            chart_height = height + 4 * bar_padding
            segment_width = bar_width || (cell_width - bar_padding)
            <svg
                className='bar-chart'
                style={{width, height: chart_height}}
                transform="translate(#{-1*cell_width/2},0)"
            >
                {data.map (d, i_data) =>
                    total_y = 0
                    cell_index++
                    cell_markers = markers?.filter (m) ->
                        m.cell_key == d.cell_key
                    family_width = cell_width * (Object.keys(d.values).length + 1)
                    <g className='bar' key=i_data >
                        {d.label?.split(' ').map (l, i_label) ->
                            label_width = 6 * l.length
                            label_x = family_width * (i_data + 0.5) - label_width / 2
                            label_y = height + el_padding + (15*(i_label+1))
                            if horizontal
                                label_y_tmp = label_y
                                label_x_tmp = label_x
                                label_x = label_y
                                label_y = label_x_tmp
                            <text className='label' y=label_y x=label_x width={cell_width} >{l}</text>}
                        {Object.keys(d.values).map (segment_key) ->
                            value = d.values[segment_key]
                            total_y = total_y + value
                            segment_color = colorer?(segment_key) || d.color || colors?[segment_key] || "#333"
                            segment_height = y(value)
                            left_padding = (cell_width + (cell_width-segment_width)) / 2
                            x_pos = left_padding + cell_width * cell_index
                            y_pos = height - y(value)

                            if horizontal
                                tmp = {}
                                tmp.height = segment_height
                                tmp.y_pos = y_pos
                                segment_height = segment_width
                                segment_width = tmp.height
                                y_pos = x_pos
                                x_pos = tmp.y_pos

                            cell_index++
                            <rect 
                                key={i_data + '.' + segment_key}
                                y=y_pos
                                x=x_pos
                                width=segment_width
                                height=segment_height
                                fill={segment_color}
                            >
                                <title>{value}</title>
                            </rect>
                        }
                        {cell_markers?.map (marker, i) ->
                            if marker.kind == 'diamond'
                                symbol_generator = d3.symbol().type(d3.symbolDiamond).size(80)
                                <path className='dot' key=i
                                    d={symbol_generator()}
                                    transform="translate(#{family_width * (i_data + 0.5)},#{y(y_max - marker.value)})"
                                    fill={colors?[marker.series_key] || "#333"}
                                >
                                    <title>{marker.value}</title>
                                </path>
                            else
                                <circle className='dot' key=i
                                    r=4
                                    cx={cell_width * (cell_index - 0.5)}
                                    cy=y(marker.value)
                                    fill={colors?[marker.series_key] || "#333"}
                                >
                                    <title>{marker.value}</title>
                                </circle>
                        }
                    </g>
                }
            </svg>

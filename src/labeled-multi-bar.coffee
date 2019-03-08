React = require 'react'
d3 = require 'd3'
Chart = require './chart'

add = (a, b) -> a + b

sum = (numbers) ->
    numbers.reduce add, 0

EL_PADDING = 10

module.exports = class LabeledMultiBarChart extends Chart
    chartHeight: ->
        if rotate = @props.x_axis?.rotate
            max_label_length = 0
            @props.data.forEach (d) ->
                if d?.label?.length > max_label_length
                    max_label_length = d.label.length
            label_height = max_label_length * 6.5 * Math.sin(Math.PI * Math.abs(rotate) / 180)
        else
            label_height = 8
        height = @props.height + (@props?.options?.el_padding || 0) + 15 + label_height
        return height

    renderChart: ->
        {width, height, data, x, y, colors, options, markers, colorer} = @props
        {x, y} = @state
        {bar_padding, bar_width, spread, horizontal, el_padding} = options
        bar_padding ||= 10
        el_padding ||= EL_PADDING
        rotate_labels = @props.x_axis?.rotate

        if !spread
            num_bars = data.length
            x_extent = d3.extent([0, width])
            if horizontal
                cell_width = Math.floor(height / num_bars - 1)
            else
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
                        {
                            l = d.label
                            # TODO: (if necessary): more sophisticated label splitter
                            # based off cell_width
                            label_height = 8
                            label_x = cell_width * (i_data + 0.5)
                            label_y = height + 15 + el_padding
                            if rotate_labels > 0
                                # If rotated clockwise, center label tip at center of cell
                                text_anchor = 'start'
                                label_x -= label_height / 2
                            else if rotate_labels < 0
                                # If rotated counterclockwise, center label tip at center of cell
                                text_anchor = 'end'
                                label_x += label_height / 2
                            else
                                text_anchor = 'middle'

                            if horizontal
                                # TODO: improve label positioning
                                label_y_tmp = label_y
                                label_x_tmp = label_x
                                label_x = 0
                                label_y = label_x_tmp
                            <text className='label' y=label_y x=label_x text-anchor=text_anchor width={cell_width} transform="rotate(#{rotate_labels},#{label_x},#{label_y})">{l}</text>
                        }
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
                                # x_pos = tmp.y_pos
                                x_pos = y(total_y) - segment_width

                            renderBar = ->
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

                            if options.display_values? && value > 0
                                offset_left = options.display_values.offset_left || 0
                                offset_top = options.display_values.offset_top || 3
                                if offset_left > 0
                                    text_anchor = 'left'
                                    label_x = x_pos + offset_left
                                else
                                    text_anchor = 'middle'
                                    label_x = x_pos + segment_width/2
                                <g x=x_pos y=y_pos style={height: segment_height,width: segment_width} >
                                    {renderBar()}
                                    <text
                                        className='value-label'
                                        text-anchor=text_anchor
                                        alignment-baseline='hanging'
                                        x=label_x
                                        y={y_pos+offset_top}
                                    >
                                        {if options.display_values?.display
                                            options.display_values?.display value
                                        else
                                            value
                                        }
                                    </text>
                                </g>
                            else
                                renderBar()
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
            if horizontal
                cell_width = Math.floor(height / num_bars - 1)
            else
                cell_width = Math.floor(width / num_bars - 1)

            if @props.y_axis.domain?
                y_max = @props.y_axis.domain[1]

            y = d3.scaleLinear()
                .domain([0, y_max])
                .range([0, height])
            cell_index = -1
            # Height for labels
            chart_height = height + 4 * bar_padding
            <svg
                className='bar-chart'
                style={{width, height: chart_height}}
                width=width height=chart_height
            >
                {data.map (d, i_data) =>
                    total_y = 0
                    cell_index++
                    cell_markers = markers?.filter (m) ->
                        m.cell_key == d.cell_key
                    family_width = cell_width * (Object.keys(d.values).length + 1)
                    <g className='bar' key=i_data >
                        {
                            l = d.label
                            label_height = 8
                            # Center label in cell
                            label_x = family_width * (i_data + 0.5) - cell_width / 2
                            label_y = height + 15 + el_padding
                            if rotate_labels > 0
                                text_anchor = 'start'
                                label_x -= label_height / 2
                            else if rotate_labels < 0
                                text_anchor = 'end'
                                label_x += label_height / 2
                            else
                                text_anchor = 'middle'
                            if horizontal
                                label_y_tmp = label_y
                                label_x_tmp = label_x
                                # label_x = label_y
                                label_x = 0
                                label_y = label_x_tmp
                            <text className='label' y=label_y x=label_x text-anchor=text_anchor width={cell_width} transform="rotate(#{rotate_labels},#{label_x},#{label_y})">{l}</text>
                        }
                        {Object.keys(d.values).map (segment_key) ->
                            value = d.values[segment_key]
                            total_y = total_y + value
                            segment_width = bar_width || (cell_width - bar_padding)
                            segment_color = colorer?(segment_key) || d.color || colors?[segment_key] || "#333"
                            segment_height = y(value)
                            left_padding = (cell_width + (cell_width-segment_width)) / 2
                            x_pos = left_padding + cell_width * cell_index - cell_width / 2
                            y_pos = height - y(value)

                            if horizontal
                                tmp = {}
                                tmp.height = segment_height
                                tmp.y_pos = y_pos
                                segment_height = segment_width
                                segment_width = tmp.height
                                y_pos = x_pos
                                # x_pos = tmp.y_pos
                                x_pos = 0

                            cell_index++

                            renderBar = ->
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

                            if options.display_values? && value > 0
                                offset_left = options.display_values.offset_left || 0
                                offset_top = options.display_values.offset_top || 3
                                if offset_left > 0
                                    text_anchor = 'left'
                                    label_x = x_pos + offset_left
                                else
                                    text_anchor = 'middle'
                                    label_x = x_pos + segment_width/2
                                <g x=x_pos y=y_pos style={height: segment_height,width: segment_width} >
                                    {renderBar()}
                                    <text
                                        className='value-label'
                                        text-anchor=text_anchor
                                        alignment-baseline='hanging'
                                        x=label_x
                                        y={y_pos+offset_top}
                                    >
                                        {if options.display_values?.display
                                            options.display_values?.display value
                                        else
                                            value
                                        }
                                    </text>
                                </g>
                            else
                                renderBar()
                        }
                        {cell_markers?.map (marker, i) ->
                            if marker.kind == 'diamond'
                                symbol_generator = d3.symbol().type(d3.symbolDiamond).size(80)
                                <path className='dot' key=i
                                    d={symbol_generator()}
                                    transform="translate(#{family_width * (i_data + 0.5) - cell_width / 2},#{y(y_max - marker.value)})"
                                    fill={colors?[marker.series_key] || "#333"}
                                >
                                    <title>{marker.value}</title>
                                </path>
                            else
                                <circle className='dot' key=i
                                    r=4
                                    cx={cell_width * (cell_index - 0.5) - cell_width / 2}
                                    cy=y(marker.value)
                                    fill={colors?[marker.series_key] || "#333"}
                                >
                                    <title>{marker.value}</title>
                                </circle>
                        }
                    </g>
                }
            </svg>

React = require 'react'
d3 = require 'd3'
Chart = require './chart'

add = (a, b) -> a + b

sum = (numbers) ->
    numbers.reduce add, 0

EL_PADDING = 10

module.exports = class LabeledMultiLineChart extends Chart
    buildSeries: ->
        {data, colors} = @props
        all_series = {}
        cell_width = @computeCellWidth()
        data.forEach (d, di) ->
            if d.values?
                Object.keys(d.values).map (series_key) ->
                    all_series[series_key] ||= []
                    all_series[series_key].push
                        x: cell_width * (di + 0.5)
                        y: d.values[series_key]

        Object.keys(all_series).map (series_key) ->
            series_key
            color: colors?[series_key]
            data: all_series[series_key]

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

    computeCellWidth: ->
        {width, height, data, options} = @props
        {horizontal} = options
        num_bars = data.length
        if horizontal
            return Math.floor(height / num_bars - 1)
        else
            return Math.floor(width / num_bars - 1)

    renderChart: ->
        {width, height, data, x, y, colors, curve, fill, options, markers, colorer} = @props
        {x, y} = @state
        {bar_padding, stroke_width, horizontal, el_padding} = options
        bar_padding ||= 10
        el_padding ||= EL_PADDING
        rotate_labels = @props.x_axis?.rotate

        cell_width = @computeCellWidth.bind(@)()
        x_extent = d3.extent([0, width])
        total_ys = data.map (d) -> sum(Object.keys(d.values).map (k) -> d.values[k])
        y_extent = Math.max(total_ys...)
        # markers.forEach (marker) ->
        #     if y_max < marker.value
        #         y_max = marker.value
        y = d3.scaleLinear()
            .domain([0, y_extent])
            .range([0, height])

        all_series = @buildSeries.bind(@)()
        line = d3.line()
            .curve if curve then d3.curveMonotoneX else d3.curveLinear
            # The x coordinate is given, it's the bin midpoint
            .x (d) -> d.x
            .y (d) -> height - y(d.y)
        if horizontal
            line = d3.line()
            .curve if curve then d3.curveMonotoneX else d3.curveLinear
            # The x coordinate is given, it's the bin midpoint
            .x (d) -> x(d.x)
            .y (d) -> d.y
        cell_index = -1
        # Height for labels
        chart_height = height + 4 * bar_padding
        cell_index = 0
        <svg className='line-chart' style={{width, height: chart_height}} width=width height=chart_height>
            {all_series.map (series, di) =>
                d = line series.data
                <g key=di>
                    {if fill
                        first_point = {x: x.domain()[0], y: y.domain()[0]}
                        last_point = {x: x.domain()[1], y: y.domain()[0]}
                        da = line [first_point].concat(data).concat([last_point])
                        <path
                            d=da
                            fill={series.color || "#333"}
                            opacity=0.2
                            stroke='none'
                        />
                    }
                    <path
                        d=d
                        fill="none"
                        stroke={series.color || "#333"}
                        strokeWidth=stroke_width
                    />
                </g>

            }
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
                        <text className='label' y=label_y x=label_x textAnchor=text_anchor width={cell_width} transform="rotate(#{rotate_labels},#{label_x},#{label_y})">{l}</text>
                    }
                </g>
            }
        </svg>
                    # TODO: renderMarkers
                        # cell_markers = markers?.filter (m) ->
                        #     m.cell_key == d.cell_key
                        # {cell_markers?.map (marker, i) ->
                        #     if marker.kind == 'diamond'
                        #         symbol_generator = d3.symbol().type(d3.symbolDiamond).size(80)
                        #         <path className='dot' key=i
                        #             d={symbol_generator()}
                        #             transform="translate(#{family_width * (i_data + 0.5) - cell_width / 2},#{y(y_max - marker.value)})"
                        #             fill={colors?[marker.series_key] || "#333"}
                        #         >
                        #             <title>{marker.value}</title>
                        #         </path>
                        #     else
                        #         <circle className='dot' key=i
                        #             r=4
                        #             cx={cell_width * (cell_index - 0.5) - cell_width / 2}
                        #             cy=y(marker.value)
                        #             fill={colors?[marker.series_key] || "#333"}
                        #         >
                        #             <title>{marker.value}</title>
                        #         </circle>
                        # }

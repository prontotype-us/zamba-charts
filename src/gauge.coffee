React = require 'react'
d3 = require 'd3'
color = d3.scaleOrdinal(d3.schemeCategory20)

Gauge = React.createClass

    angleFromValue: (val) ->
        full_arc = (@end_angle - @start_angle) || Math.PI * 2
        angle = (full_arc * (val - @min) / (@max - @min)) + @start_angle

    renderGuide: ->
        {radius, thickness, start_angle, end_angle} = @
        arc = d3.arc().innerRadius(radius - Math.floor(thickness/2) - 2)
            .startAngle(start_angle).endAngle(end_angle)
            .outerRadius(radius - Math.ceil(thickness/2) + 2)
            .padRadius(2).cornerRadius(2) arc_params
        arc_params = {
            startAngle: 0
            endAngle: (Math.PI * 2)
            value: 100
            data: 100
        }
        # console.log d
        d = arc# arc_params
        <g key='guide' className='guide' transform="translate(#{radius}, #{radius})" >
            <path
                onClick={->}
                key='guide-path'
                x=radius
                y=radius
                d=d
                fill={"#ccc"}
            />
        </g>

    render: ->
        {width, height, title, value, options, title} = @props
        {min, max, start_angle, end_angle, guide, bar} = options
        # {options
        #     guide
        #         thickness
        #         inner
        #         outer
        #         ...
        #     bar
        #         radius
        #         thickness
        # 
        # }
        {width, height, options} = @props
        {min, max, start_angle, end_angle, show_value, guide, bar} = options

        @min ||= 0
        @max ||= 100

        @show_value ||= false

        @thickness = thickness = bar?.thickness || 25
        @guide_thickness = guide?.thickness || 4
        @radius = radius = Math.min(width, height) / 2

        @start_angle = start_angle ||= 0
        @end_angle = end_angle ||= Math.PI *2

        @label_d_y = label_d_y = @props.options.label_d_y || 5

        # Markers (for comparison to value)
        markers = @props.data.filter((d) -> d.type == 'marker')
        renderMarker = (marker, i) =>
            arc = d3.arc().innerRadius(radius - thickness).outerRadius(radius).padRadius(2).cornerRadius(2)
            angle = @angleFromValue marker.value

            arc_params = {
                startAngle: angle - 0.1
                endAngle: angle + 0.1
                value: marker.value
                data: marker.value
            }

            d = arc.innerRadius(radius - (thickness + 2)).outerRadius(radius + 2) arc_params

            [label_x, label_y] = arc.outerRadius(radius + 75).centroid arc_params

            <g key=i transform="translate(#{radius}, #{radius})" >
                <path
                    onClick={->}
                    key=i
                    x=radius
                    y=radius
                    d=d
                    fill={"#888"}
                />
                {if marker.label
                    <text className='marker-label' x={label_x-35} y=label_y key='label' style={fontWeight:'bold'} >{marker.label + ' - ' + marker.value}</text>}
            </g>

        # Value data (main part of gauge)
        value_data = @props.data.filter((d) -> d.type == 'value')[0]
        {value} = value_data
        value_color = value_data.color

        value_range = [value, (@max-value)]
        arc = d3.arc().innerRadius(radius - thickness)
            .outerRadius(radius).padRadius(2)
            .cornerRadius(2).startAngle(start_angle)

        <svg className='gauge-chart' key='gauge' style={{position: 'relative', width, height}}>
            {if !options.guide?.hidden
                @renderGuide()
            }
            <g className='gauge-bar' transform="translate(#{radius}, #{radius})">
                {
                    di = 0
                    d = arc {endAngle: @angleFromValue(value)}
                    a_color = value_color || color(di)
                    <path
                        onClick={->}
                        key=di
                        x=radius
                        y=radius
                        d=d
                        fill={if di == 1 then 'none' else a_color} />}
            </g>
            {if show_value
                <text className='value' x={radius} y={radius+label_d_y} textAnchor='middle'>{value}</text>
            }
            {if markers?.length
                markers.map renderMarker
            }
        </svg>


module.exports = Gauge
React = require 'react'
d3 = require 'd3'

# Props
# 
# min: Int
# max: Int
# start_angle: Float
# end_angle: Float
# label_y: Int
# bar:
#     thickness: Int
# guide:
#     thickness: Int
#     hidden: false
# label_padding: Int

class Gauge extends React.Component

    angleFromValue: (val) ->
        {min, max, end_angle, start_angle} = @props
        full_arc = (end_angle - start_angle) or Math.PI * 2
        angle = (full_arc * (val - min) / (max - min)) + start_angle

    computeRadius: ->
        {width, height, label_padding} = @props
        (Math.min(width, height) / 2) - label_padding

    render: ->
        {
            width, height, min, max
            value, color
            start_angle, end_angle
            show_value, bar, guide, markers
            label_padding, label_y
        } = @props

        radius = @computeRadius()

        value_range = [value, (max - -value)]

        arc = d3.arc()
            .innerRadius(radius - bar.thickness)
            .outerRadius(radius)
            .padRadius(2)
            .cornerRadius(2)

        arc_params = {
            startAngle: start_angle
            endAngle: @angleFromValue(value)
        }

        arc_data = arc(arc_params)

        <svg className='gauge-chart' key='gauge' style={{position: 'relative', width, height}}>
            <g key='mover' transform="translate(#{radius + label_padding}, #{radius + label_padding})" >
                {if !guide?.hidden
                    @renderGuide()
                }
                <g className='gauge-bar'>
                    <path
                        x=radius
                        y=radius
                        d=arc_data
                        fill={color}
                    />
                </g>
                {if show_value
                    <text
                        className='value'
                        x={0}
                        y={label_y}
                        alignment-baseline='middle'
                        text-anchor='middle'
                    >
                        {value}
                    </text>
                }
                {markers?.map @renderMarker.bind(@)}
            </g>
        </svg>

    renderGuide: ->
        {start_angle, end_angle, guide} = @props
        radius = @computeRadius()

        arc = d3.arc()
            .innerRadius(radius - guide.thickness)
            .outerRadius(radius)
            .padRadius(2)
            .cornerRadius(2)

        arc_params = {
            startAngle: start_angle
            endAngle: end_angle
        }

        arc_data = arc(arc_params)

        <g key='guide' className='guide' >
            <path
                key='guide-path'
                x=radius
                y=radius
                d=arc_data
                fill=guide.color
            />
        </g>

    renderMarker: (marker, i) ->
        console.log '[marker]', marker
        {bar} = @props
        radius = @computeRadius()
        angle = @angleFromValue marker.value
        marker_angle = marker.angle or 0.05

        arc = d3.arc()
            .innerRadius(radius - bar.thickness)
            .outerRadius(radius)

        arc_params = {
            startAngle: angle - marker_angle / 2
            endAngle: angle + marker_angle / 2
        }

        arc_data = arc(arc_params)

        [label_x, label_y] = arc.outerRadius(radius + 75).centroid(arc_params)

        <g key=i>
            <path
                key=i
                className='marker'
                x=radius
                y=radius
                d=arc_data
                fill=marker.color
                onClick={onClick?.bind(null, marker)}
            />
            {if marker.label
                <text className='marker-label' x={label_x - 35} y=label_y key='label' style={fontWeight:'bold'}>
                    {marker.label}
                </text>
            }
        </g>

Gauge.defaultProps =
    min: 0
    max: 0
    start_angle: 0
    end_angle: Math.PI * 2
    bar:
        thickness: 25
    guide:
        thickness: 25
        hidden: false
    label_padding: 0
    label_y: 0

module.exports = Gauge

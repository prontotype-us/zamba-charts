React = require 'react'
d3 = require 'd3'


Gauge = React.createClass

    render: ->
        {width, height, title, value, options, title} = @props
        min = @props.options.min || 0
        max = @props.options.max || 100
        label_d_y = @props.options.label_d_y || 5
        thickness = @props.options.thickness || 25
        show_value = @props.options.show_value || false

        gauge_pieces = @props.data.map (d,i) =>
            # Have a "type" as well, to put on markers and compare to other values
            {value, label, color} = d

        value = @props.data.filter((d) -> d.type == 'value')[0].value
        markers = @props.data.filter((d) -> d.type == 'marker')

        range = [value, (max-value)]
        radius = Math.min(width, height) / 2

        color = d3.scaleOrdinal(d3.schemeCategory20)
        pie = d3.pie().value((d) -> d)
        arc = d3.arc().innerRadius(radius - thickness).outerRadius(radius).padRadius(2)
        arcs = pie(range).map (d) -> arc(d)

        guide_arc = d3.arc().innerRadius(radius - thickness/2 - 2).outerRadius(radius - thickness/2 + 2).padRadius

        <svg className='gauge-chart' key='gauge' style={{position: 'relative', width, height}}>
            <g transform="translate(#{radius}, #{radius})">
                {arcs.map (d, di) =>
                    a_color = @props.data[di]?.color || color(di)
                    <path
                        onClick={->}
                        key=di
                        x=radius
                        y=radius
                        d=d
                        fill={if di == 1 then 'none' else a_color}
                    />
                }
            </g>
            {if show_value
                <text x={radius} y={radius+label_d_y} textAnchor='middle'>{value}</text>
            }
        </svg>

                    # <g transform="translate(#{radius}, #{radius})">
                    #     {pie([100]).map((d) -> guide_arc(d)).map (d, di) =>
                    #         <path
                    #             onClick={->}
                    #             key=di
                    #             x=radius
                    #             y=radius
                    #             d=d
                    #             fill="#ddd"
                    #         />
                    #     }
                    # </g>

module.exports = Gauge
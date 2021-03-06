React = require 'react'
d3 = require 'd3'

module.exports = class PieChart extends React.Component

    render: ->
        {width, height, data, onClick, onHover, selected, hover, inner_radius} = @props

        inner_radius ||= 0
        radius = Math.min(width, height) / 2
        color = d3.scaleOrdinal(d3.schemeCategory20)
        pie = d3.pie().value((d) -> d.count).sort(null)
        if @props.start_angle
            pie = pie.startAngle(@props.start_angle)
        if @props.end_angle
            pie = pie.endAngle(@props.end_angle)

        arc = d3.arc()
            .outerRadius(radius)
            .innerRadius(inner_radius)

        arcs = pie(data).map arc

        <svg className='pie-chart' style={{position: 'relative', width, height}}>
            <g transform="translate(#{radius}, #{radius})">
                {arcs.map (arc, di) =>
                    d = data[di]
                    className = ''
                    if selected == d.label
                        className += ' selected'
                    else if hover == d.label
                        className += ' hover'
                    <path
                        className=className
                        onClick={onClick?.bind(null, d)}
                        onMouseOver={onHover?.bind(null, d)}
                        onMouseOut={onHover}
                        key=di
                        x=radius
                        y=radius
                        d=arc
                        fill={d.color || color(di)}
                    />
                }
            </g>
        </svg>

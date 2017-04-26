React = require 'react'
d3 = require 'd3'

module.exports = PieChart = React.createClass
    getDefaultProps: ->
        color: '#000'

    render: ->
        {width, height, data, onClick, onHover, selected, hover} = @props

        radius = Math.min(width, height) / 2
        color = d3.scaleOrdinal(d3.schemeCategory20)
        pie = d3.pie().value((d) -> d.count).sort(null)
        if @props.start_angle
            pie = pie.startAngle(@props.start_angle)
        if @props.end_angle
            pie = pie.endAngle(@props.end_angle)
        arc = d3.arc().innerRadius(0).outerRadius(radius).padRadius(2)
        if @props.inner_radius
            arc = arc.innerRadius(@props.inner_radius).cornerRadius(@props.corner_radius || 2)
        arcs = pie(data).map (d) -> arc(d)

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


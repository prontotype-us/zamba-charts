React = require 'react'
d3 = require 'd3'

module.exports = PieChart = React.createClass
    getDefaultProps: ->
        color: '#000'

    render: ->
        {width, height, data, onClick, onHover, selected, hover} = @props

        radius = Math.min(width, height) / 2
        color = d3.scaleOrdinal(d3.schemeCategory20)
        pie = d3.pie().value((d) -> d.count)
        arc = d3.arc().innerRadius(0).outerRadius(radius).padRadius(2)
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


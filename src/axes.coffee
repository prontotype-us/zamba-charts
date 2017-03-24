React = require 'react'

axis_formats = {

}

# types of x or "domain" axes (the domain is the y axis when the chart is horizontal)
# value/count
# duration
# timestamp
# labeled bins
exports.XAxis = React.createClass
    render: ->
        {width, height, x, options, axis_size, padding, position, formatter, format} = @props
        height = axis_size
        style = {width, height, position: 'absolute', left: padding+axis_size}
        if position == 'bottom'
            style.bottom = 0
        else
            style.top = 0
        <svg className='axis x-axis' style={style}>
            {x.ticks(options?.ticks || 10).map (t, ti) =>
                label = if options?.formatter? then options.formatter(t)() else t.toFixed(0)
                <text x={x(t)} y={height - 6} textAnchor='middle' key=ti>{label}</text>
            }
            {if options?.label
                <text className='label' x=width y={height} key='label' style={fontWeight:'bold'} >{options.label}</text>}
        </svg>


# types of y or "range" axes (the range is the x axis when the chart is horizontal)
# value/count
# percentage/normalized
exports.YAxis = React.createClass
    render: ->
        {width, height, y, options, axis_size, padding, formatter, format} = @props
        width = axis_size
        <svg className='axis y-axis' style={{width, height, position: 'absolute', left: 0, top: padding}}>
            {y.ticks(options?.ticks || (height / 20)).map (t, ti) ->
                <text y={y(t)} x={width/2} textAnchor='middle' key=ti>{t.toFixed(0)}</text>
            }
            {if options?.label
                <text className='label' y=0 x={width/2} key='label' style={fontWeight:'bold'} >{options.label}</text>}
        </svg>

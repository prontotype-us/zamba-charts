React = require 'react'

exports.XAxis = React.createClass
    render: ->
        {width, height, x, options, padding, position} = @props

        style = {width, height, position: 'absolute', left: padding}
        if position == 'bottom'
            style.bottom = 0
        else
            style.top = 0
        <svg className='axis x-axis' style={style}>
            {x.ticks(options?.tics || 10).map (t, ti) ->
                <text x={x(t)} y={height - 6} textAnchor='middle' key=ti>{t.toFixed(0)}</text>
            }
        </svg>

exports.YAxis = React.createClass
    render: ->
        {width, height, y, options, padding} = @props

        <svg className='axis y-axis' style={{width, height, position: 'absolute', left: 0, top: padding}}>
            {y.ticks(options?.ticks || (height / 20)).map (t, ti) ->
                <text y={y(t)} x={width/2} textAnchor='middle' key=ti>{t.toFixed(0)}</text>
            }
        </svg>

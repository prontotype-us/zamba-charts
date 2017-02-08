React = require 'react'

exports.XAxis = React.createClass
    render: ->
        {width, height, x} = @props

        <svg className='axis x-axis' style={{width, height, position: 'absolute', bottom: 0, left: padding}}>
            {x.ticks(10).map (t, ti) ->
                <text x={x(t)} y={height - 6} textAnchor='middle' key=ti>{t.toFixed(0)}</text>
            }
        </svg>

exports.YAxis = React.createClass
    render: ->
        {width, height, y} = @props

        <svg className='axis y-axis' style={{width, height, position: 'absolute', left: 0, top: padding}}>
            {y.ticks(height / 20).map (t, ti) ->
                <text y={y(t) + 6} x={width/2} textAnchor='middle' key=ti>{t.toFixed(2)}</text>
            }
        </svg>


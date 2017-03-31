React = require 'react'

# X axis
# types of x or "domain" axes (the domain is the y axis when the chart is horizontal)
# value/count
# duration
# timestamp
# labeled bins

# Y axis
# types of y or "range" axes (the range is the x axis when the chart is horizontal)
# value/count
# percentage/normalized

exports.XAxis = ({width, height, x, padding, position, format, ticks, labels, label}) ->
    style = {width, height, position: 'absolute', left: padding}

    if position == 'bottom'
        style.bottom = 0
    else
        style.top = 0

    <svg className='axis x-axis' style={style}>
        {if labels?
            Object.keys(labels).map (label_x) ->
                <text x={x(label_x)} y={height} textAnchor='middle' key=label_x>{labels[label_x]}</text>
        else
            x.ticks(ticks || 10).map (t, ti) =>
                tick_label = if format? then format(t) else t.toFixed(0)
                <text x={x(t)} y={height} textAnchor='middle' key=ti>{tick_label}</text>
        }

        {if label
            <text className='label' x=width y={height} key='label' style={fontWeight:'bold'}>
                {label}
            </text>
        }
    </svg>

exports.YAxis = ({width, height, y, position, padding, format, ticks, label}) ->
    style = {width, height, position: 'absolute', top: padding}

    if position == 'left'
        style.left = 0
    else
        style.right = 0

    <svg className='axis y-axis' style=style>
        {y.ticks(ticks || (height / 20)).map (t, ti) ->
            tick_label = if format? then format(t) else t.toFixed(0)
            <text y={y(t)} textAnchor='start' alignmentBaseline='middle' key=ti>{tick_label}</text>
        }

        {if label?
            <text className='label' y=0 textAnchor='start' key='label' style={fontWeight:'bold'}>
                {label}
            </text>
        }
    </svg>


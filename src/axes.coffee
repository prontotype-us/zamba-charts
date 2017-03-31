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

exports.XAxis = ({width, height, x, position, format, ticks, labels, label}) ->
    style = {width, height, position: 'absolute', left: 0}

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
                text_y = if position == 'bottom' then height else 0
                alignment_baseline = if position == 'bottom' then 'baseline' else 'hanging'
                <text x={x(t)} y=text_y textAnchor='middle' key=ti alignmentBaseline=alignment_baseline>{tick_label}</text>
        }

        {if label
            <text className='label' x=width y={height} key='label' style={fontWeight:'bold'}>
                {label}
            </text>
        }
    </svg>

exports.YAxis = ({width, height, y, position, format, ticks, label}) ->
    style = {width, height, position: 'absolute', top: 0}

    if position == 'left'
        style.left = 0
    else
        style.right = 0

    <svg className='axis y-axis' style=style>
        {y.ticks(ticks || (height / 20)).map (t, ti) ->
            tick_label = if format? then format(t) else t.toFixed(0)
            text_x = if position == 'left' then 0 else width
            text_anchor = if position == 'left' then 'start' else 'end'
            <text y={y(t)} x=text_x textAnchor=text_anchor alignmentBaseline='middle' key=ti>{tick_label}</text>
        }

        {if label?
            <text className='label' y=0 textAnchor='start' key='label' style={fontWeight:'bold'}>
                {label}
            </text>
        }
    </svg>


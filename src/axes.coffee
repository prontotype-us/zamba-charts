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

exports.XAxis = ({width, height, axis_size, x, padding, position, format, ticks, labels, label, border, rotate}) ->
    padding ||= 0
    style = {width, height: axis_size, position: 'absolute', left: 0, top: height}

    if position == 'bottom'
        style.bottom = padding
    else
        style.top = padding

    <svg className='axis x-axis' style={style} height=axis_size width=width>
        {if labels?
            <g className='labels'>
                {Object.keys(labels).map (label_x) ->
                    <text x={x(label_x)} y=0 text-anchor='middle' key=label_x>{labels[label_x]}</text>
                }
            </g>
        else
            x.ticks(ticks || 10).map (t, ti) =>
                tick_label = if format? then format(t) else t.toFixed(0)
                text_y = if position == 'bottom' then axis_size else 0
                alignment_baseline = if position == 'bottom' then 'baseline' else 'hanging'
                if rotate > 0
                    text_anchor = 'start'
                else if rotate < 0
                    text_anchor = 'end'
                else
                    text_anchor = 'middle'
                <text x={x(t)} y=text_y text-anchor=text_anchor key=ti alignmentBaseline=alignment_baseline transform="rotate(#{rotate},#{x(t)},#{text_y})">{tick_label}</text>
        }

        {if label
            <text className='label' x=width y=0 key='label' style={fontWeight:'bold'}>
                {label}
            </text>
        }

        {if border
            <rect height=axis_size x=axis_size width={width - axis_size} />
        }
    </svg>

exports.YAxis = ({width, height, axis_size, y, padding, position, format, ticks, label, labels, border}) ->
    padding ||= 0
    style = {width: axis_size, height, position: 'absolute', top: 0}

    if position == 'left'
        style.left = padding
    else
        style.right = padding

    labels_width = 20

    # TODO: translate labels left based on max label length?
    <svg className='axis y-axis' style=style height=height width=width>
        <g className='labels' transform="translate(-#{labels_width},0)">
            {if labels?
                Object.keys(labels).map (label_y) ->
                    <text y={y(label_y)} x={labels_width-5} text-anchor='end' key=label_y>{labels[label_y]}</text>
            else
                y.ticks(ticks || (height / 20)).map (t, ti) ->
                    tick_label = if format? then format(t) else t.toFixed(0)
                    text_x = if position == 'left' then 0 else width
                    text_anchor = if position == 'left' then 'start' else 'end'
                    <text y={y(t)} x=text_x text-anchor=text_anchor alignmentBaseline='middle' key=ti>{tick_label}</text>
            }
        </g>

        {if label?
            <text className='label' y=0 text-anchor='start' key='label' style={fontWeight:'bold'}>
                {label}
            </text>
        }

        {if border
            <rect width=axis_size x=0 y=0 height={height} />
        }
    </svg>

React = require 'react'
d3 = require 'd3'

module.exports = LabeledBarChart = React.createClass
    getDefaultProps: ->
        color: '#000'

    shouldComponentUpdate: (next_props, next_state) ->
        if next_props.data.length != @props.data.length
            return true
        else if (next_props.width != @props.width) or (next_props.height != @props.height)
            return true
        else if (next_props.y != @props.y) or (next_props.x != @props.x)
            return true
        else
            return false

    render: ->
        # This is built off bins rather than coordinates
        {width, height, data, x, y, bar_padding, axis_size} = @props
        num_bars = data.length
        bar_padding ||= 10

        x_extent = d3.extent([0, width])
        bar_width = Math.floor(width / num_bars - 1)

        y ||= d3.scaleLinear()
            .domain([0, d3.max(data, (d) -> d.y)])
            .range([height, 0])

        <svg className='bar-chart' style={{width, height}}>
            {data.map (d, di) =>
                <rect 
                    key=di
                    x={bar_width*(di)}
                    y={y(d.y)}
                    width={bar_width - bar_padding}
                    height={height - y(d.y)}
                    fill={d.color || @props.color}
                />
            }
        </svg>

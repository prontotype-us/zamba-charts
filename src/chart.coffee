React = require 'react'
d3 = require 'd3'
{XAxis, YAxis} = require './axes'
Follower = require './follower'
helpers = require './helpers'

flatten = (ls) ->
    flat = []
    for l in ls
        if Array.isArray(l)
            for i in l
                flat.push i
    return flat

module.exports = Chart =
    getDefaultProps: ->
        width: 100
        height: 100
        padding: 0
        axis_size: 20
        color: d3.scaleOrdinal d3.schemeCategory10

    componentWillMount: ->
        @createAxes @props

    componentWillReceiveProps: (next_props) ->
        @createAxes next_props

    shouldComponentUpdate: (next_props, next_state) ->
        if Array.isArray next_props.data?[0]
            return true # TODO: Compare inner array lengths
        if next_props.data.length != @props.data.length
            return true
        else if (next_props.width != @props.width) or (next_props.height != @props.height)
            return true
        else if (next_props.y != @props.y) or (next_props.x != @props.x)
            return true
        else
            return false

    createAxes: (props) ->
        {x, y, width, height, data, padding, x_axis, y_axis} = props
        padding = helpers.transformPadding padding

        if @multi
            flat_data = []
            for _data in data
                for i in _data
                    flat_data.push i
        else
            flat_data = data

        if !x?
            x_extent = x_axis?.domain || @xDomain?() || d3.extent(flat_data, (d) -> d.x)

            x = d3.scaleLinear()
                .range([padding.left, width - padding.right])
                .domain(x_extent)

        if !y?
            y_extent = y_axis?.domain || d3.extent(flat_data, (d) -> d.y)

            if y_axis?.zero
                y_extent = [0, d3.max(flat_data, (d) -> d.y)]

            y = d3.scaleLinear()
                .range([height - padding.bottom, padding.top])
                .domain(y_extent)

        @setState {x, y}

    render: ->
        {
            width, height, data,
            title, color,
            padding, axis_size,
            follower, x_axis, y_axis,
        } = @props

        padding = helpers.transformPadding padding
        x_axis ||= {}
        y_axis ||= {}

        <div className='chart' style={{position: 'relative', width, height}}>
            {if title
                <div className='title'>{title}</div>
            }

            {@renderChart()}

            {if !x_axis.hidden
                <XAxis x=@state.x width=width height=axis_size position='bottom' {...x_axis} />
            }

            {if !y_axis.hidden
                <YAxis y=@state.y height=height width=axis_size position='left' {...y_axis} />
            }

            {if follower
                if typeof follower == 'boolean'
                    follower = {}
                <Follower width=width height=height data={data} color=color x=@state.x y=@state.y multi=@multi {...follower} />
            }
        </div>


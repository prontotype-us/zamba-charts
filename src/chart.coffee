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

module.exports = Chart = React.createClass
    getDefaultProps: ->
        width: 100
        height: 100
        padding: 0
        axis_size: 25
        color: d3.scaleOrdinal d3.schemeCategory10

    getInitialState: ->
        mouseX: 200
        mouseY: 200

    componentWillMount: ->
        @createAxes @props

    componentWillReceiveProps: (next_props) ->
        @createAxes next_props

    createAxes: (props) ->
        {x, y, width, height, data, padding, x_axis, y_axis} = props
        padding = helpers.transformPadding padding

        if Array.isArray data[0]
            flat_data = []
            for _data in data
                for i in _data
                    flat_data.push i
        else
            flat_data = data

        if !x?
            x_extent = x_axis?.domain || d3.extent(flat_data, (d) -> d.x)

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

    onMouseMove: (e) ->
        if !@props.follower
            return
        bounds = @refs.container.getBoundingClientRect()
        mouseX = e.clientX - bounds.left
        mouseY = e.clientY - bounds.top
        @setState {mouseX, mouseY}

    render: ->
        {
            width, height, data,
            title, color, children,
            padding, axis_size,
            follower, x_axis, y_axis,
        } = @props

        padding = helpers.transformPadding padding
        x_axis ||= {}
        y_axis ||= {}

        <div className='chart' ref='container' style={{position: 'relative', width, height}} onMouseMove=@onMouseMove>
            {if title
                <div className='title'>{title}</div>
            }

            {React.cloneElement children, {
                width, height, padding,
                data, color
                x: @state.x, y: @state.y
            }}

            {if !x_axis.hidden
                <XAxis x=@state.x width=width height=axis_size position='bottom' {...x_axis} />
            }

            {if !y_axis.hidden
                <YAxis y=@state.y height=height width=axis_size position='left' {...y_axis} />
            }

            {if follower
                if typeof follower == 'boolean'
                    follower = {}
                <Follower width=width height=height data={data} color=color x=@state.x y=@state.y mouseX=@state.mouseX mouseY=@state.mouseY {...follower} />
            }
        </div>


React = require 'react'
d3 = require 'd3'
{XAxis, YAxis} = require './axes'
Follower = require './follower'

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
        {width, height, data, datas, adjust, options, padding} = props
        if !data? and datas?
            data = flatten datas
        padding ||= 0

        x_extent = options?.axes?.x?.range || d3.extent(data, (d) -> d.x)
        y_extent = options?.axes?.y?.range || d3.extent(data, (d) -> d.y)

        if adjust
            x_extent[0] -= 0.5
            x_extent[1] += 0.5

        if options?.axes?.y?.zero
            y_extent = [0, d3.max(data, (d) -> d.y)]

        x = d3.scaleLinear()
            .range([padding, width - padding])
            .domain(x_extent)
        y = d3.scaleLinear()
            .range([height - padding, padding])
            .domain(y_extent)

        @setState {x, y}

    onMouseMove: (e) ->
        if !@props.show_follower
            return
        bounds = @refs.container.getBoundingClientRect()
        mouseX = e.clientX - bounds.left
        mouseY = e.clientY - bounds.top
        @setState {mouseX, mouseY}

    render: ->
        {
            width, height,
            data, datas,
            title, children,
            colorer, color,
            adjust, padding, axis_size,
            show_follower,
            x_axis, y_axis,
            options # TODO: Less nested options 
        } = @props

        x_axis ||= {}
        y_axis ||= {}

        # Support single datasets
        if data? and !datas?
            datas = [data]

        <div className='chart' ref='container' style={{position: 'relative', width, height}} onMouseMove=@onMouseMove>
            {if title
                <div className='title'>{title}</div>
            }

            {datas.map (data, di) =>
                React.cloneElement children, {
                    width, height,
                    data, padding
                    padding, colorer,
                    options: options?.chart
                    key: data.id or di,
                    color: data.color or color(data.id or di),
                    x: @state.x, y: @state.y
                }
            }

            {if !x_axis.hidden
                <XAxis x=@state.x width=width height=axis_size padding=padding position='bottom' {...x_axis} />
            }
            {if !y_axis.hidden
                <YAxis y=@state.y height=height width=axis_size padding=padding position='left' {...y_axis} />
            }

            {if show_follower
                <Follower width=width height=height datas={datas} color=color x=@state.x y=@state.y mouseX=@state.mouseX mouseY=@state.mouseY />
            }
        </div>

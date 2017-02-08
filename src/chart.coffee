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
        padding: 0
        axis_size: 50
        color: d3.scaleOrdinal d3.schemeCategory10

    getInitialState: ->
        mouseX: 200
        mouseY: 200

    componentWillMount: ->
        @createAxes @props
    componentWillReceiveProps: (next_props) ->
        @createAxes next_props

    createAxes: (props) ->
        {width, height, data, datas, adjust} = props
        if !data? and datas?
            data = flatten datas
        x_extent = d3.extent(data, (d) -> d.x)

        if adjust
            x_extent[0] -= 0.5
            x_extent[1] += 0.5

        y_extent = d3.extent(data, (d) -> d.y)
        if false
            y_extent = [0, d3.max(data, (d) -> d.y)]

        x = d3.scaleLinear()
            .range([0, width])
            .domain(x_extent)
        y = d3.scaleLinear()
            .range([height, 0])
            .domain(y_extent)

        @setState {x, y}

    onMouseMove: (e) ->
        bounds = @refs.container.getBoundingClientRect()
        mouseX = e.clientX - bounds.left
        mouseY = e.clientY - bounds.top
        @setState {mouseX, mouseY}

    render: ->
        {width, height, data, datas, title, children, adjust, padding, axis_size, color} = @props
        if data? and !datas?
            datas = [data]

        <div className='chart' ref='container' style={{position: 'relative', padding, width, height}} onMouseMove=@onMouseMove>
            {datas.map (data, di) =>
                React.cloneElement children, {
                    width, height, data,
                    padding,
                    key: data.id or di,
                    color: color(data.id or di),
                    x: @state.x, y: @state.y
                }
            }
            <XAxis x=@state.x width=width height=axis_size padding=padding position='bottom' />
            <YAxis y=@state.y width=axis_size height=height padding=padding />
            <Follower width=width height=height datas={datas} color=color x=@state.x y=@state.y mouseX=@state.mouseX mouseY=@state.mouseY />
        </div>


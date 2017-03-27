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
        {width, height, data, datas, adjust, options, axis_size} = props
        if !data? and datas?
            data = flatten datas
        chart_height = height - axis_size
        chart_width = width - axis_size
        x_extent = @props.options?.axes?.x?.range || d3.extent(data, (d) -> d.x)

        if adjust
            x_extent[0] -= 0.5
            x_extent[1] += 0.5

        y_extent = @props.options?.axes?.y?.range || d3.extent(data, (d) -> d.y)

        if options?.axes?.y?.zero
            y_extent = [0, d3.max(data, (d) -> d.y)]

        x = d3.scaleLinear()
            .range([0, chart_width])
            .domain(x_extent)
        y = d3.scaleLinear()
            .range([chart_height, 0])
            .domain(y_extent)

        @setState {x, y}

    onMouseMove: (e) ->
        bounds = @refs.container.getBoundingClientRect()
        mouseX = e.clientX - bounds.left
        mouseY = e.clientY - bounds.top
        @setState {mouseX, mouseY}

    render: ->
        {width, height, data, datas, title, children, adjust, padding, colorer, axis_size, color, options} = @props
        if data? and !datas?
            datas = [data]

        if options?
            chart_options = options.chart
            {show_follower} = options
        chart_height = height - axis_size
        chart_width = width - axis_size

        <div className='chart' ref='container' style={{position: 'relative', padding, width, height}} onMouseMove=@onMouseMove>
            {if title
                <div className='title'>{title}</div>
            }
            {datas.map (data, di) =>
                React.cloneElement children, {
                    width: chart_width, height: chart_height, data, axis_size
                    padding, colorer,
                    options: chart_options
                    key: data.id or di,
                    color: color(data.id or di),
                    x: @state.x, y: @state.y
                }
            }
            {if !options?.axes?.x?.hidden
                <XAxis x=@state.x width=chart_width axis_size=axis_size padding=padding position='bottom' options=options?.axes?.x />}
            {if !options?.axes?.y?.hidden
                <YAxis y=@state.y axis_size=axis_size height=chart_height padding=padding options=options?.axes?.y />}
            {if show_follower
                <Follower width=width height=height datas={datas} color=color x=@state.x y=@state.y mouseX=@state.mouseX mouseY=@state.mouseY />}
        </div>

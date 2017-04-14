React = require 'react'
d3 = require 'd3'
helpers = require './helpers'

r = 5

module.exports = Follower = React.createClass
    getInitialState: ->
        mouseX: @props.width / 2
        mouseY: @props.height / 2

    onMouseMove: (e) ->
        bounds = @refs.container.getBoundingClientRect()
        mouseX = e.clientX - bounds.left
        mouseY = e.clientY - bounds.top
        @setState {mouseX, mouseY}

    render: ->
        {width, height, data, x, y, color, mouseX, mouseY, format, multi} = @props
        {mouseX, mouseY} = @state

        xx = x.invert mouseX
        if !multi
            data = [data]

        <svg className='follower-container' ref='container' style={{width, height, position: 'absolute', top: 0, left: 0, right: 0, bottom: 0}} onMouseMove=@onMouseMove>
            <rect className='follower-line follower-vertical' style={{
                width: 1
                height: height
                y: 0
                x: mouseX
            }} />
            <rect className='follower-line follower-horizontal' style={{
                width: width
                height: 1
                y: mouseY
                x: 0
            }} />

            {data.map (data, di) ->
                follower = {}
                yy = 0
                for d in data
                    if d.x > xx
                        yy = d.y
                        break
                value = yy
                if yy == 0
                    return <div key=di />

                <g className='follower' transform="translate(#{mouseX}, #{y yy})" key=di>
                    <circle className='follower-dot'
                        r={r}
                        style={{fill: helpers.interpretColor(color, data)}}
                    />
                    <text className='follower-label'
                        y={0}
                        x={r+5}
                        alignmentBaseline='middle'
                    >
                        {if format?
                            format(value)
                        else
                            value.toFixed(4)
                        }
                    </text>
                </g>
            }
        </svg>

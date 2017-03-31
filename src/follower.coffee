React = require 'react'
d3 = require 'd3'

r = 5

module.exports = Follower = ({width, height, datas, x, y, color, mouseX, mouseY}) ->
    xx = x.invert mouseX

    <svg className='follower-container' style={{width, height, position: 'absolute', top: 0, left: 0}}>
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
        {datas.map (data, di) ->
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
                    style={{fill: color(data.id or di)}}
                />
                <text className='follower-label'
                    y={0}
                    x={r+5}
                    alignmentBaseline='middle'
                >
                    {value.toFixed(4)}
                </text>
            </g>
        }
    </svg>

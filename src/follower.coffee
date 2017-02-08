React = require 'react'
d3 = require 'd3'

r = 5

module.exports = Follower = ({width, height, data, x, y, colors, mouseX, mouseY}) ->
    xx = x.invert mouseX

    <div className='follower-container' style={{width, height, position: 'absolute'}}>
        <div className='follower-line' style={{
            width: 1
            height: height
            position: 'absolute'
            top: 0
            left: mouseX
            background: '#eee'
        }} />
        <div className='follower-line' style={{
            width: width
            height: 1
            position: 'absolute'
            top: mouseY
            left: 0
            background: '#eee'
        }} />
        {data.map (ds, di) ->
            follower = {}
            yy = 0
            for d in ds
                if d.x > xx
                    yy = d.y
                    break
            value = yy
            if yy == 0
                return <div key=di />

            <div className='follower'
                style={{
                    position: 'absolute'
                    top: y yy
                    left: mouseX
                }} key=di>
                <div className='follower-dot'
                    style={{
                        position: 'absolute'
                        top: -r
                        left: -r
                        width: 2 * r
                        height: 2 * r
                        borderRadius: r
                        background: colors[di]
                    }}
                />
                <span className='follower-label'
                    style={{
                        top: -r
                        left: r + 5
                    }}
                >
                    {value.toFixed(4)}
                </span>
            </div>
        }
    </div>

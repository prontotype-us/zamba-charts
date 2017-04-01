React = require 'react'
LineChart = require './line'

module.exports = MultiLineChart = React.createClass
    render: ->
        <div>
            {@props.data.map (data) =>
                <LineChart {...@props} data=data />
            }
        </div>


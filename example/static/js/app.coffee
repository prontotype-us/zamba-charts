React = require 'react'
ReactDOM = require 'react-dom'
{BarChart, LineChart, PieChart, Chart, Histogram} = require 'zamba-charts'
require './reload'

data = [0..40].map (i) ->
    x: i
    y: Math.random() * 20 + 4

# Goal: numbers from 5 to (10 - epsilon) in 5 buckets

hist_data = [
    5.0
    5.4
    5.2
    6.2
    6.5
    6.7
    6.5
    7.4
    7.4
    7.2
    8.2
    9.9
    10
].map (x) -> {x}

pie_data = [0..6].map (i) ->
    random_int = Number(Math.random()*20)
    {label: "Test Data #{random_int}", count: Number(Math.random()*1000)}

# data = [5, 3, 2, 0, 1, 2, 4, 6].map (y, x) -> {x, y}

s = 150
ratio = 0.3

App = React.createClass
    getInitialState: ->
        f: 0
        width: s
        height: s
        dir: 1

    animate: ->
        setInterval @plusOne, 50

    plusOne: ->
        f = @state.f + 1
        wf = Math.sin(f / 100) * 2
        hf = Math.sin((f - 100) / 100) * 2
        width = @state.width + wf
        height = @state.height + hf
        @setState {width, height, f}

    render: ->
        {width, height} = @state
        <div>
            <Chart data=data width=width height=height adjust=true>
                <BarChart color='#f93' />
            </Chart>
            <Chart data=data width=width height=height>
                <LineChart color='green' curve=false />
            </Chart>
            <Chart data=data width=width height=height padding=5>
                <LineChart color='blue' />
            </Chart>
            <Chart data=data width=width height=height padding=15>
                <LineChart color='blue' fill=true />
            </Chart>
            <Chart data=data width=width height=height y_axis={position: 'right', zero: true} x_axis={position: 'top'}>
                <LineChart color='blue' />
            </Chart>
            <Chart data=pie_data width=width height=height adjust=true>
                <PieChart color='#f93' />
            </Chart>
            <button onClick=@animate>Animate</button>
        </div>

HistogramTest = React.createClass
    render: ->
        <div>
            <Histogram data=hist_data height=100 width=200 n_bins=5 />
            <Histogram data=hist_data height=100 width=200 bin_size=1 />
            <Histogram data=hist_data height=100 width=200 n_bins=1 />
            <Histogram data=hist_data height=100 width=200 bin_size=5 />
            <Histogram data=hist_data height=100 width=200 n_bins=10 />
            <Histogram data=hist_data height=100 width=200 bin_size=0.5 />
        </div>

ReactDOM.render <HistogramTest />, document.getElementById 'app'
# ReactDOM.render <App />, document.getElementById 'app'


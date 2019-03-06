React = require 'react'
ReactDOM = require 'react-dom'
{BarChart, LineChart, MultiLineChart, PieChart, Histogram, ScatterChart} = require 'zamba-charts'
d3 = require 'd3'

require './reload'

n_data = 10

data = [0...n_data].map (i) ->
    x: i
    y: Math.random() * 20 + 4

data2 = [0...n_data].map (i) ->
    x: i
    y: Math.random() * 20 + 4

# Goal: numbers from 5 to (10 - epsilon) in 5 buckets

hist_data = [
    {x: 5.0, letter: 'a'}
    {x: 5.4, letter: 'a'}
    {x: 5.2, letter: 'b'}

    {x: 6.2, letter: 'a'}
    {x: 6.3, letter: 'a'}
    {x: 6.4, letter: 'a'}
    {x: 6.5, letter: 'a'}
    {x: 6.7, letter: 'b'}
    {x: 6.5, letter: 'b'}

    {x: 7.4, letter: 'b'}
    {x: 7.4, letter: 'a'}
    {x: 7.2, letter: 'b'}

    {x: 8.1, letter: 'c'}
    {x: 8.2, letter: 'b'}

    {x: 9.8, letter: 'a'}
    {x: 9.9, letter: 'c'}
    {x: 9.99, letter: 'b'}
    {x: 10, letter: 'b'}
]

pie_data = [0..6].map (i) ->
    random_int = Number(Math.random()*20)
    {label: "Test Data #{random_int}", count: Number(Math.random()*1000)}

# data = [5, 3, 2, 0, 1, 2, 4, 6].map (y, x) -> {x, y}

s = 150
ratio = 0.3

class App extends React.Component
    constructor: ->
        @state = {
            f: 0
            width: s * 3
            height: s
            dir: 1
        }

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
        c20 = d3.scaleOrdinal d3.schemeCategory20
        <div>
            <HistogramTest />
            <ScatterChart data=data width=width height=height color='green' padding=20 />
            <BarChart adjust=true data=data width=width height=height color='purple' />
            <MultiLineChart curve=false data={[data, data2]} width=width height=height follower=true />
            <LineChart curve=false data=data width=width height=height follower=true />
            <LineChart data=data width=width height=height padding=5 color='blue' />
            <LineChart fill=true data=data width=width height=height padding=15 color='orange' />
            <LineChart fill=true data=data width=width height=height y_axis={position: 'right', zero: true} x_axis={position: 'top'} />
            <PieChart data=pie_data width=width height=height />
            <button onClick=@animate>Animate</button>
        </div>

HistogramTest = React.createClass
    render: ->
        <div>
            <Histogram data=hist_data height=100 width=200 n_bins=5 group_key='letter' padding={left: 20, bottom: 20} />
            <Histogram data=hist_data height=100 width=200 group_key='letter' bin_size=1 />
            <Histogram data=hist_data height=100 width=200 bin_size=1 />
            <Histogram data=hist_data height=100 width=200 n_bins=1 />
            <Histogram data=hist_data height=100 width=200 bin_size=5 />
            <Histogram data=hist_data height=100 width=200 n_bins=10 />
            <Histogram data=hist_data height=100 width=200 bin_size=0.5 />
        </div>

showit = (d) ->
    console.log 'clicked on', d

LT1 = ->
    <LineChart data=data height=100 width=200 />

HT2 = ->
    <Histogram data=hist_data height=100 width=200 bin_size=1 group_key='letter' onClick=showit />

# ReactDOM.render <LT1 />, document.getElementById 'app'
# ReactDOM.render <HT2 />, document.getElementById 'app'
ReactDOM.render <App />, document.getElementById 'app'


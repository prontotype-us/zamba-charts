# Zamba Charts

### Components

#### Chart

A wrapper component for rendering a chart, resizing it, and managing rendering of axes and followers. Configure the chart component and its axes with `options`

    props:
        title: String
        width: Int
        height: Int
        data: [{x, y}]
        padding: Int
        axis_size: Int
        options:
            # These will be passed to a Chart as props.options
            chart: (chart_options)
            axes:
                # These will be passed to the X Axis as props.options
                x: (axis_options)
                # These will be passed to the Y Axis as props.options
                y: (axis_options)

    children:
        <ChartComponent /> # Bar/Bin/etc...
        XAxis
        YAxis
        Follower

##### Legend

    props:
        className: String
        data: [
            color: String
            label: String
        ]

### Axes

#### XAxis

    props:
        x: d3.scale
        formatter: (d) -> String

#### YAxis

    props:
        y: d3.scale
        formatter: (d) -> String


### Chart Types

Every Chart has `height` and `width` in its props. You can also override the default x and y axes (scaled 0 to the maximum value on this axis) by passing a configured d3 scale `x` or `y` into props.


#### Bar

Histogram chart to display counts (range) over discrete values or bins of a domain.

    props:
        data: [
            x: Int
            y: Int
        ]


#### Labeled Bar

Histogram chart to display counts over a set of labeled bins.

    props:
        data: [
            y: Int
            label: String
        ]
        bar_padding: Int


#### Line

    props:
        data: [
            x: Int
            y: Int
        ]
        curve: Boolean
        fill: String #color


#### Scatter

    props:
        fill: String #color
        data: [
            x: Int
            y: Int
        ]
        options:
            renderPoint: (d) -> <PointComponent />

#### Pie

    props:
        data: [
            label: String
            count: Int
        ]
        onClick: (d) -> 


#### Gauge

Displaying a value produced within a set range. Optionally pass in markers to display baselines, averages, or other comparisons.

    props:
        data: [
            type: ['value', 'marker'] # value of the gauge or a marker
            value: Int
            label: String
        ]
        options:
            min: Int
            max: Int
            start_angle: rad
            end_angle: rad

            # Display the value as a number in the middle of the gauge
            show_value: Boolean

            # Don't show lighter guide filling in entirety of gauge
            guide:
                hidden: Boolean
            bar:
                radius: Int
                thickness: int
            # Padding around the gauge to give space for marker labels
            label_padding: Int


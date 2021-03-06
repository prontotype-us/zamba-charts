# Zamba Charts

## General Components

### Legend

    props:
        className: String
        data: [
            color: String
            label: String
        ]

### XAxis

```coffee
props:
    x: d3.scale
    position: 'bottom' | 'top'
    format: FormatFunction
    hidden: Boolean
    ticks: Int # Number of ticks to render
    label: String # Label the axis and / or add units
    labels: # Dictionary of custom labels to put at the given axis values
        Int: String
```

### YAxis

```coffee
props:
    y: d3.scale
    position: 'left' | 'right'
    format: FormatFunction
    hidden: Boolean
    zero: Boolean # Start axis domain at 0
    ticks: Int # Number of ticks to render
    label: String # Label the axis and / or add units
    label_values: # Dictionary of custom labels to put at the given axis values
        Int: String
```

### Follower

Overlay that follows the mouse position to display points on a given line or bar graph.

```coffee
props:
    format: FormatFunction
    color: ColorFunction
```

## Chart Types

Every Chart has `height` and `width` in its props. You can also override the default x and y axes (scaled 0 to the axis' maximum value) by passing a configured d3 scale `x` or `y` into props. You can also pass in `color`, or do this on each respective datapoint. Decorate your data with color based off of a color key while you are slicing it into series and/or configuring the legend.

Some chart types allow you to flip horizontally, which transforms the data, SVG rendering functions, and labels between axes.

You can also pass in `onClick`, a function of one entry of `data`, to be triggered when a slice, bar, line, or scatter plot element for a datapoint is clicked.

### ChartMixin

A mixin for rendering a chart, resizing it, and managing rendering of axes and followers.

```coffee
props:
    title: String
    width: Int
    height: Int
    axis_size: Int
    padding: Int | {left: Int, right: Int, top: Int, bottom: Int}
    color: String | (String) -> String
    follower: Bool | Options # Passed to Follower as props
    x: d3.scale
    y: d3.scale
    x_axis: # Passed to XAxis as props
    y_axis: # Passed to YAxis as props
```

### BarChart

Bar chart to display counts (range) over discrete values or bins of a domain.

```coffee
props:
    data: [
        x: Number
        y: Number
    ]
```

## Histogram

```coffee
props:
    data: [
        x: Number
        y: Number
    ]
    n_bins: Int
    group_key: String | (String) -> String
```

### Labeled Bar

Histogram chart to display counts over a set of labeled bins.

    props:
        data: [
            y: Int
            label: String
        ]
        bar_padding: Int


### LineChart

```coffee
props:
    data: [
        x: Number
        y: Number
    ]
    curve: Boolean
    fill: Boolean
```

### MultiLineChart

```coffee
props:
    data: [
        [
            x: Number
            y: Number
        ]
    ]
    curve: Boolean
    fill: Boolean
```

### Scatter

    props:
        fill: String #color
        data: [
            x: Int
            y: Int
        ]
        options:
            renderPoint: (d) -> <PointComponent />

### Pie

    props:
        data: [
            label: String
            count: Int
        ]
        onClick: (d) -> 


### Gauge

Displaying a value produced within a set range. Optionally pass in markers to display baselines, averages, or other comparisons. Override the default range of 0 to 100 with `options.{min, max}`. You can also pass in options to configure `start_angle` and `end_angle`. Default is 12 o clock, or 0 radians.

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


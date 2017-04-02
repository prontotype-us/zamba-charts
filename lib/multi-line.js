// Generated by CoffeeScript 1.10.0
var Chart, MultiLineChart, React, d3, helpers;

React = require('react');

d3 = require('d3');

Chart = require('./chart');

helpers = require('./helpers');

module.exports = MultiLineChart = React.createClass({displayName: "MultiLineChart",
  mixins: [Chart],
  multi: true,
  renderChart: function() {
    var color, curve, data, fill, height, line, ref, ref1, width, x, y;
    ref = this.props, width = ref.width, height = ref.height, data = ref.data, curve = ref.curve, fill = ref.fill, color = ref.color;
    ref1 = this.state, x = ref1.x, y = ref1.y;
    console.log('[MultiLineChart.render] data=', data);
    line = d3.line().curve(curve ? d3.curveMonotoneX : d3.curveLinear).x(function(d) {
      return x(d.x);
    }).y(function(d) {
      return y(d.y);
    });
    return React.createElement("svg", {
      "className": 'line-chart',
      "style": {
        width: width,
        height: height,
        position: 'absolute',
        top: 0
      }
    }, data.map(function(data, di) {
      var d, da, first_point, last_point;
      d = line(data);
      return React.createElement("g", {
        "key": di
      }, (fill ? (first_point = {
        x: x.domain()[0],
        y: y.domain()[0]
      }, last_point = {
        x: x.domain()[1],
        y: y.domain()[0]
      }, da = line([first_point].concat(data).concat([last_point])), React.createElement("path", {
        "d": da,
        "fill": helpers.interpretColor(color, di),
        "opacity": 0.2,
        "stroke": 'none'
      })) : void 0), React.createElement("path", {
        "d": d,
        "fill": 'none',
        "stroke": helpers.interpretColor(color, di),
        "strokeWidth": 2
      }));
    }));
  }
});
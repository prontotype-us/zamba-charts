// Generated by CoffeeScript 1.8.0
var Chart, MultiLineChart, React, d3, helpers,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

React = require('react');

d3 = require('d3');

Chart = require('./chart');

helpers = require('./helpers');

module.exports = MultiLineChart = (function(_super) {
  __extends(MultiLineChart, _super);

  function MultiLineChart() {
    return MultiLineChart.__super__.constructor.apply(this, arguments);
  }

  MultiLineChart.prototype.multi = true;

  MultiLineChart.prototype.renderChart = function() {
    var color, curve, data, fill, height, line, width, x, y, _ref, _ref1;
    _ref = this.props, width = _ref.width, height = _ref.height, data = _ref.data, curve = _ref.curve, fill = _ref.fill, color = _ref.color;
    _ref1 = this.state, x = _ref1.x, y = _ref1.y;
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
        "fill": helpers.interpretColor(color, data),
        "opacity": 0.2,
        "stroke": 'none'
      })) : void 0), React.createElement("path", {
        "d": d,
        "fill": 'none',
        "stroke": helpers.interpretColor(color, data),
        "strokeWidth": 2
      }));
    }));
  };

  return MultiLineChart;

})(Chart);

// Generated by CoffeeScript 1.10.0
exports.ChartMixin = {
  shouldComponentUpdate: function(next_props, next_state) {
    if (next_props.data.length !== this.props.data.length) {
      return true;
    }
    if (next_props.data.length !== this.props.data.length) {
      return true;
    } else if ((next_props.width !== this.props.width) || (next_props.height !== this.props.height)) {
      return true;
    } else if ((next_props.y !== this.props.y) || (next_props.x !== this.props.x)) {
      return true;
    } else {
      return false;
    }
  }
};
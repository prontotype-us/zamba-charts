React = require 'react'

module.exports = Legend = ({data, className=''}) ->
    <div className="legend  #{className}">
        {data.map (d, j) ->
            <div key=j className="legend-entry">
                <div className='legend-swatch' style={{background: d.color}}></div>
                <div className='legend-key'>{d.label}</div>
            </div>
        }
    </div>

module.exports = (ds, n_bins=20) ->
    data = []

    ds.sort (a, b) -> a.x - b.x
    x0 = ds[0].x
    x1 = ds.slice(-1)[0].x
    dt = (x1 - x0) / n_bins

    bin_i = 0
    bin_count = 0

    for bin_i in [0...n_bins]
        for d in ds
            if d.x > x0 + dt * (bin_i + 1)
                break
            else
                bin_count += (d.y or 1)

        data.push {x: bin_i, y: bin_count}
        ds = ds.slice(bin_count)
        bin_count = 0

    return data


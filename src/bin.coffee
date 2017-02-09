module.exports = (xs, n_bins=20) ->
    data = []

    xs.sort (a, b) -> a - b
    x0 = xs[0]
    x1 = xs.slice(-1)[0]
    dt = (x1 - x0) / n_bins

    bin_i = 0
    bin_count = 0
    data.push {x: -1, y: 0}

    for bin_i in [0..n_bins]
        for x in xs
            if x > x0 + dt * (bin_i + 1)
                break
            else
                bin_count += 1

        data.push {x: bin_i, y: bin_count}
        xs = xs.slice(bin_count)
        bin_count = 0

    return data


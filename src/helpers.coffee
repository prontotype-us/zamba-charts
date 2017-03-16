add = (a, b) -> a + b

sum = (numbers) ->
    numbers.reduce add, 0

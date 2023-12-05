const words = ["one","two","three","four","five",
               "six","seven","eight","nine"]

const word2int = Dict(words .=> 1:9)

function digitize(d)
    i = tryparse(Int, d)
    if isnothing(i)
        return word2int[d]
    else
        return i
    end
end

function solve(regex)
    return sum(eachline("input.txt")) do line
        matches = eachmatch(regex, line; overlap=true) |> collect
        fdigit = digitize(first(matches).match)
        ldigit = digitize(last(matches).match)
        parse(Int, "$fdigit$ldigit")
    end
end

part1() = solve(r"\d")
part2() = solve(Regex("\\d|" * join(words, "|")))

function main()
    part1() |> println
    part2() |> println
end

isinteractive() || main()

# data structures

struct Rules
    red::Int
    green::Int
    blue::Int
end

mutable struct Round
    red::Int
    green::Int
    blue::Int
end

struct Game
    id::Int
    rounds::Vector{Round}
end

id(game::Game) = game.id

# parsing

parseid(line::String) =
    parse(Int, match(r"\d.*", first(split(line, ":"))).match)

function parserounds(line::String)
    rds = last(split(line, ":"))
    rds = split(rds, ";")
    map(rds) do rd
        round = Round(0,0,0)
        colors = split(rd, ",")
        for c in colors
            count, color = split(strip(c))
            count = parse(Int, count)
            setfield!(round, Symbol(color), count)
        end
        round
    end
end

parsegame(line) = Game(parseid(line), parserounds(line))
read(file) = map(parsegame, eachline(file))

# playing the game

function ispossible(game::Game, rule::Rules) 
    return mapreduce(&, game.rounds) do round
        round.red <= rule.red &&
        round.blue <= rule.blue &&
        round.green <= rule.green
    end
end
ispossible(rules::Rules) = game -> ispossible(game, rules)

play1(games::Vector{Game}, rules::Rules) = 
    sum(id, filter(ispossible(rules), games))

play2(games::Vector{Game}) = sum(play2, games)
play2(game::Game) =
    prod(maximum(r -> getfield(r, f), game.rounds) for f in [:red, :blue, :green])        

function main()
    games = read("input.txt")
    rules = Rules(12, 13, 14)
    play1(games, rules) |> println
    play2(games) |> println
end

isinteractive() || main()

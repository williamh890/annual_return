module AnnualReturn


struct StockHistory
    year::Int
    stocks::Float64
    bonds::Float64
    treasuries::Float64
end


struct Strategy
    yearly_addition::Float64
    stocks::Float64
    bonds::Float64
    treasuries::Float64
end


function from_csv(file_path; runs=1000)
    raw_yearly_averages = load_csv_data(file_path)

    yearly_averages = to_model(raw_yearly_averages)

    strat = Strategy(3600., .5, .5, 0.)

    stocks = linspace(0., 1., 11)
    bonds = linspace(1., 0., 11)

    strats = [
       Strategy(3600., dist[1], dist[2], 0.) for
       dist=zip(stocks, bonds)
    ]

    for strat in strats
        returns = []
        for _ in 1:runs
            calculated = calc_return(yearly_averages, strat)
            push!(returns, calculated)
        end

        strat_str = "$(@sprintf("%.2f", strat.stocks)) $(@sprintf("%.2f", strat.bonds)):"
        result_str = " Mean $(@sprintf("%.2f", mean(returns))), Middle $(@sprintf("%.2f", middle(returns)))"
        println(strat_str * result_str)
    end
end


function calc_return(yearly_averages, strat; num_years=40)
    total = 0

    for _ in 1:num_years
        random_year = rand(yearly_averages)

        total += strat.yearly_addition

        distribution = [
             total * strat.stocks * random_year.stocks,
             total * strat.bonds * random_year.bonds,
             total * strat.treasuries * random_year.treasuries
        ]

        total += sum(distribution)
    end

    total
end


function load_csv_data(file_path::String)
    history = []

    open(file_path, "r") do f
        for line in eachline(f)
            data = split(line, ",")
            push!(history, data)
        end
    end

    history
end


to_model(raw_data) = map(get_year_from, raw_data)


function get_year_from(raw_year)
    year, stocks, treasuries, bonds = raw_year[2:end]

    year = parse(Int, year)

    parse_percentage(str) = parse(Float64, str[1:end-1]) / 100

    treasuries = parse_percentage(treasuries)
    bonds = parse_percentage(bonds)
    stocks = parse_percentage(stocks)

    StockHistory(year, stocks, bonds, treasuries)
end

end # AnnualReturn

push!(LOAD_PATH, ".")


module AnnualReturn

using Plots
import StockModels


function from_csv(file_path; runs=100000)
    raw_yearly_averages = load_csv_data(file_path)

    yearly_averages = to_model(raw_yearly_averages)

    stocks = linspace(0., 1., 22)
    bonds = linspace(1., 0., 22)

    strats = [
       StockModels.Strategy(3600., stock_amount, bond_amount, 0.) for
       (stock_amount, bond_amount)=zip(stocks, bonds)
    ]

    averages, devs = [], []
    for strat in strats
        returns = map(_ -> calc_return(yearly_averages, strat), 1:runs)

        rets_avg = mean(returns)

        strat_str = "$(@sprintf("%.2f", strat.stocks)) $(@sprintf("%.2f", strat.bonds)):"
        result_str = " Mean $(@sprintf("%.2f", rets_avg)), Std $(@sprintf("%.2f", std(returns)))"

        println(strat_str * result_str)

        push!(averages, rets_avg)
        push!(devs, std(returns))
    end

    plotly()
    plot([averages, devs], linewidth=2, label=["Mean" "Std Dev"])
    plot!(title="Return over 40 years")
    gui()
end


function calc_return(yearly_averages, strat; num_years=40)
    total = 0
    yearly_averages_pool = copy(yearly_averages)

    for _ in 1:num_years
        random_year = rand(yearly_averages_pool)

        total += strat.yearly_addition

        total += sum(total * [
             strat.stocks * random_year.stocks,
             strat.bonds * random_year.bonds,
             strat.treasuries * random_year.treasuries
        ])
    end

    total - (num_years * strat.yearly_addition)
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

    StockModels.StockHistory(year, stocks, bonds, treasuries)
end

end # AnnualReturn

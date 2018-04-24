module AnnualReturn

calc(x) = x * 10

struct StockHistory
    year::Int
    stocks::Float64
    bonds::Float64
    treasuries::Float64
end

function from_csv(file_path)
    raw_yearly_averages = load_csv_data(file_path)

    yearly_averages = to_model(raw_yearly_averages)

    println(yearly_averages[1])
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

function to_model(raw_data)
    years = []

    for raw_year in raw_data
        push!(years, get_year_from(raw_year))
    end

    years
end

function get_year_from(raw_year)
    year, stocks, treasuries, bonds = raw_year[2:end]

    year = parse(Int, year)

    treasuries = parse(Float64, treasuries[1:end-1])
    bonds = parse(Float64, bonds[1:end-1])
    stocks = parse(Float64, stocks[1:end-1])

    StockHistory(year, stocks, bonds, treasuries)
end

end # AnnualReturn

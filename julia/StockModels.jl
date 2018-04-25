module StockModels

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

end

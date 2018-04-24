include("annual_return.jl")

import AnnualReturn

function main()
    AnnualReturn.from_csv("historical_data.csv")
end


main()



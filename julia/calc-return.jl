push!(LOAD_PATH, ".")

import AnnualReturn

function main()
    println("Calculating Return Using Monete Carlo")
    AnnualReturn.from_csv("../historical_data.csv")
end


main()



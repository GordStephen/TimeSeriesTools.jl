using MarketData

facts("Data quality checks") do

    cl_incomplete = TimeArray(cl.timestamp[1:5], [cl.values[1:4]; NaN], cl.colnames)

    context("Determine uniformity of observations") do
        @fact cl[1:5]                         --> is_equally_spaced 
        @fact cl[1:10]                        --> not(is_equally_spaced)
        @fact require_equally_spaced(cl[1:5]) --> nothing
        @fact_throws require_equally_spaced(cl[1:10])
    end

    context("Determine completeness of data") do
        @fact cl[1:5]                         --> is_equally_spaced 
        @fact cl[1:10]                        --> not(is_equally_spaced)
        @fact require_equally_spaced(cl[1:5]) --> nothing
        @fact_throws require_equally_spaced(cl[1:10])
    end

    context("Determine cleanliness of data") do
        @fact cl[1:5]                 --> is_clean 
        @fact cl[1:10]                --> not(is_clean)
        @fact cl_incomplete           --> not(is_clean)
        @fact require_clean(cl[1:5])  --> nothing
        @fact_throws require_clean(cl[1:10])
        @fact_throws require_clean(cl_incomplete)
    end
    
end



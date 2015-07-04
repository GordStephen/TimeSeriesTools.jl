module TimeSeriesTools

using TimeSeries

export  is_equally_spaced, is_complete, is_clean,
        require_equally_spaced, require_complete, require_clean,
        plot, histogram, density,
        directedscatter, laghistogram, acf, pacf, ccf,
        cumulative_periodogram

include("data_quality.jl")
include("visualizations.jl")
include("stat_tests.jl")

end # module

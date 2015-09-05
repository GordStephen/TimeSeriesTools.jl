using MarketData

facts("Visualizations") do

    context("Raw data visualizations") do
        plot(cl)
        plot(ohlc)
        histogram(cl)
        density(cl)
    end

    context("Serial correlation visualizations") do
        directedscatter(cl[1:5])
        @fact_throws directedscatter(cl)
        directedscatter(cl, naive=true)
        directedscatter(cl, naive=true, nlags=2)

        laghistogram(cl[1:5])
        @fact_throws laghistogram(cl)
        laghistogram(cl, naive=true)
        laghistogram(cl, naive=true, nlags=2)

        @fact_throws acf(cl[1:5], lags=1:10)
        acf(cl[1:5], lags=1:3)
        @fact_throws acf(cl)
        acf(cl, naive=true)
        acf(cl, naive=true, lags=1:5)

        @fact_throws pacf(cl[1:5], lags=1:10)
        pacf(cl[1:5], lags=1:2)
        @fact_throws pacf(cl)
        pacf(cl, naive=true)
        pacf(cl, naive=true, lags=1:10)

        @fact_throws ccf(ohlc["Open", "Close"][1:5])
        ccf(ohlc["Open", "Close"][1:5], lags=-1:1)
        @fact_throws ccf(ohlc["Open", "Close"])
        ccf(ohlc["Open", "Close"], naive=true)
        ccf(ohlc["Open", "Close"], naive=true, lags=-5:5)

    end

    context("Spectral analysis") do
        cumulative_periodogram(cl[1:5]) 
        @fact_throws cumulative_periodogram(cl) 
        cumulative_periodogram(cl, naive=true) 
    end
    
end



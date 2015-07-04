using Gadfly, StatsBase, DSP
import Gadfly.plot, StatsBase.pacf

colorscale = Scale.color_discrete_hue()

function buildlayers(f::Function, colnames, colors)
  [f(coln, colr) for (coln, colr) in zip(colnames, colors)]
end #buildlayers

# Raw data visualization

function plot(ta::TimeArray; subplots=false, title="")
  subplots ? error("Subplotting not yet supported") :
  linecolors = colorscale.f(length(ta.colnames))
  layers = buildlayers(ta.colnames, linecolors) do coln, colr
    layer(x=ta.timestamp, y=ta[coln].values, Geom.line, Theme(default_color=colr))
  end
  plot(layers..., Guide.xlabel(""), Guide.ylabel(""), Guide.title(title), Guide.manual_color_key("", ta.colnames, linecolors))
end #plot

function histogram(ta::TimeArray; subplots=false, title="")
  subplots ? error("Subplotting not yet supported") :
  linecolors = colorscale.f(length(ta.colnames))
  layers = buildlayers(ta.colnames, linecolors) do coln, colr
    layer(x=ta[coln].values, Geom.histogram, Theme(default_color=colr))
  end
  plot(layers..., Guide.xlabel(""), Guide.ylabel("Counts"), Guide.title(title), Guide.manual_color_key("", ta.colnames, linecolors))
end #hist

function density(ta::TimeArray; subplots=false, title="")
  subplots ? error("Subplotting not yet supported") :
  linecolors = colorscale.f(length(ta.colnames))
  layers = buildlayers(ta.colnames, linecolors) do coln, colr
    layer(x=ta[coln].values, Geom.density, Theme(default_color=colr))
  end
  plot(layers..., Guide.xlabel(""), Guide.ylabel("Probability Density"), Guide.title(title), Guide.manual_color_key("", ta.colnames, linecolors))
end # density

# Serial correlation & cross-correlation visualization

function directedscatter(ta::TimeArray; naive=false, subplots=false, nlags=1, title="")
  naive || require_clean(ta)
  subplots ? error("Subplotting not yet supported") :
  linecolors = colorscale.f(length(ta.colnames))
  layers = buildlayers(ta.colnames, linecolors) do coln, colr
    layer(x=lag(ta[coln], nlags).values, y=ta[coln].values[nlags+1:end], Geom.line(preserve_order=true), Theme(default_color=colr))
  end
  plot(layers..., Guide.xlabel("t-"*string(nlags)), Guide.ylabel("t"), Guide.title(title), Guide.manual_color_key("", ta.colnames, linecolors))
end # directedscatter

function laghistogram(ta::TimeArray; naive=false, nlags=1, title="")
  naive || require_clean(ta)
  length(ta.colnames) > 1 ? error("Subplotting not yet supported. Use a single-column TimeArray.") :
  plot(
    x=lag(ta, nlags).values, y=ta.values[nlags+1:end], Geom.histogram2d,
    Guide.xlabel("t-"*string(nlags)), Guide.ylabel("t"), Guide.title(title)
  )
end # laghistogram

function acf(ta::TimeArray; naive=false, lags=1:30)
  naive || require_clean(ta)
  length(ta.colnames) > 1 ? error("Subplotting not yet supported. Use a single-column TimeArray.") :
  conf_int = 1.96 / sqrt(length(ta))
  plot(x=lags, y=autocor(ta.values, lags), xmin=collect(lags)-.1, xmax=lags, yintercept=[-conf_int, +conf_int], Geom.bar, Geom.hline(color="orange"), Scale.y_continuous(minvalue=-1, maxvalue=1), Guide.xlabel("lags"), Guide.ylabel(""), Guide.title(ta.colnames[1]*" ACF"))
end # acf

function pacf(ta::TimeArray; naive=false, lags=1:30)
  naive || require_clean(ta)
  length(ta.colnames) > 1 ? error("Subplotting not yet supported. Use a single-column TimeArray.") :
  conf_int = 1.96 / sqrt(length(ta))
  plot(x=lags, y=pacf(ta.values, lags), xmin=collect(lags)-.1, xmax=lags, yintercept=[-conf_int, +conf_int], Geom.bar, Geom.hline(color="orange"), Scale.y_continuous(minvalue=-1, maxvalue=1), Guide.xlabel("lags"), Guide.ylabel(""), Guide.title(ta.colnames[1]*" PACF"))
end # pacf

function ccf(ta::TimeArray; naive=false, lags=-15:15)
  naive || require_clean(ta)
  length(ta.colnames) != 2 ? error("`ccf` requires a 2-column TimeArray") :
  conf_int = 1.96 / sqrt(length(ta))
  plot(x=lags, y=crosscor(ta[ta.colnames[1]].values, ta[ta.colnames[2]].values, lags), xmin=collect(lags)-.1, xmax=lags, yintercept=[-conf_int, +conf_int], Geom.bar, Geom.hline(color="orange"), Scale.y_continuous(minvalue=-1, maxvalue=1), Guide.xlabel("lags"), Guide.ylabel(""), Guide.title(ta.colnames[1]*", "*ta.colnames[2]*" CCF"))
end # ccf

# Spectral analysis

function cumulative_periodogram(ta::TimeArray; naive=false)
  naive || require_clean(ta)
  length(ta.colnames) > 1 ? error("Subplotting not yet supported. Use a single-column TimeArray.") :
  p = periodogram(ta.values)
  plot(x=freq(p), y=cumsum(power(p)), Geom.line, Guide.xlabel("Frequency"), Guide.ylabel("Cumulative Power"), Guide.title(ta.colnames[1]*" Cumulative Periodogram"))
end # cumulatve_periodogram


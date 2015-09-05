function is_equally_spaced(ta::TimeArray)
  timediffs = ta.timestamp[2:end] - ta.timestamp[1:end-1]
  all(timediffs .== timediffs[1])
end # is_equally_spaced 

require_equally_spaced(ta::TimeArray) = is_equally_spaced(ta) ? nothing : error("
  Time series observations are not eqally spaced") 

is_complete(ta::TimeArray) = !any(isnan(ta.values))

require_complete(ta::TimeArray) = is_complete(ta) ? nothing : error("
  Time series has missing values")

is_clean(ta::TimeArray) = is_equally_spaced(ta) && is_complete(ta)

require_clean(ta::TimeArray) = is_clean(ta) ? nothing : error("
  Time series has missing or unequally spaced values")


-- rebind alerting to only show one alert at a time.
do
  local originalAlertShow = hs.alert.show
  local lastAlert
  hs.alert.show = function(...)
    if lastAlert then hs.alert.closeSpecific(lastAlert) end
    lastAlert = originalAlertShow(...)
    return lastAlert
  end
end

hs.urlevent.bind("showAlert", function(eventName, params)
  hs.alert.show(params["message"])
end)

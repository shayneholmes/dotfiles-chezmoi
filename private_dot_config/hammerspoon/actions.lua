local actions = {}

-- make a set from a table
local function Set(list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end

-- map a function to an array (convenience)
local function map(func, array)
  local new_array = {}
  for i,v in ipairs(array) do
    new_array[i] = func(v)
  end
  return new_array
end

local printwindow = function(w)
  return ("%s"):format(w:title())
end

local activateOrSwitchWindow = function(app)
  if not app:isFrontmost() then
    app:activate()
    return
  end

  -- switch windows
  -- this should behave something like cmd-backtick
  -- so just use cmd-backtick!
  hs.eventtap.keyStroke({"cmd"},"`",0) -- no delay makes this snappier
end

-- launch an app if running; hit the button again to get a non-running app started
local activateOrLaunchIfRunTwice
do
  local delaySecs = 2 -- how long can elapse between two key activations to count as "again"?
  -- state shared across invocations
  local waitingName
  local timer

  activateOrLaunchIfRunTwice = function(app)
    local isFirstInvocation = not (waitingName == app.name)
    waitingName = nil

    -- activate it if it's already open
    local activeApp = hs.application.get(app.activeWindow)
    if activeApp then
      return activateOrSwitchWindow(activeApp)
    end

    -- not running; save this key for a couple seconds
    waitingName = app.name
    if timer then timer:stop() end
    timer = hs.timer.doAfter(delaySecs, function() waitingName = nil end)

    -- not running, and the first time hitting the key
    if isFirstInvocation then
      hs.alert.show(("%s is not runnning. Tap again to launch."):format(app.name))
      return
    end

    -- not running, but the key was hit again, so go ahead and launch it
    hs.alert.show(("Launching %s..."):format(app.name))
    -- give time for the alert to show before we actually launch the app; launching seems to be synchronous and will block the alert
    hs.timer.doAfter(0.25, function() hs.application.open(app.appId) end)
  end
end

-- `app` is either a string (specifying `name`) or a table with the following values:
--   `name` (required): The name of the app. Displayed in user-facing prompts.
--   `appId` (optional): The name of the package to run to start the app. If not specified, this will be set to `name`.
--   `activeWindow` (optional): The name of the app's main window when running. If not specified, this will be set to `appId`.
actions.app = function(app)
  if type(app) == "string" then
    app = {name = app}
  end
  if not app.appId then
    app.appId = app.name
  end
  if not app.activeWindow then
    app.activeWindow = app.appId
  end
  return activateOrLaunchIfRunTwice(app)
end

actions.reload = hs.reload

actions.sneakypaste = function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end

actions.addtask = function()
  local lastActiveWindow = hs.window.focusedWindow()
  hs.focus() -- works fine as long as the console isn't open
  local button, text = hs.dialog.textPrompt("Add todo", "", "", "OK", "Cancel")
  if button == "OK" and text ~= "" then
    text = text:gsub("'", "'\"'\"'")
    local command = ("/opt/homebrew/bin/todo.sh add '%s'"):format(text)
    local output, status = hs.execute(command)
    if status ~= true then
      hs.alert.show(("Got error: %s"):format(output))
    end
  end
  local windowToFocus = hs.window.orderedWindows()[1]
  local frontmostWindow = hs.window.frontmostWindow()
  if frontmostWindow ~= windowToFocus then
    hs.alert.show(("Focusing on %s, but frontmost was %s"):format(windowToFocus:application():name(), frontmostWindow:application():name()))
  end
  windowToFocus:focus()
end

local expectedGlobals = Set{
  "string",
  "collectgarbage",
  "setmetatable",
  "pcall",
  "ls",
  "os",
  "table",
  "select",
  "getmetatable",
  "assert",
  "math",
  "dofile",
  "rawlen",
  "spoon",
  "io",
  "utf8",
  "ipairs",
  "package",
  "print",
  "rawrequire",
  "_G",
  "pairs",
  "audiodevices",
  "help",
  "hs",
  "type",
  "rawset",
  "debug",
  "loadfile",
  "load",
  "coroutine",
  "require",
  "rawget",
  "error",
  "next",
  "xpcall",
  "rawequal",
  "tostring",
  "tonumber",
}
actions.printglobals = function()
  local vars = {}
  for n,v in pairs(_G) do
    if not expectedGlobals[n] then
      vars[#vars+1] = n
    end
  end
  print(("Unexpected global variables:\n%s"):format(table.concat(vars,"\n")))
end

actions.toggleTextExpansion = function()
  if spoon.TextExpansion:isEnabled() then
    spoon.TextExpansion:stop()
    hs.alert.show("Text expansion disabled.")
  else
    spoon.TextExpansion:start()
    hs.alert.show("Text expansion enabled.")
  end
end

local timer = require("timer")
actions.timer = function(name)
  return timer.startTimer(name)
end

local internaltimer = require("internaltimer")
actions.internaltimer = function()
  local fn = function()
    hs.notify.new(
      nil,
      {
        title = "Timer over!",
        informativeText = "",
      }
      ):send()
  end
  return internaltimer.startTimer(fn)
end

actions.testAlert = function() hs.alert.show("test successful") end

actions.screensaver = function()
  hs.alert.show("Locking...")
  hs.timer.doAfter(0.5, function()
    hs.caffeinate.startScreensaver()
  end)
end

actions.refreshbitbar = function() hs.execute("open -g 'xbar://app.xbarapp.com/refreshAllPlugins'") end

actions.noop = function()
  hs.alert.show("No-op'ed")
end

return actions

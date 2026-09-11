local start = os.clock()
hs.loadSpoon("TextExpansion")
-- spoon.TextExpansion:setDebug(true)

--[[
-- Return a thunk that will format the given date offset when evaluated.
--
-- This guarantees that the date will be fresh, even if this function was
-- called initially on a different date.
--]]
local formatDate = function(format, offsetDays)
  if not offsetDays then
    offsetDays = 0
  end
  local offsetValue = ""
  if offsetDays >= 0 then
    offsetValue = "+" .. offsetDays
  else
    offsetValue = offsetDays -- negative numbers come with a direction
  end
  local offset = "-v " .. offsetValue .. "d"
  local command = "date " .. offset .. ' +"'.. format .. '"'
  return function()
    return hs.execute(command):gsub("\n","")
  end
end

local DATE_FORMAT_ISO = "%F" -- "2019-01-16"
local DATE_FORMAT_ISO_BRACKETS = "[%F]" -- "[2019-01-16]"
local DATE_FORMAT_LONG_TEXT = "%A, %-e %B %Y" -- "Wednesday, 16 January 2019"
local DATE_FORMAT_ISO_TIME = "%FT%T" -- "2019-01-16T08:12:09"
local DATE_FORMAT_SHORT = "%-m/%-e" -- "1/16"

local date_expansions = {}

--[[
-- Dynamic timestamp offsets
--
-- Syntax: <offset>ts, <offset>td
-- <offset> [-7..30]: Number of days to skip
--
-- Examples:
-- '-7ts': 2019-08-07
-- '14td': Wednesday, 28 August 2019
--]]
do
  local EARLIEST = -70
  local LATEST = 365
  for i = EARLIEST, LATEST do
    date_expansions[i .. "ts"] = formatDate(DATE_FORMAT_ISO, i)
    date_expansions[i .. "td"] = formatDate(DATE_FORMAT_LONG_TEXT, i)
    date_expansions[i .. "tn"] = formatDate(DATE_FORMAT_SHORT, i)
  end
end

--[[
-- Dynamic day-of-week timestamps
--
-- Syntax: [<range>]<day-of-week>ts
-- <range> [-5..52]: Number of weeks to skip
-- <day-of-week>: Day of the week (see DAY_CODES)
--
-- Examples:
-- 'mts': the upcoming Monday.
-- '6sats': the Saturday coming six weeks from this one.
--]]
local DAY_CODES = {"m", "t", "w", "th", "f", "sa", "su"}
local LEAST_WEEKS = -5
local MOST_WEEKS = 52

local formatDateOfWeek = function(format, targetWeekDay, weeksToSkip)
  return function()
    local currentWeekDayRes = hs.execute("date +%u") -- [1..7, 1 is Monday]
    local currentWeekDay = tonumber(currentWeekDayRes)
    local daysUntilNextTargetWeekDay = (targetWeekDay - currentWeekDay) % 7 -- [0..6]
    if weeksToSkip >= 0 and daysUntilNextTargetWeekDay == 0 then
      -- Edge case: Asking for the next Monday on Monday should return a week
      -- away, not today. This applies to only non-negative weeks to skip:
      -- Asking for last Monday on a Monday should return the previous week's
      -- Monday.
      daysUntilNextTargetWeekDay = 7
    end
    local offsetDays = daysUntilNextTargetWeekDay + weeksToSkip * 7
    return formatDate(format, offsetDays)()
  end
end

do
  for weeks = LEAST_WEEKS, MOST_WEEKS do
    local prefix = ""
    if weeks ~= 0 then prefix = weeks end
    for dayIndex = 1, #DAY_CODES do
      date_expansions[prefix .. DAY_CODES[dayIndex] .. "ts"] =
        formatDateOfWeek(DATE_FORMAT_ISO, dayIndex, weeks)
      date_expansions[prefix .. DAY_CODES[dayIndex] .. "td"] =
        formatDateOfWeek(DATE_FORMAT_LONG_TEXT, dayIndex, weeks)
      date_expansions[prefix .. DAY_CODES[dayIndex] .. "tn"] =
        formatDateOfWeek(DATE_FORMAT_SHORT, dayIndex, weeks)
    end
  end
end

-- abbreviations that are applied immediately. If they are prefixes of another
-- abbrevation, the other abbreviation will be impossible to type!
local immediate_expansions = {
  [";c;"] = "©",
  [";r;"] = "®",
  [";^;"] = "⇑",
  [";v;"] = "⇓",
  [";=>;"] = "⇒",
  [";<=;"] = "⇐",
  [";->;"] = "→",
  [";<-;"] = "←",
  [";?!;"] = "‽", -- interrobang
  [";ge;"] = "≥",
  [";le;"] = "≤",
  [";--;"] = "—",
  [";~=;"] = "≈", -- approx. equal
  [";md;"] = "—", -- emdash
  [";nd;"] = "–", -- endash
  [";cmd;"] = "⌘",
  [";bike;"] = "🚲",
  [";deg;"] = "°",
  [";div;"] = "÷",
  [";divide;"] = "÷",
  [";negative;"] = "−",
  [";neg;"] = "−", -- math minus
  [";minus;"] = "−", -- math minus
  [";key;"] = "🔑",
  [";.;"] = "·", -- interpunct
  [";shrug;"] = "¯\\_(ツ)_/¯",
  [";+1;"] = "👍",
  [";tu;"] = "👍", -- thumbs up
  [";grim;"] = "😬",
  [";check;"] = "✅",
  [";tada;"] = "🎉",
  [";tflip;"] = "(╯°□°）╯︵ ┻━┻",
  [";times;"] = "×",
  [";mult;"] = "×",
  [";tm;"] = "™",

  -- deadkeys for Spanish
  ["~n"] = "ñ",
  ["'a"] = "á",
  ["'e"] = "é",
  ["'i"] = "í",
  ["'o"] = "ó",
  ["'u"] = "ú",
  [":u"] = "ü", -- sideways diaeresis
  ["''u"] = "ü", -- double dots
  ["'!"] = "¡",
  ["'?"] = "¿",
}

local expansions = {
  ["/yd"] = {
    expansion = "",
    backspace = false,
    internal = true,
  },
  ["]d"] = formatDate(DATE_FORMAT_ISO_TIME),
  -- btw = "by the way",
  -- lgtm = { expansion = "Looks good to me", matchcase = false},
  rcgnth = function() hs.alert.show("Testing...") end,
  tb = formatDate(DATE_FORMAT_ISO_BRACKETS),
  td = formatDate(DATE_FORMAT_LONG_TEXT),
  tn = formatDate(DATE_FORMAT_SHORT),
  [".ts"] = { -- ignore ts files
    expansion = "",
    backspace = false,
    internal = true,
  },
  ts = formatDate(DATE_FORMAT_ISO), -- timestamp
  tt = formatDate(DATE_FORMAT_ISO_TIME), -- timestamp, with time
  yts = formatDate(DATE_FORMAT_ISO, -1), -- yesterday timestamp
  yd = formatDate(DATE_FORMAT_LONG_TEXT, -1), -- yesterday day
  sb = "[Shayne]", -- tb but with s for my name
  segun = "según",
}

for k,v in pairs(date_expansions) do expansions[k] = v end
for k,v in pairs(immediate_expansions) do expansions[k] = { expansion = v, internal = true, waitforcompletionkey = false, sendcompletionkey = false } end

local function script_path()
  local str = debug.getinfo(2, "S").source:sub(2)
  return str:match("(.*/)")
end
local after_expansions_thunk, err = loadfile(script_path() .. "abbreviations.lua.after")

if after_expansions_thunk then
  for k,v in pairs(after_expansions_thunk()) do expansions[k] = v end
else
  print(("Error\n%s"):format(err))
end

spoon.TextExpansion:setExpansions(expansions)

-- spoon.TextExpansion:setDebug(true)
spoon.TextExpansion:start()

local fin = os.clock()
print(("Finished loading textExpansion in %f seconds"):format(fin-start))

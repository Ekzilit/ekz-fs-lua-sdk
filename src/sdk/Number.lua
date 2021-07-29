package "sdk"
import "sdk.Object"
import "sdk.String"
public.class("Number", Object) {

  public.static.final.method("is", function(value)
    return type(value) == "number" and true or false
  end);

  public.static.method("isEmpty", function(str)
    return str == nil or str == ""
  end);

  public.static.method("findLastIndex", function(str, pattern)
    local i, j
    local k = 0
    repeat
      i = j
      j, k = string.find(str, pattern, k + 1, true)
    until j == nil
    return i
  end);

  public.static.method("round", function(num, numDecimalPlaces)
    num = tonumber(num) or 0
    local mult = 10 ^ (numDecimalPlaces or 0)
    if num >= 0 then
      return math.floor(num * mult + 0.5) / mult
    else
      return math.ceil(num * mult - 0.5) / mult
    end
    return math.floor(num + 0.5)
  end);

  public.static.method("formatSeparated", function(value)
    if not value then
      return 0
    end
    local milliards = value - (value % 1000000000)
    local millions = value - milliards - (value % 1000000)
    local thousands = value - milliards - millions - (value % 1000)
    local units = value - thousands - millions - milliards
    milliards = milliards / 1000000000
    millions = millions / 1000000
    thousands = thousands / 1000
    local result = ""
    if milliards and milliards ~= 0 then
      result = result .. tostring(milliards) .. "."
    end
    if millions and (millions ~= 0 or milliards ~= 0) then
      if string.len(millions) ~= 3 and (milliards and milliards ~= 0) then
        for i = 1, 3 - string.len(millions), 1 do
          millions = "0" .. millions
        end
      end
      result = result .. tostring(millions) .. "."
    end
    if thousands and (thousands ~= 0 or millions ~= 0 or milliards ~= 0) then
      if string.len(thousands) ~= 3 and (millions and millions ~= 0) then
        for i = 1, 3 - string.len(thousands), 1 do
          thousands = "0" .. thousands
        end
      end
      result = result .. tostring(thousands) .. "."
    end
    if string.len(units) ~= 3 and (thousands and thousands ~= 0) then
      for i = 1, 3 - string.len(units), 1 do
        units = "0" .. units
      end
    end
    result = result .. tostring(units)
    return result
  end);

  public.static.method("percentage", function(currentValue, maxValue)
    local percentage = 0
    if currentValue and maxValue then
      if currentValue == maxValue then return 100 end
      if currentValue == 0 or maxValue == 0 then return 0 end
      percentage = currentValue / (maxValue / 100)
      if percentage then
        percentage = round(percentage)
      end
    end
    return percentage
  end);

  public.static.method("isEmptyNumberText", function(numberText)
    if String.is(numberText) then
      return isEmpty(numberText) or numberText == "0"
    elseif Number.is(numberText) then
      return numberText == 0
    elseif type(numberText) == "nil" then
      --TODO check whether it works or not
      return true
    end
    return true
  end);
}
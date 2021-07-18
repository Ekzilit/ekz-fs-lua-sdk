package "ekz.sdk"
import "ekz.sdk.Object"
public.class("String", Object) {
  public.static.final.method("is", function(value)
    return type(value) == "string" and true or false
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
}
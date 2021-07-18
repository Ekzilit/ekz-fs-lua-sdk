package "ekz.sdk"
import "ekz.sdk.Object"
public.class("Map", Object) {
  public.static.final.method("is", function(value)
    return type(value) == "table" and true or false
  end);
}
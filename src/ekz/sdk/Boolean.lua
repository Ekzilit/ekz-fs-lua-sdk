package "ekz.sdk"
import "ekz.sdk.Object"
public.class("Boolean", Object) {
  public.static.final.method("is", function(value)
    return type(value) == "boolean" and true or false
  end);
}
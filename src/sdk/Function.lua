package "sdk"
import "sdk.Object"
public.class("Function", Object) {
  public.static.final.method("is", function(value)
    return type(value) == "function" and true or false
  end);
}
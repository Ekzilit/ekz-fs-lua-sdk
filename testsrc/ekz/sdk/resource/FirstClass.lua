package "sdk.resource"
import "sdk.String"
import "sdk.resource.AbstractClass"
public.class("FirstClass") {
  public.String("varString", "publicVarString");
  public.method("method1", function()
    return "firstClassMethod1"
  end);
}

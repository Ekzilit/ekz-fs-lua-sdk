package "sdk.resource"
import "sdk.String"
public.class("SecondClass") {
  public.String("secondVarString", "publicVarString");
  public.method("method1", function()
    return "secondClassMethod1"
  end);
  public.method("method2", function()
    return "secondClassMethod2"
  end);
}

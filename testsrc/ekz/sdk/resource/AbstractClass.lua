package "sdk.resource"
import "sdk.String"
public.abstract.class("AbstractClass") {
  public.String("varString", "publicVarStringFromAbstract");
  public.method("publicMethod", function()
    return varString
  end);
  public.static.inner.class("publicStaticInnerClass", {
    public.static.method("publicStaticMethod", function() return true end);
  });
}
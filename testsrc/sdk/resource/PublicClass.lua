package "sdk.resource"
import "sdk.String"
import "sdk.resource.AbstractClass"
public.class("PublicClass", AbstractClass) {
  public.String("varString", "publicVarString");
  public.static.inner.class("publicStaticInnerClass", AbstractClass.publicStaticInnerClass, {
    public.static.method("publicStaticMethod2", function() return true end);
  });
}

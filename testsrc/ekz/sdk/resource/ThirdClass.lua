package "sdk.resource"
import "sdk.String"
import "sdk.resource.FirstClass"
import "sdk.resource.SecondClass"
public.class("ThirdClass", {FirstClass, SecondClass}) {
  public.String("varString", "publicVarString");
}

package "sdk"
import "sdk.resource.PublicClass"
import "sdk.resource.ThirdClass"
public.class("TestInnerClassExtends") {
  public.method("init", function()
    local thirdClass = ThirdClass()
    thirdClass.secondVarString = "val"
    assert("firstClassMethod1" == thirdClass.method1())
    assert("secondClassMethod2" == thirdClass.method2())
    assert("val" == thirdClass.secondVarString)

    local cls = PublicClass()
    assert(cls.publicStaticInnerClass.publicStaticMethod(), "Cannot find inner parents method")
    assert(cls.publicStaticInnerClass.publicStaticMethod2(), "Cannot find own inner method")
    assert("publicVarString" == cls.publicMethod(), "Not correct result")
  end);
}

local function protectedGetter(value)
  return getVarAccessMethod(Getter, Protected, value)
end
local function protectedSetter(value)
  return getVarAccessMethod(Setter, Protected, value)
end
local function protectedClassInitializer() error("Class can not be protected") end
local function protectedInterfaceInitializer() error("Interface can not be protected") end
local function protectedEnumInitializer() error("Enum can not be protected") end
local function protectedInnerClassInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, Inner, {Protected}, body)
end
local function protectedInnerInterfaceInitializer(name, parentName, body)
  return getClassInitializer(name, parentName, nil, {Inner, Interface}, {Protected}, body)
end
local function protectedInnerEnumInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, {Inner, EnumType}, {Protected}, body)
end
local function protectedVariableInitializer(_, fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Protected}, nil, firstAccessMethod, secondAccessMethod)
end
local function protectedVariableObjectInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Protected}, varObjectTypeFullPath, firstAccessMethod, secondAccessMethod)
end
local function protectedVariableBeanInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Protected}, Bean, firstAccessMethod, secondAccessMethod)
end
local function protectedMethodInitializer(fieldName, value)
  return getFieldInitializer(fieldName, value, Method, {Protected})
end
--protected final
local function protectedFinalClassInitializer() error("Class can not be protected") end
local function protectedFinalInterfaceInitializer() error("Interface can not be protected or final") end
local function protectedFinalEnumInitializer() error("Enum can not be protected or final") end
local function protectedFinalInnerClassInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, Inner, {Protected, Final}, body)
end
local function protectedFinalInnerInterfaceInitializer() error("Interface can not be final") end
local function protectedFinalInnerEnumInitializer() error("Enum can not be final") end
local function protectedFinalVariableInitializer(_, fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Protected, Final}, nil, firstAccessMethod, secondAccessMethod)
end
local function protectedFinalVariableObjectInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Protected, Final}, varObjectTypeFullPath, firstAccessMethod
      , secondAccessMethod)
end
local function protectedFinalVariableBeanInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Protected, Final}, Bean, firstAccessMethod, secondAccessMethod)
end
local function protectedFinalMethodInitializer(fieldName, value)
  return getFieldInitializer(fieldName, value, Method, {Protected, Final})
end
--protected static
local function protectedStaticClassInitializer() error("Class can not be protected or static") end
local function protectedStaticInterfaceInitializer() error("Interface can not be protected or static") end
local function protectedStaticEnumInitializer() error("Enum can not be protected or static") end
local function protectedStaticInnerClassInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, Inner, {Protected, Static}, body)
end
local function protectedStaticInnerInterfaceInitializer(name, parentName, body)
  return getClassInitializer(name, parentName, nil, {Inner, Interface}, {Protected, Static}, body)
end
local function protectedStaticInnerEnumInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, {Inner, EnumType}, {Protected, Static}, body)
end
local function protectedStaticVariableInitializer(_, fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Protected, Static}, nil, firstAccessMethod, secondAccessMethod)
end
local function protectedStaticVariableObjectInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Protected, Static}, varObjectTypeFullPath, firstAccessMethod
      , secondAccessMethod)
end
local function protectedStaticVariableBeanInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Protected, Static}, Bean, firstAccessMethod, secondAccessMethod)
end
local function protectedStaticMethodInitializer(fieldName, value)
  return getFieldInitializer(fieldName, value, Method, {Protected, Static})
end
--protected static final
local function protectedStaticFinalClassInitializer() error("Class can not be protected or static") end
local function protectedStaticFinalInterfaceInitializer() error("Interface can not be protected, static or final") end
local function protectedStaticFinalEnumInitializer() error("Enum can not be protected, static or final") end
local function protectedStaticFinalInnerClassInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, Inner, {Protected, Static, Final}, body)
end
local function protectedStaticFinalInnerInterfaceInitializer() error("Interface can not be final") end
local function protectedStaticFinalInnerEnumInitializer() error("Enum can not be final") end
local function protectedStaticFinalVariableInitializer(_, fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Protected, Static, Final}, nil, firstAccessMethod
      , secondAccessMethod)
end
local function protectedStaticFinalVariableObjectInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Protected, Static, Final}, varObjectTypeFullPath, firstAccessMethod
      , secondAccessMethod)
end
local function protectedStaticFinalVariableBeanInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Protected, Static, Final}, Bean, firstAccessMethod
      , secondAccessMethod)
end
local function protectedStaticFinalMethodInitializer(fieldName, value)
  return getFieldInitializer(fieldName, value, Method, {Protected, Static, Final})
end
--protected abstract
local function protectedAbstractClassInitializer(name, parentName, interfaces) error("Class can not be protected") end
local function protectedAbstractInterfaceInitializer() error("Interface can not be protected or abstract") end
local function protectedAbstractEnumInitializer() error("Enum can not be protected or abstract") end
local function protectedAbstractInnerClassInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, Inner, {Protected, Abstract}, body)
end
local function protectedAbstractInnerInterfaceInitializer() error("Interface can not be abstract") end
local function protectedAbstractInnerEnumInitializer() error("Enum can not be abstract") end
local function protectedAbstractVariableInitializer(_, fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Protected, Abstract}, nil, firstAccessMethod, secondAccessMethod)
end
local function protectedAbstractVariableObjectInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Protected, Abstract}, varObjectTypeFullPath, firstAccessMethod
      , secondAccessMethod)
end
local function protectedAbstractVariableBeanInitializer() error("Bean can not be abstract") end
local function protectedAbstractMethodInitializer(fieldName, value)
  return getFieldInitializer(fieldName, value, Table, {Protected, Abstract})
end

getfenv(0)["protected"] = setmetatable({
  static = setmetatable({
    final = setmetatable({
      inner = {
        class = protectedStaticFinalInnerClassInitializer;
        interface = protectedStaticFinalInnerInterfaceInitializer;
        enum = protectedStaticFinalInnerEnumInitializer;
      };
      class = protectedStaticFinalClassInitializer;
      interface = protectedStaticFinalInterfaceInitializer;
      enum = protectedStaticFinalEnumInitializer;
      bean = setmetatable({}, {
        __index = function(self, key) updateVarObjectType(key) return protectedStaticFinalVariableBeanInitializer end
      });
      method = protectedStaticFinalMethodInitializer;
    }, {
      __call = protectedStaticFinalVariableInitializer,
      __index = function(self, key) updateVarObjectType(key) return protectedStaticFinalVariableObjectInitializer end
    });
    inner = {
      class = protectedStaticInnerClassInitializer;
      interface = protectedStaticInnerInterfaceInitializer;
      enum = protectedStaticInnerEnumInitializer;
    };
    class = protectedStaticClassInitializer;
    interface = protectedStaticInterfaceInitializer;
    enum = protectedStaticEnumInitializer;
    bean = setmetatable({}, {
      __index = function(self, key) updateVarObjectType(key) return protectedStaticVariableBeanInitializer end
    });
    method = protectedStaticMethodInitializer;
  }, {
    __call = protectedStaticVariableInitializer,
    __index = function(self, key) updateVarObjectType(key) return protectedStaticVariableObjectInitializer end
  });
  final = setmetatable({
    inner = {
      class = protectedFinalInnerClassInitializer;
      interface = protectedFinalInnerInterfaceInitializer;
      enum = protectedFinalInnerEnumInitializer;
    };
    class = protectedFinalClassInitializer;
    interface = protectedFinalInterfaceInitializer;
    enum = protectedFinalEnumInitializer;
    bean = setmetatable({}, {
      __index = function(self, key) updateVarObjectType(key) return protectedFinalVariableBeanInitializer end
    });
    method = protectedFinalMethodInitializer;
  }, {
    __call = protectedFinalVariableInitializer,
    __index = function(self, key) updateVarObjectType(key) return protectedFinalVariableObjectInitializer end

  });
  abstract = setmetatable({
    inner = {
      class = protectedAbstractInnerClassInitializer;
      interface = protectedAbstractInnerInterfaceInitializer;
      enum = protectedAbstractInnerEnumInitializer;
    };
    class = protectedAbstractClassInitializer;
    interface = protectedAbstractInterfaceInitializer;
    enum = protectedAbstractEnumInitializer;
    var = setmetatable({
      bean = setmetatable({}, {
        __index = function(self, key) updateVarObjectType(key) return protectedAbstractVariableBeanInitializer end
      });
    }, {
      __call = protectedAbstractVariableInitializer,
      __index = function(self, key) updateVarObjectType(key) return protectedAbstractVariableObjectInitializer end
    });
    method = protectedAbstractMethodInitializer;
  }, {

  });
  inner = {
    class = protectedInnerClassInitializer;
    interface = protectedInnerInterfaceInitializer;
    enum = protectedInnerEnumInitializer;
  };
  class = protectedClassInitializer;
  interface = protectedInterfaceInitializer;
  enum = protectedEnumInitializer;
  bean = setmetatable({}, {
    __index = function(self, key) updateVarObjectType(key) return protectedVariableBeanInitializer end
  });
  method = protectedMethodInitializer;
  getter = protectedGetter;
  setter = protectedSetter;
}, {
  __call = protectedVariableInitializer,
  __index = function(self, key) updateVarObjectType(key) return protectedVariableObjectInitializer end

})

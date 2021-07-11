local function privateGetter(value)
  return getVarAccessMethod(Getter, Private, value)
end
local function privateSetter(value)
  return getVarAccessMethod(Setter, Private, value)
end
local function privateClassInitializer() error("Class can not be private") end
local function privateInterfaceInitializer() error("Interface can not be private") end
local function privateEnumInitializer() error("Interface can not be private") end
local function privateInnerClassInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, Inner, {Private}, body)
end
local function privateInnerInterfaceInitializer(name, parentName, body)
  return getClassInitializer(name, parentName, nil, {Inner, Interface}, {Private}, body)
end
local function privateInnerEnumInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, {Inner, EnumType}, {Private}, body)
end
local function privateVariableInitializer(_, fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Private}, nil, firstAccessMethod, secondAccessMethod)
end
local function privateVariableObjectInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Private}, varObjectTypeFullPath, firstAccessMethod, secondAccessMethod)
end
local function privateVariableBeanInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Private}, Bean, firstAccessMethod, secondAccessMethod)
end
local function privateMethodInitializer(fieldName, value)
  return getFieldInitializer(fieldName, value, Method, {Private})
end
--private final
local function privateFinalClassInitializer() error("Class can not be private") end
local function privateFinalInterfaceInitializer() error("Interface can not be private or final") end
local function privateFinalEnumInitializer() error("Enum can not be private or final") end
local function privateFinalInnerClassInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, Inner, {Private, Final}, body)
end
local function privateFinalInnerInterfaceInitializer() error("Inner interface can not be final") end
local function privateFinalInnerEnumInitializer() error("Inner enum can not be final") end
local function privateFinalVariableInitializer(_, fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Private, Final}, nil, firstAccessMethod, secondAccessMethod)
end
local function privateFinalVariableObjectInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Private, Final}, varObjectTypeFullPath, firstAccessMethod
      , secondAccessMethod)
end
local function privateFinalVariableBeanInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Private, Final}, Bean, firstAccessMethod, secondAccessMethod)
end
local function privateFinalMethodInitializer(fieldName, value)
  return getFieldInitializer(fieldName, value, Method, {Private, Final})
end
--private static
local function privateStaticClassInitializer() error("Class can not be private or static") end
local function privateStaticInterfaceInitializer() error("Interface can not be private or static") end
local function privateStaticEnumInitializer() error("Enum can not be private or static") end
local function privateStaticInnerClassInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, Inner, {Private, Static}, body)
end
local function privateStaticInnerInterfaceInitializer(name, parentName, body)
  return getClassInitializer(name, parentName, nil, {Inner, Interface}, {Private, Static}, body)
end
local function privateStaticInnerEnumInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, {Inner, EnumType}, {Private, Static}, body)
end
local function privateStaticVariableInitializer(_, fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Private, Static}, nil, firstAccessMethod, secondAccessMethod)
end
local function privateStaticVariableObjectInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Private, Static}, varObjectTypeFullPath, firstAccessMethod
      , secondAccessMethod)
end
local function privateStaticVariableBeanInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Private, Static}, Bean, firstAccessMethod, secondAccessMethod)
end
local function privateStaticMethodInitializer(fieldName, value)
  return getFieldInitializer(fieldName, value, Method, {Private, Static})
end
--private static final
local function privateStaticFinalClassInitializer() error("Class can not be private or static") end
local function privateStaticFinalInterfaceInitializer() error("Interface can not be private, static or final") end
local function privateStaticFinalEnumInitializer() error("Enum can not be private, static or final") end
local function privateStaticFinalInnerClassInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, Inner, {Private, Static, Final}, body)
end
local function privateStaticFinalInnerInterfaceInitializer() error("Inner interface can not be final") end
local function privateStaticFinalInnerEnumInitializer() error("Inner enum can not be final") end
local function privateStaticFinalVariableInitializer(_, fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Private, Static, Final}, nil, firstAccessMethod
      , secondAccessMethod)
end
local function privateStaticFinalVariableObjectInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Private, Static, Final}, varObjectTypeFullPath, firstAccessMethod
      , secondAccessMethod)
end
local function privateStaticFinalVariableBeanInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Private, Static, Final}, Bean, firstAccessMethod
      , secondAccessMethod)
end
local function privateStaticFinalMethodInitializer(fieldName, value)
  return getFieldInitializer(fieldName, value, Method, {Private, Static, Final})
end
--private abstract
local function privateAbstractClassInitializer() error("Class can not be private") end
local function privateAbstractInterfaceInitializer() error("Interface can not be private or abstract") end
local function privateAbstractEnumInitializer() error("Enum can not be private or abstract") end
local function privateAbstractInnerClassInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, Inner, {Private, Abstract}, body)
end
local function privateAbstractInnerInterfaceInitializer() error("Inner interface can not be abstract") end
local function privateAbstractInnerEnumInitializer() error("Inner enum can not be abstract") end
local function privateAbstractVariableInitializer() error("Var can not be private abstract") end
local function privateAbstractVariableObjectInitializer() error("Var can not be private abstract") end
local function privateAbstractVariableBeanInitializer() error("Bean can not be abstract") end
local function privateAbstractMethodInitializer() error("Method can not be private abstract") end

getfenv(0)["private"] = setmetatable({
  static = setmetatable({
    final = setmetatable({
      inner = {
        class = privateStaticFinalInnerClassInitializer;
        interface = privateStaticFinalInnerInterfaceInitializer;
        enum = privateStaticFinalInnerEnumInitializer;
      };
      class = privateStaticFinalClassInitializer;
      interface = privateStaticFinalInterfaceInitializer;
      enum = privateStaticFinalEnumInitializer;
      bean = setmetatable({}, {
        __index = function(self, key) updateVarObjectType(key) return privateStaticFinalVariableBeanInitializer end
      });
      method = privateStaticFinalMethodInitializer;
    }, {
      __call = privateStaticFinalVariableInitializer,
      __index = function(self, key) updateVarObjectType(key) return privateStaticFinalVariableObjectInitializer end

    });
    inner = {
      class = privateStaticInnerClassInitializer;
      interface = privateStaticInnerInterfaceInitializer;
      enum = privateStaticInnerEnumInitializer;
    };
    class = privateStaticClassInitializer;
    interface = privateStaticInterfaceInitializer;
    enum = privateStaticEnumInitializer;
    bean = setmetatable({}, {
      __index = function(self, key) updateVarObjectType(key) return privateStaticVariableBeanInitializer end
    });
    method = privateStaticMethodInitializer;
  }, {
    __call = privateStaticVariableInitializer,
    __index = function(self, key) updateVarObjectType(key) return privateStaticVariableObjectInitializer end

  });
  final = setmetatable({
    inner = {
      class = privateFinalInnerClassInitializer;
      interface = privateFinalInnerInterfaceInitializer;
      enum = privateFinalInnerEnumInitializer;
    };
    class = privateFinalClassInitializer;
    interface = privateFinalInterfaceInitializer;
    enum = privateFinalEnumInitializer;
    bean = setmetatable({}, {
      __index = function(self, key) updateVarObjectType(key) return privateFinalVariableBeanInitializer end
    });
    method = privateFinalMethodInitializer;
  }, {
    __call = privateFinalVariableInitializer,
    __index = function(self, key) updateVarObjectType(key) return privateFinalVariableObjectInitializer end
  });
  abstract = setmetatable({
    inner = {
      class = privateAbstractInnerClassInitializer;
      interface = privateAbstractInnerInterfaceInitializer;
      enum = privateAbstractInnerEnumInitializer;
    };
    class = privateAbstractClassInitializer;
    interface = privateAbstractInterfaceInitializer;
    enum = privateAbstractEnumInitializer;
    bean = setmetatable({}, {
      __index = function(self, key) updateVarObjectType(key) return privateAbstractVariableBeanInitializer end
    });
    method = privateAbstractMethodInitializer;
  }, {
    __call = privateAbstractVariableInitializer,
    __index = function(self, key) updateVarObjectType(key) return privateAbstractVariableObjectInitializer end
  });
  inner = {
    class = privateInnerClassInitializer;
    interface = privateInnerInterfaceInitializer;
    enum = privateInnerEnumInitializer;
  };
  class = privateClassInitializer;
  interface = privateInterfaceInitializer;
  enum = privateEnumInitializer;
  bean = setmetatable({}, {
    __index = function(self, key) updateVarObjectType(key) return privateVariableBeanInitializer end
  });
  method = privateMethodInitializer;
  getter = privateGetter;
  setter = privateSetter;
}, {
  __call = privateVariableInitializer,
  __index = function(self, key) updateVarObjectType(key) return privateVariableObjectInitializer end
})
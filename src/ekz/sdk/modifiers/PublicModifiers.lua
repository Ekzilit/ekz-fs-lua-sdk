local function publicGetter(value)
  return getVarAccessMethod(Getter, Public, value)
end
local function publicSetter(value)
  return getVarAccessMethod(Setter, Public, value)
end
local function publicClassInitializer(name, parentName, interfaces)
  return getClassInitializer(name, parentName, interfaces, nil, {Public})
end
local function publicInterfaceInitializer(name, parentName)
  return getClassInitializer(name, parentName, nil, Interface, {Public})
end
local function publicEnumInitializer(name, parentName, interfaces)
  return getClassInitializer(name, parentName, interfaces, EnumType, {Public})
end
local function publicInnerClassInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, Inner, {Public}, body)
end
local function publicInnerInterfaceInitializer(name, parentName, body)
  return getClassInitializer(name, parentName, nil, {Inner, Interface}, {Public}, body)
end
local function publicInnerEnumInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, {Inner, EnumType}, {Public}, body)
end
local function publicVariableInitializer(_, fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Public}, nil, firstAccessMethod, secondAccessMethod)
end
local function publicVariableObjectInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Public}, varObjectTypeFullPath, firstAccessMethod, secondAccessMethod)
end
local function publicVariableBeanInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Public}, Bean, firstAccessMethod, secondAccessMethod)
end
local function publicMethodInitializer(fieldName, value)
  return getFieldInitializer(fieldName, value, Method, {Public})
end
--public final
local function publicFinalClassInitializer(name, parentName, interfaces)
  return getClassInitializer(name, parentName, interfaces, nil, {Public, Final})
end
local function publicFinalInterfaceInitializer() error("Interface can not be final") end
local function publicFinalEnumInitializer() error("Enum is final by default") end
local function publicFinalInnerClassInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, Inner, {Public, Final}, body)
end
local function publicFinalInnerInterfaceInitializer() error("Interface can not be final") end
local function publicFinalInnerEnumInitializer() error("Enum can not be final") end
local function publicFinalVariableInitializer(_, fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Public, Final}, nil, firstAccessMethod, secondAccessMethod)
end
local function publicFinalVariableObjectInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Public, Final}, varObjectTypeFullPath, firstAccessMethod, secondAccessMethod)
end
local function publicFinalVariableBeanInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Public, Final}, Bean, firstAccessMethod, secondAccessMethod)
end
local function publicFinalMethodInitializer(fieldName, value)
  return getFieldInitializer(fieldName, value, Method, {Public, Final})
end
--public static
local function publicStaticClassInitializer() error("Class can not be static") end
local function publicStaticInterfaceInitializer() error("Interface can not be static") end
local function publicStaticEnumInitializer() error("Enum can not be static") end
local function publicStaticInnerClassInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, Inner, {Public, Static}, body)
end
local function publicStaticInnerInterfaceInitializer(name, parentName, body)
  return getClassInitializer(name, parentName, nil, {Inner, Interface}, {Public, Static}, body)
end
local function publicStaticInnerEnumInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, {Inner, EnumType}, {Public, Static}, body)
end
local function publicStaticVariableInitializer(_, fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Public, Static}, nil, firstAccessMethod, secondAccessMethod)
end
local function publicStaticVariableObjectInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Public, Static}, varObjectTypeFullPath, firstAccessMethod, secondAccessMethod)
end
local function publicStaticVariableBeanInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Public, Static}, Bean, firstAccessMethod, secondAccessMethod)
end
local function publicStaticMethodInitializer(fieldName, value)
  return getFieldInitializer(fieldName, value, Method, {Public, Static})
end
--public static final
local function publicStaticFinalClassInitializer() error("Class can not be static") end
local function publicStaticFinalInterfaceInitializer() error("Interface can not be static or final") end
local function publicStaticFinalEnumInitializer() error("Enum can not be static or final") end
local function publicStaticFinalInnerClassInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, Inner, {Public, Static, Final}, body)
end
local function publicStaticFinalInnerInterfaceInitializer() error("Interface can not be final") end
local function publicStaticFinalInnerEnumInitializer() error("Enum can not be final")
end
local function publicStaticFinalVariableInitializer(_, fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Public, Static, Final}, nil, firstAccessMethod, secondAccessMethod)
end
local function publicStaticFinalVariableObjectInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Public, Static, Final}, varObjectTypeFullPath, firstAccessMethod, secondAccessMethod)
end
local function publicStaticFinalVariableBeanInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Public, Static, Final}, Bean, firstAccessMethod, secondAccessMethod)
end
local function publicStaticFinalMethodInitializer(fieldName, value)
  return getFieldInitializer(fieldName, value, Method, {Public, Static, Final})
end
--public abstract
local function publicAbstractClassInitializer(name, parentName, interfaces)
  return getClassInitializer(name, parentName, interfaces, nil, {Public, Abstract})
end
local function publicAbstractInterfaceInitializer() error("Interface can not be abstract") end
local function publicAbstractEnumInitializer() error("Enum can not be abstract") end
local function publicAbstractInnerClassInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, Inner, {Public, Abstract}, body)
end
local function publicAbstractInnerInterfaceInitializer() error("Interface can not be abstract") end
local function publicAbstractInnerEnumInitializer() error("Enum can not be abstract") end
local function publicAbstractVariableInitializer(_, fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Public, Abstract}, nil, firstAccessMethod, secondAccessMethod)
end
local function publicAbstractVariableObjectInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Public, Abstract}, varObjectTypeFullPath, firstAccessMethod, secondAccessMethod)
end
local function publicAbstractVariableBeanInitializer() error("Bean can not be abstract") end
local function publicAbstractMethodInitializer(fieldName, value)
  return getFieldInitializer(fieldName, value, Method, {Public, Abstract})
end

getfenv(0)["public"] = setmetatable({
  static = setmetatable({
    final = setmetatable({
      inner = {
        class = publicStaticFinalInnerClassInitializer;
        interface = publicStaticFinalInnerInterfaceInitializer;
        enum = publicStaticFinalInnerEnumInitializer;
      };
      class = publicStaticFinalClassInitializer;
      interface = publicStaticFinalInterfaceInitializer;
      enum = publicStaticFinalEnumInitializer;
      bean = setmetatable({}, {
        __index = function(self, key) updateVarObjectType(key) return publicStaticFinalVariableBeanInitializer end
      });
      method = publicStaticFinalMethodInitializer;
    }, {
      __call = publicStaticFinalVariableInitializer,
      __index = function(self, key) updateVarObjectType(key) return publicStaticFinalVariableObjectInitializer end
    });
    inner = {
      class = publicStaticInnerClassInitializer;
      interface = publicStaticInnerInterfaceInitializer;
      enum = publicStaticInnerEnumInitializer;
    };
    class = publicStaticClassInitializer;
    interface = publicStaticInterfaceInitializer;
    enum = publicStaticEnumInitializer;
    bean = setmetatable({}, {
      __index = function(self, key) updateVarObjectType(key) return publicStaticVariableBeanInitializer end
    });
    method = publicStaticMethodInitializer;
  }, {
    __call = publicStaticVariableInitializer,
    __index = function(self, key) updateVarObjectType(key) return publicStaticVariableObjectInitializer end
  });
  final = setmetatable({
    inner = {
      class = publicFinalInnerClassInitializer;
      interface = publicFinalInnerInterfaceInitializer;
      enum = publicFinalInnerEnumInitializer;
    };
    class = publicFinalClassInitializer;
    interface = publicFinalInterfaceInitializer;
    enum = publicFinalEnumInitializer;
    bean = setmetatable({}, {
      __index = function(self, key) updateVarObjectType(key) return publicFinalVariableBeanInitializer end
    });
    method = publicFinalMethodInitializer;
  }, {
    __call = publicFinalVariableInitializer,
    __index = function(self, key) updateVarObjectType(key) return publicFinalVariableObjectInitializer end
  });

  abstract = setmetatable({
    inner = {
      class = publicAbstractInnerClassInitializer;
      interface = publicAbstractInnerInterfaceInitializer;
      enum = publicAbstractInnerEnumInitializer;
    };
    class = publicAbstractClassInitializer;
    interface = publicAbstractInterfaceInitializer;
    enum = publicAbstractEnumInitializer;
    bean = setmetatable({}, {
      __index = function(self, key) updateVarObjectType(key) return publicAbstractVariableBeanInitializer end
    });
    method = publicAbstractMethodInitializer;
  }, {
    __call = publicAbstractVariableInitializer,
    __index = function(self, key) updateVarObjectType(key) return publicAbstractVariableObjectInitializer end
  });

  inner = {
    class = publicInnerClassInitializer;
    interface = publicInnerInterfaceInitializer;
    enum = publicInnerEnumInitializer;
  };
  class = publicClassInitializer;
  interface = publicInterfaceInitializer;
  enum = publicEnumInitializer;
  bean = setmetatable({}, {
    __index = function(self, key) updateVarObjectType(key) return publicVariableBeanInitializer end
  });
  method = publicMethodInitializer;
  getter = publicGetter;
  setter = publicSetter;
}, {
  __call = publicVariableInitializer,
  __index = function(self, key) updateVarObjectType(key) return publicVariableObjectInitializer end
})

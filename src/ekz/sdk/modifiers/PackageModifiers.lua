local function packageGetter(value)
  return getVarAccessMethod(Getter, Package, value)
end
local function packageSetter(value)
  return getVarAccessMethod(Setter, Package, value)
end
local function packageClassInitializer(name, parentName, interfaces)
  return getClassInitializer(name, parentName, interfaces, nil, {Package})
end
local function packageInterfaceInitializer(name, parentName)
  return getClassInitializer(name, parentName, nil, Interface, {Package})
end
local function packageEnumInitializer(name, parentName, interfaces)
  return getClassInitializer(name, parentName, interfaces, EnumType, {Package})
end
local function packageInnerClassInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, Inner, {Package}, body)
end
local function packageInnerInterfaceInitializer(name, parentName, body)
  return getClassInitializer(name, parentName, nil, {Inner, Interface}, {Package}, body)
end
local function packageInnerEnumInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, {Inner, EnumType}, {Package}, body)
end
local function packageVariableObjectInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Package}, varObjectTypeFullPath, firstAccessMethod
      , secondAccessMethod)
end
local function packageVariableBeanInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Package}, Bean, firstAccessMethod, secondAccessMethod)
end
local function packageMethodInitializer(fieldName, value)
  return getFieldInitializer(fieldName, value, Method, {Package})
end
--package final
local function packageFinalClassInitializer(name, parentName, interfaces)
  return getClassInitializer(name, parentName, interfaces, nil, {Package, Final})
end
local function packageFinalInterfaceInitializer() error("Interface can not be final") end
local function packageFinalEnumInitializer() error("Enum can not be final") end
local function packageFinalInnerClassInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, Inner, {Package, Final}, body)
end
local function packageFinalInnerInterfaceInitializer() error("Interface can not be final") end
local function packageFinalInnerEnumInitializer() error("Enum can not be final") end
local function packageFinalVariableInitializer(_, fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Package, Final}, nil, firstAccessMethod, secondAccessMethod)
end
local function packageFinalVariableObjectInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Package, Final}, varObjectTypeFullPath, firstAccessMethod
      , secondAccessMethod)
end
local function packageFinalVariableBeanInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Package, Final}, Bean, firstAccessMethod, secondAccessMethod)
end
local function packageFinalMethodInitializer(fieldName, value)
  return getFieldInitializer(fieldName, value, Method, {Package, Final})
end
--package static
local function packageStaticClassInitializer() error("Class can not be static") end
local function packageStaticInterfaceInitializer() error("Interface can not be static") end
local function packageStaticEnumInitializer() error("Enum can not be static") end
local function packageStaticInnerClassInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, Inner, {Package, Static}, body)
end
local function packageStaticInnerInterfaceInitializer(name, parentName, body)
  return getClassInitializer(name, parentName, nil, {Inner, Interface}, {Package, Static}, body)
end
local function packageStaticInnerEnumInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, {Inner, EnumType}, {Package, Static}, body)
end
local function packageStaticVariableInitializer(_, fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Package, Static}, nil, firstAccessMethod, secondAccessMethod)
end
local function packageStaticVariableObjectInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Package, Static}, varObjectTypeFullPath, firstAccessMethod
      , secondAccessMethod)
end
local function packageStaticVariableBeanInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Package, Static}, Bean, firstAccessMethod, secondAccessMethod)
end
local function packageStaticMethodInitializer(fieldName, value)
  return getFieldInitializer(fieldName, value, Method, {Package, Static})
end
--package static final
local function packageStaticFinalClassInitializer() error("Class can not be static") end
local function packageStaticFinalInterfaceInitializer() error("Interface can not be static or final") end
local function packageStaticFinalEnumInitializer() error("Enum can not be static or final") end
local function packageStaticFinalInnerClassInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, Inner, {Package, Static, Final}, body)
end
local function packageStaticFinalInnerInterfaceInitializer() error("Interface can not be final") end
local function packageStaticFinalInnerEnumInitializer() error("Enum can not be final") end
local function packageStaticFinalVariableInitializer(_, fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Package, Static, Final}, nil, firstAccessMethod
      , secondAccessMethod)
end
local function packageStaticFinalVariableObjectInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Package, Static, Final}, varObjectTypeFullPath, firstAccessMethod
      , secondAccessMethod)
end
local function packageStaticFinalVariableBeanInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Package, Static, Final}, Bean, firstAccessMethod, secondAccessMethod)
end
local function packageStaticFinalMethodInitializer(fieldName, value)
  return getFieldInitializer(fieldName, value, Method, {Package, Static, Final})
end
--package abstract
local function packageAbstractClassInitializer(name, parentName, interfaces)
  return getClassInitializer(name, parentName, interfaces, nil, {Package, Abstract})
end
local function packageAbstractInterfaceInitializer() error("Interface can not be abstract") end
local function packageAbstractEnumInitializer() error("Enum can not be abstract") end
local function packageAbstractInnerClassInitializer(name, parentName, interfaces, body)
  return getClassInitializer(name, parentName, interfaces, Inner, {Package, Abstract}, body)
end
local function packageAbstractInnerInterfaceInitializer() error("Interface can not be abstract") end
local function packageAbstractInnerEnumInitializer() error("Enum can not be abstract") end
local function packageAbstractVariableInitializer(_, fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Package, Abstract}, nil, firstAccessMethod, secondAccessMethod)
end
local function packageAbstractVariableObjectInitializer(fieldName, value, firstAccessMethod, secondAccessMethod)
  return getFieldInitializer(fieldName, value, Var, {Package, Abstract}, varObjectTypeFullPath, firstAccessMethod
      , secondAccessMethod)
end
local function packageAbstractVariableBeanInitializer() error("Bean can not be abstract") end
local function packageAbstractMethodInitializer(fieldName, value)
  return getFieldInitializer(fieldName, value, Method, {Package, Abstract})
end

getfenv(0)["package"] = setmetatable({
  static = setmetatable({
    final = setmetatable({
      inner = {
        class = packageStaticFinalInnerClassInitializer;
        interface = packageStaticFinalInnerInterfaceInitializer;
        enum = packageStaticFinalInnerEnumInitializer;
      };
      class = packageStaticFinalClassInitializer;
      interface = packageStaticFinalInterfaceInitializer;
      enum = packageStaticFinalEnumInitializer;
      bean = setmetatable({}, {
        __index = function(self, key) updateVarObjectType(key) return packageStaticFinalVariableBeanInitializer end
      });
      method = packageStaticFinalMethodInitializer;
    }, {
      __call = packageStaticFinalVariableInitializer,
      __index = function(self, key) updateVarObjectType(key) return packageStaticFinalVariableObjectInitializer end
    });
    inner = {
      class = packageStaticInnerClassInitializer;
      interface = packageStaticInnerInterfaceInitializer;
      enum = packageStaticInnerEnumInitializer;
    };
    class = packageStaticClassInitializer;
    interface = packageStaticInterfaceInitializer;
    enum = packageStaticEnumInitializer;
    bean = setmetatable({}, {
      __index = function(self, key) updateVarObjectType(key) return packageStaticVariableBeanInitializer end
    });
    method = packageStaticMethodInitializer;
  }, {
    __call = packageStaticVariableInitializer,
    __index = function(self, key) updateVarObjectType(key) return packageStaticVariableObjectInitializer end
  });
  final = setmetatable({
    inner = {
      class = packageFinalInnerClassInitializer;
      interface = packageFinalInnerInterfaceInitializer;
      enum = packageFinalInnerEnumInitializer;
    };
    class = packageFinalClassInitializer;
    interface = packageFinalInterfaceInitializer;
    enum = packageFinalEnumInitializer;
    bean = setmetatable({}, {
      __index = function(self, key) updateVarObjectType(key) return packageFinalVariableBeanInitializer end
    });
    method = packageFinalMethodInitializer;
  }, {
    __call = packageFinalVariableInitializer,
    __index = function(self, key) updateVarObjectType(key) return packageFinalVariableObjectInitializer end
  });
  abstract = setmetatable({
    inner = {
      class = packageAbstractInnerClassInitializer;
      interface = packageAbstractInnerInterfaceInitializer;
      enum = packageAbstractInnerEnumInitializer;
    };
    class = packageAbstractClassInitializer;
    interface = packageAbstractInterfaceInitializer;
    enum = packageAbstractEnumInitializer;
    bean = setmetatable({}, {
      __index = function(self, key) updateVarObjectType(key) return packageAbstractVariableBeanInitializer end
    });
    method = packageAbstractMethodInitializer;
  }, {
    __call = packageAbstractVariableInitializer,
    __index = function(self, key) updateVarObjectType(key) return packageAbstractVariableObjectInitializer end
  });
  inner = {
    class = packageInnerClassInitializer;
    interface = packageInnerInterfaceInitializer;
    enum = packageInnerEnumInitializer;
  };
  class = packageClassInitializer;
  interface = packageInterfaceInitializer;
  enum = packageEnumInitializer;
  bean = setmetatable({}, {
    __index = function(self, key) updateVarObjectType(key) return packageVariableBeanInitializer end
  });
  method = packageMethodInitializer;
  getter = packageGetter;
  setter = packageSetter;
}, {
  --there is no package("varName"), only with type
  --should be removed for others access modifiers in the future
  __call = function(self, packagePath)
    setfenv(2, setmetatable({_G = _G, imports = _import}, {
      __index = function(self, name)
        if self.imports ~= nil and self.imports[name] ~= nil then
          return self._G[self.imports[name]]
        end
        if name == "this" then return self._G[name]() end
        if name == "super" then return self._G[name]() end
        return self._G[name]
      end;
      __newindex = function(self, name, val)
        self._G[name] = val
      end;
    }))
    classPackage(packagePath)
  end,
  __index = function(self, key) updateVarObjectType(key) return packageVariableObjectInitializer end
})

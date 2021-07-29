varObjectTypeFullPath = ""
ignoreVarSetMethod = false
ignoreVarGetMethod = false

function updateVarObjectType(className)
  varObjectTypeFullPath = getFullPathFromImports(className)
  if varObjectTypeFullPath == nil then error("Can not find import with name " .. className) end
end

function table.contains(tbl, value)
  for _, v in ipairs(tbl) do
    if v == value then
      return true
    end
  end
  return false
end

function getVarAccessMethod(type, access, method)
  local result = {}
  result[access] = true
  result.type = type
  local proxyMethod = function(...)
    if type == Getter then
      ignoreVarGetMethod = true
    else
      ignoreVarSetMethod = true
    end
    setfenv(method, getfenv(1))
    local res = method(...)
    ignoreVarSetMethod = false
    ignoreVarGetMethod = false
    return res
  end
  result.method = proxyMethod
  return result
end

local function fillClassModifiers(classType, classAttributes)
  local modifiers = {}

  if classType ~= nil then
    if type(classType) == Table then
      for _, type in ipairs(classType) do
        modifiers[type] = true
      end
    else
      modifiers[classType] = true
    end
  end

  for _, modifier in ipairs(classAttributes) do
    modifiers[modifier] = true
  end

  return modifiers
end

function getClassInitializer(className, parents, interfacesToImplement, classType, modifiers, body)
  local classBody
  local interfaces
  local parent
  local modifiers = fillClassModifiers(classType, modifiers)

  local isInner = (type(classType) == Table and table.contains(classType, Inner)) or classType == Inner
  if isInner == true then
    if body ~= nil then
      classBody = body
      interfaces = interfacesToImplement
      parent = parents
    elseif interfacesToImplement ~= nil then
      classBody = interfacesToImplement
      if type(parents) == Table then
        if rawget(parents, "isWrapper") == true then
          parent = parents
        else
          interfaces = parents
        end
      elseif type(parents) == String then
        parent = parents
      else
        error("Wrong interface or parent type")
      end
    elseif parents ~= nil then
      classBody = parents
    else
      error("Inner class has to have body")
    end
  else
    parent = parents
    if type(interfacesToImplement) == String then
      interfaces = {interfacesToImplement}
    elseif type(interfacesToImplement) == Table then
      interfaces = interfacesToImplement
    elseif type(interfacesToImplement) ~= Nil then
      error("Wrong type of interface attribute for class declaration")
    end
  end

  return setmetatable({
    className = className,
    parents = parent,
    interfaces = interfaces,
    classBody = classBody,
    modifiers = modifiers,
    static = modifiers[Static]
  }, {
    __call = function(self, class)
      --Inner class
      if self.modifiers.inner == true then
        modifiers.owner = class
        --parent is a string - indicate that it is a inner class name of the owner class
        if type(self.parents) == String then
          local parentName = self.parents
          --try to find parent class in direct class owner
          addToPool(class)
          self.parents = class[parentName]
          removeLastFromPool()
          if self.parents == nil and rawget(rawget(class, "classAttributes"), "inner") == true then
            --try to find parent class in owners of direct class owner
            local owner = rawget(rawget(class, "classAttributes"), "owner")
            while self.parents == nil do
              addToPool(owner)
              self.parents = owner[parentName]
              owner = rawget(rawget(owner, "classAttributes"), "owner")
              removeLastFromPool()
            end
          end
          if self.parents == nil then
            error("Can not find parent " .. parentName .. " for inner class " .. self.className)
          end
        end
        rawset(class, self.className, declareClass(self.className, {self.parents}, self.classBody, self.modifiers
            , self.interfaces))
        class.elementsAttributes.classes[self.className] = {}

        for modifier in pairs(self.modifiers) do
          class.elementsAttributes.classes[self.className][modifier] = true
        end
      else
        --Simple class
        local parentsToSend
        if parents ~= nil and rawget(parents, "isWrapper") == true then
          parentsToSend = {parents}
        else
          parentsToSend = parents
        end
        declareClass(self.className, parentsToSend, class, self.modifiers, self.interfaces)
      end
    end
  })
end

local function getMethodValue(value, class, initialClass)
  local proxyMethod = function(...)
    addToPool(initialClass or class, class)
    local result
    if value ~= nil then
      result = value(...)
    end
    removeLastFromPool()
    return result
  end
  return proxyMethod
end

local function getVarValue(varInitializer, valueType, class)
  local value = varInitializer.value
  if value == nil then
    if valueType == Bean then
      return getBean(class, varInitializer.fieldName):getClass()
    end
    return nil
  else
    --bean
    if valueType == Bean then
      if type(value) ~= String then
        error("Bean name must be string type")
      else
        return getBean(class, value):getClass()
      end
    end
    --wrong value type
    local valType = type(value)
    if valueType ~= nil then
      if valType ~= valueType and valType ~= Nil then
        local typeObject = _G[valueType]
        if typeObject ~= nil then
          if not typeObject.is(value) then
            error("Trying to set " .. valType .. " into type " .. typeObject.objectName)
          end
        else
          error("Trying to set " .. valType .. " into type " .. valueType)
        end
      end
    end
    --clone table value
    if valType == Table then
      --not widget and class
      if value.GetName == nil and value.objectName == nil then
        value = table.clone(value)
      end
    end

    return value
  end
  error("unhandled behavior in var value set for " .. varInitializer.fieldName)
end

local function copyVarAccessMethod(accessMethod)
  local copy = {}
  for k, v in pairs(accessMethod) do
    if k ~= "method" then
      copy[k] = v
    end
  end
  return copy
end

function getFieldInitializer(fieldName, value, fieldType, fieldModifiers, valueType, firstAccessMethod,
                            secondAccessMethod)
  return setmetatable({
    fieldName = fieldName,
    fieldType = fieldType,
    fieldModifiers = fieldModifiers,
    value = value,
    valueType = valueType,
    beanType = varObjectTypeFullPath,
    firstAccessMethod = firstAccessMethod,
    secondAccessMethod = secondAccessMethod,
    static = table.contains(fieldModifiers, Static)
  }, { __call = function(self, class, initialClass)
    local fieldName = self.fieldName
    local fieldModifiers = self.fieldModifiers
    local fieldType = self.fieldType
    local value = self.value
    local valueType = self.valueType
    local elementAttributes = nil
    local fenv
    local fAM = self.firstAccessMethod
    local sAM = self.secondAccessMethod

    if fieldType == Method or fAM ~= nil or sAM ~= nil then
      fenv = setmetatable({}, {
        __index = function(self, name)
          if name == "this" then return this() end
          if name == "super" then return super() end
          --to address to class element just by it`s name
          local class = getCurrentClass()
          local classElement = class[name]
          if classElement ~= nil then
            return getClassElement(class, name)
          end
          if class.classAttributes then
            if class.classAttributes.inner == true then
              if class.classAttributes.owner == nil then
                error("Inner class does not have owner")
              else
                local owner = class.classAttributes.owner
                while owner ~= nil do
                  classElement = class.classAttributes.owner[name]
                  if classElement ~= nil then return classElement end
                  owner = owner.classAttributes.owner
                end
              end
            end
            if getFullClassNameFromImports(name) ~= nil then
              return def(name)
            end
          end
          return _G[name]
        end;
        __newindex = function(self, name, value)
          if name == "ignoreVarSetMethod" or name == "ignoreVarGetMethod" then
            return _G[name]
          end
          if name ~= "_" then
            local class = getCurrentClass()
            setClassElement(class, name, value)
          end
        end
      })
    end

    if fieldType == Method then
      if value == nil then error("Method mustn't be nil") end
      setfenv(value, fenv)
      rawset(class, fieldName, getMethodValue(value, class, initialClass))
      class.elementsAttributes.methods[fieldName] = {}
      elementAttributes = class.elementsAttributes.methods[fieldName]

    elseif fieldType == Var then
      local varValue = getVarValue(self, valueType, class)
      if varValue ~= nil then
        rawset(class, fieldName, varValue)
      end
      class.elementsAttributes.vars[fieldName] = {}
      elementAttributes = class.elementsAttributes.vars[fieldName]
      if valueType ~= nil then
        elementAttributes.type = (valueType == Bean and self.beanType ~= nil) and self.beanType or valueType
      else
        elementAttributes.type = Any
      end
      class.varAccessMethods[fieldName] = {}
      if fAM ~= nil and fAM.type == Getter then
        if elementAttributes.abstract == true then
          error("Abstract var can not have getter")
        end
        setfenv(fAM.method, fenv)
        local copyFAM = copyVarAccessMethod(fAM)
        copyFAM.method = getMethodValue(fAM.method, class, initialClass)
        class.varAccessMethods[fieldName].getter = copyFAM
      end
      if sAM ~= nil and sAM.type == Getter then
        if elementAttributes.abstract == true then
          error("Abstract var can not have getter")
        end
        setfenv(sAM.method, fenv)
        local copySAM = copyVarAccessMethod(sAM)
        copySAM.method = getMethodValue(sAM.method, class, initialClass)
        class.varAccessMethods[fieldName].getter = copySAM
      end
      if fAM ~= nil and fAM.type == Setter then
        if elementAttributes.final == true then
          error("Final var can not have setter")
        end
        if elementAttributes.abstract == true then
          error("Abstract var can not have setter")
        end
        setfenv(fAM.method, fenv)
        local copyFAM = copyVarAccessMethod(fAM)
        copyFAM.method = getMethodValue(fAM.method, class, initialClass)
        class.varAccessMethods[fieldName].setter = copyFAM
      end
      if sAM ~= nil and sAM.type == Setter then
        if elementAttributes.final == true then
          error("Final var can not have setter")
        end
        if elementAttributes.abstract == true then
          error("Abstract var can not have setter")
        end
        setfenv(sAM.method, fenv)
        local copySAM = copyVarAccessMethod(sAM)
        copySAM.method = getMethodValue(sAM.method, class, initialClass)
        class.varAccessMethods[fieldName].setter = copySAM
      end
    end

    for _, accessModifier in ipairs(fieldModifiers) do
      elementAttributes[accessModifier] = true
    end
  end })
end

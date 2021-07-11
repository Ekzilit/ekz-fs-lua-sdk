local _package = nil
local sourceClassGet = nil
local sourceClassSet = nil
_import = {}
local currentClassPool = {
  {
    --master caller, to have caller for frameworks
    --should has access only to public
  }
}
local methodOwnerPool = {
  {
    --master caller, to have caller for frameworks
    --should has access only to public
  }
}

function addToPool(currentClass, methodOwner)
  table.insert(currentClassPool, currentClass)
  table.insert(methodOwnerPool, methodOwner or currentClass)
end

function removeLastFromPool()
  if #currentClassPool == 1 then
    error("Trying to remove master caller")
  end
  table.remove(currentClassPool)

  if #methodOwnerPool == 1 then
    error("Trying to remove master caller")
  end
  table.remove(methodOwnerPool)
end

function getCurrentClass()
  return currentClassPool[#currentClassPool]
end

function getMethodOwner()
  return methodOwnerPool[#methodOwnerPool]
end

local function unwrapClass(wrappedClass)
  return rawget(wrappedClass, "isWrapper") == true and rawget(wrappedClass, "class") or wrappedClass
end

function wrapClass(class, metatable)
  local wrapper = {}
  wrapper.__index = wrapper
  wrapper.isWrapper = true
  wrapper.class = class
  if metatable ~= nil then
    setmetatable(wrapper, metatable)
  else
    setmetatable(wrapper, {__index = getClassElement, __newindex = setClassElement})
  end
  return wrapper
end

function extend(child, parents)
  child = child or {}
  --TODO check the whether wrapper for parent is needed
  local parentsClasses = {}
  if parents ~= nil then
    for _, parent in ipairs(parents) do
      if parent ~= "" then
        table.insert(parentsClasses, parent.class)
      end
    end
  end
  child.parents = parentsClasses
  for k in pairs(child.elementsAttributes.classes) do
    if child.elementsAttributes.classes[k].static == true then
      if rawget(child[k].class, "classAttributes").inner == true then
        rawget(child[k].class, "classAttributes").owner = child
      end
    end
  end
  setmetatable(child, {__index = getClassElement, __newindex = setClassElement})

  local extendedClass = {}
  extendedClass.__index = extendedClass
  extendedClass.isWrapper = true
  extendedClass.class = child
  setmetatable(extendedClass, {
    __call = classInitialization,
    __newindex = setClassElement,
    __index = getClassElement
  })
  return extendedClass
end

local function buildClass(tbl)
  local classCopy = {}
  for orig_key, orig_value in pairs(tbl) do
    if type(orig_value) == "table" then
      if orig_key == "parents" then
        local wrappedParens = {}
        for _, parent in ipairs(orig_value) do
          table.insert(wrappedParens, wrapClass(buildClass(parent)))
        end
        rawset(classCopy, orig_key, wrappedParens)
      else
        rawset(classCopy, orig_key, orig_value)
      end
    else
      rawset(classCopy, orig_key, orig_value)
    end
  end
  setmetatable(classCopy, getmetatable(tbl))
  return classCopy
end

local function initClassElements(cls, initialClass)
  rawset(cls, "varAccessMethods", {})
  for k, v in ipairs(cls) do
    if v == -1 then --static element
      rawset(cls, k, nil)
    elseif rawget(v, "fieldName") then
      if rawget(v, "fieldType") == Method then
        v(cls, initialClass)
      else --var
        v(cls, initialClass)
      end
      rawset(cls, k, nil)
    end
  end
  for k in pairs(rawget(cls, "elementsAttributes").classes) do
    if rawget(cls[k].class, "classAttributes").inner == true then
      rawget(cls[k].class, "classAttributes").owner = cls
    end
  end
  for k, v in pairs(cls) do
    if k == "parents" then
      for _, parent in ipairs(v) do
        initClassElements(rawget(parent, "class"), initialClass)
      end
    end
  end
end

local function validateClassBeforeInit(class)
  local owner = getCurrentClass()
  --TODO check
  if owner ~= nil then
    if rawget(class, "classAttributes").package == true then
      if rawget(owner, "package"):sub(1, #rawget(class, "package")) == rawget(class, "package") then
        error("Can not create new instance of package class from class from another package")
      end
    end
  end
  if rawget(class, "classAttributes").abstract == true then
    error("abstract class can not be initialized")
  end
  if rawget(class, "classAttributes").static == true then
    error("static class can not be initialized")
  end
  if rawget(class, "classAttributes").enum == true then
    error("enum can not be initialized")
  end
  if rawget(class, "classAttributes").interface == true then
    error("interface can not be initialized")
  end
end

local function markClassInitialized(class)
  rawset(class, "initialized", true)
  local parents = rawget(class, "parents")
  if parents ~= nil then
    for _, parent in ipairs(parents) do
      markClassInitialized(rawget(parent, "class"))
    end
  end
end

--initialization of class
function classInitialization(wrappedClass, ...)
  local class = unwrapClass(wrappedClass)

  validateClassBeforeInit(class)
  local copyClass = buildClass(class)
  initClassElements(copyClass, copyClass)
  markClassInitialized(copyClass)

  --wrap
  local wrapper = wrapClass(copyClass)

  addToPool(wrapper)
  if wrapper.init then wrapper.init(...) end
  removeLastFromPool()

  return wrapper
end

local function getClassElementAttributesToGet(class, elementName)
  return class.elementsAttributes.vars[elementName] or class.elementsAttributes.methods[elementName]
      or class.elementsAttributes.classes[elementName]
end

local function getClassElementAttributesToSet(class, elementName)
  return class.elementsAttributes.vars[elementName]
end

local function getClassElementSetter(class, elementName)
  return class.varAccessMethods[elementName] and class.varAccessMethods[elementName].setter or nil
end

local function getClassElementGetter(class, elementName)
  return class.varAccessMethods[elementName] and class.varAccessMethods[elementName].getter or nil
end

local function validateElementValueType(elementAttributes, value)
  if type(value) == Nil then return true
  elseif elementAttributes.type == Any then return true
  elseif elementAttributes.type == Number then
    if Number ~= type(value) then error("Wrong type of value to set, must be number") else return true end
  elseif elementAttributes.type == String then
    if String ~= type(value) then error("Wrong type of value to set, must be string") else return true end
  elseif elementAttributes.type == Boolean then
    if Boolean ~= type(value) then error("Wrong type of value to set, must be boolean") else return true end
  elseif elementAttributes.type == Function then
    if Function ~= type(value) then error("Wrong type of value to set, must be function") else return true end
  elseif elementAttributes.type == Table then
    --TODO possibly will be removed afted adding List, Map .... objects
    if Table ~= type(value) then error("Wrong type of value to set, must be ") else return true end
  elseif elementAttributes.type ~= nil and _G[elementAttributes.type] == nil then
    error("Object with full path name " .. elementAttributes.type .. " not found")
  elseif elementAttributes.type == nil then error("Type for element is not specified")
  end
end

local function setValue(access, class, key, val)
  local varAttributes = class.elementsAttributes.vars[key]
  if varAttributes ~= nil then
    if not ignoreVarSetMethod and access.method ~= nil then access.method(val) else rawset(class, key, val) end
    if varAttributes.subscribers ~= nil then
      for _, v in pairs(varAttributes.subscribers) do
        --validation has been done during subscribing
        if v.valueRequared then
          local elementAttributes = getClassElementAttributesToSet(class, key)
          if elementAttributes.getter ~= nil then
            validateAccess(getMethodOwner(), class, elementAttributes.getter, key)
            rawget(v.subscriber.class, v.subscriberMethodName)(elementAttributes.getter.method(rawget(class, key)))
          else
            rawget(v.subscriber.class, v.subscriberMethodName)(rawget(class, key))
          end
        else
          rawget(v.subscriber.class, v.subscriberMethodName)()
        end
      end
    end
  else
    error("Can not find var " .. key)
  end
end

local function checkParentsOnProtectedAccess(parents, target)
  if parents == nil then return false end
  for _, parent in ipairs(parents) do
    local unwrappedParent = unwrapClass(parent)
    if unwrappedParent == target then
      return true
    else
      if checkParentsOnProtectedAccess(rawget(unwrappedParent, "parents"), target) == true then
        return true
      end
    end
  end
  return false
end

function validateAccess(object, target, elementAttributes, elementName)
  if elementAttributes.private == true then
    if target ~= object then
      error("no access to private element " .. elementName)
    end
  elseif elementAttributes.package == true then
    if rawget(object, "package"):sub(1, #rawget(target, "package")) == rawget(target, "package") then
      error("no access to package element " .. elementName)
    end
  elseif elementAttributes.protected == true then
    local owner = rawget(target, "classAttributes").inner == true
        and rawget(object, "classAttributes").owner or object
    if owner == target then
      --is a child
      return
    else
      if checkParentsOnProtectedAccess(rawget(owner, "parents"), target) == true then return end
    end
    --does not a child - rejected
    error("no access to protected element " .. elementName)
  elseif elementAttributes.public ~= true then
    error(elementName .. " without access modifier")
  end
end

local function processSetElement(class, key, val)
  local elementAttributes = getClassElementAttributesToSet(class, key)
  validateElementValueType(elementAttributes, val)
  if elementAttributes.final == true then error("final value can not be setted") end

  if rawget(class, "initialized") ~= true and elementAttributes.static ~= true then
    error("Into not initialized class can set only into static elements")
  end
  if elementAttributes.abstract == true then error("abstract value can not be setted") end

  if not ignoreVarSetMethod then
    elementAttributes = getClassElementSetter(class, key) or elementAttributes
  end
  validateAccess(getMethodOwner(), class, elementAttributes, key)
  setValue(elementAttributes, class, key, val)
  return true
end

local function processGetElement(class, key)
  --TODO test is memory increasing more
  local elementAttributes = getClassElementAttributesToGet(class, key)
  if elementAttributes.static ~= true and rawget(class, "initialized") ~= true then
    error("From not initialized class can get only static elements")
  end
  if elementAttributes.abstract == true then error("abstract value can not be getted") end

  local caller = getMethodOwner()
  if not ignoreVarGetMethod and  class ~= caller then
    elementAttributes = getClassElementGetter(class, key) or elementAttributes
  end
  validateAccess(caller, class, elementAttributes, key)
  return not ignoreVarGetMethod and elementAttributes.method ~= nil and elementAttributes.method()
      or rawget(class, key)
end

local function setIntoParents(parents, key, val)
  if parents ~= nil then
    for _, wrappedParent in ipairs(parents) do
      local result
      local parent = unwrapClass(wrappedParent)
      if (getClassElementAttributesToSet(parent, key) and processSetElement(parent, key, val))
             or setIntoParents(rawget(parent, "parents"), key, val) then
        return true
      end
    end
  end
  return false
end

function setClassElement(wrappedClass, key, val)
  local class = unwrapClass(wrappedClass)
  if getClassElementAttributesToSet(class, key) and processSetElement(class, key, val) then return end
  --else will find in parents
  if not setIntoParents(rawget(class, "parents"), key, val) then
    error("Trying to set value into not existing element " .. key)
  end
end

local function getFromParents(parents, key)
  local result
  for _, wrappedParent in ipairs(parents) do
    local parent = unwrapClass(wrappedParent)
    if getClassElementAttributesToGet(parent, key) then
      result = processGetElement(parent, key)
      break
    else
      --does not have value
      --get from parent
      result = parent[key]
    end
    if result ~= nil then break end
  end
  return result
end

function getClassElement(wrappedClass, key)
  local class = unwrapClass(wrappedClass)
  --[[
    if class.objectName == "NewAttribute" and key == "text" then
      print(class.package)
    end
  ]]
  if getClassElementAttributesToGet(class, key) then return processGetElement(class, key) end
  --else will find in parents
  return getFromParents(rawget(class, "parents"), key)
  --error("Trying to get not existing element " .. key)
end

local function finishClassDeclaration(rawClass, name)
  local child = unwrapClass(rawClass)
  if child.classAttributes.inner == true then
    local ownerChainName = ""
    local owner = child.classAttributes.owner
    while owner ~= nil do
      ownerChainName = "." .. rawget(owner, "objectName") .. ownerChainName
      owner = owner.classAttributes.owner
    end
    child.package = child.package .. ownerChainName
    _G[child.package .. "." .. name] = rawClass
  else
    _G[child.package .. "." .. name] = rawClass
    _package = nil
    _import = {}
  end
  return rawClass
end

function getFullPathFromImports(className)
  for _, val in pairs(_import) do
    local _, ePos = string.find(val, className)
    if ePos and ePos == string.len(val) then
      return val
    end
  end
  error("Can not find import with name " .. className)
end

local function populateRawClass(rawClass, name, interfaces, classAttributes)
  rawClass.initialized = false
  rawClass.interfaces = interfaces
  rawClass.elementsAttributes = {
    classes = {};
    methods = {};
    vars = {};
  }
  rawClass.varAccessMethods = {}
  rawClass.classAttributes = classAttributes
  rawClass.package = _package
  rawClass.imports = table.clone(_import)
  --TODO test: possibly objectName will be overriden by Object's class objectName after init
  rawClass.objectName = name
  rawClass.elementsAttributes.vars["objectName"] = {}
  rawClass.elementsAttributes.vars["objectName"].public = true
  rawClass.elementsAttributes.vars["objectName"].type = Any
end

local function initEnumValues(rawClass)
  if rawClass.classAttributes.enum == true then
    if type(rawClass.values) ~= "table" then
      error("Enum " .. rawClass.objectName .. " does not have values")
    else
      rawClass.elementsAttributes.vars["values"] = {}
      rawClass.elementsAttributes.vars["values"].static = true
      rawClass.elementsAttributes.vars["values"].public = true
      --to call enum value skipping values table
      for k, v in pairs(rawClass.values) do
        if type(v) == "table" then
          rawClass[k] = v.value
        else
          rawClass[k] = v
        end
        rawClass.elementsAttributes.vars[k] = {}
        rawClass.elementsAttributes.vars[k].static = true
        rawClass.elementsAttributes.vars[k].public = true
      end
    end
  end
end

local function initStaticElements(rawClass)
  for i, v in ipairs(rawClass) do
    if (rawget(v, "fieldName") ~= nil or rawget(v, "className") ~= nil) and rawget(v, "static") then
      v(rawClass)
      rawClass[i] = -1--should be removed on initialization
    end
  end
end

local function declareValidation(rawClass, parent)
  local fullParentName = rawget(parent.class, "package") .. "." .. rawget(parent.class, "objectName")
  local parentClass = parent --_G[fullParentName]
  --TODO validation logic for parent which is inner class is needed (access modifiers)
  --    if parentClass then
  if rawClass.classAttributes.interface == true and
         parentClass.class.classAttributes.interface == false then
    error("Interface can not extend class")
  elseif rawClass.classAttributes.interface == true and parentClass.class.classAttributes.interface == true then
    --interface extends interface
    --TODO redo
    rawClass.parent = parentClass
    error("must be redone")
    return finishClassDeclaration(rawClass, rawClass.objectName)
  elseif rawClass.classAttributes.interface == false and parentClass.class.classAttributes.interface == true then
    error("Class can not extend interface")
  else
    --TODO redo on interfaces are already classes not the classes names
    if rawClass.interfaces then
      for i, interface in ipairs(rawClass.interfaces) do
        local interfaceDeclaration = _G[getFullPathFromImports(interface)]
        if interfaceDeclaration then
          --TODO may be all elements to implement have to be public?
          local interfaceElements = {}
          for i, v in ipairs(interface) do
            table.insert(interfaceElements, i)
          end
          local parent = interface.parent
          while parent ~= nil do
            for i, v in pairs(parent) do
              table.insert(interfaceElements, i)
            end
            parent = parent.parent
          end

          local childElements = {}
          for i, v in pairs(rawClass) do
            table.insert(childElements, i)
          end

          for i, v in ipairs(interfaceElements) do
            if not table.contains(childElements, v) then
              error("Class " .. _package .. "." .. rawClass.objectName .. " must implement interface element " .. v)
            end
          end
        else
          error("Interface declaration " .. fullInterfaceName .. " not found")
        end
      end
    end

    --TODO redo on package starts with other package (like in def)
    if parentClass.class.classAttributes.package == true and rawClass.package ~= parentClass.class.package then
      error("Can not extend package class from other package")
    end
    if parentClass.class.classAttributes.final == true then
      --final class handling
      error("Parent class " .. parentClass.class.objectName .. " is final and cannot be extended")
    elseif parentClass.class.classAttributes.final == true then
      --static class handling
      error("Parent class " .. parentClass.class.objectName .. " is static and cannot be extended")
    elseif parentClass.class.classAttributes.abstract == true then
      --abstract class handling
      local parentAbstractElements = {}
      --[[ for i, v in pairs(parentClass.class) do
         if parentClass.class.elementsAttributes.vars[i].abstract == true or
                parentClass.class.elementsAttributes.methods[i].abstract == true or
                parentClass.class.elementsAttributes.classes[i].abstract == true then
           table.insert(parentAbstractElements, i)
         end
       end]]
      local implementedAbstractElements = {}
      for i, v in pairs(rawClass) do
        if table.contains(parentAbstractElements, i) then
          table.inset(implementedAbstractElements, i)
        end
      end
      if table.size(parentAbstractElements) ~= table.size(implementedAbstractElements) then
        error("Not all abstract elements from class " .. fullParentName .. " implemented in class " ..
            _package .. "." .. rawClass.objectName)
        for i, v in pairs(parentAbstractElements) do
          if not table.contains(implementedAbstractElements, v) then
            error(v .. " must be implemented in class " .. _package .. "." .. rawClass.objectName)
          end
        end
      end
    end
    rawClass.parentName = fullParentName
  end
end

function declareClass(name, parents, rawClass, modifiers, interfacesToImplement)
  populateRawClass(rawClass, name, interfacesToImplement, modifiers)
  initEnumValues(rawClass)
  initStaticElements(rawClass)

  if parents == nil or #parents == 0 then
    if name == "Object" then
      return finishClassDeclaration(extend(rawClass, nil), name)
    else
      if rawClass.classAttributes.interface == true then
        return finishClassDeclaration(rawClass, name)
      end
      return finishClassDeclaration(extend(rawClass, _G["sdk.Object"]), name)
    end
  else
    for _, parent in ipairs(parents) do
      declareValidation(rawClass, parent)
    end
    return finishClassDeclaration(extend(rawClass, parents), name)
  end
end

function this() return wrapClass(getCurrentClass()) end

function super()
  local caller = getMethodOwner()
  local parents = rawget(caller, "parents")
  if parents ~= nil and #parents ~= 0 then
    return parents[1]
  else
    error(rawget(caller, "objectName") .. " doesn't have parent")
  end
end

function classPackage(packagePath) _package = packagePath end

function import(fullClassName)
  local className
  local pos = fullClassName:reverse():find("%.")
  if pos ~= nil then
    local ePos = #fullClassName - pos + 2
    className = string.sub(fullClassName, ePos)
  else
    className = fullClassName
  end
  _import[className] = fullClassName
end

function getFullClassNameFromImports(className)
  local classCaller = getMethodOwner()
  local fullClassName
  for _, val in pairs(classCaller.imports) do
    local _, ePos = string.find(val, "%." .. className)
    if ePos and ePos == string.len(val) then
      fullClassName = val
      break
    end
  end
  return fullClassName
end

getfenv(0)["def"] = function(className)
  local fullClassName
  local firstPosition = string.find(className, "%.")
  if firstPosition then
    --className is the fullClassName
    fullClassName = className
  else
    fullClassName = getFullClassNameFromImports(className)
  end
  if fullClassName then
    local wrappedCalledClass = _G[fullClassName]
    if wrappedCalledClass == nil then
      error("Can not find class " .. fullClassName)
    end
    local classCaller = getCurrentClass()
    if rawget(unwrapClass(wrappedCalledClass), "classAttributes").package == true then
      if rawget(classCaller, "package"):sub(1, #rawget(unwrapClass(wrappedCalledClass), "package"))
             == rawget(unwrapClass(wrappedCalledClass), "package") then
        error("Access to package class definition not from the same package")
      end
    end
    return wrappedCalledClass
  else
    error("cannot find model " .. className .. " for class " .. classCaller.objectName)
  end
end
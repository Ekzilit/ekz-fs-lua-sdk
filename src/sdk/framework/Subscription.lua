local function addSubscriber(subscribers, subscriber, subscriberMethodName, valueRequared)
  subscribers[tostring(subscriber) .. "." .. subscriberMethodName] = {
    subscriber = subscriber,
    subscriberMethodName = subscriberMethodName,
    valueRequared = valueRequared,
    suspended = false
  }
end

local function getVarAttributesFromParents(parents, varName)
  if parents == nil then return nil end
  local varAttributes
  for _, parent in ipairs(parents) do
    varAttributes = parent.class.elementsAttributes.vars[varName]
    if varAttributes ~= nil then return varAttributes end
    varAttributes = getVarAttributesFromParents(rawget(parent.class, "parents"))
    if varAttributes ~= nil then return varAttributes end
  end
  return nil
end

local function getMethodAttributesFromParents(parents, varName)
  if parents == nil then return nil end
  local varAttributes
  for _, parent in ipairs(parents) do
    varAttributes = parent.class.elementsAttributes.vars[varName]
    if varAttributes ~= nil then return varAttributes end
    varAttributes = getVarAttributesFromParents(rawget(parent.class, "parents"))
    if varAttributes ~= nil then return varAttributes end
  end
  return nil
end

local function getVarAttributes(class, varName)
  local targetVarAttributes = class.class.elementsAttributes.vars[varName]
  if targetVarAttributes == nil then
    targetVarAttributes = getVarAttributesFromParents(rawget(class.class, "parents"), varName)
  end
  if targetVarAttributes == nil then
    error("Var " .. varName .. " does not exists in " .. class.objectName)
  end
  return targetVarAttributes
end

local function getMethodAttributes(class, methodName)
  local targetVarAttributes = class.elementsAttributes.methods[methodName]
  if targetVarAttributes == nil then
    targetVarAttributes = getMethodAttributesFromParents(rawget(class, "parents"), methodName)
  end
  if targetVarAttributes == nil then
    error("Method " .. methodName .. " does not exists in " .. class.objectName)
  end
  return targetVarAttributes
end

local function validateSubscriber(targetVarName, targetVarAttributes, subscriber, subscriberMethodName)
  if targetVarAttributes.subscribers == nil then
    error("Var " .. targetVarName .. " does not have subscribers")
  elseif targetVarAttributes.subscribers[tostring(subscriber) .. "." .. subscriberMethodName] == nil then
    error("Var " .. targetVarName .. " does not have subscriber " .. subscriber.objectName .. "." .. subscriberMethodName)
  end
end

function subscribe(subscriber, subscriberMethodName, target, targetVarName, valueRequared)
  local targetVarAttributes = getVarAttributes(target, targetVarName)
  if targetVarAttributes.subscribers == nil then
    targetVarAttributes.subscribers = {}
  else
    if targetVarAttributes.subscribers[tostring(subscriber) .. "." .. subscriberMethodName] ~= nil then
      error("Subscriber " .. subscriber.objectName .. "." .. subscriberMethodName .. " already exists")
    end
  end
  local caller = getMethodOwner()
  local subscriberMethodAttributes = getMethodAttributes(subscriber.class, subscriberMethodName)
  validateAccess(caller, target, targetVarAttributes, targetVarName)
  validateAccess(caller, subscriber, subscriberMethodAttributes, subscriberMethodName)
  validateAccess(subscriber, target, targetVarAttributes, targetVarName)
  validateAccess(target, subscriber, subscriberMethodAttributes, subscriberMethodName)
  addSubscriber(targetVarAttributes.subscribers, subscriber, subscriberMethodName, valueRequared)
end

function unsubscribe(subscriber, subscriberMethodName, target, targetVarName)
  local targetVarAttributes = getVarAttributes(target, targetVarName)
  validateSubscriber(targetVarName, targetVarAttributes, subscriber, subscriberMethodName)
  targetVarAttributes.subscribers[tostring(subscriber) .. "." .. subscriberMethodName] = nil
end

function suspend(subscriber, subscriberMethodName, target, targetVarName)
  local targetVarAttributes = getVarAttributes(target, targetVarName)
  validateSubscriber(targetVarName, targetVarAttributes, subscriber, subscriberMethodName)
  targetVarAttributes.subscribers[tostring(subscriber) .. "." .. subscriberMethodName].suspend = true
end

function resume(subscriber, subscriberMethodName, target, targetVarName)
  local targetVarAttributes = getVarAttributes(target, targetVarName)
  validateSubscriber(targetVarName, targetVarAttributes, subscriber, subscriberMethodName)
  targetVarAttributes.subscribers[tostring(subscriber) .. "." .. subscriberMethodName].suspend = false
end

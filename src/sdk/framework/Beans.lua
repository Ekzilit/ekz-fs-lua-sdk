local globalContext = 0

local function startAddon(contextName)
    local starter = getfenv(0)[contextName .. ".Starter"]
    if starter then
        starter():start()
    else
        --TODO should be changed on error after test
        print("Could not find starter for context " .. contextName)
    end
end

local function recordContext(context, parentName, isGlobal)
    local name = context.name
    if isGlobal and globalContext ~= 0 then
        error("Global context already exists")
    elseif isGlobal then
        globalContext = context
        context.contexts = {}
    else
        if globalContext.contexts[name] then
            error("Context " .. name .. " already exists")
        elseif parentName then
            if globalContext.contexts[parentName] == nil then
                error("Parent context " .. name .. " does not exist")
            else
                context.parent = globalContext.contexts[parentName]
            end
        elseif parentName == nil then
            context.parent = globalContext
        end
        globalContext.contexts[name] = context
    end
end

getfenv(0)["context"] = function(contextName, initBeansFunc, parentName, isGlobal)
    local context = {
        name = contextName;
        parent = nil;
        initBeans = initBeansFunc;
        beans = {}
    }
    recordContext(context, parentName, isGlobal)
    addToPool(context)
    context.initBeans()
    startAddon(context.name)
    removeLastFromPool()
end

local function getContextByName(contextName)
    if globalContext.name == contextName then
        return globalContext
    else
        if globalContext.contexts[contextName] then
            return globalContext.contexts[contextName]
        else
            error("Could not find context " .. contextName)
        end
    end
end

local function getContextByPackage(classPackage)
    local position = string.find(classPackage, "%.")
    local contextName
    if position then
        contextName = string.sub(classPackage, 1, position - 1)
    else
        contextName = classPackage
    end
    return getContextByName(contextName)
end

function getBean(class, beanId)
    local context = getContextByPackage(rawget(class, "package"))
    local bean = context.beans[beanId]
    if bean ~= nil then
        return bean
    elseif context.parent ~= nil then
        local parentContext = context.parent
        while parentContext ~= nil do
            bean = parentContext.beans[beanId]
            if bean ~= nil then
                return bean
            end
            parentContext = parentContext.parent
        end
    end
    error("cannot find bean " .. beanId)
end

local function getBeanClass(bean, targetClass)
    local wrappedClassInited
    if bean.singleton == true then
        wrappedClassInited = bean.class
    else
        wrappedClassInited = bean.params ~= nil and bean.class(unpack(bean.params)) or bean.class()
    end
    --package modifier validation
    if targetClass ~= nil then
        if rawget(rawget(wrappedClassInited, "class"), "classAttributes").package == true then
            if rawget(targetClass, "package") ~= rawget(wrappedClassInited, "package") then
                error("Access to inject bean with package class into class with another package")
            end
        end
    end
    return wrappedClassInited
end

getfenv(0)["bean"] = function(id, classFullName, params, prototype)
    local wrappedClassDef = getfenv(0)[classFullName]
    if wrappedClassDef then
        local context = getCurrentClass()
        local bean = {
            singleton = prototype == true and false or true;
            getClass = getBeanClass;
        }
        if bean.singleton == true then
            local wrappedClassInited = params ~= nil and wrappedClassDef(unpack(params)) or wrappedClassDef()
            bean.class = wrappedClassInited
        else
            bean.params = params
            bean.class = wrappedClassDef
        end
        context.beans[id] = bean
    else
        error("Could not find class " .. classFullName .. " for bean " .. id)
    end
end

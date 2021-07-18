local stream = {}
mapStream = setmetatable({}, {__call = function(self, tbl)
  if type(tbl) ~= Table then
    error("Stream can only work with tables")
  end
  stream.tbl = tbl
  return stream
end})

local function updateResult(streamContainer)
  if streamContainer.tbl ~= streamContainer.tmpTbl then
    streamContainer.tbl = streamContainer.tmpTbl
  end
end

local function addValue(k, v, streamContainer)
  if streamContainer.tmpTbl == nil then streamContainer.tmpTbl = {} end
  streamContainer.tmpTbl[k] = v
end

function stream.filter(self, filterFunc)
  for k, v in pairs(self.tbl) do
    if filterFunc(k, v) == true then
      addValue(k, v, self)
    end
  end
  updateResult(self)
  return self
end

function stream.map(self, mapFunc)
  for k, v in pairs(self.tbl) do
    local result = mapFunc(k, v)
    if result ~= nil then
      addValue(k, result, self)
    else
      error("result of map function must not be nil")
    end
  end
  updateResult(self)
  return self
end

function stream.get(self)
  return self.tbl
end

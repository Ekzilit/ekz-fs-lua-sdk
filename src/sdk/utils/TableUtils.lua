function table.clone(orig, copies)
  copies = copies or {}
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    if copies[orig] then
      copy = copies[orig]
    else
      copy = {}
      for orig_key, orig_value in next, orig, nil do
        copy[table.clone(orig_key, copies)] = table.clone(orig_value, copies)
      end
      copies[orig] = copy
      setmetatable(copy, table.clone(getmetatable(orig), copies))
    end
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

function table.merge(tableFirst, tableSecond)
  tableFirst = tableFirst or {}
  if tableSecond and type(tableSecond) == "table" then
    for _, v in pairs(tableSecond) do
      table.insert(tableFirst, v)
    end
  end
  return tableFirst
end

function table.contains(tbl, value)
  if type(tbl) ~= "table" then error("Table type expected to check whether contains element") end
  for _, v in ipairs(tbl) do
    if v == value then
      return true
    end
  end
  return false
end

function table.removeElement(tbl, value)
  if type(tbl) ~= "table" then error("Table type expected to remove from") end
  for k, v in ipairs(tbl) do
    if v == value then
      tbl[k] = nil
      return true
    end
  end
  return false
end

function pairsSorted(tab, sortField, direction)
  local keys = {}
  for k in pairs(tab) do
    keys[#keys + 1] = k
  end
  table.sort(keys, function(a, b)
    if direction == "descending" then
      return tab[a][sortField] > tab[b][sortField]
    else
      return tab[a][sortField] < tab[b][sortField]
    end
  end)
  local j = 0
  return function()
    j = j + 1
    local k = keys[j]
    if k ~= nil then
      return k, tab[k]
    end
  end
end

function table.size(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

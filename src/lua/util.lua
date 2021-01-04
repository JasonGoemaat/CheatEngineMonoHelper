util = util or {}

util.loadTextFile = function (name, useTableFile)
  if useTableFile then
    local tableFile = findTableFile(name)
    if not tableFile then return nil, 'Unable to open table file "'..tostring(name)..'"' end
    local ss = createStringStream()
    ss.Position = 0 -- recommended on wiki: https://wiki.cheatengine.org/index.php?title=Lua:Class:TableFile
    ss.CopyFrom(tableFile.Stream, 0)
    local text = ss.DataString
    ss.destroy()
    return text
  else
    local path = getMainForm().openDialog1.InitialDir..name
    local f, err = io.open(path, "r")
    -- fall back to table file if disk file error (doesn't exist)
    if f == nil then return loadTextFile(name, true) end
    local text = f:read("*all")
    f:close()
    return text
  end
end

--[[
  Save a string to a text file.  If useTableFile is true it will be saved as
  a TableFile.  The directory should be where the cheat file is, it is the
  initial directory for the dialog when you are saving your cheat table.
--]]
util.saveTextFile = function(name, text, useTableFile)
  if useTableFile then
    local tf = findTableFile(name)
    if tf ~= nil then
      tf.delete()
      tf = nil
    end
    tf = createTableFile(name)
    local ss = createStringStream(text)
    tf.Stream.CopyFrom(ss, 0)
    ss.destroy()
    return true
  else
    local path = getMainForm().saveDialog1.InitialDir..name
    local f, err = io.open(path, "w")
    if f == nil then return nil, err end
    f:write(text)
    f:close()
    return true
  end
end

--[[
  For mono symbols, you have to surround them in quotes for use in AA
]]
function util.safeAddress(s)
  local tbl = {}
  for a in string.gmatch(s, "([^+]+)[+]?") do table.insert(tbl, a) end
  local result = '"'..tbl[1]..'"'
  if #tbl > 1 then result = result..'+'..tbl[2] end
  return result
end

function util.split(s, separator)
  local tbl = {}
  for str in string.gmatch(s, "([^"..separator.."]+)") do table.insert(tbl, str) end
  return tbl
end

function util.trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

--[[
    Pretty-print serialize the passed object and return the results
    as a string.  This does nice indenting and follows metatables.  It
    is not guaranteed to provide the same object back if the string is
    loaded because it just replaces circular references with a string
    among other things.  It does try to keep tables/arrays on one line
    if there is room (120 characters).
--]]
function util.pretty(value, funcs, indent, done, stack)
  indent = indent or 0
  funcs = funcs or {}
  done = done or {}
  stack = stack or { {value=value} } -- initialize with passed value, no key

  -- if a 'userdata', use metatable
  local l = value
  if type(value) == "userdata" then
    l = getmetatable(value)
  end

  if type(l) == "table" then
    -- if we've already serialized the table, return string representation
    -- to avoid self-referencing in recursion.  Only the first serialization
    -- will have the full serialized string
    if done[l] then return tostring(l) end
    done[l] = true

    local list = {}

    -- here we return "{", the values, and "}"
    if (#l > 0) then
      -- if we have a count ('#'), then it's just an array of values
      for i,v in ipairs(l) do
        table.insert(list, util.pretty(v, funcs, indent + 2, done, stack))
      end
    else
      -- no count, so either empty or object with key/value
      -- first we sort the keys
      local keys = {}
      for k,v in pairs(l) do table.insert(keys, k) end
      table.sort(keys)

      local last = {key = "UNKNOWN", value = "NONE"}
      table.insert(stack, last)
      for i,k in ipairs(keys) do
        local propValue = value[k]
        last.key = k
        last.value = value[k]
        for j,f in ipairs(funcs) do
          local returnValue = f(value, k, value[k], stack, indent)
          if returnValue ~= nil then
            propValue = returnValue
            break
          end
        end
        table.insert(list, string.format("%s = %s", tostring(k), util.pretty(propValue, funcs, indent+2, done, stack)))
      end
      table.remove(stack, #stack)
    end

    -- now we find the total size, add 200 if there are line breaks
    local size = 0
    for i,v in ipairs(list) do
      size = size + string.len(v) + 2
      if string.find(v, "\r\n") then
        size = 200
        break;
      end
    end
    -- if it's small enough, join with commas
    if (size < 120) then
      local result = {"{ "}
      for i,v in ipairs(list) do
        if i > 1 then table.insert(result, ", ") end
        table.insert(result, v)
      end
      table.insert(result, " }")
      return table.concat(result);
    else
      local indentString1 = string.rep(" ", indent)
      local indentString2 = string.rep(" ", indent + 2)
      local result = {"{\r\n"}
      for i,v in ipairs(list) do
        table.insert(result, indentString2)
        table.insert(result, v)
        if (i < #list) then table.insert(result, ",") end
        table.insert(result, "\r\n")
      end
      -- table.insert(result, indentString)
      table.insert(result, indentString1)
      table.insert(result, "}")
      return table.concat(result);
    end
  end

  if type(value) == "string" then
    return string.format("\"%s\"", value)
  end
  return tostring(value)
end



--[[
    Values and functions used by util.serialize(t)
---]]

local oddvals = {[tostring(1/0)] = '1/0', [tostring(-1/0)] = '-1/0', [tostring(-(0/0))] = '-(0/0)', [tostring(0/0)] = '0/0'}

local kw = {['and'] = true, ['break'] = true, ['do'] = true, ['else'] = true,
	['elseif'] = true, ['end'] = true, ['false'] = true, ['for'] = true,
	['function'] = true, ['goto'] = true, ['if'] = true, ['in'] = true,
	['local'] = true, ['nil'] = true, ['not'] = true, ['or'] = true,
	['repeat'] = true, ['return'] = true, ['then'] = true, ['true'] = true,
	['until'] = true, ['while'] = true}

local getchr = function(c)
  return "\\" .. c:byte()
end

local make_safe = function(text)
  return ("%q"):format(text):gsub('\n', 'n'):gsub("[\128-\255]", getchr)
end

local write = function(t, memo, rev_memo)
	local ty = type(t)
	if ty == 'number' then
		t = format("%.17g", t)
		return oddvals[t] or t
	elseif ty == 'boolean' or ty == 'nil' then
		return tostring(t)
	elseif ty == 'string' then
		return make_safe(t)
	elseif ty == 'table' or ty == 'function' then
		if not memo[t] then
			local index = #rev_memo + 1
			memo[t] = index
			rev_memo[index] = t
		end
		return '_[' .. memo[t] .. ']'
	else
		error("Trying to serialize unsupported type " .. ty)
	end
end

local write_key_value_pair = function(k, v, memo, rev_memo, name)
	if type(k) == 'string' and k:match '^[_%a][_%w]*$' and not kw[k] then
		return (name and name .. '.' or '') .. k ..'=' .. write(v, memo, rev_memo)
	else
		return (name or '') .. '[' .. write(k, memo, rev_memo) .. ']=' .. write(v, memo, rev_memo)
	end
end

local is_cyclic = function(memo, sub, super)
	local m = memo[sub]
	local p = memo[super]
	return m and p and m < p
end

local write_table_ex = function(t, memo, rev_memo, srefs, name)
	if type(t) == 'function' then
		return '_[' .. name .. ']=loadstring' .. make_safe(string.dump(t))
	end
	local m = {}
	local mi = 1
	for i = 1, #t do -- don't use ipairs here, we need the gaps
		local v = t[i]
		if v == t or is_cyclic(memo, v, t) then
			srefs[#srefs + 1] = {name, i, v}
			m[mi] = 'nil'
			mi = mi + 1
		else
			m[mi] = write(v, memo, rev_memo)
			mi = mi + 1
		end
	end
	for k,v in pairs(t) do
		if type(k) ~= 'number' or math.floor(k) ~= k or k < 1 or k > #t then
			if v == t or k == t or is_cyclic(memo, v, t) or is_cyclic(memo, k, t) then
				srefs[#srefs + 1] = {name, k, v}
			else
				m[mi] = write_key_value_pair(k, v, memo, rev_memo)
				mi = mi + 1
			end
		end
	end
	return '_[' .. name .. ']={' .. table.concat(m, ',') .. '}'
end


--[[
    A function more appropriate for serializing objects in a reproduceable way.
--]]
function util.serialize(t)
  local memo = {[t] = 0}
	local rev_memo = {[0] = t}
	local srefs = {}
	local result = {}

	-- phase 1: recursively descend the table structure
	local n = 0
	while rev_memo[n] do
		result[n + 1] = write_table_ex(rev_memo[n], memo, rev_memo, srefs, n)
		n = n + 1
	end

	-- phase 2: reverse order
	for i = 1, n*.5 do
		local j = n - i + 1
		result[i], result[j] = result[j], result[i]
	end

	-- phase 3: add all the tricky cyclic stuff
	for i, v in ipairs(srefs) do
		n = n + 1
		result[n] = write_key_value_pair(v[2], v[3], memo, rev_memo, '_[' .. v[1] .. ']')
	end

	-- phase 4: add something about returning the main table
	if result[n]:sub(1, 5) == '_[0]=' then
		result[n] = 'return ' .. result[n]:sub(6)
	else
		result[n + 1] = 'return _[0]'
	end

	-- phase 5: just concatenate everything
	result = table.concat(result, '\n')
	return n > 1 and 'local _={}\n' .. result or result
end

function util.map(t, f)
  local results = {}
  local func = f or tostring
  for i,v in ipairs(t) do
    table.insert(results, func(v))
  end
  return results
end

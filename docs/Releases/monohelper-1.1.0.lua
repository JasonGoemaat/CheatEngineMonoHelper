--[[--------------------------------------------------------------------------------
    -- Forms - Save strings as temp files, then load using createFormFromFile()  
    --------------------------------------------------------------------------------]]

local stringFormMonoClass = [==========[<?xml version="1.0" encoding="utf-8"?>
<FormData>
  <formMonoClass Class="TCEForm" Encoding="Ascii85">/yTK^8${c!?7msfX.9L%MdIQc2%!i#a/iSfwG[w3Ysw8Y[Kxk5cW0K{aT8zrG5QUV]XxAk]V}0BB[_{Vs2AqX#xv[:OOyz4.If^1_L48mym]Ld2VgSleeO*UPkS@:9=bb=Knd-{Fwg6!XwK_6R]WT,izTxk+!F}][G^4i7DsGpKdC!im?-UB)-%rDskPUQF)Rzc]O6B[^z_1jKxFN;3I7ftCcx#cPvI2B]=2@,6K60%kK1Inq+.g}B+HlEQo:GCJB^HvLD=hC/st1bW!#ougl#/+QCofy@d(g#(?4h)n8Fz+i)?5xP$o*@=dcxr)_y%yGnV1$nxVZO[j:r2!YoA0+:wJL^qMWa,vD*+B#@Aa^}w.+i9/DmKABOH)-/:7OY#V[,0t=5X%AnZNZI@*4P)qUochB[2IovkhHMj}pgGSwG;$,pf+DV1m(P:6eYFu^E_4i5L4sm06/=9(J7sgHB8O!u?#{an(pMPbnmp0mu^idQi:$okj^1k1uL#v47W@Fp/*YhfEm]%Ci;ljoM.XY223(DY6Rw1U16MK{7p_0/,oR*QnI[Fx^!y8#j2ckVB]M#Nx8-_c+WC%64uvTTI4@LHr!jItz$,W392+Q{fnI+0ZtCx}tJD9YPG3]{w.DidKFjDj=a(KvF(!Ybq*}ChFDvxykE{+J#tY*OFjmoR(+2mnbeOfW6L(G}VH6iWtST43*e09*7_ViOIcO=vZQlX[;]P:XP:O6M/=H[=ynj_%^B#R%zdd94B?*STJO,#0_F?tQwd/1zU0A=]i8tY!aETBz0@KQl]EvYNz8vptiL[Ikvlkeh]!QcAwJIEFM-@Dm0,of/B6lzLjd8rM.Gnrpfh[pd*BDc8ZD{3.LaY.#?7HvWhx2*km@.8k@?mT2K5-1RP/@sV)KQkKCt%8mdvjf.RWoE7?]4qdK5r791pEnq06lk%U@FE0#]DJXJVY@=G0$jxo,z).[8j,RK1M0c81DiaKt9iB)TJ^frZR-yyca?(fKZ]Vg)1UN1(9oZN*#C}cZbo/q1+}b-]OP]=bq+tqn,{9S:jv5gov0-xD/b,@6QeXDuMD?87SU{rt4Hrj)e$Es?Lbf0CIUI(nQD0J]K73r}V?b/@f8mm,,6(sDjPbLj]EI^7T4dCGHNGn{Yav,s/u:/3H}_92;K+QF?o7A!IP*hw:FG6p.l-9ssiZVrCF%)tkrZjW7EQC0;Gu5)-93DF{wtVS,.rrp]v9wuiG@k1h]dr]6f0e,)[j1cvUB)p3+ZXQR5Y+IqN*U832[*Bii9Atfj5DM^1R2i),;p7,TTWtgGpCMyR#t=?cSt+w-4Ay5^,$?%1PleRCoEy*I@UNgbZD5JU:h,R1^LE((gIpcuQ6Y!Q}nmbV9Cn%pG5/$YWLSPU?]TWVY8/d*XGbEDX9GFx_.#z,L</formMonoClass>
</FormData>
]==========]

local stringFormMonoImage = [==========[<?xml version="1.0" encoding="utf-8"?>
<FormData>
  <formMonoImage Class="TCEForm" Encoding="Ascii85">#goBu):ZT+Wtl^dlQI).N^(5n(hQF{X^MQJn@1eo5fn$ZHIXe;RtGr4190F.cqtCN1hVAXjWcD*0l3*K^?z^hx4+qE0Ksbh3I+QToQw1+QkP4f?kNSb@5lX/)jLR@IiYbP=eCTy?ZA0ZI(bMlCiZ8DJe+6*v,mF+jD,(E%sth}1CLRX$vU-f(i9$XRV@:QA!q!f%hX+b6)]dyOt_prhLp]G9=zuU40V/tG9sQgs]],Y[?WW7%bqQH*RxO9*We0CaVdE@Zgdl/@M}s?b/WI$4H*R(bICOq:vG*bM5b2J?8GRcx[DbAAiUL]9lSLiz[S=[8zTH1hct@Prs^Avs4E{u#(j9zj(]G[D0JP0B(qo^2%G=}m+ra!0MJv,XL@_ZnSM_HxTV)cJhf9I9+4KLxJqx*H(z;36.k,8JMD^Qkiz#h)TZim?DT^LGY6G3@@j/pDI11cbh0/UjyJR^0G:vZE5TzyieiSvQC;a(0j_I1#Y1q]28AO^@P9DA)8H^GkPRD[5Z%y%t^HKF?{v6g?tUv!E3cP_:l]R+yV4f4v4-{wf!3Qc8fU38JaQy9#^U-{8!JCVHkhj,CSHPtPb3.lul(V3=_gdgp9Os[Rb%_?;C,WXNw,f/6f.*]R#b*wa-.kPtDstrDfs3NGb%qJ6y3fSIFkJp7HU$DGcFw09Lg7,2RjA700</formMonoImage>
</FormData>
]==========]

local stringFormMonoSearch = [==========[<?xml version="1.0" encoding="utf-8"?>
<FormData>
  <formMonoSearch Class="TCEForm" Encoding="Ascii85">%}#Ei,cprUq+#;fbZc+SoAl.WE)L-l:ODn@%^B_H;xFG;($Pw03Dcw=)cVojK[8=K)V+xt2#OX6(]Y18()T9kQCj]j@g2!t@,BL!hBKq?n}$;oZUQj6IDG.}-Iu34S^z*-OOG:=#3-7}=w#W,.XJY2SC}v@!ui8=Mm%*;0k!W+AZE[22D;N{gfq9HcD41k](}+f6X}X)=S^V3[T1{XwuIh7UVDfza3G6cpegQhCL(I}P[C8Z%M(*4?n{c[tonGI]eChq(2V([du2{+:Y!liP*$[aM@)34K[A6YhYP[M4_BgZm{^s0N]eG9yPo0pQ-YgaPhlI=;L)LHR#-hX@aUDg,?MYyH*=1u/6SgYX(^.;O=qgqlY[$!j^,PGLo@_5]dHU$m5oWgFUqzgja?$}TXj.q=v2p,j0O0^25Q,=F+X4HNZt%+7;h!q8SCyQ!hb9ieqIA:yj{*G9AJ6TTSoXsm/Y{b8A#3p%0Sx;N.v/uJ5pYsb!Ui4I+!UcYHI-yZ.0toph)!jm(/d@rebD.mI^7Fm@hU@b}*t^gcI7KXfiLkhT:8F)7lQ}oCZK5t!AHL,6dKE+WDYJ3ciQssLG5QHIkRvUnd)_-KG[gY2^LD/=C8DJ-e!66Rq[QUSWF1q-LQvUJVe5aiER.rI1EAUa1W?KgS9?l+jtAI?bA6SfC,!^5Imtu*{XYpQ=pUp._T3SuABBv;0OKs}EIDV{?=FaRxKa2AVTF/=MH;c0$RNK@M]4tBgT#3p4Ce6vsF(L.Ru*?q4Ry5GjbyNh}f2zHU+u)7mRKOdwauFaTW+GlE=W,#m2Qo$Vx*7aH^JUHsnKRVYv%Ps.[153E{^;IsVN?6ZB!J#=cpwjHlWShBW+w8{$Ez7djl.5SGh-y2^Q@cj8a]vZP0k3(2Wet_S!k*?A3Zxs*4$RpwQnc54F+Em$;y7Z2zoPx/5ezhKvx[{.sVMvLPGH%9dp)DjdU{/k2U@[o@QV;Dmq.3_3k_3-9CH-j]*bPeh*!-qjr,b4Q*^;TmF)=b.jgw/,m)HG6VW?f{2q?kW3ODQiLU)Va-T!vCmfcf:X.6^!@K!?Uj8bmqB/nmTC2xJSqL$YKjcQ(G-CxgpLw}F2:Ve8_]xHgj5-[*m]4/2R8xo17o*1NjEC22YGWpMhe@g}$S,@*UdDtDXv@J0NMnxBO):3pe*VpgAcI)IaU{)ts*iR$7-pNw%A@8FO]TMem#f.w{vbR=CSlIBsOcR,?wg!YjWNUFojeRt/W^GWUZXboc^S/_^8p.2q#E#eaPBo?{^z!dYtB;(f8)iAt?:V_bT#(Pc]Yyfg=NM?H2suncbWi2z(mL*OTW@xT]sjj)%TR5.AF5UQE^A:VIAE*2O-zMaeztg.H;7UcPr.[BXO+aDs*K)4</formMonoSearch>
</FormData>
]==========]

local function saveForm(text)
  local path = os.tmpname() -- get temp file name
  local f, err = io.open(path, "w")
  if f == nil then return nil, err end
  f:write(text)
  f:close()
  return path
end

local function createFormFromString(text)
  local path = saveForm(text)
  local form = createFormFromFile(path)
  pcall(os.remove, path)
  return form
end


formMonoClassB = createFormFromString(stringFormMonoClass)
formMonoImage = createFormFromString(stringFormMonoImage)
formMonoSearch = createFormFromString(stringFormMonoSearch)


--[[--------------------------------------------------------------------------------
    -- Included File: src/lua/bootstrap.lua
    --------------------------------------------------------------------------------]]
-- loadstring(loadTextFile('src/lua/util.lua'))()
-- loadstring(loadTextFile('../temp/notes.lua'))()
-- loadstring(loadTextFile('src/lua/mono.lua'))()


--[[--------------------------------------------------------------------------------
    -- Included File: src/lua/util.lua
    --------------------------------------------------------------------------------]]
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


--[[--------------------------------------------------------------------------------
    -- Included File: src/lua/temp/notes.lua
    --------------------------------------------------------------------------------]]
--[[ 
    A note has 'key' and 'text' fields, lists are sorted by key.
--]]

notes = notes or {}
notesmt = notesmt or {}

note = note or {}
notemt = notemt or {}

notemt.__index = note
notemt.__lt =  function(a,b) return a.key < b.key end

function notes.new(filename, useTableFile)
  local obj = {}
  setmetatable(obj, {__index = notes})
  obj:load(filename, useTableFile)
  return obj
end

function notes:load(filename, useTableFile)
  self.filename = filename
  self.useTableFile = useTableFile
  local s = loadTextFile(self.filename, self.useTableFile)
  self.dict = {}
  if s then self.dict = loadstring(s)() end
  self.lastSave = os.clock()
  self.lastChange = 0
end

function notes:save()
  local text = util.serialize(self.dict)
  saveTextFile(self.filename, text, self.useTableFile)
  self.lastSave = os.clock()
end

function notes:saveAs(filename, useTableFile)
  self.filename = filename
  self.useTableFile = useTableFile
  self:save()
end


function notes:update(key, text)
  if text == nil or string.len(text) == 0 then
    if self.dict[key] then self.dict[key] = nil end
  else
    self.dict[key] = {key = key, text = text}
  end
  self.lastUpdate = os.clock()
end

function notes:getList()
  local keys = {}
  for k,n in pairs(self.dict) do table.insert(keys, n) end
  return keys
end


--[[--------------------------------------------------------------------------------
    -- Included File: src/lua/mono.lua
    --------------------------------------------------------------------------------]]

-- moduled
mono = mono or {}

-- classes
mono.MonoClass = mono.MonoClass or {}
mono.MonoField = mono.MonoField or {}
mono.MonoMethod = mono.MonoMethod or {}
mono.MonoImage = mono.MonoImage or {}

mono.menu = mono.menu or {}

mono.popups = mono.popups or {}

mono.formSelectImage = mono.formSelectImage or {}
mono.formSearch = mono.formSearch or {}
mono.formClass = mono.formClass or {}

-- defines
mono.TYPE_NAMES = {
  [0] = 'END',
  [1] = 'void',
  [2] = 'bool',
  [3] = 'char',
  [4] = 'sbyte',
  [5] = 'byte',
  [6] = 'short',
  [7] = 'ushort',
  [8]= 'int',
  [9]= 'uint',
  [10] = 'long',
  [11] = 'ulong',
  [12] = 'float',
  [13] = 'double',
  [14] = 'string',
  [15] = 'ptr',
  [16] = 'byref',
  [17] = 'valuetype',
  [18] = 'class',
  [19] = 'var',
  [20] = 'array',
  [21] = 'genericinst',
  [22] = 'typedbyref',
  [24] = 'I',
  [25] = 'U',
  [0x1b] = 'FNPTR',
  [0x1c] = 'object',
  [0x1d] = 'szarray', -- 0-based one-dim-array
  [0x1e] = 'mvar',
  [0x1f] = 'CMOD_REQD', -- typedef or typeref token
  [0x20] = 'CMOD_OPT',  -- optional arg: typedef or typeref token
  [0x21] = 'INTERNAL',
  [0x40] = 'MODIFIER', -- Or with the following types
  [0x41] = 'SENTINEL', -- sentinel for varargs method signature
  [0x45] = 'PINNED', -- local var that points to pinned object
  [0x55] = 'ENUM', -- an enumeration
}


--[[--------------------------------------------------------------------------------
    -- Included File: src/lua/mono/monofield.lua
    --------------------------------------------------------------------------------]]
local MonoField = mono.MonoField
MonoField.mt = {
  __index = MonoField,
  __tostring = function(t)
    return 'MonoField '..tostring(t.id)..' "'..tostring(t.name)..'"'
  end,
  __lt = function(a, b)
    return a.lowerName < b.lowerName
  end
}

-- class is a monoclass table, f is a table with results from
-- mono_class_enumFields
function MonoField.new(class, f)
  local obj = {
    class = class,
    id = f.field,
    name = f.name,
    isStatic = f.isStatic,
    isConst = f.isConst,
    offset = f.offset,
    monoType = f.monotype,
    lowerName = string.lower(f.name),
    foundTypeName = f.typeName,
    typeName = mono.TYPE_NAMES[f.monotype] or 'UnknownType'..tostring(f.monotype)
  }

  -- should be types where we might have a 'Class'
  --if f.monotype == 15 or f.monotype == 16 or f.monotype == 18 or f.monotype then
  --end

  obj.typeClassId = mono_type_getClass(obj.id)
  if obj.typeClassId ~= nil then
    -- this is the 'type' of the field
    obj.typeClass = class.image.classesById[obj.typeClassId]
    if obj.typeClass ~= nil then
      obj.typeName = obj.typeClass.name
    else
      if class.image.missingNames[obj.typeClassId] then
        obj.typeName = class.image.missingNames[obj.typeClassId]
      else
        obj.typeName = mono_class_getFullName(obj.typeClassId)
        class.image.missingNames[obj.typeClassId] = obj.typeName
      end
    end
  end

  setmetatable(obj, MonoField.mt)
  return obj
end

function MonoField:getFullName()
  local s = ""
  if self.class.namespace ~= nil and self.class.namespace:len() > 0 then s = self.class.namespace..':' end
  s = s..self.class.name..'.'
  s = s..self.name
  return s
end


--[[--------------------------------------------------------------------------------
    -- Included File: src/lua/mono/monomethod.lua
    --------------------------------------------------------------------------------]]
local MonoMethod = mono.MonoMethod
MonoMethod.mt = {
  __index = MonoMethod,
  __tostring = function(t)
    return 'MonoMethod '..tostring(t.id)..' "'..tostring(t.name)..'"'
  end,
  __lt = function(a, b)
    return a.lowerName < b.lowerName
  end
}

function MonoMethod.new(class, m)
  local obj = {
    class = class,
    id = m.method,
    name = m.name,
    lowerName = string.lower(m.name),
    parameters = {}
  }
  setmetatable(obj, MonoMethod.mt)

  lastmethod = obj
  local types, parameternames, returntype = mono_method_getSignature(obj.id)
  local typenames={}
  local tn
  if types ~= nil then
    for tn in string.gmatch(types, '([^,]+)') do
      table.insert(typenames, tn)
    end
  end
  
  for i=1,#typenames do
    table.insert(obj.parameters, { name = parameternames[i], type = typenames[i] })
  end
  obj.returnType = returntype

  return obj
end

--[[
    Get parameters for method
--]]
function MonoMethod:fetchParms()
  if self.parms ~= nil then return nil end
  if self.class.image.ignoredClassesByName[self.class.name] ~= nil then return nil end
  local status, parms = pcall(function()
         local result = mono_method_get_parameters(self.id)
         return result
       end)

  if status then
    -- success!
    self.parms = parms
  else
    self.class.image.ignoredClassesByName[self.class.name] = true
    print('Error with class '..tostring(self.class.name)..' method '..tostring(self.name))
    error('Error fetching parameters for '..tostring(self.class.name)..'.'..tostring(self.name))
  end
end


--[[--------------------------------------------------------------------------------
    -- Included File: src/lua/mono/monoclass.lua
    --------------------------------------------------------------------------------]]
local MonoClass = mono.MonoClass
MonoClass.mt = {
  __index = MonoClass,
  __tostring = function(t)
    return 'MonoClass '..tostring(t.id)..' "'..tostring(t.name)..'"'
  end,
  __lt = function(a, b)
    return a.lowerName < b.lowerName
  end
  
}

local MonoField = mono.MonoField
local MonoMethod = mono.MonoMethod

--[[
    Called from MonoImage:_init, 'c' is what is returned from enumerating classes.
--]]
function MonoClass.new(image, c)
  local obj = {
    name = c.classname,
    namespace = c.namespace,
    id = c.class,
    lowerName = string.lower(c.classname),
    image = image
  }

  setmetatable(obj, MonoClass.mt)
  return obj
end

function MonoClass:initFields()
  self.fields = {}
  self.fieldsByName = {}
  self.fieldsByLowerName = {}
  local constFieldCount = 0
  
  local temp = mono_class_enumFields(self.id)
  for i,f in ipairs(temp) do
    local field = MonoField.new(self, f)
    table.insert(self.fields, field)
    self.fieldsByLowerName[field.lowerName] = field;
    self.fieldsByName[field.name] = field

    if field.isStatic and field.isConst then
      field.constValue = constFieldCount
      constFieldCount = constFieldCount + 1
    end
  end

  table.sort(self.fields)
end

function MonoClass:initMethods()
  self.methods = {}
  self.methodsByName = {}
  self.methodsByLowerName = {}
  
  local temp = mono_class_enumMethods(self.id)
  for i,m in ipairs(temp) do
    local method = MonoMethod.new(self, m)
    table.insert(self.methods, method)
    self.methodsByName[method.name] = method
    self.methodsByLowerName[method.lowerName] = method
  end

  table.sort(self.methods)
end


--[[--------------------------------------------------------------------------------
    -- Included File: src/lua/mono/monoimage.lua
    --------------------------------------------------------------------------------]]
local MonoImage = mono.MonoImage
MonoImage.mt = {
  __index = MonoImage,
  __tostring = function(t)
    return 'MonoImage '..tostring(t.name)
  end
}

local MonoClass = mono.MonoClass

--[[
    List names of images, a name can be passed to MonoImage.new()
    or MonoImage(name) to create a MonoImage instance.
--]]
function MonoImage.enumerate()
  local names = {}
  mono_enumImages(function(img)
    local name = mono_image_get_name(img)
    table.insert(names, name)
  end)
  table.sort(names)
  return names
end

--[[
    Constructor doesn't do much, call :init(name, progress)
--]]
function MonoImage.new()
  local obj = { }
  setmetatable(obj, MonoImage.mt)
  return obj
end

--[[
    init() takes the image name and an optional callback for reporting progress
    and when it is complete.  The signature for this function is:
        function progress(complete, image, message, processed, total)
    This callback should be executed on the main CE thread.
--]]
function MonoImage:init(name, progress)
  if monopipe == nil then
    print('Launching mono data collector...')
    LaunchMonoDataCollector()
  end
  
  self.domains = mono_enumDomains()
  self.domain = self.domains[1]

  self.classes = {}                -- straight list of all classes
  self.classesByName = {}          -- dictionary for access by name
  self.classesByLowerName = {}     -- for access by lower case name
  self.classesById = {}            -- for access by id
  self.ignoredClassesByName = {}   -- for ignoring classes in searches, etc.
  self.progress = progress
  self.name = name or 'Assembly-CSharp' -- intelligent default for unity
  
  -- get id
  self.id = nil
  mono_enumImages(function(img)
    local foundName = mono_image_get_name(img)
    if foundName == self.name then self.id = img end
  end)
  
  if not self.id then
    print('NO ID!')
    print('name is', name, self.name)
    self:report(false, 'Error finding image named '..tostring(name))
    self.progress = nil
    self.total = nil
    self.count = nil
    return false
  end
  
  createThread(function(thread)
      self.thread = thread
      self:_init(thread)
    end)
end

--[[
    This is the function called by init() on another thread
--]]
function MonoImage:_init(thread)
  --print('MonoImage:_init thread is', thread, 'self is', tostring(self))
  self.thread = thread
  local temp = mono_image_enumClasses(self.id)
--  thread.synchronize(function(th)
--      print('Image '..tostring(self.id)..' has classes: '..tostring(temp))
--    end)
    
  self.classes = {}
  self.classesByName = {}
  self.classesByLowerName = {}
  self.classesById = {}
  self.missingNames = {}
  
  self.total = #temp
  self.count = 0
  self.message = "Getting classes"
  self:report(false, "Getting classes")
  
  -- populate classes without much information first so we can
  -- access our definitions when filling in parents, properties, etc.
  for i,c in ipairs(temp) do
    local class = MonoClass.new(self, c)
    if class.lowerName ~= nil then
      table.insert(self.classes, class)
      self.classesByName[class.name] = class
      self.classesByLowerName[class.lowerName] = class
      self.classesById[class.id] = class
    else
      --print("Nil lowername for class", c.class)
    end
    self.count = i
    if (i % 100 == 0 or i == #temp) then
      self:report(false, 'Fetching classes')
    end
  end
  table.sort(self.classes)
  
  for i,class in ipairs(self.classes) do
    class.parentId = mono_class_getParent(class.id)
    class.parent = self.classesById[class.parentId]
    self.count = i
    if (i % 100 == 0 or i == #temp) then
      self:report(false, 'Fetching parents')
    end
  end
  
  self.count = 0
  for i,class in ipairs(self.classes) do
    class:initFields()
    class:initMethods()
    self.count = i
    if (i % 100 == 0 or i == #temp) then
      self:report(false, 'Initializing fields and methods')
    end
  end
  
  self:report(true, 'Done')
end

--[[
    Report progress on the main CE thread to do gui updates
--]]
function MonoImage:report(done, message)
  if self.progress ~= nil and self.thread ~= nil then
    self.thread.synchronize(function(thread)
        self.progress(done, self, message, self.count, self.total)
      end)
  end
  
  if done then
    -- do cleanup here
    self.count = nil
    self.total = nil
    self.progress = nil
    self.thread = nil
  end
end


--[[  Sample code... weird

--return util.pretty(mono.MonoImage.enumerate())
mi = mono.MonoImage.new()
print('mi is "'..tostring(mi)..'"')
mi:init('Assembly-CSharp', function(c, i, m, p, t)
  print(m, p, t)
end)

--LaunchMonoDataCollector()
local thread = createThread(function(th)
  TESTIMAGES = {}
  mono_enumImages(function(img)
    th.synchronize(function() print(img) end)
  end)
end)

--]]



--[[--------------------------------------------------------------------------------
    -- Included File: src/lua/monomenu.lua
    --------------------------------------------------------------------------------]]
function mono.menu:init()
  --if self.menuSearch or self.timer then return end
  self.timer = createTimer()
  self.timer.Interval = 1000
  self.timer.OnTimer = function(timer)
    -- wait for normal mono script to create mono menu, check every 5 seconds
    if not miMonoTopMenuItem then return end
    
    self.timer.destroy()
    self.timer = nil

    self.menuSearch = createMenuItem(miMonoTopMenuItem)
    self.menuSearch.Caption = 'Search'
    self.menuSearch.Name = 'miMonoSearch'
    self.menuSearch.OnClick = function(sender) self:OnSearchClick() end
    miMonoTopMenuItem.add(self.menuSearch)
  end
end

function mono.menu:OnSearchClick()
  if mono.selectedImage then
    mono.formSearch:show()
    formMonoSearch:centerScreen()
  else
    mono.formSelectImage:show()
  end
end

mono.menu:init()



--[[--------------------------------------------------------------------------------
    -- Included File: src/lua/forms/formSelectImage.lua
    --------------------------------------------------------------------------------]]
local DEFAULT_ASSEMBLY_NAME = "Assembly-CSharp"
local imageHasBeenSelected = false

function mono.formSelectImage:show()
  LaunchMonoDataCollector()
  formMonoImage.listImages.Visible = true
  formMonoImage.buttonSelectImage.Visible = true
  formMonoImage.progressImage.Visible = false
  formMonoImage.labelMessage.Visible = false
  
  self.imageNames = mono.MonoImage.enumerate()
  table.sort(self.imageNames)
  local items = formMonoImage.listImages.Items
  items.Clear()

  local foundIndex = 0
  for i,name in ipairs(self.imageNames) do
    items.add(name)
    if name == DEFAULT_ASSEMBLY_NAME then foundIndex = i end
  end
  
  local handler = function(sender)
    mono.formSelectImage.OnSelectImage(self)
  end
  
  formMonoImage.buttonSelectImage.OnClick = handler
  formMonoImage.listImages.OnDblClick = handler
  
  formMonoImage.show()

  if foundIndex ~= 0 and imageHasBeenSelected == false then
    formMonoImage.listImages.ItemIndex = foundIndex - 1
    mono.formSelectImage:OnSelectImage()
  end
end

function mono.formSelectImage:OnSelectImage()
  imageHasBeenSelected = true
  local index = formMonoImage.listImages.ItemIndex + 1
  if self.imageNames == nil or index < 1 or index > #self.imageNames then return end
  local imageName = self.imageNames[index]
 
  formMonoImage.listImages.Visible = false
  formMonoImage.buttonSelectImage.Visible = false
  formMonoImage.progressImage.Visible = true
  formMonoImage.labelMessage.Visible = true
  formMonoImage.labelMessage.Caption = 'Finding classes...'
  
  local image = mono.MonoImage.new()
  
  formMonoImage.progressImage.Min = 0
  local progressHandler = function(done, image, message, count, total)
    if total ~= nil and total > 0 and count ~= nil and count >= 0 then
      message = string.format('%s  %d/%d', message, count, total)
      formMonoImage.progressImage.Max = total
      formMonoImage.progressImage.Position = count
    end
    
    formMonoImage.labelMessage.Caption = message
    if done then self:OnImageComplete(image) end
  end
  
  image:init(imageName, progressHandler)
end

function mono.formSelectImage:OnImageComplete(image)
  self.image = image
  mono.selectedImage = image
  formMonoImage.Close()
  mono.formSearch:show()
  formMonoSearch:centerScreen()
end


--[[--------------------------------------------------------------------------------
    -- Included File: src/lua/forms/formSearch.lua
    --------------------------------------------------------------------------------]]
--[[
    Form for searching an image.
    
    Controls:
      pageMain.tabSearch - main tab
      editSearchText: TCEEdit
      listSearchClasses: TCEListView
      listSearchFields: TCEListView
      listSearchMethods: TCEListView
      miImage: TMenuItem - main menu Image entry
      miImageSelectImage - entry to re-open select image form
--]]

mono.formSearch.found = mono.formSearch.found or {}
mono.formSearch.found.classes = mono.formSearch.found.classes or {}
mono.formSearch.found.fields = mono.formSearch.found.fields or {}
mono.formSearch.found.methods = mono.formSearch.found.methods or {}

--[[
    Show the search form, mono.selectedImage should be set to the
    image to search.
--]]
function mono.formSearch:show()
  if mono.selectedImage == nil then return end
  self.image = mono.selectedImage
  
  -- setup event handlers
  formMonoSearch.miImageSelectImage.OnClick = function(sender) self:SelectImageClick() end
  
  formMonoSearch.listSearchClasses.OnData = function(sender, listitem)
    self:listSearchClasses_OnData(sender, listitem)
  end
  
  formMonoSearch.listSearchClasses.OnDblClick = function(sender)
    local class = self.found.classes[sender.ItemIndex + 1]
    mono.formClass:show(class, nil, nil)
  end
  
  formMonoSearch.listSearchFields.OnData = function(sender, listitem)
    self:listSearchFields_OnData(sender, listitem)
  end
  
  formMonoSearch.listSearchFields.OnDblClick = function(sender)
    local field = self.found.fields[sender.ItemIndex + 1]
    if field then
      mono.formClass:show(field.class, field, nil)
    end
  end
  
  formMonoSearch.listSearchMethods.OnData = function(sender, listitem)
    self:listSearchMethods_OnData(sender, listitem)
  end
  
  formMonoSearch.listSearchMethods.OnDblClick = function(sender)
    local method = self.found.methods[sender.ItemIndex + 1]
    if method then
      mono.formClass:show(method.class, nil, method)
    end
  end
  
  formMonoSearch.editSearchText.OnChange = function(sender)
    self:search(sender.text)
  end
  
  -- popups
  formMonoSearch.listSearchClasses.PopupMenu = formMonoSearch.popupClasses
  local count = 0
  formMonoSearch.popupClasses.OnPopup = function(sender)
    print('formMonoSearch.popupClasses.OnPopup "'..tostring(sender.name)..'" count '..tostring(count))
    count = count + 1
  end
  
  -- perform initial search to set 'found' results, probably empty text
  self:search(formMonoSearch.editSearchText.Text)
  

  -- show form
  formMonoSearch.show()
end

--[[
    When menu item to select an image is clicked, hide this form and
    show the image select form
--]]
function mono.formSearch:SelectImageClick()
  formMonoSearch.close()
  mono.formSelectImage:show()
end

--[[
    When typing in the edit box to filter results, filter the lists of
    classes, fields, and methods with the lower case of the text
--]]
function mono.formSearch:search(text)
  local lower = nil
  if text ~= nil then lower = text:lower() end

  local classes = {}
  local methods = {}
  local fields = {}
  for i,class in ipairs(self.image.classes) do
    if lower == nil or class.lowerName:find(lower, 1, true) ~= nil then table.insert(classes, class) end
    for j,method in ipairs(class.methods) do
      if lower == nil or method.lowerName:find(lower, 1, true) ~= nil then table.insert(methods, method) end
    end
    for j,field in ipairs(class.fields) do
      if lower == nil or field.lowerName:find(lower, 1, true) ~= nil then table.insert(fields, field) end
    end
  end
  self.found.classes = classes
  self.found.fields = fields
  self.found.methods = methods
  formMonoSearch.listSearchClasses.Items.Count = #classes
  formMonoSearch.listSearchFields.Items.Count = #fields
  formMonoSearch.listSearchMethods.Items.Count = #methods
end

-- handler to display classes in list view
function mono.formSearch:listSearchClasses_OnData(sender, listitem)
  local index = listitem.Index + 1
  local class = self.found.classes[index]
  listitem.Caption = class.name
end

-- handler to display fields in list view
function mono.formSearch:listSearchFields_OnData(sender, listitem)
  local field = self.found.fields[listitem.Index + 1]
  if field == nil then
    listitem.Caption = 'nil index '..tostring(index)
  else
    listitem.Caption = field.name
    listitem.SubItems.text = field.class.name
  end
end

-- handler to display methods in list view
function mono.formSearch:listSearchMethods_OnData(sender, listitem)
  local method = self.found.methods[listitem.Index + 1]
  if method == nil then
    listitem.Caption = 'nil index '..tostring(index)
  else
    listitem.Caption = method.name
    listitem.SubItems.text = method.class.name
  end
end


--[[--------------------------------------------------------------------------------
    -- Included File: src/lua/forms/formClass.lua
    --------------------------------------------------------------------------------]]
--[[
    Form for viewing a class
    
    Controls:
      listFields: TCEListView
      listMethods: TCEListView
      miSortFieldsByOffset - if Checked, sort by offset, otherwise by name
      miShowInherited - if Checked, add in methods and fields of parent(s)
      miShowUsage - if Checked, funcs and methods will be on other classes that use the type
      
      miFindFields - When clicked, find fields in all classes that have this class as a type
      miFindMethodCode - When clicked, find methods in all classes that have this class as a type
      
      
    Standard Mode:
      listFields (can sort by name (default) or offset)
        Offset
        Type
        Name
        Class - class it is defined on, blank if not inherited
      listMethods (sorted by name)
        Name
        Signature (return type, parameter types and names)
        Class - class it is defined on, blank if not inherited
      
    Usage Mode:
      listFields (sorted by Class then Name)
        Offset
        Type
        Class
--]]

local sortByClassThenName = function(a, b)
  if a.isConst and not b.isConst then return true end
  if b.isConst and not a.isConst then return false end
  if a.isConst and b.isConst then return a.constValue < b.constValue end
  if a.class.lowerName < b.class.lowerName then return true end
  if b.class.lowerName < a.class.lowerName then return false end
  return a.name < b.name
end

local sortByClassThenOffset = function(a, b)
  if a.isConst and not b.isConst then return true end
  if b.isConst and not a.isConst then return false end
  if a.isConst and b.isConst then return a.constValue < b.constValue end
  if a.class.lowerName < b.class.lowerName then return true end
  if b.class.lowerName < a.class.lowerName then return false end
  return a.offset < b.offset
end

local sortByName = function(a, b)
  if a.isConst and not b.isConst then return true end
  if b.isConst and not a.isConst then return false end
  if a.isConst and b.isConst then return a.constValue < b.constValue end
  return a.lowerName < b.lowerName
end

local sortByOffset = function(a, b)
  if a.isConst and not b.isConst then return true end
  if b.isConst and not a.isConst then return false end
  if a.isConst and b.isConst then return a.constValue < b.constValue end
  return a.offset < b.offset
end


--[[
    Show the search form, mono.selectedImage should be set to the
    image to search.
--]]
function mono.formClass:show(class, field, method)
  if mono.selectedImage == nil or class == nil then return end
  self.image = mono.selectedImage
  self.class = class
  
  -- function to update lists, for setting on menu items that
  -- make other changes
  local funcUpdate = function(sender) self:setFieldsAndMethods() end
  
  formMonoClass.listFields.OnData = function(sender, listitem)
    self:listFields_OnData(sender, listitem)
  end
  
  formMonoClass.listFields.OnDblClick = function(sender)
    self:listFields_OnDblClick(sender)
  end

  formMonoClass.listMethods.OnData = function(sender, listitem)
    self:listMethods_OnData(sender, listitem)
  end

  formMonoClass.listMethods.OnDblClick = function(sender)
    self:listMethods_OnDblClick(sender)
  end

  formMonoClass.miSortFieldsByOffset.OnClick = funcUpdate
  formMonoClass.miShowInherited.OnClick = funcUpdate
  formMonoClass.miShowUsage.OnClick = funcUpdate
  
  -- create our own lists of fields and methods that we can sort
  -- and filter
  self:setFieldsAndMethods()
  
  -- show form
  formMonoClass.show()
end

--[[
    Set fields and methods arrays, sorted appropriately and
    with extra fields, including possibly parent fields and methods
--]]
function mono.formClass:setFieldsAndMethods()
  local other = ''
  if formMonoClass.miShowUsage.Checked then other = ' (usage by other classes)' end

  formMonoClass.labelClassName.Caption = string.format('Mono Class: %s:%s%s', self.class.namespace, self.class.name, other)
  local fields = {}
  local methods = {}
  if formMonoClass.miShowUsage.Checked then
    ---------- show where class is used in other classes
    for i,class in ipairs(self.image.classes) do
      for j,method in ipairs(class.methods) do
        local found = false
        if method.returnType == self.class.name then
          found = true
        else
          for k,p in ipairs(method.parameters) do
            if p.typeName == self.class.name then found = true end
          end
        end
        if found then table.insert(methods, method) end
      end
      
      for j,field in ipairs(class.fields) do
        if field.typeName == self.class.name then table.insert(fields, field) end
      end
    end
  else
    ---------- basic class fields and methods
    local c = self.class
    
    while c ~= nil do
      for i,field in ipairs(c.fields) do
        table.insert(fields, field)
      end
      
      for i,method in ipairs(c.methods) do
        table.insert(methods, method)
      end
      
      if formMonoClass.miShowInherited.Checked then
        c = c.parent
      else
        c = nil
      end
    end
  end


  if formMonoClass.miSortByClassFirst.Checked then
    table.sort(fields, formMonoClass.miSortFieldsByOffset.Checked and sortByClassThenOffset or sortByClassThenName)
    table.sort(methods, sortByClassThenName)
  else
    table.sort(fields, formMonoClass.miSortFieldsByOffset.Checked and sortByOffset or sortByName)
    table.sort(methods, sortByName)
  end

  self.fields = fields
  self.methods = methods
  formMonoClass.listFields.Items.Count = 0
  formMonoClass.listFields.Items.Count = #fields
  formMonoClass.listMethods.Items.Count = 0
  formMonoClass.listMethods.Items.Count = #methods
end

-- handler to display fields in list view
function mono.formClass:listFields_OnData(sender, listitem)
  -- columns are offset (or 'STATIC'), Type, Name
  local index = listitem.Index + 1
  local field = self.fields[index]
  
  -- columns are Offset, Type, Name
  if field.isStatic then
    if field.isConst then
      listitem.Caption = 'Const:'..string.format('%2X', field.constValue or 0)
    else
      listitem.Caption = 'Static:'..string.format('%2X', field.offset or 0)
    end
  else
    listitem.Caption = string.format('%02X', field.offset or 0)
  end
  local className = ''
  if field.class.name ~= self.class.name then className = field.class.name end
  listitem.SubItems.text = table.concat({field.typeName or '??', field.name, className}, '\n')
end

-- handler to display methods in list view
function mono.formClass:listMethods_OnData(sender, listitem)
  local method = self.methods[listitem.Index + 1]
  if method == nil then
    listitem.Caption = 'nil index '..tostring(listitem.Index + 1)
  else
    listitem.Caption = method.name
    
    local className = ''
    if method.class.name ~= self.class.name then className = method.class.name end
    
    local ps = {}
    for i,p in ipairs(method.parameters) do
      table.insert(ps, string.format('%s %s', p.type, p.name))
    end
    local parms = method.returnType..' ('..table.concat(ps, ', ')..')'
   
    --print('className, method.class.name', className, method.class.name)
    listitem.SubItems.text = table.concat({ parms, className }, '\n')
  end
end

local parameters = { 'RCX', 'RDX', 'R8', 'R9', '[RBP+30]', '[RBP+38]', '[RBP+40]', '[RBP+48]', '[RBP+50]' }
local floatParameters = { 'XMM0', 'XMM1', 'XMM2', 'XMM3', 'XMM4', 'XMM5', 'XMM6'}

function mono.formClass:popupMethod_OnPopup(sender)
  
end

function mono.formClass:listMethods_OnDblClick(sender)
  local method = self.methods[sender.ItemIndex + 1]
  --print("method: "..tostring(method.id))
  if method then
    local address = mono_compile_method(method.id)
    --print("address: "..tostring(address))
    getMemoryViewForm().DisassemblerView.SelectedAddress = address
    getMemoryViewForm().show()
    local hookInfo = hookAt(address)
    -- have aobString, hookString, returnString, instructions
    --[[ how to get method signature
    local ps = {}
    for i,p in ipairs(method.parameters) do
      table.insert(ps, string.format('%s %s', p.type, p.name))
    end
    local parms = method.returnType..' ('..table.concat(ps, ', ')..')'
    ]]

    local lines = {}
    table.insert(lines, "define(hook,"..hookInfo.hookString..")")
    table.insert(lines, "define(bytes,"..hookInfo.aobString..")")
    table.insert(lines, "")
    table.insert(lines, "[enable]")
    table.insert(lines, "")
    table.insert(lines, "assert(hook, bytes)")
    table.insert(lines, "alloc(newmem,$1000, hook)")
    table.insert(lines, "{")


    -- note: per x64 calling convention, RCX might actually be space for
    -- a pre-allocated structure for the return value and other parameters
    -- might be moved one further down the list
    table.insert(lines, "  RCX: "..method.class.name.." (this)")
    for i,p in ipairs(method.parameters) do
      local param = parameters[i + 1]
      if (p.type == "System.Single" or p.type == "System.Double") then param = floatParameters[i + 1] end
      table.insert(lines, "  "..param..": "..tostring(p.type).." "..tostring(p.name))
    end
    table.insert(lines, "")

    table.insert(lines, "  Returns (RAX) "..method.returnType)
    table.insert(lines, "}")
    table.insert(lines, "")
    table.insert(lines, "newmem:")
    table.insert(lines, "  // original code")
    for i,c in ipairs(hookInfo.instructions) do
      table.insert(lines, "  "..c)
    end
    table.insert(lines, "  jmp hook+"..string.format("%X", hookInfo.returnOffset))
    table.insert(lines, "")
    table.insert(lines, "hook:")
    table.insert(lines, "  jmp newmem")
    table.insert(lines, "")
    table.insert(lines, "[disable]")
    table.insert(lines, "")
    table.insert(lines, "hook:")
    table.insert(lines, "  db bytes")
    table.insert(lines, "")
    table.insert(lines, "dealloc(newmem)")

    local t = {}
    for i,v in ipairs(lines) do
      table.insert(t, v);
      table.insert(t, "\r\n")
    end
  
    local aa = table.concat(t)

    getMemoryViewForm().AutoInject1.DoClick()
    
    for i=0,getFormCount()-1 do --this is sorted from z-level. 0 is top
      local f=getForm(i)
  
      if getForm(i).ClassName == 'TfrmAutoInject' then
        f.assemblescreen.Lines.Text = aa
        break
      end
    end
  end
end

--[[
      When double-clicking a field, print out the base address for the statics of the
      class and the address of the clicked-on static field.
--]]
function mono.formClass:listFields_OnDblClick(sender)
  local field = self.fields[sender.ItemIndex + 1]
  if field then
    local class = field.class
    local image = class.image
    local domainId = image.domain
    print('double-clicked on class '..tostring(field.class.name)..' field '..tostring(field.name)..' domain '..tostring(domainId))
    local address = mono_class_getStaticFieldAddress(domainId, class.id)
    print('statics base address: '..string.format("%x", address))
    print(class.name..'.'..field.name..': '..string.format("%x", address + field.offset))
  end
end

--[[
      IN PROGRESS - take an address and create an AA script to hook at that address
      expecting MONO code.  Will process instructions until 5 bytes (for jmp) are
      processed.  Basic format is like this for address 'CryingSuns.PlayerStatus:BattleshipState:HasAuxiliarySystemType+28'

[enable]
assert("CryingSuns.PlayerStatus:BattleshipState:HasAuxiliarySystemType":+28, )
]]
function hookAt(address)
  local pos = string.find(address, "+", 1, true)
  local name = address
  local offset = 0
  if (pos ~= nil) then
    name = string.substring(1, pos - 1)
    offset = tonumber(string.sub(pos + 1), 16)
  end
  local actualAddress = getAddress(name) + offset

  local data = {
    hookString = util.safeAddress(getNameFromAddress(actualAddress)), -- used for injection, etc
    instructions = {},
    aobString = ""
  }

  local aobs = {}

  while (offset < 5) do
    local parsed = disassembleAndParse(actualAddress + offset)
    if #aobs > 0 then table.insert(aobs, " ") end
    table.insert(aobs, parsed.bytesString)
    table.insert(data.instructions, parsed.instructionString)
    offset = offset + parsed.length
  end

  data.aobString = table.concat(aobs)
  data.returnString = util.safeAddress(getNameFromAddress(actualAddress + offset))
  data.returnOffset = offset
  return data
end

function hookMethod(method)

end

--[[
      Expects address to be a number
]]
function disassembleAndParse(address)
  local disassembly = disassemble(address)
  local parts = util.split(disassembly, "-")
  for i = 1,#parts do
    if i == 2 then
      parts[i] = parts[i]:gsub("%s+", "") -- remove ALL whitespace from bytes
    else
      parts[i] = parts[i]:gsub("^%s*(.-)%s*$", "%1") -- remove whitespace from ends
    end
  end

  local aob = {}
  local i = 1
  while i < string.len(parts[2]) do
    if (i ~= 1) then table.insert(aob, " ") end
    table.insert(aob, string.sub(parts[2], i, i+1))
    i = i + 2
  end

  local instructionString = parts[3]
  for k,v in parts[3]:gmatch("[0-9a-fA-F]+") do
    if k:len() == 8 or k:len() == 16 then
      instructionString = instructionString:gsub(k, getNameFromAddress(k))
    end
  end
  

  local result = {
    address = getAddress(address),
    addressString = util.safeAddress(getNameFromAddress(address)),
    aob = aob,
    bytesString = table.concat(aob),
    disassembly = disassembly,
    instructionString = instructionString,
    length = getInstructionSize(address),
    originalInstructionString = parts[3]
  }

  return result
end

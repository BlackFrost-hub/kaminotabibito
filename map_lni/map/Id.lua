--转换256进制整数
local tb = {}

local CJ = require 'jass.common'

local g = require 'jass.globals'

local _ids1 = {}
local _ids2 = {}

function tb._id(a)
	local r = ('>I4'):pack(a)
	_ids1[a] = r
	_ids2[r] = a
	return r
end

function tb.__id2(a)
	local r = ('>I4'):unpack(a)
	_ids2[a] = r
	_ids1[r] = a
	return r
end

function tb.id2string()
	local a = CJ.LoadInteger(g.StarBaseHT,1000,0)
	CJ.FlushChildHashtable(g.StarBaseHT,1000)
	local s = tostring(_ids1[a] or tb._id(a))
	CJ.SaveStr(g.StarBaseHT,1000,1,s)
end

function tb.string2id()
	local a = CJ.LoadStr(g.StarBaseHT,1000,0)
	local i = tonumber(_ids2[a] or tb.__id2(a))
	CJ.SaveInteger(g.StarBaseHT,1000,1,i)
end

return tb
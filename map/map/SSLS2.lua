
local SSLS2 = {}

local CJ = require 'jass.common'

local g = require 'jass.globals'

-- 截取utf8 字符串
-- str:            要截取的字符串
-- startChar:    开始字符下标,从1开始
-- numChars:    要截取的字符长度
-- function utf8sub(str, startChar, numChars)
--     local startIndex = 1
--     while startChar > 1 do
--         local char = string.byte(str, startIndex)
--         startIndex = startIndex + chsize(char)
--         startChar = startChar - 1
--     end

--     local currentIndex = startIndex

--     while numChars > 0 and currentIndex <= #str do
--         local char = string.byte(str, currentIndex)
--         currentIndex = currentIndex + chsize(char)
--         numChars = numChars -1
--     end
--     return str:sub(startIndex, currentIndex - 1)
-- end

-- //用于传输布尔值
-- boolean SSLS2BLS[];
-- //用于传输数字
-- integer SSLS2Int;
-- //用于传输字符串
-- string SSLS2Str;
--3字节字符串转整数
function SSLS2.s32i()
    local s = g.SSLS2Str
	local i = (string.byte(s,1)-33)*92*92+(string.byte(s,2)-33)*92+(string.byte(s,3)-33)
    g.SSLS2Int = i
	return i
end
--整数转3字节字符串
function SSLS2.i23s()
    i = g.SSLS2Int
	if i>778688 then
		i = 778688
	end
	local b = {}
	for c=0,2,1 do
		b[c] = math.floor(i%92)
		i = math.floor(i/92)
	end
	local s = string.char(33+b[2])..string.char(33+b[1])..string.char(33+b[0])
	g.SSLS2Str = s
	return s
end
--整数转二进制字符串
function SSLS2.i2bs()
    local s = ""
    local x = g.SSLS2Int
    for y = 0,31,1 do
        s = (x & 1) .. s
        x = x >> 1
    end
    g.SSLS2Str = s
    return s
end

local lll = 5-- 位数
function SSLS2.i2ns(i)
	local b = {}
	if (i<0) then
        i = 4294967296 + i
    end
	for c=0,lll-1,1 do
		b[c] = math.floor(i%92)
		i = math.floor(i/92)
	end
	local s  = ""
	for d = lll-1,0,-1 do
		s= s..string.char(33+b[d])
	end
	return s
end
function SSLS2.sn2i(s)
	local i = 0
	for a = lll,1,-1 do
		local c =(string.byte(s,a)-33)
		for b = 1,lll-a,1 do
			c = c * 92
		end
		i = i + c
	end
	return i
end
--传入整数变量 返回字符串
function SSLS2.SaveInt()
    s = SSLS2.i2ns(g.SSLS2Int)
    return s
end
--传入字符串 返回整数
function SSLS2.LoadInt()
    g.SSLS2Int = SSLS2.sn2i(g.SSLS2Str)
end
--一位一存0-4  两位一存0-12  三位一存 0-18 五位0-31
--为每个玩家保存2个栏位也就是15*24个int 作为布尔值
--为每个玩家保存至多64个存档栏 这个由常量控制
--布尔值数组转整数
function SSLS2.b2i()
    local str =""
    for i = 0 , 31,1 do
        if(g.SSLS2BLS[i])then
            str = str .."1"
        else
            str = str .."0"
        end
    end
    g.SSLS2Int = tonumber(str, 2)
    return g.SSLS2Int
end
--整数转布尔值数组
function SSLS2.i2b()
    local x = g.SSLS2Int
    for y = 0,31,1 do
        g.SSLS2BLS[31-y] = (((x >> y) & 1) == 1)
    end
end
return SSLS2;
-- Debug 的代码
-- local lll = 5-- 位数
-- function sn2i(s)
-- 	local i = 0
-- 	for a = lll,1,-1 do
-- 		local c =(string.byte(s,a)-33)
-- 		for b = 1,lll-a,1 do
-- 			c = c * 92
-- 		end
-- 		i = i + c
-- 	end
-- 	return i
-- end
-- function i2ns(i)
-- 	local b = {}
-- 	if (i<0) then
--         i = 4294967296 + i
--     end
-- 	for c=0,lll-1,1 do
-- 		b[c] = math.floor(i%92)
-- 		i = math.floor(i/92)
-- 	end
-- 	local s  = ""
-- 	for d = lll-1,0,-1 do
-- 		s= s..string.char(33+b[d])
-- 	end
-- 	return s
-- end
-- function i2bs(x)
-- 	local s=""
--     for y = 0,31,1 do
--         s = (x & 1) .. s
--         x = x >> 1
--     end
--     return s
-- end
-- function b2i(x)
-- 	return tonumber(x,2)
-- end
-- local e = i2bs(-1048576)
-- print("e:"..e)
-- local a = b2i(e)
-- print("a:"..a)
-- local b = i2ns(a)
-- print("b:"..b)
-- local c = sn2i(b)
-- print("c:"..c)
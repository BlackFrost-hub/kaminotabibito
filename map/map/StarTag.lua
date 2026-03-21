local a = {}

local CJ = require 'jass.common'
local g = require 'jass.globals'
local japi = require 'jass.japi'

-- 计算 UTF8 字符串的长度，每一个中文算一个字符
function a.utf8len(input)
    local len  = string.len(input)
    local left = len
    local cnt  = 0
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    while left ~= 0 do
        local tmp = string.byte(input, -left)
        local i   = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
    end
    return cnt
end

function a.display()
    local value = CJ.LoadInteger(g.StarBaseHT,998,0)--显示的值
    local x = CJ.LoadReal(g.StarBaseHT,998,1)--显示位置X
    local y = CJ.LoadReal(g.StarBaseHT,998,2)--显示位置Y
    local z = CJ.LoadReal(g.StarBaseHT,998,3)--显示位置Z
    local color = CJ.LoadInteger(g.StarBaseHT,998,4)--显示的颜色
    local s = string.format("%d",value)
    local len = string.len(s)
    for i = 1, len do
        local v = string.sub(s,i,i)
        local e = CJ.AddSpecialEffect(g.ST_Path[10*color + v], x, y)
        x = x + 40
        japi.EXSetEffectZ(e,z);
        CJ.DestroyEffect(e);
    end

    --return s
end

return a

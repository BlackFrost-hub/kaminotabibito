local a = {}

local CJ = require 'jass.common'
local g = require 'jass.globals'
local japi = require 'jass.japi'

function a.display()
    
    local x = CJ.LoadReal(g.StarBaseHT,998,1)--显示位置X
    local y = CJ.LoadReal(g.StarBaseHT,998,2)--显示位置Y
    local z = CJ.LoadReal(g.StarBaseHT,998,3)--显示位置Z
    japi.DzConvertWorldPosition(x,y,z,function()
        print(japi.DzGetConvertWorldPositionX())
        print(japi.DzGetConvertWorldPositionY())
    end)
end

return a

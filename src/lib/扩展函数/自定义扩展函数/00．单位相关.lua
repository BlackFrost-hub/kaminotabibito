--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 单位相关扩展函数
local jass = require("jass.common")
--- 创建单位并设置尺寸和角度
-- 
-- @param playerId 玩家ID (0-15)
-- @param unitId 单位ID (FourCC字符串如 "hfoo")
-- @param x X坐标
-- @param y Y坐标
-- @param facing 面向角度（弧度），不传则使用单位默认面向
-- @param scale X轴缩放，不传则使用1.0
-- @param scaleY Y轴缩放，不传则使用1.0
-- @param scaleZ Z轴缩放，不传则使用1.0
-- @returns 创建的单位，失败返回null
function ____exports.createUnitWithOptions(self, playerId, unitId, x, y, facing, scale, scaleY, scaleZ)
    if type(jass.CreateUnit) ~= "function" then
        return nil
    end
    local unit = jass.CreateUnit(
        jass.Player(playerId),
        unitId,
        x,
        y,
        0
    )
    if not unit then
        return nil
    end
    if facing ~= nil and type(jass.SetUnitFacing) == "function" then
        jass.SetUnitFacing(unit, facing * 180 / math.pi)
    end
    local scaleX = scale or 1
    local scaleY2 = scaleY or 1
    local scaleZ2 = scaleZ or 1
    if type(jass.SetUnitScale) == "function" then
        jass.SetUnitScale(unit, scaleX, scaleY2, scaleZ2)
    end
    return unit
end
return ____exports

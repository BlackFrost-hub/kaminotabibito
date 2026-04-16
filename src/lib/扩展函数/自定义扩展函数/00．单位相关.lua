--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0EYDUserData_517C_5BB9 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataGet = ____01_FF0EYDUserData_517C_5BB9.YDUserDataGet
local ____07_FF0E_6742_9879 = require("lib.扩展函数.BJ函数.07．杂项")
local ForGroupBJ = ____07_FF0E_6742_9879.ForGroupBJ
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
    local unitTypeId = nil
    if type(unitId) == "number" then
        unitTypeId = unitId
    elseif type(unitId) == "string" and #unitId == 4 then
        local bytes = {
            string.byte(unitId, 1) or 0 / 0,
            string.byte(unitId, 2) or 0 / 0,
            string.byte(unitId, 3) or 0 / 0,
            string.byte(unitId, 4) or 0 / 0
        }
        unitTypeId = bytes[1] * 16777216 + bytes[2] * 65536 + bytes[3] * 256 + bytes[4]
    end
    if unitTypeId == nil then
        return nil
    end
    local unit = jass.CreateUnit(
        jass.Player(playerId),
        unitTypeId,
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
--- 获取玩家的第一个英雄
-- 
-- @param player 玩家对象
-- @returns 玩家的第一个英雄单位，如果没有则返回null
function ____exports.getPlayerFirstHero(self, player)
    if not player then
        return nil
    end
    local heroGroup = YDUserDataGet(
        nil,
        "string",
        "玩家英雄",
        "单位组",
        "group"
    )
    if not heroGroup or type(jass.GetEnumUnit) ~= "function" or type(jass.GetOwningPlayer) ~= "function" then
        return nil
    end
    local hero = nil
    ForGroupBJ(
        nil,
        heroGroup,
        function()
            local u = jass.GetEnumUnit()
            if hero ~= nil then
                return
            end
            if jass.GetOwningPlayer(u) == player then
                local ____temp_0
                if type(jass.IsUnitType) == "function" then
                    ____temp_0 = jass.IsUnitType(u, jass.UNIT_TYPE_HERO)
                else
                    ____temp_0 = true
                end
                if ____temp_0 then
                    hero = u
                end
            end
        end
    )
    return hero
end
return ____exports

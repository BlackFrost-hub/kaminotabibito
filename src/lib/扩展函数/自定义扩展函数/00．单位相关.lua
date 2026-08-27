--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0EYDUserData_517C_5BB9 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataGet = ____01_FF0EYDUserData_517C_5BB9.YDUserDataGet
local ____04_FF0E_5355_4F4D_5DE5_5177 = require("lib.扩展函数.封装函数.01．通用工具.04．单位工具")
local forEachUnitInGroup = ____04_FF0E_5355_4F4D_5DE5_5177.forEachUnitInGroup
--- 单位相关扩展函数
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
local _____767B_8BB0_5355_4F4D_6392_6CC4 = ____require_result_0["登记单位排泄"]
local ____jglobals_bj_RADTODEG_1 = jglobals.bj_RADTODEG
if ____jglobals_bj_RADTODEG_1 == nil then
    ____jglobals_bj_RADTODEG_1 = 57.29577951308232
end
local BJ_RADTODEG = ____jglobals_bj_RADTODEG_1
local Player = jass.Player
local CreateUnit = jass.CreateUnit
local SetUnitFacing = jass.SetUnitFacing
local SetUnitScale = jass.SetUnitScale
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
    local unit = CreateUnit(
        Player(playerId),
        unitTypeId,
        x,
        y,
        0
    )
    if not unit then
        return nil
    end
    if facing ~= nil then
        SetUnitFacing(unit, facing * BJ_RADTODEG)
    end
    local scaleX = scale or 1
    local scaleY2 = scaleY or 1
    local scaleZ2 = scaleZ or 1
    SetUnitScale(unit, scaleX, scaleY2, scaleZ2)
    return _____767B_8BB0_5355_4F4D_6392_6CC4(unit)
end
____exports["创建单位并登记排泄"] = function(self, owner, unitTypeId, x, y, facing)
    local unit = CreateUnit(
        owner,
        unitTypeId,
        x,
        y,
        facing
    )
    return _____767B_8BB0_5355_4F4D_6392_6CC4(unit)
end
function ____exports.createUnitWithOptionsAndRegisterDeathCleanup(self, playerId, unitId, x, y, facing, scale, scaleY, scaleZ)
    return ____exports.createUnitWithOptions(
        nil,
        playerId,
        unitId,
        x,
        y,
        facing,
        scale,
        scaleY,
        scaleZ
    )
end
--- 获取玩家的第一个英雄
-- 
-- @param player 玩家对象
-- @returns 玩家的第一个英雄单位，如果没有则返回null
function ____exports.getPlayerFirstHero(self, player)
    if not player then
        return nil
    end
    local registeredHero = YDUserDataGet(
        nil,
        "player",
        player,
        "英雄",
        "unit"
    )
    if registeredHero ~= nil and registeredHero ~= 0 and jass:GetOwningPlayer(registeredHero) == player and jass:IsUnitType(registeredHero, jass.UNIT_TYPE_HERO) then
        return registeredHero
    end
    local heroGroup = YDUserDataGet(
        nil,
        "string",
        "玩家英雄",
        "单位组",
        "group"
    )
    if not heroGroup then
        return nil
    end
    local hero = nil
    forEachUnitInGroup(
        nil,
        heroGroup,
        function(____, u)
            if hero ~= nil then
                return
            end
            if jass:GetOwningPlayer(u) == player then
                if jass:IsUnitType(u, jass.UNIT_TYPE_HERO) then
                    hero = u
                end
            end
        end
    )
    return hero
end
return ____exports

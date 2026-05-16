--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local YDWETimerDestroyEffect = ____require_result_0.YDWETimerDestroyEffect
local starLocation = nil
--- 获取坐标点地形高度（对齐 EC_GetPointZ）
function ____exports.EC_GetPointZ(self, x, y)
    local px = x
    local py = y
    if type(self) == "number" and type(x) == "number" and y == nil then
        px = self
        py = x
    end
    if starLocation == nil then
        starLocation = jass.Location(px, py)
    else
        jass.MoveLocation(starLocation, px, py)
    end
    return jass.GetLocationZ(starLocation) or 0
end
--- 创建特效（对齐 EC_CreateEffect）
-- time:
-- - >= 0: 到时销毁
-- - == -1: 不自动处理
-- - 其它负数: 立即销毁
function ____exports.EC_CreateEffect(self, pathOrX, xOrY, yOrZ, zOrFac, facOrSize, sizeOrS, sOrTime, timeMaybe)
    local path = pathOrX
    local x = xOrY
    local y = yOrZ
    local z = zOrFac
    local fac = facOrSize
    local size = sizeOrS
    local s = sOrTime
    local time = timeMaybe
    if type(self) == "string" and type(pathOrX) == "number" and timeMaybe == nil then
        path = self
        x = pathOrX
        y = xOrY
        z = yOrZ
        fac = zOrFac
        size = facOrSize
        s = sizeOrS
        time = sOrTime
    end
    if path == nil or path == "" then
        return nil
    end
    if x == nil or x == false or x == "" then
        x = 0
    end
    if y == nil or y == false or y == "" then
        y = 0
    end
    if z == nil or z == false or z == "" then
        z = 0
    end
    if fac == nil or fac == false or fac == "" then
        fac = 0
    end
    if size == nil or size == false or size == "" then
        size = 1
    end
    if s == nil or s == false or s == "" then
        s = 1
    end
    if time == nil or time == false or time == "" then
        time = -1
    end
    local g = _G
    local eff = jass.AddSpecialEffect(path, x, y)
    g.bj_lastCreatedEffect = eff
    if not eff then
        return nil
    end
    japi.EXSetEffectSize(eff, size)
    japi.EXSetEffectZ(
        eff,
        ____exports.EC_GetPointZ(nil, x, y) + z
    )
    japi.EXEffectMatRotateZ(eff, fac)
    japi.EXSetEffectSpeed(eff, s)
    if time >= 0 then
        YDWETimerDestroyEffect(nil, time, eff)
    elseif time ~= -1 then
        jass.DestroyEffect(eff)
    end
    return eff
end
return ____exports

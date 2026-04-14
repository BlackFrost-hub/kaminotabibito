--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local japi = require("jass.japi")
local starLocation = nil
--- 获取坐标点地形高度（对齐 EC_GetPointZ）
function ____exports.EC_GetPointZ(self, x, y)
    if type(jass.Location) ~= "function" then
        return 0
    end
    if starLocation == nil then
        starLocation = jass.Location(x, y)
    elseif type(jass.MoveLocation) == "function" then
        jass.MoveLocation(starLocation, x, y)
    else
        starLocation = jass.Location(x, y)
    end
    if type(jass.GetLocationZ) == "function" then
        return jass.GetLocationZ(starLocation) or 0
    end
    return 0
end
--- 创建特效（对齐 EC_CreateEffect）
-- time:
-- - >= 0: 到时销毁（优先 YDWETimerDestroyEffect）
-- - == -1: 不自动处理
-- - 其它负数: 立即销毁
function ____exports.EC_CreateEffect(self, path, x, y, z, fac, size, s, time)
    local g = _G
    if type(jass.AddSpecialEffect) ~= "function" then
        return nil
    end
    local eff = jass.AddSpecialEffect(path, x, y)
    g.bj_lastCreatedEffect = eff
    if not eff then
        return nil
    end
    if type(japi.EXSetEffectSize) == "function" then
        japi.EXSetEffectSize(eff, size)
    end
    if type(japi.EXSetEffectZ) == "function" then
        japi.EXSetEffectZ(
            eff,
            ____exports.EC_GetPointZ(nil, x, y) + z
        )
    end
    if time >= 0 then
        if type(jass.YDWETimerDestroyEffect) == "function" then
            jass.YDWETimerDestroyEffect(time, eff)
        end
    elseif time ~= -1 then
        if type(jass.DestroyEffect) == "function" then
            jass.DestroyEffect(eff)
        end
    end
    if type(japi.EXEffectMatRotateZ) == "function" then
        japi.EXEffectMatRotateZ(eff, fac)
    end
    if type(japi.EXSetEffectSpeed) == "function" then
        japi.EXSetEffectSpeed(eff, s)
    end
    return eff
end
return ____exports

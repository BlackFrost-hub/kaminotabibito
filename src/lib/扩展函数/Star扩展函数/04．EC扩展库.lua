--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local YDWETimerDestroyEffect = ____require_result_0.YDWETimerDestroyEffect
local starLocation = nil
--- 获取坐标点地形高度（对齐 EC_GetPointZ）
function ____exports.EC_GetPointZ(self, x, y)
    if starLocation == nil then
        starLocation = jass.Location(x, y)
    else
        jass.MoveLocation(starLocation, x, y)
    end
    return jass.GetLocationZ(starLocation) or 0
end
--- 创建特效（对齐 EC_CreateEffect）
-- time:
-- - >= 0: 到时销毁
-- - == -1: 不自动处理
-- - 其它负数: 立即销毁
function ____exports.EC_CreateEffect(self, path, x, y, z, fac, size, s, time)
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

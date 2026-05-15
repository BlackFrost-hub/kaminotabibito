local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local ____exports = {}
--- 特效封装函数
-- 创建和管理特效
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_0.safeTimerStart
local safeDestroyTimer = ____require_result_0.safeDestroyTimer
local effectDestroyCtxByTimerHid = {}
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local DzBindEffect = japi.DzBindEffect
local DzUnbindEffect = japi.DzUnbindEffect
local EXSetEffectSize = japi.EXSetEffectSize
local function onTimedEffectTimerExpire()
    local t = jass.GetExpiredTimer()
    local eff = effectDestroyCtxByTimerHid[jass.GetHandleId(t)]
    __TS__Delete(
        effectDestroyCtxByTimerHid,
        jass.GetHandleId(t)
    )
    if eff then
        jass.DestroyEffect(eff)
    end
    safeDestroyTimer(nil, t)
end
--- 创建特效并在指定时间后自动销毁
-- 
-- @param modelPath 特效模型路径
-- @param x x坐标
-- @param y y坐标
-- @param z z坐标，可选，默认 0
-- @param duration 持续时间秒数，默认 2 秒
-- @returns 特效句柄
function ____exports.createTimedEffect(modelPath, x, y, z, duration)
    if z == nil then
        z = 0
    end
    if duration == nil then
        duration = 2
    end
    local eff = jass.AddSpecialEffect(modelPath, x, y)
    if not eff then
        return nil
    end
    if z ~= 0 then
        japi.EXSetEffectZ(eff, z)
    end
    local t = jass.CreateTimer()
    if t then
        effectDestroyCtxByTimerHid[jass.GetHandleId(t)] = eff
        safeTimerStart(
            nil,
            t,
            duration,
            false,
            onTimedEffectTimerExpire
        )
    end
    return eff
end
local unitEffectMap = __TS__New(Map)
local function getUnitEffectHandleId(unit)
    if not unit then
        return 0
    end
    return jass.GetHandleId(unit)
end
local function getUnitEffectKey(unit, effectKey)
    local handleId = getUnitEffectHandleId(unit)
    if not handleId then
        return ""
    end
    return (tostring(handleId) .. ":") .. effectKey
end
local function destroyBoundEffect(effect)
    if not effect then
        return
    end
    jass.DestroyEffect(effect)
end
local boundEffectCtxByTimerHid = {}
local function onBoundEffectTimerExpire()
    local t = jass.GetExpiredTimer()
    local ctx = boundEffectCtxByTimerHid[jass.GetHandleId(t)]
    __TS__Delete(
        boundEffectCtxByTimerHid,
        jass.GetHandleId(t)
    )
    if not ctx then
        return
    end
    local currentEffect = unitEffectMap:get(ctx.key)
    if currentEffect == ctx.effect then
        destroyBoundEffect(ctx.effect)
        unitEffectMap:delete(ctx.key)
    end
    safeDestroyTimer(nil, t)
end
--- 在单位上创建绑定特效
-- 
-- @param unit 目标单位
-- @param attachPoint 绑定点，如 "overhead"、"origin"、"chest"
-- @param modelPath 特效模型路径
-- @param duration 持续时间；不传则常驻，直到手动销毁
-- @returns 特效句柄；创建失败返回 null
function ____exports.createUnitEffect(unit, attachPoint, modelPath, duration, effectKey)
    if effectKey == nil then
        effectKey = "default"
    end
    if not unit then
        return nil
    end
    local key = getUnitEffectKey(unit, effectKey)
    if key == "" then
        return nil
    end
    local existingEffect = unitEffectMap:get(key)
    if existingEffect then
        destroyBoundEffect(existingEffect)
    end
    local effect = jass.AddSpecialEffectTarget(modelPath, unit, attachPoint)
    if not effect then
        return nil
    end
    unitEffectMap:set(key, effect)
    if duration ~= nil and duration > 0 then
        local t = jass.CreateTimer()
        if t then
            boundEffectCtxByTimerHid[jass.GetHandleId(t)] = {key = key, effect = effect}
            safeTimerStart(
                nil,
                t,
                duration,
                false,
                onBoundEffectTimerExpire
            )
        end
    end
    return effect
end
--- 销毁单位上的绑定特效
-- 
-- @param unit 目标单位
function ____exports.destroyUnitEffect(unit, effectKey)
    if effectKey == nil then
        effectKey = "default"
    end
    if not unit then
        return
    end
    local key = getUnitEffectKey(unit, effectKey)
    if key == "" then
        return
    end
    local effect = unitEffectMap:get(key)
    if effect then
        destroyBoundEffect(effect)
    end
    unitEffectMap:delete(key)
end
local ____Dz_7ED1_5B9A_5355_4F4D_7279_6548_8868 = __TS__New(Map)
local function _____9690_85CF_5E76_9500_6BC1Dz_7ED1_5B9A_7279_6548(effect)
    if not effect then
        return
    end
    DzUnbindEffect(effect)
    EXSetEffectSize(effect, 0)
    DestroyEffect(effect)
end
____exports["创建Dz绑定单位特效"] = function(unit, attachPoint, modelPath, effectKey)
    if effectKey == nil then
        effectKey = "default"
    end
    if not unit or modelPath == "" then
        return nil
    end
    local key = getUnitEffectKey(unit, effectKey)
    if key == "" then
        return nil
    end
    local existingEffect = ____Dz_7ED1_5B9A_5355_4F4D_7279_6548_8868:get(key)
    if existingEffect then
        _____9690_85CF_5E76_9500_6BC1Dz_7ED1_5B9A_7279_6548(existingEffect)
    end
    local effect = AddSpecialEffect(
        modelPath,
        GetUnitX(unit),
        GetUnitY(unit)
    )
    if not effect then
        return nil
    end
    DzBindEffect(unit, attachPoint, effect)
    ____Dz_7ED1_5B9A_5355_4F4D_7279_6548_8868:set(key, effect)
    return effect
end
____exports["是否已有Dz绑定单位特效"] = function(unit, effectKey)
    if effectKey == nil then
        effectKey = "default"
    end
    if not unit then
        return false
    end
    local key = getUnitEffectKey(unit, effectKey)
    if key == "" then
        return false
    end
    local effect = ____Dz_7ED1_5B9A_5355_4F4D_7279_6548_8868:get(key)
    return effect ~= nil and effect ~= 0
end
____exports["销毁Dz绑定单位特效"] = function(unit, effectKey)
    if effectKey == nil then
        effectKey = "default"
    end
    if not unit then
        return
    end
    local key = getUnitEffectKey(unit, effectKey)
    if key == "" then
        return
    end
    local effect = ____Dz_7ED1_5B9A_5355_4F4D_7279_6548_8868:get(key)
    if effect then
        _____9690_85CF_5E76_9500_6BC1Dz_7ED1_5B9A_7279_6548(effect)
    end
    ____Dz_7ED1_5B9A_5355_4F4D_7279_6548_8868:delete(key)
end
return ____exports

local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____02_FF0E_8BA1_65F6_5668 = require("lib.扩展函数.封装函数.01．通用工具.02．计时器")
local withTimer = ____02_FF0E_8BA1_65F6_5668.withTimer
--- 特效封装函数
-- 创建和管理特效
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.KK扩展API.index")
local DzUnbindEffect = ____require_result_0.DzUnbindEffect
--- 创建特效并在指定时间后自动销毁
-- 
-- @param modelPath 特效模型路径
-- @param x x坐标
-- @param y y坐标
-- @param z z坐标，可选，默认 0
-- @param duration 持续时间秒数，默认 2 秒
-- @returns 特效句柄
function ____exports.createTimedEffect(self, modelPath, x, y, z, duration)
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
    if z ~= 0 and type(japi.EXSetEffectZ) == "function" then
        japi.EXSetEffectZ(eff, z)
    end
    withTimer(
        nil,
        duration,
        function()
            jass.DestroyEffect(eff)
        end
    )
    return eff
end
local unitEffectMap = __TS__New(Map)
local function getUnitEffectHandleId(self, unit)
    if not unit then
        return 0
    end
    return jass.GetHandleId(unit)
end
local function getUnitEffectKey(self, unit, effectKey)
    local handleId = getUnitEffectHandleId(nil, unit)
    if not handleId then
        return ""
    end
    return (tostring(handleId) .. ":") .. effectKey
end
local function destroyBoundEffect(self, effect)
    if not effect then
        return
    end
    DzUnbindEffect(nil, effect)
    jass.DestroyEffect(effect)
end
--- 在单位上创建绑定特效
-- 
-- @param unit 目标单位
-- @param attachPoint 绑定点，如 "overhead"、"origin"、"chest"
-- @param modelPath 特效模型路径
-- @param duration 持续时间；不传则常驻，直到手动销毁
-- @returns 特效句柄；创建失败返回 null
function ____exports.createUnitEffect(self, unit, attachPoint, modelPath, duration, effectKey)
    if effectKey == nil then
        effectKey = "default"
    end
    if not unit then
        return nil
    end
    local key = getUnitEffectKey(nil, unit, effectKey)
    if key == "" then
        return nil
    end
    local existingEffect = unitEffectMap:get(key)
    if existingEffect then
        destroyBoundEffect(nil, existingEffect)
    end
    local effect = jass.AddSpecialEffectTarget(modelPath, unit, attachPoint)
    if not effect then
        return nil
    end
    unitEffectMap:set(key, effect)
    if duration ~= nil and duration > 0 then
        withTimer(
            nil,
            duration,
            function()
                local currentEffect = unitEffectMap:get(key)
                if currentEffect == effect then
                    destroyBoundEffect(nil, effect)
                    unitEffectMap:delete(key)
                end
            end
        )
    end
    return effect
end
--- 销毁单位上的绑定特效
-- 
-- @param unit 目标单位
function ____exports.destroyUnitEffect(self, unit, effectKey)
    if effectKey == nil then
        effectKey = "default"
    end
    if not unit then
        return
    end
    local key = getUnitEffectKey(nil, unit, effectKey)
    if key == "" then
        return
    end
    local effect = unitEffectMap:get(key)
    if effect then
        destroyBoundEffect(nil, effect)
    end
    unitEffectMap:delete(key)
end
return ____exports

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
--- 创建特效并在指定时间后自动销毁（自动处理 1.27 兼容）
-- 
-- @param modelPath 特效模型路径
-- @param x x坐标
-- @param y y坐标
-- @param z z坐标（可选，默认0）
-- @param duration 持续时间秒数（默认2秒）
-- @returns 特效句柄
function ____exports.createTimedEffect(self, modelPath, x, y, z, duration)
    if z == nil then
        z = 0
    end
    if duration == nil then
        duration = 2
    end
    local eff
    if type(jass.AddSpecialEffectZ) == "function" then
        eff = jass.AddSpecialEffectZ(modelPath, x, y, z)
    elseif type(jass.AddSpecialEffect) == "function" then
        eff = jass.AddSpecialEffect(modelPath, x, y)
    end
    if not eff then
        return nil
    end
    withTimer(
        nil,
        duration,
        function()
            if type(jass.DestroyEffect) == "function" then
                jass.DestroyEffect(eff)
            end
        end
    )
    return eff
end
--- 存储单位绑定的特效（key: 单位句柄ID, value: 特效句柄）
local unitEffectMap = __TS__New(Map)
--- 在单位上创建绑定特效
-- 
-- @param unit 目标单位
-- @param attachPoint 绑定点（如 "overhead", "origin", "chest" 等）
-- @param modelPath 特效模型路径
-- @param duration 持续时间（秒），不传则永久存在直到手动销毁
-- @returns 是否创建成功
function ____exports.createUnitEffect(self, unit, attachPoint, modelPath, duration)
    if not unit then
        return false
    end
    local ____japi_DzGetUnitObjectId_0
    if japi.DzGetUnitObjectId then
        ____japi_DzGetUnitObjectId_0 = japi.DzGetUnitObjectId(unit)
    else
        ____japi_DzGetUnitObjectId_0 = 0
    end
    local handleId = ____japi_DzGetUnitObjectId_0
    if not handleId then
        return false
    end
    local existingEffect = unitEffectMap:get(handleId)
    if existingEffect and type(jass.DestroyEffect) == "function" then
        jass.DestroyEffect(existingEffect)
    end
    local effect = jass.AddSpecialEffectTarget(modelPath, unit, attachPoint)
    if not effect then
        return false
    end
    unitEffectMap:set(handleId, effect)
    if duration ~= nil and duration > 0 then
        withTimer(
            nil,
            duration,
            function()
                local currentEffect = unitEffectMap:get(handleId)
                if currentEffect == effect and type(jass.DestroyEffect) == "function" then
                    jass.DestroyEffect(effect)
                    unitEffectMap:delete(handleId)
                end
            end
        )
    end
    return true
end
--- 销毁单位上的绑定特效
-- 
-- @param unit 目标单位
function ____exports.destroyUnitEffect(self, unit)
    if not unit then
        return
    end
    local ____japi_DzGetUnitObjectId_1
    if japi.DzGetUnitObjectId then
        ____japi_DzGetUnitObjectId_1 = japi.DzGetUnitObjectId(unit)
    else
        ____japi_DzGetUnitObjectId_1 = 0
    end
    local handleId = ____japi_DzGetUnitObjectId_1
    if not handleId then
        return
    end
    local effect = unitEffectMap:get(handleId)
    if effect and type(jass.DestroyEffect) == "function" then
        jass.DestroyEffect(effect)
    end
    unitEffectMap:delete(handleId)
end
return ____exports

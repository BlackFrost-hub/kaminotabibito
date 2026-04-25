local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local getUnitId, destroyEffect, jass, boundEffects, unitToEffectMap
function getUnitId(unit)
    if not unit then
        return 0
    end
    return jass.GetHandleId(unit)
end
function destroyEffect(effect)
    if not effect then
        return
    end
    jass.DestroyEffect(effect)
end
function ____exports.removeBoundEffect(effect)
    if not effect then
        return
    end
    local data = boundEffects:get(effect)
    if data then
        local unitId = getUnitId(data.unit)
        unitToEffectMap:delete(unitId)
    end
    boundEffects:delete(effect)
    destroyEffect(effect)
end
jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_0.EC_CreateEffect
local EC_GetPointZ = ____require_result_0.EC_GetPointZ
local ____G_1 = _G
local onTick10ms = ____G_1.onTick10ms
local offTick10ms = ____G_1.offTick10ms
--- 进度条模型路径
____exports.PROGRESSBAR_MODEL = "resource\\models\\Common\\Progressbar.mdx"
--- 默认黄色颜色 (R=255, G=255, B=0, A=255)
____exports.COLOR_YELLOW = {r = 255, g = 255, b = 0, a = 255}
--- 默认高度偏移
____exports.DEFAULT_HEIGHT_OFFSET = 233
--- 默认缩放
____exports.DEFAULT_SCALE = 3
--- 默认动画速度 (1.0 = 正常速度，越大越快)
____exports.DEFAULT_ANIM_SPEED = 1
boundEffects = __TS__New(Map)
unitToEffectMap = __TS__New(Map)
local _isRegistered = false
--- 更新所有绑定特效的位置（世界 Z = 地形 + 飞行高度 + 记录的高度偏移）
local function updateBoundEffects()
    for ____, ____value in __TS__Iterator(boundEffects) do
        local effect = ____value[1]
        local data = ____value[2]
        do
            if not data.unit then
                ____exports.removeBoundEffect(effect)
                goto __continue7
            end
            local unitX = jass.GetUnitX(data.unit)
            local unitY = jass.GetUnitY(data.unit)
            local unitFlyHeight = jass.GetUnitFlyHeight(data.unit)
            local z = EC_GetPointZ(nil, unitX, unitY) + unitFlyHeight + data.heightOffset
            japi.EXSetEffectXY(effect, unitX, unitY)
            japi.EXSetEffectZ(effect, z)
        end
        ::__continue7::
    end
    if boundEffects.size == 0 and _isRegistered then
        offTick10ms(nil, updateBoundEffects)
        _isRegistered = false
    end
end
local function ensureRegistered()
    if _isRegistered then
        return
    end
    _isRegistered = true
    onTick10ms(nil, updateBoundEffects)
end
--- 创建绑定到单位的特效
-- 
-- @param zForEC 传入 EC_CreateEffect 的 z：仅「飞行高度 + 相对地形/单位的竖直偏移」，不含地形采样
function ____exports.createBoundEffect(unit, modelPath, options)
    if not unit then
        return nil
    end
    local unitId = getUnitId(unit)
    local existingEffect = unitToEffectMap:get(unitId)
    if existingEffect then
        ____exports.removeBoundEffect(existingEffect)
    end
    local unitX = jass.GetUnitX(unit)
    local unitY = jass.GetUnitY(unit)
    local unitFlyHeight = jass.GetUnitFlyHeight(unit)
    local heightOffset = options and options.heightOffset or ____exports.DEFAULT_HEIGHT_OFFSET
    local scale = options and options.scale or ____exports.DEFAULT_SCALE
    local facing = options and options.facing or 0
    local animSpeed = options and options.animSpeed or ____exports.DEFAULT_ANIM_SPEED
    local color = options and options.color or ____exports.COLOR_YELLOW
    --- EC 内部会再加 EC_GetPointZ(x,y)，此处只传飞行高度与自定义竖直偏移
    local zForEc = unitFlyHeight + heightOffset
    local effect = EC_CreateEffect(
        nil,
        modelPath,
        unitX,
        unitY,
        zForEc,
        facing,
        scale,
        animSpeed,
        -1
    )
    if not effect then
        return nil
    end
    local colorValue = japi.DzGetColor(color.r, color.g, color.b, color.a)
    japi.DzSetEffectVertexColor(effect, colorValue)
    local data = {
        effect = effect,
        unit = unit,
        heightOffset = heightOffset,
        scale = scale,
        facing = facing,
        animSpeed = animSpeed
    }
    boundEffects:set(effect, data)
    unitToEffectMap:set(unitId, effect)
    ensureRegistered()
    return effect
end
--- 创建黄色进度条特效（默认配置）
function ____exports.createProgressBarEffect(unit, animSpeed)
    if animSpeed == nil then
        animSpeed = 1
    end
    return ____exports.createBoundEffect(unit, ____exports.PROGRESSBAR_MODEL, {heightOffset = ____exports.DEFAULT_HEIGHT_OFFSET, scale = ____exports.DEFAULT_SCALE, animSpeed = animSpeed, color = ____exports.COLOR_YELLOW})
end
function ____exports.removeUnitBoundEffect(unit)
    if not unit then
        return
    end
    local unitId = getUnitId(unit)
    local effect = unitToEffectMap:get(unitId)
    if effect then
        ____exports.removeBoundEffect(effect)
    end
end
function ____exports.hasBoundEffect(unit)
    if not unit then
        return false
    end
    local unitId = getUnitId(unit)
    return unitToEffectMap:has(unitId)
end
function ____exports.getUnitBoundEffect(unit)
    if not unit then
        return nil
    end
    local unitId = getUnitId(unit)
    return unitToEffectMap:get(unitId)
end
function ____exports.setEffectAnimSpeed(effect, speed)
    if not effect then
        return
    end
    japi.EXSetEffectSpeed(effect, speed)
    local data = boundEffects:get(effect)
    if data then
        data.animSpeed = speed
    end
end
function ____exports.clearAllBoundEffects()
    for ____, ____value in __TS__Iterator(boundEffects) do
        local effect = ____value[1]
        destroyEffect(effect)
    end
    boundEffects:clear()
    unitToEffectMap:clear()
    if _isRegistered then
        offTick10ms(nil, updateBoundEffects)
        _isRegistered = false
    end
end
return ____exports

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
--- 移除绑定特效
-- 
-- @param effect 特效句柄
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
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_1.onTick10ms
local offTick10ms = ____require_result_1.offTick10ms
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
--- 是否已注册到中心计时器
local _isRegistered = false
--- 使用 DzGetColor 生成颜色值
-- 
-- @param r 红色 (0-255)
-- @param g 绿色 (0-255)
-- @param b 蓝色 (0-255)
-- @param a 透明度 (0-255)
function ____exports.DzGetColor(r, g, b, a)
    return japi.DzGetColor(r, g, b, a)
end
--- 设置特效顶点颜色
-- 
-- @param effect 特效句柄
-- @param color 颜色值（由 DzGetColor 生成）
function ____exports.DzSetEffectVertexColor(effect, color)
    if not effect then
        return
    end
    japi.DzSetEffectVertexColor(effect, color)
end
--- 设置特效坐标
-- 
-- @param effect 特效句柄
-- @param x X坐标
-- @param y Y坐标
function ____exports.EXSetEffectXY(effect, x, y)
    if not effect then
        return
    end
    japi.EXSetEffectXY(effect, x, y)
end
--- 设置特效Z轴高度
-- 
-- @param effect 特效句柄
-- @param z Z轴高度
function ____exports.EXSetEffectZ(effect, z)
    if not effect then
        return
    end
    japi.EXSetEffectZ(effect, z)
end
--- 设置特效缩放
-- 
-- @param effect 特效句柄
-- @param scale 缩放值
function ____exports.EXSetEffectSize(effect, scale)
    if not effect then
        return
    end
    japi.EXSetEffectSize(effect, scale)
end
--- 设置特效动画速度
-- 
-- @param effect 特效句柄
-- @param speed 速度倍数
function ____exports.EXSetEffectSpeed(effect, speed)
    if not effect then
        return
    end
    japi.EXSetEffectSpeed(effect, speed)
end
--- 更新所有绑定特效的位置
local function updateBoundEffects()
    for ____, ____value in __TS__Iterator(boundEffects) do
        local effect = ____value[1]
        local data = ____value[2]
        do
            if not data.unit then
                ____exports.removeBoundEffect(effect)
                goto __continue18
            end
            local ____opt_2 = jass.GetUnitX
            if ____opt_2 ~= nil then
                ____opt_2 = ____opt_2(jass, data.unit)
            end
            local unitX = ____opt_2
            local ____opt_4 = jass.GetUnitY
            if ____opt_4 ~= nil then
                ____opt_4 = ____opt_4(jass, data.unit)
            end
            local unitY = ____opt_4
            if unitX == nil or unitY == nil then
                ____exports.removeBoundEffect(effect)
                goto __continue18
            end
            local ____opt_6 = jass.GetUnitFlyHeight
            if ____opt_6 ~= nil then
                ____opt_6 = ____opt_6(jass, data.unit)
            end
            local ____opt_6_8 = ____opt_6
            if ____opt_6_8 == nil then
                ____opt_6_8 = 0
            end
            local unitFlyHeight = ____opt_6_8
            local z = EC_GetPointZ(nil, unitX, unitY) + unitFlyHeight + data.heightOffset
            ____exports.EXSetEffectXY(effect, unitX, unitY)
            ____exports.EXSetEffectZ(effect, z)
        end
        ::__continue18::
    end
    if boundEffects.size == 0 and _isRegistered then
        offTick10ms(nil, updateBoundEffects)
        _isRegistered = false
    end
end
--- 确保已注册到中心计时器
local function ensureRegistered()
    if _isRegistered then
        return
    end
    _isRegistered = true
    onTick10ms(nil, updateBoundEffects)
end
--- 创建绑定到单位的特效
-- 
-- @param unit 目标单位
-- @param modelPath 模型路径
-- @param options 可选配置
-- @returns 特效句柄，创建失败返回 null
function ____exports.createBoundEffect(unit, modelPath, options)
    if not unit then
        return nil
    end
    local unitId = getUnitId(unit)
    local existingEffect = unitToEffectMap:get(unitId)
    if existingEffect then
        ____exports.removeBoundEffect(existingEffect)
    end
    local ____opt_9 = jass.GetUnitX
    if ____opt_9 ~= nil then
        ____opt_9 = ____opt_9(jass, unit)
    end
    local ____opt_9_11 = ____opt_9
    if ____opt_9_11 == nil then
        ____opt_9_11 = 0
    end
    local unitX = ____opt_9_11
    local ____opt_12 = jass.GetUnitY
    if ____opt_12 ~= nil then
        ____opt_12 = ____opt_12(jass, unit)
    end
    local ____opt_12_14 = ____opt_12
    if ____opt_12_14 == nil then
        ____opt_12_14 = 0
    end
    local unitY = ____opt_12_14
    local ____opt_15 = jass.GetUnitFlyHeight
    if ____opt_15 ~= nil then
        ____opt_15 = ____opt_15(jass, unit)
    end
    local ____opt_15_17 = ____opt_15
    if ____opt_15_17 == nil then
        ____opt_15_17 = 0
    end
    local unitFlyHeight = ____opt_15_17
    local heightOffset = options and options.heightOffset or ____exports.DEFAULT_HEIGHT_OFFSET
    local scale = options and options.scale or ____exports.DEFAULT_SCALE
    local facing = options and options.facing or 0
    local animSpeed = options and options.animSpeed or ____exports.DEFAULT_ANIM_SPEED
    local color = options and options.color or ____exports.COLOR_YELLOW
    local z = EC_GetPointZ(nil, unitX, unitY) + unitFlyHeight + heightOffset
    local effect = EC_CreateEffect(
        nil,
        modelPath,
        unitX,
        unitY,
        z,
        facing,
        scale,
        animSpeed,
        -1
    )
    if not effect then
        return nil
    end
    local colorValue = ____exports.DzGetColor(color.r, color.g, color.b, color.a)
    ____exports.DzSetEffectVertexColor(effect, colorValue)
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
-- 
-- @param unit 目标单位
-- @param animSpeed 动画速度（默认 1.0，开启时间越短速度越快）
-- @returns 特效句柄
function ____exports.createProgressBarEffect(unit, animSpeed)
    if animSpeed == nil then
        animSpeed = 1
    end
    return ____exports.createBoundEffect(unit, ____exports.PROGRESSBAR_MODEL, {heightOffset = ____exports.DEFAULT_HEIGHT_OFFSET, scale = ____exports.DEFAULT_SCALE, animSpeed = animSpeed, color = ____exports.COLOR_YELLOW})
end
--- 移除单位绑定的特效
-- 
-- @param unit 目标单位
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
--- 检查单位是否有绑定特效
-- 
-- @param unit 目标单位
function ____exports.hasBoundEffect(unit)
    if not unit then
        return false
    end
    local unitId = getUnitId(unit)
    return unitToEffectMap:has(unitId)
end
--- 获取单位绑定的特效
-- 
-- @param unit 目标单位
-- @returns 特效句柄或 undefined
function ____exports.getUnitBoundEffect(unit)
    if not unit then
        return nil
    end
    local unitId = getUnitId(unit)
    return unitToEffectMap:get(unitId)
end
--- 设置特效动画速度（用于控制进度条速度）
-- 
-- @param effect 特效句柄
-- @param speed 速度倍数（开启时间越短，速度越大）
function ____exports.setEffectAnimSpeed(effect, speed)
    if not effect then
        return
    end
    ____exports.EXSetEffectSpeed(effect, speed)
    local data = boundEffects:get(effect)
    if data then
        data.animSpeed = speed
    end
end
--- 清理所有绑定特效
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

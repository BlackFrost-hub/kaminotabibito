local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local destroyBoundEffect, _____505C_6B62_7279_6548_9500_6BC1_68C0_67E5, _____786E_4FDD_7279_6548_9500_6BC1_68C0_67E5, _____5B89_6392_5B9A_65F6_9500_6BC1_7279_6548, _____5904_7406_5B9A_65F6_7279_6548_9500_6BC1, _____5904_7406_7ED1_5B9A_7279_6548_9500_6BC1, ____on_7279_6548_9500_6BC1_68C0_67E5, jass, addPeriodicCallback, removePeriodicCallback, getServerTime, _____7279_6548_9500_6BC1_68C0_67E5_95F4_9694_6BEB_79D2, _____5B9A_65F6_9500_6BC1_7279_6548_5217_8868, _____5B9A_65F6_9500_6BC1_7279_6548_5230_671F_6BEB_79D2_5217_8868, _____7ED1_5B9A_7279_6548_9500_6BC1_952E_5217_8868, _____7ED1_5B9A_7279_6548_9500_6BC1_7279_6548_5217_8868, _____7ED1_5B9A_7279_6548_9500_6BC1_5230_671F_6BEB_79D2_5217_8868, _____7279_6548_9500_6BC1_68C0_67E5_56DE_8C03ID, unitEffectMap
function destroyBoundEffect(effect)
    if not effect then
        return
    end
    jass.DestroyEffect(effect)
end
function _____505C_6B62_7279_6548_9500_6BC1_68C0_67E5()
    if _____7279_6548_9500_6BC1_68C0_67E5_56DE_8C03ID <= 0 then
        return
    end
    removePeriodicCallback(_____7279_6548_9500_6BC1_68C0_67E5_56DE_8C03ID)
    _____7279_6548_9500_6BC1_68C0_67E5_56DE_8C03ID = 0
end
function _____786E_4FDD_7279_6548_9500_6BC1_68C0_67E5()
    if _____7279_6548_9500_6BC1_68C0_67E5_56DE_8C03ID > 0 then
        return
    end
    _____7279_6548_9500_6BC1_68C0_67E5_56DE_8C03ID = addPeriodicCallback(_____7279_6548_9500_6BC1_68C0_67E5_95F4_9694_6BEB_79D2, ____on_7279_6548_9500_6BC1_68C0_67E5)
end
function _____5B89_6392_5B9A_65F6_9500_6BC1_7279_6548(effect, duration)
    _____5B9A_65F6_9500_6BC1_7279_6548_5217_8868[#_____5B9A_65F6_9500_6BC1_7279_6548_5217_8868 + 1] = effect
    _____5B9A_65F6_9500_6BC1_7279_6548_5230_671F_6BEB_79D2_5217_8868[#_____5B9A_65F6_9500_6BC1_7279_6548_5230_671F_6BEB_79D2_5217_8868 + 1] = getServerTime() + duration * 1000
    _____786E_4FDD_7279_6548_9500_6BC1_68C0_67E5()
end
function _____5904_7406_5B9A_65F6_7279_6548_9500_6BC1(now)
    local writeIndex = 0
    do
        local i = 0
        while i < #_____5B9A_65F6_9500_6BC1_7279_6548_5217_8868 do
            local effect = _____5B9A_65F6_9500_6BC1_7279_6548_5217_8868[i + 1]
            if now >= _____5B9A_65F6_9500_6BC1_7279_6548_5230_671F_6BEB_79D2_5217_8868[i + 1] then
                if effect then
                    jass.DestroyEffect(effect)
                end
            else
                _____5B9A_65F6_9500_6BC1_7279_6548_5217_8868[writeIndex + 1] = effect
                _____5B9A_65F6_9500_6BC1_7279_6548_5230_671F_6BEB_79D2_5217_8868[writeIndex + 1] = _____5B9A_65F6_9500_6BC1_7279_6548_5230_671F_6BEB_79D2_5217_8868[i + 1]
                writeIndex = writeIndex + 1
            end
            i = i + 1
        end
    end
    do
        local i = #_____5B9A_65F6_9500_6BC1_7279_6548_5217_8868 - 1
        while i >= writeIndex do
            table.remove(_____5B9A_65F6_9500_6BC1_7279_6548_5217_8868)
            table.remove(_____5B9A_65F6_9500_6BC1_7279_6548_5230_671F_6BEB_79D2_5217_8868)
            i = i - 1
        end
    end
end
function _____5904_7406_7ED1_5B9A_7279_6548_9500_6BC1(now)
    local writeIndex = 0
    do
        local i = 0
        while i < #_____7ED1_5B9A_7279_6548_9500_6BC1_952E_5217_8868 do
            local key = _____7ED1_5B9A_7279_6548_9500_6BC1_952E_5217_8868[i + 1]
            local effect = _____7ED1_5B9A_7279_6548_9500_6BC1_7279_6548_5217_8868[i + 1]
            if now >= _____7ED1_5B9A_7279_6548_9500_6BC1_5230_671F_6BEB_79D2_5217_8868[i + 1] then
                local currentEffect = unitEffectMap:get(key)
                if currentEffect == effect then
                    destroyBoundEffect(effect)
                    unitEffectMap:delete(key)
                end
            else
                _____7ED1_5B9A_7279_6548_9500_6BC1_952E_5217_8868[writeIndex + 1] = key
                _____7ED1_5B9A_7279_6548_9500_6BC1_7279_6548_5217_8868[writeIndex + 1] = effect
                _____7ED1_5B9A_7279_6548_9500_6BC1_5230_671F_6BEB_79D2_5217_8868[writeIndex + 1] = _____7ED1_5B9A_7279_6548_9500_6BC1_5230_671F_6BEB_79D2_5217_8868[i + 1]
                writeIndex = writeIndex + 1
            end
            i = i + 1
        end
    end
    do
        local i = #_____7ED1_5B9A_7279_6548_9500_6BC1_952E_5217_8868 - 1
        while i >= writeIndex do
            table.remove(_____7ED1_5B9A_7279_6548_9500_6BC1_952E_5217_8868)
            table.remove(_____7ED1_5B9A_7279_6548_9500_6BC1_7279_6548_5217_8868)
            table.remove(_____7ED1_5B9A_7279_6548_9500_6BC1_5230_671F_6BEB_79D2_5217_8868)
            i = i - 1
        end
    end
end
function ____on_7279_6548_9500_6BC1_68C0_67E5()
    local now = getServerTime()
    _____5904_7406_5B9A_65F6_7279_6548_9500_6BC1(now)
    _____5904_7406_7ED1_5B9A_7279_6548_9500_6BC1(now)
    if #_____5B9A_65F6_9500_6BC1_7279_6548_5217_8868 <= 0 and #_____7ED1_5B9A_7279_6548_9500_6BC1_952E_5217_8868 <= 0 then
        _____505C_6B62_7279_6548_9500_6BC1_68C0_67E5()
    end
end
jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
getServerTime = ____require_result_0.getServerTime
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local DzBindEffect = japi.DzBindEffect
local DzUnbindEffect = japi.DzUnbindEffect
local EXSetEffectSize = japi.EXSetEffectSize
_____7279_6548_9500_6BC1_68C0_67E5_95F4_9694_6BEB_79D2 = 10
_____5B9A_65F6_9500_6BC1_7279_6548_5217_8868 = {}
_____5B9A_65F6_9500_6BC1_7279_6548_5230_671F_6BEB_79D2_5217_8868 = {}
_____7ED1_5B9A_7279_6548_9500_6BC1_952E_5217_8868 = {}
_____7ED1_5B9A_7279_6548_9500_6BC1_7279_6548_5217_8868 = {}
_____7ED1_5B9A_7279_6548_9500_6BC1_5230_671F_6BEB_79D2_5217_8868 = {}
_____7279_6548_9500_6BC1_68C0_67E5_56DE_8C03ID = 0
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
    _____5B89_6392_5B9A_65F6_9500_6BC1_7279_6548(eff, duration)
    return eff
end
unitEffectMap = __TS__New(Map)
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
local function _____5B89_6392_7ED1_5B9A_7279_6548_9500_6BC1_68C0_67E5(key, effect, duration)
    _____7ED1_5B9A_7279_6548_9500_6BC1_952E_5217_8868[#_____7ED1_5B9A_7279_6548_9500_6BC1_952E_5217_8868 + 1] = key
    _____7ED1_5B9A_7279_6548_9500_6BC1_7279_6548_5217_8868[#_____7ED1_5B9A_7279_6548_9500_6BC1_7279_6548_5217_8868 + 1] = effect
    _____7ED1_5B9A_7279_6548_9500_6BC1_5230_671F_6BEB_79D2_5217_8868[#_____7ED1_5B9A_7279_6548_9500_6BC1_5230_671F_6BEB_79D2_5217_8868 + 1] = getServerTime() + duration * 1000
    _____786E_4FDD_7279_6548_9500_6BC1_68C0_67E5()
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
        _____5B89_6392_7ED1_5B9A_7279_6548_9500_6BC1_68C0_67E5(key, effect, duration)
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

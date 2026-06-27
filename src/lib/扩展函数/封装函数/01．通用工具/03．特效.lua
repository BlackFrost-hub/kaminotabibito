local ____lualib = require("lualib_bundle")
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__Delete = ____lualib.__TS__Delete
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local _____89C4_8303_5316_7279_6548_6A21_578B_8DEF_5F84, _____9650_5236_5230_989C_8272_5B57_8282, _____53D6_7279_6548_9876_70B9_989C_8272, _____9500_6BC1_5FAA_73AF_70B9_7279_6548_53E5_67C4, _____521B_5EFA_5FAA_73AF_70B9_7279_6548_4E00_6B21, _____505C_6B62_5FAA_73AF_70B9_7279_6548Tick, _____786E_4FDD_5FAA_73AF_70B9_7279_6548Tick, _____79FB_9664_5FAA_73AF_70B9_7279_6548_8BB0_5F55, ____on_5FAA_73AF_70B9_7279_6548Tick, destroyBoundEffect, _____505C_6B62_7279_6548_9500_6BC1_68C0_67E5, _____786E_4FDD_7279_6548_9500_6BC1_68C0_67E5, _____5B89_6392_5B9A_65F6_9500_6BC1_7279_6548, _____5904_7406_5B9A_65F6_7279_6548_9500_6BC1, _____5904_7406_7ED1_5B9A_7279_6548_9500_6BC1, ____on_7279_6548_9500_6BC1_68C0_67E5, jass, addPeriodicCallback, removePeriodicCallback, getServerTime, AddSpecialEffect, DestroyEffect, EXSetEffectXY, EXSetEffectZ, EXSetEffectSize, EXSetEffectSpeed, EXEffectMatScale, DzSetEffectScale, DzGetColor, DzSetEffectVertexColor, _____7279_6548_9500_6BC1_68C0_67E5_95F4_9694_6BEB_79D2, _____5B9A_65F6_9500_6BC1_7279_6548_5217_8868, _____5B9A_65F6_9500_6BC1_7279_6548_5230_671F_6BEB_79D2_5217_8868, _____7ED1_5B9A_7279_6548_9500_6BC1_952E_5217_8868, _____7ED1_5B9A_7279_6548_9500_6BC1_7279_6548_5217_8868, _____7ED1_5B9A_7279_6548_9500_6BC1_5230_671F_6BEB_79D2_5217_8868, _____7279_6548_9500_6BC1_68C0_67E5_56DE_8C03ID, _____5FAA_73AF_70B9_7279_6548_68C0_67E5_95F4_9694_6BEB_79D2, _____5FAA_73AF_70B9_7279_6548_8868, _____5FAA_73AF_70B9_7279_6548_6570_91CF, _____5FAA_73AF_70B9_7279_6548_56DE_8C03ID, _____4E0B_4E00_4E2A_5FAA_73AF_70B9_7279_6548ID, unitEffectMap
function _____89C4_8303_5316_7279_6548_6A21_578B_8DEF_5F84(modelPath)
    if (string.find(modelPath, "imports\\", nil, true) or 0) - 1 == 0 then
        return __TS__StringSubstring(modelPath, 8)
    end
    if (string.find(modelPath, "imports/", nil, true) or 0) - 1 == 0 then
        return __TS__StringSubstring(modelPath, 8)
    end
    return modelPath
end
function _____9650_5236_5230_989C_8272_5B57_8282(value)
    if value < 0 then
        return 0
    end
    if value > 255 then
        return 255
    end
    return jass.R2I(value)
end
function _____53D6_7279_6548_9876_70B9_989C_8272(_____53C2_6570)
    if _____53C2_6570["顶点颜色"] ~= nil then
        return _____53C2_6570["顶点颜色"]
    end
    if _____53C2_6570["红"] == nil or _____53C2_6570["绿"] == nil or _____53C2_6570["蓝"] == nil then
        return nil
    end
    local alpha = _____9650_5236_5230_989C_8272_5B57_8282(_____53C2_6570["透明度"] or 255)
    local red = _____9650_5236_5230_989C_8272_5B57_8282(_____53C2_6570["红"])
    local green = _____9650_5236_5230_989C_8272_5B57_8282(_____53C2_6570["绿"])
    local blue = _____9650_5236_5230_989C_8272_5B57_8282(_____53C2_6570["蓝"])
    if type(DzGetColor) == "function" then
        return DzGetColor(alpha, red, green, blue)
    end
    return alpha * 16777216 + red * 65536 + green * 256 + blue
end
function _____9500_6BC1_5FAA_73AF_70B9_7279_6548_53E5_67C4(effect)
    if effect == nil or effect == 0 then
        return
    end
    EXSetEffectXY(effect, 0, 0)
    EXSetEffectSize(effect, 0)
    DestroyEffect(effect)
end
function _____521B_5EFA_5FAA_73AF_70B9_7279_6548_4E00_6B21(_____8BB0_5F55)
    local _____53C2_6570 = _____8BB0_5F55["参数"]
    local effect = AddSpecialEffect(
        _____89C4_8303_5316_7279_6548_6A21_578B_8DEF_5F84(_____53C2_6570["模型路径"]),
        _____53C2_6570.X,
        _____53C2_6570.Y
    )
    if effect == nil or effect == 0 then
        return nil
    end
    if _____53C2_6570.Z ~= nil and _____53C2_6570.Z ~= 0 then
        EXSetEffectZ(effect, _____53C2_6570.Z)
    end
    ____exports["设置Dz绑定特效缩放"](effect, _____53C2_6570["缩放"] or 1)
    if _____53C2_6570["动画速度"] ~= nil then
        EXSetEffectSpeed(effect, _____53C2_6570["动画速度"])
    end
    local color = _____53D6_7279_6548_9876_70B9_989C_8272(_____53C2_6570)
    if color ~= nil and type(DzSetEffectVertexColor) == "function" then
        DzSetEffectVertexColor(effect, color)
    end
    return effect
end
function _____505C_6B62_5FAA_73AF_70B9_7279_6548Tick()
    if _____5FAA_73AF_70B9_7279_6548_56DE_8C03ID <= 0 then
        return
    end
    removePeriodicCallback(_____5FAA_73AF_70B9_7279_6548_56DE_8C03ID)
    _____5FAA_73AF_70B9_7279_6548_56DE_8C03ID = 0
end
function _____786E_4FDD_5FAA_73AF_70B9_7279_6548Tick()
    if _____5FAA_73AF_70B9_7279_6548_56DE_8C03ID > 0 then
        return
    end
    _____5FAA_73AF_70B9_7279_6548_56DE_8C03ID = addPeriodicCallback(_____5FAA_73AF_70B9_7279_6548_68C0_67E5_95F4_9694_6BEB_79D2, ____on_5FAA_73AF_70B9_7279_6548Tick)
end
function _____79FB_9664_5FAA_73AF_70B9_7279_6548_8BB0_5F55(id, _____8BB0_5F55)
    _____9500_6BC1_5FAA_73AF_70B9_7279_6548_53E5_67C4(_____8BB0_5F55["当前特效"])
    if _____5FAA_73AF_70B9_7279_6548_8868[id] ~= nil then
        __TS__Delete(_____5FAA_73AF_70B9_7279_6548_8868, id)
        _____5FAA_73AF_70B9_7279_6548_6570_91CF = _____5FAA_73AF_70B9_7279_6548_6570_91CF - 1
    end
end
function ____on_5FAA_73AF_70B9_7279_6548Tick()
    local now = getServerTime()
    for idText in pairs(_____5FAA_73AF_70B9_7279_6548_8868) do
        do
            local id = idText
            local _____8BB0_5F55 = _____5FAA_73AF_70B9_7279_6548_8868[id]
            if _____8BB0_5F55 == nil then
                goto __continue39
            end
            local _____53C2_6570 = _____8BB0_5F55["参数"]
            local alive = _____53C2_6570["存活条件"] == nil or _____53C2_6570["存活条件"]()
            if _____8BB0_5F55["已停止"] or not alive or _____8BB0_5F55["结束毫秒"] > 0 and now >= _____8BB0_5F55["结束毫秒"] then
                _____79FB_9664_5FAA_73AF_70B9_7279_6548_8BB0_5F55(id, _____8BB0_5F55)
                goto __continue39
            end
            if now >= _____8BB0_5F55["下次重建毫秒"] then
                _____9500_6BC1_5FAA_73AF_70B9_7279_6548_53E5_67C4(_____8BB0_5F55["当前特效"])
                _____8BB0_5F55["当前特效"] = _____521B_5EFA_5FAA_73AF_70B9_7279_6548_4E00_6B21(_____8BB0_5F55)
                _____8BB0_5F55["下次重建毫秒"] = now + (_____53C2_6570["重建间隔秒"] or 3) * 1000
            elseif _____53C2_6570["单次持续秒"] ~= nil and _____53C2_6570["单次持续秒"] > 0 and now >= _____8BB0_5F55["下次重建毫秒"] - ((_____53C2_6570["重建间隔秒"] or 3) - _____53C2_6570["单次持续秒"]) * 1000 then
                _____9500_6BC1_5FAA_73AF_70B9_7279_6548_53E5_67C4(_____8BB0_5F55["当前特效"])
                _____8BB0_5F55["当前特效"] = nil
            end
        end
        ::__continue39::
    end
    if _____5FAA_73AF_70B9_7279_6548_6570_91CF <= 0 then
        _____505C_6B62_5FAA_73AF_70B9_7279_6548Tick()
    end
end
____exports["创建循环点特效"] = function(_____53C2_6570)
    _____4E0B_4E00_4E2A_5FAA_73AF_70B9_7279_6548ID = _____4E0B_4E00_4E2A_5FAA_73AF_70B9_7279_6548ID + 1
    local id = _____4E0B_4E00_4E2A_5FAA_73AF_70B9_7279_6548ID
    local now = getServerTime()
    local interval = _____53C2_6570["重建间隔秒"] ~= nil and _____53C2_6570["重建间隔秒"] > 0 and _____53C2_6570["重建间隔秒"] or 3
    local _____8BB0_5F55 = {
        id = id,
        ["参数"] = _____53C2_6570,
        ["当前特效"] = nil,
        ["下次重建毫秒"] = now + interval * 1000,
        ["结束毫秒"] = _____53C2_6570["总持续秒"] ~= nil and _____53C2_6570["总持续秒"] > 0 and now + _____53C2_6570["总持续秒"] * 1000 or 0,
        ["已停止"] = false
    }
    _____8BB0_5F55["当前特效"] = _____521B_5EFA_5FAA_73AF_70B9_7279_6548_4E00_6B21(_____8BB0_5F55)
    _____5FAA_73AF_70B9_7279_6548_8868[id] = _____8BB0_5F55
    _____5FAA_73AF_70B9_7279_6548_6570_91CF = _____5FAA_73AF_70B9_7279_6548_6570_91CF + 1
    _____786E_4FDD_5FAA_73AF_70B9_7279_6548Tick()
    return {id = id}
end
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
____exports["设置Dz绑定特效缩放"] = function(effect, scale)
    if effect == nil or effect == 0 then
        return
    end
    if type(DzSetEffectScale) == "function" then
        DzSetEffectScale(effect, scale)
    end
    EXSetEffectSize(effect, scale)
    if type(EXEffectMatScale) == "function" then
        EXEffectMatScale(effect, scale, scale, scale)
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
AddSpecialEffect = jass.AddSpecialEffect
DestroyEffect = jass.DestroyEffect
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local DzBindEffect = japi.DzBindEffect
local DzUnbindEffect = japi.DzUnbindEffect
local DzSetEffectPos = japi.DzSetEffectPos
EXSetEffectXY = japi.EXSetEffectXY
EXSetEffectZ = japi.EXSetEffectZ
EXSetEffectSize = japi.EXSetEffectSize
EXSetEffectSpeed = japi.EXSetEffectSpeed
EXEffectMatScale = japi.EXEffectMatScale
DzSetEffectScale = japi.DzSetEffectScale
DzGetColor = japi.DzGetColor
DzSetEffectVertexColor = japi.DzSetEffectVertexColor
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
    local eff = jass.AddSpecialEffect(
        _____89C4_8303_5316_7279_6548_6A21_578B_8DEF_5F84(modelPath),
        x,
        y
    )
    if not eff then
        return nil
    end
    if z ~= 0 then
        japi.EXSetEffectZ(eff, z)
    end
    _____5B89_6392_5B9A_65F6_9500_6BC1_7279_6548(eff, duration)
    return eff
end
____exports["创建点特效"] = function(_____53C2_6570)
    if _____53C2_6570["模型路径"] == nil or _____53C2_6570["模型路径"] == "" then
        return nil
    end
    local effect = AddSpecialEffect(
        _____89C4_8303_5316_7279_6548_6A21_578B_8DEF_5F84(_____53C2_6570["模型路径"]),
        _____53C2_6570.X,
        _____53C2_6570.Y
    )
    if effect == nil or effect == 0 then
        return nil
    end
    if _____53C2_6570.Z ~= nil and _____53C2_6570.Z ~= 0 then
        EXSetEffectZ(effect, _____53C2_6570.Z)
    end
    ____exports["设置Dz绑定特效缩放"](effect, _____53C2_6570["缩放"] or 1)
    if _____53C2_6570["动画速度"] ~= nil then
        EXSetEffectSpeed(effect, _____53C2_6570["动画速度"])
    end
    local color = _____53D6_7279_6548_9876_70B9_989C_8272(_____53C2_6570)
    if color ~= nil and type(DzSetEffectVertexColor) == "function" then
        DzSetEffectVertexColor(effect, color)
    end
    if _____53C2_6570["持续秒"] ~= nil and _____53C2_6570["持续秒"] > 0 then
        _____5B89_6392_5B9A_65F6_9500_6BC1_7279_6548(effect, _____53C2_6570["持续秒"])
    end
    return effect
end
____exports["创建单位脚下点特效"] = function(unit, _____53C2_6570)
    if unit == nil or unit == 0 then
        return nil
    end
    return ____exports["创建点特效"](__TS__ObjectAssign(
        {},
        _____53C2_6570,
        {
            X = GetUnitX(unit),
            Y = GetUnitY(unit)
        }
    ))
end
____exports["创建持续点法阵"] = function(_____53C2_6570)
    return ____exports["创建循环点特效"](_____53C2_6570)
end
_____5FAA_73AF_70B9_7279_6548_68C0_67E5_95F4_9694_6BEB_79D2 = 100
_____5FAA_73AF_70B9_7279_6548_8868 = {}
_____5FAA_73AF_70B9_7279_6548_6570_91CF = 0
_____5FAA_73AF_70B9_7279_6548_56DE_8C03ID = 0
_____4E0B_4E00_4E2A_5FAA_73AF_70B9_7279_6548ID = 0
____exports["停止循环点特效"] = function(_____53E5_67C4)
    if _____53E5_67C4 == nil then
        return
    end
    local id = type(_____53E5_67C4) == "number" and _____53E5_67C4 or _____53E5_67C4.id
    local _____8BB0_5F55 = _____5FAA_73AF_70B9_7279_6548_8868[id]
    if _____8BB0_5F55 == nil then
        return
    end
    _____8BB0_5F55["已停止"] = true
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
    local effect = jass.AddSpecialEffectTarget(
        _____89C4_8303_5316_7279_6548_6A21_578B_8DEF_5F84(modelPath),
        unit,
        attachPoint
    )
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
local _____5355_4F4D_5750_6807_8DDF_968F_7279_6548_8868 = {}
local _____5355_4F4D_5750_6807_8DDF_968F_7279_6548_6570_91CF = 0
local _____5355_4F4D_5750_6807_8DDF_968F_7279_6548_56DE_8C03ID = 0
local _____5355_4F4D_5750_6807_8DDF_968F_7279_6548_95F4_9694_6BEB_79D2 = 30
local _____5355_4F4D_5750_6807_8DDF_968F_7279_6548_9ED8_8BA4_9AD8_5EA6 = 50
local function _____89E3_7ED1_540E_5F52_96F6_5C3A_5BF8_5E76_9500_6BC1Dz_7ED1_5B9A_7279_6548(effect)
    if not effect then
        return
    end
    DzUnbindEffect(effect)
    EXSetEffectXY(effect, 0, 0)
    EXSetEffectSize(effect, 0)
    DestroyEffect(effect)
end
____exports["销毁Dz绑定特效句柄"] = function(effect)
    _____89E3_7ED1_540E_5F52_96F6_5C3A_5BF8_5E76_9500_6BC1Dz_7ED1_5B9A_7279_6548(effect)
end
____exports["创建Dz绑定单位特效"] = function(unit, attachPoint, modelPath, effectKey, scale)
    if effectKey == nil then
        effectKey = "default"
    end
    if scale == nil then
        scale = 1
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
        _____89E3_7ED1_540E_5F52_96F6_5C3A_5BF8_5E76_9500_6BC1Dz_7ED1_5B9A_7279_6548(existingEffect)
    end
    local effect = AddSpecialEffect(
        _____89C4_8303_5316_7279_6548_6A21_578B_8DEF_5F84(modelPath),
        GetUnitX(unit),
        GetUnitY(unit)
    )
    if not effect then
        return nil
    end
    DzBindEffect(unit, attachPoint, effect)
    ____exports["设置Dz绑定特效缩放"](effect, scale)
    ____Dz_7ED1_5B9A_5355_4F4D_7279_6548_8868:set(key, effect)
    return effect
end
local function _____5355_4F4D_53EF_5750_6807_8DDF_968F(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548_8BB0_5F55(key, record)
    local ____temp_1
    if record == nil then
        ____temp_1 = nil
    else
        ____temp_1 = record.effect
    end
    local effect = ____temp_1
    if effect ~= nil and effect ~= 0 then
        EXSetEffectXY(effect, 0, 0)
        EXSetEffectSize(effect, 0)
        DestroyEffect(effect)
    end
    if _____5355_4F4D_5750_6807_8DDF_968F_7279_6548_8868[key] ~= nil then
        __TS__Delete(_____5355_4F4D_5750_6807_8DDF_968F_7279_6548_8868, key)
        _____5355_4F4D_5750_6807_8DDF_968F_7279_6548_6570_91CF = _____5355_4F4D_5750_6807_8DDF_968F_7279_6548_6570_91CF - 1
    end
end
local function _____505C_6B62_5355_4F4D_5750_6807_8DDF_968F_7279_6548Tick()
    if _____5355_4F4D_5750_6807_8DDF_968F_7279_6548_56DE_8C03ID <= 0 then
        return
    end
    removePeriodicCallback(_____5355_4F4D_5750_6807_8DDF_968F_7279_6548_56DE_8C03ID)
    _____5355_4F4D_5750_6807_8DDF_968F_7279_6548_56DE_8C03ID = 0
end
local function ____on_5355_4F4D_5750_6807_8DDF_968F_7279_6548Tick()
    for key in pairs(_____5355_4F4D_5750_6807_8DDF_968F_7279_6548_8868) do
        do
            local record = _____5355_4F4D_5750_6807_8DDF_968F_7279_6548_8868[key]
            if record == nil then
                goto __continue109
            end
            if not _____5355_4F4D_53EF_5750_6807_8DDF_968F(record.unit) then
                _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548_8BB0_5F55(key, record)
                goto __continue109
            end
            DzSetEffectPos(
                record.effect,
                GetUnitX(record.unit),
                GetUnitY(record.unit),
                record.height
            )
        end
        ::__continue109::
    end
    if _____5355_4F4D_5750_6807_8DDF_968F_7279_6548_6570_91CF <= 0 then
        _____505C_6B62_5355_4F4D_5750_6807_8DDF_968F_7279_6548Tick()
    end
end
local function _____786E_4FDD_5355_4F4D_5750_6807_8DDF_968F_7279_6548Tick()
    if _____5355_4F4D_5750_6807_8DDF_968F_7279_6548_56DE_8C03ID > 0 then
        return
    end
    _____5355_4F4D_5750_6807_8DDF_968F_7279_6548_56DE_8C03ID = addPeriodicCallback(_____5355_4F4D_5750_6807_8DDF_968F_7279_6548_95F4_9694_6BEB_79D2, ____on_5355_4F4D_5750_6807_8DDF_968F_7279_6548Tick)
end
____exports["创建单位坐标跟随特效"] = function(unit, modelPath, effectKey, scale, height, animSpeed)
    if effectKey == nil then
        effectKey = "default"
    end
    if scale == nil then
        scale = 1
    end
    if height == nil then
        height = _____5355_4F4D_5750_6807_8DDF_968F_7279_6548_9ED8_8BA4_9AD8_5EA6
    end
    if not _____5355_4F4D_53EF_5750_6807_8DDF_968F(unit) or modelPath == "" then
        return nil
    end
    local key = getUnitEffectKey(unit, effectKey)
    if key == "" then
        return nil
    end
    local existingRecord = _____5355_4F4D_5750_6807_8DDF_968F_7279_6548_8868[key]
    if existingRecord then
        _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548_8BB0_5F55(key, existingRecord)
    end
    local x = GetUnitX(unit)
    local y = GetUnitY(unit)
    local effect = AddSpecialEffect(
        _____89C4_8303_5316_7279_6548_6A21_578B_8DEF_5F84(modelPath),
        x,
        y
    )
    if not effect then
        return nil
    end
    DzSetEffectPos(effect, x, y, height)
    if animSpeed ~= nil then
        EXSetEffectSpeed(effect, animSpeed)
    end
    ____exports["设置Dz绑定特效缩放"](effect, scale)
    _____5355_4F4D_5750_6807_8DDF_968F_7279_6548_8868[key] = {
        unit = unit,
        effect = effect,
        scale = scale,
        height = height,
        animSpeed = animSpeed
    }
    _____5355_4F4D_5750_6807_8DDF_968F_7279_6548_6570_91CF = _____5355_4F4D_5750_6807_8DDF_968F_7279_6548_6570_91CF + 1
    _____786E_4FDD_5355_4F4D_5750_6807_8DDF_968F_7279_6548Tick()
    return effect
end
____exports["获取单位坐标跟随特效"] = function(unit, effectKey)
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
    local record = _____5355_4F4D_5750_6807_8DDF_968F_7279_6548_8868[key]
    local ____temp_2
    if record == nil then
        ____temp_2 = nil
    else
        ____temp_2 = record.effect
    end
    return ____temp_2
end
____exports["销毁单位坐标跟随特效"] = function(unit, effectKey)
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
    local record = _____5355_4F4D_5750_6807_8DDF_968F_7279_6548_8868[key]
    if record then
        _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548_8BB0_5F55(key, record)
    end
    if _____5355_4F4D_5750_6807_8DDF_968F_7279_6548_6570_91CF <= 0 then
        _____505C_6B62_5355_4F4D_5750_6807_8DDF_968F_7279_6548Tick()
    end
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
____exports["获取Dz绑定单位特效"] = function(unit, effectKey)
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
    local ____temp_3 = ____Dz_7ED1_5B9A_5355_4F4D_7279_6548_8868:get(key)
    if ____temp_3 == nil then
        ____temp_3 = nil
    end
    return ____temp_3
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
        _____89E3_7ED1_540E_5F52_96F6_5C3A_5BF8_5E76_9500_6BC1Dz_7ED1_5B9A_7279_6548(effect)
    end
    ____Dz_7ED1_5B9A_5355_4F4D_7279_6548_8868:delete(key)
end
return ____exports

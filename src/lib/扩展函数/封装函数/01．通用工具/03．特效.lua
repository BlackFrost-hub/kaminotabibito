local ____lualib = require("lualib_bundle")
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__Class = ____lualib.__TS__Class
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__New = ____lualib.__TS__New
local __TS__Delete = ____lualib.__TS__Delete
local Map = ____lualib.Map
local ____exports = {}
local _____89C4_8303_5316_7279_6548_6A21_578B_8DEF_5F84, _____5B89_5168_8BBE_7F6E_7279_6548_5750_6807, _____505C_6B62_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548Tick, _____79FB_9664_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548, _____9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548Tick, _____9650_5236_5230_989C_8272_5B57_8282, _____53D6_7279_6548_9876_70B9_989C_8272, _____9500_6BC1_5FAA_73AF_70B9_7279_6548_53E5_67C4, _____521B_5EFA_5FAA_73AF_70B9_7279_6548_4E00_6B21, _____505C_6B62_5FAA_73AF_70B9_7279_6548Tick, _____786E_4FDD_5FAA_73AF_70B9_7279_6548Tick, _____79FB_9664_5FAA_73AF_70B9_7279_6548_8BB0_5F55, ____on_5FAA_73AF_70B9_7279_6548Tick, destroyBoundEffect, _____505C_6B62_7279_6548_9500_6BC1_68C0_67E5, _____786E_4FDD_7279_6548_9500_6BC1_68C0_67E5, _____5B89_6392_5B9A_65F6_9500_6BC1_7279_6548, _____5904_7406_5B9A_65F6_7279_6548_9500_6BC1, _____5904_7406_7ED1_5B9A_7279_6548_9500_6BC1, ____on_7279_6548_9500_6BC1_68C0_67E5, jass, addPeriodicCallback, removePeriodicCallback, getServerTime, EC_CreateEffect, DestroyEffect, EXSetEffectXY, EXSetEffectX, EXSetEffectY, EXSetEffectSize, EXEffectMatRotateX, EXEffectMatRotateY, EXEffectMatRotateZ, DzGetColor, DzSetEffectVertexColor, _____7279_6548_9500_6BC1_68C0_67E5_95F4_9694_6BEB_79D2, _____5B9A_65F6_9500_6BC1_7279_6548_5217_8868, _____5B9A_65F6_9500_6BC1_7279_6548_5230_671F_6BEB_79D2_5217_8868, _____7ED1_5B9A_7279_6548_9500_6BC1_952E_5217_8868, _____7ED1_5B9A_7279_6548_9500_6BC1_7279_6548_5217_8868, _____7ED1_5B9A_7279_6548_9500_6BC1_5230_671F_6BEB_79D2_5217_8868, _____7279_6548_9500_6BC1_68C0_67E5_56DE_8C03ID, _____6D3B_8DC3_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_5217_8868, _____9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_56DE_8C03ID, _____5FAA_73AF_70B9_7279_6548_68C0_67E5_95F4_9694_6BEB_79D2, _____5FAA_73AF_70B9_7279_6548_8868, _____5FAA_73AF_70B9_7279_6548_6570_91CF, _____5FAA_73AF_70B9_7279_6548_56DE_8C03ID, _____4E0B_4E00_4E2A_5FAA_73AF_70B9_7279_6548ID, unitEffectMap
function _____89C4_8303_5316_7279_6548_6A21_578B_8DEF_5F84(modelPath)
    if (string.find(modelPath, "imports\\", nil, true) or 0) - 1 == 0 then
        return __TS__StringSubstring(modelPath, 8)
    end
    if (string.find(modelPath, "imports/", nil, true) or 0) - 1 == 0 then
        return __TS__StringSubstring(modelPath, 8)
    end
    return modelPath
end
function _____5B89_5168_8BBE_7F6E_7279_6548_5750_6807(effect, x, y)
    if effect == nil or effect == 0 then
        return
    end
    if EXSetEffectXY ~= nil then
        EXSetEffectXY(effect, x, y)
        return
    end
    if EXSetEffectX ~= nil then
        EXSetEffectX(effect, x)
    end
    if EXSetEffectY ~= nil then
        EXSetEffectY(effect, y)
    end
end
____exports["设置特效XYZ轴旋转"] = function(effect, _____53C2_6570)
    if effect == nil or effect == 0 or _____53C2_6570 == nil then
        return
    end
    local x = _____53C2_6570["X轴角度"] or 0
    local y = _____53C2_6570["Y轴角度"] or 0
    local z = _____53C2_6570["Z轴角度"] or 0
    if x ~= 0 then
        EXEffectMatRotateX(effect, x)
    end
    if y ~= 0 then
        EXEffectMatRotateY(effect, y)
    end
    if z ~= 0 then
        EXEffectMatRotateZ(effect, z)
    end
end
function _____505C_6B62_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548Tick()
    if _____9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_56DE_8C03ID == 0 then
        return
    end
    removePeriodicCallback(_____9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_56DE_8C03ID)
    _____9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_56DE_8C03ID = 0
end
function _____79FB_9664_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548(_____5B9E_4F8B)
    local _____7D22_5F15 = __TS__ArrayIndexOf(_____6D3B_8DC3_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_5217_8868, _____5B9E_4F8B)
    if _____7D22_5F15 >= 0 then
        __TS__ArraySplice(_____6D3B_8DC3_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_5217_8868, _____7D22_5F15, 1)
    end
    if #_____6D3B_8DC3_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_5217_8868 == 0 then
        _____505C_6B62_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548Tick()
    end
end
function _____9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548Tick()
    local _____5F53_524D_6BEB_79D2 = getServerTime()
    local _____7D22_5F15 = 0
    while _____7D22_5F15 < #_____6D3B_8DC3_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_5217_8868 do
        local _____5B9E_4F8B = _____6D3B_8DC3_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_5217_8868[_____7D22_5F15 + 1]
        _____5B9E_4F8B["推进"](_____5B9E_4F8B, _____5F53_524D_6BEB_79D2)
        if _____6D3B_8DC3_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_5217_8868[_____7D22_5F15 + 1] == _____5B9E_4F8B then
            _____7D22_5F15 = _____7D22_5F15 + 1
        end
    end
end
function _____9650_5236_5230_989C_8272_5B57_8282(value)
    if value < 0 then
        return 0
    end
    if value > 255 then
        return 255
    end
    return jass:R2I(value)
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
    return DzGetColor(alpha, red, green, blue)
end
function _____9500_6BC1_5FAA_73AF_70B9_7279_6548_53E5_67C4(effect)
    if effect == nil or effect == 0 then
        return
    end
    _____5B89_5168_8BBE_7F6E_7279_6548_5750_6807(effect, 0, 0)
    EXSetEffectSize(effect, 0)
    DestroyEffect(effect)
end
function _____521B_5EFA_5FAA_73AF_70B9_7279_6548_4E00_6B21(_____8BB0_5F55)
    local _____53C2_6570 = _____8BB0_5F55["参数"]
    local effect = EC_CreateEffect(
        _____89C4_8303_5316_7279_6548_6A21_578B_8DEF_5F84(_____53C2_6570["模型路径"]),
        _____53C2_6570.X,
        _____53C2_6570.Y,
        _____53C2_6570.Z or 0,
        0,
        _____53C2_6570["缩放"] or 1,
        _____53C2_6570["动画速度"] or 1,
        -1
    )
    if effect == nil or effect == 0 then
        return nil
    end
    ____exports["设置特效XYZ轴旋转"](effect, _____53C2_6570)
    local color = _____53D6_7279_6548_9876_70B9_989C_8272(_____53C2_6570)
    if color ~= nil then
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
                goto __continue74
            end
            local _____53C2_6570 = _____8BB0_5F55["参数"]
            local alive = _____53C2_6570["存活条件"] == nil or _____53C2_6570["存活条件"]()
            if _____8BB0_5F55["已停止"] or not alive or _____8BB0_5F55["结束毫秒"] > 0 and now >= _____8BB0_5F55["结束毫秒"] then
                _____79FB_9664_5FAA_73AF_70B9_7279_6548_8BB0_5F55(id, _____8BB0_5F55)
                goto __continue74
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
        ::__continue74::
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
    jass:DestroyEffect(effect)
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
                    jass:DestroyEffect(effect)
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
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
EC_CreateEffect = ____require_result_1.EC_CreateEffect
local EC_GetPointZ = ____require_result_1.EC_GetPointZ
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local Cos = jass.Cos
local Sin = jass.Sin
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
DestroyEffect = jass.DestroyEffect
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local DzBindEffect = japi.DzBindEffect
local DzUnbindEffect = japi.DzUnbindEffect
EXSetEffectXY = japi.EXSetEffectXY
EXSetEffectX = japi.EXSetEffectX
EXSetEffectY = japi.EXSetEffectY
local EXSetEffectZ = japi.EXSetEffectZ
EXSetEffectSize = japi.EXSetEffectSize
EXEffectMatRotateX = japi.EXEffectMatRotateX
EXEffectMatRotateY = japi.EXEffectMatRotateY
EXEffectMatRotateZ = japi.EXEffectMatRotateZ
local EXEffectMatScale = japi.EXEffectMatScale
local DzSetEffectScale = japi.DzSetEffectScale
local DzSetEffectAnimation = japi.DzSetEffectAnimation
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
    return EC_CreateEffect(
        _____89C4_8303_5316_7279_6548_6A21_578B_8DEF_5F84(modelPath),
        x,
        y,
        z,
        0,
        1,
        1,
        duration
    )
end
function ____exports.createTimedUnitEffect(unit, attachPoint, modelPath, duration)
    if duration == nil then
        duration = 2
    end
    if unit == nil or unit == 0 or modelPath == "" then
        return nil
    end
    local effect = AddSpecialEffectTarget(
        _____89C4_8303_5316_7279_6548_6A21_578B_8DEF_5F84(modelPath),
        unit,
        attachPoint
    )
    if effect == nil or effect == 0 then
        return nil
    end
    _____5B89_6392_5B9A_65F6_9500_6BC1_7279_6548(effect, duration)
    return effect
end
____exports["创建点特效"] = function(_____53C2_6570)
    if _____53C2_6570["模型路径"] == nil or _____53C2_6570["模型路径"] == "" then
        return nil
    end
    local duration = _____53C2_6570["持续秒"] ~= nil and _____53C2_6570["持续秒"] > 0 and _____53C2_6570["持续秒"] or -1
    local effect = EC_CreateEffect(
        _____89C4_8303_5316_7279_6548_6A21_578B_8DEF_5F84(_____53C2_6570["模型路径"]),
        _____53C2_6570.X,
        _____53C2_6570.Y,
        _____53C2_6570.Z or 0,
        _____53C2_6570["面向角度"] or 0,
        _____53C2_6570["缩放"] or 1,
        _____53C2_6570["动画速度"] or 1,
        duration
    )
    if effect == nil or effect == 0 then
        return nil
    end
    ____exports["设置特效XYZ轴旋转"](effect, _____53C2_6570)
    if _____53C2_6570["动画索引"] ~= nil and DzSetEffectAnimation ~= nil then
        DzSetEffectAnimation(effect, _____53C2_6570["动画索引"], 0)
    end
    local color = _____53D6_7279_6548_9876_70B9_989C_8272(_____53C2_6570)
    if color ~= nil then
        DzSetEffectVertexColor(effect, color)
    end
    return effect
end
--- 销毁由创建点特效创建的常驻点特效。
____exports["销毁点特效"] = function(effect)
    if effect == nil or effect == 0 then
        return
    end
    DestroyEffect(effect)
end
local _____9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_5B9E_73B0 = __TS__Class()
_____9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_5B9E_73B0.name = "逐段直线路径点特效实现"
function _____9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_5B9E_73B0.prototype.____constructor(self, ID, _____53C2_6570)
    self["下一个距离"] = 0
    self["下次铺设毫秒"] = 0
    self["已停止"] = false
    self.ID = ID
    self["参数"] = _____53C2_6570
end
_____9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_5B9E_73B0.prototype["启动"] = function(self)
    self["创建下一段"](self)
    if not self["已停止"] then
        self["下次铺设毫秒"] = getServerTime() + self["取铺设间隔毫秒"](self)
    end
end
_____9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_5B9E_73B0.prototype["推进"] = function(self, _____5F53_524D_6BEB_79D2)
    if self["已停止"] then
        return
    end
    if self["参数"]["存活条件"] ~= nil and not self["参数"]["存活条件"]() then
        self["停止"](self)
        return
    end
    if _____5F53_524D_6BEB_79D2 < self["下次铺设毫秒"] then
        return
    end
    self["创建下一段"](self)
    if not self["已停止"] then
        self["下次铺设毫秒"] = _____5F53_524D_6BEB_79D2 + self["取铺设间隔毫秒"](self)
    end
end
_____9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_5B9E_73B0.prototype["停止"] = function(self)
    if self["已停止"] then
        return
    end
    self["已停止"] = true
    _____79FB_9664_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548(self)
end
_____9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_5B9E_73B0.prototype["是否已停止"] = function(self)
    return self["已停止"]
end
_____9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_5B9E_73B0.prototype["创建下一段"] = function(self)
    local _____8DEF_5F84_957F_5EA6 = self["参数"]["路径长度"] > 0 and self["参数"]["路径长度"] or 0
    local _____5F53_524D_8DDD_79BB = self["下一个距离"] > _____8DEF_5F84_957F_5EA6 and _____8DEF_5F84_957F_5EA6 or self["下一个距离"]
    ____exports["创建点特效"](__TS__ObjectAssign(
        {},
        self["参数"],
        {
            X = self["参数"]["起点X"] + Cos(self["参数"]["方向弧度"]) * _____5F53_524D_8DDD_79BB,
            Y = self["参数"]["起点Y"] + Sin(self["参数"]["方向弧度"]) * _____5F53_524D_8DDD_79BB
        }
    ))
    if _____5F53_524D_8DDD_79BB >= _____8DEF_5F84_957F_5EA6 then
        self["停止"](self)
        return
    end
    local _____6BB5_95F4_8DDD = self["参数"]["段间距"] > 0 and self["参数"]["段间距"] or 128
    self["下一个距离"] = _____5F53_524D_8DDD_79BB + _____6BB5_95F4_8DDD
    if self["下一个距离"] > _____8DEF_5F84_957F_5EA6 then
        self["下一个距离"] = _____8DEF_5F84_957F_5EA6
    end
end
_____9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_5B9E_73B0.prototype["取铺设间隔毫秒"] = function(self)
    local _____79D2 = self["参数"]["铺设间隔秒"] ~= nil and self["参数"]["铺设间隔秒"] > 0 and self["参数"]["铺设间隔秒"] or 0.06
    return _____79D2 * 1000
end
_____6D3B_8DC3_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_5217_8868 = {}
local _____4E0B_4E00_4E2A_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548ID = 0
_____9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_56DE_8C03ID = 0
local function _____786E_4FDD_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548Tick()
    if _____9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_56DE_8C03ID ~= 0 then
        return
    end
    _____9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_56DE_8C03ID = addPeriodicCallback(10, _____9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548Tick)
end
____exports["创建逐段直线路径点特效"] = function(_____53C2_6570)
    local ____9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_5B9E_73B0_2 = _____9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_5B9E_73B0
    _____4E0B_4E00_4E2A_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548ID = _____4E0B_4E00_4E2A_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548ID + 1
    local _____5B9E_4F8B = __TS__New(____9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_5B9E_73B0_2, _____4E0B_4E00_4E2A_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548ID, _____53C2_6570)
    _____6D3B_8DC3_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_5217_8868[#_____6D3B_8DC3_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548_5217_8868 + 1] = _____5B9E_4F8B
    _____5B9E_4F8B["启动"](_____5B9E_4F8B)
    if not _____5B9E_4F8B["是否已停止"](_____5B9E_4F8B) then
        _____786E_4FDD_9010_6BB5_76F4_7EBF_8DEF_5F84_70B9_7279_6548Tick()
    end
    return _____5B9E_4F8B
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
    return jass:GetHandleId(unit)
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
    local effect = jass:AddSpecialEffectTarget(
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
    if effect == nil or effect == 0 then
        return
    end
    DzUnbindEffect(effect)
    DzSetEffectScale(effect, 0)
    _____5B89_6392_5B9A_65F6_9500_6BC1_7279_6548(effect, 0.01)
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
    local effect = EC_CreateEffect(
        _____89C4_8303_5316_7279_6548_6A21_578B_8DEF_5F84(modelPath),
        GetUnitX(unit),
        GetUnitY(unit),
        0,
        0,
        scale,
        1,
        -1
    )
    if not effect then
        return nil
    end
    DzBindEffect(unit, attachPoint, effect)
    ____Dz_7ED1_5B9A_5355_4F4D_7279_6548_8868:set(key, effect)
    return effect
end
____exports["设置Dz绑定特效缩放"] = function(effect, scale)
    if effect == nil or effect == 0 then
        return
    end
    DzSetEffectScale(effect, scale)
    EXSetEffectSize(effect, scale)
    EXEffectMatScale(effect, scale, scale, scale)
end
--- 安全设置普通特效实例缩放，不要求特效使用 Dz 绑定。
____exports["设置特效缩放"] = function(effect, scale)
    if effect == nil or effect == 0 or scale <= 0 then
        return
    end
    EXSetEffectSize(effect, scale)
end
--- 使用 DzGetColor 组装完整 ARGB，避免手算颜色遗漏 Alpha 或通道错位。
____exports["设置特效颜色"] = function(effect, red, green, blue, alpha)
    if alpha == nil then
        alpha = 255
    end
    if effect == nil or effect == 0 then
        return
    end
    DzSetEffectVertexColor(
        effect,
        DzGetColor(alpha, red, green, blue)
    )
end
local function _____5355_4F4D_53EF_5750_6807_8DDF_968F(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548_8BB0_5F55(key, record)
    local ____temp_3
    if record == nil then
        ____temp_3 = nil
    else
        ____temp_3 = record.effect
    end
    local effect = ____temp_3
    if effect ~= nil and effect ~= 0 then
        _____5B89_5168_8BBE_7F6E_7279_6548_5750_6807(effect, 0, 0)
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
                goto __continue146
            end
            if not _____5355_4F4D_53EF_5750_6807_8DDF_968F(record.unit) then
                _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548_8BB0_5F55(key, record)
                goto __continue146
            end
            local x = GetUnitX(record.unit)
            local y = GetUnitY(record.unit)
            _____5B89_5168_8BBE_7F6E_7279_6548_5750_6807(record.effect, x, y)
            EXSetEffectZ(
                record.effect,
                EC_GetPointZ(x, y) + record.height
            )
        end
        ::__continue146::
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
____exports["创建单位坐标跟随特效"] = function(unit, modelPath, effectKey, scale, height, animSpeed, _____52A8_753B_7D22_5F15)
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
    local effect = EC_CreateEffect(
        _____89C4_8303_5316_7279_6548_6A21_578B_8DEF_5F84(modelPath),
        x,
        y,
        height,
        0,
        scale,
        animSpeed or 1,
        -1
    )
    if not effect then
        return nil
    end
    _____5B89_5168_8BBE_7F6E_7279_6548_5750_6807(effect, x, y)
    EXSetEffectZ(
        effect,
        EC_GetPointZ(x, y) + height
    )
    if _____52A8_753B_7D22_5F15 ~= nil and DzSetEffectAnimation ~= nil then
        DzSetEffectAnimation(effect, _____52A8_753B_7D22_5F15, 0)
    end
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
    local ____temp_4
    if record == nil then
        ____temp_4 = nil
    else
        ____temp_4 = record.effect
    end
    return ____temp_4
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
    local ____temp_5 = ____Dz_7ED1_5B9A_5355_4F4D_7279_6548_8868:get(key)
    if ____temp_5 == nil then
        ____temp_5 = nil
    end
    return ____temp_5
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

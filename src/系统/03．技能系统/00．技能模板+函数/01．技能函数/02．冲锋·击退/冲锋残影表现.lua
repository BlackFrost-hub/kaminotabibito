local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____5355_4F4D_5B58_6D3B, _____9650_5236_5230_5B57_8282, _____7EC4_88C5_989C_8272_503C, _____6062_590D_5355_4F4D_8868_73B0, _____9500_6BC1_51B2_950B_6B8B_5F71_8868_73B0_5B9E_4F8B, _____521B_5EFA_4E00_6B21_6B8B_5F71, ____on_51B2_950B_6B8B_5F71_8868_73B0Tick, jass, _____83B7_53D6_5355_4F4D_5F53_524D_4F4D_79FBID, YDWETimerDestroyEffect, offTick10ms, AddSpecialEffect, GetUnitX, GetUnitY, GetUnitState, SetUnitTimeScale, GetUnitFlyHeight, SetUnitFlyHeight, R2I, DzSetEffectAnimation, DzPlayEffectAnimation, DzSetEffectVertexColor, DzSetEffectVertexAlpha, DzSetEffectScale, EXSetEffectXY, EXSetEffectZ, EXSetEffectSize, EXSetEffectSpeed, EXEffectMatRotateZ, TICK_INTERVAL, UNIT_ALIVE_LIFE, _____6D3B_52A8_51B2_950B_6B8B_5F71_8868_73B0_5217_8868, _____51B2_950B_6B8B_5F71_8868_73B0_6620_5C04, _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668
function _____5355_4F4D_5B58_6D3B(u)
    return u ~= nil and u ~= 0 and GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE
end
function _____9650_5236_5230_5B57_8282(v)
    if v <= 0 then
        return 0
    end
    if v >= 255 then
        return 255
    end
    return R2I(v)
end
function _____7EC4_88C5_989C_8272_503C(r, g, b)
    return _____9650_5236_5230_5B57_8282(r) * 65536 + _____9650_5236_5230_5B57_8282(g) * 256 + _____9650_5236_5230_5B57_8282(b)
end
function _____6062_590D_5355_4F4D_8868_73B0(_____5B9E_4F8B)
    if _____5B9E_4F8B["单位"] ~= nil and _____5B9E_4F8B["单位"] ~= 0 then
        SetUnitTimeScale(_____5B9E_4F8B["单位"], 1)
        if _____5B9E_4F8B["已应用飞行高度变化"] and _____5B9E_4F8B["飞行高度变化"] ~= 0 then
            local _____5F53_524D_9AD8_5EA6 = GetUnitFlyHeight(_____5B9E_4F8B["单位"])
            SetUnitFlyHeight(_____5B9E_4F8B["单位"], _____5F53_524D_9AD8_5EA6 - _____5B9E_4F8B["飞行高度变化"], 0)
            _____5B9E_4F8B["已应用飞行高度变化"] = false
        end
    end
end
function _____9500_6BC1_51B2_950B_6B8B_5F71_8868_73B0_5B9E_4F8B(_____5B9E_4F8B)
    _____6062_590D_5355_4F4D_8868_73B0(_____5B9E_4F8B)
    __TS__Delete(_____51B2_950B_6B8B_5F71_8868_73B0_6620_5C04, _____5B9E_4F8B["冲锋ID"])
    local idx = __TS__ArrayIndexOf(_____6D3B_52A8_51B2_950B_6B8B_5F71_8868_73B0_5217_8868, _____5B9E_4F8B)
    if idx >= 0 then
        __TS__ArraySplice(_____6D3B_52A8_51B2_950B_6B8B_5F71_8868_73B0_5217_8868, idx, 1)
    end
    if #_____6D3B_52A8_51B2_950B_6B8B_5F71_8868_73B0_5217_8868 == 0 and _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 then
        _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = false
        offTick10ms(____on_51B2_950B_6B8B_5F71_8868_73B0Tick)
    end
end
function _____521B_5EFA_4E00_6B21_6B8B_5F71(_____5B9E_4F8B)
    local effect = AddSpecialEffect(
        _____5B9E_4F8B["残影模型"],
        GetUnitX(_____5B9E_4F8B["单位"]),
        GetUnitY(_____5B9E_4F8B["单位"])
    )
    if effect == nil or effect == 0 then
        return
    end
    if type(EXSetEffectXY) == "function" then
        EXSetEffectXY(
            effect,
            GetUnitX(_____5B9E_4F8B["单位"]),
            GetUnitY(_____5B9E_4F8B["单位"])
        )
    end
    if type(EXSetEffectZ) == "function" and _____5B9E_4F8B["飞行高度变化"] ~= 0 then
        EXSetEffectZ(effect, _____5B9E_4F8B["飞行高度变化"])
    end
    if type(DzSetEffectScale) == "function" then
        DzSetEffectScale(effect, _____5B9E_4F8B["残影缩放"])
    end
    if type(EXSetEffectSize) == "function" then
        EXSetEffectSize(effect, _____5B9E_4F8B["残影缩放"])
    end
    if type(EXSetEffectSpeed) == "function" then
        EXSetEffectSpeed(effect, _____5B9E_4F8B["动画速度"])
    end
    if type(EXEffectMatRotateZ) == "function" and _____5B9E_4F8B["残影朝向"] ~= nil then
        EXEffectMatRotateZ(effect, _____5B9E_4F8B["残影朝向"])
    end
    if type(DzSetEffectAnimation) == "function" and _____5B9E_4F8B["动画序号"] ~= nil then
        DzSetEffectAnimation(effect, _____5B9E_4F8B["动画序号"], 0)
    end
    if type(DzPlayEffectAnimation) == "function" and _____5B9E_4F8B["动画名"] ~= nil and _____5B9E_4F8B["动画名"] ~= "" then
        DzPlayEffectAnimation(effect, _____5B9E_4F8B["动画名"], "")
    end
    if type(DzSetEffectVertexColor) == "function" then
        DzSetEffectVertexColor(
            effect,
            _____7EC4_88C5_989C_8272_503C(_____5B9E_4F8B["染色R"], _____5B9E_4F8B["染色G"], _____5B9E_4F8B["染色B"])
        )
    end
    if type(DzSetEffectVertexAlpha) == "function" then
        DzSetEffectVertexAlpha(effect, _____5B9E_4F8B["残影透明度"])
    end
    YDWETimerDestroyEffect(nil, _____5B9E_4F8B["残影生命周期"], effect)
end
function ____on_51B2_950B_6B8B_5F71_8868_73B0Tick()
    local i = 0
    while i < #_____6D3B_52A8_51B2_950B_6B8B_5F71_8868_73B0_5217_8868 do
        do
            local _____5B9E_4F8B = _____6D3B_52A8_51B2_950B_6B8B_5F71_8868_73B0_5217_8868[i + 1]
            if not _____5355_4F4D_5B58_6D3B(_____5B9E_4F8B["单位"]) or _____83B7_53D6_5355_4F4D_5F53_524D_4F4D_79FBID(_____5B9E_4F8B["单位"]) ~= _____5B9E_4F8B["冲锋ID"] then
                _____9500_6BC1_51B2_950B_6B8B_5F71_8868_73B0_5B9E_4F8B(_____5B9E_4F8B)
                goto __continue36
            end
            _____5B9E_4F8B["下次生成剩余时间"] = _____5B9E_4F8B["下次生成剩余时间"] - TICK_INTERVAL
            if _____5B9E_4F8B["下次生成剩余时间"] <= 0 then
                _____521B_5EFA_4E00_6B21_6B8B_5F71(_____5B9E_4F8B)
                _____5B9E_4F8B["下次生成剩余时间"] = _____5B9E_4F8B["下次生成剩余时间"] + _____5B9E_4F8B["残影生成间隔"]
            end
            i = i + 1
        end
        ::__continue36::
    end
end
jass = require("jass.common")
local japi = nil
do
    local function ____catch(_e)
        japi = nil
    end
    local ____try, ____hasReturned = pcall(function()
        japi = require("jass.japi")
    end)
    if not ____try then
        ____catch(____hasReturned)
    end
end
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统")
local _____5F00_59CB_51B2_950B = ____require_result_0["开始冲锋"]
_____83B7_53D6_5355_4F4D_5F53_524D_4F4D_79FBID = ____require_result_0["获取单位当前位移ID"]
local ____require_result_1 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
YDWETimerDestroyEffect = ____require_result_1.YDWETimerDestroyEffect
local getObjectProperty = ____require_result_1.getObjectProperty
local ObjectType = ____require_result_1.ObjectType
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_2.onTick10ms
offTick10ms = ____require_result_2.offTick10ms
AddSpecialEffect = jass.AddSpecialEffect
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local GetUnitTypeId = jass.GetUnitTypeId
GetUnitState = jass.GetUnitState
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitAnimation = jass.SetUnitAnimation
SetUnitTimeScale = jass.SetUnitTimeScale
GetUnitFlyHeight = jass.GetUnitFlyHeight
SetUnitFlyHeight = jass.SetUnitFlyHeight
local UnitAddAbility = jass.UnitAddAbility
local UnitRemoveAbility = jass.UnitRemoveAbility
R2I = jass.R2I
local ____opt_result_5
if japi ~= nil then
    ____opt_result_5 = japi.DzSetEffectAnimation
end
DzSetEffectAnimation = ____opt_result_5
local ____opt_result_8
if japi ~= nil then
    ____opt_result_8 = japi.DzPlayEffectAnimation
end
DzPlayEffectAnimation = ____opt_result_8
local ____opt_result_11
if japi ~= nil then
    ____opt_result_11 = japi.DzSetEffectVertexColor
end
DzSetEffectVertexColor = ____opt_result_11
local ____opt_result_14
if japi ~= nil then
    ____opt_result_14 = japi.DzSetEffectVertexAlpha
end
DzSetEffectVertexAlpha = ____opt_result_14
local ____opt_result_17
if japi ~= nil then
    ____opt_result_17 = japi.DzSetEffectScale
end
DzSetEffectScale = ____opt_result_17
local ____opt_result_20
if japi ~= nil then
    ____opt_result_20 = japi.EXSetEffectXY
end
EXSetEffectXY = ____opt_result_20
local ____opt_result_23
if japi ~= nil then
    ____opt_result_23 = japi.EXSetEffectZ
end
EXSetEffectZ = ____opt_result_23
local ____opt_result_26
if japi ~= nil then
    ____opt_result_26 = japi.EXSetEffectSize
end
EXSetEffectSize = ____opt_result_26
local ____opt_result_29
if japi ~= nil then
    ____opt_result_29 = japi.EXSetEffectSpeed
end
EXSetEffectSpeed = ____opt_result_29
local ____opt_result_32
if japi ~= nil then
    ____opt_result_32 = japi.EXEffectMatRotateZ
end
EXEffectMatRotateZ = ____opt_result_32
TICK_INTERVAL = 0.01
UNIT_ALIVE_LIFE = 0.405
local DEFAULT_AFTERIMAGE_INTERVAL = 0.05
local DEFAULT_AFTERIMAGE_LIFETIME = 0.35
local DEFAULT_AFTERIMAGE_ALPHA = 160
local DEFAULT_AFTERIMAGE_SCALE = 1
local DEFAULT_ANIMATION_SPEED = 1
local CROW_FORM_ABILITY_ID = 1097691750
_____6D3B_52A8_51B2_950B_6B8B_5F71_8868_73B0_5217_8868 = {}
_____51B2_950B_6B8B_5F71_8868_73B0_6620_5C04 = {}
_____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = false
local function _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6(_____5355_4F4D)
    UnitAddAbility(_____5355_4F4D, CROW_FORM_ABILITY_ID)
    UnitRemoveAbility(_____5355_4F4D, CROW_FORM_ABILITY_ID)
end
local function _____89E3_6790_6B8B_5F71_6A21_578B(_____5355_4F4D, _____53C2_6570)
    if _____53C2_6570["残影模型"] ~= nil and _____53C2_6570["残影模型"] ~= "" then
        return _____53C2_6570["残影模型"]
    end
    local _____6B8B_5F71_5355_4F4D_7C7B_578B = _____53C2_6570["残影单位类型"] or GetUnitTypeId(_____5355_4F4D)
    if _____6B8B_5F71_5355_4F4D_7C7B_578B == nil or _____6B8B_5F71_5355_4F4D_7C7B_578B == 0 or _____6B8B_5F71_5355_4F4D_7C7B_578B == "" then
        return ""
    end
    return getObjectProperty(nil, ObjectType.UNIT, _____6B8B_5F71_5355_4F4D_7C7B_578B, "file") or ""
end
local function _____5E94_7528_5355_4F4D_52A8_753B_8868_73B0(_____5355_4F4D, _____53C2_6570)
    if _____53C2_6570["动画序号"] ~= nil then
        SetUnitAnimationByIndex(_____5355_4F4D, _____53C2_6570["动画序号"])
    elseif _____53C2_6570["动画名"] ~= nil and _____53C2_6570["动画名"] ~= "" then
        SetUnitAnimation(_____5355_4F4D, _____53C2_6570["动画名"])
    end
    if _____53C2_6570["动画速度"] ~= nil and _____53C2_6570["动画速度"] > 0 then
        SetUnitTimeScale(_____5355_4F4D, _____53C2_6570["动画速度"])
    end
end
local function _____6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668()
    if _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668 = true
    onTick10ms(____on_51B2_950B_6B8B_5F71_8868_73B0Tick)
end
____exports["开始冲锋并附带残影表现"] = function(_____5355_4F4D, _____4F4D_79FB_53C2_6570, _____8868_73B0_53C2_6570)
    local _____51B2_950BID = _____5F00_59CB_51B2_950B(_____5355_4F4D, _____4F4D_79FB_53C2_6570)
    if _____51B2_950BID <= 0 then
        return 0
    end
    local _____6B8B_5F71_6A21_578B = _____89E3_6790_6B8B_5F71_6A21_578B(_____5355_4F4D, _____8868_73B0_53C2_6570)
    if _____6B8B_5F71_6A21_578B == "" then
        return _____51B2_950BID
    end
    _____5E94_7528_5355_4F4D_52A8_753B_8868_73B0(_____5355_4F4D, _____8868_73B0_53C2_6570)
    local _____98DE_884C_9AD8_5EA6_53D8_5316 = _____8868_73B0_53C2_6570["飞行高度变化"] or 0
    if _____98DE_884C_9AD8_5EA6_53D8_5316 ~= 0 then
        _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6(_____5355_4F4D)
        SetUnitFlyHeight(
            _____5355_4F4D,
            GetUnitFlyHeight(_____5355_4F4D) + _____98DE_884C_9AD8_5EA6_53D8_5316,
            0
        )
    end
    local _____5B9E_4F8B = {
        ["冲锋ID"] = _____51B2_950BID,
        ["单位"] = _____5355_4F4D,
        ["残影模型"] = _____6B8B_5F71_6A21_578B,
        ["动画序号"] = _____8868_73B0_53C2_6570["动画序号"],
        ["动画名"] = _____8868_73B0_53C2_6570["动画名"],
        ["动画速度"] = _____8868_73B0_53C2_6570["动画速度"] ~= nil and _____8868_73B0_53C2_6570["动画速度"] > 0 and _____8868_73B0_53C2_6570["动画速度"] or DEFAULT_ANIMATION_SPEED,
        ["残影生命周期"] = _____8868_73B0_53C2_6570["残影生命周期"] ~= nil and _____8868_73B0_53C2_6570["残影生命周期"] > 0 and _____8868_73B0_53C2_6570["残影生命周期"] or DEFAULT_AFTERIMAGE_LIFETIME,
        ["残影透明度"] = _____8868_73B0_53C2_6570["残影透明度"] ~= nil and _____9650_5236_5230_5B57_8282(_____8868_73B0_53C2_6570["残影透明度"]) or DEFAULT_AFTERIMAGE_ALPHA,
        ["染色R"] = _____8868_73B0_53C2_6570["染色R"] ~= nil and _____9650_5236_5230_5B57_8282(_____8868_73B0_53C2_6570["染色R"]) or 255,
        ["染色G"] = _____8868_73B0_53C2_6570["染色G"] ~= nil and _____9650_5236_5230_5B57_8282(_____8868_73B0_53C2_6570["染色G"]) or 255,
        ["染色B"] = _____8868_73B0_53C2_6570["染色B"] ~= nil and _____9650_5236_5230_5B57_8282(_____8868_73B0_53C2_6570["染色B"]) or 255,
        ["残影生成间隔"] = _____8868_73B0_53C2_6570["残影生成间隔"] ~= nil and _____8868_73B0_53C2_6570["残影生成间隔"] > 0 and _____8868_73B0_53C2_6570["残影生成间隔"] or DEFAULT_AFTERIMAGE_INTERVAL,
        ["下次生成剩余时间"] = 0,
        ["飞行高度变化"] = _____98DE_884C_9AD8_5EA6_53D8_5316,
        ["已应用飞行高度变化"] = _____98DE_884C_9AD8_5EA6_53D8_5316 ~= 0,
        ["残影缩放"] = _____8868_73B0_53C2_6570["残影缩放"] ~= nil and _____8868_73B0_53C2_6570["残影缩放"] > 0 and _____8868_73B0_53C2_6570["残影缩放"] or DEFAULT_AFTERIMAGE_SCALE,
        ["残影朝向"] = _____8868_73B0_53C2_6570["残影朝向"]
    }
    _____51B2_950B_6B8B_5F71_8868_73B0_6620_5C04[_____51B2_950BID] = _____5B9E_4F8B
    _____6D3B_52A8_51B2_950B_6B8B_5F71_8868_73B0_5217_8868[#_____6D3B_52A8_51B2_950B_6B8B_5F71_8868_73B0_5217_8868 + 1] = _____5B9E_4F8B
    _____521B_5EFA_4E00_6B21_6B8B_5F71(_____5B9E_4F8B)
    _____5B9E_4F8B["下次生成剩余时间"] = _____5B9E_4F8B["残影生成间隔"]
    _____6CE8_518C_5230_4E2D_5FC3_8BA1_65F6_5668()
    return _____51B2_950BID
end
return ____exports

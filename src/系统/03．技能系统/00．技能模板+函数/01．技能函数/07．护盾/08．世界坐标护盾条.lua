local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local _____9650_523601, _____683C_5F0F_5316_6570_503C, _____683C_5F0F_5316_79D2_6570, _____4ECE_4E16_754C_62A4_76FE_6761_5217_8868_79FB_9664, _____4E16_754C_62A4_76FE_6761_5DF2_5728_5217_8868, _____786E_4FDD_4E16_754C_62A4_76FE_6761_5728_5217_8868, _____5C1D_8BD5_5173_95ED_4E16_754C_62A4_76FE_6761_8BA1_65F6_5668, _____786E_4FDD_4E16_754C_62A4_76FE_6761_8BA1_65F6_5668, _____5237_65B0_4E16_754C_62A4_76FE_6761_6587_672C, _____5237_65B0_4E16_754C_62A4_76FE_6761_7F13_964D, ____on_4E16_754C_62A4_76FE_6761Tick, onTick10ms, offTick10ms, DzFrameSetSize, DzFrameSetPoint, DzFrameSetText, DzFrameShow, DzDestroyFrame, _____70B9_5DE6_4E0A, _____4E16_754C_62A4_76FE_6761_5185_5BBD, _____4E16_754C_62A4_76FE_6761_5185_9AD8, _____4E16_754C_62A4_76FE_6761_5185X, _____4E16_754C_62A4_76FE_6761_5185Y, _____4E16_754C_62A4_76FE_6761_7F13_964D_8FFD_8D76_6BD4_4F8B, _____5DF2_6CE8_518C_4E16_754C_62A4_76FE_6761_8BA1_65F6_5668, _____4E16_754C_62A4_76FE_6761_5217_8868
local ____01_FF0E_62A4_76FE_7C7B_578B = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.01．护盾类型")
local _____62A4_76FE_7C7B_578B = ____01_FF0E_62A4_76FE_7C7B_578B["护盾类型"]
function _____9650_523601(value)
    if not (value > 0) then
        return 0
    end
    if value > 1 then
        return 1
    end
    return value
end
function _____683C_5F0F_5316_6570_503C(value)
    return tostring(math.floor(value + 0.5)
    )
end
function _____683C_5F0F_5316_79D2_6570(value)
    if not (value > 0) then
        return "0.0"
    end
    return tostring(math.floor(value * 10 + 0.5) / 10
    )
end
function _____4ECE_4E16_754C_62A4_76FE_6761_5217_8868_79FB_9664(bar)
    do
        local i = #_____4E16_754C_62A4_76FE_6761_5217_8868 - 1
        while i >= 0 do
            if _____4E16_754C_62A4_76FE_6761_5217_8868[i + 1] == bar then
                __TS__ArraySplice(_____4E16_754C_62A4_76FE_6761_5217_8868, i, 1)
                return
            end
            i = i - 1
        end
    end
end
function _____4E16_754C_62A4_76FE_6761_5DF2_5728_5217_8868(bar)
    do
        local i = 0
        while i < #_____4E16_754C_62A4_76FE_6761_5217_8868 do
            if _____4E16_754C_62A4_76FE_6761_5217_8868[i + 1] == bar then
                return true
            end
            i = i + 1
        end
    end
    return false
end
function _____786E_4FDD_4E16_754C_62A4_76FE_6761_5728_5217_8868(bar)
    if bar["已销毁"] then
        return
    end
    if not _____4E16_754C_62A4_76FE_6761_5DF2_5728_5217_8868(bar) then
        _____4E16_754C_62A4_76FE_6761_5217_8868[#_____4E16_754C_62A4_76FE_6761_5217_8868 + 1] = bar
    end
    _____786E_4FDD_4E16_754C_62A4_76FE_6761_8BA1_65F6_5668()
end
function _____5C1D_8BD5_5173_95ED_4E16_754C_62A4_76FE_6761_8BA1_65F6_5668()
    if not _____5DF2_6CE8_518C_4E16_754C_62A4_76FE_6761_8BA1_65F6_5668 then
        return
    end
    if #_____4E16_754C_62A4_76FE_6761_5217_8868 > 0 then
        return
    end
    _____5DF2_6CE8_518C_4E16_754C_62A4_76FE_6761_8BA1_65F6_5668 = false
    offTick10ms(____on_4E16_754C_62A4_76FE_6761Tick)
end
function _____786E_4FDD_4E16_754C_62A4_76FE_6761_8BA1_65F6_5668()
    if _____5DF2_6CE8_518C_4E16_754C_62A4_76FE_6761_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_4E16_754C_62A4_76FE_6761_8BA1_65F6_5668 = true
    onTick10ms(____on_4E16_754C_62A4_76FE_6761Tick)
end
function _____5237_65B0_4E16_754C_62A4_76FE_6761_6587_672C(bar)
    local text = ((((("|cffccffff" .. bar["名称"]) .. " ") .. _____683C_5F0F_5316_6570_503C(bar["当前值"])) .. "/") .. _____683C_5F0F_5316_6570_503C(bar["最大值"])) .. "|r"
    if bar["显示倒计时"] then
        text = ((text .. " |cffffe6a8") .. _____683C_5F0F_5316_79D2_6570(bar["剩余时间"])) .. "s|r"
    end
    DzFrameSetText(bar.text, text)
end
function _____5237_65B0_4E16_754C_62A4_76FE_6761_7F13_964D(bar, _____5F53_524D_6BD4_4F8B)
    local lagPct = bar["缓降比例"] - _____5F53_524D_6BD4_4F8B
    if lagPct > 0.003 then
        DzFrameSetPoint(
            bar.lag,
            _____70B9_5DE6_4E0A,
            bar.root,
            _____70B9_5DE6_4E0A,
            _____4E16_754C_62A4_76FE_6761_5185X + _____4E16_754C_62A4_76FE_6761_5185_5BBD * _____5F53_524D_6BD4_4F8B,
            _____4E16_754C_62A4_76FE_6761_5185Y
        )
        DzFrameSetSize(bar.lag, _____4E16_754C_62A4_76FE_6761_5185_5BBD * lagPct, _____4E16_754C_62A4_76FE_6761_5185_9AD8)
        DzFrameShow(bar.lag, true)
    else
        DzFrameShow(bar.lag, false)
    end
end
function ____on_4E16_754C_62A4_76FE_6761Tick()
    do
        local i = #_____4E16_754C_62A4_76FE_6761_5217_8868 - 1
        while i >= 0 do
            do
                local bar = _____4E16_754C_62A4_76FE_6761_5217_8868[i + 1]
                if bar == nil or bar["已销毁"] then
                    __TS__ArraySplice(_____4E16_754C_62A4_76FE_6761_5217_8868, i, 1)
                    goto __continue47
                end
                local currentPct = _____9650_523601(bar["当前值"] / bar["最大值"])
                if bar["缓降比例"] > currentPct then
                    local nextPct = bar["缓降比例"] - _____4E16_754C_62A4_76FE_6761_7F13_964D_8FFD_8D76_6BD4_4F8B
                    bar["缓降比例"] = nextPct > currentPct and nextPct or currentPct
                    _____5237_65B0_4E16_754C_62A4_76FE_6761_7F13_964D(bar, currentPct)
                else
                    bar["缓降比例"] = currentPct
                    DzFrameShow(bar.lag, false)
                end
                if bar["持续计时"] then
                    bar["剩余时间"] = bar["剩余时间"] - 0.01
                end
                bar["刷新Tick"] = bar["刷新Tick"] + 1
                if bar["刷新Tick"] >= 10 then
                    bar["刷新Tick"] = 0
                    _____5237_65B0_4E16_754C_62A4_76FE_6761_6587_672C(bar)
                end
                if bar["持续计时"] and bar["剩余时间"] <= 0 then
                    ____exports["销毁世界坐标护盾条"](bar)
                elseif not bar["持续计时"] and not (bar["缓降比例"] - currentPct > 0.003) then
                    __TS__ArraySplice(_____4E16_754C_62A4_76FE_6761_5217_8868, i, 1)
                end
                if not bar["已销毁"] then
                    DzFrameShow(bar.root, bar["当前值"] > 0 or bar["缓降比例"] - currentPct > 0.003)
                end
            end
            ::__continue47::
            i = i - 1
        end
    end
    _____5C1D_8BD5_5173_95ED_4E16_754C_62A4_76FE_6761_8BA1_65F6_5668()
end
____exports["更新世界坐标护盾条"] = function(bar, _____5F53_524D_503C)
    if bar == nil or bar["已销毁"] then
        return
    end
    local oldPct = bar["缓降比例"]
    bar["当前值"] = _____5F53_524D_503C
    local pct = _____9650_523601(_____5F53_524D_503C / bar["最大值"])
    if pct >= oldPct then
        bar["缓降比例"] = pct
    else
        bar["缓降比例"] = oldPct
        _____786E_4FDD_4E16_754C_62A4_76FE_6761_5728_5217_8868(bar)
    end
    _____5237_65B0_4E16_754C_62A4_76FE_6761_7F13_964D(bar, pct)
    DzFrameSetSize(bar.fill, _____4E16_754C_62A4_76FE_6761_5185_5BBD * pct, _____4E16_754C_62A4_76FE_6761_5185_9AD8)
    _____5237_65B0_4E16_754C_62A4_76FE_6761_6587_672C(bar)
    DzFrameShow(bar.root, _____5F53_524D_503C > 0 or bar["缓降比例"] - pct > 0.003)
end
____exports["销毁世界坐标护盾条"] = function(bar)
    if bar == nil or bar["已销毁"] then
        return
    end
    bar["已销毁"] = true
    _____4ECE_4E16_754C_62A4_76FE_6761_5217_8868_79FB_9664(bar)
    DzFrameShow(bar.root, false)
    DzDestroyFrame(bar.root)
    _____5C1D_8BD5_5173_95ED_4E16_754C_62A4_76FE_6761_8BA1_65F6_5668()
end
---
-- @noSelfInFile
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
onTick10ms = ____require_result_0.onTick10ms
offTick10ms = ____require_result_0.offTick10ms
local DzCreateFrameByTagName = japi.DzCreateFrameByTagName
local DzGetGameUI = japi.DzGetGameUI
local DzFrameGetLowerLevelFrame = japi.DzFrameGetLowerLevelFrame
DzFrameSetSize = japi.DzFrameSetSize
DzFrameSetPoint = japi.DzFrameSetPoint
local DzFrameSetTexture = japi.DzFrameSetTexture
DzFrameSetText = japi.DzFrameSetText
local DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment
local DzFrameSetTextColor = japi.DzFrameSetTextColor
local DzFrameSetFont = japi.DzFrameSetFont
local DzFrameSetPriority = japi.DzFrameSetPriority
local DzFrameSetIgnoreTrackEvents = japi.DzFrameSetIgnoreTrackEvents
local DzFrameBindWorldPos = japi.DzFrameBindWorldPos
DzFrameShow = japi.DzFrameShow
DzDestroyFrame = japi.DzDestroyFrame
local _____62A4_76FE_6761_5E95_6846 = "UI\\UnitHealthBar\\bar_frame.tga"
local _____62A4_76FE_6761_7F13_964D_8D34_56FE = "UI\\UnitHealthBar\\bar_damage_lag_white.tga"
_____70B9_5DE6_4E0A = 0
local _____70B9_4E2D = 4
local _____4E16_754C_62A4_76FE_6761_5BBD = 0.066
local _____4E16_754C_62A4_76FE_6761_9AD8 = 0.012
_____4E16_754C_62A4_76FE_6761_5185_5BBD = 0.062
_____4E16_754C_62A4_76FE_6761_5185_9AD8 = 0.0064
_____4E16_754C_62A4_76FE_6761_5185X = 0.002
_____4E16_754C_62A4_76FE_6761_5185Y = -0.0028
local _____4E16_754C_62A4_76FE_6761_6587_5B57_5BBD = 0.085
local _____4E16_754C_62A4_76FE_6761_6587_5B57_9AD8 = 0.01
local _____4E16_754C_62A4_76FE_6761_5C42_7EA7 = 6500
_____4E16_754C_62A4_76FE_6761_7F13_964D_8FFD_8D76_6BD4_4F8B = 0.008
local _____4E16_754C_62A4_76FE_6761_7236_5E27 = 0
local _____4E0B_4E00_4E2A_4E16_754C_62A4_76FE_6761ID = 1
_____5DF2_6CE8_518C_4E16_754C_62A4_76FE_6761_8BA1_65F6_5668 = false
_____4E16_754C_62A4_76FE_6761_5217_8868 = {}
local function _____53D6_62A4_76FE_8D34_56FE(shieldType)
    if shieldType == _____62A4_76FE_7C7B_578B["物理"] then
        return "UI\\UnitHealthBar\\bar_shield_physical.tga"
    end
    if shieldType == _____62A4_76FE_7C7B_578B["魔法"] then
        return "UI\\UnitHealthBar\\bar_shield_magic.tga"
    end
    if shieldType == _____62A4_76FE_7C7B_578B["强化"] then
        return "UI\\UnitHealthBar\\bar_shield_enhanced.tga"
    end
    if shieldType == _____62A4_76FE_7C7B_578B["火"] then
        return "UI\\UnitHealthBar\\bar_shield_fire.tga"
    end
    if shieldType == _____62A4_76FE_7C7B_578B["水"] or shieldType == _____62A4_76FE_7C7B_578B["冰"] then
        return "UI\\UnitHealthBar\\bar_shield_water.tga"
    end
    if shieldType == _____62A4_76FE_7C7B_578B["雷"] then
        return "UI\\UnitHealthBar\\bar_shield_thunder.tga"
    end
    if shieldType == _____62A4_76FE_7C7B_578B["金"] or shieldType == _____62A4_76FE_7C7B_578B["毒"] then
        return "UI\\UnitHealthBar\\bar_shield_metal.tga"
    end
    if shieldType == _____62A4_76FE_7C7B_578B["木"] or shieldType == _____62A4_76FE_7C7B_578B["风"] then
        return "UI\\UnitHealthBar\\bar_shield_wood.tga"
    end
    if shieldType == _____62A4_76FE_7C7B_578B["光"] then
        return "UI\\UnitHealthBar\\bar_shield_light.tga"
    end
    if shieldType == _____62A4_76FE_7C7B_578B["暗"] then
        return "UI\\UnitHealthBar\\bar_shield_dark.tga"
    end
    return "UI\\UnitHealthBar\\bar_shield_white.tga"
end
local function _____53D6_4E16_754C_62A4_76FE_6761_7236_5E27()
    if _____4E16_754C_62A4_76FE_6761_7236_5E27 ~= 0 then
        return _____4E16_754C_62A4_76FE_6761_7236_5E27
    end
    local lower = DzFrameGetLowerLevelFrame()
    local parent = lower ~= nil and lower ~= 0 and lower or DzGetGameUI()
    _____4E16_754C_62A4_76FE_6761_7236_5E27 = DzCreateFrameByTagName(
        "FRAME",
        "WorldShieldBarLayer",
        parent,
        "",
        0
    )
    if _____4E16_754C_62A4_76FE_6761_7236_5E27 == 0 then
        return parent
    end
    return _____4E16_754C_62A4_76FE_6761_7236_5E27
end
local function _____521B_5EFA_8D34_56FE_5E27(_____540D_79F0, _____7236_7EA7, _____8D34_56FE, _____4F18_5148_7EA7)
    local frame = DzCreateFrameByTagName(
        "BACKDROP",
        _____540D_79F0,
        _____7236_7EA7,
        "",
        0
    )
    if frame == nil or frame == 0 then
        return 0
    end
    DzFrameSetTexture(frame, _____8D34_56FE, 0)
    DzFrameSetPriority(frame, _____4F18_5148_7EA7)
    DzFrameSetIgnoreTrackEvents(frame, true)
    return frame
end
____exports["创建世界坐标护盾条"] = function(_____53C2_6570)
    if not (_____53C2_6570["最大值"] > 0) then
        return nil
    end
    local id = _____4E0B_4E00_4E2A_4E16_754C_62A4_76FE_6761ID
    _____4E0B_4E00_4E2A_4E16_754C_62A4_76FE_6761ID = _____4E0B_4E00_4E2A_4E16_754C_62A4_76FE_6761ID + 1
    local parent = _____53D6_4E16_754C_62A4_76FE_6761_7236_5E27()
    local suffix = tostring(id)
    local root = _____521B_5EFA_8D34_56FE_5E27("WorldShieldBarRoot_" .. suffix, parent, _____62A4_76FE_6761_5E95_6846, _____4E16_754C_62A4_76FE_6761_5C42_7EA7)
    if root == 0 then
        return nil
    end
    local lag = _____521B_5EFA_8D34_56FE_5E27("WorldShieldBarLag_" .. suffix, root, _____62A4_76FE_6761_7F13_964D_8D34_56FE, _____4E16_754C_62A4_76FE_6761_5C42_7EA7 + 1)
    local fill = _____521B_5EFA_8D34_56FE_5E27(
        "WorldShieldBarFill_" .. suffix,
        root,
        _____53D6_62A4_76FE_8D34_56FE(_____53C2_6570["类型"]),
        _____4E16_754C_62A4_76FE_6761_5C42_7EA7 + 2
    )
    local text = DzCreateFrameByTagName(
        "TEXT",
        "WorldShieldBarText_" .. suffix,
        root,
        "",
        0
    )
    if lag == 0 or fill == 0 or text == nil or text == 0 then
        DzDestroyFrame(root)
        return nil
    end
    DzFrameSetSize(root, _____4E16_754C_62A4_76FE_6761_5BBD, _____4E16_754C_62A4_76FE_6761_9AD8)
    DzFrameSetSize(lag, 0, _____4E16_754C_62A4_76FE_6761_5185_9AD8)
    DzFrameSetPoint(
        lag,
        _____70B9_5DE6_4E0A,
        root,
        _____70B9_5DE6_4E0A,
        _____4E16_754C_62A4_76FE_6761_5185X,
        _____4E16_754C_62A4_76FE_6761_5185Y
    )
    DzFrameSetSize(fill, _____4E16_754C_62A4_76FE_6761_5185_5BBD, _____4E16_754C_62A4_76FE_6761_5185_9AD8)
    DzFrameSetPoint(
        fill,
        _____70B9_5DE6_4E0A,
        root,
        _____70B9_5DE6_4E0A,
        _____4E16_754C_62A4_76FE_6761_5185X,
        _____4E16_754C_62A4_76FE_6761_5185Y
    )
    DzFrameSetSize(text, _____4E16_754C_62A4_76FE_6761_6587_5B57_5BBD, _____4E16_754C_62A4_76FE_6761_6587_5B57_9AD8)
    DzFrameSetPoint(
        text,
        _____70B9_4E2D,
        root,
        _____70B9_4E2D,
        0,
        0.012
    )
    DzFrameSetTextAlignment(text, -1)
    DzFrameSetTextAlignment(text, 18)
    DzFrameSetTextColor(
        text,
        210,
        235,
        255,
        255
    )
    DzFrameSetFont(text, "UI\\unit_name_zcool_qingke.ttf", 0.01, 0)
    DzFrameSetPriority(text, _____4E16_754C_62A4_76FE_6761_5C42_7EA7 + 2)
    DzFrameSetIgnoreTrackEvents(text, true)
    local ____array_2 = __TS__SparseArrayNew(
        root,
        _____53C2_6570.X,
        _____53C2_6570.Y,
        _____53C2_6570.Z or 180,
        0,
        0
    )
    local ____53C2_6570__96FE_4E2D_53EF_89C1_1 = _____53C2_6570["雾中可见"]
    if ____53C2_6570__96FE_4E2D_53EF_89C1_1 == nil then
        ____53C2_6570__96FE_4E2D_53EF_89C1_1 = false
    end
    __TS__SparseArrayPush(____array_2, ____53C2_6570__96FE_4E2D_53EF_89C1_1)
    DzFrameBindWorldPos(__TS__SparseArraySpread(____array_2))
    DzFrameShow(root, true)
    DzFrameShow(lag, false)
    DzFrameShow(fill, true)
    DzFrameShow(text, true)
    local currentValue = _____53C2_6570["当前值"] or _____53C2_6570["最大值"]
    local duration = _____53C2_6570["持续时间"] or 0
    local ____id_4 = id
    local ____root_5 = root
    local ____lag_6 = lag
    local ____fill_7 = fill
    local ____text_8 = text
    local ____53C2_6570__6700_5927_503C_9 = _____53C2_6570["最大值"]
    local ____9650_523601_result_10 = _____9650_523601(currentValue / _____53C2_6570["最大值"])
    local ____temp_11 = duration > 0
    local ____53C2_6570__663E_793A_5012_8BA1_65F6_3 = _____53C2_6570["显示倒计时"]
    if ____53C2_6570__663E_793A_5012_8BA1_65F6_3 == nil then
        ____53C2_6570__663E_793A_5012_8BA1_65F6_3 = true
    end
    local bar = {
        id = ____id_4,
        root = ____root_5,
        lag = ____lag_6,
        fill = ____fill_7,
        text = ____text_8,
        ["最大值"] = ____53C2_6570__6700_5927_503C_9,
        ["当前值"] = currentValue,
        ["缓降比例"] = ____9650_523601_result_10,
        ["剩余时间"] = duration,
        ["持续计时"] = ____temp_11,
        ["显示倒计时"] = ____53C2_6570__663E_793A_5012_8BA1_65F6_3 and duration > 0,
        ["名称"] = _____53C2_6570["名称"] or "魔盾",
        ["刷新Tick"] = 0,
        ["已销毁"] = false
    }
    if bar["持续计时"] then
        _____786E_4FDD_4E16_754C_62A4_76FE_6761_5728_5217_8868(bar)
    end
    ____exports["更新世界坐标护盾条"](bar, bar["当前值"])
    return bar
end
return ____exports

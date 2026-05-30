--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5E38_91CF_5B9A_4E49 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.06．Boss血条弱点韧性.01．常量定义")
local ____Boss_8840_6761UI_5E38_91CF = ____01_FF0E_5E38_91CF_5B9A_4E49["Boss血条UI常量"]
local ____05_FF0EBoss_5F31_70B9_8FD0_884C_72B6_6001 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.06．Boss血条弱点韧性.05．Boss弱点运行状态")
local _____83B7_53D6_5168_90E8Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001 = ____05_FF0EBoss_5F31_70B9_8FD0_884C_72B6_6001["获取全部Boss血条弱点韧性运行状态"]
local japi = require("jass.japi")
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local GetUnitLifePercentBJ = ____require_result_1.GetUnitLifePercentBJ
local IsUnitAliveBJ = ____require_result_1.IsUnitAliveBJ
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local getObjectPropertySafe = ____require_result_2.getObjectPropertySafe
local ____require_result_3 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local ObjectType = ____require_result_3.ObjectType
local DzCreateFrameByTagName = japi.DzCreateFrameByTagName
local DzGetGameUI = japi.DzGetGameUI
local DzFrameSetModel = japi.DzFrameSetModel
local DzFrameSetAnimate = japi.DzFrameSetAnimate
local DzFrameSetAnimateOffset = japi.DzFrameSetAnimateOffset
local DzFrameSetPoint = japi.DzFrameSetPoint
local DzFrameSetPriority = japi.DzFrameSetPriority
local DzFrameSetTexture = japi.DzFrameSetTexture
local DzFrameSetSize = japi.DzFrameSetSize
local DzFrameSetText = japi.DzFrameSetText
local DzFrameSetAlpha = japi.DzFrameSetAlpha
local DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint
local DzFrameShow = japi.DzFrameShow
local DzDestroyFrame = japi.DzDestroyFrame
local GetUnitTypeId = jass.GetUnitTypeId
local R2I = jass.R2I
local _____8840_6761_5237_65B0_56DE_8C03ID = 0
local function _____9650_5236_6BD4_4F8B(value)
    if value < 0 then
        return 0
    end
    if value > 1 then
        return 1
    end
    return value
end
local function _____53D6Boss_5934_50CF_8DEF_5F84(bossUnit)
    if bossUnit == nil or bossUnit == 0 then
        return ""
    end
    local unitTypeId = GetUnitTypeId(bossUnit)
    if unitTypeId == 0 then
        return ""
    end
    return getObjectPropertySafe(ObjectType.UNIT, unitTypeId, "Art") or ""
end
local function _____663E_793A_8840_6761_5E27_7EC4(state, visible)
    if state["血条Frame"] ~= 0 then
        DzFrameShow(state["血条Frame"], visible)
    end
    if state["损失血条Frame"] ~= 0 then
        DzFrameShow(state["损失血条Frame"], visible)
    end
    if state["头像Frame"] ~= 0 then
        DzFrameShow(state["头像Frame"], visible)
    end
    if state["血量文本Frame"] ~= 0 then
        DzFrameShow(state["血量文本Frame"], visible)
    end
    if state["护盾框Frame"] ~= 0 then
        DzFrameShow(state["护盾框Frame"], visible)
    end
    if state["护盾填充Frame"] ~= 0 then
        DzFrameShow(state["护盾填充Frame"], visible)
    end
end
local function _____9500_6BC1_5E27(frame)
    if frame == 0 then
        return
    end
    DzFrameShow(frame, false)
    DzDestroyFrame(frame)
end
local function _____5237_65B0Boss_8840_6761UI(state)
    if state["是否已结束"] or not state["是否血条已注册"] then
        return
    end
    if state["Boss单位"] == nil or state["Boss单位"] == 0 or not IsUnitAliveBJ(state["Boss单位"]) then
        _____663E_793A_8840_6761_5E27_7EC4(state, false)
        return
    end
    local hpPercent = GetUnitLifePercentBJ(state["Boss单位"])
    local hpRatio = _____9650_5236_6BD4_4F8B(hpPercent / 100)
    local shieldValue = state["当前护盾值"]
    local shieldMax = state["最大护盾值"]
    if state["血量文本Frame"] ~= 0 then
        DzFrameSetText(
            state["血量文本Frame"],
            (" [HP] ：" .. tostring(R2I(hpPercent))) .. "%"
        )
    end
    if state["损失血条Frame"] ~= 0 then
        DzFrameSetAnimateOffset(state["损失血条Frame"], hpPercent >= 100 and 0.9999 or hpRatio)
    end
    if shieldValue <= 0 or shieldMax <= 0 then
        if state["护盾填充Frame"] ~= 0 then
            DzFrameShow(state["护盾填充Frame"], false)
        end
        return
    end
    local shieldRatio = _____9650_5236_6BD4_4F8B(shieldValue / shieldMax)
    if state["护盾填充Frame"] ~= 0 then
        DzFrameSetSize(state["护盾填充Frame"], ____Boss_8840_6761UI_5E38_91CF["护盾填充基础宽"] * shieldRatio, ____Boss_8840_6761UI_5E38_91CF["护盾填充高"])
        DzFrameSetAbsolutePoint(state["护盾填充Frame"], ____Boss_8840_6761UI_5E38_91CF["锚点中心"], ____Boss_8840_6761UI_5E38_91CF["护盾填充基础X"] - ____Boss_8840_6761UI_5E38_91CF["护盾填充偏移系数"] * (1 - shieldRatio), ____Boss_8840_6761UI_5E38_91CF["护盾填充Y"])
        DzFrameShow(state["护盾填充Frame"], true)
    end
end
local function ____onBoss_8840_6761_5237_65B0Tick()
    local states = _____83B7_53D6_5168_90E8Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001()
    do
        local i = 0
        while i < #states do
            _____5237_65B0Boss_8840_6761UI(states[i + 1])
            i = i + 1
        end
    end
end
local function _____786E_4FDDBoss_8840_6761_5237_65B0()
    if _____8840_6761_5237_65B0_56DE_8C03ID ~= 0 then
        return
    end
    _____8840_6761_5237_65B0_56DE_8C03ID = addPeriodicCallback(____Boss_8840_6761UI_5E38_91CF["刷新间隔毫秒"], ____onBoss_8840_6761_5237_65B0Tick)
end
local function _____505C_6B62Boss_8840_6761_5237_65B0_5982_679C_7A7A_95F2()
    if _____8840_6761_5237_65B0_56DE_8C03ID == 0 then
        return
    end
    local states = _____83B7_53D6_5168_90E8Boss_8840_6761_5F31_70B9_97E7_6027_8FD0_884C_72B6_6001()
    do
        local i = 0
        while i < #states do
            if states[i + 1]["是否血条已注册"] and not states[i + 1]["是否已结束"] then
                return
            end
            i = i + 1
        end
    end
    removePeriodicCallback(_____8840_6761_5237_65B0_56DE_8C03ID)
    _____8840_6761_5237_65B0_56DE_8C03ID = 0
end
local function _____521B_5EFABoss_8840_6761_5E27_7EC4(state)
    local gameUI = DzGetGameUI()
    state["血条Frame"] = DzCreateFrameByTagName(
        "SPRITE",
        "BossHealthBar",
        gameUI,
        "template",
        0
    )
    DzFrameSetModel(state["血条Frame"], ____Boss_8840_6761UI_5E38_91CF["血条模型"], 0, 0)
    DzFrameSetAnimate(state["血条Frame"], 0, true)
    DzFrameSetPoint(
        state["血条Frame"],
        ____Boss_8840_6761UI_5E38_91CF["锚点中心"],
        gameUI,
        ____Boss_8840_6761UI_5E38_91CF["锚点中心"],
        ____Boss_8840_6761UI_5E38_91CF["血条X"],
        ____Boss_8840_6761UI_5E38_91CF["血条Y"]
    )
    state["损失血条Frame"] = DzCreateFrameByTagName(
        "SPRITE",
        "BossLostHealthBar",
        state["血条Frame"],
        "template",
        0
    )
    DzFrameSetModel(state["损失血条Frame"], ____Boss_8840_6761UI_5E38_91CF["损失血条模型"], 0, 0)
    DzFrameSetAnimate(state["损失血条Frame"], 0, false)
    DzFrameSetPoint(
        state["损失血条Frame"],
        ____Boss_8840_6761UI_5E38_91CF["锚点中心"],
        gameUI,
        ____Boss_8840_6761UI_5E38_91CF["锚点中心"],
        ____Boss_8840_6761UI_5E38_91CF["血条X"],
        ____Boss_8840_6761UI_5E38_91CF["血条Y"]
    )
    DzFrameSetPriority(state["损失血条Frame"], 2)
    state["头像Frame"] = DzCreateFrameByTagName(
        "BACKDROP",
        "BossHealthPortrait",
        state["血条Frame"],
        "UI_BACKDROP_5",
        0
    )
    DzFrameSetTexture(
        state["头像Frame"],
        _____53D6Boss_5934_50CF_8DEF_5F84(state["Boss单位"]),
        0
    )
    DzFrameSetPoint(
        state["头像Frame"],
        ____Boss_8840_6761UI_5E38_91CF["锚点右下"],
        state["血条Frame"],
        ____Boss_8840_6761UI_5E38_91CF["锚点左下"],
        ____Boss_8840_6761UI_5E38_91CF["头像偏移X"],
        ____Boss_8840_6761UI_5E38_91CF["头像偏移Y"]
    )
    DzFrameSetSize(state["头像Frame"], ____Boss_8840_6761UI_5E38_91CF["头像宽"], ____Boss_8840_6761UI_5E38_91CF["头像高"])
    state["血量文本Frame"] = DzCreateFrameByTagName(
        "TEXT",
        "BossHealthText",
        gameUI,
        "UI_TEXT_10",
        0
    )
    DzFrameSetAbsolutePoint(state["血量文本Frame"], ____Boss_8840_6761UI_5E38_91CF["锚点中心"], ____Boss_8840_6761UI_5E38_91CF["血量文本X"], ____Boss_8840_6761UI_5E38_91CF["血量文本Y"])
    state["护盾框Frame"] = DzCreateFrameByTagName(
        "BACKDROP",
        "BossShieldBarBg",
        state["血条Frame"],
        "template",
        0
    )
    DzFrameSetAlpha(state["护盾框Frame"], ____Boss_8840_6761UI_5E38_91CF["护盾框透明度"])
    DzFrameSetTexture(state["护盾框Frame"], ____Boss_8840_6761UI_5E38_91CF["护盾底图"], 0)
    DzFrameSetAbsolutePoint(state["护盾框Frame"], ____Boss_8840_6761UI_5E38_91CF["锚点中心"], ____Boss_8840_6761UI_5E38_91CF["护盾框X"], ____Boss_8840_6761UI_5E38_91CF["护盾框Y"])
    DzFrameSetSize(state["护盾框Frame"], ____Boss_8840_6761UI_5E38_91CF["护盾框宽"], ____Boss_8840_6761UI_5E38_91CF["护盾框高"])
    state["护盾填充Frame"] = DzCreateFrameByTagName(
        "BACKDROP",
        "BossShieldBarFill",
        state["护盾框Frame"],
        "template",
        0
    )
    DzFrameSetTexture(state["护盾填充Frame"], ____Boss_8840_6761UI_5E38_91CF["护盾填充图"], 0)
    DzFrameSetAbsolutePoint(state["护盾填充Frame"], ____Boss_8840_6761UI_5E38_91CF["锚点中心"], ____Boss_8840_6761UI_5E38_91CF["护盾填充基础X"], ____Boss_8840_6761UI_5E38_91CF["护盾填充Y"])
    DzFrameSetSize(state["护盾填充Frame"], ____Boss_8840_6761UI_5E38_91CF["护盾填充显示宽"], ____Boss_8840_6761UI_5E38_91CF["护盾填充高"])
    _____663E_793A_8840_6761_5E27_7EC4(state, true)
end
____exports["注册Boss血条UI"] = function(state)
    if state["是否已结束"] or state["是否血条已注册"] then
        return
    end
    _____521B_5EFABoss_8840_6761_5E27_7EC4(state)
    state["是否血条已注册"] = true
    _____5237_65B0Boss_8840_6761UI(state)
    _____786E_4FDDBoss_8840_6761_5237_65B0()
end
____exports["注销Boss血条UI"] = function(state)
    if not state["是否血条已注册"] then
        return
    end
    _____9500_6BC1_5E27(state["护盾填充Frame"])
    _____9500_6BC1_5E27(state["护盾框Frame"])
    _____9500_6BC1_5E27(state["血量文本Frame"])
    _____9500_6BC1_5E27(state["头像Frame"])
    _____9500_6BC1_5E27(state["损失血条Frame"])
    _____9500_6BC1_5E27(state["血条Frame"])
    state["护盾填充Frame"] = 0
    state["护盾框Frame"] = 0
    state["血量文本Frame"] = 0
    state["头像Frame"] = 0
    state["损失血条Frame"] = 0
    state["血条Frame"] = 0
    state["是否血条已注册"] = false
    _____505C_6B62Boss_8840_6761_5237_65B0_5982_679C_7A7A_95F2()
end
return ____exports

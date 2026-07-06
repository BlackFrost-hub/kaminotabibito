--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____521B_5EFA_63A7_5236_53F0_906E_7F69, DzCreateFrameByTagName, DzGetGameUI, DzFrameSetSize, DzFrameSetPoint, DzFrameSetTexture, DzFrameSetPriority, DzFrameShow, DzFrameSetIgnoreTrackEvents, _____63A7_5236_53F0_906E_7F69_5E27
local ____00_FF0E_5E38_91CF = require("系统.09．表现系统.13．单位头顶血条.00．常量")
local _____8840_6761_5C3A_5BF8 = ____00_FF0E_5E38_91CF["血条尺寸"]
local _____8840_6761_5C42_7EA7 = ____00_FF0E_5E38_91CF["血条层级"]
local _____8840_6761_8D44_6E90 = ____00_FF0E_5E38_91CF["血条资源"]
function _____521B_5EFA_63A7_5236_53F0_906E_7F69(_____7236_7EA7)
    if _____63A7_5236_53F0_906E_7F69_5E27 ~= 0 then
        return
    end
    _____63A7_5236_53F0_906E_7F69_5E27 = DzCreateFrameByTagName(
        "BACKDROP",
        "UnitHeadHealthBarConsoleMask",
        _____7236_7EA7,
        "",
        0
    )
    if _____63A7_5236_53F0_906E_7F69_5E27 == 0 then
        return
    end
    DzFrameSetTexture(_____63A7_5236_53F0_906E_7F69_5E27, "Textures\\Black32.blp", 0)
    DzFrameSetSize(_____63A7_5236_53F0_906E_7F69_5E27, _____8840_6761_5C3A_5BF8["控制台遮罩宽"], _____8840_6761_5C3A_5BF8["控制台遮罩高"])
    DzFrameSetPoint(
        _____63A7_5236_53F0_906E_7F69_5E27,
        6,
        DzGetGameUI(),
        6,
        0,
        0
    )
    DzFrameSetPriority(_____63A7_5236_53F0_906E_7F69_5E27, _____8840_6761_5C42_7EA7["控制台遮罩"])
    DzFrameSetIgnoreTrackEvents(_____63A7_5236_53F0_906E_7F69_5E27, true)
    DzFrameShow(_____63A7_5236_53F0_906E_7F69_5E27, true)
end
local japi = require("jass.japi")
DzCreateFrameByTagName = japi.DzCreateFrameByTagName
DzGetGameUI = japi.DzGetGameUI
local DzFrameGetLowerLevelFrame = japi.DzFrameGetLowerLevelFrame
DzFrameSetSize = japi.DzFrameSetSize
DzFrameSetPoint = japi.DzFrameSetPoint
DzFrameSetTexture = japi.DzFrameSetTexture
DzFrameSetPriority = japi.DzFrameSetPriority
local DzFrameSetText = japi.DzFrameSetText
local DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment
local DzFrameSetTextColor = japi.DzFrameSetTextColor
local DzFrameSetFont = japi.DzFrameSetFont
DzFrameShow = japi.DzFrameShow
DzFrameSetIgnoreTrackEvents = japi.DzFrameSetIgnoreTrackEvents
local _____70B9_4E2D = 4
local _____8840_6761_5E95_5C42_5E27 = 0
_____63A7_5236_53F0_906E_7F69_5E27 = 0
local function _____53D6_8840_6761_7236_5E27()
    if _____8840_6761_5E95_5C42_5E27 ~= 0 then
        return _____8840_6761_5E95_5C42_5E27
    end
    local lower = DzFrameGetLowerLevelFrame()
    if lower ~= nil and lower ~= 0 then
        _____8840_6761_5E95_5C42_5E27 = DzCreateFrameByTagName(
            "FRAME",
            "UnitHeadHealthBarLayer",
            lower,
            "",
            0
        )
        if _____8840_6761_5E95_5C42_5E27 ~= 0 then
            _____521B_5EFA_63A7_5236_53F0_906E_7F69(_____8840_6761_5E95_5C42_5E27)
            return _____8840_6761_5E95_5C42_5E27
        end
        return lower
    end
    local gameUI = DzGetGameUI()
    return gameUI
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
    return frame
end
____exports["创建单位血条帧组"] = function(_____69FD_4F4D)
    local parent = _____53D6_8840_6761_7236_5E27()
    local suffix = tostring(_____69FD_4F4D)
    local root = _____521B_5EFA_8D34_56FE_5E27("UnitHeadHealthBarRoot_" .. suffix, parent, _____8840_6761_8D44_6E90["底框"], _____8840_6761_5C42_7EA7["根"])
    if root == 0 then
        return nil
    end
    DzFrameSetSize(root, _____8840_6761_5C3A_5BF8["根宽"], _____8840_6761_5C3A_5BF8["根高"])
    local life = _____521B_5EFA_8D34_56FE_5E27("UnitHeadHealthBarLife_" .. suffix, root, _____8840_6761_8D44_6E90["友方生命"], _____8840_6761_5C42_7EA7["生命"])
    local shields = {}
    do
        local i = 0
        while i < _____8840_6761_5C3A_5BF8["最大护盾分段数"] do
            shields[#shields + 1] = _____521B_5EFA_8D34_56FE_5E27(
                (("UnitHeadHealthBarShield_" .. suffix) .. "_") .. tostring(i),
                root,
                _____8840_6761_8D44_6E90["护盾"]["通用"],
                _____8840_6761_5C42_7EA7["护盾"]
            )
            i = i + 1
        end
    end
    local mana = _____521B_5EFA_8D34_56FE_5E27("UnitHeadHealthBarMana_" .. suffix, root, _____8840_6761_8D44_6E90["魔法"], _____8840_6761_5C42_7EA7["魔法"])
    local name = DzCreateFrameByTagName(
        "TEXT",
        "UnitHeadHealthBarName_" .. suffix,
        root,
        "",
        0
    )
    local shieldOk = true
    do
        local i = 0
        while i < #shields do
            if shields[i + 1] == 0 then
                shieldOk = false
            end
            i = i + 1
        end
    end
    if life == 0 or not shieldOk or mana == 0 or name == nil or name == 0 then
        return nil
    end
    DzFrameSetSize(life, _____8840_6761_5C3A_5BF8["内条宽"], _____8840_6761_5C3A_5BF8["生命高"])
    DzFrameSetPoint(
        life,
        0,
        root,
        0,
        _____8840_6761_5C3A_5BF8["内条左偏移"],
        _____8840_6761_5C3A_5BF8["生命Y"]
    )
    do
        local i = 0
        while i < #shields do
            DzFrameSetSize(shields[i + 1], 0, _____8840_6761_5C3A_5BF8["生命高"])
            DzFrameSetPoint(
                shields[i + 1],
                0,
                root,
                0,
                _____8840_6761_5C3A_5BF8["内条左偏移"],
                _____8840_6761_5C3A_5BF8["生命Y"]
            )
            i = i + 1
        end
    end
    DzFrameSetSize(mana, _____8840_6761_5C3A_5BF8["内条宽"], _____8840_6761_5C3A_5BF8["魔法高"])
    DzFrameSetPoint(
        mana,
        0,
        root,
        0,
        _____8840_6761_5C3A_5BF8["内条左偏移"],
        _____8840_6761_5C3A_5BF8["魔法Y"]
    )
    DzFrameSetSize(name, _____8840_6761_5C3A_5BF8["名字宽"], _____8840_6761_5C3A_5BF8["名字高"])
    DzFrameSetPoint(
        name,
        _____70B9_4E2D,
        root,
        _____70B9_4E2D,
        0,
        _____8840_6761_5C3A_5BF8["名字Y"]
    )
    DzFrameSetText(name, "")
    DzFrameSetTextAlignment(name, -1)
    DzFrameSetTextAlignment(name, 18)
    DzFrameSetTextColor(
        name,
        255,
        238,
        190,
        255
    )
    DzFrameSetFont(name, "UI\\unit_name_zcool_qingke.ttf", 0.0115, 0)
    DzFrameSetPriority(name, _____8840_6761_5C42_7EA7["名字"])
    DzFrameSetIgnoreTrackEvents(name, true)
    DzFrameShow(root, false)
    DzFrameShow(life, true)
    do
        local i = 0
        while i < #shields do
            DzFrameShow(shields[i + 1], false)
            i = i + 1
        end
    end
    DzFrameShow(mana, false)
    DzFrameShow(name, false)
    return {
        ["槽位"] = _____69FD_4F4D,
        root = root,
        life = life,
        shields = shields,
        mana = mana,
        name = name
    }
end
return ____exports

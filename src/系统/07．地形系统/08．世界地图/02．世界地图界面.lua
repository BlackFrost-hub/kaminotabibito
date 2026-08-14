--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E16_754C_5730_56FE_5730_70B9_914D_7F6E = require("系统.07．地形系统.08．世界地图.01．世界地图地点配置")
local _____4E16_754C_5730_56FE_5730_70B9_914D_7F6E_8868 = ____01_FF0E_4E16_754C_5730_56FE_5730_70B9_914D_7F6E["世界地图地点配置表"]
local _____4E16_754C_5730_56FE_9ED8_8BA4_672A_77E5_56FE_6807 = ____01_FF0E_4E16_754C_5730_56FE_5730_70B9_914D_7F6E["世界地图默认未知图标"]
---
-- @noSelfInFile
local japi = require("jass.japi")
local DzGetGameUI = japi.DzGetGameUI
local DzCreateFrameByTagName = japi.DzCreateFrameByTagName
local DzFrameSetTexture = japi.DzFrameSetTexture
local DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint
local DzFrameSetPoint = japi.DzFrameSetPoint
local DzFrameSetSize = japi.DzFrameSetSize
local DzFrameShow = japi.DzFrameShow
local DzFrameSetText = japi.DzFrameSetText
local DzFrameSetPriority = japi.DzFrameSetPriority
local DzFrameSetFont = japi.DzFrameSetFont
local _____4E2D_5FC3_951A_70B9 = 4
____exports["世界地图帧"] = {
    ["入口图标"] = 0,
    ["入口提示"] = 0,
    ["放大图标"] = 0,
    ["地图根帧"] = 0,
    ["地点帧组表"] = {}
}
local _____4E16_754C_5730_56FE_754C_9762_5DF2_521D_59CB_5316 = false
local function _____521B_5EFA_5165_53E3_56FE_6807(_____6E38_620F_754C_9762)
    local _____5165_53E3_56FE_6807 = DzCreateFrameByTagName(
        "BACKDROP",
        "name",
        _____6E38_620F_754C_9762,
        "template",
        0
    )
    DzFrameSetTexture(_____5165_53E3_56FE_6807, "war3mapImported\\worldmap.tga", 0)
    DzFrameSetAbsolutePoint(_____5165_53E3_56FE_6807, _____4E2D_5FC3_951A_70B9, 0.562708, 0.1552308)
    DzFrameSetSize(_____5165_53E3_56FE_6807, 0.04, 0.025)
    DzFrameShow(_____5165_53E3_56FE_6807, true)
    ____exports["世界地图帧"]["入口图标"] = _____5165_53E3_56FE_6807
    local _____5165_53E3_63D0_793A = DzCreateFrameByTagName(
        "TEXT",
        "主线任务提示文本",
        _____5165_53E3_56FE_6807,
        "template",
        0
    )
    DzFrameSetAbsolutePoint(_____5165_53E3_63D0_793A, _____4E2D_5FC3_951A_70B9, 0.5463336, 0.1555134)
    DzFrameSetText(_____5165_53E3_63D0_793A, "M")
    ____exports["世界地图帧"]["入口提示"] = _____5165_53E3_63D0_793A
    local _____653E_5927_56FE_6807 = DzCreateFrameByTagName(
        "BACKDROP",
        "name",
        _____6E38_620F_754C_9762,
        "template",
        0
    )
    DzFrameSetTexture(_____653E_5927_56FE_6807, "war3mapImported\\worldmap.tga", 0)
    DzFrameSetAbsolutePoint(_____653E_5927_56FE_6807, _____4E2D_5FC3_951A_70B9, 0.562708, 0.1552308)
    DzFrameSetSize(_____653E_5927_56FE_6807, 0.05, 0.03125)
    DzFrameShow(_____653E_5927_56FE_6807, false)
    ____exports["世界地图帧"]["放大图标"] = _____653E_5927_56FE_6807
end
local function _____521B_5EFA_5730_56FE_5E95_56FE(_____5730_56FE_6839_5E27)
    do
        local _____5E8F_53F7 = 1
        while _____5E8F_53F7 <= 8 do
            local _____5E95_56FE = DzCreateFrameByTagName(
                "BACKDROP",
                "name",
                _____5730_56FE_6839_5E27,
                "template",
                0
            )
            DzFrameSetTexture(
                _____5E95_56FE,
                ("war3mapImported\\map0" .. tostring(_____5E8F_53F7)) .. ".blp",
                0
            )
            if _____5E8F_53F7 <= 4 then
                DzFrameSetAbsolutePoint(_____5E95_56FE, _____4E2D_5FC3_951A_70B9, -0.1 + 0.2 * _____5E8F_53F7, 0.4249764)
            else
                DzFrameSetAbsolutePoint(_____5E95_56FE, _____4E2D_5FC3_951A_70B9, -0.9 + 0.2 * _____5E8F_53F7, 0.1422246)
            end
            DzFrameSetSize(_____5E95_56FE, 0.2, 0.2844486)
            _____5E8F_53F7 = _____5E8F_53F7 + 1
        end
    end
end
local function _____521B_5EFA_5730_70B9_5E27(_____5730_56FE_6839_5E27, _____914D_7F6E_7D22_5F15)
    local _____914D_7F6E = _____4E16_754C_5730_56FE_5730_70B9_914D_7F6E_8868[_____914D_7F6E_7D22_5F15 + 1]
    local _____6309_94AE = DzCreateFrameByTagName(
        "GLUETEXTBUTTON",
        "主线按钮",
        _____5730_56FE_6839_5E27,
        "template",
        0
    )
    DzFrameSetSize(_____6309_94AE, 0.03, 0.03)
    DzFrameSetAbsolutePoint(_____6309_94AE, _____4E2D_5FC3_951A_70B9, _____914D_7F6E["按钮X"], _____914D_7F6E["按钮Y"])
    local _____6587_672C_6846 = DzCreateFrameByTagName(
        "BACKDROP",
        "主线任务文本框",
        _____6309_94AE,
        "template",
        0
    )
    DzFrameSetTexture(_____6587_672C_6846, "war3mapImported\\wenbenkuang2.blp", 0)
    DzFrameSetSize(_____6587_672C_6846, 0.12, 0.2)
    DzFrameSetPoint(
        _____6587_672C_6846,
        _____4E2D_5FC3_951A_70B9,
        _____6309_94AE,
        _____4E2D_5FC3_951A_70B9,
        0.05,
        0.05
    )
    DzFrameShow(_____6587_672C_6846, false)
    DzFrameSetPriority(_____6587_672C_6846, 1)
    local _____63D0_793A_6587_672C = DzCreateFrameByTagName(
        "TEXT",
        "主线任务提示文本",
        _____6587_672C_6846,
        "template",
        0
    )
    DzFrameSetPoint(
        _____63D0_793A_6587_672C,
        _____4E2D_5FC3_951A_70B9,
        _____6587_672C_6846,
        _____4E2D_5FC3_951A_70B9,
        0,
        0.02
    )
    DzFrameSetText(_____63D0_793A_6587_672C, _____914D_7F6E["初始提示"])
    local _____56FE_6807 = DzCreateFrameByTagName(
        "BACKDROP",
        "name",
        _____6587_672C_6846,
        "template",
        0
    )
    DzFrameSetTexture(_____56FE_6807, _____914D_7F6E["初始图标"] or _____4E16_754C_5730_56FE_9ED8_8BA4_672A_77E5_56FE_6807, 0)
    DzFrameSetPoint(
        _____56FE_6807,
        _____4E2D_5FC3_951A_70B9,
        _____6309_94AE,
        _____4E2D_5FC3_951A_70B9,
        0.015,
        0.12
    )
    DzFrameSetSize(_____56FE_6807, 0.02, 0.02)
    local _____5F53_524D_4F4D_7F6E_7BAD_5934 = DzCreateFrameByTagName(
        "BACKDROP",
        "name",
        _____6309_94AE,
        "template",
        0
    )
    DzFrameSetTexture(_____5F53_524D_4F4D_7F6E_7BAD_5934, "war3mapImported\\TB-jiantouweizhi.tga", 0)
    DzFrameSetSize(_____5F53_524D_4F4D_7F6E_7BAD_5934, 0.0135, 0.0191)
    DzFrameShow(_____5F53_524D_4F4D_7F6E_7BAD_5934, false)
    DzFrameSetPriority(_____5F53_524D_4F4D_7F6E_7BAD_5934, 0)
    if _____914D_7F6E["箭头X"] ~= nil and _____914D_7F6E["箭头Y"] ~= nil then
        DzFrameSetAbsolutePoint(_____5F53_524D_4F4D_7F6E_7BAD_5934, _____4E2D_5FC3_951A_70B9, _____914D_7F6E["箭头X"], _____914D_7F6E["箭头Y"])
    end
    return {
        ["按钮"] = _____6309_94AE,
        ["文本框"] = _____6587_672C_6846,
        ["提示文本"] = _____63D0_793A_6587_672C,
        ["图标"] = _____56FE_6807,
        ["当前位置箭头"] = _____5F53_524D_4F4D_7F6E_7BAD_5934
    }
end
____exports["获取世界地图地点帧"] = function(_____5730_70B9ID)
    if _____5730_70B9ID <= 0 then
        return nil
    end
    return ____exports["世界地图帧"]["地点帧组表"][_____5730_70B9ID]
end
____exports["更新世界地图地点显示"] = function(_____5730_70B9ID, _____63D0_793A, _____56FE_6807_8DEF_5F84)
    local _____5730_70B9_5E27 = ____exports["获取世界地图地点帧"](_____5730_70B9ID)
    if _____5730_70B9_5E27 == nil then
        return
    end
    DzFrameSetText(_____5730_70B9_5E27["提示文本"], _____63D0_793A)
    DzFrameSetTexture(_____5730_70B9_5E27["图标"], _____56FE_6807_8DEF_5F84, 0)
end
____exports["初始化世界地图界面"] = function()
    if _____4E16_754C_5730_56FE_754C_9762_5DF2_521D_59CB_5316 then
        return
    end
    _____4E16_754C_5730_56FE_754C_9762_5DF2_521D_59CB_5316 = true
    local _____6E38_620F_754C_9762 = DzGetGameUI()
    _____521B_5EFA_5165_53E3_56FE_6807(_____6E38_620F_754C_9762)
    local _____5730_56FE_6839_5E27 = DzCreateFrameByTagName(
        "BACKDROP",
        "name",
        _____6E38_620F_754C_9762,
        "template",
        0
    )
    ____exports["世界地图帧"]["地图根帧"] = _____5730_56FE_6839_5E27
    DzFrameShow(_____5730_56FE_6839_5E27, true)
    DzFrameShow(_____5730_56FE_6839_5E27, false)
    local _____5730_56FE_63D0_793A = DzCreateFrameByTagName(
        "TEXT",
        "文本A",
        _____5730_56FE_6839_5E27,
        "template",
        0
    )
    DzFrameSetAbsolutePoint(_____5730_56FE_63D0_793A, _____4E2D_5FC3_951A_70B9, 0.4, 0.5)
    DzFrameSetText(_____5730_56FE_63D0_793A, "|cffff0000地图提示|r|cff000000：脱战状态下，『双击已激活的城镇』可以快速传送！|r")
    DzFrameSetPriority(_____5730_56FE_63D0_793A, 1)
    DzFrameSetFont(_____5730_56FE_63D0_793A, "war3mapImported\\uizt.ttf", 20, 0)
    _____521B_5EFA_5730_56FE_5E95_56FE(_____5730_56FE_6839_5E27)
    do
        local _____914D_7F6E_7D22_5F15 = 0
        while _____914D_7F6E_7D22_5F15 < #_____4E16_754C_5730_56FE_5730_70B9_914D_7F6E_8868 do
            local ____exports__4E16_754C_5730_56FE_5E27__5730_70B9_5E27_7EC4_8868_0 = ____exports["世界地图帧"]["地点帧组表"]
            ____exports__4E16_754C_5730_56FE_5E27__5730_70B9_5E27_7EC4_8868_0[#____exports__4E16_754C_5730_56FE_5E27__5730_70B9_5E27_7EC4_8868_0 + 1] = _____521B_5EFA_5730_70B9_5E27(_____5730_56FE_6839_5E27, _____914D_7F6E_7D22_5F15)
            _____914D_7F6E_7D22_5F15 = _____914D_7F6E_7D22_5F15 + 1
        end
    end
end
return ____exports

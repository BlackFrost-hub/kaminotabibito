--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local DzFrameShow, _____541F_5531_6761UI_5B9E_4F8B
____exports["隐藏吟唱条UI"] = function()
    if _____541F_5531_6761UI_5B9E_4F8B == nil then
        return
    end
    DzFrameShow(_____541F_5531_6761UI_5B9E_4F8B["前景"], false)
    DzFrameShow(_____541F_5531_6761UI_5B9E_4F8B["标题"], false)
    DzFrameShow(_____541F_5531_6761UI_5B9E_4F8B["进度"], false)
    DzFrameShow(_____541F_5531_6761UI_5B9E_4F8B["分隔符"], false)
    DzFrameShow(_____541F_5531_6761UI_5B9E_4F8B["时间"], false)
    DzFrameShow(_____541F_5531_6761UI_5B9E_4F8B["提示"], false)
end
--- 吟唱条系统 - UI创建（单壳复用）
local japi = require("jass.japi")
local _____5E38_91CF = require("系统.09．表现系统.08．吟唱条.00．常量定义")
local ____require_result_0 = require("系统.09．表现系统.08．吟唱条.00．常量定义")
local _____83B7_53D6_524D_666F_6A21_578B = ____require_result_0["获取前景模型"]
local _____83B7_53D6_80CC_666F_6A21_578B = ____require_result_0["获取背景模型"]
local DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint
local DzFrameSetPoint = japi.DzFrameSetPoint
local DzFrameSetText = japi.DzFrameSetText
local DzFrameSetModel = japi.DzFrameSetModel
local DzFrameSetAnimate = japi.DzFrameSetAnimate
local DzFrameSetAnimateOffset = japi.DzFrameSetAnimateOffset
local DzFrameSetPriority = japi.DzFrameSetPriority
DzFrameShow = japi.DzFrameShow
local DzGetGameUI = japi.DzGetGameUI
local DzCreateFrameByTagName = japi.DzCreateFrameByTagName
_____541F_5531_6761UI_5B9E_4F8B = nil
local _____951A_70B9TOPLEFT = 0
local _____80CC_666F_5C42_7EA7 = 0
local _____6587_5B57_5C42_7EA7 = 2
local function _____521D_59CB_5316_6587_672C_6846(frame)
    DzFrameSetPriority(frame, _____6587_5B57_5C42_7EA7)
end
____exports["创建吟唱条UI"] = function()
    if _____541F_5531_6761UI_5B9E_4F8B ~= nil then
        return _____541F_5531_6761UI_5B9E_4F8B
    end
    local _____7236_7EA7 = DzGetGameUI()
    local _____524D_666F = DzCreateFrameByTagName(
        "SPRITE",
        _____5E38_91CF["框架名_前景"],
        _____7236_7EA7,
        "template",
        0
    )
    DzFrameSetAbsolutePoint(_____524D_666F, _____5E38_91CF["锚点CENTER"], _____5E38_91CF["UI坐标X"], _____5E38_91CF["UI坐标Y"])
    DzFrameSetAnimate(_____524D_666F, 0, false)
    DzFrameSetAnimateOffset(_____524D_666F, 1)
    local _____80CC_666F = DzCreateFrameByTagName(
        "SPRITE",
        _____5E38_91CF["框架名_背景"],
        _____524D_666F,
        "template",
        0
    )
    DzFrameSetAbsolutePoint(_____80CC_666F, _____5E38_91CF["锚点CENTER"], _____5E38_91CF["UI坐标X"], _____5E38_91CF["UI坐标Y"])
    DzFrameSetPriority(_____80CC_666F, _____80CC_666F_5C42_7EA7)
    local _____6807_9898 = DzCreateFrameByTagName(
        "TEXT",
        _____5E38_91CF["框架名_标题"],
        _____524D_666F,
        "template",
        0
    )
    DzFrameSetPoint(
        _____6807_9898,
        _____5E38_91CF["锚点CENTER"],
        _____524D_666F,
        _____5E38_91CF["锚点CENTER"],
        -0.148,
        0.02
    )
    DzFrameSetText(_____6807_9898, _____5E38_91CF["默认标题文本"])
    _____521D_59CB_5316_6587_672C_6846(_____6807_9898)
    local _____8FDB_5EA6 = DzCreateFrameByTagName(
        "TEXT",
        _____5E38_91CF["框架名_进度"],
        _____524D_666F,
        "template",
        0
    )
    DzFrameSetPoint(
        _____8FDB_5EA6,
        _____5E38_91CF["锚点CENTER"],
        _____524D_666F,
        _____5E38_91CF["锚点CENTER"],
        -0.162,
        0.005
    )
    _____521D_59CB_5316_6587_672C_6846(_____8FDB_5EA6)
    local _____5206_9694_7B26 = DzCreateFrameByTagName(
        "TEXT",
        _____5E38_91CF["框架名_分隔符"],
        _____524D_666F,
        "template",
        0
    )
    DzFrameSetPoint(
        _____5206_9694_7B26,
        _____5E38_91CF["锚点CENTER"],
        _____524D_666F,
        _____5E38_91CF["锚点CENTER"],
        -0.15,
        0.005
    )
    DzFrameSetText(_____5206_9694_7B26, _____5E38_91CF["分隔符文本"])
    _____521D_59CB_5316_6587_672C_6846(_____5206_9694_7B26)
    local _____65F6_95F4 = DzCreateFrameByTagName(
        "TEXT",
        _____5E38_91CF["框架名_时间"],
        _____524D_666F,
        "template",
        0
    )
    DzFrameSetPoint(
        _____65F6_95F4,
        _____5E38_91CF["锚点CENTER"],
        _____524D_666F,
        _____5E38_91CF["锚点CENTER"],
        -0.138,
        0.005
    )
    _____521D_59CB_5316_6587_672C_6846(_____65F6_95F4)
    local _____63D0_793A = DzCreateFrameByTagName(
        "TEXT",
        _____5E38_91CF["框架名_提示"],
        _____524D_666F,
        "template",
        0
    )
    DzFrameSetPoint(
        _____63D0_793A,
        _____5E38_91CF["锚点CENTER"],
        _____524D_666F,
        _____951A_70B9TOPLEFT,
        -0.12,
        0.005
    )
    DzFrameSetText(_____63D0_793A, _____5E38_91CF["默认提示文本"])
    _____521D_59CB_5316_6587_672C_6846(_____63D0_793A)
    _____541F_5531_6761UI_5B9E_4F8B = {
        ["前景"] = _____524D_666F,
        ["背景"] = _____80CC_666F,
        ["标题"] = _____6807_9898,
        ["进度"] = _____8FDB_5EA6,
        ["分隔符"] = _____5206_9694_7B26,
        ["时间"] = _____65F6_95F4,
        ["提示"] = _____63D0_793A
    }
    ____exports["隐藏吟唱条UI"]()
    return _____541F_5531_6761UI_5B9E_4F8B
end
____exports["显示吟唱条UI"] = function()
    if _____541F_5531_6761UI_5B9E_4F8B == nil then
        ____exports["创建吟唱条UI"]()
    end
    if _____541F_5531_6761UI_5B9E_4F8B ~= nil then
        DzFrameShow(_____541F_5531_6761UI_5B9E_4F8B["前景"], true)
        DzFrameShow(_____541F_5531_6761UI_5B9E_4F8B["背景"], true)
        DzFrameShow(_____541F_5531_6761UI_5B9E_4F8B["标题"], true)
        DzFrameShow(_____541F_5531_6761UI_5B9E_4F8B["进度"], true)
        DzFrameShow(_____541F_5531_6761UI_5B9E_4F8B["分隔符"], true)
        DzFrameShow(_____541F_5531_6761UI_5B9E_4F8B["时间"], true)
        DzFrameShow(_____541F_5531_6761UI_5B9E_4F8B["提示"], true)
    end
end
____exports["更新吟唱条模型"] = function(_____989C_8272ID)
    if _____541F_5531_6761UI_5B9E_4F8B == nil then
        return
    end
    DzFrameSetModel(
        _____541F_5531_6761UI_5B9E_4F8B["前景"],
        _____83B7_53D6_524D_666F_6A21_578B(_____989C_8272ID),
        0,
        0
    )
    DzFrameSetModel(
        _____541F_5531_6761UI_5B9E_4F8B["背景"],
        _____83B7_53D6_80CC_666F_6A21_578B(_____989C_8272ID),
        0,
        0
    )
    DzFrameSetAbsolutePoint(_____541F_5531_6761UI_5B9E_4F8B["前景"], _____5E38_91CF["锚点CENTER"], _____5E38_91CF["UI坐标X"], _____5E38_91CF["UI坐标Y"])
    DzFrameSetAbsolutePoint(_____541F_5531_6761UI_5B9E_4F8B["背景"], _____5E38_91CF["锚点CENTER"], _____5E38_91CF["UI坐标X"], _____5E38_91CF["UI坐标Y"])
    DzFrameSetPriority(_____541F_5531_6761UI_5B9E_4F8B["背景"], _____80CC_666F_5C42_7EA7)
    DzFrameSetAnimate(_____541F_5531_6761UI_5B9E_4F8B["前景"], 0, false)
    DzFrameSetAnimateOffset(_____541F_5531_6761UI_5B9E_4F8B["前景"], 0.9)
end
____exports["更新吟唱条文本"] = function(_____6807_9898_6587_672C, _____63D0_793A_6587_672C)
    if _____541F_5531_6761UI_5B9E_4F8B == nil then
        return
    end
    DzFrameSetText(_____541F_5531_6761UI_5B9E_4F8B["标题"], _____6807_9898_6587_672C)
    DzFrameSetText(_____541F_5531_6761UI_5B9E_4F8B["提示"], _____63D0_793A_6587_672C)
end
____exports["更新吟唱条数值"] = function(_____5DF2_8FC7_79D2, _____5269_4F59_79D2)
    if _____541F_5531_6761UI_5B9E_4F8B == nil then
        return
    end
    DzFrameSetText(_____541F_5531_6761UI_5B9E_4F8B["进度"], _____5DF2_8FC7_79D2)
    DzFrameSetText(_____541F_5531_6761UI_5B9E_4F8B["时间"], _____5269_4F59_79D2)
end
____exports["设置吟唱条动画进度"] = function(_____8FDB_5EA6)
    if _____541F_5531_6761UI_5B9E_4F8B == nil then
        return
    end
    if _____8FDB_5EA6 < 0 then
        _____8FDB_5EA6 = 0
    end
    if _____8FDB_5EA6 > 1 then
        _____8FDB_5EA6 = 1
    end
    DzFrameSetAnimateOffset(_____541F_5531_6761UI_5B9E_4F8B["前景"], 1 - _____8FDB_5EA6)
end
return ____exports

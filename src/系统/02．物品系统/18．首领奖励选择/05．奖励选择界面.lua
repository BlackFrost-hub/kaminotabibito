--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5E27_521B_5EFA = require("系统.09．表现系统.01．UI工具.01．帧创建")
local _____521B_5EFA_5E27 = ____01_FF0E_5E27_521B_5EFA.createFrame
local ____00_FF0E_7C7B_578B_5B9A_4E49 = require("系统.09．表现系统.01．UI工具.00．类型定义")
local FramePoint = ____00_FF0E_7C7B_578B_5B9A_4E49.FramePoint
local FrameType = ____00_FF0E_7C7B_578B_5B9A_4E49.FrameType
local ____02_FF0E_4F4D_7F6E_5C3A_5BF8 = require("系统.09．表现系统.01．UI工具.02．位置尺寸")
local _____8BBE_7F6E_5E27_4F4D_7F6E = ____02_FF0E_4F4D_7F6E_5C3A_5BF8.setFramePosition
local _____8BBE_7F6E_5E27_5C3A_5BF8 = ____02_FF0E_4F4D_7F6E_5C3A_5BF8.setFrameSize
local ____03_FF0E_5185_5BB9_8BBE_7F6E = require("系统.09．表现系统.01．UI工具.03．内容设置")
local _____8BBE_7F6E_5E27_8D34_56FE = ____03_FF0E_5185_5BB9_8BBE_7F6E.setFrameTexture
local ____05_FF0E_5E27_63A7_5236 = require("系统.09．表现系统.01．UI工具.05．帧控制")
local _____83B7_53D6_6E38_620FUI_5E27 = ____05_FF0E_5E27_63A7_5236.getGameUIFrame
local _____9690_85CF_5E27 = ____05_FF0E_5E27_63A7_5236.hideFrame
local _____663E_793A_5E27 = ____05_FF0E_5E27_63A7_5236.showFrame
local _____9996_9886_5956_52B1_9762_677F_8D34_56FE = "UI\\BossReward\\boss_reward_panel_v2.tga"
local _____9996_9886_5956_52B1_9762_677F_5BBD_5EA6 = 0.58
local _____9996_9886_5956_52B1_9762_677F_9AD8_5EA6 = 0.326
local _____9996_9886_5956_52B1_9762_677F_4E2D_5FC3X = 0.4
local _____9996_9886_5956_52B1_9762_677F_4E2D_5FC3Y = 0.34
local _____9996_9886_5956_52B1_9762_677F_5E27 = 0
local _____9996_9886_5956_52B1_754C_9762_5DF2_521D_59CB_5316 = false
local function _____521B_5EFA_9996_9886_5956_52B1_9762_677F_515C_5E95(self)
    local _____7236_5E27 = _____83B7_53D6_6E38_620FUI_5E27(nil)
    return _____521B_5EFA_5E27(nil, {
        type = FrameType.BACKDROP,
        name = "BossRewardPanelBackdropFallback",
        parent = _____7236_5E27,
        template = "template",
        id = 0,
        visible = false
    })
end
____exports["初始化首领奖励选择界面"] = function()
    if _____9996_9886_5956_52B1_754C_9762_5DF2_521D_59CB_5316 then
        return
    end
    _____9996_9886_5956_52B1_754C_9762_5DF2_521D_59CB_5316 = true
    local _____9762_677F = _____521B_5EFA_9996_9886_5956_52B1_9762_677F_515C_5E95(nil)
    if _____9762_677F == nil or _____9762_677F == 0 then
        return
    end
    _____9996_9886_5956_52B1_9762_677F_5E27 = _____9762_677F
    _____8BBE_7F6E_5E27_5C3A_5BF8(nil, _____9762_677F, {width = _____9996_9886_5956_52B1_9762_677F_5BBD_5EA6, height = _____9996_9886_5956_52B1_9762_677F_9AD8_5EA6})
    _____8BBE_7F6E_5E27_4F4D_7F6E(nil, _____9762_677F, {point = FramePoint.CENTER, x = _____9996_9886_5956_52B1_9762_677F_4E2D_5FC3X, y = _____9996_9886_5956_52B1_9762_677F_4E2D_5FC3Y})
    _____8BBE_7F6E_5E27_8D34_56FE(nil, _____9762_677F, _____9996_9886_5956_52B1_9762_677F_8D34_56FE)
    _____9690_85CF_5E27(nil, _____9762_677F)
end
____exports["显示首领奖励选择界面"] = function()
    ____exports["初始化首领奖励选择界面"]()
    if _____9996_9886_5956_52B1_9762_677F_5E27 ~= 0 then
        _____663E_793A_5E27(nil, _____9996_9886_5956_52B1_9762_677F_5E27)
    end
end
____exports["隐藏首领奖励选择界面"] = function()
    if _____9996_9886_5956_52B1_9762_677F_5E27 ~= 0 then
        _____9690_85CF_5E27(nil, _____9996_9886_5956_52B1_9762_677F_5E27)
    end
end
____exports["获取首领奖励面板帧"] = function()
    ____exports["初始化首领奖励选择界面"]()
    return _____9996_9886_5956_52B1_9762_677F_5E27
end
return ____exports

--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.09．表现系统.06．广播提示消息.00．常量定义")
local _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示玩家槽数"]
local _____5E7F_64AD_63D0_793A_9ED8_8BA4_5934_50CF = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示默认头像"]
local ____01_FF0E_5934_50CF_8BFB_53D6 = require("系统.09．表现系统.06．广播提示消息.01．头像读取")
local _____53D6_5355_4F4D_5934_50CF = ____01_FF0E_5934_50CF_8BFB_53D6["取单位头像"]
local ____02_FF0EUI_521B_5EFA = require("系统.09．表现系统.06．广播提示消息.02．UI创建")
local _____521B_5EFA_5168_90E8_5E7F_64AD_63D0_793A_69FD = ____02_FF0EUI_521B_5EFA["创建全部广播提示槽"]
local ____03_FF0E_6D88_606F_961F_5217 = require("系统.09．表现系统.06．广播提示消息.03．消息队列")
local _____521D_59CB_5316_5E7F_64AD_63D0_793A_6D88_606F_72B6_6001 = ____03_FF0E_6D88_606F_961F_5217["初始化广播提示消息状态"]
local _____5165_961F_5934_50CF_63D0_793A = ____03_FF0E_6D88_606F_961F_5217["入队头像提示"]
local ____04_FF0E_52A8_753B_9A71_52A8 = require("系统.09．表现系统.06．广播提示消息.04．动画驱动")
local _____542F_52A8_5E7F_64AD_63D0_793A_52A8_753B_9A71_52A8 = ____04_FF0E_52A8_753B_9A71_52A8["启动广播提示动画驱动"]
local ____on_5E7F_64AD_63D0_793A_6D88_606FTick = ____04_FF0E_52A8_753B_9A71_52A8["on广播提示消息Tick"]
---
-- @noSelfInFile
local jass = require("jass.common")
local GetPlayerId = jass.GetPlayerId
local _____5DF2_521D_59CB_5316_5E7F_64AD_63D0_793A_6D88_606F_7CFB_7EDF = false
local function _____53D6_76EE_6807_73A9_5BB6ID(_____76EE_6807_73A9_5BB6)
    if _____76EE_6807_73A9_5BB6 == nil or _____76EE_6807_73A9_5BB6 == 0 then
        return -1
    end
    local _____73A9_5BB6ID = GetPlayerId(_____76EE_6807_73A9_5BB6)
    if _____73A9_5BB6ID < 0 or _____73A9_5BB6ID >= _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 then
        return -1
    end
    return _____73A9_5BB6ID
end
local function _____53D6_63D0_793A_5934_50CF(_____5934_50CF_8DEF_5F84)
    if _____5934_50CF_8DEF_5F84 == nil or _____5934_50CF_8DEF_5F84 == "" then
        return _____5E7F_64AD_63D0_793A_9ED8_8BA4_5934_50CF
    end
    return _____5934_50CF_8DEF_5F84
end
____exports["初始化广播提示消息系统"] = function()
    if _____5DF2_521D_59CB_5316_5E7F_64AD_63D0_793A_6D88_606F_7CFB_7EDF then
        return
    end
    _____5DF2_521D_59CB_5316_5E7F_64AD_63D0_793A_6D88_606F_7CFB_7EDF = true
    _____521B_5EFA_5168_90E8_5E7F_64AD_63D0_793A_69FD()
    _____521D_59CB_5316_5E7F_64AD_63D0_793A_6D88_606F_72B6_6001()
    _____542F_52A8_5E7F_64AD_63D0_793A_52A8_753B_9A71_52A8()
    ____on_5E7F_64AD_63D0_793A_6D88_606FTick()
end
____exports["发送头像提示给玩家"] = function(_____76EE_6807_73A9_5BB6, _____5934_50CF_8DEF_5F84, _____6587_672C, _____6301_7EED_65F6_95F4)
    ____exports["初始化广播提示消息系统"]()
    local _____73A9_5BB6ID = _____53D6_76EE_6807_73A9_5BB6ID(_____76EE_6807_73A9_5BB6)
    if _____73A9_5BB6ID < 0 then
        return
    end
    _____5165_961F_5934_50CF_63D0_793A(
        _____73A9_5BB6ID,
        _____53D6_63D0_793A_5934_50CF(_____5934_50CF_8DEF_5F84),
        _____6587_672C,
        _____6301_7EED_65F6_95F4
    )
end
____exports["发送单位提示给玩家"] = function(_____76EE_6807_73A9_5BB6, _____6765_6E90_5355_4F4D, _____6587_672C, _____6301_7EED_65F6_95F4)
    ____exports["初始化广播提示消息系统"]()
    local _____73A9_5BB6ID = _____53D6_76EE_6807_73A9_5BB6ID(_____76EE_6807_73A9_5BB6)
    if _____73A9_5BB6ID < 0 then
        return
    end
    _____5165_961F_5934_50CF_63D0_793A(
        _____73A9_5BB6ID,
        _____53D6_5355_4F4D_5934_50CF(_____6765_6E90_5355_4F4D),
        _____6587_672C,
        _____6301_7EED_65F6_95F4
    )
end
____exports["广播单位提示"] = function(_____6765_6E90_5355_4F4D, _____6587_672C, _____6301_7EED_65F6_95F4)
    ____exports["初始化广播提示消息系统"]()
    local _____5934_50CF_8DEF_5F84 = _____53D6_5355_4F4D_5934_50CF(_____6765_6E90_5355_4F4D)
    do
        local _____73A9_5BB6ID = 0
        while _____73A9_5BB6ID < _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 do
            _____5165_961F_5934_50CF_63D0_793A(_____73A9_5BB6ID, _____5934_50CF_8DEF_5F84, _____6587_672C, _____6301_7EED_65F6_95F4)
            _____73A9_5BB6ID = _____73A9_5BB6ID + 1
        end
    end
end
return ____exports

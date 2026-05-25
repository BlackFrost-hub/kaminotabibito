--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.07．杂项")
local ModifyGateBJ = ____require_result_0.ModifyGateBJ
local ____require_result_1 = require("lib.扩展函数.物品相关函数.创建物品函数")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_1["创建物品并注册排泄监听"]
local ____require_result_2 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_2["广播单位提示"]
local GetPlayersAll = jass.GetPlayersAll
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local PingMinimap = jass.PingMinimap
local QuestMessageBJ = jass.QuestMessageBJ
local bj_GATEOPERATION_CLOSE = jglobals.bj_GATEOPERATION_CLOSE
local bj_GATEOPERATION_OPEN = jglobals.bj_GATEOPERATION_OPEN
____exports["发送剧情任务消息"] = function(_____53C2_6570)
    QuestMessageBJ(
        GetPlayersAll(),
        _____53C2_6570["消息类型"],
        _____53C2_6570["文本"]
    )
end
____exports["发送剧情小地图信号"] = function(_____53C2_6570)
    PingMinimap(_____53C2_6570.X, _____53C2_6570.Y, _____53C2_6570["持续时间"])
end
____exports["切换剧情大门"] = function(_____53C2_6570)
    local destructable = jglobals[_____53C2_6570["可破坏物全局名"]]
    if destructable == nil or destructable == 0 then
        return
    end
    ModifyGateBJ(_____53C2_6570["开关"] == "打开" and bj_GATEOPERATION_OPEN or bj_GATEOPERATION_CLOSE, destructable)
end
____exports["在触发单位脚下创建剧情物品"] = function(itemTypeId)
    local _____4E0A_4E0B_6587 = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()
    local unit = _____4E0A_4E0B_6587["触发单位"]
    if unit == nil or unit == 0 then
        return
    end
    _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(
        itemTypeId,
        GetUnitX(unit),
        GetUnitY(unit)
    )
end
____exports["发送剧情广播"] = function(_____53C2_6570)
    local _____4E0A_4E0B_6587 = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()
    local ____53C2_6570__6765_6E90_5355_4F4D_3 = _____53C2_6570["来源单位"]
    if ____53C2_6570__6765_6E90_5355_4F4D_3 == nil then
        ____53C2_6570__6765_6E90_5355_4F4D_3 = _____4E0A_4E0B_6587["触发单位"]
    end
    local _____6765_6E90_5355_4F4D = ____53C2_6570__6765_6E90_5355_4F4D_3
    if _____6765_6E90_5355_4F4D == nil or _____6765_6E90_5355_4F4D == 0 then
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____6765_6E90_5355_4F4D, _____53C2_6570["文本"], _____53C2_6570["持续时间"])
end
return ____exports

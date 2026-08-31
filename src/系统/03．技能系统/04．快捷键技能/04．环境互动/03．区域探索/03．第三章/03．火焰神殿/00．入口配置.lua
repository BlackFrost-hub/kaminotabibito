--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心")
local _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_0["注册环境互动调查点"]
local ____require_result_1 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.00．环境互动配置")
local _____73AF_5883_4E92_52A8_88C5_5907_5956_52B1_6982_7387 = ____require_result_1["环境互动装备奖励概率"]
local ____require_result_2 = require("lib.扩展函数.物品相关函数.创建物品函数")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_2["创建物品并注册排泄监听"]
local ____require_result_3 = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具")
local _____89E3_6790_914D_7F6E_5185_90E8ID = ____require_result_3["解析配置内部ID"]
local ____require_result_4 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.43．菲尼克斯尔现身")
local _____662F_5426_5DF2_6B63_5F0F_51FB_8D25_83F2_5C3C_514B_65AF_5C14 = ____require_result_4["是否已正式击败菲尼克斯尔"]
local ____require_result_5 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_5["按名字反查物品ID"]
local ____require_result_6 = require("系统.09．表现系统.06．广播提示消息.index")
local _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6 = ____require_result_6["发送单位提示给玩家"]
local function _____5904_7406_83F2_5C3C_514B_65AF_5C14_6218_540E_6676_6838(_____73A9_5BB6ID, _____82F1_96C4, ______8C03_67E5_70B9)
    if not _____662F_5426_5DF2_6B63_5F0F_51FB_8D25_83F2_5C3C_514B_65AF_5C14() then
        return false
    end
    local _____914D_7F6EID = _____6309_540D_5B57_53CD_67E5_7269_54C1ID("焚羽余烬晶核")
    if _____914D_7F6EID == nil then
        return false
    end
    local _____7269_54C1 = _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(
        _____89E3_6790_914D_7F6E_5185_90E8ID(_____914D_7F6EID),
        jass.GetUnitX(_____82F1_96C4),
        jass.GetUnitY(_____82F1_96C4)
    )
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    jass.UnitAddItem(_____82F1_96C4, _____7269_54C1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        jass.Player(_____73A9_5BB6ID),
        _____82F1_96C4,
        "|cffff6800『焚羽余烬晶核』：|r凤凰消散后的晶体仍在冷热之间缓慢脉动，像是把最后的火焰与冰霜都压进了同一枚核心。|n|cffffff00获得装备：焚羽余烬晶核。|r",
        5200
    )
    return true
end
____exports["注册火焰神殿探索点"] = function()
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "火焰神殿.菲尼克斯尔战后晶核",
        X = 16243.2,
        Y = -3941.4,
        ["一次性"] = true,
        ["一次性奖励概率"] = _____73AF_5883_4E92_52A8_88C5_5907_5956_52B1_6982_7387,
        ["触发前置检查"] = function() return _____662F_5426_5DF2_6B63_5F0F_51FB_8D25_83F2_5C3C_514B_65AF_5C14() end,
        ["触发回调"] = _____5904_7406_83F2_5C3C_514B_65AF_5C14_6218_540E_6676_6838
    })
end
return ____exports

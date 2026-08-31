--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心")
local _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_0["注册环境互动调查点"]
local ____require_result_1 = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具")
local _____89E3_6790_914D_7F6E_5185_90E8ID = ____require_result_1["解析配置内部ID"]
local ____require_result_2 = require("lib.扩展函数.物品相关函数.创建物品函数")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_2["创建物品并注册排泄监听"]
local ____require_result_3 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_3["按名字反查物品ID"]
local ____require_result_4 = require("系统.09．表现系统.06．广播提示消息.index")
local _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6 = ____require_result_4["发送单位提示给玩家"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local UnitAddItem = jass.UnitAddItem
local _____63D0_793A_6301_7EED_6BEB_79D2 = 5200
local function _____589E_52A0_8D44_6E90(_____73A9_5BB6ID, _____72B6_6001, _____6570_91CF)
    local _____73A9_5BB6 = jass.Player(_____73A9_5BB6ID)
    jass.SetPlayerState(
        _____73A9_5BB6,
        _____72B6_6001,
        jass.GetPlayerState(_____73A9_5BB6, _____72B6_6001) + _____6570_91CF
    )
end
local function _____7ED9_4E88_7269_54C1(_____5355_4F4D, _____540D_79F0)
    local _____914D_7F6EID = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____540D_79F0)
    if _____914D_7F6EID == nil then
        return false
    end
    local _____7269_54C1 = _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(
        _____89E3_6790_914D_7F6E_5185_90E8ID(_____914D_7F6EID),
        GetUnitX(_____5355_4F4D),
        GetUnitY(_____5355_4F4D)
    )
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return UnitAddItem(_____5355_4F4D, _____7269_54C1)
end
local function _____5904_7406_5723_94A5_796D_575B(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    if not _____7ED9_4E88_7269_54C1(_____65BD_6CD5_5355_4F4D, "守誓圣铠合成书") then
        return false
    end
    _____589E_52A0_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        jass.Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffccffff『圣钥祭坛』：|r祭坛的石匣被圣水浸了不知多少年，匣中的锻造图谱却字迹如新——守誓者把铠甲的锻法留在了钥匙的诞生地，等一双还愿意守誓的手。|n|cffffff00获得守誓圣铠合成书、1能量碎片。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
____exports["注册钥匙圣地探索点"] = function()
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "钥匙圣地.圣钥祭坛",
        X = 26100.5,
        Y = -14312.2,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_5723_94A5_796D_575B
    })
end
return ____exports

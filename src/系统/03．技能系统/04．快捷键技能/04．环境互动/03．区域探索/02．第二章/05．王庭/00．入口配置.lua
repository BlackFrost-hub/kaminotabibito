--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local DzGetUnitNeededXP = japi.DzGetUnitNeededXP
local ____require_result_0 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心")
local _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_0["注册环境互动调查点"]
local ____require_result_1 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.00．环境互动配置")
local _____73AF_5883_4E92_52A8_88C5_5907_5956_52B1_6982_7387 = ____require_result_1["环境互动装备奖励概率"]
local ____require_result_2 = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具")
local _____89E3_6790_914D_7F6E_5185_90E8ID = ____require_result_2["解析配置内部ID"]
local ____require_result_3 = require("lib.扩展函数.物品相关函数.创建物品函数")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_3["创建物品并注册排泄监听"]
local ____require_result_4 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_4["按名字反查物品ID"]
local ____require_result_5 = require("系统.09．表现系统.06．广播提示消息.index")
local _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6 = ____require_result_5["发送单位提示给玩家"]
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
local function _____83B7_5F97_5F53_524D_5347_7EA7_7ECF_9A8C_767E_5206_6BD4(_____5355_4F4D, _____6BD4_4F8B)
    local level = jass.GetHeroLevel(_____5355_4F4D)
    local neededExp = DzGetUnitNeededXP(_____5355_4F4D, level)
    local value = jass.R2I(neededExp * _____6BD4_4F8B)
    if value > 0 then
        jass.AddHeroXP(_____5355_4F4D, value, true)
    end
end
local function _____5904_7406_6B66_5907_9648_5217_957F_684C(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    if not _____7ED9_4E88_7269_54C1(_____65BD_6CD5_5355_4F4D, "王庭礼剑") then
        return false
    end
    _____589E_52A0_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        jass.Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffccffff『武备陈列长桌』：|r长桌上的礼器兵器保养得一丝不苟，其中一柄长剑的铭牌写着仿制品，剑格内侧的守夜人戳记却骗不了人——被调包的是赝品，真品一直立在原地。|n|cffffff00获得王庭礼剑、1能量碎片。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
local function _____5904_7406_738B_5EAD_5E93_91D1(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    _____589E_52A0_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_GOLD, 10000)
    _____589E_52A0_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        jass.Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffffcc99『王庭库金』：|r墙边封存的库金积着薄灰，封条完好，账册上却查不到这一笔——像是有人特意把它留在这里，等一个会数数的人。|n|cffffff00获得10000金币、1能量碎片。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
local function _____5904_7406_4ED3_4FC3_64A4_79BB_7684_6742_5806(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    if not _____7ED9_4E88_7269_54C1(_____65BD_6CD5_5355_4F4D, "月影花") then
        return false
    end
    _____589E_52A0_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_GOLD, 8000)
    _____589E_52A0_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        jass.Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffff6800『仓促撤离的杂堆』：|r翻检过的箱笼与文书散了一地，椅子倒着没人扶——来过的人翻得很仔细，走得很急，带不走的又原样丢了回来。|n|cffffff00获得8000金币、月影花、1能量碎片。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
local function _____5904_7406_672A_5BC4_51FA_7684_4FE1_7B3A(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    _____83B7_5F97_5F53_524D_5347_7EA7_7ECF_9A8C_767E_5206_6BD4(_____65BD_6CD5_5355_4F4D, 0.15)
    _____589E_52A0_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        jass.Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffccffff『未寄出的信笺』：|r大桌上压着一叠信笺，火漆完整却从未封发，每一封的抬头都被裁去——写信的人不想让收信人被认出来。|n|cffffff00获得当前等级升级所需经验的15%、1能量碎片。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
____exports["注册王庭探索点"] = function()
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "王庭.武备陈列长桌",
        X = 21462.1,
        Y = -24415.7,
        ["一次性"] = true,
        ["一次性奖励概率"] = _____73AF_5883_4E92_52A8_88C5_5907_5956_52B1_6982_7387,
        ["触发回调"] = _____5904_7406_6B66_5907_9648_5217_957F_684C
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "王庭.王庭库金",
        X = 23207,
        Y = -24091.3,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_738B_5EAD_5E93_91D1
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "王庭.仓促撤离的杂堆",
        X = 23093,
        Y = -25204.5,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_4ED3_4FC3_64A4_79BB_7684_6742_5806
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "王庭.未寄出的信笺",
        X = 22607.6,
        Y = -23836.5,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_672A_5BC4_51FA_7684_4FE1_7B3A
    })
end
return ____exports

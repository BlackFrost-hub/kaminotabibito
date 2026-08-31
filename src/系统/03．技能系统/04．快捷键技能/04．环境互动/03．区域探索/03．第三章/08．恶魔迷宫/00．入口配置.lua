--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
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
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_5["调整玩家属性"]
local ____require_result_6 = require("系统.09．表现系统.06．广播提示消息.index")
local _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6 = ____require_result_6["发送单位提示给玩家"]
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local GetHeroAgi = jass.GetHeroAgi
local SetHeroAgi = jass.SetHeroAgi
local GetHeroInt = jass.GetHeroInt
local SetHeroInt = jass.SetHeroInt
local UnitAddItem = jass.UnitAddItem
local SGSS_SetState = require("lib.扩展函数.Star扩展函数.00．SGSS").SGSS_SetState
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
        jass.GetUnitX(_____5355_4F4D),
        jass.GetUnitY(_____5355_4F4D)
    )
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return UnitAddItem(_____5355_4F4D, _____7269_54C1)
end
local function _____5B8C_5168_6062_590D_751F_547D_4E0E_9B54_6CD5(_____5355_4F4D)
    SetUnitState(
        _____5355_4F4D,
        jass.UNIT_STATE_LIFE,
        GetUnitState(_____5355_4F4D, jass.UNIT_STATE_MAX_LIFE)
    )
    SetUnitState(
        _____5355_4F4D,
        jass.UNIT_STATE_MANA,
        GetUnitState(_____5355_4F4D, jass.UNIT_STATE_MAX_MANA)
    )
end
local function _____5904_7406_7EFF_6676_53CC_7891(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    SetHeroAgi(
        _____65BD_6CD5_5355_4F4D,
        GetHeroAgi(_____65BD_6CD5_5355_4F4D, false) + 2,
        true
    )
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        jass.Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffccffff『绿晶双碑』：|r甬道两侧的绿晶方碑刻满细密的划痕，指岔道的符号被凿去又重刻，最新一层的刻痕还带着石粉。守夜人更新界碑的习惯，比任何一张地图都诚实。|n|cffffff00永久敏捷+2。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
local function _____5904_7406_6D4B_7ED8_8425_5730_9057_5806(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    if not _____7ED9_4E88_7269_54C1(_____65BD_6CD5_5355_4F4D, "恶魔结晶") then
        return false
    end
    _____589E_52A0_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_GOLD, 8000)
    _____589E_52A0_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        jass.Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffff6800『测绘营地遗堆』：|r篝火的灰烬早已冷透，帐篷桩却还立着。宝箱上锁完好，压在箱底的测绘图稿画到一半就断了笔——比测绘师这一批人更早的探路者，也没能走出迷宫。|n|cffffff00获得8000金币、恶魔结晶、1能量碎片。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
local function _____5904_7406_65AD_6D41_77F3_4E95(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    if not _____7ED9_4E88_7269_54C1(_____65BD_6CD5_5355_4F4D, "深井活水囊") then
        return false
    end
    _____5B8C_5168_6062_590D_751F_547D_4E0E_9B54_6CD5(_____65BD_6CD5_5355_4F4D)
    _____589E_52A0_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        jass.Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cff66ccff『断流石井』：|r石井早已断流，井口的凹槽被绳子磨出深痕。贴近井口还能听见深处有活水在流，井沿挂着一只守夜人留下的水囊，囊中的水仍在轻轻晃动。|n|cffffff00生命与魔法完全恢复，获得深井活水囊、1能量碎片。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
local function _____5904_7406_8840_8DEF_796D_6807(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____65BD_6CD5_5355_4F4D, "生命值", 150)
    SGSS_SetState(_____65BD_6CD5_5355_4F4D, 7, 150)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        jass.Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffff6800『血路祭标』：|r祭坛的血槽里残渍未干，一路向迷宫深处延伸。敌对势力把拖运的路线做成了祭祀的路标——被拆走的引路灯照亮的，从来不是旅客的路。|n|cffffff00永久生命值+150。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
local function _____5904_7406_5C01_5B58_7684_5B9D_85CF(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    if not _____7ED9_4E88_7269_54C1(_____65BD_6CD5_5355_4F4D, "熔渊坠饰合成书") then
        return false
    end
    _____589E_52A0_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        jass.Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffff6800『封存的宝藏』：|r宝藏堆的封漆上盖着教团印记，撬开箱盖，最上面躺着一本用魔血写就的重铸手记——教团把自己的重铸法也封进了宝藏。|n|cffffff00获得熔渊坠饰合成书、1能量碎片。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
local function _____5904_7406_5411_5BFC_77F3_50CF_5217(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    SetHeroInt(
        _____65BD_6CD5_5355_4F4D,
        GetHeroInt(_____65BD_6CD5_5355_4F4D, false) + 2,
        true
    )
    _____589E_52A0_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        jass.Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffccffff『向导石像列』：|r石像列的每一尊都捧着一颗圣球，唯独其中一尊的圣球颜色更新、接缝粗糙，是后来才补上的。守夜人的序列在某一代断了档，补球的人手艺并不高明。|n|cffffff00永久智力+2，获得1能量碎片。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
____exports["注册恶魔迷宫探索点"] = function()
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "恶魔迷宫.绿晶双碑",
        X = 29216.4,
        Y = -8519.3,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_7EFF_6676_53CC_7891
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "恶魔迷宫.测绘营地遗堆",
        X = 26698.3,
        Y = -10766.2,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_6D4B_7ED8_8425_5730_9057_5806
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "恶魔迷宫.断流石井",
        X = 24544.3,
        Y = -3520.7,
        ["一次性"] = true,
        ["一次性奖励概率"] = _____73AF_5883_4E92_52A8_88C5_5907_5956_52B1_6982_7387,
        ["触发回调"] = _____5904_7406_65AD_6D41_77F3_4E95
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "恶魔迷宫.血路祭标",
        X = 27139.4,
        Y = -12154.9,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_8840_8DEF_796D_6807
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "恶魔迷宫.向导石像列",
        X = 26353.5,
        Y = -13607.7,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_5411_5BFC_77F3_50CF_5217
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "恶魔迷宫.封存的宝藏",
        X = 14723.4,
        Y = -27824.7,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_5C01_5B58_7684_5B9D_85CF
    })
end
return ____exports

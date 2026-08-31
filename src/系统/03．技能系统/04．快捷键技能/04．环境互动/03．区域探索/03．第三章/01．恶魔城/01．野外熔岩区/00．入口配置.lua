--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心")
local _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_0["注册环境互动调查点"]
local _____6CE8_9500_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_0["注销环境互动调查点"]
local ____require_result_1 = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具")
local _____89E3_6790_914D_7F6E_5185_90E8ID = ____require_result_1["解析配置内部ID"]
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_2["创建单位并登记排泄安全"]
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_3.registerDeathListener
local unregisterDeathListener = ____require_result_3.unregisterDeathListener
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_4["调整玩家属性"]
local ____require_result_5 = require("系统.09．表现系统.06．广播提示消息.index")
local _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6 = ____require_result_5["发送单位提示给玩家"]
local Player = jass.Player
local _____4E2D_7ACB_654C_5BF9 = Player(jass.PLAYER_NEUTRAL_AGGRESSIVE)
local _____7194_6838X = 22177.5
local _____7194_6838Y = -16520.8
local _____7194_6838_906D_9047ID = "恶魔城.未冷熔核"
local _____7194_6838_5355_4F4D_7C7B_578BID = _____89E3_6790_914D_7F6E_5185_90E8ID("n027")
local _____63D0_793A_6301_7EED_6BEB_79D2 = 5200
local _____7194_6838_906D_9047_5355_4F4D = nil
local _____7194_6838_906D_9047_82F1_96C4 = nil
local _____7194_6838_906D_9047_73A9_5BB6ID = -1
local function _____589E_52A0_73A9_5BB6_8D44_6E90(_____73A9_5BB6ID, _____72B6_6001, _____6570_91CF)
    local _____73A9_5BB6 = Player(_____73A9_5BB6ID)
    jass.SetPlayerState(
        _____73A9_5BB6,
        _____72B6_6001,
        jass.GetPlayerState(_____73A9_5BB6, _____72B6_6001) + _____6570_91CF
    )
end
local function _____5904_7406_672A_51B7_7194_6838_6B7B_4EA1(_____6B7B_4EA1_5355_4F4D, ______51FB_6740_5355_4F4D)
    if _____6B7B_4EA1_5355_4F4D ~= _____7194_6838_906D_9047_5355_4F4D then
        return
    end
    local _____82F1_96C4 = _____7194_6838_906D_9047_82F1_96C4
    local _____73A9_5BB6ID = _____7194_6838_906D_9047_73A9_5BB6ID
    _____7194_6838_906D_9047_5355_4F4D = nil
    _____7194_6838_906D_9047_82F1_96C4 = nil
    _____7194_6838_906D_9047_73A9_5BB6ID = -1
    unregisterDeathListener(_____5904_7406_672A_51B7_7194_6838_6B7B_4EA1)
    _____6CE8_9500_73AF_5883_4E92_52A8_8C03_67E5_70B9(_____7194_6838_906D_9047ID)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or _____73A9_5BB6ID < 0 then
        return
    end
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____82F1_96C4, "力量", 2)
    _____589E_52A0_73A9_5BB6_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_GOLD, 15000)
    _____589E_52A0_73A9_5BB6_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        Player(_____73A9_5BB6ID),
        _____82F1_96C4,
        "|cffff6800『未冷熔核』：|r熔岩元素的核心熄灭后，岩石内部的人为切痕显露出来。这里保存的并不是余热，而是一块被截取的熔核残片。|n|cffffff00获得永久力量+2、15000金币、1能量碎片。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
end
local function _____5904_7406_672A_51B7_7194_6838_8C03_67E5(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    if _____7194_6838_906D_9047_5355_4F4D ~= nil or _____7194_6838_5355_4F4D_7C7B_578BID <= 0 then
        return false
    end
    local _____5355_4F4D = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        _____4E2D_7ACB_654C_5BF9,
        _____7194_6838_5355_4F4D_7C7B_578BID,
        _____7194_6838X,
        _____7194_6838Y,
        270
    )
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    _____7194_6838_906D_9047_5355_4F4D = _____5355_4F4D
    _____7194_6838_906D_9047_82F1_96C4 = _____65BD_6CD5_5355_4F4D
    _____7194_6838_906D_9047_73A9_5BB6ID = _____73A9_5BB6ID
    registerDeathListener(_____5904_7406_672A_51B7_7194_6838_6B7B_4EA1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffff6800『未冷熔核』：|r你触碰了熔岩石，里面传出沉重的心跳声。凝固的裂缝突然被热光贯穿，一只熔岩元素从石中挣脱出来。|n|cffffff00击败它，才能取出熔核残片。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return false
end
local function _____5904_7406_56DE_6D41_88C2_75D5(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____65BD_6CD5_5355_4F4D, "生命恢复", 15)
    _____589E_52A0_73A9_5BB6_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_GOLD, 20000)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffff6800『回流裂痕』：|r熔岩的流向与地势完全相反，裂痕深处有一条被人为改造过的熔流通道，似乎通向更深的区域。|n|cffffff00获得永久生命恢复+15、20000金币。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
____exports["注册恶魔城野外熔岩探索点"] = function()
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "恶魔城.回流裂痕",
        X = 18528.5,
        Y = -14922.4,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_56DE_6D41_88C2_75D5
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = _____7194_6838_906D_9047ID,
        X = _____7194_6838X,
        Y = _____7194_6838Y,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_672A_51B7_7194_6838_8C03_67E5
    })
end
return ____exports

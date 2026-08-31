--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____589E_52A0_8D44_6E90, _____7ED9_4E88_7269_54C1, _____5904_7406_7126_5316_86DB_5DE2_51FB_6740, _____5904_7406_707C_70ED_706B_5C71_5355_4F4D_6B7B_4EA1, jass, _____6CE8_9500_73AF_5883_4E92_52A8_8C03_67E5_70B9, _____89E3_6790_914D_7F6E_5185_90E8ID, _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C, _____6309_540D_5B57_53CD_67E5_7269_54C1ID, unregisterDeathListener, _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6, Player, GetUnitX, GetUnitY, GetHeroAgi, SetHeroAgi, UnitAddItem, _____63D0_793A_6301_7EED_6BEB_79D2, _____86DB_5DE2_906D_9047ID, _____86DB_5DE2_906D_9047_5355_4F4D, _____86DB_5DE2_906D_9047_82F1_96C4, _____86DB_5DE2_906D_9047_73A9_5BB6ID
function _____589E_52A0_8D44_6E90(_____73A9_5BB6ID, _____72B6_6001, _____6570_91CF)
    local _____73A9_5BB6 = Player(_____73A9_5BB6ID)
    jass.SetPlayerState(
        _____73A9_5BB6,
        _____72B6_6001,
        jass.GetPlayerState(_____73A9_5BB6, _____72B6_6001) + _____6570_91CF
    )
end
function _____7ED9_4E88_7269_54C1(_____5355_4F4D, _____540D_79F0)
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
function _____5904_7406_7126_5316_86DB_5DE2_51FB_6740()
    if _____86DB_5DE2_906D_9047_82F1_96C4 == nil or _____86DB_5DE2_906D_9047_73A9_5BB6ID < 0 then
        return
    end
    local _____73A9_5BB6ID = _____86DB_5DE2_906D_9047_73A9_5BB6ID
    local _____82F1_96C4 = _____86DB_5DE2_906D_9047_82F1_96C4
    _____86DB_5DE2_906D_9047_5355_4F4D = nil
    _____86DB_5DE2_906D_9047_82F1_96C4 = nil
    _____86DB_5DE2_906D_9047_73A9_5BB6ID = -1
    unregisterDeathListener(_____5904_7406_707C_70ED_706B_5C71_5355_4F4D_6B7B_4EA1)
    _____6CE8_9500_73AF_5883_4E92_52A8_8C03_67E5_70B9(_____86DB_5DE2_906D_9047ID)
    SetHeroAgi(
        _____82F1_96C4,
        GetHeroAgi(_____82F1_96C4, false) + 2,
        true
    )
    _____589E_52A0_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_GOLD, 20000)
    _____589E_52A0_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1)
    _____7ED9_4E88_7269_54C1(_____82F1_96C4, "熔岩宝石")
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        Player(_____73A9_5BB6ID),
        _____82F1_96C4,
        "|cffff6800『焦化蛛巢』：|r火焰狼蛛倒下后，焦黑的蛛丝中凝出了一枚熔岩宝石。|n|cffffff00获得熔岩宝石、敏捷+2、20000金币、1能量碎片。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
end
function _____5904_7406_707C_70ED_706B_5C71_5355_4F4D_6B7B_4EA1(_____6B7B_4EA1_5355_4F4D, ______51FB_6740_5355_4F4D)
    if _____6B7B_4EA1_5355_4F4D ~= _____86DB_5DE2_906D_9047_5355_4F4D then
        return
    end
    _____5904_7406_7126_5316_86DB_5DE2_51FB_6740()
end
jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心")
local _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_0["注册环境互动调查点"]
_____6CE8_9500_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_0["注销环境互动调查点"]
local ____require_result_1 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.00．环境互动配置")
local _____73AF_5883_4E92_52A8_88C5_5907_5956_52B1_6982_7387 = ____require_result_1["环境互动装备奖励概率"]
local ____require_result_2 = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具")
_____89E3_6790_914D_7F6E_5185_90E8ID = ____require_result_2["解析配置内部ID"]
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_3["创建单位并登记排泄安全"]
local ____require_result_4 = require("lib.扩展函数.物品相关函数.创建物品函数")
_____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_4["创建物品并注册排泄监听"]
local ____require_result_5 = require("系统.02．物品系统.13．物品名反查")
_____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_5["按名字反查物品ID"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_6["调整玩家属性"]
local ____require_result_7 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_7.registerDeathListener
unregisterDeathListener = ____require_result_7.unregisterDeathListener
local ____require_result_8 = require("系统.09．表现系统.06．广播提示消息.index")
_____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6 = ____require_result_8["发送单位提示给玩家"]
Player = jass.Player
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetHeroAgi = jass.GetHeroAgi
SetHeroAgi = jass.SetHeroAgi
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
UnitAddItem = jass.UnitAddItem
local SGSS_SetState = require("lib.扩展函数.Star扩展函数.00．SGSS").SGSS_SetState
local _____4E2D_7ACB_654C_5BF9 = Player(jass.PLAYER_NEUTRAL_AGGRESSIVE)
_____63D0_793A_6301_7EED_6BEB_79D2 = 5200
local _____86DB_5DE2X = 12346.5
local _____86DB_5DE2Y = -26893.9
_____86DB_5DE2_906D_9047ID = "灼热火山.焦化蛛巢"
local _____86DB_5DE2_5355_4F4D_7C7B_578BID = _____89E3_6790_914D_7F6E_5185_90E8ID("n00Z")
_____86DB_5DE2_906D_9047_5355_4F4D = nil
_____86DB_5DE2_906D_9047_82F1_96C4 = nil
_____86DB_5DE2_906D_9047_73A9_5BB6ID = -1
local function _____5904_7406_706B_5C71_5FC3_8109(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____65BD_6CD5_5355_4F4D, "生命恢复", 20)
    _____589E_52A0_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffff6800『火山心脉余烬』：|r火山口的熔壳向内部塌陷，地下热流被持续牵引。余烬融入血脉，你的生命恢复得到永久提升。|n|cffffff00生命恢复+20，获得1能量碎片。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
local function _____5904_7406_7126_5316_86DB_5DE2(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    if _____86DB_5DE2_906D_9047_5355_4F4D ~= nil then
        return false
    end
    _____86DB_5DE2_906D_9047_82F1_96C4 = _____65BD_6CD5_5355_4F4D
    _____86DB_5DE2_906D_9047_73A9_5BB6ID = _____73A9_5BB6ID
    _____86DB_5DE2_906D_9047_5355_4F4D = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        _____4E2D_7ACB_654C_5BF9,
        _____86DB_5DE2_5355_4F4D_7C7B_578BID,
        _____86DB_5DE2X + 220,
        _____86DB_5DE2Y,
        180
    )
    if _____86DB_5DE2_906D_9047_5355_4F4D == nil or _____86DB_5DE2_906D_9047_5355_4F4D == 0 then
        _____86DB_5DE2_906D_9047_82F1_96C4 = nil
        _____86DB_5DE2_906D_9047_73A9_5BB6ID = -1
        return false
    end
    registerDeathListener(_____5904_7406_707C_70ED_706B_5C71_5355_4F4D_6B7B_4EA1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffff6800『焦化蛛巢』：|r你触动了岩壁上的蛛网，巢穴深处传来尖锐的摩擦声。火焰狼蛛已经醒来，击败它才能取出收获。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return false
end
local function _____5904_7406_7194_6D41_53E4_9053(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    if not _____7ED9_4E88_7269_54C1(_____65BD_6CD5_5355_4F4D, "余烬寻路灯") then
        return false
    end
    SGSS_SetState(_____65BD_6CD5_5355_4F4D, 7, 300)
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____65BD_6CD5_5355_4F4D, "生命值", 300)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffff6800『熔流古道压痕』：|r凝固石道上的拖痕指向熔岩小镇，冷却矿渣中还留着一盏余烬寻路灯。|n|cffffff00生命值+300，获得余烬寻路灯。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
local function _____5904_7406_9006_7130_51B7_6CC9(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____65BD_6CD5_5355_4F4D, "魔法恢复", 12)
    SGSS_SetState(_____65BD_6CD5_5355_4F4D, 8, 200)
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____65BD_6CD5_5355_4F4D, "魔法值", 200)
    SetUnitState(
        _____65BD_6CD5_5355_4F4D,
        jass.UNIT_STATE_LIFE,
        GetUnitState(_____65BD_6CD5_5355_4F4D, jass.UNIT_STATE_MAX_LIFE)
    )
    SetUnitState(
        _____65BD_6CD5_5355_4F4D,
        jass.UNIT_STATE_MANA,
        GetUnitState(_____65BD_6CD5_5355_4F4D, jass.UNIT_STATE_MAX_MANA)
    )
    _____589E_52A0_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cff66ccff『逆焰冷泉』：|r冷泉下的旧石渠仍在抽走山腹热量，泉水的力量融入你的魔力循环。|n|cffffff00魔法恢复+12、魔法值+200、生命与魔法完全恢复，获得1能量碎片。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
____exports["注册灼热火山探索点"] = function()
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "灼热火山.火山心脉余烬",
        X = 8026.8,
        Y = -27365.7,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_706B_5C71_5FC3_8109
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = _____86DB_5DE2_906D_9047ID,
        X = _____86DB_5DE2X,
        Y = _____86DB_5DE2Y,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_7126_5316_86DB_5DE2
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "灼热火山.熔流古道压痕",
        X = 8715.6,
        Y = -24386.6,
        ["一次性"] = true,
        ["一次性奖励概率"] = _____73AF_5883_4E92_52A8_88C5_5907_5956_52B1_6982_7387,
        ["触发回调"] = _____5904_7406_7194_6D41_53E4_9053
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "熔岩小镇.逆焰冷泉",
        X = 7985.2,
        Y = -22435.5,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_9006_7130_51B7_6CC9
    })
end
return ____exports

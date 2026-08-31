--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心")
local _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_0["注册环境互动调查点"]
local _____6CE8_9500_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_0["注销环境互动调查点"]
local ____require_result_1 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.00．环境互动配置")
local _____73AF_5883_4E92_52A8_88C5_5907_5956_52B1_6982_7387 = ____require_result_1["环境互动装备奖励概率"]
local ____require_result_2 = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具")
local _____89E3_6790_914D_7F6E_5185_90E8ID = ____require_result_2["解析配置内部ID"]
local ____require_result_3 = require("lib.扩展函数.物品相关函数.创建物品函数")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_3["创建物品并注册排泄监听"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口")
local _____521B_5EFA_53EC_5524_7269 = ____require_result_4["创建召唤物"]
local ____require_result_5 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_5.registerDeathListener
local unregisterDeathListener = ____require_result_5.unregisterDeathListener
local ____require_result_6 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_6["按名字反查物品ID"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_7["调整玩家属性"]
local ____require_result_8 = require("系统.09．表现系统.06．广播提示消息.index")
local _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6 = ____require_result_8["发送单位提示给玩家"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHeroStr = jass.GetHeroStr
local SetHeroStr = jass.SetHeroStr
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local UnitAddItem = jass.UnitAddItem
local SGSS_SetState = require("lib.扩展函数.Star扩展函数.00．SGSS").SGSS_SetState
local _____63D0_793A_6301_7EED_6BEB_79D2 = 5200
local _____8718_86DB_70B9_4F4DX = 24222.4
local _____8718_86DB_70B9_4F4DY = -12127.9
local _____8718_86DB_73AF_5883_4E92_52A8ID = "恶魔城.焚丝蛛痕"
local _____8718_86DB_6A21_578B_8DEF_5F84 = "Unit\\Minion\\FireSpider\\CryptFiend.mdx"
local _____8718_86DB_5355_4F4D_540D_79F0 = "熔狱焚丝蛛"
local _____8718_86DB_57FA_7840_751F_547D_503C = 6400
local _____8718_86DB_653B_51FB_529B = 755
local _____8718_86DB_653B_51FB_95F4_9694 = 1
local _____8718_86DB_62A4_7532 = 10
local _____8718_86DB_7D22_654C_8303_56F4 = 750
local _____8718_86DB_7F29_653E = 0.85
local _____4E2D_7ACB_654C_5BF9 = jass.Player(jass.PLAYER_NEUTRAL_AGGRESSIVE)
local _____8718_86DB_906D_9047_5355_4F4D = nil
local _____8718_86DB_906D_9047_82F1_96C4 = nil
local _____8718_86DB_906D_9047_73A9_5BB6ID = -1
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
local function _____5904_7406_953B_9020_533A_8D27_7BB1(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    if not _____7ED9_4E88_7269_54C1(_____65BD_6CD5_5355_4F4D, "恶魔锻火结晶") then
        return false
    end
    _____589E_52A0_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        jass.Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffff6800『锻造区货箱』：|r货箱里的成品早已被搬空，只剩未发运的锻材。装箱单上的收货方一栏被划去重写，最终收货的地址不是城中任何一家铁匠铺。|n|cffffff00获得恶魔锻火结晶、1能量碎片。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
local function _____5904_7406_82B1_56ED_6CC9_773C(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____65BD_6CD5_5355_4F4D, "生命恢复", 12)
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____65BD_6CD5_5355_4F4D, "魔法恢复", 6)
    _____5B8C_5168_6062_590D_751F_547D_4E0E_9B54_6CD5(_____65BD_6CD5_5355_4F4D)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        jass.Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cff66ccff『花园泉眼』：|r环廊里的植物早已扭曲变形，唯独泉眼周围还留着一圈青草。泉水依旧清冽，只是水底沉着几片黑色的鳞状物，随水流轻轻摆动。|n|cffffff00生命恢复+12、魔法恢复+6，生命与魔法完全恢复。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
local function _____5904_7406_9A91_58EB_77F3_50CF(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    SetHeroStr(
        _____65BD_6CD5_5355_4F4D,
        GetHeroStr(_____65BD_6CD5_5355_4F4D, false) + 2,
        true
    )
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        jass.Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffccffff『骑士石像』：|r石像的双手紧握一柄断剑，剑身缺口的位置与底座浮雕上城门破损的位置完全一致。底座刻文只余一句：城在人在。|n|cffffff00永久力量+2。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
local function _____5904_7406_767D_77F3_7891_5217(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____65BD_6CD5_5355_4F4D, "生命值", 200)
    SGSS_SetState(_____65BD_6CD5_5355_4F4D, 7, 200)
    _____589E_52A0_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        jass.Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffccffff『白石碑列』：|r碑列没有立者姓名，只有一行行小字记录着同一天死去的人。刻工起初工整，越往后越潦草，最后一碑只刻了一个未写完的名字。|n|cffffff00生命值+200，获得1能量碎片。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
local function _____5904_7406_9057_843D_8D27_7BB1_91D1_5806(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    if not _____7ED9_4E88_7269_54C1(_____65BD_6CD5_5355_4F4D, "夜行教团坠饰") then
        return false
    end
    _____589E_52A0_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_LUMBER, 1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        jass.Player(_____73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffff6800『遗落货箱金堆』：|r货箱没有上锁，金币散落在箱口，像是搬运的人中途被什么打断，再没有回来。箱底压着一条教团样式的坠饰。|n|cffffff00获得夜行教团坠饰、1能量碎片。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return true
end
local function _____5904_7406_711A_4E1D_86DB_6B7B_4EA1(_____6B7B_4EA1_5355_4F4D, ______51FB_6740_5355_4F4D)
    if _____6B7B_4EA1_5355_4F4D ~= _____8718_86DB_906D_9047_5355_4F4D then
        return
    end
    local _____82F1_96C4 = _____8718_86DB_906D_9047_82F1_96C4
    local _____73A9_5BB6ID = _____8718_86DB_906D_9047_73A9_5BB6ID
    _____8718_86DB_906D_9047_5355_4F4D = nil
    _____8718_86DB_906D_9047_82F1_96C4 = nil
    _____8718_86DB_906D_9047_73A9_5BB6ID = -1
    unregisterDeathListener(_____5904_7406_711A_4E1D_86DB_6B7B_4EA1)
    _____6CE8_9500_73AF_5883_4E92_52A8_8C03_67E5_70B9(_____8718_86DB_73AF_5883_4E92_52A8ID)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or _____73A9_5BB6ID < 0 then
        return
    end
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____82F1_96C4, "魔法恢复", 10)
    _____589E_52A0_8D44_6E90(_____73A9_5BB6ID, jass.PLAYER_STATE_RESOURCE_GOLD, 20000)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        jass.Player(_____73A9_5BB6ID),
        _____82F1_96C4,
        "|cffff6800『焚丝蛛痕』：|r熔狱焚丝蛛倒下，缠在岩缝里的赤黑蛛丝逐渐失去光泽。蛛丝深处残留着一股持续牵引魔力的热流。|n|cffffff00获得永久魔法恢复+10、20000金币。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
end
local function _____5904_7406_711A_4E1D_86DB_75D5(______73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, ______8C03_67E5_70B9)
    if _____8718_86DB_906D_9047_5355_4F4D ~= nil then
        return false
    end
    local _____8718_86DB = _____521B_5EFA_53EC_5524_7269({
        ["所属玩家"] = _____4E2D_7ACB_654C_5BF9,
        ["单位类型"] = "e08P",
        ["单位名称"] = _____8718_86DB_5355_4F4D_540D_79F0,
        ["模型文件"] = _____8718_86DB_6A21_578B_8DEF_5F84,
        X = _____8718_86DB_70B9_4F4DX,
        Y = _____8718_86DB_70B9_4F4DY,
        ["朝向"] = 180,
        ["飞行高度"] = 0,
        ["生命值"] = _____8718_86DB_57FA_7840_751F_547D_503C,
        ["生命值受小怪倍率"] = false,
        ["生命值受难度倍率"] = true,
        ["攻击力"] = _____8718_86DB_653B_51FB_529B,
        ["攻击间隔"] = _____8718_86DB_653B_51FB_95F4_9694,
        ["护甲"] = _____8718_86DB_62A4_7532,
        ["索敌范围"] = _____8718_86DB_7D22_654C_8303_56F4,
        ["缩放"] = _____8718_86DB_7F29_653E
    })
    if _____8718_86DB == nil or _____8718_86DB == 0 then
        return false
    end
    _____8718_86DB_906D_9047_5355_4F4D = _____8718_86DB
    _____8718_86DB_906D_9047_82F1_96C4 = _____65BD_6CD5_5355_4F4D
    _____8718_86DB_906D_9047_73A9_5BB6ID = jass.GetPlayerId(jass.GetOwningPlayer(_____65BD_6CD5_5355_4F4D))
    registerDeathListener(_____5904_7406_711A_4E1D_86DB_6B7B_4EA1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        jass.Player(_____8718_86DB_906D_9047_73A9_5BB6ID),
        _____65BD_6CD5_5355_4F4D,
        "|cffff6800『焚丝蛛痕』：|r蛛网深处传来甲壳刮过熔岩的声响，一只熔狱焚丝蛛从裂缝中爬出。击败它，才能看清这片蛛丝隐藏的痕迹。|r",
        _____63D0_793A_6301_7EED_6BEB_79D2
    )
    return false
end
____exports["注册恶魔城探索点"] = function()
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "恶魔城.锻造区货箱",
        X = 14000.2,
        Y = -18593.3,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_953B_9020_533A_8D27_7BB1
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "恶魔城.花园泉眼",
        X = 15643.2,
        Y = -16256.1,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_82B1_56ED_6CC9_773C
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "恶魔城.骑士石像",
        X = 14602.7,
        Y = -16744,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_9A91_58EB_77F3_50CF
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "恶魔城.白石碑列",
        X = 13804.9,
        Y = -15086.5,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_767D_77F3_7891_5217
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "恶魔城.遗落货箱金堆",
        X = 16413.4,
        Y = -14487.5,
        ["一次性"] = true,
        ["一次性奖励概率"] = _____73AF_5883_4E92_52A8_88C5_5907_5956_52B1_6982_7387,
        ["触发回调"] = _____5904_7406_9057_843D_8D27_7BB1_91D1_5806
    })
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = _____8718_86DB_73AF_5883_4E92_52A8ID,
        X = _____8718_86DB_70B9_4F4DX,
        Y = _____8718_86DB_70B9_4F4DY,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_711A_4E1D_86DB_75D5
    })
end
return ____exports

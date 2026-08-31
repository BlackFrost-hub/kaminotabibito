--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心")
local _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_0["注册环境互动调查点"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口")
local _____521B_5EFA_53EC_5524_7269 = ____require_result_1["创建召唤物"]
local ____require_result_2 = require("lib.扩展函数.物品相关函数.创建物品函数")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_2["创建物品并注册排泄监听"]
local ____require_result_3 = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具")
local _____89E3_6790_914D_7F6E_5185_90E8ID = ____require_result_3["解析配置内部ID"]
local ____require_result_4 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.49．封印守卫战")
local _____662F_5426_5DF2_6210_529F_5B8C_6210_5C01_5370_5B88_536B_6218 = ____require_result_4["是否已成功完成封印守卫战"]
local ____require_result_5 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_5["按名字反查物品ID"]
local ____require_result_6 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_6.registerDeathListener
local unregisterDeathListener = ____require_result_6.unregisterDeathListener
local ____require_result_7 = require("系统.09．表现系统.06．广播提示消息.index")
local _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6 = ____require_result_7["发送单位提示给玩家"]
local _____5C01_5370_8C03_67E5X = 998.3
local _____5C01_5370_8C03_67E5Y = -9739.3
local _____5C0FBoss_540D_79F0 = "归返的封印枪卫"
local _____5C0FBoss_6A21_578B = "Unit\\Special\\SealRiftWarden.mdx"
local _____5C0FBoss_73A9_5BB6 = jass.Player(jass.PLAYER_NEUTRAL_AGGRESSIVE)
local _____5F53_524D_5C0FBoss = nil
local _____5F53_524D_8C03_67E5_82F1_96C4 = nil
local _____5F53_524D_8C03_67E5_73A9_5BB6ID = -1
local function _____5904_7406_5C01_5370_5C0FBoss_6B7B_4EA1(_____6B7B_4EA1_5355_4F4D, ______51FB_6740_5355_4F4D)
    if _____6B7B_4EA1_5355_4F4D ~= _____5F53_524D_5C0FBoss then
        return
    end
    local _____82F1_96C4 = _____5F53_524D_8C03_67E5_82F1_96C4
    local _____73A9_5BB6ID = _____5F53_524D_8C03_67E5_73A9_5BB6ID
    _____5F53_524D_5C0FBoss = nil
    _____5F53_524D_8C03_67E5_82F1_96C4 = nil
    _____5F53_524D_8C03_67E5_73A9_5BB6ID = -1
    unregisterDeathListener(_____5904_7406_5C01_5370_5C0FBoss_6B7B_4EA1)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or _____73A9_5BB6ID < 0 then
        return
    end
    local _____914D_7F6EID = _____6309_540D_5B57_53CD_67E5_7269_54C1ID("七晶封印棱章")
    if _____914D_7F6EID == nil then
        return
    end
    local _____7269_54C1 = _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(
        _____89E3_6790_914D_7F6E_5185_90E8ID(_____914D_7F6EID),
        jass.GetUnitX(_____82F1_96C4),
        jass.GetUnitY(_____82F1_96C4)
    )
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return
    end
    jass.UnitAddItem(_____82F1_96C4, _____7269_54C1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        jass.Player(_____73A9_5BB6ID),
        _____82F1_96C4,
        "|cff66ccff『七晶封印棱章』：|r封印枪卫倒下，七颗晶石重新稳定下来，棱面上凝出一枚完整的守护徽章。|n|cffffff00获得装备：七晶封印棱章。|r",
        5200
    )
end
local function _____5904_7406_5C01_5370_5B88_536B_6218_540E_8C03_67E5(_____73A9_5BB6ID, _____82F1_96C4, ______8C03_67E5_70B9)
    if not _____662F_5426_5DF2_6210_529F_5B8C_6210_5C01_5370_5B88_536B_6218() or _____5F53_524D_5C0FBoss ~= nil then
        return false
    end
    local _____5C0FBoss = _____521B_5EFA_53EC_5524_7269({
        ["所属玩家"] = _____5C0FBoss_73A9_5BB6,
        ["单位类型"] = "n06M",
        ["单位名称"] = _____5C0FBoss_540D_79F0,
        ["模型文件"] = _____5C0FBoss_6A21_578B,
        X = _____5C01_5370_8C03_67E5X,
        Y = _____5C01_5370_8C03_67E5Y,
        ["朝向"] = 270,
        ["生命值"] = 54600,
        ["生命值受小怪倍率"] = false,
        ["生命值受难度倍率"] = true,
        ["攻击力"] = 7670,
        ["攻击间隔"] = 1.35,
        ["护甲"] = 45.5,
        ["索敌范围"] = 800,
        ["缩放"] = 1.15
    })
    if _____5C0FBoss == nil or _____5C0FBoss == 0 then
        return false
    end
    _____5F53_524D_5C0FBoss = _____5C0FBoss
    _____5F53_524D_8C03_67E5_82F1_96C4 = _____82F1_96C4
    _____5F53_524D_8C03_67E5_73A9_5BB6ID = _____73A9_5BB6ID
    registerDeathListener(_____5904_7406_5C01_5370_5C0FBoss_6B7B_4EA1)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(
        jass.Player(_____73A9_5BB6ID),
        _____82F1_96C4,
        "|cff66ccff『封印核心残响』：|r七颗晶石的余波重新汇聚，裂隙深处走出一名归返的封印枪卫。击败它，才能取走守护战留下的晶石力量。|r",
        5200
    )
    return true
end
____exports["注册封印核心探索点"] = function()
    _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
        ID = "封印核心.封印守卫战后残响",
        X = _____5C01_5370_8C03_67E5X,
        Y = _____5C01_5370_8C03_67E5Y,
        ["一次性"] = true,
        ["触发回调"] = _____5904_7406_5C01_5370_5B88_536B_6218_540E_8C03_67E5
    })
end
return ____exports

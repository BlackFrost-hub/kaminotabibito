local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local _____521B_5EFA_6C34_89E6_624B, _____542F_52A8_65E7Boss_6218, _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168, YDUserDataSetSafe, createTimedEffect, _____5E7F_64AD_5355_4F4D_63D0_793A, _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8, _____542F_52A8Boss_6218_8FD0_884C, _____89E3_6790_914D_7F6E_5185_90E8ID, Player, PLAYER_NEUTRAL_PASSIVE
local ____00_FF0E_65E7_73AF_5883_4E92_52A8_914D_7F6E = require("系统.03．技能系统.04．快捷键技能.04．环境互动.02．旧环境互动.00．旧环境互动配置")
local _____65E7_73AF_5883_4E92_52A8Boss_5355_4F4DID = ____00_FF0E_65E7_73AF_5883_4E92_52A8_914D_7F6E["旧环境互动Boss单位ID"]
local _____65E7_73AF_5883_4E92_52A8_914D_7F6E_8868 = ____00_FF0E_65E7_73AF_5883_4E92_52A8_914D_7F6E["旧环境互动配置表"]
local _____65E7_73AF_5883_4E92_52A8_679C_5B50_7269_54C1ID = ____00_FF0E_65E7_73AF_5883_4E92_52A8_914D_7F6E["旧环境互动果子物品ID"]
local _____65E7_73AF_5883_4E92_52A8_9690_85CF_6728_6869_5956_52B1_7269_54C1ID_5217_8868 = ____00_FF0E_65E7_73AF_5883_4E92_52A8_914D_7F6E["旧环境互动隐藏木桩奖励物品ID列表"]
local _____65E7_73AF_5883_4E92_52A8_6C34_89E6_624B_5355_4F4DID = ____00_FF0E_65E7_73AF_5883_4E92_52A8_914D_7F6E["旧环境互动水触手单位ID"]
local _____65E7_73AF_5883_4E92_52A8_6C34_89E6_624B_7279_6548_8DEF_5F84 = ____00_FF0E_65E7_73AF_5883_4E92_52A8_914D_7F6E["旧环境互动水触手特效路径"]
function _____521B_5EFA_6C34_89E6_624B(_____53C2_6570)
    if _____53C2_6570 == nil or _____53C2_6570["施法单位"] == nil or _____53C2_6570["施法单位"] == 0 then
        return
    end
    local X = _____53C2_6570["配置"].X
    local Y = _____53C2_6570["配置"].Y
    createTimedEffect(
        _____65E7_73AF_5883_4E92_52A8_6C34_89E6_624B_7279_6548_8DEF_5F84,
        X,
        Y,
        0,
        1
    )
    _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(PLAYER_NEUTRAL_PASSIVE),
        _____89E3_6790_914D_7F6E_5185_90E8ID(_____65E7_73AF_5883_4E92_52A8_6C34_89E6_624B_5355_4F4DID),
        X,
        Y,
        0
    )
    if _____53C2_6570["配置"]["延迟提示文本"] ~= nil and _____53C2_6570["配置"]["延迟提示文本"] ~= "" then
        _____5E7F_64AD_5355_4F4D_63D0_793A(_____53C2_6570["施法单位"], _____53C2_6570["配置"]["延迟提示文本"], 1500)
    end
end
function _____542F_52A8_65E7Boss_6218(_____53C2_6570)
    if _____53C2_6570 == nil or _____53C2_6570["Boss单位"] == nil or _____53C2_6570["Boss单位"] == 0 then
        return
    end
    YDUserDataSetSafe(
        "string",
        "Boss战",
        "触发玩家",
        "unit",
        _____53C2_6570["触发单位"]
    )
    _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8(_____53C2_6570["Boss单位"], "Boss战.单位")
    _____542F_52A8Boss_6218_8FD0_884C(_____53C2_6570["Boss单位"])
end
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心")
local _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_0["注册环境互动调查点"]
local _____6CE8_9500_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_0["注销环境互动调查点"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
_____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_2["创建单位并登记排泄安全"]
local ____require_result_3 = require("lib.扩展函数.物品相关函数.创建物品函数")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_3["创建物品并注册排泄监听"]
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_4.YDUserDataGetSafe
YDUserDataSetSafe = ____require_result_4.YDUserDataSetSafe
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
createTimedEffect = ____require_result_5.createTimedEffect
local ____require_result_6 = require("系统.09．表现系统.06．广播提示消息.index")
_____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_6["广播单位提示"]
local ____require_result_7 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表")
_____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8 = ____require_result_7["记录Boss自动技能启动"]
local ____require_result_8 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.03．Boss战运行驱动")
_____542F_52A8Boss_6218_8FD0_884C = ____require_result_8["启动Boss战运行"]
local ____require_result_9 = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口")
local SFB_setBuff = ____require_result_9.SFB_setBuff
local ____require_result_10 = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具")
_____89E3_6790_914D_7F6E_5185_90E8ID = ____require_result_10["解析配置内部ID"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHeroLevel = jass.GetHeroLevel
local GetRandomInt = jass.GetRandomInt
Player = jass.Player
local SetUnitOwner = jass.SetUnitOwner
local UnitAddItem = jass.UnitAddItem
PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local ____Boss_5165_53E3_7279_6548_8DEF_5F84 = "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl"
local function _____521B_5EFA_5E76_7ED9_4E88_7269_54C1(_____65BD_6CD5_5355_4F4D, _____7269_54C1ID)
    local _____7269_54C1 = _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(
        _____89E3_6790_914D_7F6E_5185_90E8ID(_____7269_54C1ID),
        GetUnitX(_____65BD_6CD5_5355_4F4D),
        GetUnitY(_____65BD_6CD5_5355_4F4D)
    )
    if _____7269_54C1 ~= nil and _____7269_54C1 ~= 0 then
        UnitAddItem(_____65BD_6CD5_5355_4F4D, _____7269_54C1)
    end
end
local function _____5904_7406_6C34_89E6_624B(______73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    createTimedEffect(
        _____65E7_73AF_5883_4E92_52A8_6C34_89E6_624B_7279_6548_8DEF_5F84,
        _____8C03_67E5_70B9.X,
        _____8C03_67E5_70B9.Y,
        0,
        1
    )
    addDelayedCallback(3000, _____521B_5EFA_6C34_89E6_624B, {["施法单位"] = _____65BD_6CD5_5355_4F4D, ["配置"] = _____8C03_67E5_70B9})
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9["提示文本"], 1500)
    return true
end
local function _____5904_7406_4E66_67B6(______73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    local _____5F53_524D_6062_590D = __TS__Number(YDUserDataGetSafe("unit", _____65BD_6CD5_5355_4F4D, "魔法恢复", "real")) or 0
    YDUserDataSetSafe(
        "unit",
        _____65BD_6CD5_5355_4F4D,
        "魔法恢复",
        "real",
        _____5F53_524D_6062_590D + 1
    )
    local _____73A9_5BB6 = jass.GetOwningPlayer(_____65BD_6CD5_5355_4F4D)
    local _____5F53_524D_9B54_6CD5_4F24_5BB3 = __TS__Number(YDUserDataGetSafe("player", _____73A9_5BB6, "魔法伤害", "real")) or 0
    YDUserDataSetSafe(
        "player",
        _____73A9_5BB6,
        "魔法伤害",
        "real",
        _____5F53_524D_9B54_6CD5_4F24_5BB3 + 0.01
    )
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9["提示文本"], 3000)
    return true
end
local function _____5904_7406_7CBE_7075_5C0F_5C4B(______73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    local _____73A9_5BB6 = jass.GetOwningPlayer(_____65BD_6CD5_5355_4F4D)
    local _____5F53_524D_547D_4E2D = __TS__Number(YDUserDataGetSafe("player", _____73A9_5BB6, "命中率", "real")) or 0
    YDUserDataSetSafe(
        "player",
        _____73A9_5BB6,
        "命中率",
        "real",
        _____5F53_524D_547D_4E2D + 0.01
    )
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9["提示文本"], 3000)
    return true
end
local function _____5904_7406_7A7A_6728_6869(______73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    _____521B_5EFA_5E76_7ED9_4E88_7269_54C1(_____65BD_6CD5_5355_4F4D, _____65E7_73AF_5883_4E92_52A8_679C_5B50_7269_54C1ID)
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9["提示文本"], 3000)
    return true
end
local function _____5904_7406_6811_4E0A_7269_54C1(______73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    _____521B_5EFA_5E76_7ED9_4E88_7269_54C1(_____65BD_6CD5_5355_4F4D, _____65E7_73AF_5883_4E92_52A8_679C_5B50_7269_54C1ID)
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9["提示文本"], 3000)
    return true
end
local function _____5904_7406_9690_85CF_6728_6869(______73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    local _____968F_673A_5E8F_53F7 = GetRandomInt(1, 3) - 1
    _____521B_5EFA_5E76_7ED9_4E88_7269_54C1(_____65BD_6CD5_5355_4F4D, _____65E7_73AF_5883_4E92_52A8_9690_85CF_6728_6869_5956_52B1_7269_54C1ID_5217_8868[_____968F_673A_5E8F_53F7 + 1])
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9["提示文本"], 3000)
    return true
end
local function _____5904_7406_666E_901A_63D0_793A(______73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9["提示文本"], 3000)
    return true
end
local function _____5904_7406Boss_5165_53E3(______73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    if GetHeroLevel(_____65BD_6CD5_5355_4F4D) < 9 then
        return false
    end
    local X = _____8C03_67E5_70B9.X
    local Y = _____8C03_67E5_70B9.Y
    createTimedEffect(
        ____Boss_5165_53E3_7279_6548_8DEF_5F84,
        X,
        Y,
        0,
        1
    )
    SFB_setBuff(_____65BD_6CD5_5355_4F4D, _____65BD_6CD5_5355_4F4D, 0, 6)
    local ____Boss_5355_4F4D = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(PLAYER_NEUTRAL_PASSIVE),
        _____89E3_6790_914D_7F6E_5185_90E8ID(_____65E7_73AF_5883_4E92_52A8Boss_5355_4F4DID),
        X,
        Y,
        270
    )
    if ____Boss_5355_4F4D == nil or ____Boss_5355_4F4D == 0 then
        return false
    end
    YDUserDataSetSafe(
        "string",
        "Boss战",
        "单位",
        "unit",
        ____Boss_5355_4F4D
    )
    YDUserDataSetSafe(
        "string",
        "Boss战",
        "绑定单位",
        "unit",
        ____Boss_5355_4F4D
    )
    YDUserDataSetSafe(
        "string",
        "Boss战",
        "触发玩家",
        "unit",
        _____65BD_6CD5_5355_4F4D
    )
    YDUserDataSetSafe(
        "unit",
        ____Boss_5355_4F4D,
        "闪避率",
        "real",
        0.2
    )
    local _____65E7Boss_968F_4ECE = jglobals.gg_unit_n05Q_0003
    if _____65E7Boss_968F_4ECE ~= nil and _____65E7Boss_968F_4ECE ~= 0 then
        SetUnitOwner(
            _____65E7Boss_968F_4ECE,
            Player(5),
            true
        )
    end
    addDelayedCallback(3000, _____542F_52A8_65E7Boss_6218, {["Boss单位"] = ____Boss_5355_4F4D, ["触发单位"] = _____65BD_6CD5_5355_4F4D})
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9["提示文本"], 1500)
    return true
end
local function _____5904_7406_7269_54C1_5956_52B1(______73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    if _____8C03_67E5_70B9["奖励物品ID"] == nil or _____8C03_67E5_70B9["奖励物品ID"] == "" then
        return false
    end
    _____521B_5EFA_5E76_7ED9_4E88_7269_54C1(_____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9["奖励物品ID"])
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9["提示文本"], 3000)
    return true
end
local function _____53D6_65E7_73AF_5883_4E92_52A8_56DE_8C03(_____7C7B_578B)
    if _____7C7B_578B == "水触手" then
        return _____5904_7406_6C34_89E6_624B
    end
    if _____7C7B_578B == "书架" then
        return _____5904_7406_4E66_67B6
    end
    if _____7C7B_578B == "精灵小屋" then
        return _____5904_7406_7CBE_7075_5C0F_5C4B
    end
    if _____7C7B_578B == "空木桩" then
        return _____5904_7406_7A7A_6728_6869
    end
    if _____7C7B_578B == "树上物品" then
        return _____5904_7406_6811_4E0A_7269_54C1
    end
    if _____7C7B_578B == "隐藏木桩" then
        return _____5904_7406_9690_85CF_6728_6869
    end
    if _____7C7B_578B == "普通提示" then
        return _____5904_7406_666E_901A_63D0_793A
    end
    if _____7C7B_578B == "Boss入口" then
        return _____5904_7406Boss_5165_53E3
    end
    return _____5904_7406_7269_54C1_5956_52B1
end
____exports["注册旧环境互动调查点"] = function()
    do
        local i = 0
        while i < #_____65E7_73AF_5883_4E92_52A8_914D_7F6E_8868 do
            local _____914D_7F6E = _____65E7_73AF_5883_4E92_52A8_914D_7F6E_8868[i + 1]
            _____6CE8_9500_73AF_5883_4E92_52A8_8C03_67E5_70B9(_____914D_7F6E.ID)
            _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
                ID = _____914D_7F6E.ID,
                X = _____914D_7F6E.X,
                Y = _____914D_7F6E.Y,
                ["触发范围"] = _____914D_7F6E["触发范围"],
                ["一次性"] = _____914D_7F6E["一次性"],
                ["提示文本"] = _____914D_7F6E["提示文本"],
                ["延迟提示文本"] = _____914D_7F6E["延迟提示文本"],
                ["奖励物品ID"] = _____914D_7F6E["奖励物品ID"],
                ["触发回调"] = _____53D6_65E7_73AF_5883_4E92_52A8_56DE_8C03(_____914D_7F6E["类型"])
            })
            i = i + 1
        end
    end
end
return ____exports

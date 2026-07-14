local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____83AB_5C14_7279_65AF_8150_8D25_4E4B_6E90_6B7B_4EA1, _____83AB_5C14_7279_65AF_8150_8D25_4E4B_6E90_9500_6BC1, GetUnitX, GetUnitY, AddSpecialEffect
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.01．运行时上下文")
local _____589E_52A0_73A9_5BB6_8150_8D25_503C = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["增加玩家腐败值"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.02．数值与表现配置")
local _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯数值与表现配置"]
local _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯音效配置"]
local ____13_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.13．台词播放")
local _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD = ____13_FF0E_53F0_8BCD_64AD_653E["播放莫尔特斯台词"]
local ____16_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.16．公共工具")
local _____5355_4F4D_6709_6548 = ____16_FF0E_516C_5171_5DE5_5177["单位有效"]
local _____64AD_653E_83AB_5C14_7279_65AF_9650_65F6_52A8_4F5C = ____16_FF0E_516C_5171_5DE5_5177["播放莫尔特斯限时动作"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60 = ____00_FF0EBoss_97F3_6548_64AD_653E["尝试播放Boss拟声池"]
function _____83AB_5C14_7279_65AF_8150_8D25_4E4B_6E90_6B7B_4EA1(unit)
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["根系觉醒"]
    AddSpecialEffect(
        cfg["腐败之源摧毁特效路径"],
        GetUnitX(unit),
        GetUnitY(unit)
    )
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["根系觉醒"]["腐败之源摧毁"],
        GetUnitX(unit),
        GetUnitY(unit),
        _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
    )
end
function _____83AB_5C14_7279_65AF_8150_8D25_4E4B_6E90_9500_6BC1(unit)
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["根系觉醒"]
    AddSpecialEffect(
        cfg["腐败之源摧毁特效路径"],
        GetUnitX(unit),
        GetUnitY(unit)
    )
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["根系觉醒"]["腐败之源摧毁"],
        GetUnitX(unit),
        GetUnitY(unit),
        _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
    )
end
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_0["造成AOE技能伤害"]
local _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_0["创建独立技能伤害实例"]
local jass = require("jass.common")
local GetOwningPlayer = jass.GetOwningPlayer
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
AddSpecialEffect = jass.AddSpecialEffect
local GetRandomInt = jass.GetRandomInt
local ShowUnit = jass.ShowUnit
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.02．限时摧毁目标组")
local _____521B_5EFA_9650_65F6_6467_6BC1_76EE_6807_7EC4 = ____require_result_1["创建限时摧毁目标组"]
local ____require_result_2 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_2["获取Boss技能敌对英雄列表"]
local ____require_result_3 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_3["读取单位攻击力"]
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_4["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_4["移除单位暂停"]
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_5.addDelayedCallback
local _____83AB_5C14_7279_65AF_6839_7CFB_89C9_9192_6682_505C_6765_6E90 = "Boss:Moltes:根系觉醒"
local function _____5EF6_8FDF_9690_85CF_6839_7CFB_89C9_9192Boss(context)
    if context["腐败之源组"] ~= nil and _____5355_4F4D_6709_6548(context["Boss单位"]) then
        ShowUnit(context["Boss单位"], false)
    end
end
local function _____6CBB_7597Boss_6700_5927_751F_547D_6BD4_4F8B(boss, ratio)
    if not _____5355_4F4D_6709_6548(boss) or not (ratio > 0) then
        return
    end
    local maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE)
    local life = GetUnitState(boss, UNIT_STATE_LIFE)
    local next = life + maxLife * ratio
    SetUnitState(boss, UNIT_STATE_LIFE, next > maxLife and maxLife or next)
end
local function _____9009_62E9_8150_8D25_4E4B_6E90_683C_5B50(context)
    local result = {}
    local grid = context["根须宫格"]
    if grid == nil then
        return result
    end
    local pool = {}
    do
        local i = 0
        while i < grid["格子列表"].length do
            pool[#pool + 1] = grid["格子列表"][i]
            i = i + 1
        end
    end
    local count = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["根系觉醒"]["腐败之源数量"]
    do
        local i = 0
        while i < count and #pool > 0 do
            local index = GetRandomInt(0, #pool - 1)
            result[#result + 1] = pool[index + 1]
            __TS__ArraySplice(pool, index, 1)
            i = i + 1
        end
    end
    return result
end
local function _____6839_7CFB_89C9_9192_5931_8D25_7206_53D1(context)
    local boss = context["Boss单位"]
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["根系觉醒"]
    _____6CBB_7597Boss_6700_5927_751F_547D_6BD4_4F8B(boss, cfg["失败回血比例"])
    AddSpecialEffect(
        cfg["全屏爆发特效路径"],
        GetUnitX(boss),
        GetUnitY(boss)
    )
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["根系觉醒"]["失败爆发"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    local _____6280_80FD_5B9E_4F8BID = _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B({["来源类型"] = "Boss技能", ["标签"] = "莫尔特斯根系觉醒", ["持续时间秒"] = 2})
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["全屏爆发伤害Boss攻击力比例"]
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue14
                end
                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["来源"] = boss,
                    ["目标"] = hero,
                    ["伤害"] = damage,
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_PLANT,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "Boss技能",
                    ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
                    ["标签"] = "莫尔特斯根系觉醒"
                })
                _____589E_52A0_73A9_5BB6_8150_8D25_503C(context, hero, cfg["全屏爆发腐败值"])
            end
            ::__continue14::
            i = i + 1
        end
    end
end
local function _____521B_5EFA_8150_8D25_4E4B_6E90_76EE_6807_5217_8868(context)
    local boss = context["Boss单位"]
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["根系觉醒"]
    local cells = _____9009_62E9_8150_8D25_4E4B_6E90_683C_5B50(context)
    local targets = {}
    do
        local i = 0
        while i < #cells do
            local cell = cells[i + 1]
            targets[#targets + 1] = {
                ["清理"] = context["清理"],
                ["名称"] = "莫尔特斯-腐败之源",
                ["主人单位"] = boss,
                ["所属玩家"] = GetOwningPlayer(boss),
                ["单位类型"] = cfg["腐败之源单位类型"],
                ["模型路径"] = cfg["腐败之源模型路径"],
                X = cell["中心X"],
                Y = cell["中心Y"],
                ["最大生命"] = cfg["腐败之源生命值"],
                ["缩放"] = cfg["腐败之源缩放"],
                ["on死亡"] = _____83AB_5C14_7279_65AF_8150_8D25_4E4B_6E90_6B7B_4EA1,
                ["on销毁"] = _____83AB_5C14_7279_65AF_8150_8D25_4E4B_6E90_9500_6BC1
            }
            local circle = AddSpecialEffect(cfg["腐败之源脚下特效路径"], cell["中心X"], cell["中心Y"])
            local ____self_6 = context["清理"]
            ____self_6["登记特效"](____self_6, "莫尔特斯-腐败之源脚下圈", circle)
            i = i + 1
        end
    end
    return targets
end
local function _____83AB_5C14_7279_65AF_6839_7CFB_89C9_9192_8D85_65F6(______5269_4F59_6570_91CF, context)
    _____6839_7CFB_89C9_9192_5931_8D25_7206_53D1(context)
end
local function _____83AB_5C14_7279_65AF_6839_7CFB_89C9_9192_7ED3_675F(______662F_5426_6210_529F, ______5269_4F59_6570_91CF, context)
    if _____5355_4F4D_6709_6548(context["Boss单位"]) then
        ShowUnit(context["Boss单位"], true)
        _____79FB_9664_5355_4F4D_6682_505C(context["Boss单位"], _____83AB_5C14_7279_65AF_6839_7CFB_89C9_9192_6682_505C_6765_6E90)
    end
    context["腐败之源组"] = nil
end
____exports["尝试触发莫尔特斯根系觉醒"] = function(context)
    if context["根系觉醒已触发"] or context["阶段"] < 2 or not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return
    end
    context["根系觉醒已触发"] = true
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["根系觉醒"]
    _____64AD_653E_83AB_5C14_7279_65AF_9650_65F6_52A8_4F5C(context["Boss单位"], cfg["动画编号"], cfg["动画速度"], cfg["动作播放秒"])
    _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD(context["Boss单位"], "根系觉醒")
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["根系觉醒"]["机制开始"],
        GetUnitX(context["Boss单位"]),
        GetUnitY(context["Boss单位"]),
        _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60({
        ["标识"] = _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["怪物拟声"]["标识"],
        ["音效路径列表"] = _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["怪物拟声"]["音效路径列表"],
        X = GetUnitX(context["Boss单位"]),
        Y = GetUnitY(context["Boss单位"]),
        ["裁断距离"] = _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["默认裁断距离"],
        ["冷却Ms"] = _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["怪物拟声"]["冷却Ms"],
        ["触发概率百分比"] = _____83AB_5C14_7279_65AF_97F3_6548_914D_7F6E["怪物拟声"]["转阶段触发概率百分比"]
    })
    _____6DFB_52A0_5355_4F4D_6682_505C(context["Boss单位"], _____83AB_5C14_7279_65AF_6839_7CFB_89C9_9192_6682_505C_6765_6E90)
    context["腐败之源组"] = _____521B_5EFA_9650_65F6_6467_6BC1_76EE_6807_7EC4({
        ["清理"] = context["清理"],
        ["名称"] = "莫尔特斯-根系觉醒",
        ["持续秒"] = cfg["限时秒"],
        ["目标列表"] = _____521B_5EFA_8150_8D25_4E4B_6E90_76EE_6807_5217_8868(context),
        ["变量"] = context,
        ["on超时"] = _____83AB_5C14_7279_65AF_6839_7CFB_89C9_9192_8D85_65F6,
        ["on结束"] = _____83AB_5C14_7279_65AF_6839_7CFB_89C9_9192_7ED3_675F
    })
    local hideId = addDelayedCallback(cfg["显形动作秒"] * 1000, _____5EF6_8FDF_9690_85CF_6839_7CFB_89C9_9192Boss, context)
    local ____self_7 = context["清理"]
    ____self_7["登记延迟回调"](____self_7, "莫尔特斯-根系觉醒显形动作", hideId)
end
____exports["注册莫尔特斯根系觉醒"] = function()
end
return ____exports

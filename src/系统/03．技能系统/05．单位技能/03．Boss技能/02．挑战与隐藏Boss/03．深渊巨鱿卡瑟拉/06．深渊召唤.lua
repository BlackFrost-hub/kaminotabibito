--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.01．运行时上下文")
local _____589E_52A0_73A9_5BB6_89E6_624B_6B8B_7247 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["增加玩家触手残片"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.02．数值与表现配置")
local _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["卡瑟拉数值与表现配置"]
local _____5361_745F_62C9_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["卡瑟拉音效配置"]
local ____11_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.11．台词播放")
local _____64AD_653E_5361_745F_62C9_53F0_8BCD = ____11_FF0E_53F0_8BCD_64AD_653E["播放卡瑟拉台词"]
local ____14_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.14．公共工具")
local _____5355_4F4D_6709_6548 = ____14_FF0E_516C_5171_5DE5_5177["单位有效"]
local _____6781_5750_6807X = ____14_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____14_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local _____64AD_653E_5361_745F_62C9_9650_65F6_52A8_4F5C = ____14_FF0E_516C_5171_5DE5_5177["播放卡瑟拉限时动作"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60 = ____00_FF0EBoss_97F3_6548_64AD_653E["尝试播放Boss拟声池"]
local ____require_result_0 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_0.doHeal
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitState = jass.GetUnitState
local GetRandomReal = jass.GetRandomReal
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____require_result_2["创建可攻击机制单位"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容")
local _____4E34_65F6_8C03_6574_653B_51FB = ____require_result_3["临时调整攻击"]
local function _____6CBB_7597Boss_6700_5927_751F_547D_6BD4_4F8B(boss, ratio)
    if not _____5355_4F4D_6709_6548(boss) or not (ratio > 0) then
        return
    end
    doHeal({
        HealSource = boss,
        HealTarget = boss,
        HealAmount = GetUnitState(boss, UNIT_STATE_MAX_LIFE) * ratio,
        ItemHeal = false,
        HealEffect = false
    })
end
local function _____5E7C_9C7F_6B7B_4EA1_6389_843D_6B8B_7247(context, killer)
    if not _____5355_4F4D_6709_6548(killer) then
        return
    end
    local chance = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手鞭笞"]["触手残片掉落概率"]
    if GetRandomReal(0, 1) <= chance then
        _____589E_52A0_73A9_5BB6_89E6_624B_6B8B_7247(context, killer, 1)
    end
end
local function _____521B_5EFA_6DF1_6E0A_5E7C_9C7F(context, angle)
    local boss = context["Boss单位"]
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["深渊召唤"]
    local x = _____6781_5750_6807X(
        GetUnitX(boss),
        angle,
        480
    )
    local y = _____6781_5750_6807Y(
        GetUnitY(boss),
        angle,
        480
    )
    local instance = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = context["清理"],
        ["名称"] = "卡瑟拉-深渊幼鱿",
        ["主人单位"] = boss,
        ["所属玩家"] = GetOwningPlayer(boss),
        ["单位类型"] = cfg["幼鱿单位类型"],
        ["模型路径"] = cfg["幼鱿模型路径"],
        X = x,
        Y = y,
        ["朝向"] = angle + 180,
        ["最大生命"] = cfg["幼鱿生命值"],
        ["缩放"] = cfg["幼鱿缩放"],
        ["持续时间"] = cfg["吞噬等待秒"] + 2,
        ["on死亡"] = function(_unit, killer)
            _____5E7C_9C7F_6B7B_4EA1_6389_843D_6B8B_7247(context, killer)
        end
    })
    if instance == nil or not _____5355_4F4D_6709_6548(instance["单位"]) then
        return
    end
    _____4E34_65F6_8C03_6574_653B_51FB(instance["单位"], cfg["幼鱿攻击力"])
    local id = addDelayedCallback(
        cfg["吞噬等待秒"] * 1000,
        function()
            if not _____5355_4F4D_6709_6548(boss) or not instance["是否存活"](instance) then
                return
            end
            instance["销毁"](instance)
            _____6CBB_7597Boss_6700_5927_751F_547D_6BD4_4F8B(boss, cfg["吞噬回血比例"])
        end
    )
    local ____self_4 = context["清理"]
    ____self_4["登记延迟回调"](____self_4, "卡瑟拉-深渊幼鱿吞噬", id)
end
____exports["释放卡瑟拉深渊召唤"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["Boss潜入中"] then
        return
    end
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["深渊召唤"]
    _____64AD_653E_5361_745F_62C9_9650_65F6_52A8_4F5C(boss, cfg["动画编号"], cfg["动画速度"], cfg["动作原始时长秒"])
    _____64AD_653E_5361_745F_62C9_53F0_8BCD(boss, "深渊召唤")
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____5361_745F_62C9_97F3_6548_914D_7F6E["深渊召唤"]["幼鱿入场"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____5361_745F_62C9_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60({
        ["标识"] = _____5361_745F_62C9_97F3_6548_914D_7F6E["怪物拟声"]["标识"],
        ["音效路径列表"] = _____5361_745F_62C9_97F3_6548_914D_7F6E["怪物拟声"]["音效路径列表"],
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        ["裁断距离"] = _____5361_745F_62C9_97F3_6548_914D_7F6E["默认裁断距离"],
        ["冷却Ms"] = _____5361_745F_62C9_97F3_6548_914D_7F6E["怪物拟声"]["冷却Ms"],
        ["触发概率百分比"] = _____5361_745F_62C9_97F3_6548_914D_7F6E["怪物拟声"]["关键机制触发概率百分比"]
    })
    do
        local i = 0
        while i < cfg["幼鱿数量"] do
            _____521B_5EFA_6DF1_6E0A_5E7C_9C7F(context, i * 120)
            i = i + 1
        end
    end
end
return ____exports

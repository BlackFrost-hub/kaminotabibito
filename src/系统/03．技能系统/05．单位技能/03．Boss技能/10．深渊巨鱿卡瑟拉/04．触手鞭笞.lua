--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.00．配置")
local _____5361_745F_62C9_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["卡瑟拉单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建卡瑟拉上下文"]
local _____589E_52A0_73A9_5BB6_89E6_624B_6B8B_7247 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["增加玩家触手残片"]
local _____53D6_73A9_5BB6_89E6_624B_6B8B_7247 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["取玩家触手残片"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.02．数值与表现配置")
local _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["卡瑟拉数值与表现配置"]
local ____11_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.11．台词播放")
local _____64AD_653E_5361_745F_62C9_53F0_8BCD = ____11_FF0E_53F0_8BCD_64AD_653E["播放卡瑟拉台词"]
local ____14_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.14．公共工具")
local _____5355_4F4D_6709_6548 = ____14_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____14_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____6781_5750_6807X = ____14_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____14_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local GetRandomReal = jass.GetRandomReal
local UnitDamageTarget = jass.UnitDamageTarget
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_0["读取单位攻击力"]
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_1.registerSpellEffectListener
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local addPeriodicCallback = ____require_result_2.addPeriodicCallback
local removePeriodicCallback = ____require_result_2.removePeriodicCallback
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_3["创建技能提示圈"]
local ____require_result_4 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_4["获取Boss技能敌对英雄列表"]
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_4["获取Boss技能随机敌对英雄"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____require_result_5["创建可攻击机制单位"]
local ____require_result_6 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_6.registerManualBuff
local ____require_result_7 = require("系统.05．Buff系统.03．Buff表.01．Boss.08．卡瑟拉")
local _____5361_745F_62C9BuffID = ____require_result_7["卡瑟拉BuffID"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_5FEB_901F_51CF_901FBuff = ____require_result_8["施加快速减速Buff"]
local _____5361_745F_62C9_5355_4F4D_7C7B_578BID = stringToFourCC(_____5361_745F_62C9_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____89E6_624B_97AD_7B1E_6280_80FDID = stringToFourCC(_____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手鞭笞"]["技能槽位"])
local _____5DF2_6CE8_518C = false
local function _____9009_62E9_89E6_624B_97AD_7B1E_76EE_6807(context)
    local boss = context["Boss单位"]
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local best = nil
    local bestScore = -1
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue4
                end
                local score = _____53D6_73A9_5BB6_89E6_624B_6B8B_7247(context, hero) * 10 + GetRandomReal(0, 10)
                if score > bestScore then
                    bestScore = score
                    best = hero
                end
            end
            ::__continue4::
            i = i + 1
        end
    end
    local _____5355_4F4D_6709_6548_result_9
    if _____5355_4F4D_6709_6548(best) then
        _____5355_4F4D_6709_6548_result_9 = best
    else
        _____5355_4F4D_6709_6548_result_9 = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss, boss, 2000)
    end
    return _____5355_4F4D_6709_6548_result_9
end
local function _____6389_843D_89E6_624B_6B8B_7247_7ED9_51FB_6740_8005(context, killer)
    if not _____5355_4F4D_6709_6548(killer) then
        return
    end
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手鞭笞"]
    if GetRandomReal(0, 1) > cfg["触手残片掉落概率"] then
        return
    end
    local next = _____589E_52A0_73A9_5BB6_89E6_624B_6B8B_7247(context, killer, 1)
    if next > _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手残片"]["大于数量时恢复已损生命"] then
        local maxLife = GetUnitState(killer, UNIT_STATE_MAX_LIFE)
        local life = GetUnitState(killer, UNIT_STATE_LIFE)
        local heal = (maxLife - life) * _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手残片"]["已损生命恢复比例"]
        if heal > 0 then
            SetUnitState(killer, UNIT_STATE_LIFE, life + heal > maxLife and maxLife or life + heal)
        end
    end
end
local function _____89E6_624B_97AD_7B1E_4E00_8DF3(data)
    local context = data.context
    local boss = context["Boss单位"]
    local target = data["目标"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(data["触手单位"]) or not _____5355_4F4D_6709_6548(target) or data["剩余跳数"] <= 0 then
        removePeriodicCallback(data["周期ID"])
        return
    end
    data["剩余跳数"] = data["剩余跳数"] - 1
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手鞭笞"]
    local dx = GetUnitX(target) - GetUnitX(data["触手单位"])
    local dy = GetUnitY(target) - GetUnitY(data["触手单位"])
    if dx * dx + dy * dy > cfg["触手攻击半径"] * cfg["触手攻击半径"] then
        return
    end
    UnitDamageTarget(
        boss,
        target,
        _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["触手Boss攻击力比例"],
        true,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_NORMAL,
        WEAPON_TYPE_WHOKNOWS
    )
    _____65BD_52A0_5FEB_901F_51CF_901FBuff(
        boss,
        target,
        cfg["缠绕减速比例"],
        cfg["缠绕减速比例"],
        cfg["缠绕持续秒"]
    )
    registerManualBuff(
        target,
        _____5361_745F_62C9BuffID["触手缠绕"],
        cfg["缠绕持续秒"],
        cfg["缠绕减速比例"],
        {sourceName = "卡瑟拉-触手缠绕"}
    )
end
local function _____521B_5EFA_5355_6761_89E6_624B(context, target, x, y)
    local boss = context["Boss单位"]
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手鞭笞"]
    local instance = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = context["清理"],
        ["名称"] = "卡瑟拉-鞭笞触手",
        ["主人单位"] = boss,
        ["所属玩家"] = GetOwningPlayer(boss),
        ["单位类型"] = "hfoo",
        ["模型路径"] = cfg["触手模型路径"],
        X = x,
        Y = y,
        ["朝向"] = 0,
        ["最大生命"] = cfg["触手生命值"],
        ["缩放"] = cfg["触手缩放"],
        ["持续时间"] = cfg["触手持续秒"],
        ["on死亡"] = function(_unit, killer)
            _____6389_843D_89E6_624B_6B8B_7247_7ED9_51FB_6740_8005(context, killer)
        end
    })
    if instance == nil or not _____5355_4F4D_6709_6548(instance["单位"]) then
        return
    end
    local data = {
        context = context,
        ["触手单位"] = instance["单位"],
        ["目标"] = target,
        ["剩余跳数"] = cfg["触手持续秒"] / cfg["触手攻击间隔秒"],
        ["周期ID"] = 0
    }
    data["周期ID"] = addPeriodicCallback(
        cfg["触手攻击间隔秒"] * 1000,
        function()
            _____89E6_624B_97AD_7B1E_4E00_8DF3(data)
        end
    )
    local ____self_10 = context["清理"]
    ____self_10["登记周期回调"](____self_10, "卡瑟拉-触手鞭笞周期", data["周期ID"])
end
local function _____91CA_653E_89E6_624B_56F4_653B(context, target)
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手鞭笞"]
    local cx = GetUnitX(target)
    local cy = GetUnitY(target)
    do
        local i = 0
        while i < cfg["触手数量"] do
            local angle = i * 120
            _____521B_5EFA_5355_6761_89E6_624B(
                context,
                target,
                _____6781_5750_6807X(cx, angle, cfg["触手半径"]),
                _____6781_5750_6807Y(cy, angle, cfg["触手半径"])
            )
            i = i + 1
        end
    end
end
local function _____91CA_653E_5361_745F_62C9_89E6_624B_97AD_7B1E(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local target = _____9009_62E9_89E6_624B_97AD_7B1E_76EE_6807(context)
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手鞭笞"]
    _____64AD_653E_5361_745F_62C9_53F0_8BCD(boss, "触手鞭笞")
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "圆形",
        X = GetUnitX(target),
        Y = GetUnitY(target),
        ["半径"] = cfg["触手半径"] + 120,
        ["持续时间"] = cfg["延迟秒"],
        ["来源单位"] = boss
    })
    local id = addDelayedCallback(
        cfg["延迟秒"] * 1000,
        function()
            if _____5355_4F4D_6709_6548(target) then
                _____91CA_653E_89E6_624B_56F4_653B(context, target)
            end
        end
    )
    local ____self_11 = context["清理"]
    ____self_11["登记延迟回调"](____self_11, "卡瑟拉-触手鞭笞围攻", id)
end
local function ____on_5361_745F_62C9_89E6_624B_97AD_7B1E_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____89E6_624B_97AD_7B1E_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____5361_745F_62C9_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    _____91CA_653E_5361_745F_62C9_89E6_624B_97AD_7B1E(context)
end
____exports["注册卡瑟拉触手鞭笞"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    registerSpellEffectListener(____on_5361_745F_62C9_89E6_624B_97AD_7B1E_65BD_6CD5)
end
return ____exports

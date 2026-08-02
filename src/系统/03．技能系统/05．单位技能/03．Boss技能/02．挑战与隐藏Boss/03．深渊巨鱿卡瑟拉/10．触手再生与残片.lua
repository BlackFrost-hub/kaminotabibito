local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.01．运行时上下文")
local _____83B7_53D6_5168_90E8_5361_745F_62C9_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部卡瑟拉上下文"]
local _____6E05_7406_5361_745F_62C9_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["清理卡瑟拉上下文"]
local _____8BBE_7F6E_73A9_5BB6_89E6_624B_6B8B_7247 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["设置玩家触手残片"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.02．数值与表现配置")
local _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["卡瑟拉数值与表现配置"]
local ____06_FF0E_6DF1_6E0A_53EC_5524 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.06．深渊召唤")
local _____91CA_653E_5361_745F_62C9_6DF1_6E0A_53EC_5524 = ____06_FF0E_6DF1_6E0A_53EC_5524["释放卡瑟拉深渊召唤"]
local ____09_FF0E_5171_751F_7535_51FB = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.09．共生电击")
local _____91CA_653E_5361_745F_62C9_5171_751F_7535_51FB = ____09_FF0E_5171_751F_7535_51FB["释放卡瑟拉共生电击"]
local ____14_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.14．公共工具")
local _____5355_4F4D_6709_6548 = ____14_FF0E_516C_5171_5DE5_5177["单位有效"]
local _____6781_5750_6807X = ____14_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____14_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local _____8DDD_79BBXY = ____14_FF0E_516C_5171_5DE5_5177["距离XY"]
local _____53D6_5750_6807_89D2_5EA6 = ____14_FF0E_516C_5171_5DE5_5177["取坐标角度"]
local ____11_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.11．台词播放")
local _____64AD_653E_5361_745F_62C9_53F0_8BCD = ____11_FF0E_53F0_8BCD_64AD_653E["播放卡瑟拉台词"]
local ____17_FF0E_5468_671F_673A_5236_8C03_5EA6_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.17．周期机制调度器")
local _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668 = ____17_FF0E_5468_671F_673A_5236_8C03_5EA6_5668["创建周期机制调度器"]
local ____22_FF0E_9650_6B21_5468_671F_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.22．限次周期执行器")
local _____521B_5EFA_9650_6B21_5468_671F_6267_884C_5668 = ____22_FF0E_9650_6B21_5468_671F_6267_884C_5668["创建限次周期执行器"]
local ____01_FF0E_6218_6597_6280_80FD_8C03_5EA6_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.13．战斗技能调度模板.01．战斗技能调度模板")
local _____521B_5EFA_6218_6597_6280_80FD_8C03_5EA6_5668 = ____01_FF0E_6218_6597_6280_80FD_8C03_5EA6_6A21_677F["创建战斗技能调度器"]
local ____01_FF0E_8840_91CF_8282_70B9_89E6_53D1_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.01．血量节点触发器")
local _____521B_5EFA_8840_91CF_8282_70B9_89E6_53D1_5668 = ____01_FF0E_8840_91CF_8282_70B9_89E6_53D1_5668["创建血量节点触发器"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____53D6_5355_4F4DID = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["取单位ID"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行Boss单体技能伤害"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitState = jass.GetUnitState
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
local _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____require_result_2["创建可攻击机制单位"]
local ____require_result_3 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_3["读取单位攻击力"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容")
local _____4E34_65F6_8C03_6574_653B_51FB = ____require_result_4["临时调整攻击"]
local ____require_result_5 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_5.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_5["移除单位指定Buff"]
local ____require_result_6 = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.02．卡瑟拉")
local _____5361_745F_62C9BuffID = ____require_result_6["卡瑟拉BuffID"]
local ____require_result_7 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_7.doHeal
local _____5DF2_6CE8_518C = false
local function _____6CBB_7597Boss_56FA_5B9A_503C(boss, amount)
    if not _____5355_4F4D_6709_6548(boss) or not (amount > 0) then
        return
    end
    doHeal({
        HealSource = boss,
        HealTarget = boss,
        HealAmount = amount,
        ItemHeal = false,
        HealEffect = false
    })
end
local function _____9009_62E9_6700_4F4E_751F_547D_73A9_5BB6(boss)
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local best = nil
    local bestRatio = 2
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue6
                end
                local maxLife = GetUnitStateJapi(hero, UNIT_STATE_MAX_LIFE)
                if not (maxLife > 0) then
                    goto __continue6
                end
                local ratio = GetUnitState(hero, UNIT_STATE_LIFE) / maxLife
                if ratio < bestRatio then
                    bestRatio = ratio
                    best = hero
                end
            end
            ::__continue6::
            i = i + 1
        end
    end
    return best
end
local function _____521B_5EFA_5730_9762_89E6_624B_6B8B_7247(context, x, y)
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手残片"]
    local effect = AddSpecialEffect(cfg["地面模型路径"], x, y)
    local ____context__573A_4E0A_89E6_624B_6B8B_7247_5217_8868_8 = context["场上触手残片列表"]
    ____context__573A_4E0A_89E6_624B_6B8B_7247_5217_8868_8[#____context__573A_4E0A_89E6_624B_6B8B_7247_5217_8868_8 + 1] = {X = x, Y = y, ["特效"] = effect, ["已吸收"] = false}
end
local function _____7ED3_7B97_518D_751F_89E6_624B_4E00_8DF3(data)
    local context = data.context
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(data["触手单位"]) then
        return false
    end
    local target = _____9009_62E9_6700_4F4E_751F_547D_73A9_5BB6(boss)
    if not _____5355_4F4D_6709_6548(target) then
        return true
    end
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手残片"]
    if _____8DDD_79BBXY(
        GetUnitX(data["触手单位"]),
        GetUnitY(data["触手单位"]),
        GetUnitX(target),
        GetUnitY(target)
    ) > cfg["再生触手攻击半径"] then
        return true
    end
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["再生触手Boss攻击力比例"]
    _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = boss,
        ["目标"] = target,
        ["伤害公式"] = {["来源攻击力比例"] = cfg["再生触手Boss攻击力比例"]},
        attack = true,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["标签"] = "卡瑟拉触手再生"
    })
    _____6CBB_7597Boss_56FA_5B9A_503C(boss, damage * cfg["再生触手吸血比例"])
    return true
end
local function _____751F_6210_518D_751F_89E6_624B(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["Boss潜入中"] then
        return
    end
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手残片"]
    local angle = _____53D6_5750_6807_89D2_5EA6(
        0,
        0,
        GetUnitX(boss),
        GetUnitY(boss)
    )
    local x = _____6781_5750_6807X(
        GetUnitX(boss),
        angle,
        520
    )
    local y = _____6781_5750_6807Y(
        GetUnitY(boss),
        angle,
        520
    )
    local instance = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = context["清理"],
        ["名称"] = "卡瑟拉-再生触手",
        ["主人单位"] = boss,
        ["所属玩家"] = GetOwningPlayer(boss),
        ["单位类型"] = "hfoo",
        ["模型路径"] = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手解放"]["巨型触手模型路径"],
        X = x,
        Y = y,
        ["朝向"] = angle + 180,
        ["最大生命"] = cfg["再生触手生命值"],
        ["缩放"] = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手鞭笞"]["触手缩放"],
        ["持续时间"] = cfg["再生触手持续秒"],
        ["on死亡"] = function(unit)
            _____521B_5EFA_5730_9762_89E6_624B_6B8B_7247(
                context,
                GetUnitX(unit),
                GetUnitY(unit)
            )
        end
    })
    if instance == nil or not _____5355_4F4D_6709_6548(instance["单位"]) then
        return
    end
    _____64AD_653E_5361_745F_62C9_53F0_8BCD(boss, "触手再生")
    local data = {context = context, ["触手单位"] = instance["单位"]}
    data["周期"] = _____521B_5EFA_9650_6B21_5468_671F_6267_884C_5668({
        ["名称"] = "卡瑟拉-再生触手周期",
        ["间隔毫秒"] = cfg["再生触手攻击间隔秒"] * 1000,
        ["最大执行次数"] = cfg["再生触手持续秒"] / cfg["再生触手攻击间隔秒"],
        ["清理"] = context["清理"],
        onTick = function()
            return _____7ED3_7B97_518D_751F_89E6_624B_4E00_8DF3(data)
        end
    })
end
local function _____786E_4FDD_89E6_624B_518D_751F_8840_91CF_8282_70B9(context)
    if context["触手再生节点已注册"] then
        return
    end
    context["触手再生节点已注册"] = true
    local _____8282_70B9_5217_8868 = {}
    do
        local _____6863_4F4D = 5
        while _____6863_4F4D >= 1 do
            _____8282_70B9_5217_8868[#_____8282_70B9_5217_8868 + 1] = {
                ID = ("触手再生-" .. tostring(_____6863_4F4D)) .. "0%",
                ["百分比"] = _____6863_4F4D * 0.1,
                ["on触发"] = function()
                    _____751F_6210_518D_751F_89E6_624B(context)
                end
            }
            _____6863_4F4D = _____6863_4F4D - 1
        end
    end
    _____521B_5EFA_8840_91CF_8282_70B9_89E6_53D1_5668({
        ["清理"] = context["清理"],
        ["名称"] = "卡瑟拉-触手再生节点",
        ["单位"] = context["Boss单位"],
        ["节点列表"] = _____8282_70B9_5217_8868,
        ["Tick间隔毫秒"] = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["运行时"]["推进间隔毫秒"]
    })
end
local function _____79FB_52A8_5355_4E2A_5730_9762_6B8B_7247(context, fragment)
    if fragment["已吸收"] then
        return false
    end
    local boss = context["Boss单位"]
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手残片"]
    local bx = GetUnitX(boss)
    local by = GetUnitY(boss)
    local dist = _____8DDD_79BBXY(fragment.X, fragment.Y, bx, by)
    if dist <= cfg["吸引距离"] then
        fragment["已吸收"] = true
        if fragment["特效"] ~= nil then
            DestroyEffect(fragment["特效"])
        end
        return true
    end
    local angle = _____53D6_5750_6807_89D2_5EA6(fragment.X, fragment.Y, bx, by)
    if fragment["特效"] ~= nil then
        DestroyEffect(fragment["特效"])
    end
    fragment.X = _____6781_5750_6807X(fragment.X, angle, cfg["吸引距离"])
    fragment.Y = _____6781_5750_6807Y(fragment.Y, angle, cfg["吸引距离"])
    fragment["特效"] = AddSpecialEffect(cfg["地面模型路径"], fragment.X, fragment.Y)
    return false
end
local function _____7275_5F15_5730_9762_89E6_624B_6B8B_7247(context)
    local absorbed = 0
    local index = 0
    while index < #context["场上触手残片列表"] do
        do
            local fragment = context["场上触手残片列表"][index + 1]
            if _____79FB_52A8_5355_4E2A_5730_9762_6B8B_7247(context, fragment) then
                __TS__ArraySplice(context["场上触手残片列表"], index, 1)
                absorbed = absorbed + 1
                goto __continue31
            end
            index = index + 1
        end
        ::__continue31::
    end
    return absorbed
end
local function _____5438_6536_73A9_5BB6_89E6_624B_6B8B_7247(context)
    local count = 0
    for key in pairs(context["玩家触手残片表"]) do
        do
            local current = context["玩家触手残片表"][key] or 0
            if current <= 0 or current >= 4 then
                goto __continue34
            end
            local unit = context["玩家触手残片单位表"][key]
            if unit == nil or unit == 0 then
                goto __continue34
            end
            count = count + current
            _____8BBE_7F6E_73A9_5BB6_89E6_624B_6B8B_7247(context, unit, 0)
        end
        ::__continue34::
    end
    return count
end
local function _____5E94_7528_89E6_624B_7CBE_534E(context, count)
    if count <= 0 then
        return
    end
    local boss = context["Boss单位"]
    local cfg = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手残片"]
    local maxLife = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE)
    _____6CBB_7597Boss_56FA_5B9A_503C(boss, maxLife * cfg["Boss每片回血比例"] * count)
    context["触手精华层数"] = context["触手精华层数"] + count
    local attackBonus = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["精华每层攻击加成"] * count
    if attackBonus > 0 then
        _____4E34_65F6_8C03_6574_653B_51FB(boss, attackBonus)
        local id = addDelayedCallback(
            cfg["精华持续秒"] * 1000,
            function()
                if not _____5355_4F4D_6709_6548(boss) then
                    return
                end
                _____4E34_65F6_8C03_6574_653B_51FB(boss, -attackBonus)
                context["触手精华层数"] = context["触手精华层数"] - count
                if context["触手精华层数"] > 0 then
                    registerManualBuff(
                        boss,
                        _____5361_745F_62C9BuffID["触手精华"],
                        cfg["精华持续秒"],
                        context["触手精华层数"],
                        {stack = context["触手精华层数"], sourceName = "卡瑟拉-触手精华"}
                    )
                else
                    context["触手精华层数"] = 0
                    _____79FB_9664_5355_4F4D_6307_5B9ABuff(boss, _____5361_745F_62C9BuffID["触手精华"])
                end
            end
        )
        local ____self_9 = context["清理"]
        ____self_9["登记延迟回调"](____self_9, "卡瑟拉-触手精华攻击回滚", id)
    end
    registerManualBuff(
        boss,
        _____5361_745F_62C9BuffID["触手精华"],
        cfg["精华持续秒"],
        context["触手精华层数"],
        {stack = context["触手精华层数"], sourceName = "卡瑟拉-触手精华"}
    )
end
local function _____5904_7406_5730_9762_6B8B_7247_7275_5F15(context)
    local groundAbsorbed = _____7275_5F15_5730_9762_89E6_624B_6B8B_7247(context)
    if groundAbsorbed > 0 then
        _____5E94_7528_89E6_624B_7CBE_534E(context, groundAbsorbed)
        _____64AD_653E_5361_745F_62C9_53F0_8BCD(context["Boss单位"], "触手残片回收")
    end
end
local function _____5904_7406_73A9_5BB6_6B8B_7247_5438_6536(context)
    local absorbed = _____5438_6536_73A9_5BB6_89E6_624B_6B8B_7247(context)
    if absorbed <= 0 then
        return
    end
    _____5E94_7528_89E6_624B_7CBE_534E(context, absorbed)
    _____64AD_653E_5361_745F_62C9_53F0_8BCD(context["Boss单位"], "触手残片吸收")
end
local function _____53D6_5361_745F_62C9_4E0A_4E0B_6587_952E(context)
    return _____53D6_5355_4F4DID(context["Boss单位"])
end
local function _____53EF_8C03_5EA6_5361_745F_62C9_6DF1_6E0A_53EC_5524(context)
    return _____5355_4F4D_6709_6548(context["Boss单位"]) and context["阶段"] >= 2 and not context["Boss潜入中"]
end
local function _____6267_884C_5361_745F_62C9_6DF1_6E0A_53EC_5524(context)
    _____91CA_653E_5361_745F_62C9_6DF1_6E0A_53EC_5524(context)
    return true
end
local function _____53EF_8C03_5EA6_5361_745F_62C9_5171_751F_7535_51FB(context)
    return _____5355_4F4D_6709_6548(context["Boss单位"]) and context["阶段"] >= 3 and not context["Boss潜入中"]
end
local function ____on_5361_745F_62C9_8FD0_884C_65F6_7EF4_62A4(context)
    if not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        _____6E05_7406_5361_745F_62C9_4E0A_4E0B_6587(context["Boss单位"])
        return
    end
    _____786E_4FDD_89E6_624B_518D_751F_8840_91CF_8282_70B9(context)
end
____exports["注册卡瑟拉触手再生与残片"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668({["名称"] = "卡瑟拉-运行时维护", ["间隔毫秒"] = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["运行时"]["推进间隔毫秒"], ["取上下文列表"] = _____83B7_53D6_5168_90E8_5361_745F_62C9_4E0A_4E0B_6587, ["执行"] = ____on_5361_745F_62C9_8FD0_884C_65F6_7EF4_62A4})
    _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668({
        ["名称"] = "卡瑟拉-地面残片牵引",
        ["间隔毫秒"] = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手残片"]["吸引间隔秒"] * 1000,
        ["取上下文列表"] = _____83B7_53D6_5168_90E8_5361_745F_62C9_4E0A_4E0B_6587,
        ["可执行"] = function(context)
            return _____5355_4F4D_6709_6548(context["Boss单位"]) and #context["场上触手残片列表"] > 0
        end,
        ["执行"] = _____5904_7406_5730_9762_6B8B_7247_7275_5F15
    })
    _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668({
        ["名称"] = "卡瑟拉-玩家残片吸收",
        ["间隔毫秒"] = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["触手残片"]["Boss吸收间隔秒"] * 1000,
        ["取上下文列表"] = _____83B7_53D6_5168_90E8_5361_745F_62C9_4E0A_4E0B_6587,
        ["可执行"] = function(context)
            return _____5355_4F4D_6709_6548(context["Boss单位"]) and not context["Boss潜入中"]
        end,
        ["执行"] = _____5904_7406_73A9_5BB6_6B8B_7247_5438_6536
    })
    _____521B_5EFA_6218_6597_6280_80FD_8C03_5EA6_5668({
        ["名称"] = "卡瑟拉-深渊召唤调度",
        ["间隔毫秒"] = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["运行时"]["推进间隔毫秒"],
        ["取当前时间"] = getServerTime,
        ["取上下文列表"] = _____83B7_53D6_5168_90E8_5361_745F_62C9_4E0A_4E0B_6587,
        ["取上下文键"] = _____53D6_5361_745F_62C9_4E0A_4E0B_6587_952E,
        ["可调度"] = _____53EF_8C03_5EA6_5361_745F_62C9_6DF1_6E0A_53EC_5524,
        ["技能列表"] = {{key = "深渊召唤", ["冷却毫秒"] = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["深渊召唤"]["触发间隔秒"] * 1000, ["首次延迟毫秒"] = 0, ["执行"] = _____6267_884C_5361_745F_62C9_6DF1_6E0A_53EC_5524}}
    })
    _____521B_5EFA_6218_6597_6280_80FD_8C03_5EA6_5668({
        ["名称"] = "卡瑟拉-共生电击调度",
        ["间隔毫秒"] = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["运行时"]["推进间隔毫秒"],
        ["取当前时间"] = getServerTime,
        ["取上下文列表"] = _____83B7_53D6_5168_90E8_5361_745F_62C9_4E0A_4E0B_6587,
        ["取上下文键"] = _____53D6_5361_745F_62C9_4E0A_4E0B_6587_952E,
        ["可调度"] = _____53EF_8C03_5EA6_5361_745F_62C9_5171_751F_7535_51FB,
        ["技能列表"] = {{key = "共生电击", ["冷却毫秒"] = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["共生电击"]["间隔秒"] * 1000, ["首次延迟毫秒"] = _____5361_745F_62C9_6570_503C_4E0E_8868_73B0_914D_7F6E["共生电击"]["间隔秒"] * 1000, ["执行"] = _____91CA_653E_5361_745F_62C9_5171_751F_7535_51FB}}
    })
end
return ____exports

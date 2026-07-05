--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____53D6_76EE_6807, _____521B_5EFA_8DEF_5F84, _____751F_6210_5251_9B42_72FC, _____6267_884C_5251_9B42_8DEF_5F84, ____on_83F2_5229_65AF_5251_9B42_6740_751F_6548, _____9020_6210AOE_6280_80FD_4F24_5BB3, GetUnitTypeId, GetUnitX, GetUnitY, GetOwningPlayer, GetHandleId, GetSpellTargetUnit, IssueTargetOrder, SetUnitMoveSpeed, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF, _____521B_5EFA_6280_80FD_63D0_793A_5708, _____521B_5EFA_56FA_5B9A_53D7_51FB_6B21_6570_673A_5236_5355_4F4D, _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4Ex, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, addPeriodicCallback, removePeriodicCallback, registerManualBuff, _____83F2_5229_65AFBuffID, _____521B_5EFA_70B9_7279_6548, _____83F2_5229_65AF_5355_4F4D_7C7B_578BID, _____5251_9B42_6740_6280_80FDID
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.00．配置")
local _____83F2_5229_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["菲利斯单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.01．运行时上下文")
local _____767B_8BB0_83F2_5229_65AF_5251_9B42_72FC = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["登记菲利斯剑魂狼"]
local _____83B7_53D6_6216_521B_5EFA_83F2_5229_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建菲利斯上下文"]
local _____83B7_53D6_83F2_5229_65AF_5251_9B42_72FC_8BB0_5F55 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取菲利斯剑魂狼记录"]
local _____6CE8_9500_83F2_5229_65AF_5251_9B42_72FC = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["注销菲利斯剑魂狼"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.02．数值与表现配置")
local _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲利斯数值与表现配置"]
local ____08_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.08．台词播放")
local _____64AD_653E_83F2_5229_65AF_53F0_8BCD = ____08_FF0E_53F0_8BCD_64AD_653E["播放菲利斯台词"]
local ____11_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.11．公共工具")
local _____5355_4F4D_6709_6548 = ____11_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____11_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____53D6_5355_4F4D_95F4_89D2_5EA6 = ____11_FF0E_516C_5171_5DE5_5177["取单位间角度"]
local _____6781_5750_6807X = ____11_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____11_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local _____8DDD_79BB_5E73_65B9XY = ____11_FF0E_516C_5171_5DE5_5177["距离平方XY"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
function _____53D6_76EE_6807(boss)
    local spellTarget = GetSpellTargetUnit()
    if _____5355_4F4D_6709_6548(spellTarget) then
        return spellTarget
    end
    return _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4Ex(boss, boss, _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["剑魂杀"]["路径距离"] + 400)
end
function _____521B_5EFA_8DEF_5F84(boss, target)
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["剑魂杀"]
    local angle = _____53D6_5355_4F4D_95F4_89D2_5EA6(boss, target)
    local paths = {}
    do
        local i = 0
        while i < cfg["剑气数量"] do
            local side = i == 0 and cfg["起点夹角"] or -cfg["起点夹角"]
            local sx = _____6781_5750_6807X(
                GetUnitX(boss),
                angle + side,
                cfg["起点偏移距离"]
            )
            local sy = _____6781_5750_6807Y(
                GetUnitY(boss),
                angle + side,
                cfg["起点偏移距离"]
            )
            paths[#paths + 1] = {
                ["起点X"] = sx,
                ["起点Y"] = sy,
                ["终点X"] = _____6781_5750_6807X(sx, angle, cfg["路径距离"]),
                ["终点Y"] = _____6781_5750_6807Y(sy, angle, cfg["路径距离"]),
                ["命中表"] = {}
            }
            _____521B_5EFA_6280_80FD_63D0_793A_5708({
                ["类型"] = "矩形",
                X = _____6781_5750_6807X(sx, angle, cfg["路径距离"] * 0.5),
                Y = _____6781_5750_6807Y(sy, angle, cfg["路径距离"] * 0.5),
                ["宽度"] = cfg["路径宽度"],
                ["长度"] = cfg["路径距离"],
                ["朝向"] = angle,
                ["持续时间"] = cfg["前摇秒"],
                ["来源单位"] = boss
            })
            i = i + 1
        end
    end
    return paths
end
function _____751F_6210_5251_9B42_72FC(context, x, y, big)
    local boss = context["Boss单位"]
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["剑魂杀"]
    _____521B_5EFA_70B9_7279_6548({["模型路径"] = cfg["召唤爆点特效路径"], X = x, Y = y, ["持续秒"] = cfg["召唤爆点持续秒"]})
    local wolf = _____521B_5EFA_56FA_5B9A_53D7_51FB_6B21_6570_673A_5236_5355_4F4D({
        ["清理"] = context["清理"],
        ["名称"] = big and "菲利斯-大剑魂狼" or "菲利斯-小剑魂狼",
        ["主人单位"] = boss,
        ["所属玩家"] = GetOwningPlayer(boss),
        ["单位类型"] = cfg["狼单位类型"],
        ["模型路径"] = cfg["狼模型路径"],
        X = x,
        Y = y,
        ["最大生命"] = 999999,
        ["受击次数"] = big and cfg["大狼生命点"] or cfg["小狼生命点"],
        ["计数模式"] = "纯普攻或最终伤害阈值",
        ["最终伤害计数阈值"] = 1000,
        ["缩放"] = big and cfg["大狼缩放"] or cfg["小狼缩放"],
        ["持续时间"] = cfg["狼持续秒"],
        ["on死亡"] = function(unit)
            _____6CE8_9500_83F2_5229_65AF_5251_9B42_72FC(unit)
        end,
        ["on销毁"] = function(unit)
            _____6CE8_9500_83F2_5229_65AF_5251_9B42_72FC(unit)
        end
    })
    if wolf == nil then
        return
    end
    _____767B_8BB0_83F2_5229_65AF_5251_9B42_72FC(wolf["单位"], {["Boss单位"] = boss, ["大狼"] = big, ["伤害比例"] = big and cfg["大狼目标最大生命伤害比例"] or cfg["小狼目标最大生命伤害比例"]})
    SetUnitMoveSpeed(wolf["单位"], cfg["狼移动速度"])
    local target = _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4Ex(boss, wolf["单位"], cfg["狼攻击索敌范围"])
    if _____5355_4F4D_6709_6548(target) then
        IssueTargetOrder(wolf["单位"], "attack", target)
    end
end
function _____6267_884C_5251_9B42_8DEF_5F84(context, paths)
    local boss = context["Boss单位"]
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["剑魂杀"]
    local elapsedMs = 0
    local hitCount = 0
    local callbackID = 0
    callbackID = addPeriodicCallback(
        cfg["Tick间隔毫秒"],
        function()
            local ____temp_12 = not _____5355_4F4D_6709_6548(boss)
            if not ____temp_12 then
                local ____self_11 = context["清理"]
                ____temp_12 = ____self_11["已清理"](____self_11)
            end
            if ____temp_12 then
                removePeriodicCallback(callbackID)
                return
            end
            elapsedMs = elapsedMs + cfg["Tick间隔毫秒"]
            local progress = elapsedMs / (cfg["飞行持续秒"] * 1000)
            local p = progress >= 1 and 1 or progress
            do
                local i = 0
                while i < #paths do
                    local path = paths[i + 1]
                    local x = path["起点X"] + (path["终点X"] - path["起点X"]) * p
                    local y = path["起点Y"] + (path["终点Y"] - path["起点Y"]) * p
                    _____521B_5EFA_70B9_7279_6548({
                        ["模型路径"] = cfg["狼魂路径特效路径"],
                        X = x,
                        Y = y,
                        ["缩放"] = cfg["狼魂路径特效缩放"],
                        ["持续秒"] = cfg["狼魂路径特效持续秒"]
                    })
                    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
                    do
                        local h = 0
                        while h < #heroes do
                            do
                                local hero = heroes[h + 1]
                                if not _____5355_4F4D_6709_6548(hero) then
                                    goto __continue22
                                end
                                local hid = GetHandleId(hero) or 0
                                if hid == 0 or path["命中表"][hid] == true then
                                    goto __continue22
                                end
                                if _____8DDD_79BB_5E73_65B9XY(
                                    GetUnitX(hero),
                                    GetUnitY(hero),
                                    x,
                                    y
                                ) > cfg["命中半径"] * cfg["命中半径"] then
                                    goto __continue22
                                end
                                path["命中表"][hid] = true
                                hitCount = hitCount + 1
                                registerManualBuff(
                                    hero,
                                    _____83F2_5229_65AFBuffID["剑魂狼印"],
                                    4,
                                    1,
                                    {sourceName = "菲利斯-剑魂杀"}
                                )
                                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                                    ["技能ID"] = _____5251_9B42_6740_6280_80FDID,
                                    ["来源"] = boss,
                                    ["目标"] = hero,
                                    ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["路径伤害Boss攻击力比例"],
                                    attack = false,
                                    ranged = false,
                                    attackType = ATTACK_TYPE_NORMAL,
                                    ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                                    weaponType = WEAPON_TYPE_WHOKNOWS,
                                    ["来源类型"] = "Boss技能"
                                })
                            end
                            ::__continue22::
                            h = h + 1
                        end
                    end
                    i = i + 1
                end
            end
            if p >= 1 then
                removePeriodicCallback(callbackID)
                if hitCount >= cfg["合并命中次数"] then
                    local x = (paths[1]["终点X"] + paths[2]["终点X"]) * 0.5
                    local y = (paths[1]["终点Y"] + paths[2]["终点Y"]) * 0.5
                    _____751F_6210_5251_9B42_72FC(context, x, y, true)
                else
                    do
                        local i = 0
                        while i < #paths do
                            _____751F_6210_5251_9B42_72FC(context, paths[i + 1]["终点X"], paths[i + 1]["终点Y"], false)
                            i = i + 1
                        end
                    end
                end
            end
        end
    )
    local ____self_13 = context["清理"]
    ____self_13["登记周期回调"](____self_13, "菲利斯-剑魂杀飞行", callbackID)
end
____exports["释放菲利斯剑魂杀"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local target = _____53D6_76EE_6807(boss)
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["剑魂杀"]
    local paths = _____521B_5EFA_8DEF_5F84(boss, target)
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["目标单位"] = target,
        ["硬直秒"] = cfg["前摇秒"],
        ["动画编号"] = cfg["动画编号"],
        ["动画速度"] = cfg["动画速度"],
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = cfg["前摇秒"],
            ["颜色ID"] = cfg["吟唱条颜色ID"],
            ["标题文本"] = cfg["吟唱条标题文本"],
            ["提示文本"] = cfg["吟唱条提示文本"]
        },
        ["播放台词"] = function()
            _____64AD_653E_83F2_5229_65AF_53F0_8BCD(boss, "剑魂杀")
        end,
        ["on生效"] = function()
            _____6267_884C_5251_9B42_8DEF_5F84(context, paths)
        end
    })
end
function ____on_83F2_5229_65AF_5251_9B42_6740_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____5251_9B42_6740_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____83F2_5229_65AF_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_83F2_5229_65AF_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放菲利斯剑魂杀"](context)
end
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_0["造成AOE技能伤害"]
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_0["造成单体技能伤害"]
local jass = require("jass.common")
GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
GetOwningPlayer = jass.GetOwningPlayer
GetHandleId = jass.GetHandleId
GetSpellTargetUnit = jass.GetSpellTargetUnit
IssueTargetOrder = jass.IssueTargetOrder
SetUnitMoveSpeed = jass.SetUnitMoveSpeed
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_1["读取单位攻击力"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
_____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_2["启动基础施法时间线"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
_____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_3["创建技能提示圈"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.03．固定受击次数机制单位")
_____521B_5EFA_56FA_5B9A_53D7_51FB_6B21_6570_673A_5236_5355_4F4D = ____require_result_4["创建固定受击次数机制单位"]
local ____require_result_5 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4Ex = ____require_result_5["获取Boss技能最近敌对英雄Ex"]
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_5["获取Boss技能敌对英雄列表"]
local ____require_result_6 = require("系统.00．核心系统.05．中心计时器")
addPeriodicCallback = ____require_result_6.addPeriodicCallback
removePeriodicCallback = ____require_result_6.removePeriodicCallback
local ____require_result_7 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_7.registerAppliedFinalDamageListener
local ____require_result_8 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_8.registerManualBuff
local ____require_result_9 = require("系统.05．Buff系统.03．Buff表.01．Boss.06．菲利斯")
_____83F2_5229_65AFBuffID = ____require_result_9["菲利斯BuffID"]
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_10["创建点特效"]
_____83F2_5229_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____83F2_5229_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____5251_9B42_6740_6280_80FDID = stringToFourCC(_____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["剑魂杀"]["技能槽位"])
local _____5251_9B42_6740_5DF2_6CE8_518C = false
local _____5251_9B42_72FC_653B_51FB_76D1_542C_5DF2_6CE8_518C = false
local function _____8865_5145Boss_9B54_6CD5(context, amount)
    local boss = context["Boss单位"]
    local maxMana = GetUnitState(boss, UNIT_STATE_MAX_MANA)
    local current = GetUnitState(boss, UNIT_STATE_MANA)
    if maxMana > 0 then
        SetUnitState(boss, UNIT_STATE_MANA, current + amount > maxMana and maxMana or current + amount)
    end
    context["当前魔法充能"] = context["当前魔法充能"] + amount
    if context["当前魔法充能"] > _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["异形化"]["魔法阈值"] then
        context["当前魔法充能"] = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["异形化"]["魔法阈值"]
    end
end
local function _____6CBB_7597Boss(boss, amount)
    local maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE)
    local life = GetUnitState(boss, UNIT_STATE_LIFE)
    SetUnitState(boss, UNIT_STATE_LIFE, life + amount > maxLife and maxLife or life + amount)
end
local function ____on_5251_9B42_72FC_6700_7EC8_4F24_5BB3(target, attacker, _applied, snapshot)
    if snapshot == nil or snapshot.isNormalAttack ~= true then
        return
    end
    local record = _____83B7_53D6_83F2_5229_65AF_5251_9B42_72FC_8BB0_5F55(attacker)
    if record == nil or not _____5355_4F4D_6709_6548(record["Boss单位"]) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_83F2_5229_65AF_4E0A_4E0B_6587(record["Boss单位"])
    if context == nil then
        return
    end
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["剑魂杀"]
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["技能ID"] = _____5251_9B42_6740_6280_80FDID,
        ["来源"] = attacker,
        ["目标"] = target,
        ["伤害"] = GetUnitState(target, UNIT_STATE_MAX_LIFE) * record["伤害比例"],
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "Boss技能"
    })
    _____8865_5145Boss_9B54_6CD5(
        context,
        GetUnitState(record["Boss单位"], UNIT_STATE_MAX_MANA) * cfg["狼攻击回魔Boss最大魔法比例"]
    )
    if context["异形化中"] then
        _____6CBB_7597Boss(
            record["Boss单位"],
            GetUnitState(record["Boss单位"], UNIT_STATE_MAX_LIFE) * cfg["异形化狼攻击回血Boss最大生命比例"]
        )
    end
end
____exports["注册菲利斯剑魂杀"] = function()
    if not _____5251_9B42_72FC_653B_51FB_76D1_542C_5DF2_6CE8_518C then
        _____5251_9B42_72FC_653B_51FB_76D1_542C_5DF2_6CE8_518C = true
        registerAppliedFinalDamageListener(____on_5251_9B42_72FC_6700_7EC8_4F24_5BB3)
    end
    if _____5251_9B42_6740_5DF2_6CE8_518C then
        return
    end
    _____5251_9B42_6740_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "04．剑魂杀",
        ["单位类型ID"] = _____83F2_5229_65AF_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____5251_9B42_6740_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_83F2_5229_65AF_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_83F2_5229_65AF_5251_9B42_6740_751F_6548(boss, _____5251_9B42_6740_6280_80FDID)
        end
    })
end
return ____exports

--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____53D6_76EE_6807, _____8865_5145Boss_9B54_6CD5, _____521B_5EFA_65B9_5411_7279_6548, _____7ED3_7B97_5251_6C14_521D_59CB_547D_4E2D, _____521B_5EFA_4FB5_8680_6B8B_7559, ____on_83F2_5229_65AF_5251_6C14_7075_65A9_751F_6548, _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3, _____9020_6210AOE_6280_80FD_4F24_5BB3, GetUnitTypeId, GetUnitX, GetUnitY, GetUnitState, SetUnitState, GetSpellTargetUnit, UNIT_STATE_MANA, UNIT_STATE_MAX_MANA, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS, _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF, _____521B_5EFA_6280_80FD_63D0_793A_5708, _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4Ex, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, addPeriodicCallback, removePeriodicCallback, registerManualBuff, _____83F2_5229_65AFBuffID, _____521B_5EFA_70B9_7279_6548, _____8BBE_7F6E_7279_6548XYZ_8F74_65CB_8F6C, _____83F2_5229_65AF_5355_4F4D_7C7B_578BID, _____5251_6C14_7075_65A9_6280_80FDID
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.00．配置")
local _____83F2_5229_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["菲利斯单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_83F2_5229_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建菲利斯上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.02．数值与表现配置")
local _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲利斯数值与表现配置"]
local _____83F2_5229_65AF_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲利斯音效配置"]
local ____08_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.08．台词播放")
local _____64AD_653E_83F2_5229_65AF_53F0_8BCD = ____08_FF0E_53F0_8BCD_64AD_653E["播放菲利斯台词"]
local ____11_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.11．公共工具")
local _____5355_4F4D_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9 = ____11_FF0E_516C_5171_5DE5_5177["单位到线段距离平方"]
local _____5355_4F4D_6709_6548 = ____11_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____11_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____53D6_5355_4F4D_95F4_89D2_5EA6 = ____11_FF0E_516C_5171_5DE5_5177["取单位间角度"]
local _____6781_5750_6807X = ____11_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____11_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
function _____53D6_76EE_6807(boss)
    local spellTarget = GetSpellTargetUnit()
    if _____5355_4F4D_6709_6548(spellTarget) then
        return spellTarget
    end
    return _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4Ex(boss, boss, _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["剑气灵斩"]["距离"] + 400)
end
function _____8865_5145Boss_9B54_6CD5(context, amount)
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
function _____521B_5EFA_65B9_5411_7279_6548(model, x, y, angle, scale, duration)
    local effect = _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = model,
        X = x,
        Y = y,
        ["缩放"] = scale,
        ["持续秒"] = duration
    })
    _____8BBE_7F6E_7279_6548XYZ_8F74_65CB_8F6C(effect, {["Z轴角度"] = angle})
end
function _____7ED3_7B97_5251_6C14_521D_59CB_547D_4E2D(context, ax, ay, bx, by, width)
    local boss = context["Boss单位"]
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["剑气灵斩"]
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local width2 = width * width * 0.25
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue10
                end
                if _____5355_4F4D_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9(
                    hero,
                    ax,
                    ay,
                    bx,
                    by
                ) > width2 then
                    goto __continue10
                end
                local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(boss, hero, {["来源攻击力比例"] = cfg["Boss攻击力比例"], ["目标最大生命比例"] = cfg["目标最大生命比例"]})
                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["技能ID"] = _____5251_6C14_7075_65A9_6280_80FDID,
                    ["来源"] = boss,
                    ["目标"] = hero,
                    ["伤害"] = damage,
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "Boss技能"
                })
            end
            ::__continue10::
            i = i + 1
        end
    end
end
function _____521B_5EFA_4FB5_8680_6B8B_7559(context, ax, ay, bx, by, angle, width)
    local boss = context["Boss单位"]
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["剑气灵斩"]
    local midX = (ax + bx) * 0.5
    local midY = (ay + by) * 0.5
    _____521B_5EFA_65B9_5411_7279_6548(
        cfg["残留特效路径"],
        midX,
        midY,
        angle,
        cfg["残留特效缩放"],
        cfg["侵蚀持续秒"]
    )
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "矩形",
        X = midX,
        Y = midY,
        ["宽度"] = width,
        ["长度"] = cfg["距离"],
        ["朝向"] = angle,
        ["持续时间"] = cfg["侵蚀持续秒"],
        ["来源单位"] = boss
    })
    local elapsed = 0
    local tickID
    tickID = addPeriodicCallback(
        cfg["侵蚀Tick秒"] * 1000,
        function()
            local ____temp_10 = not _____5355_4F4D_6709_6548(boss)
            if not ____temp_10 then
                local ____self_9 = context["清理"]
                ____temp_10 = ____self_9["已清理"](____self_9)
            end
            if ____temp_10 then
                removePeriodicCallback(tickID)
                return
            end
            elapsed = elapsed + cfg["侵蚀Tick秒"]
            if elapsed > cfg["侵蚀持续秒"] then
                removePeriodicCallback(tickID)
                return
            end
            local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
            local width2 = width * width * 0.25
            do
                local i = 0
                while i < #heroes do
                    do
                        local hero = heroes[i + 1]
                        if not _____5355_4F4D_6709_6548(hero) then
                            goto __continue18
                        end
                        if _____5355_4F4D_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9(
                            hero,
                            ax,
                            ay,
                            bx,
                            by
                        ) > width2 then
                            goto __continue18
                        end
                        local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(boss, hero, {["来源攻击力比例"] = cfg["侵蚀Boss攻击力比例"], ["目标最大生命比例"] = cfg["侵蚀目标最大生命比例"]})
                        _____9020_6210AOE_6280_80FD_4F24_5BB3({
                            ["技能ID"] = _____5251_6C14_7075_65A9_6280_80FDID,
                            ["来源"] = boss,
                            ["目标"] = hero,
                            ["伤害"] = damage,
                            attack = false,
                            ranged = false,
                            attackType = ATTACK_TYPE_NORMAL,
                            ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                            weaponType = WEAPON_TYPE_WHOKNOWS,
                            ["来源类型"] = "Boss技能"
                        })
                        local mana = GetUnitState(hero, UNIT_STATE_MANA)
                        local lostMana = mana * cfg["侵蚀扣魔当前魔法比例"]
                        if lostMana > 0 then
                            SetUnitState(hero, UNIT_STATE_MANA, mana - lostMana)
                            _____8865_5145Boss_9B54_6CD5(context, lostMana * cfg["侵蚀补魔倍率"])
                        end
                        registerManualBuff(
                            hero,
                            _____83F2_5229_65AFBuffID["侵蚀残留"],
                            cfg["侵蚀Buff残留秒"],
                            damage,
                            {sourceName = "菲利斯-剑气灵斩"}
                        )
                        _____521B_5EFA_70B9_7279_6548({
                            ["模型路径"] = cfg["Tick命中特效路径"],
                            X = GetUnitX(hero),
                            Y = GetUnitY(hero),
                            ["持续秒"] = cfg["Tick命中特效持续秒"]
                        })
                    end
                    ::__continue18::
                    i = i + 1
                end
            end
        end
    )
    local ____self_11 = context["清理"]
    ____self_11["登记周期回调"](____self_11, "菲利斯-剑气灵斩侵蚀", tickID)
end
____exports["释放菲利斯剑气灵斩"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local target = _____53D6_76EE_6807(boss)
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["剑气灵斩"]
    local angle = _____53D6_5355_4F4D_95F4_89D2_5EA6(boss, target)
    local ax = GetUnitX(boss)
    local ay = GetUnitY(boss)
    local bx = _____6781_5750_6807X(ax, angle, cfg["距离"])
    local by = _____6781_5750_6807Y(ay, angle, cfg["距离"])
    local width = context["异形化中"] and cfg["宽度"] * cfg["异形化宽度倍率"] or cfg["宽度"]
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["目标单位"] = target,
        ["硬直秒"] = cfg["施法硬直秒"],
        ["动画编号"] = cfg["动画编号"],
        ["动画速度"] = cfg["动画速度"],
        ["播放台词"] = function()
            _____64AD_653E_83F2_5229_65AF_53F0_8BCD(boss, "剑气灵斩")
        end,
        ["on生效"] = function()
            _____64AD_653EBoss_5750_6807_97F3_6548(_____83F2_5229_65AF_97F3_6548_914D_7F6E["剑气灵斩"]["斩出侵蚀"], ax, ay, _____83F2_5229_65AF_97F3_6548_914D_7F6E["默认裁断距离"])
            _____521B_5EFA_65B9_5411_7279_6548(
                cfg["剑气特效路径"],
                ax,
                ay,
                angle,
                cfg["剑气特效缩放"],
                cfg["剑气特效持续秒"]
            )
            _____7ED3_7B97_5251_6C14_521D_59CB_547D_4E2D(
                context,
                ax,
                ay,
                bx,
                by,
                width
            )
            _____521B_5EFA_4FB5_8680_6B8B_7559(
                context,
                ax,
                ay,
                bx,
                by,
                angle,
                width
            )
        end
    })
end
function ____on_83F2_5229_65AF_5251_6C14_7075_65A9_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____5251_6C14_7075_65A9_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____83F2_5229_65AF_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_83F2_5229_65AF_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放菲利斯剑气灵斩"](context)
end
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
_____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____require_result_0["计算组合技能伤害"]
local ____require_result_1 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_1["造成AOE技能伤害"]
local jass = require("jass.common")
GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitState = jass.GetUnitState
SetUnitState = jass.SetUnitState
GetSpellTargetUnit = jass.GetSpellTargetUnit
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
UNIT_STATE_MANA = jass.UNIT_STATE_MANA
UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
_____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_2["启动基础施法时间线"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
_____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_3["创建技能提示圈"]
local ____require_result_4 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4Ex = ____require_result_4["获取Boss技能最近敌对英雄Ex"]
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_4["获取Boss技能敌对英雄列表"]
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
addPeriodicCallback = ____require_result_5.addPeriodicCallback
removePeriodicCallback = ____require_result_5.removePeriodicCallback
local ____require_result_6 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_6.registerManualBuff
local ____require_result_7 = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.05．菲利斯")
_____83F2_5229_65AFBuffID = ____require_result_7["菲利斯BuffID"]
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_8["创建点特效"]
_____8BBE_7F6E_7279_6548XYZ_8F74_65CB_8F6C = ____require_result_8["设置特效XYZ轴旋转"]
_____83F2_5229_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____83F2_5229_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____5251_6C14_7075_65A9_6280_80FDID = stringToFourCC(_____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["剑气灵斩"]["技能槽位"])
local _____5251_6C14_7075_65A9_5DF2_6CE8_518C = false
____exports["注册菲利斯剑气灵斩"] = function()
    if _____5251_6C14_7075_65A9_5DF2_6CE8_518C then
        return
    end
    _____5251_6C14_7075_65A9_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "05．剑气灵斩",
        ["单位类型ID"] = _____83F2_5229_65AF_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____5251_6C14_7075_65A9_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_83F2_5229_65AF_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_83F2_5229_65AF_5251_6C14_7075_65A9_751F_6548(boss, _____5251_6C14_7075_65A9_6280_80FDID)
        end
    })
end
return ____exports

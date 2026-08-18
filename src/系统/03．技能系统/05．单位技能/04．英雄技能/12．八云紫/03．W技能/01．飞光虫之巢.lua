--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.12．八云紫.00．配置")
local _____516B_4E91_7D2B_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["八云紫单位技能配置"]
local ____01_FF0E_88C2_9699_7CFB_7EDF = require("系统.03．技能系统.05．单位技能.04．英雄技能.12．八云紫.07．公共与单位壳.01．裂隙系统")
local _____516B_4E91_7D2B_5355_4F4D_5B58_6D3B = ____01_FF0E_88C2_9699_7CFB_7EDF["八云紫单位存活"]
local _____662F_516B_4E91_7D2B = ____01_FF0E_88C2_9699_7CFB_7EDF["是八云紫"]
local _____662F_516B_4E91_7D2B_5408_6CD5_654C_4EBA = ____01_FF0E_88C2_9699_7CFB_7EDF["是八云紫合法敌人"]
local _____521B_5EFA_516B_4E91_7D2B_4E34_65F6_88C2_9699 = ____01_FF0E_88C2_9699_7CFB_7EDF["创建八云紫临时裂隙"]
local _____521B_5EFA_516B_4E91_7D2B_70B9_7279_6548 = ____01_FF0E_88C2_9699_7CFB_7EDF["创建八云紫点特效"]
local ____01_FF0E_6CE2_4E0E_7C92_7684_5883_754C = require("系统.03．技能系统.05．单位技能.04．英雄技能.12．八云紫.02．Q技能.01．波与粒的境界")
local _____53D1_5C04_516B_4E91_7D2B_5F39_5E55 = ____01_FF0E_6CE2_4E0E_7C92_7684_5883_754C["发射八云紫弹幕"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.12．八云紫.00A．表现工具")
local _____64AD_653E_516B_4E91_7D2B_968F_673A_5355_4F4D_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放八云紫随机单位音效"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_1["读取单位攻击力"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_1["两点角度"]
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_2.getEnemyUnitsInRange
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_3["造成单体技能伤害"]
local _____914D_7F6E = _____516B_4E91_7D2B_5355_4F4D_6280_80FD_914D_7F6E
local DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local function _____83B7_53D6W_4E0A_4E0B_6587(hero)
    return _____662F_516B_4E91_7D2B(hero) and ({["英雄"] = hero}) or nil
end
local function _____53D1_5C04W_4E00_6CE2(variable)
    local data = variable
    if data == nil or not _____516B_4E91_7D2B_5355_4F4D_5B58_6D3B(data["上下文"]["英雄"]) then
        return
    end
    local context = data["上下文"]
    do
        local i = 0
        while i < #context["裂隙"] do
            do
                local gap = context["裂隙"][i + 1]
                if not _____516B_4E91_7D2B_5355_4F4D_5B58_6D3B(gap) then
                    goto __continue6
                end
                local x = jass.GetUnitX(gap)
                local y = jass.GetUnitY(gap)
                local hasTarget = _____516B_4E91_7D2B_5355_4F4D_5B58_6D3B(context["目标单位"])
                local ____hasTarget_4
                if hasTarget then
                    ____hasTarget_4 = jass.GetUnitX(context["目标单位"])
                else
                    ____hasTarget_4 = context["目标X"]
                end
                local targetX = ____hasTarget_4
                local ____hasTarget_5
                if hasTarget then
                    ____hasTarget_5 = jass.GetUnitY(context["目标单位"])
                else
                    ____hasTarget_5 = context["目标Y"]
                end
                local targetY = ____hasTarget_5
                _____53D1_5C04_516B_4E91_7D2B_5F39_5E55({
                    ["施法者"] = context["英雄"],
                    X = x,
                    Y = y,
                    ["方向角"] = _____4E24_70B9_89D2_5EA6(x, y, targetX, targetY),
                    ["速度"] = _____914D_7F6E.Q["普通速度"],
                    ["高度"] = hasTarget and _____914D_7F6E.Q["强化高度"] or _____914D_7F6E.Q["普通高度"],
                    ["缩放"] = hasTarget and _____914D_7F6E.Q["强化缩放"] or _____914D_7F6E.Q["普通缩放"],
                    ["命中半径"] = hasTarget and _____914D_7F6E.Q["强化半径"] or _____914D_7F6E.Q["普通半径"],
                    ["伤害攻击力比例"] = _____914D_7F6E.W["普通伤害攻击力比例"],
                    ["技能ID"] = _____914D_7F6E["技能"].W["类型ID"],
                    ["技能实例ID"] = context["技能实例ID"],
                    ["普通弹幕"] = not hasTarget,
                    ["最短飞行距离"] = hasTarget and _____914D_7F6E.Q["强化最短飞行距离"] or 0
                })
            end
            ::__continue6::
            i = i + 1
        end
    end
end
local function _____7ED3_7B97W_6307_5B9A_76EE_6807(variable)
    local context = variable
    if context == nil or not _____516B_4E91_7D2B_5355_4F4D_5B58_6D3B(context["英雄"]) or not _____516B_4E91_7D2B_5355_4F4D_5B58_6D3B(context["目标单位"]) then
        return
    end
    local target = context["目标单位"]
    local targetX = jass.GetUnitX(target)
    local targetY = jass.GetUnitY(target)
    local missingLife = math.max(
        0,
        jass.GetUnitState(target, UNIT_STATE_MAX_LIFE) - jass.GetUnitState(target, UNIT_STATE_LIFE)
    )
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = context["英雄"],
        ["目标"] = target,
        ["伤害"] = missingLife * _____914D_7F6E.W["指定目标已损失生命比例"],
        ["伤害类型"] = DAMAGE_TYPE_MIND,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____914D_7F6E["技能"].W["类型ID"],
        ["技能实例ID"] = context["技能实例ID"],
        ["标签"] = "八云紫-W-指定目标精神伤害"
    })
    local enemies = getEnemyUnitsInRange(context["英雄"], targetX, targetY, _____914D_7F6E.W["周围伤害范围"])
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(context["英雄"]) * _____914D_7F6E.W["周围伤害攻击力比例"]
    do
        local i = 0
        while i < #enemies do
            do
                local enemy = enemies[i + 1]
                if enemy == target or not _____662F_516B_4E91_7D2B_5408_6CD5_654C_4EBA(context["英雄"], enemy) then
                    goto __continue11
                end
                _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                    ["来源"] = context["英雄"],
                    ["目标"] = enemy,
                    ["伤害"] = damage,
                    ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
                    attackType = ATTACK_TYPE_NORMAL,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "单位技能",
                    ["技能ID"] = _____914D_7F6E["技能"].W["类型ID"],
                    ["技能实例ID"] = context["技能实例ID"],
                    ["标签"] = "八云紫-W-周围暗魔法伤害",
                    ["参与技能伤害加成"] = true
                })
            end
            ::__continue11::
            i = i + 1
        end
    end
    _____521B_5EFA_516B_4E91_7D2B_70B9_7279_6548(
        _____914D_7F6E.W["结算特效"],
        targetX,
        targetY,
        1.5,
        1,
        _____914D_7F6E.W["结算特效高度"]
    )
end
local function _____91CA_653EW(_entry, hero, skillInstanceId)
    local target = jass.GetSpellTargetUnit()
    local targetX = jass.GetSpellTargetX()
    local targetY = jass.GetSpellTargetY()
    local context = {
        ["英雄"] = hero,
        ["裂隙"] = {},
        ["目标单位"] = target,
        ["目标X"] = targetX,
        ["目标Y"] = targetY,
        ["技能实例ID"] = skillInstanceId
    }
    if target ~= nil and target ~= 0 and _____662F_516B_4E91_7D2B_5408_6CD5_654C_4EBA(hero, target) then
        _____64AD_653E_516B_4E91_7D2B_968F_673A_5355_4F4D_97F3_6548(hero, _____914D_7F6E.W["指定目标语音键"])
        do
            local i = 0
            while i < _____914D_7F6E.W["裂隙数量"] do
                local angle = 45 + 90 * (i + 1)
                local radians = angle * math.pi / 180
                local ____context__88C2_9699_6 = context["裂隙"]
                ____context__88C2_9699_6[#____context__88C2_9699_6 + 1] = _____521B_5EFA_516B_4E91_7D2B_4E34_65F6_88C2_9699(
                    hero,
                    targetX + math.cos(radians) * _____914D_7F6E.W["指定目标裂隙半径"],
                    targetY + math.sin(radians) * _____914D_7F6E.W["指定目标裂隙半径"],
                    _____914D_7F6E.W["裂隙持续秒"] + _____914D_7F6E.W["裂隙清理宽限秒"]
                )
                i = i + 1
            end
        end
    else
        _____64AD_653E_516B_4E91_7D2B_968F_673A_5355_4F4D_97F3_6548(hero, _____914D_7F6E.W["无目标语音键"])
        local heroX = jass.GetUnitX(hero)
        local heroY = jass.GetUnitY(hero)
        local angle = _____4E24_70B9_89D2_5EA6(heroX, heroY, targetX, targetY)
        local radians = angle * math.pi / 180
        local sideRadians = (angle + 90) * math.pi / 180
        local backX = heroX - math.cos(radians) * _____914D_7F6E.W["无目标后方距离"]
        local backY = heroY - math.sin(radians) * _____914D_7F6E.W["无目标后方距离"]
        local firstX = backX + math.cos(sideRadians) * _____914D_7F6E.W["横向起点距离"]
        local firstY = backY + math.sin(sideRadians) * _____914D_7F6E.W["横向起点距离"]
        do
            local i = 1
            while i <= _____914D_7F6E.W["裂隙数量"] do
                local ____context__88C2_9699_7 = context["裂隙"]
                ____context__88C2_9699_7[#____context__88C2_9699_7 + 1] = _____521B_5EFA_516B_4E91_7D2B_4E34_65F6_88C2_9699(
                    hero,
                    firstX - math.cos(sideRadians) * _____914D_7F6E.W["横向间距"] * i,
                    firstY - math.sin(sideRadians) * _____914D_7F6E.W["横向间距"] * i,
                    _____914D_7F6E.W["裂隙持续秒"] + _____914D_7F6E.W["裂隙清理宽限秒"]
                )
                i = i + 1
            end
        end
    end
    do
        local wave = 1
        while wave <= _____914D_7F6E.W["每裂隙弹幕数"] do
            addDelayedCallback(wave * _____914D_7F6E.W["发射间隔秒"] * 1000, _____53D1_5C04W_4E00_6CE2, {["上下文"] = context, ["波次"] = wave})
            wave = wave + 1
        end
    end
    if target ~= nil and target ~= 0 and _____662F_516B_4E91_7D2B_5408_6CD5_654C_4EBA(hero, target) then
        addDelayedCallback((_____914D_7F6E.W["每裂隙弹幕数"] + 1) * _____914D_7F6E.W["发射间隔秒"] * 1000, _____7ED3_7B97W_6307_5B9A_76EE_6807, context)
    end
end
_____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
    ["名称"] = "八云紫-飞光虫之巢（W）",
    ["单位类型ID"] = _____914D_7F6E["单位"]["英雄类型ID"],
    ["技能ID"] = _____914D_7F6E["技能"].W["类型ID"],
    ["获取或创建上下文"] = _____83B7_53D6W_4E0A_4E0B_6587,
    ["释放技能"] = _____91CA_653EW,
    ["创建独立技能实例"] = true,
    ["独立技能来源类型"] = "单位技能",
    ["技能实例持续时间秒"] = 5
})
return ____exports

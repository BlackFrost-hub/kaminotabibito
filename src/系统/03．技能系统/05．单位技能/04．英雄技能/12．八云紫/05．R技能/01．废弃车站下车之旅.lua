local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____53E5_67C4ID, _____7ED3_675F_5217_8F66, _____6E05_9664_4E8C_6BB5_7B49_5F85, _____63A8_52A8_76EE_6807, _____62E5_6709_5217_8F66_7729_6655, _____7ED3_7B97_5217_8F66_78B0_649E, _____521B_5EFA_5217_8F66_8DEF_5F84_8868_73B0, _____521B_5EFA_4E8C_6BB5_5217_8F66, _____4E8C_6BB5_7A97_53E3_8D85_65F6, _____5F00_542F_4E8C_6BB5_7A97_53E3, _____5217_8F66Tick, _____542F_52A8_5217_8F66, jass, addDelayedCallback, addPeriodicCallback, removePeriodicCallback, _____521B_5EFA_70B9_7279_6548, _____9500_6BC1_70B9_7279_6548, getEnemyUnitsInRange, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, _____4E24_70B9_89D2_5EA6, _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3, _____65BD_52A0_7729_6655, _____914D_7F6E, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_ROCK_HEAVY_BASH, PATHING_TYPE_WALKABILITY, STUN_BUFF_ID, PSEUDO_STUN_BUFF_ID, DzSetEffectPos, EXSetEffectSize, _____4E8C_6BB5_7B49_5F85_8868
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.12．八云紫.00．配置")
local _____516B_4E91_7D2B_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["八云紫单位技能配置"]
local ____01_FF0E_88C2_9699_7CFB_7EDF = require("系统.03．技能系统.05．单位技能.04．英雄技能.12．八云紫.07．公共与单位壳.01．裂隙系统")
local _____516B_4E91_7D2B_5355_4F4D_5B58_6D3B = ____01_FF0E_88C2_9699_7CFB_7EDF["八云紫单位存活"]
local _____662F_516B_4E91_7D2B = ____01_FF0E_88C2_9699_7CFB_7EDF["是八云紫"]
local _____662F_516B_4E91_7D2B_5408_6CD5_654C_4EBA = ____01_FF0E_88C2_9699_7CFB_7EDF["是八云紫合法敌人"]
local _____67E5_627E_516B_4E91_7D2B_88C2_9699 = ____01_FF0E_88C2_9699_7CFB_7EDF["查找八云紫裂隙"]
local _____83B7_53D6_8303_56F4_5185_516B_4E91_7D2B_88C2_9699 = ____01_FF0E_88C2_9699_7CFB_7EDF["获取范围内八云紫裂隙"]
local _____521B_5EFA_516B_4E91_7D2B_88C2_9699 = ____01_FF0E_88C2_9699_7CFB_7EDF["创建八云紫裂隙"]
local _____6CE8_518C_516B_4E91_7D2B_88C2_9699_521B_5EFA_76D1_542C_5668 = ____01_FF0E_88C2_9699_7CFB_7EDF["注册八云紫裂隙创建监听器"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____00B_FF0E_8BCA_65AD = require("系统.03．技能系统.05．单位技能.04．英雄技能.12．八云紫.00B．诊断")
local _____516B_4E91_7D2B_8BCA_65AD_65E5_5FD7 = ____00B_FF0E_8BCA_65AD["八云紫诊断日志"]
local _____516B_4E91_7D2B_8BCA_65AD_53E5_67C4 = ____00B_FF0E_8BCA_65AD["八云紫诊断句柄"]
function _____53E5_67C4ID(handle)
    return (handle == nil or handle == 0) and 0 or jass.GetHandleId(handle)
end
function _____7ED3_675F_5217_8F66(context)
    if context["已结束"] then
        return
    end
    _____516B_4E91_7D2B_8BCA_65AD_65E5_5FD7(
        "R",
        "结束列车",
        "英雄",
        _____516B_4E91_7D2B_8BCA_65AD_53E5_67C4(context["英雄"]),
        "X",
        context.X,
        "Y",
        context.Y,
        "剩余Tick",
        context["剩余Tick"],
        "允许二段",
        context["允许触发二段"]
    )
    context["已结束"] = true
    if context["周期ID"] ~= 0 then
        removePeriodicCallback(context["周期ID"])
    end
    if context["特效"] ~= nil and context["特效"] ~= 0 then
        EXSetEffectSize(context["特效"], 0)
        DzSetEffectPos(context["特效"], context.X, context.Y, -10000)
        _____9500_6BC1_70B9_7279_6548(context["特效"])
    end
    context["特效"] = nil
end
function _____6E05_9664_4E8C_6BB5_7B49_5F85(context)
    if context["已结束"] then
        return
    end
    context["已结束"] = true
    local heroId = _____53E5_67C4ID(context["英雄"])
    if _____4E8C_6BB5_7B49_5F85_8868[heroId] == context then
        __TS__Delete(_____4E8C_6BB5_7B49_5F85_8868, heroId)
    end
    _____516B_4E91_7D2B_8BCA_65AD_65E5_5FD7(
        "R",
        "清除二段等待",
        "英雄",
        heroId,
        "进入裂隙",
        _____516B_4E91_7D2B_8BCA_65AD_53E5_67C4(context["进入裂隙"]["单位"])
    )
end
function _____63A8_52A8_76EE_6807(target, directionRadians)
    local nextX = jass.GetUnitX(target) + math.cos(directionRadians) * _____914D_7F6E.R["推动距离"]
    local nextY = jass.GetUnitY(target) + math.sin(directionRadians) * _____914D_7F6E.R["推动距离"]
    if jass.IsTerrainPathable(nextX, nextY, PATHING_TYPE_WALKABILITY) == true then
        return
    end
    jass.SetUnitPosition(target, nextX, nextY)
end
function _____62E5_6709_5217_8F66_7729_6655(target)
    return jass.GetUnitAbilityLevel(target, STUN_BUFF_ID) > 0 or jass.GetUnitAbilityLevel(target, PSEUDO_STUN_BUFF_ID) > 0
end
function _____7ED3_7B97_5217_8F66_78B0_649E(context)
    local targets = getEnemyUnitsInRange(context["英雄"], context.X, context.Y, _____914D_7F6E.R["命中范围"])
    do
        local i = 0
        while i < #targets do
            do
                local target = targets[i + 1]
                if not _____662F_516B_4E91_7D2B_5408_6CD5_654C_4EBA(context["英雄"], target) then
                    goto __continue15
                end
                if not _____62E5_6709_5217_8F66_7729_6655(target) then
                    _____65BD_52A0_7729_6655(
                        context["英雄"],
                        target,
                        _____914D_7F6E.R["眩晕秒"],
                        "八云紫-R-废旧列车",
                        "技能"
                    )
                end
                _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                    ["来源"] = context["英雄"],
                    ["目标"] = target,
                    ["伤害"] = context["伤害"],
                    ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                    attackType = ATTACK_TYPE_NORMAL,
                    weaponType = WEAPON_TYPE_ROCK_HEAVY_BASH,
                    ["来源类型"] = "单位技能",
                    ["技能ID"] = _____914D_7F6E["技能"].R["类型ID"],
                    ["技能实例ID"] = context["技能实例ID"],
                    ["标签"] = "八云紫-R-废旧列车碰撞",
                    ["伤害形态"] = "AOE",
                    ["参与技能伤害加成"] = true
                })
                if _____62E5_6709_5217_8F66_7729_6655(target) then
                    _____63A8_52A8_76EE_6807(target, context["方向弧度"])
                    jass.SetUnitAnimation(target, "Death")
                end
            end
            ::__continue15::
            i = i + 1
        end
    end
end
function _____521B_5EFA_5217_8F66_8DEF_5F84_8868_73B0(context)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E.R["路径特效A"],
        X = context.X,
        Y = context.Y,
        ["持续秒"] = _____914D_7F6E.R["路径特效持续秒"],
        ["缩放"] = _____914D_7F6E.R["路径特效A缩放"]
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E.R["路径特效B"],
        X = context.X,
        Y = context.Y,
        ["持续秒"] = _____914D_7F6E.R["路径特效持续秒"],
        ["缩放"] = _____914D_7F6E.R["路径特效B缩放"]
    })
end
function _____521B_5EFA_4E8C_6BB5_5217_8F66(hero, gap, skillInstanceId)
    if not _____516B_4E91_7D2B_5355_4F4D_5B58_6D3B(hero) or gap["已结束"] or not _____516B_4E91_7D2B_5355_4F4D_5B58_6D3B(gap["单位"]) then
        return
    end
    local gapX = jass.GetUnitX(gap["单位"])
    local gapY = jass.GetUnitY(gap["单位"])
    local direction = _____4E24_70B9_89D2_5EA6(
        jass.GetUnitX(hero),
        jass.GetUnitY(hero),
        gapX,
        gapY
    )
    _____542F_52A8_5217_8F66(
        hero,
        gap,
        direction,
        false,
        skillInstanceId
    )
end
function _____4E8C_6BB5_7A97_53E3_8D85_65F6(variable)
    local context = variable
    if context == nil or context["已结束"] then
        return
    end
    _____516B_4E91_7D2B_8BCA_65AD_65E5_5FD7(
        "R",
        "二段窗口超时",
        "英雄",
        _____516B_4E91_7D2B_8BCA_65AD_53E5_67C4(context["英雄"]),
        "进入裂隙",
        _____516B_4E91_7D2B_8BCA_65AD_53E5_67C4(context["进入裂隙"]["单位"])
    )
    _____6E05_9664_4E8C_6BB5_7B49_5F85(context)
    if not _____516B_4E91_7D2B_5355_4F4D_5B58_6D3B(context["英雄"]) then
        return
    end
    local heroX = jass.GetUnitX(context["英雄"])
    local heroY = jass.GetUnitY(context["英雄"])
    local behindRadians = (jass.GetUnitFacing(context["英雄"]) + 180) * math.pi / 180
    local targetX = heroX + math.cos(behindRadians) * _____914D_7F6E.R["自动裂隙身后距离"]
    local targetY = heroY + math.sin(behindRadians) * _____914D_7F6E.R["自动裂隙身后距离"]
    local gap = _____521B_5EFA_516B_4E91_7D2B_88C2_9699(
        context["英雄"],
        targetX,
        targetY,
        _____914D_7F6E["技能"].R["类型ID"],
        context["技能实例ID"]
    )
    _____516B_4E91_7D2B_8BCA_65AD_65E5_5FD7(
        "R",
        "超时自动创建身后间隙",
        "请求X",
        targetX,
        "请求Y",
        targetY,
        "间隙",
        gap ~= nil and _____516B_4E91_7D2B_8BCA_65AD_53E5_67C4(gap["单位"]) or 0
    )
    if gap ~= nil then
        _____521B_5EFA_4E8C_6BB5_5217_8F66(context["英雄"], gap, context["技能实例ID"])
    end
end
function _____5F00_542F_4E8C_6BB5_7A97_53E3(hero, gap, skillInstanceId)
    local heroId = _____53E5_67C4ID(hero)
    local previous = _____4E8C_6BB5_7B49_5F85_8868[heroId]
    if previous ~= nil then
        _____6E05_9664_4E8C_6BB5_7B49_5F85(previous)
    end
    local context = {["英雄"] = hero, ["进入裂隙"] = gap, ["技能实例ID"] = skillInstanceId, ["已结束"] = false}
    _____4E8C_6BB5_7B49_5F85_8868[heroId] = context
    _____516B_4E91_7D2B_8BCA_65AD_65E5_5FD7(
        "R",
        "开启二段窗口",
        "英雄",
        heroId,
        "进入裂隙",
        _____516B_4E91_7D2B_8BCA_65AD_53E5_67C4(gap["单位"]),
        "窗口秒",
        _____914D_7F6E.R["主动二段窗口秒"]
    )
    addDelayedCallback(_____914D_7F6E.R["主动二段窗口秒"] * 1000, _____4E8C_6BB5_7A97_53E3_8D85_65F6, context)
end
function _____5217_8F66Tick(variable)
    local context = variable
    if context == nil or context["已结束"] then
        return
    end
    if not _____516B_4E91_7D2B_5355_4F4D_5B58_6D3B(context["英雄"]) or context["剩余Tick"] <= 0 then
        _____7ED3_675F_5217_8F66(context)
        return
    end
    context.X = context.X + math.cos(context["方向弧度"]) * _____914D_7F6E.R["列车每Tick距离"]
    context.Y = context.Y + math.sin(context["方向弧度"]) * _____914D_7F6E.R["列车每Tick距离"]
    context["剩余Tick"] = context["剩余Tick"] - 1
    if context["剩余Tick"] == _____914D_7F6E.R["列车Tick数"] - 1 or context["剩余Tick"] % 10 == 0 then
        _____516B_4E91_7D2B_8BCA_65AD_65E5_5FD7(
            "R",
            "列车Tick",
            "英雄",
            _____516B_4E91_7D2B_8BCA_65AD_53E5_67C4(context["英雄"]),
            "X",
            context.X,
            "Y",
            context.Y,
            "剩余Tick",
            context["剩余Tick"],
            "特效有效",
            context["特效"] ~= nil and context["特效"] ~= 0
        )
    end
    if context["特效"] ~= nil and context["特效"] ~= 0 then
        DzSetEffectPos(context["特效"], context.X, context.Y, 0)
    end
    _____521B_5EFA_5217_8F66_8DEF_5F84_8868_73B0(context)
    _____7ED3_7B97_5217_8F66_78B0_649E(context)
    if context["允许触发二段"] then
        local gap = _____67E5_627E_516B_4E91_7D2B_88C2_9699(context.X, context.Y, _____914D_7F6E["裂隙"]["扩散触发半径"], context["英雄"])
        if gap ~= nil and _____53E5_67C4ID(gap["单位"]) ~= context["起点裂隙ID"] then
            _____516B_4E91_7D2B_8BCA_65AD_65E5_5FD7(
                "R",
                "列车进入另一间隙",
                "列车X",
                context.X,
                "列车Y",
                context.Y,
                "起点裂隙",
                context["起点裂隙ID"],
                "命中裂隙",
                _____516B_4E91_7D2B_8BCA_65AD_53E5_67C4(gap["单位"])
            )
            _____7ED3_675F_5217_8F66(context)
            _____5F00_542F_4E8C_6BB5_7A97_53E3(context["英雄"], gap, context["技能实例ID"])
            return
        end
    end
    if context["剩余Tick"] <= 0 then
        _____7ED3_675F_5217_8F66(context)
    end
end
function _____542F_52A8_5217_8F66(hero, startGap, direction, canTriggerSecond, skillInstanceId)
    local x = jass.GetUnitX(startGap["单位"])
    local y = jass.GetUnitY(startGap["单位"])
    local effect = _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E.R["列车模型"],
        X = x,
        Y = y,
        ["面向角度"] = direction,
        ["缩放"] = _____914D_7F6E.R["列车缩放"],
        ["红"] = _____914D_7F6E.R["列车颜色"][1],
        ["绿"] = _____914D_7F6E.R["列车颜色"][2],
        ["蓝"] = _____914D_7F6E.R["列车颜色"][3],
        ["透明度"] = _____914D_7F6E.R["列车颜色"][4]
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E.E["出现特效"],
        X = x,
        Y = y,
        ["持续秒"] = 1.5,
        ["缩放"] = 2
    })
    local context = {
        ["英雄"] = hero,
        X = x,
        Y = y,
        ["方向角"] = direction,
        ["方向弧度"] = direction * math.pi / 180,
        ["剩余Tick"] = _____914D_7F6E.R["列车Tick数"],
        ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(hero) * _____914D_7F6E.R["伤害攻击力比例"],
        ["特效"] = effect,
        ["周期ID"] = 0,
        ["起点裂隙ID"] = _____53E5_67C4ID(startGap["单位"]),
        ["允许触发二段"] = canTriggerSecond,
        ["技能实例ID"] = skillInstanceId,
        ["已结束"] = false
    }
    _____516B_4E91_7D2B_8BCA_65AD_65E5_5FD7(
        "R",
        "启动列车",
        "英雄",
        _____516B_4E91_7D2B_8BCA_65AD_53E5_67C4(hero),
        "起点裂隙",
        _____516B_4E91_7D2B_8BCA_65AD_53E5_67C4(startGap["单位"]),
        "起点X",
        x,
        "起点Y",
        y,
        "方向角",
        direction,
        "允许二段",
        canTriggerSecond,
        "伤害",
        context["伤害"],
        "特效有效",
        effect ~= nil and effect ~= 0,
        "Tick数",
        _____914D_7F6E.R["列车Tick数"]
    )
    context["周期ID"] = addPeriodicCallback(_____914D_7F6E.R["列车Tick毫秒"], _____5217_8F66Tick, context)
end
jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_0.addDelayedCallback
addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_1["创建点特效"]
_____9500_6BC1_70B9_7279_6548 = ____require_result_1["销毁点特效"]
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
getEnemyUnitsInRange = ____require_result_2.getEnemyUnitsInRange
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_3["读取单位攻击力"]
_____4E24_70B9_89D2_5EA6 = ____require_result_3["两点角度"]
local _____8DDD_79BBXY = ____require_result_3["距离XY"]
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_4["造成单体技能伤害"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
_____65BD_52A0_7729_6655 = ____require_result_5["施加眩晕"]
local ____require_result_6 = require("平台扩展API动作")
local _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4 = ____require_result_6["技能_设置技能冷却时间"]
local ____require_result_7 = require("平台扩展API取值")
local _____6280_80FD__83B7_53D6_6280_80FD_6700_5927_51B7_5374_65F6_95F4 = ____require_result_7["技能_获取技能最大冷却时间"]
_____914D_7F6E = _____516B_4E91_7D2B_5355_4F4D_6280_80FD_914D_7F6E
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
WEAPON_TYPE_ROCK_HEAVY_BASH = jass.WEAPON_TYPE_ROCK_HEAVY_BASH
PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY
STUN_BUFF_ID = 1112757326
PSEUDO_STUN_BUFF_ID = 1112560453
DzSetEffectPos = japi.DzSetEffectPos
EXSetEffectSize = japi.EXSetEffectSize
_____4E8C_6BB5_7B49_5F85_8868 = {}
local function _____9009_62E9_76EE_6807_88C2_9699(hero, targetX, targetY)
    local gaps = _____83B7_53D6_8303_56F4_5185_516B_4E91_7D2B_88C2_9699(targetX, targetY, _____914D_7F6E.R["裂隙选择范围"], hero)
    _____516B_4E91_7D2B_8BCA_65AD_65E5_5FD7(
        "R",
        "搜索目标裂隙",
        "英雄",
        _____516B_4E91_7D2B_8BCA_65AD_53E5_67C4(hero),
        "目标X",
        targetX,
        "目标Y",
        targetY,
        "搜索范围",
        _____914D_7F6E.R["裂隙选择范围"],
        "候选数",
        #gaps
    )
    local selected
    local selectedDistance = _____914D_7F6E.R["裂隙选择范围"] + 1
    do
        local i = 0
        while i < #gaps do
            local distance = _____8DDD_79BBXY(
                targetX,
                targetY,
                jass.GetUnitX(gaps[i + 1]["单位"]),
                jass.GetUnitY(gaps[i + 1]["单位"])
            )
            _____516B_4E91_7D2B_8BCA_65AD_65E5_5FD7(
                "R",
                "目标裂隙候选",
                "间隙",
                _____516B_4E91_7D2B_8BCA_65AD_53E5_67C4(gaps[i + 1]["单位"]),
                "X",
                jass.GetUnitX(gaps[i + 1]["单位"]),
                "Y",
                jass.GetUnitY(gaps[i + 1]["单位"]),
                "距离",
                distance,
                "长期",
                gaps[i + 1]["长期"]
            )
            if distance < selectedDistance then
                selected = gaps[i + 1]
                selectedDistance = distance
            end
            i = i + 1
        end
    end
    return selected
end
local function _____83B7_53D6R_76D1_542C_4E0A_4E0B_6587(hero)
    return _____662F_516B_4E91_7D2B(hero) and ({["英雄"] = hero}) or nil
end
local function _____91CA_653ER(_entry, hero, skillInstanceId)
    local targetX = jass.GetSpellTargetX()
    local targetY = jass.GetSpellTargetY()
    local gap = _____9009_62E9_76EE_6807_88C2_9699(hero, targetX, targetY)
    _____516B_4E91_7D2B_8BCA_65AD_65E5_5FD7(
        "R",
        "收到R施法",
        "英雄",
        _____516B_4E91_7D2B_8BCA_65AD_53E5_67C4(hero),
        "英雄X",
        jass.GetUnitX(hero),
        "英雄Y",
        jass.GetUnitY(hero),
        "目标X",
        targetX,
        "目标Y",
        targetY,
        "选中间隙",
        gap ~= nil and _____516B_4E91_7D2B_8BCA_65AD_53E5_67C4(gap["单位"]) or 0,
        "技能实例ID",
        skillInstanceId or 0
    )
    if gap == nil then
        _____516B_4E91_7D2B_8BCA_65AD_65E5_5FD7("R", "R入口失败", "原因", "目标点400范围没有同玩家已登记间隙")
        jass.DisplayTimedTextToPlayer(
            jass.GetOwningPlayer(hero),
            0,
            0,
            3,
            "目标位置附近没有可用的『间隙』。 "
        )
        local maximum = _____6280_80FD__83B7_53D6_6280_80FD_6700_5927_51B7_5374_65F6_95F4(hero, _____914D_7F6E["技能"].R["类型ID"]) or 80
        _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(hero, _____914D_7F6E["技能"].R["类型ID"], _____914D_7F6E.R["无合法裂隙失败冷却秒"], maximum)
        return
    end
    local direction = _____4E24_70B9_89D2_5EA6(
        jass.GetUnitX(gap["单位"]),
        jass.GetUnitY(gap["单位"]),
        targetX,
        targetY
    )
    if _____8DDD_79BBXY(
        jass.GetUnitX(gap["单位"]),
        jass.GetUnitY(gap["单位"]),
        targetX,
        targetY
    ) <= 1 then
        direction = jass.GetUnitFacing(hero)
    end
    _____516B_4E91_7D2B_8BCA_65AD_65E5_5FD7(
        "R",
        "R入口成功",
        "间隙",
        _____516B_4E91_7D2B_8BCA_65AD_53E5_67C4(gap["单位"]),
        "列车方向",
        direction
    )
    _____542F_52A8_5217_8F66(
        hero,
        gap,
        direction,
        true,
        skillInstanceId
    )
end
local function _____76D1_542C_4E3B_52A8_4E8C_6BB5_88C2_9699(hero, gap, skillId, _skillInstanceId)
    _____516B_4E91_7D2B_8BCA_65AD_65E5_5FD7(
        "R",
        "收到裂隙创建监听",
        "英雄",
        _____516B_4E91_7D2B_8BCA_65AD_53E5_67C4(hero),
        "间隙",
        _____516B_4E91_7D2B_8BCA_65AD_53E5_67C4(gap["单位"]),
        "来源技能ID",
        skillId,
        "要求D技能ID",
        _____914D_7F6E["技能"].D["类型ID"],
        "存在二段窗口",
        _____4E8C_6BB5_7B49_5F85_8868[_____53E5_67C4ID(hero)] ~= nil
    )
    if skillId ~= _____914D_7F6E["技能"].D["类型ID"] then
        return
    end
    local context = _____4E8C_6BB5_7B49_5F85_8868[_____53E5_67C4ID(hero)]
    if context == nil or context["已结束"] then
        _____516B_4E91_7D2B_8BCA_65AD_65E5_5FD7("R", "主动二段未触发", "原因", context == nil and "没有二段窗口" or "二段窗口已结束")
        return
    end
    _____6E05_9664_4E8C_6BB5_7B49_5F85(context)
    _____521B_5EFA_4E8C_6BB5_5217_8F66(hero, gap, context["技能实例ID"])
end
_____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
    ["名称"] = "八云紫-废弃车站下车之旅（R）",
    ["单位类型ID"] = _____914D_7F6E["单位"]["英雄类型ID"],
    ["技能ID"] = _____914D_7F6E["技能"].R["类型ID"],
    ["获取或创建上下文"] = _____83B7_53D6R_76D1_542C_4E0A_4E0B_6587,
    ["释放技能"] = _____91CA_653ER,
    ["创建独立技能实例"] = true,
    ["独立技能来源类型"] = "单位技能",
    ["技能实例持续时间秒"] = 8
})
_____6CE8_518C_516B_4E91_7D2B_88C2_9699_521B_5EFA_76D1_542C_5668(_____76D1_542C_4E3B_52A8_4E8C_6BB5_88C2_9699)
return ____exports

local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.12．八云紫.00．配置")
local _____516B_4E91_7D2B_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["八云紫单位技能配置"]
local ____01_FF0E_88C2_9699_7CFB_7EDF = require("系统.03．技能系统.05．单位技能.04．英雄技能.12．八云紫.07．公共与单位壳.01．裂隙系统")
local _____516B_4E91_7D2B_5355_4F4D_5B58_6D3B = ____01_FF0E_88C2_9699_7CFB_7EDF["八云紫单位存活"]
local _____662F_516B_4E91_7D2B = ____01_FF0E_88C2_9699_7CFB_7EDF["是八云紫"]
local _____662F_516B_4E91_7D2B_5408_6CD5_654C_4EBA = ____01_FF0E_88C2_9699_7CFB_7EDF["是八云紫合法敌人"]
local _____67E5_627E_516B_4E91_7D2B_88C2_9699 = ____01_FF0E_88C2_9699_7CFB_7EDF["查找八云紫裂隙"]
local _____83B7_53D6_8303_56F4_5185_516B_4E91_7D2B_88C2_9699 = ____01_FF0E_88C2_9699_7CFB_7EDF["获取范围内八云紫裂隙"]
local _____6CE8_518C_516B_4E91_7D2B_88C2_9699_6269_6563_53D1_5C04_5668 = ____01_FF0E_88C2_9699_7CFB_7EDF["注册八云紫裂隙扩散发射器"]
local _____89E6_53D1_516B_4E91_7D2B_88C2_9699_6269_6563 = ____01_FF0E_88C2_9699_7CFB_7EDF["触发八云紫裂隙扩散"]
local _____521B_5EFA_516B_4E91_7D2B_70B9_7279_6548 = ____01_FF0E_88C2_9699_7CFB_7EDF["创建八云紫点特效"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.12．八云紫.00A．表现工具")
local _____64AD_653E_516B_4E91_7D2B_5355_4F4D_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放八云紫单位音效"]
local _____64AD_653E_516B_4E91_7D2B_968F_673A_5355_4F4D_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放八云紫随机单位音效"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____6781_5750_6807X = ____require_result_1["极坐标X"]
local _____6781_5750_6807Y = ____require_result_1["极坐标Y"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____require_result_2["创建原生弹幕"]
local _____83B7_53D6_539F_751F_5F39_5E55 = ____require_result_2["获取原生弹幕"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_3["读取单位攻击力"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_3["两点角度"]
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_4["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_4["移除单位暂停"]
local _____914D_7F6E = _____516B_4E91_7D2B_5355_4F4D_6280_80FD_914D_7F6E
local ____Q_6682_505C_6765_6E90 = "八云紫-Q-波与粒的境界"
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____5F39_5E55_4E0A_4E0B_6587_8868 = {}
local function _____5F39_5E55_7ED3_675F(_reason, projectileId)
    __TS__Delete(_____5F39_5E55_4E0A_4E0B_6587_8868, projectileId)
end
local function _____5F39_5E55_76EE_6807_7B5B_9009(target, projectileId)
    local context = _____5F39_5E55_4E0A_4E0B_6587_8868[projectileId]
    return context ~= nil and _____662F_516B_4E91_7D2B_5408_6CD5_654C_4EBA(context["施法者"], target)
end
local function _____5F39_5E55Tick(instance, _delta)
    local context = _____5F39_5E55_4E0A_4E0B_6587_8868[instance.id]
    if context == nil then
        return
    end
    if instance["已飞行距离"] >= context["最短飞行距离"] and instance["参数"]["命中半径"] ~= context["最终命中半径"] then
        instance["参数"]["命中半径"] = context["最终命中半径"]
    end
    if not context["普通弹幕"] then
        return
    end
    local nearby = _____83B7_53D6_8303_56F4_5185_516B_4E91_7D2B_88C2_9699(instance["当前X"], instance["当前Y"], _____914D_7F6E.Q["自动追踪裂隙范围"], context["施法者"])
    if #nearby > 0 then
        local targetGap = nearby[1]
        if not context["已记录追踪"] then
            context["已记录追踪"] = true
        end
        instance["当前方向角"] = _____4E24_70B9_89D2_5EA6(
            instance["当前X"],
            instance["当前Y"],
            jass.GetUnitX(targetGap["单位"]),
            jass.GetUnitY(targetGap["单位"])
        )
    end
    local touched = _____67E5_627E_516B_4E91_7D2B_88C2_9699(instance["当前X"], instance["当前Y"], _____914D_7F6E["裂隙"]["扩散触发半径"], context["施法者"])
    if touched == nil then
        return
    end
    local gapId = jass.GetHandleId(touched["单位"])
    if context["已触发裂隙"][gapId] == true then
        return
    end
    context["已触发裂隙"][gapId] = true
    _____64AD_653E_516B_4E91_7D2B_5355_4F4D_97F3_6548(context["施法者"], _____914D_7F6E.Q["裂隙触发音效键"])
    _____89E6_53D1_516B_4E91_7D2B_88C2_9699_6269_6563(context["施法者"], touched)
end
____exports["发射八云紫弹幕"] = function(options)
    local minDistance = options["最短飞行距离"] or 0
    local instance = _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = options["施法者"],
        X = options.X,
        Y = options.Y,
        ["方向角"] = options["方向角"],
        ["速度"] = options["速度"],
        ["最大距离"] = options["最大距离"] or _____914D_7F6E.Q["飞行距离"],
        ["生命周期"] = _____914D_7F6E.Q["生命周期秒"],
        ["命中半径"] = minDistance > 0 and 0 or options["命中半径"],
        ["影响目标"] = "敌方",
        ["碰撞消失"] = false,
        ["每单位最大命中次数"] = 1,
        ["伤害值"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(options["施法者"]) * options["伤害攻击力比例"],
        ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = options["技能ID"],
        ["技能实例ID"] = options["技能实例ID"],
        ["技能标签"] = options["普通弹幕"] and "八云紫-普通弹幕" or "八云紫-强化弹幕",
        ["伤害形态"] = "AOE",
        ["参与技能伤害加成"] = true,
        ["模型"] = _____914D_7F6E.Q["模型"],
        ["缩放"] = options["缩放"],
        ["飞行高度"] = options["高度"],
        ["显式改向后锁定方向"] = true,
        ["目标筛选"] = _____5F39_5E55_76EE_6807_7B5B_9009,
        onTick = _____5F39_5E55Tick,
        ["on结束"] = _____5F39_5E55_7ED3_675F
    })
    if instance == nil then
        return 0
    end
    _____5F39_5E55_4E0A_4E0B_6587_8868[instance["弹幕ID"]] = {
        ["施法者"] = options["施法者"],
        ["普通弹幕"] = options["普通弹幕"],
        ["最终命中半径"] = options["命中半径"],
        ["最短飞行距离"] = minDistance,
        ["已触发裂隙"] = {},
        ["已记录追踪"] = false
    }
    return instance["弹幕ID"]
end
local function _____53D1_5C04_516D_5411_5F3A_5316_5F39_5E55(hero, gap)
    local x = jass.GetUnitX(gap["单位"])
    local y = jass.GetUnitY(gap["单位"])
    _____521B_5EFA_516B_4E91_7D2B_70B9_7279_6548(
        "war3mapImported\\ancientexplodeblue.mdx",
        x,
        y,
        2,
        1
    )
    do
        local i = 0
        while i < 6 do
            ____exports["发射八云紫弹幕"]({
                ["施法者"] = hero,
                X = x,
                Y = y,
                ["方向角"] = 60 * (i + 1),
                ["速度"] = _____914D_7F6E.Q["强化速度"],
                ["高度"] = _____914D_7F6E.Q["普通高度"],
                ["缩放"] = _____914D_7F6E.Q["强化缩放"],
                ["命中半径"] = _____914D_7F6E.Q["强化半径"],
                ["伤害攻击力比例"] = _____914D_7F6E.Q["基础伤害攻击力比例"] * _____914D_7F6E.Q["裂隙扩散倍率"],
                ["技能ID"] = _____914D_7F6E["技能"].Q["类型ID"],
                ["普通弹幕"] = false,
                ["最短飞行距离"] = _____914D_7F6E.Q["强化最短飞行距离"]
            })
            i = i + 1
        end
    end
end
local function _____53D1_5C04_6307_5B9A_88C2_9699_6CE2(variable)
    local data = variable
    if data == nil or not _____516B_4E91_7D2B_5355_4F4D_5B58_6D3B(data["英雄"]) or data["裂隙"]["已结束"] then
        return
    end
    local x = jass.GetUnitX(data["裂隙"]["单位"])
    local y = jass.GetUnitY(data["裂隙"]["单位"])
    _____64AD_653E_516B_4E91_7D2B_5355_4F4D_97F3_6548(data["英雄"], _____914D_7F6E.Q["裂隙爆发音效键"], true)
    _____521B_5EFA_516B_4E91_7D2B_70B9_7279_6548(
        "war3mapImported\\ancientexplodeblue.mdx",
        x,
        y,
        2,
        1
    )
    do
        local i = 0
        while i < 6 do
            ____exports["发射八云紫弹幕"]({
                ["施法者"] = data["英雄"],
                X = x,
                Y = y,
                ["方向角"] = 60 * (i + 1),
                ["速度"] = _____914D_7F6E.Q["强化速度"],
                ["高度"] = _____914D_7F6E.Q["强化高度"],
                ["缩放"] = _____914D_7F6E.Q["强化缩放"],
                ["命中半径"] = _____914D_7F6E.Q["指定裂隙强化半径"],
                ["伤害攻击力比例"] = _____914D_7F6E.Q["基础伤害攻击力比例"] * _____914D_7F6E.Q["指定裂隙倍率"],
                ["技能ID"] = _____914D_7F6E["技能"].Q["类型ID"],
                ["技能实例ID"] = data["技能实例ID"],
                ["普通弹幕"] = false,
                ["最短飞行距离"] = _____914D_7F6E.Q["强化最短飞行距离"]
            })
            i = i + 1
        end
    end
end
local function _____89E3_9664Q_786C_76F4(variable)
    local hero = variable
    if hero ~= nil and hero ~= 0 then
        _____79FB_9664_5355_4F4D_6682_505C(hero, ____Q_6682_505C_6765_6E90)
    end
end
local function _____83B7_53D6Q_4E0A_4E0B_6587(hero)
    return _____662F_516B_4E91_7D2B(hero) and ({["英雄"] = hero}) or nil
end
local function _____91CA_653EQ(_context, hero, skillInstanceId)
    local heroX = jass.GetUnitX(hero)
    local heroY = jass.GetUnitY(hero)
    local targetX = jass.GetSpellTargetX()
    local targetY = jass.GetSpellTargetY()
    local targetGap = _____67E5_627E_516B_4E91_7D2B_88C2_9699(targetX, targetY, 100, hero)
    _____6DFB_52A0_5355_4F4D_6682_505C(hero, ____Q_6682_505C_6765_6E90)
    jass.SetUnitAnimation(hero, "attack,2")
    addDelayedCallback(_____914D_7F6E.Q["硬直秒"] * 1000, _____89E3_9664Q_786C_76F4, hero)
    if targetGap ~= nil then
        _____64AD_653E_516B_4E91_7D2B_968F_673A_5355_4F4D_97F3_6548(hero, _____914D_7F6E.Q["指定裂隙语音键"])
        do
            local i = 1
            while i <= _____914D_7F6E.Q["指定裂隙波数"] do
                addDelayedCallback(i * _____914D_7F6E.Q["指定裂隙波间隔秒"] * 1000, _____53D1_5C04_6307_5B9A_88C2_9699_6CE2, {["英雄"] = hero, ["裂隙"] = targetGap, ["技能实例ID"] = skillInstanceId})
                i = i + 1
            end
        end
        return
    end
    _____64AD_653E_516B_4E91_7D2B_5355_4F4D_97F3_6548(hero, _____914D_7F6E.Q["普通起手音效键"])
    _____64AD_653E_516B_4E91_7D2B_968F_673A_5355_4F4D_97F3_6548(hero, _____914D_7F6E.Q["普通语音键"])
    local baseAngle = _____4E24_70B9_89D2_5EA6(heroX, heroY, targetX, targetY)
    do
        local i = 0
        while i < _____914D_7F6E.Q["普通弹幕数量"] do
            local angle = baseAngle + _____914D_7F6E.Q["普通角度偏移"][i + 1]
            local distance = _____914D_7F6E.Q["普通创建距离"][i + 1]
            ____exports["发射八云紫弹幕"]({
                ["施法者"] = hero,
                X = _____6781_5750_6807X(heroX, angle, distance),
                Y = _____6781_5750_6807Y(heroY, angle, distance),
                ["方向角"] = angle,
                ["速度"] = _____914D_7F6E.Q["普通速度"],
                ["高度"] = _____914D_7F6E.Q["普通高度"],
                ["缩放"] = _____914D_7F6E.Q["普通缩放"],
                ["命中半径"] = _____914D_7F6E.Q["普通半径"],
                ["伤害攻击力比例"] = _____914D_7F6E.Q["基础伤害攻击力比例"],
                ["技能ID"] = _____914D_7F6E["技能"].Q["类型ID"],
                ["技能实例ID"] = skillInstanceId,
                ["普通弹幕"] = true
            })
            i = i + 1
        end
    end
end
_____6CE8_518C_516B_4E91_7D2B_88C2_9699_6269_6563_53D1_5C04_5668(_____53D1_5C04_516D_5411_5F3A_5316_5F39_5E55)
_____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
    ["名称"] = "八云紫-波与粒的境界（Q）",
    ["单位类型ID"] = _____914D_7F6E["单位"]["英雄类型ID"],
    ["技能ID"] = _____914D_7F6E["技能"].Q["类型ID"],
    ["获取或创建上下文"] = _____83B7_53D6Q_4E0A_4E0B_6587,
    ["释放技能"] = _____91CA_653EQ,
    ["创建独立技能实例"] = true,
    ["独立技能来源类型"] = "单位技能",
    ["技能实例持续时间秒"] = 5
})
return ____exports

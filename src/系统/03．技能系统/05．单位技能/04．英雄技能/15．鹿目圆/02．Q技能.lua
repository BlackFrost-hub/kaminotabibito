local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____79FB_9664Q_5355_4F4D_58F3, _____8BB0_5F55Q_8FDE_7EED_547D_4E2D, _____6E05_7406_4E09_4E2AQ_5355_4F4D_58F3, ____Q_6BCF_76EE_6807_7ED3_7B97_540E, _____65BD_52A0_7729_6655, GetHandleId, RemoveUnit, _____914D_7F6E
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.15．鹿目圆.00．配置")
local _____9E7F_76EE_5706_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["鹿目圆单位技能配置"]
local ____01_FF0E_72B6_6001_4E0E_88AB_52A8 = require("系统.03．技能系统.05．单位技能.04．英雄技能.15．鹿目圆.01．状态与被动")
local _____662F_9E7F_76EE_5706 = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["是鹿目圆"]
local _____9E7F_76EE_5706_4F24_5BB3_65E0_89C6_9B54_6297 = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["鹿目圆伤害无视魔抗"]
local _____9E7F_76EE_5706_6CBB_7597_53CB_519B = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["鹿目圆治疗友军"]
local _____6D88_8017_9E7F_76EE_5706_5706_73AF_5F3A_5316 = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["消耗鹿目圆圆环强化"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
function _____79FB_9664Q_5355_4F4D_58F3(unit)
    if unit ~= nil and unit ~= 0 then
        RemoveUnit(unit)
    end
end
function _____8BB0_5F55Q_8FDE_7EED_547D_4E2D(context, target)
    local targetId = GetHandleId(target)
    local next = (context["命中次数"][targetId] or 0) + 1
    context["命中次数"][targetId] = next
    if next == _____914D_7F6E.Q["连续命中眩晕次数"] then
        _____65BD_52A0_7729_6655(
            context["施法者"],
            target,
            _____914D_7F6E.Q["连续命中眩晕秒"],
            "鹿目圆-圆环射击",
            "技能"
        )
    end
end
function _____6E05_7406_4E09_4E2AQ_5355_4F4D_58F3(variable)
    local data = variable
    if data == nil then
        return
    end
    _____79FB_9664Q_5355_4F4D_58F3(data["坠落壳"])
    _____79FB_9664Q_5355_4F4D_58F3(data["爆炸壳"])
    _____79FB_9664Q_5355_4F4D_58F3(data["攻击承载壳"])
end
function ____Q_6BCF_76EE_6807_7ED3_7B97_540E(target, _index, success, variable)
    if not success then
        return
    end
    local context = variable
    if context == nil then
        return
    end
    _____8BB0_5F55Q_8FDE_7EED_547D_4E2D(context, target)
end
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_1["造成单体技能伤害"]
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_1["造成批量AOE技能伤害"]
local _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_1["结束独立技能伤害实例"]
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_2.registerAppliedFinalDamageListener
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_3["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_3["移除单位暂停"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
_____65BD_52A0_7729_6655 = ____require_result_4["施加眩晕"]
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_5["创建单位并登记排泄安全"]
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_6.getUnitsInRange
local getEnemyUnitsInRange = ____require_result_6.getEnemyUnitsInRange
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_7["读取单位攻击力"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_7["两点角度"]
GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetOwningPlayer = jass.GetOwningPlayer
local GetHeroLevel = jass.GetHeroLevel
local GetRandomInt = jass.GetRandomInt
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local SetUnitFacing = jass.SetUnitFacing
local SetUnitFlyHeight = jass.SetUnitFlyHeight
local SetUnitScale = jass.SetUnitScale
local SetUnitAnimation = jass.SetUnitAnimation
RemoveUnit = jass.RemoveUnit
local IsUnitType = jass.IsUnitType
local IsUnitAlly = jass.IsUnitAlly
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local DAMAGE_TYPE_DIVINE = jass.DAMAGE_TYPE_DIVINE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
_____914D_7F6E = _____9E7F_76EE_5706_5355_4F4D_6280_80FD_914D_7F6E
local ____Q_4F24_5BB3_6807_7B7E = "鹿目圆-Q-区域"
local ____Q_4E0A_4E0B_6587_8868 = {}
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
local function _____662FQ_6709_6548_654C_4EBA(source, target)
    return _____5355_4F4D_5B58_6D3B(target) and IsUnitType(target, UNIT_TYPE_MECHANICAL) ~= true and IsUnitType(target, UNIT_TYPE_ANCIENT) ~= true and jass.IsUnitEnemy(
        target,
        GetOwningPlayer(source)
    ) == true
end
local function _____9009_62E9Q_9501_5B9A_76EE_6807(source, x, y)
    local candidates = getEnemyUnitsInRange(source, x, y, _____914D_7F6E.Q["目标半径"])
    local pool = {}
    local result = {}
    do
        local i = 0
        while i < #candidates do
            if _____662FQ_6709_6548_654C_4EBA(source, candidates[i + 1]) then
                pool[#pool + 1] = candidates[i + 1]
            end
            i = i + 1
        end
    end
    while #result < _____914D_7F6E.Q["箭数量"] and #pool > 0 do
        local index = GetRandomInt(0, #pool - 1)
        result[#result + 1] = pool[index + 1]
        __TS__ArraySplice(pool, index, 1)
    end
    return result
end
local function _____7ED3_675FQ_6280_80FD(context)
    if context["已结束"] then
        return
    end
    context["已结束"] = true
    _____79FB_9664_5355_4F4D_6682_505C(context["施法者"], context["暂停来源"])
    if ____Q_4E0A_4E0B_6587_8868[GetHandleId(context["施法者"])] == context then
        __TS__Delete(
            ____Q_4E0A_4E0B_6587_8868,
            GetHandleId(context["施法者"])
        )
    end
    _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(context["技能实例ID"])
end
local function _____89E3_9664Q_786C_76F4(variable)
    local context = variable
    if context == nil or context["已结束"] then
        return
    end
    _____79FB_9664_5355_4F4D_6682_505C(context["施法者"], context["暂停来源"])
end
local function ____Q_6536_5C3E(variable)
    local context = variable
    if context ~= nil then
        _____7ED3_675FQ_6280_80FD(context)
    end
end
local function _____7ED3_7B97Q_7BAD(state)
    local context = state["上下文"]
    local source = context["施法者"]
    local targetX = state["终点X"]
    local targetY = state["终点Y"]
    _____79FB_9664Q_5355_4F4D_58F3(state["箭单位"])
    if context["已结束"] or not _____5355_4F4D_5B58_6D3B(source) then
        return
    end
    local owner = GetOwningPlayer(source)
    local _____5760_843D_58F3 = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        owner,
        _____914D_7F6E["单位壳"]["Q坠落箭"],
        targetX,
        targetY,
        0
    )
    local _____7206_70B8_58F3 = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        owner,
        _____914D_7F6E["单位壳"]["Q爆炸"],
        targetX,
        targetY,
        0
    )
    local _____653B_51FB_627F_8F7D_58F3 = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        owner,
        _____914D_7F6E["单位壳"]["Q攻击承载"],
        targetX,
        targetY,
        0
    )
    addDelayedCallback(_____914D_7F6E.Q["爆炸特效持续秒"] * 1000, _____6E05_7406_4E09_4E2AQ_5355_4F4D_58F3, {["坠落壳"] = _____5760_843D_58F3, ["爆炸壳"] = _____7206_70B8_58F3, ["攻击承载壳"] = _____653B_51FB_627F_8F7D_58F3})
    local targets = getEnemyUnitsInRange(source, targetX, targetY, _____914D_7F6E.Q["目标半径"])
    local validTargets = {}
    do
        local i = 0
        while i < #targets do
            if _____662FQ_6709_6548_654C_4EBA(source, targets[i + 1]) then
                validTargets[#validTargets + 1] = targets[i + 1]
            end
            i = i + 1
        end
    end
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = source,
        ["目标列表"] = validTargets,
        ["伤害"] = context["伤害"],
        ["伤害类型"] = DAMAGE_TYPE_MAGIC,
        attack = false,
        ranged = true,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____914D_7F6E["技能"].Q["类型ID"],
        ["技能实例ID"] = context["技能实例ID"],
        ["标签"] = ____Q_4F24_5BB3_6807_7B7E,
        ["参与技能伤害加成"] = true,
        ["忽略魔法抗性"] = context["忽略魔抗"],
        ["每目标结算后处理器"] = ____Q_6BCF_76EE_6807_7ED3_7B97_540E,
        ["变量"] = context
    })
    if _____662FQ_6709_6548_654C_4EBA(source, state["锁定目标"]) then
        _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
            ["来源"] = source,
            ["目标"] = state["锁定目标"],
            ["伤害"] = context["额外光伤"],
            ["伤害类型"] = DAMAGE_TYPE_DIVINE,
            attack = false,
            ranged = true,
            attackType = ATTACK_TYPE_NORMAL,
            weaponType = WEAPON_TYPE_WHOKNOWS,
            ["来源类型"] = "单位技能",
            ["技能ID"] = _____914D_7F6E["技能"].Q["类型ID"],
            ["技能实例ID"] = context["技能实例ID"],
            ["标签"] = "鹿目圆-Q-锁定光伤",
            ["参与技能伤害加成"] = true
        })
    end
end
local function _____63A8_8FDBQ_7BAD(variable)
    local state = variable
    if state == nil then
        return
    end
    local context = state["上下文"]
    if context["已结束"] or not _____5355_4F4D_5B58_6D3B(state["箭单位"]) then
        if state["周期ID"] ~= 0 then
            removePeriodicCallback(state["周期ID"])
        end
        _____79FB_9664Q_5355_4F4D_58F3(state["箭单位"])
        return
    end
    state["已飞行毫秒"] = state["已飞行毫秒"] + 50
    local rate = state["已飞行毫秒"] >= _____914D_7F6E.Q["箭命中延迟毫秒"] and 1 or state["已飞行毫秒"] / _____914D_7F6E.Q["箭命中延迟毫秒"]
    SetUnitX(state["箭单位"], state["起点X"] + (state["终点X"] - state["起点X"]) * rate)
    SetUnitY(state["箭单位"], state["起点Y"] + (state["终点Y"] - state["起点Y"]) * rate)
    if rate < 1 then
        return
    end
    if state["周期ID"] ~= 0 then
        removePeriodicCallback(state["周期ID"])
    end
    state["周期ID"] = 0
    _____7ED3_7B97Q_7BAD(state)
end
local function _____53D1_5C04Q_7BAD(variable)
    local data = variable
    if data == nil or data["上下文"]["已结束"] then
        return
    end
    local context = data["上下文"]
    local source = context["施法者"]
    local locked = context["锁定目标"][data["索引"] + 1]
    if not _____5355_4F4D_5B58_6D3B(source) or not _____5355_4F4D_5B58_6D3B(locked) then
        return
    end
    local startX = GetUnitX(source)
    local startY = GetUnitY(source)
    local endX = GetUnitX(locked)
    local endY = GetUnitY(locked)
    local angle = _____4E24_70B9_89D2_5EA6(startX, startY, endX, endY)
    local arrow = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        GetOwningPlayer(source),
        _____914D_7F6E["单位壳"]["Q起手箭"],
        startX,
        startY,
        angle
    )
    if arrow == nil or arrow == 0 then
        return
    end
    SetUnitFacing(arrow, angle)
    SetUnitFlyHeight(arrow, _____914D_7F6E.Q["箭飞行高度"], 0)
    SetUnitScale(arrow, _____914D_7F6E.Q["箭飞行缩放"], _____914D_7F6E.Q["箭飞行缩放"], _____914D_7F6E.Q["箭飞行缩放"])
    local state = {
        ["上下文"] = context,
        ["锁定目标"] = locked,
        ["箭单位"] = arrow,
        ["起点X"] = startX,
        ["起点Y"] = startY,
        ["终点X"] = endX,
        ["终点Y"] = endY,
        ["已飞行毫秒"] = 0,
        ["周期ID"] = 0
    }
    state["周期ID"] = addPeriodicCallback(50, _____63A8_8FDBQ_7BAD, state)
end
local function _____83B7_53D6Q_4E0A_4E0B_6587(hero)
    return _____662F_9E7F_76EE_5706(hero) and ({["英雄"] = hero}) or nil
end
local function _____91CA_653EQ_6280_80FD(_entry, caster, _____6280_80FD_5B9E_4F8BID)
    if not _____5355_4F4D_5B58_6D3B(caster) or not _____662F_9E7F_76EE_5706(caster) or _____6280_80FD_5B9E_4F8BID == nil then
        return
    end
    local targetX = GetSpellTargetX()
    local targetY = GetSpellTargetY()
    local locked = _____9009_62E9Q_9501_5B9A_76EE_6807(caster, targetX, targetY)
    if #locked <= 0 then
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(_____6280_80FD_5B9E_4F8BID)
        return
    end
    local old = ____Q_4E0A_4E0B_6587_8868[GetHandleId(caster)]
    if old ~= nil then
        _____7ED3_675FQ_6280_80FD(old)
    end
    local ____d_5F3A_5316_5C42_6570 = _____6D88_8017_9E7F_76EE_5706_5706_73AF_5F3A_5316(caster)
    local damageMultiplier = ____d_5F3A_5316_5C42_6570 > 0 and 1 + _____914D_7F6E.D["Q伤害额外比例"] or 1
    local attack = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster)
    local level = GetHeroLevel(caster)
    local context = {
        ["施法者"] = caster,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["暂停来源"] = "鹿目圆-Q-" .. tostring(_____6280_80FD_5B9E_4F8BID),
        ["锁定目标"] = locked,
        ["伤害"] = attack * (_____914D_7F6E.Q["伤害攻击力基础比例"] + level * _____914D_7F6E.Q["每英雄等级额外比例"]) * damageMultiplier,
        ["额外光伤"] = attack * _____914D_7F6E.Q["锁定目标额外光伤比例"] * damageMultiplier,
        ["忽略魔抗"] = _____9E7F_76EE_5706_4F24_5BB3_65E0_89C6_9B54_6297(caster),
        ["已结束"] = false,
        ["命中次数"] = {}
    }
    ____Q_4E0A_4E0B_6587_8868[GetHandleId(caster)] = context
    _____6DFB_52A0_5355_4F4D_6682_505C(caster, context["暂停来源"])
    SetUnitAnimation(caster, "spell")
    addDelayedCallback(_____914D_7F6E.Q["施法硬直秒"] * 1000, _____89E3_9664Q_786C_76F4, context)
    do
        local i = 0
        while i < #locked do
            addDelayedCallback(i * _____914D_7F6E.Q["箭间隔毫秒"], _____53D1_5C04Q_7BAD, {["上下文"] = context, ["索引"] = i})
            i = i + 1
        end
    end
    addDelayedCallback(_____914D_7F6E.Q["收尾毫秒"], ____Q_6536_5C3E, context)
end
local function ____Q_6700_7EC8_4F24_5BB3_6CBB_7597_53CB_519B(target, attacker, applied, snapshot)
    local ____temp_11 = not (applied > 0)
    if not ____temp_11 then
        local ____opt_result_10
        if snapshot ~= nil then
            ____opt_result_10 = snapshot.skillDamageTag
        end
        ____temp_11 = ____opt_result_10 ~= ____Q_4F24_5BB3_6807_7B7E
    end
    if ____temp_11 then
        return
    end
    if not _____662F_9E7F_76EE_5706(attacker) or not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    local friends = getUnitsInRange(
        GetUnitX(target),
        GetUnitY(target),
        _____914D_7F6E.Q["目标半径"]
    )
    local amount = applied * _____914D_7F6E.Q["友军生命魔法恢复比例"]
    do
        local i = 0
        while i < #friends do
            do
                local friend = friends[i + 1]
                if not _____5355_4F4D_5B58_6D3B(friend) or IsUnitAlly(
                    friend,
                    GetOwningPlayer(attacker)
                ) ~= true then
                    goto __continue52
                end
                _____9E7F_76EE_5706_6CBB_7597_53CB_519B(attacker, friend, amount, amount)
            end
            ::__continue52::
            i = i + 1
        end
    end
end
local function _____6CE8_518CQ_5355_4F4D_7C7B_578B_76D1_542C(unitTypeId)
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "鹿目圆-圆环射击",
        ["单位类型ID"] = unitTypeId,
        ["技能ID"] = _____914D_7F6E["技能"].Q["类型ID"],
        ["获取或创建上下文"] = _____83B7_53D6Q_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653EQ_6280_80FD,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 3
    })
end
_____6CE8_518CQ_5355_4F4D_7C7B_578B_76D1_542C(_____914D_7F6E["单位"]["普通类型ID"])
_____6CE8_518CQ_5355_4F4D_7C7B_578B_76D1_542C(_____914D_7F6E["单位"]["圆神类型ID"])
registerAppliedFinalDamageListener(____Q_6700_7EC8_4F24_5BB3_6CBB_7597_53CB_519B)
return ____exports

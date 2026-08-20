local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____79FB_9664Q_5355_4F4D_58F3, _____8BB0_5F55Q_8FDE_7EED_547D_4E2D, _____6E05_7406Q_7206_70B8_5355_4F4D_58F3, ____Q_6BCF_76EE_6807_7ED3_7B97_540E, _____65BD_52A0_7729_6655, _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0, GetHandleId, _____914D_7F6E
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.15．鹿目圆.00．配置")
local _____9E7F_76EE_5706_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["鹿目圆单位技能配置"]
local ____01_FF0E_72B6_6001_4E0E_88AB_52A8 = require("系统.03．技能系统.05．单位技能.04．英雄技能.15．鹿目圆.01．状态与被动")
local _____662F_9E7F_76EE_5706 = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["是鹿目圆"]
local _____9E7F_76EE_5706_4F24_5BB3_65E0_89C6_9B54_6297 = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["鹿目圆伤害无视魔抗"]
local _____9E7F_76EE_5706_6CBB_7597_53CB_519B = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["鹿目圆治疗友军"]
local _____83B7_53D6_9E7F_76EE_5706_5706_73AF_5F3A_5316_5C42_6570 = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["获取鹿目圆圆环强化层数"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____01_FF0ETS_539F_751F_5F39_5E55 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____01_FF0ETS_539F_751F_5F39_5E55["创建原生弹幕"]
local _____521B_5EFA_4E8C_9636_8D1D_585E_5C14_629B_7269_7EBF_8F68_8FF9 = ____01_FF0ETS_539F_751F_5F39_5E55["创建二阶贝塞尔抛物线轨迹"]
function _____79FB_9664Q_5355_4F4D_58F3(unit)
    if unit ~= nil and unit ~= 0 then
        _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(unit)
    end
end
function _____8BB0_5F55Q_8FDE_7EED_547D_4E2D(context, target)
    local targetId = GetHandleId(target)
    local next = (context["命中次数"][targetId] or 0) + 1
    context["命中次数"][targetId] = next
    if next >= _____914D_7F6E.Q["连续命中眩晕次数"] then
        _____65BD_52A0_7729_6655(
            context["施法者"],
            target,
            _____914D_7F6E.Q["连续命中眩晕秒"],
            "鹿目圆-圆环射击",
            "技能"
        )
    end
end
function _____6E05_7406Q_7206_70B8_5355_4F4D_58F3(variable)
    _____79FB_9664Q_5355_4F4D_58F3(variable)
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
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
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
local ____require_result_6 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
_____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0 = ____require_result_6["立即移除单位并取消排泄登记"]
local ____require_result_7 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_7.getUnitsInRange
local getEnemyUnitsInRange = ____require_result_7.getEnemyUnitsInRange
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_8["读取单位攻击力"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_8["两点角度"]
local _____5355_4F4D_5B58_6D3B = ____require_result_8["单位存活"]
GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetOwningPlayer = jass.GetOwningPlayer
local GetHeroLevel = jass.GetHeroLevel
local GetRandomInt = jass.GetRandomInt
local SetUnitAnimation = jass.SetUnitAnimation
local IsUnitType = jass.IsUnitType
local IsUnitAlly = jass.IsUnitAlly
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local DAMAGE_TYPE_DIVINE = jass.DAMAGE_TYPE_DIVINE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
--- 播放地图预载全局音效（源 PlaySoundAtPointBJ gg_snd_*）
local function _____64AD_653EQ_5168_5C40_97F3_6548(soundKey)
    if soundKey == "" then
        return
    end
    local sound = jglobals[soundKey]
    if sound == nil or sound == 0 then
        return
    end
    jass.StartSound(sound)
end
_____914D_7F6E = _____9E7F_76EE_5706_5355_4F4D_6280_80FD_914D_7F6E
local ____Q_4F24_5BB3_6807_7B7E = "鹿目圆-Q-区域"
local ____Q_795E_5723_4F24_5BB3_6807_7B7E = "鹿目圆-Q-锁定神圣"
local ____Q_4E0A_4E0B_6587_8868 = {}
local ____Q_7BAD_5F39_5E55_72B6_6001_8868 = {}
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
    while #result < _____914D_7F6E.Q["箭数量"] and #result > 0 do
        result[#result + 1] = result[GetRandomInt(0, #result - 1) + 1]
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
    if context["已结束"] or not _____5355_4F4D_5B58_6D3B(source) then
        return
    end
    local dLayers = _____83B7_53D6_9E7F_76EE_5706_5706_73AF_5F3A_5316_5C42_6570(source)
    local aoeMultiplier = dLayers >= 2 and _____914D_7F6E.Q["爆炸倍率二次"] or (dLayers >= 1 and _____914D_7F6E.Q["爆炸倍率一次"] or _____914D_7F6E.Q["爆炸倍率基础"])
    local divineRatio = dLayers >= 2 and _____914D_7F6E.Q["锁定神圣伤害二次比例"] or (dLayers >= 1 and _____914D_7F6E.Q["锁定神圣伤害一次比例"] or _____914D_7F6E.Q["锁定神圣伤害基础比例"])
    local owner = GetOwningPlayer(source)
    local _____7206_70B8_58F3 = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        owner,
        _____914D_7F6E["单位壳"]["Q爆炸"],
        targetX,
        targetY,
        0
    )
    addDelayedCallback(_____914D_7F6E.Q["爆炸特效持续秒"] * 1000, _____6E05_7406Q_7206_70B8_5355_4F4D_58F3, _____7206_70B8_58F3)
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
        ["伤害"] = context["爆炸基础伤害"] * aoeMultiplier,
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
            ["伤害"] = context["攻击力"] * divineRatio,
            ["伤害类型"] = DAMAGE_TYPE_DIVINE,
            attack = false,
            ranged = true,
            attackType = ATTACK_TYPE_NORMAL,
            weaponType = WEAPON_TYPE_WHOKNOWS,
            ["来源类型"] = "单位技能",
            ["技能ID"] = _____914D_7F6E["技能"].Q["类型ID"],
            ["技能实例ID"] = context["技能实例ID"],
            ["标签"] = ____Q_795E_5723_4F24_5BB3_6807_7B7E,
            ["参与技能伤害加成"] = true
        })
    end
end
local function ____Q_7BAD_5230_8FBE_76EE_6807_70B9(_____5F39_5E55ID, ______539F_56E0)
    local state = ____Q_7BAD_5F39_5E55_72B6_6001_8868[_____5F39_5E55ID]
    if state == nil then
        return
    end
    __TS__Delete(____Q_7BAD_5F39_5E55_72B6_6001_8868, _____5F39_5E55ID)
    _____7ED3_7B97Q_7BAD(state)
end
local function ____Q_7BAD_7ED3_675F(_____539F_56E0, _____5F39_5E55ID)
    if _____539F_56E0 ~= "完成" and _____539F_56E0 ~= "距离结束" then
        __TS__Delete(____Q_7BAD_5F39_5E55_72B6_6001_8868, _____5F39_5E55ID)
    end
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
    _____64AD_653EQ_5168_5C40_97F3_6548(_____914D_7F6E.Q["施放音效键"])
    local startX = GetUnitX(source)
    local startY = GetUnitY(source)
    local endX = GetUnitX(locked)
    local endY = GetUnitY(locked)
    local angle = _____4E24_70B9_89D2_5EA6(startX, startY, endX, endY)
    local state = {["上下文"] = context, ["锁定目标"] = locked, ["终点X"] = endX, ["终点Y"] = endY}
    local _____5F39_5E55 = _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = source,
        ["弹幕单位类型"] = _____914D_7F6E["单位壳"]["Q起手箭"],
        X = startX,
        Y = startY,
        ["方向角"] = angle,
        ["速度"] = 1,
        ["生命周期"] = _____914D_7F6E.Q["箭命中延迟毫秒"] / 1000,
        ["命中半径"] = 0,
        ["不可阻挡"] = true,
        ["禁用碰撞"] = true,
        ["缩放"] = _____914D_7F6E.Q["箭飞行缩放"],
        ["飞行高度"] = _____914D_7F6E.Q["箭飞行高度"],
        ["轨迹采样器"] = _____521B_5EFA_4E8C_9636_8D1D_585E_5C14_629B_7269_7EBF_8F68_8FF9(
            startX,
            startY,
            _____914D_7F6E.Q["箭飞行高度"],
            (startX + endX) * 0.5,
            (startY + endY) * 0.5,
            endX,
            endY,
            0,
            _____914D_7F6E.Q["箭贝塞尔抬高"]
        ),
        ["on到达目标点"] = ____Q_7BAD_5230_8FBE_76EE_6807_70B9,
        ["on结束"] = ____Q_7BAD_7ED3_675F
    })
    ____Q_7BAD_5F39_5E55_72B6_6001_8868[_____5F39_5E55["弹幕ID"]] = state
end
local function _____83B7_53D6Q_4E0A_4E0B_6587(hero)
    return _____662F_9E7F_76EE_5706(hero) and ({["英雄"] = hero}) or nil
end
local function _____91CA_653EQ_6280_80FD(_entry, caster, _____6280_80FD_5B9E_4F8BID)
    if not _____5355_4F4D_5B58_6D3B(caster) or not _____662F_9E7F_76EE_5706(caster) or _____6280_80FD_5B9E_4F8BID == nil then
        return
    end
    local targetUnit = GetSpellTargetUnit()
    local targetX = targetUnit ~= nil and targetUnit ~= 0 and GetUnitX(targetUnit) or GetSpellTargetX()
    local targetY = targetUnit ~= nil and targetUnit ~= 0 and GetUnitY(targetUnit) or GetSpellTargetY()
    local locked = _____9009_62E9Q_9501_5B9A_76EE_6807(caster, targetX, targetY)
    if #locked <= 0 then
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(_____6280_80FD_5B9E_4F8BID)
        return
    end
    local old = ____Q_4E0A_4E0B_6587_8868[GetHandleId(caster)]
    if old ~= nil then
        _____7ED3_675FQ_6280_80FD(old)
    end
    local attack = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster)
    local level = GetHeroLevel(caster)
    local context = {
        ["施法者"] = caster,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["暂停来源"] = "鹿目圆-Q-" .. tostring(_____6280_80FD_5B9E_4F8BID),
        ["锁定目标"] = locked,
        ["攻击力"] = attack,
        ["爆炸基础伤害"] = attack * (_____914D_7F6E.Q["伤害攻击力基础比例"] + level * _____914D_7F6E.Q["每英雄等级额外比例"]),
        ["忽略魔抗"] = _____9E7F_76EE_5706_4F24_5BB3_65E0_89C6_9B54_6297(caster),
        ["已结束"] = false,
        ["命中次数"] = {}
    }
    ____Q_4E0A_4E0B_6587_8868[GetHandleId(caster)] = context
    _____64AD_653EQ_5168_5C40_97F3_6548(_____914D_7F6E.Q["施放音效键"])
    _____6DFB_52A0_5355_4F4D_6682_505C(caster, context["暂停来源"])
    SetUnitAnimation(caster, "spell")
    addDelayedCallback(_____914D_7F6E.Q["施法硬直秒"] * 1000, _____89E3_9664Q_786C_76F4, context)
    do
        local i = 0
        while i < _____914D_7F6E.Q["箭数量"] do
            addDelayedCallback(i * _____914D_7F6E.Q["箭间隔毫秒"], _____53D1_5C04Q_7BAD, {["上下文"] = context, ["索引"] = i})
            i = i + 1
        end
    end
    addDelayedCallback(_____914D_7F6E.Q["收尾毫秒"], ____Q_6536_5C3E, context)
end
local function ____Q_6700_7EC8_4F24_5BB3_6CBB_7597_53CB_519B(target, attacker, applied, snapshot)
    local ____temp_12 = applied < 1
    if not ____temp_12 then
        local ____opt_result_11
        if snapshot ~= nil then
            ____opt_result_11 = snapshot.skillDamageTag
        end
        ____temp_12 = ____opt_result_11 ~= ____Q_795E_5723_4F24_5BB3_6807_7B7E
    end
    if ____temp_12 then
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
                    goto __continue51
                end
                _____9E7F_76EE_5706_6CBB_7597_53CB_519B(attacker, friend, amount, amount)
            end
            ::__continue51::
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

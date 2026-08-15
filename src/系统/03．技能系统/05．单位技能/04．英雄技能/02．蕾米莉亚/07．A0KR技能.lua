local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.02．蕾米莉亚.00．配置")
local _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["蕾米莉亚单位技能配置"]
local ____03_FF0E_857E_7C73_8389_4E9A = require("系统.05．Buff系统.03．Buff表.02．英雄.03．蕾米莉亚")
local _____857E_7C73_8389_4E9ABuffID = ____03_FF0E_857E_7C73_8389_4E9A["蕾米莉亚BuffID"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_1.registerDeathListener
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local removeDelayedCallback = ____require_result_2.removeDelayedCallback
local addPeriodicCallback = ____require_result_2.addPeriodicCallback
local removePeriodicCallback = ____require_result_2.removePeriodicCallback
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51B2_950B = ____require_result_3["开始冲锋"]
local _____505C_6B62_4F4D_79FB = ____require_result_3["停止位移"]
local ____require_result_4 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_4["获取范围敌军"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____require_result_5["单位存活"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_5["读取单位攻击力"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_5["两点角度"]
local ____require_result_6 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_6["造成批量AOE技能伤害"]
local _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_6["创建独立技能伤害实例"]
local _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_6["结束独立技能伤害实例"]
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedUnitEffect = ____require_result_7.createTimedUnitEffect
local _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_7["创建单位坐标跟随特效"]
local _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_7["销毁单位坐标跟随特效"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_8["调整玩家属性"]
local ____require_result_9 = require("系统.05．Buff系统.00．Buff系统")
local getBuffRuntime = ____require_result_9.getBuffRuntime
local registerManualBuff = ____require_result_9.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_9["移除单位指定Buff"]
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_10.stringToFourCCSafe
local ____A0KR_914D_7F6E = _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E["额外D"]
local ____A0KR_6280_80FDID = stringToFourCCSafe(____A0KR_914D_7F6E["技能ID"])
local _____5355_4F4D_7C7B_578BID = _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"]
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitType = jass.IsUnitType
local _____4E0A_4E0B_6587_8868 = {}
local _____5438_8840_5C42_6570_8868 = {}
local function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    return (unit == nil or unit == 0) and 0 or (GetHandleId(unit) or 0)
end
local function _____83B7_53D6_6216_521B_5EFAA0KR_4E0A_4E0B_6587(unit)
    local unitId = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unitId == 0 then
        return nil
    end
    local old = _____4E0A_4E0B_6587_8868[unitId]
    if old ~= nil then
        return old
    end
    local created = {
        ["施法者"] = unit,
        ["方向角"] = 0,
        ["伤害"] = 0,
        ["周期回调ID"] = 0,
        ["收尾回调ID"] = 0,
        ["位移ID"] = 0,
        ["周期次数"] = 0,
        ["已命中"] = {},
        ["已启动"] = false
    }
    _____4E0A_4E0B_6587_8868[unitId] = created
    return created
end
local function ____A0KR_76EE_6807_5141_8BB8(caster, target, context)
    local targetId = _____53D6_5355_4F4D_53E5_67C4ID(target)
    return targetId ~= 0 and context["已命中"][targetId] ~= true and _____5355_4F4D_5B58_6D3B(target) and not IsUnitType(target, UNIT_TYPE_ANCIENT) and not IsUnitType(target, UNIT_TYPE_MECHANICAL) and not IsUnitType(target, UNIT_TYPE_STRUCTURE) and jass.IsUnitEnemy(
        target,
        GetOwningPlayer(caster)
    ) == true
end
local function ____A0KR_51C6_5907_76EE_6807(target, _index, variable)
    local context = variable
    if context == nil or not ____A0KR_76EE_6807_5141_8BB8(context["施法者"], target, context) then
        return nil
    end
    local targetId = _____53D6_5355_4F4D_53E5_67C4ID(target)
    context["已命中"][targetId] = true
    createTimedUnitEffect(target, ____A0KR_914D_7F6E["命中特效"]["挂点"], ____A0KR_914D_7F6E["命中特效"]["模型路径"], ____A0KR_914D_7F6E["命中特效持续秒"])
    return {
        ["伤害"] = context["伤害"],
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        attack = true,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE
    }
end
local function ____A0KR_5438_8840_5230_671F(variable)
    local record = variable
    if record == nil or record["施法者"] == nil or record["施法者"] == 0 then
        return
    end
    local unitId = _____53D6_5355_4F4D_53E5_67C4ID(record["施法者"])
    local current = _____5438_8840_5C42_6570_8868[unitId] or 0
    if current <= 0 then
        return
    end
    _____8C03_6574_73A9_5BB6_5C5E_6027(record["施法者"], "伤害吸血", -record["数值"])
    local next = current - 1
    _____5438_8840_5C42_6570_8868[unitId] = next
    if next <= 0 then
        __TS__Delete(_____5438_8840_5C42_6570_8868, unitId)
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(record["施法者"], _____857E_7C73_8389_4E9ABuffID["恶魔突袭吸血"])
        return
    end
    local runtime = getBuffRuntime(record["施法者"], _____857E_7C73_8389_4E9ABuffID["恶魔突袭吸血"])
    if runtime ~= nil then
        runtime.stack = next
        runtime.effect = next
    end
end
local function ____A0KR_76EE_6807_7ED3_7B97_540E(target, _index, success, variable)
    local context = variable
    if context == nil or not success then
        return
    end
    local value = IsUnitType(target, UNIT_TYPE_HERO) and ____A0KR_914D_7F6E["英雄吸血"] or ____A0KR_914D_7F6E["普通单位吸血"]
    local unitId = _____53D6_5355_4F4D_53E5_67C4ID(context["施法者"])
    local next = (_____5438_8840_5C42_6570_8868[unitId] or 0) + 1
    _____5438_8840_5C42_6570_8868[unitId] = next
    _____8C03_6574_73A9_5BB6_5C5E_6027(context["施法者"], "伤害吸血", value)
    registerManualBuff(
        context["施法者"],
        _____857E_7C73_8389_4E9ABuffID["恶魔突袭吸血"],
        ____A0KR_914D_7F6E["吸血持续秒"],
        next,
        {sourceName = "蕾米莉亚-恶魔突袭", stack = next}
    )
    addDelayedCallback(____A0KR_914D_7F6E["吸血持续秒"] * 1000, ____A0KR_5438_8840_5230_671F, {["施法者"] = context["施法者"], ["数值"] = value})
end
local function ____A0KR_6536_5C3E(variable)
    local context = variable
    if context == nil then
        return
    end
    context["收尾回调ID"] = 0
    if context["技能实例ID"] ~= nil then
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(context["技能实例ID"])
        context["技能实例ID"] = nil
    end
    do
        local i = 0
        while i < #____A0KR_914D_7F6E["表现"] do
            _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(context["施法者"], ____A0KR_914D_7F6E["表现"][i + 1]["特效键"])
            i = i + 1
        end
    end
    context["已启动"] = false
    local casterId = _____53D6_5355_4F4D_53E5_67C4ID(context["施法者"])
    if casterId ~= 0 and _____4E0A_4E0B_6587_8868[casterId] == context then
        __TS__Delete(_____4E0A_4E0B_6587_8868, casterId)
    end
end
local function _____6E05_7406A0KR_4E0A_4E0B_6587(context)
    if context["位移ID"] ~= 0 then
        _____505C_6B62_4F4D_79FB(context["位移ID"], "中断")
        context["位移ID"] = 0
    end
    if context["周期回调ID"] ~= 0 then
        removePeriodicCallback(context["周期回调ID"])
        context["周期回调ID"] = 0
    end
    if context["收尾回调ID"] ~= 0 then
        removeDelayedCallback(context["收尾回调ID"])
        context["收尾回调ID"] = 0
    end
    if context["技能实例ID"] ~= nil then
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(context["技能实例ID"])
        context["技能实例ID"] = nil
    end
    do
        local i = 0
        while i < #____A0KR_914D_7F6E["表现"] do
            _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(context["施法者"], ____A0KR_914D_7F6E["表现"][i + 1]["特效键"])
            i = i + 1
        end
    end
    context["已启动"] = false
    local casterId = _____53D6_5355_4F4D_53E5_67C4ID(context["施法者"])
    if casterId ~= 0 and _____4E0A_4E0B_6587_8868[casterId] == context then
        __TS__Delete(_____4E0A_4E0B_6587_8868, casterId)
    end
end
local function ____A0KR_5468_671FTick(variable)
    local context = variable
    if context == nil or not context["已启动"] then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        _____6E05_7406A0KR_4E0A_4E0B_6587(context)
        return
    end
    if context["周期次数"] >= ____A0KR_914D_7F6E["持续次数"] then
        if context["周期回调ID"] ~= 0 then
            removePeriodicCallback(context["周期回调ID"])
            context["周期回调ID"] = 0
        end
        context["收尾回调ID"] = addDelayedCallback(150, ____A0KR_6536_5C3E, context)
        return
    end
    context["周期次数"] = context["周期次数"] + 1
    local targets = _____83B7_53D6_8303_56F4_654C_519B(
        context["施法者"],
        GetUnitX(context["施法者"]),
        GetUnitY(context["施法者"]),
        ____A0KR_914D_7F6E["命中范围"]
    )
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = context["施法者"],
        ["目标列表"] = targets,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____A0KR_6280_80FDID,
        ["技能实例ID"] = context["技能实例ID"],
        ["伤害形态"] = "AOE",
        ["每目标处理器"] = ____A0KR_51C6_5907_76EE_6807,
        ["每目标结算后处理器"] = ____A0KR_76EE_6807_7ED3_7B97_540E,
        ["变量"] = context
    })
end
local function _____91CA_653E_857E_7C73_8389_4E9AA0KR(caster)
    local existing = _____4E0A_4E0B_6587_8868[_____53D6_5355_4F4D_53E5_67C4ID(caster)]
    if existing ~= nil and existing["已启动"] then
        _____6E05_7406A0KR_4E0A_4E0B_6587(existing)
    end
    local context = _____83B7_53D6_6216_521B_5EFAA0KR_4E0A_4E0B_6587(caster)
    if context == nil then
        return
    end
    context["方向角"] = _____4E24_70B9_89D2_5EA6(
        GetUnitX(caster),
        GetUnitY(caster),
        GetSpellTargetX(),
        GetSpellTargetY()
    )
    context["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * ____A0KR_914D_7F6E["攻击力倍率"]
    context["技能实例ID"] = _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B({["技能ID"] = ____A0KR_6280_80FDID, ["来源类型"] = "单位技能", ["标签"] = "蕾米莉亚-恶魔突袭", ["持续时间秒"] = 1})
    context["周期次数"] = 0
    context["已命中"] = {}
    context["已启动"] = true
    do
        local i = 0
        while i < #____A0KR_914D_7F6E["表现"] do
            local effect = ____A0KR_914D_7F6E["表现"][i + 1]
            local _____7279_6548_89D2_5EA6 = context["方向角"] + (____A0KR_914D_7F6E["特效朝向偏移"] or 0)
            _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548(
                caster,
                effect["模型路径"],
                effect["特效键"],
                effect["缩放"],
                ____A0KR_914D_7F6E["初始高度"],
                nil,
                nil,
                _____7279_6548_89D2_5EA6
            )
            i = i + 1
        end
    end
    context["周期回调ID"] = addPeriodicCallback(____A0KR_914D_7F6E["周期间隔毫秒"], ____A0KR_5468_671FTick, context)
    local _____6301_7EED_65F6_95F4 = ____A0KR_914D_7F6E["周期间隔毫秒"] * ____A0KR_914D_7F6E["持续次数"] / 1000
    context["位移ID"] = _____5F00_59CB_51B2_950B(
        caster,
        {
            ["角度"] = context["方向角"],
            ["距离"] = ____A0KR_914D_7F6E["速度"] * ____A0KR_914D_7F6E["持续次数"],
            ["每秒速度"] = ____A0KR_914D_7F6E["速度"] / (____A0KR_914D_7F6E["周期间隔毫秒"] / 1000),
            ["持续时间"] = _____6301_7EED_65F6_95F4,
            ["检查地形"] = true,
            ["暂停单位"] = false,
            ["禁用碰撞"] = true,
            ["朝向跟随位移"] = true,
            ["结束回调"] = function(_unit, _reason)
                context["位移ID"] = 0
                if context["周期回调ID"] ~= 0 then
                    removePeriodicCallback(context["周期回调ID"])
                    context["周期回调ID"] = 0
                end
                if context["收尾回调ID"] == 0 then
                    context["收尾回调ID"] = addDelayedCallback(150, ____A0KR_6536_5C3E, context)
                end
            end
        }
    )
    if context["位移ID"] == 0 then
        _____6E05_7406A0KR_4E0A_4E0B_6587(context)
    end
end
local function _____5904_7406_857E_7C73_8389_4E9AA0KR(caster, abilityId)
    if abilityId ~= ____A0KR_6280_80FDID or GetUnitTypeId(caster) ~= _____5355_4F4D_7C7B_578BID or not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    _____91CA_653E_857E_7C73_8389_4E9AA0KR(caster)
end
local function _____857E_7C73_8389_4E9AA0KR_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    local context = _____4E0A_4E0B_6587_8868[_____53D6_5355_4F4D_53E5_67C4ID(dyingUnit)]
    if context ~= nil then
        _____6E05_7406A0KR_4E0A_4E0B_6587(context)
    end
end
registerSpellEffectListener(_____5904_7406_857E_7C73_8389_4E9AA0KR)
registerDeathListener(_____857E_7C73_8389_4E9AA0KR_5355_4F4D_6B7B_4EA1)
return ____exports

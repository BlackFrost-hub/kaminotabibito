local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____963F_74E6_9686_7B49_91CF_6062_590D, doHeal
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.17．Saber.00．配置")
local ____Saber_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["Saber技能配置"]
local ____08_FF0ESaber = require("系统.05．Buff系统.03．Buff表.02．英雄.08．Saber")
local SaberBuffID = ____08_FF0ESaber.SaberBuffID
local ____01_FF0E_72B6_6001_8868 = require("系统.03．技能系统.05．单位技能.04．英雄技能.17．Saber.01．状态表")
local ____Saber_8BBE_7F6E_963F_74E6_9686 = ____01_FF0E_72B6_6001_8868["Saber设置阿瓦隆"]
local ____Saber_662F_5426_963F_74E6_9686 = ____01_FF0E_72B6_6001_8868["Saber是否阿瓦隆"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
function _____963F_74E6_9686_7B49_91CF_6062_590D(variable)
    local ctx = variable
    if ctx == nil then
        return
    end
    local target = ctx.target
    if target == nil or target == 0 or not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    if not ____Saber_662F_5426_963F_74E6_9686(target) then
        return
    end
    doHeal({
        HealSource = target,
        HealTarget = target,
        HealAmount = ctx.damage,
        ItemHeal = false,
        HealEffect = false,
        HealShowText = false
    })
end
local jass = require("jass.common")
local jglobals = require("jass.globals")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local addDelayedCallback = ____require_result_0.addDelayedCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_1.registerDamageModifier
local ____require_result_2 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
doHeal = ____require_result_2.doHeal
local ____require_result_3 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_3.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_3["移除单位指定Buff"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createUnitEffect = ____require_result_4.createUnitEffect
local destroyUnitEffect = ____require_result_4.destroyUnitEffect
local _____521B_5EFA_70B9_7279_6548 = ____require_result_4["创建点特效"]
local ____require_result_5 = require("lib.扩展函数.BJ函数.14．音效函数")
local PlaySoundBJ = ____require_result_5.PlaySoundBJ
local ____require_result_6 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_6.registerDeathListener
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local GetHandleId = jass.GetHandleId
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local DzPlayEffectAnimation = japi.DzPlayEffectAnimation
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_7.stringToFourCCSafe
local stringToFourCC = stringToFourCCSafe
local _____914D_7F6E = ____Saber_6280_80FD_914D_7F6E
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
local ____D_7C7B_578BID = stringToFourCC(_____914D_7F6E.D["技能ID"])
local ____D_5934_9876_7279_6548_952E = "Saber-D-头顶"
local ____D_539F_70B9_7279_6548_952E = "Saber-D-原点"
local ____D_8FD0_884C_65F6_8868 = {}
local function _____7ED3_675F_963F_74E6_9686(caster)
    if caster == nil or caster == 0 then
        return
    end
    local runtime = ____D_8FD0_884C_65F6_8868[GetHandleId(caster)]
    ____Saber_8BBE_7F6E_963F_74E6_9686(caster, false)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(caster, SaberBuffID["阿瓦隆"])
    destroyUnitEffect(caster, ____D_5934_9876_7279_6548_952E)
    destroyUnitEffect(caster, ____D_539F_70B9_7279_6548_952E)
    if runtime == nil then
        return
    end
    if runtime["回蓝回调ID"] ~= 0 then
        removePeriodicCallback(runtime["回蓝回调ID"])
    end
    runtime["回蓝回调ID"] = 0
    runtime["已启动"] = false
    __TS__Delete(
        ____D_8FD0_884C_65F6_8868,
        GetHandleId(caster)
    )
end
local function _____63A8_8FDBD_56DE_84DD_4E0E_7C92_5B50(variable)
    local runtime = variable
    if runtime == nil then
        return
    end
    local caster = runtime.caster
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) or not ____Saber_662F_5426_963F_74E6_9686(caster) or runtime["Tick数"] >= _____914D_7F6E.D["回蓝"]["最大Tick数"] then
        _____7ED3_675F_963F_74E6_9686(caster)
        return
    end
    runtime["Tick数"] = runtime["Tick数"] + 1
    local _____7C92_5B50 = _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____914D_7F6E.D["粒子特效"]["模型路径"],
        X = GetUnitX(caster),
        Y = GetUnitY(caster),
        Z = _____914D_7F6E.D["粒子特效"]["高度"],
        ["缩放"] = _____914D_7F6E.D["粒子特效"]["缩放"],
        ["持续秒"] = _____914D_7F6E.D["粒子特效"]["持续秒"]
    })
    if _____7C92_5B50 ~= nil and _____7C92_5B50 ~= 0 then
        DzPlayEffectAnimation(_____7C92_5B50, _____914D_7F6E.D["粒子特效"]["动画名"], "")
    end
    local _____5DF2_635F_5931_9B54_6CD5 = GetUnitState(caster, UNIT_STATE_MAX_MANA) - GetUnitState(caster, UNIT_STATE_MANA)
    if _____5DF2_635F_5931_9B54_6CD5 > 0 then
        doHeal({
            HealSource = caster,
            HealTarget = caster,
            HealAmount = 0,
            HealManaAmount = _____5DF2_635F_5931_9B54_6CD5 * _____914D_7F6E.D["回蓝"]["已损失魔法比例"],
            ItemHeal = false,
            HealEffect = false,
            ManaEffect = false,
            HealShowText = false,
            ManaShowText = false
        })
    end
end
local function _____963F_74E6_9686_4F24_5BB3_4FEE_6B63(context)
    local target = context.target
    if target == nil or target == 0 then
        return context.currentDamage
    end
    if GetUnitTypeId(target) ~= _____82F1_96C4_5355_4F4D_7C7B_578BID then
        return context.currentDamage
    end
    if not ____Saber_662F_5426_963F_74E6_9686(target) then
        return context.currentDamage
    end
    local damage = context.currentDamage
    if damage <= 0 then
        return damage
    end
    if context.isMagicDamage == true then
        return 0
    end
    addDelayedCallback(0, _____963F_74E6_9686_7B49_91CF_6062_590D, {target = target, damage = damage})
    return damage
end
local ____D_4E0A_4E0B_6587_8868 = {}
local function _____83B7_53D6_6216_521B_5EFAD_4E0A_4E0B_6587(caster)
    local id = GetHandleId(caster)
    local record = ____D_4E0A_4E0B_6587_8868[id]
    if record == nil then
        record = {["施法者"] = caster}
        ____D_4E0A_4E0B_6587_8868[id] = record
    end
    return record
end
local function _____91CA_653ED_6280_80FD(_context, caster, ______6280_80FD_5B9E_4F8BID)
    if not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    if ____Saber_662F_5426_963F_74E6_9686(caster) then
        _____7ED3_675F_963F_74E6_9686(caster)
    end
    local ____d_97F3_6548_53E5_67C4 = jglobals[_____914D_7F6E.D["音效"]["全局音效键"]]
    if ____d_97F3_6548_53E5_67C4 ~= nil then
        PlaySoundBJ(____d_97F3_6548_53E5_67C4)
    end
    createUnitEffect(
        caster,
        _____914D_7F6E.D["头顶特效"]["挂点"],
        _____914D_7F6E.D["头顶特效"]["模型路径"],
        nil,
        ____D_5934_9876_7279_6548_952E
    )
    createUnitEffect(
        caster,
        _____914D_7F6E.D["原点特效"]["挂点"],
        _____914D_7F6E.D["原点特效"]["模型路径"],
        nil,
        ____D_539F_70B9_7279_6548_952E
    )
    local _____7F3A_5931_751F_547D = GetUnitState(caster, UNIT_STATE_MAX_LIFE) - GetUnitState(caster, UNIT_STATE_LIFE)
    if _____7F3A_5931_751F_547D > 0 then
        doHeal({
            HealSource = caster,
            HealTarget = caster,
            HealAmount = _____7F3A_5931_751F_547D,
            ItemHeal = false,
            HealEffect = true,
            HealShowText = true
        })
    end
    ____Saber_8BBE_7F6E_963F_74E6_9686(caster, true)
    registerManualBuff(
        caster,
        SaberBuffID["阿瓦隆"],
        _____914D_7F6E.D["持续秒"],
        0,
        {["来源"] = caster, ["标签"] = "Saber-D-阿瓦隆"}
    )
    local runtime = {caster = caster, ["回蓝回调ID"] = 0, ["Tick数"] = 0, ["已启动"] = true}
    ____D_8FD0_884C_65F6_8868[GetHandleId(caster)] = runtime
    runtime["回蓝回调ID"] = addPeriodicCallback(
        math.floor(_____914D_7F6E.D["回蓝"]["间隔秒"] * 1000 + 0.5),
        _____63A8_8FDBD_56DE_84DD_4E0E_7C92_5B50,
        runtime
    )
end
local ____D_76D1_542C_5DF2_6CE8_518C = false
local function ____D_5355_4F4D_6B7B_4EA1_6E05_7406(dyingUnit, _killingUnit)
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    if GetUnitTypeId(dyingUnit) ~= _____82F1_96C4_5355_4F4D_7C7B_578BID then
        return
    end
    if ____Saber_662F_5426_963F_74E6_9686(dyingUnit) or ____D_8FD0_884C_65F6_8868[GetHandleId(dyingUnit)] ~= nil then
        _____7ED3_675F_963F_74E6_9686(dyingUnit)
    end
end
____exports["注册SaberD"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "Saber-遥远的理想乡（D）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____914D_7F6E.D["技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAD_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653ED_6280_80FD,
        ["创建独立技能实例"] = false
    })
    if not ____D_76D1_542C_5DF2_6CE8_518C then
        ____D_76D1_542C_5DF2_6CE8_518C = true
        registerDamageModifier(_____963F_74E6_9686_4F24_5BB3_4FEE_6B63, 30)
        registerDeathListener(____D_5355_4F4D_6B7B_4EA1_6E05_7406)
    end
end
____exports["注册SaberD"]()
local ____ = ____D_7C7B_578BID
return ____exports

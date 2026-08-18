local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local GetUnitTypeIdLocal, jass
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.13．坂井悠二.00．配置")
local _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["坂井悠二技能配置"]
local ____05_FF0E_5742_4E95_60A0_4E8C = require("系统.05．Buff系统.03．Buff表.02．英雄.05．坂井悠二")
local _____5742_4E95_60A0_4E8CBuffID = ____05_FF0E_5742_4E95_60A0_4E8C["坂井悠二BuffID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位最大生命"]
local _____4E24_70B9_89D2_5EA6 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["两点角度"]
local ____23_FF0E_77AC_79FB_8DEF_5F84_9884_8BA1_7B97 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.23．瞬移路径预计算")
local _____8BA1_7B97_77AC_79FB_8DEF_5F84 = ____23_FF0E_77AC_79FB_8DEF_5F84_9884_8BA1_7B97["计算瞬移路径"]
function GetUnitTypeIdLocal(unit)
    return jass.GetUnitTypeId(unit)
end
jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_0["施加眩晕"]
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_1["移除单位指定Buff"]
local getBuffRuntime = ____require_result_1.getBuffRuntime
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWESetUnitAbilityStateSafe = ____require_result_2.YDWESetUnitAbilityStateSafe
local ____require_result_3 = require("系统.04．伤害系统.01．伤害事件")
local registerDamageCallback = ____require_result_3.registerDamageCallback
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_4["创建点特效"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_5.createTimedEffect
local createTimedUnitEffect = ____require_result_5.createTimedUnitEffect
local ____require_result_6 = require("lib.扩展函数.BJ函数.14．音效函数")
local PlaySoundOnUnitBJ = ____require_result_6.PlaySoundOnUnitBJ
local ____require_result_7 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_7.addDelayedCallback
local removeDelayedCallback = ____require_result_7.removeDelayedCallback
local addPeriodicCallback = ____require_result_7.addPeriodicCallback
local removePeriodicCallback = ____require_result_7.removePeriodicCallback
local ____require_result_8 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_8.registerDeathListener
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetOwningPlayer = jass.GetOwningPlayer
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local SetUnitFacing = jass.SetUnitFacing
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local CreateUnit = jass.CreateUnit
local SetUnitPosition = jass.SetUnitPosition
local ____require_result_9 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_9.stringToFourCCSafe
local stringToFourCC = stringToFourCCSafe
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local IsUnitEnemy = jass.IsUnitEnemy
local _____914D_7F6E = _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E.E
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E["单位类型ID"]
local ____E_6280_80FDID_5B57_7B26_4E32 = _____914D_7F6E["技能ID"]
local ____E_6280_80FD_7C7B_578BID = _____914D_7F6E["技能类型ID"]
local ____E_62B5_6321BuffID = _____5742_4E95_60A0_4E8CBuffID["E抵挡"]
local _____4E0A_4E0B_6587_8868 = {}
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local _____4F24_5BB3_56DE_8C03_5DF2_6CE8_518C = false
local function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____83B7_53D6E_4E0A_4E0B_6587(unit)
    local id = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if id == 0 then
        return nil
    end
    return _____4E0A_4E0B_6587_8868[id]
end
local function _____83B7_53D6_6216_521B_5EFAE_4E0A_4E0B_6587(unit)
    local id = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if id == 0 then
        return nil
    end
    local current = _____4E0A_4E0B_6587_8868[id]
    if current ~= nil then
        return current
    end
    local created = {
        ["施法者"] = unit,
        ["已启动"] = false,
        ["延迟回调ID"] = 0,
        ["锁存目标单位"] = nil,
        ["锁存目标X"] = 0,
        ["锁存目标Y"] = 0
    }
    _____4E0A_4E0B_6587_8868[id] = created
    return created
end
local function _____6E05_7406E_4E0A_4E0B_6587(context)
    if context["延迟回调ID"] ~= 0 then
        removeDelayedCallback(context["延迟回调ID"])
        context["延迟回调ID"] = 0
    end
    context["已启动"] = false
    local id = _____53D6_5355_4F4D_53E5_67C4ID(context["施法者"])
    if id ~= 0 and _____4E0A_4E0B_6587_8868[id] == context then
        __TS__Delete(_____4E0A_4E0B_6587_8868, id)
    end
end
local function _____6267_884CE_654C_4EBA_5206_652F(context, target)
    local caster = context["施法者"]
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    if target == nil or target == 0 or not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    local _____654C_4EBAX = GetUnitX(target)
    local _____654C_4EBAY = GetUnitY(target)
    local _____671D_5411 = _____4E24_70B9_89D2_5EA6(
        _____654C_4EBAX,
        _____654C_4EBAY,
        GetUnitX(caster),
        GetUnitY(caster)
    )
    SetUnitX(caster, _____654C_4EBAX)
    SetUnitY(caster, _____654C_4EBAY)
    SetUnitFacing(caster, _____671D_5411)
    _____65BD_52A0_7729_6655(
        caster,
        target,
        _____914D_7F6E["敌人分支"]["眩晕秒"],
        _____5742_4E95_60A0_4E8CBuffID["E语法眩晕"],
        "技能"
    )
    createTimedUnitEffect(caster, "origin", _____914D_7F6E["敌人分支"]["传送特效"]["模型路径"], _____914D_7F6E["敌人分支"]["传送特效"]["持续秒"])
    createTimedUnitEffect(target, "origin", _____914D_7F6E["敌人分支"]["传送特效"]["模型路径"], _____914D_7F6E["敌人分支"]["传送特效"]["持续秒"])
end
local function _____6267_884CE_81EA_65BD_6CD5_5206_652F(context)
    local caster = context["施法者"]
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    registerManualBuff(
        caster,
        ____E_62B5_6321BuffID,
        _____914D_7F6E["自施法分支"]["持续秒"],
        _____914D_7F6E["自施法分支"]["减伤比例"],
        {["来源"] = caster, ["来源类型"] = "技能", ["标签"] = "坂井悠二-E-语法抵挡"}
    )
end
local function _____6267_884CE_76EE_6807_70B9_5206_652F(context)
    local caster = context["施法者"]
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    local _____76EE_6807X = context["锁存目标X"]
    local _____76EE_6807Y = context["锁存目标Y"]
    local _____8D77_59CBX = GetUnitX(caster)
    local _____8D77_59CBY = GetUnitY(caster)
    local _____65B9_5411 = _____4E24_70B9_89D2_5EA6(_____8D77_59CBX, _____8D77_59CBY, _____76EE_6807X, _____76EE_6807Y)
    createTimedUnitEffect(caster, "origin", _____914D_7F6E["目标点分支"]["传送特效"]["模型路径"], _____914D_7F6E["目标点分支"]["传送特效"]["持续秒"])
    local _____8DEF_5F84 = _____8BA1_7B97_77AC_79FB_8DEF_5F84(
        _____8D77_59CBX,
        _____8D77_59CBY,
        _____65B9_5411,
        _____914D_7F6E["目标点分支"]["探测步长"],
        _____914D_7F6E["目标点分支"]["最大探测步数"]
    )
    SetUnitPosition(caster, _____8DEF_5F84.X, _____8DEF_5F84.Y)
    SetUnitFacing(caster, _____65B9_5411)
    if not _____8DEF_5F84["撞墙"] then
        createTimedUnitEffect(caster, "origin", _____914D_7F6E["目标点分支"]["传送特效"]["模型路径"], _____914D_7F6E["目标点分支"]["传送特效"]["持续秒"])
    end
end
local function _____5EF6_8FDF_542F_52A8E(context)
    local ctx = context
    if ctx == nil then
        return
    end
    ctx["延迟回调ID"] = 0
    local caster = ctx["施法者"]
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        _____6E05_7406E_4E0A_4E0B_6587(ctx)
        return
    end
    local _____76EE_6807_5355_4F4D = ctx["锁存目标单位"]
    if _____76EE_6807_5355_4F4D ~= nil and _____76EE_6807_5355_4F4D ~= 0 and _____76EE_6807_5355_4F4D ~= caster and _____5355_4F4D_5B58_6D3B(_____76EE_6807_5355_4F4D) then
        _____6267_884CE_654C_4EBA_5206_652F(ctx, _____76EE_6807_5355_4F4D)
        _____6E05_7406E_4E0A_4E0B_6587(ctx)
        return
    end
    if _____76EE_6807_5355_4F4D == caster then
        _____6267_884CE_81EA_65BD_6CD5_5206_652F(ctx)
        _____6E05_7406E_4E0A_4E0B_6587(ctx)
        return
    end
    _____6267_884CE_76EE_6807_70B9_5206_652F(ctx)
    _____6E05_7406E_4E0A_4E0B_6587(ctx)
end
local function _____91CA_653EE_6280_80FD(context, caster, _____6280_80FD_5B9E_4F8BID)
    if context["已启动"] then
        return
    end
    context["已启动"] = true
    context["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
    context["锁存目标单位"] = GetSpellTargetUnit()
    context["锁存目标X"] = GetSpellTargetX()
    context["锁存目标Y"] = GetSpellTargetY()
    if getBuffRuntime(caster, _____5742_4E95_60A0_4E8CBuffID["D期间状态"]) ~= nil then
        YDWESetUnitAbilityStateSafe(caster, ____E_6280_80FD_7C7B_578BID, 1, _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E.D["期间"]["E技能冷却秒"])
    end
    context["延迟回调ID"] = addDelayedCallback(_____914D_7F6E["启动延迟秒"] * 1000, _____5EF6_8FDF_542F_52A8E, context)
end
local function ____E_53EF_91CA_653E(context)
    return not context["已启动"] and context["延迟回调ID"] == 0
end
local function _____5904_7406E_62B5_6321_53D7_5230_4F24_5BB3(target, damage, _damageType, _fromDotTickBatch, _source, _isNormalAttack)
    if target == nil or target == 0 then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    if GetUnitTypeIdLocal(target) ~= _____82F1_96C4_5355_4F4D_7C7B_578BID then
        return
    end
    local runtime = getBuffRuntime(target, ____E_62B5_6321BuffID)
    if runtime == nil then
        return
    end
    local _____5F53_524D_751F_547D = GetUnitState(target, UNIT_STATE_LIFE)
    local _____6700_5927_751F_547D = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(target)
    local _____9608_503C = _____6700_5927_751F_547D * _____914D_7F6E["自施法分支"]["单次伤害阈值最大生命比例"]
    if damage >= _____9608_503C or damage >= _____5F53_524D_751F_547D then
        createTimedUnitEffect(target, "origin", _____914D_7F6E["自施法分支"]["破除特效"]["模型路径"], _____914D_7F6E["自施法分支"]["破除特效"]["持续秒"])
        local ____e_97F3_6548_53E5_67C4 = jglobals[_____914D_7F6E["自施法分支"]["音效"]["全局音效键"]]
        if ____e_97F3_6548_53E5_67C4 ~= nil then
            PlaySoundOnUnitBJ(____e_97F3_6548_53E5_67C4, 100, target)
        end
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(target, ____E_62B5_6321BuffID)
    end
end
local function ____E_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    local context = _____83B7_53D6E_4E0A_4E0B_6587(dyingUnit)
    if context ~= nil then
        _____6E05_7406E_4E0A_4E0B_6587(context)
    end
    if GetUnitTypeIdLocal(dyingUnit) == _____82F1_96C4_5355_4F4D_7C7B_578BID then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(dyingUnit, ____E_62B5_6321BuffID)
    end
end
local function _____786E_4FDDE_4F24_5BB3_76D1_542C()
    if _____4F24_5BB3_56DE_8C03_5DF2_6CE8_518C then
        return
    end
    _____4F24_5BB3_56DE_8C03_5DF2_6CE8_518C = true
    registerDamageCallback(_____5904_7406E_62B5_6321_53D7_5230_4F24_5BB3)
end
____exports["注册坂井悠二E"] = function()
    _____786E_4FDDE_4F24_5BB3_76D1_542C()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "坂井悠二-Grammatica「语法」（E）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = ____E_6280_80FDID_5B57_7B26_4E32,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAE_4E0A_4E0B_6587,
        ["可释放"] = ____E_53EF_91CA_653E,
        ["释放技能"] = _____91CA_653EE_6280_80FD,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 3
    })
    if not _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
        registerDeathListener(____E_5355_4F4D_6B7B_4EA1)
    end
end
____exports["注册坂井悠二E"]()
____exports["坂井悠二E技能状态"] = {["已完成设计"] = true, ["已完成实现"] = true, ["伤害形态"] = "无直接伤害（控制/位移/抵挡）", ["分支"] = "敌方目标瞬移+0.5秒眩晕 / 自施法抵挡1.5秒+75%减伤 / 目标点预计算路径一次性瞬移（撞墙停在地形前）"}
return ____exports

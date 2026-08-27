local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.10．欧尔贝克.00．配置")
local _____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["欧尔贝克单位技能配置"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.10．欧尔贝克.00A．表现工具")
local _____64AD_653E_6B27_5C14_8D1D_514B_5355_4F4D_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放欧尔贝克单位音效"]
local _____64AD_653E_6B27_5C14_8D1D_514B_914D_7F6E_52A8_4F5C = ____00A_FF0E_8868_73B0_5DE5_5177["播放欧尔贝克配置动作"]
local ____17_FF0E_6B27_5C14_8D1D_514B = require("系统.05．Buff系统.03．Buff表.02．英雄.17．欧尔贝克")
local _____6B27_5C14_8D1D_514BBuffID = ____17_FF0E_6B27_5C14_8D1D_514B["欧尔贝克BuffID"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_1.registerSpellEffectListener
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local removeDelayedCallback = ____require_result_2.removeDelayedCallback
local ____require_result_3 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_3.registerDamageModifier
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____8C03_6574_5355_4F4D_5C5E_6027 = ____require_result_4["调整单位属性"]
local ____require_result_5 = require("系统.01．单位系统.06．仇恨系统.06．对外接口")
local _____589E_52A0_751F_547D_6BD4_4F8B_4EC7_6068 = ____require_result_5["增加生命比例仇恨"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.index")
local _____65BD_52A0_5632_8BBD = ____require_result_6["施加嘲讽"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____require_result_7["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_7["两点角度"]
local _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D = ____require_result_7["读取单位最大生命"]
local _____6781_5750_6807X = ____require_result_7["极坐标X"]
local _____6781_5750_6807Y = ____require_result_7["极坐标Y"]
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_8["创建点特效"]
local ____require_result_9 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isUnitAlly = ____require_result_9.isUnitAlly
local isUnitEnemy = ____require_result_9.isUnitEnemy
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____5355_4F4D_662F_6307_5B9A_7C7B_578B = ____require_result_10["单位是指定类型"]
local ____require_result_11 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_11.YDUserDataSetSafe
local ____require_result_12 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_12.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_12["移除单位指定Buff"]
local ____D_6280_80FDID = stringToFourCCSafe(_____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E["D技能ID"])
local _____9632_5FA1_6280_80FD_7C7B_578BID = stringToFourCCSafe(_____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E.D["防御技能ID"])
local _____6B27_5C14_8D1D_514B_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local SetUnitPosition = jass.SetUnitPosition
local UnitAddAbility = jass.UnitAddAbility
local UnitRemoveAbility = jass.UnitRemoveAbility
local _____514D_75AB_4F24_5BB3_5C5E_6027_540D = "免疫伤害"
local _____9632_5FA1_8BB0_5F55_7F13_5B58 = {}
local _____63A9_62A4_8BB0_5F55_7F13_5B58 = {}
local function _____7ED3_675F_9632_5FA1(id, record)
    if _____9632_5FA1_8BB0_5F55_7F13_5B58[id] ~= record then
        return
    end
    local cfg = _____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E.D
    if _____5355_4F4D_5B58_6D3B(record["单位"]) then
        UnitRemoveAbility(record["单位"], _____9632_5FA1_6280_80FD_7C7B_578BID)
    end
    _____8C03_6574_5355_4F4D_5C5E_6027(record["单位"], "伤害减少%", -cfg["防御减免"])
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(record["单位"], _____6B27_5C14_8D1D_514BBuffID["防御"])
    __TS__Delete(_____9632_5FA1_8BB0_5F55_7F13_5B58, id)
end
local function _____65BD_52A0_9632_5FA1(caster)
    local cfg = _____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E.D
    local id = GetHandleId(caster)
    local old = _____9632_5FA1_8BB0_5F55_7F13_5B58[id]
    if old ~= nil and old["单位"] == caster then
        removeDelayedCallback(old["到期回调ID"])
        old["到期回调ID"] = addDelayedCallback(
            cfg["防御持续秒"] * 1000,
            function() return _____7ED3_675F_9632_5FA1(id, old) end
        )
        registerManualBuff(
            caster,
            _____6B27_5C14_8D1D_514BBuffID["防御"],
            cfg["防御持续秒"],
            cfg["防御减免"],
            {sourceUnit = caster}
        )
        return
    end
    UnitAddAbility(caster, _____9632_5FA1_6280_80FD_7C7B_578BID)
    _____8C03_6574_5355_4F4D_5C5E_6027(caster, "伤害减少%", cfg["防御减免"])
    local record = {["单位"] = caster, ["到期回调ID"] = 0}
    _____9632_5FA1_8BB0_5F55_7F13_5B58[id] = record
    registerManualBuff(
        caster,
        _____6B27_5C14_8D1D_514BBuffID["防御"],
        cfg["防御持续秒"],
        cfg["防御减免"],
        {sourceUnit = caster}
    )
    record["到期回调ID"] = addDelayedCallback(
        cfg["防御持续秒"] * 1000,
        function() return _____7ED3_675F_9632_5FA1(id, record) end
    )
end
local function _____7ED3_675F_63A9_62A4(id, record)
    if _____63A9_62A4_8BB0_5F55_7F13_5B58[id] ~= record then
        return
    end
    if record["到期回调ID"] ~= 0 then
        removeDelayedCallback(record["到期回调ID"])
    end
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(record["目标"], _____6B27_5C14_8D1D_514BBuffID["掩护"])
    __TS__Delete(_____63A9_62A4_8BB0_5F55_7F13_5B58, id)
end
local function _____65BD_52A0_63A9_62A4(caster, target)
    local cfg = _____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E.D
    local id = GetHandleId(target)
    local old = _____63A9_62A4_8BB0_5F55_7F13_5B58[id]
    if old ~= nil and old["目标"] == target then
        removeDelayedCallback(old["到期回调ID"])
        old["施法者"] = caster
        old["到期回调ID"] = addDelayedCallback(
            cfg["掩护持续秒"] * 1000,
            function() return _____7ED3_675F_63A9_62A4(id, old) end
        )
        registerManualBuff(
            target,
            _____6B27_5C14_8D1D_514BBuffID["掩护"],
            cfg["掩护持续秒"],
            0,
            {sourceUnit = caster}
        )
        return
    end
    local record = {["目标"] = target, ["施法者"] = caster, ["到期回调ID"] = 0}
    _____63A9_62A4_8BB0_5F55_7F13_5B58[id] = record
    registerManualBuff(
        target,
        _____6B27_5C14_8D1D_514BBuffID["掩护"],
        cfg["掩护持续秒"],
        0,
        {sourceUnit = caster}
    )
    record["到期回调ID"] = addDelayedCallback(
        cfg["掩护持续秒"] * 1000,
        function() return _____7ED3_675F_63A9_62A4(id, record) end
    )
end
--- 掩护触发：目标受到单次伤害超过最大生命 10% 时取消伤害并移动施法者
local function _____5904_7406_63A9_62A4_4F24_5BB3(context)
    local target = context.target
    if target == nil or target == 0 then
        return context.currentDamage
    end
    local id = GetHandleId(target)
    local record = _____63A9_62A4_8BB0_5F55_7F13_5B58[id]
    if record == nil or record["目标"] ~= target then
        return context.currentDamage
    end
    local cfg = _____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E.D
    local maxLife = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(target)
    if not (context.currentDamage >= maxLife * cfg["掩护阈值生命比例"]) then
        return context.currentDamage
    end
    _____7ED3_675F_63A9_62A4(id, record)
    local _____65BD_6CD5_8005 = record["施法者"]
    if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        return context.currentDamage
    end
    local attacker = context.attacker
    local _____65B9_5411_89D2 = attacker ~= nil and attacker ~= 0 and _____4E24_70B9_89D2_5EA6(
        GetUnitX(target),
        GetUnitY(target),
        GetUnitX(attacker),
        GetUnitY(attacker)
    ) or jass:GetUnitFacing(_____65BD_6CD5_8005)
    SetUnitPosition(
        _____65BD_6CD5_8005,
        _____6781_5750_6807X(
            GetUnitX(target),
            _____65B9_5411_89D2,
            cfg["掩护位移距离"]
        ),
        _____6781_5750_6807Y(
            GetUnitY(target),
            _____65B9_5411_89D2,
            cfg["掩护位移距离"]
        )
    )
    YDUserDataSetSafe(
        "unit",
        _____65BD_6CD5_8005,
        _____514D_75AB_4F24_5BB3_5C5E_6027_540D,
        "boolean",
        true
    )
    addDelayedCallback(
        cfg["掩护后免伤持续秒"] * 1000,
        function()
            YDUserDataSetSafe(
                "unit",
                _____65BD_6CD5_8005,
                _____514D_75AB_4F24_5BB3_5C5E_6027_540D,
                "boolean",
                false
            )
        end
    )
    _____64AD_653E_6B27_5C14_8D1D_514B_5355_4F4D_97F3_6548(_____65BD_6CD5_8005, cfg["掩护音效键"])
    _____64AD_653E_6B27_5C14_8D1D_514B_914D_7F6E_52A8_4F5C(_____65BD_6CD5_8005, 3, 3)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["掩护特效模型"],
        X = GetUnitX(target),
        Y = GetUnitY(target),
        Z = 25,
        ["缩放"] = 1,
        ["持续秒"] = cfg["掩护特效持续秒"]
    })
    return 0
end
local function _____65BD_52A0_6311_8845(caster, target)
    local cfg = _____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E.D
    _____65BD_52A0_5632_8BBD(caster, target, {["持续时间"] = cfg["挑衅持续秒"]})
    _____589E_52A0_751F_547D_6BD4_4F8B_4EC7_6068(target, caster, cfg["挑衅仇恨生命比例"])
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["挑衅特效模型"],
        X = GetUnitX(caster),
        Y = GetUnitY(caster),
        Z = 0,
        ["持续秒"] = cfg["挑衅特效持续秒"]
    })
end
local function ____on_6B27_5C14_8D1D_514BD(caster, abilityId)
    if abilityId ~= ____D_6280_80FDID then
        return
    end
    if not _____5355_4F4D_662F_6307_5B9A_7C7B_578B(caster, _____6B27_5C14_8D1D_514B_5355_4F4D_7C7B_578BID) then
        return
    end
    local target = GetSpellTargetUnit()
    if target == nil or target == 0 then
        return
    end
    if target == caster then
        _____64AD_653E_6B27_5C14_8D1D_514B_5355_4F4D_97F3_6548(caster, _____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E.D["防御音效键"])
        _____65BD_52A0_9632_5FA1(caster)
        return
    end
    if isUnitAlly(target, caster) then
        _____65BD_52A0_63A9_62A4(caster, target)
        return
    end
    if isUnitEnemy(target, caster) then
        _____64AD_653E_6B27_5C14_8D1D_514B_5355_4F4D_97F3_6548(caster, _____6B27_5C14_8D1D_514B_5355_4F4D_6280_80FD_914D_7F6E.D["全局音效键"])
        _____65BD_52A0_6311_8845(caster, target)
    end
end
registerSpellEffectListener(____on_6B27_5C14_8D1D_514BD)
registerDamageModifier(_____5904_7406_63A9_62A4_4F24_5BB3, -1000)
return ____exports

local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local createTimedUnitEffect
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.13．坂井悠二.00．配置")
local _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["坂井悠二技能配置"]
local ____05_FF0E_5742_4E95_60A0_4E8C = require("系统.05．Buff系统.03．Buff表.02．英雄.05．坂井悠二")
local _____5742_4E95_60A0_4E8CBuffID = ____05_FF0E_5742_4E95_60A0_4E8C["坂井悠二BuffID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local _____53D6_5355_4F4DID = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["取单位ID"]
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_0["施加眩晕"]
local ____require_result_1 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_1["造成单体技能伤害"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_2["创建点特效"]
local _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_2["创建单位坐标跟随特效"]
local _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_2["销毁单位坐标跟随特效"]
local _____8BBE_7F6E_7279_6548_989C_8272 = ____require_result_2["设置特效颜色"]
local ____require_result_3 = require("lib.扩展函数.BJ函数.14．音效函数")
local PlaySoundOnUnitBJ = ____require_result_3.PlaySoundOnUnitBJ
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_4.addDelayedCallback
local removeDelayedCallback = ____require_result_4.removeDelayedCallback
local ____require_result_5 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_5.registerDeathListener
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetOwningPlayer = jass.GetOwningPlayer
local ____jass_GetUnitModelScale_6 = jass.GetUnitModelScale
if ____jass_GetUnitModelScale_6 == nil then
    ____jass_GetUnitModelScale_6 = function(_u) return 1 end
end
local GetUnitModelScale = ____jass_GetUnitModelScale_6
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_7.stringToFourCCSafe
local stringToFourCC = stringToFourCCSafe
local _____914D_7F6E = _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E.W
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____5742_4E95_60A0_4E8C_6280_80FD_914D_7F6E["单位类型ID"]
local ____W_6280_80FDID_5B57_7B26_4E32 = _____914D_7F6E["技能ID"]
local _____4E0A_4E0B_6587_8868 = {}
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____83B7_53D6W_4E0A_4E0B_6587(unit)
    local id = _____53D6_5355_4F4DID(unit)
    if id == 0 then
        return nil
    end
    return _____4E0A_4E0B_6587_8868[id]
end
local function _____83B7_53D6_6216_521B_5EFAW_4E0A_4E0B_6587(unit)
    local id = _____53D6_5355_4F4DID(unit)
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
        ["阶段回调ID"] = 0,
        ["伤害攻击力快照"] = 0,
        ["目标"] = nil,
        ["当前阶段"] = 0
    }
    _____4E0A_4E0B_6587_8868[id] = created
    return created
end
local function _____6E05_7406W_4E0A_4E0B_6587(context)
    if context["阶段回调ID"] ~= 0 then
        removeDelayedCallback(context["阶段回调ID"])
        context["阶段回调ID"] = 0
    end
    context["已启动"] = false
    local id = _____53D6_5355_4F4DID(context["施法者"])
    if id ~= 0 and _____4E0A_4E0B_6587_8868[id] == context then
        __TS__Delete(_____4E0A_4E0B_6587_8868, id)
    end
end
local function _____63A8_8FDBW_4E09_6BB5_7279_6548(context)
    local ctx = context
    if ctx == nil then
        return
    end
    local caster = ctx["施法者"]
    local target = ctx["目标"]
    if caster == nil or caster == 0 or not _____5355_4F4D_5B58_6D3B(caster) then
        _____6E05_7406W_4E0A_4E0B_6587(ctx)
        return
    end
    if target == nil or target == 0 or not _____5355_4F4D_5B58_6D3B(target) then
        _____6E05_7406W_4E0A_4E0B_6587(ctx)
        return
    end
    local stageIndex = ctx["当前阶段"]
    if stageIndex >= #_____914D_7F6E["三段特效"] then
        _____6E05_7406W_4E0A_4E0B_6587(ctx)
        return
    end
    local _____7279_6548_914D_7F6E = _____914D_7F6E["三段特效"][stageIndex + 1]
    createTimedUnitEffect(target, "origin", _____7279_6548_914D_7F6E["模型路径"], _____7279_6548_914D_7F6E["持续秒"])
    ctx["当前阶段"] = stageIndex + 1
    if ctx["当前阶段"] < #_____914D_7F6E["三段特效"] then
        ctx["阶段回调ID"] = addDelayedCallback(_____7279_6548_914D_7F6E["持续秒"] * 1000, _____63A8_8FDBW_4E09_6BB5_7279_6548, ctx)
    else
        _____6E05_7406W_4E0A_4E0B_6587(ctx)
    end
end
local function _____91CA_653EW_6280_80FD(context, caster, _____6280_80FD_5B9E_4F8BID)
    if context["已启动"] then
        return
    end
    local target = GetSpellTargetUnit()
    if target == nil or target == 0 then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    context["已启动"] = true
    context["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
    context["伤害攻击力快照"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster)
    context["目标"] = target
    context["当前阶段"] = 0
    _____65BD_52A0_7729_6655(
        caster,
        target,
        _____914D_7F6E["眩晕秒"],
        _____5742_4E95_60A0_4E8CBuffID["W眩晕"],
        "技能"
    )
    local _____4F24_5BB3 = context["伤害攻击力快照"] * _____914D_7F6E["伤害攻击力倍率"]
    if _____4F24_5BB3 > 0 and _____5355_4F4D_5B58_6D3B(target) then
        _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
            ["来源"] = caster,
            ["目标"] = target,
            ["伤害"] = _____4F24_5BB3,
            ["伤害类型"] = jass.DAMAGE_TYPE_MAGIC,
            attackType = jass.ATTACK_TYPE_NORMAL,
            weaponType = jass.WEAPON_TYPE_WHOKNOWS,
            ["来源类型"] = "单位技能",
            ["标签"] = "坂井悠二-W-银之监牢",
            ["技能ID"] = stringToFourCC(____W_6280_80FDID_5B57_7B26_4E32),
            ["技能实例ID"] = context["技能实例ID"]
        })
    end
    local ____w_97F3_6548_53E5_67C4 = jglobals[_____914D_7F6E["音效"]["全局音效键"]]
    if ____w_97F3_6548_53E5_67C4 ~= nil then
        PlaySoundOnUnitBJ(____w_97F3_6548_53E5_67C4, 100, target)
    end
    if _____914D_7F6E["壳优化为控制特效"]["启用"] then
        local _____7F29_653E_500D_7387 = _____914D_7F6E["壳优化为控制特效"]["缩放倍率"]
        local _____5F53_524D_7F29_653E = GetUnitModelScale(target)
        local ____ = _____5F53_524D_7F29_653E
        local ____ = _____7F29_653E_500D_7387
    end
    context["阶段回调ID"] = addDelayedCallback(0, _____63A8_8FDBW_4E09_6BB5_7279_6548, context)
end
local function ____W_53EF_91CA_653E(context)
    return not context["已启动"] and context["阶段回调ID"] == 0
end
local function ____W_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    local context = _____83B7_53D6W_4E0A_4E0B_6587(dyingUnit)
    if context ~= nil then
        _____6E05_7406W_4E0A_4E0B_6587(context)
    end
end
____exports["注册坂井悠二W"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "坂井悠二-银之监牢（W）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = ____W_6280_80FDID_5B57_7B26_4E32,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAW_4E0A_4E0B_6587,
        ["可释放"] = ____W_53EF_91CA_653E,
        ["释放技能"] = _____91CA_653EW_6280_80FD,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 4
    })
    if not _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
        registerDeathListener(____W_5355_4F4D_6B7B_4EA1)
    end
end
____exports["注册坂井悠二W"]()
____exports["坂井悠二W技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["伤害形态"] = "单体暗属性技能伤害",
    ["伤害"] = "立即 350% 攻击力 + 2秒眩晕",
    ["表现"] = "三段直接特效各 1秒 + 3D 音效"
}
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
createTimedUnitEffect = ____require_result_8.createTimedUnitEffect
return ____exports

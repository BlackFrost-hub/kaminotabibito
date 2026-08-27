local ____lualib = require("lualib_bundle")
local __TS__ArraySetLength = ____lualib.__TS__ArraySetLength
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____53D6_975E_8D1F_6570, _____9500_6BC1_6697_6C72_53D6_5F39_9053_7279_6548, _____56DE_6EDA_6697_6C72_53D6_6700_5927_751F_547D, _____7ED3_675F_6697_6C72_53D6_5F39_9053, _____6E05_7406_6697_6C72_53D6_5F39_9053_5217_8868, _____68C0_67E5_6697_6C72_53D6_6700_5927_751F_547D, removePeriodicCallback, UNIT_STATE_MAX_LIFE, GetUnitState, SetUnitState, DestroyEffect
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.03．阿伦劳特.00．配置")
local _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["阿伦劳特单位技能配置"]
local ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406 = require("系统.03．技能系统.05．单位技能.04．英雄技能.03．阿伦劳特.00B．形态与状态管理")
local _____662F_963F_4F26_52B3_7279_82F1_96C4 = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["是阿伦劳特英雄"]
local _____662F_5149_5F62_6001 = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["是光形态"]
local _____662F_6697_5F62_6001 = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["是暗形态"]
local _____662F_6709_6548_76EE_6807 = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["是有效目标"]
local _____62E5_6709_88C1_51B3_5BA1_5224 = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["拥有裁决审判"]
local _____62E5_6709_5929_5802_547C_5524 = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["拥有天堂呼唤"]
local _____6DFB_52A0_539F_751FBuff_6301_7EED = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["添加原生Buff持续"]
local _____79FB_9664_539F_751FBuff = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["移除原生Buff"]
local _____4E24_70B9_89D2_5EA6 = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["两点角度"]
local _____4E24_70B9_8DDD_79BB = ____00B_FF0E_5F62_6001_4E0E_72B6_6001_7BA1_7406["两点距离"]
local ____13_FF0E_963F_4F26_52B3_7279 = require("系统.05．Buff系统.03．Buff表.02．英雄.13．阿伦劳特")
local _____963F_4F26_52B3_7279BuffID = ____13_FF0E_963F_4F26_52B3_7279["阿伦劳特BuffID"]
function _____53D6_975E_8D1F_6570(value)
    return value > 0 and value or 0
end
function _____9500_6BC1_6697_6C72_53D6_5F39_9053_7279_6548(ctx)
    if ctx["弹道1"] ~= nil and ctx["弹道1"] ~= 0 then
        DestroyEffect(ctx["弹道1"])
    end
    if ctx["弹道2"] ~= nil and ctx["弹道2"] ~= 0 then
        DestroyEffect(ctx["弹道2"])
    end
    ctx["弹道1"] = nil
    ctx["弹道2"] = nil
end
function _____56DE_6EDA_6697_6C72_53D6_6700_5927_751F_547D(ctx)
    if not ctx["最大生命已增加"] or ctx["最大生命已回滚"] then
        return
    end
    if ctx["施法者"] ~= nil and ctx["施法者"] ~= 0 then
        local _____5F53_524D_6700_5927_751F_547D = GetUnitState(ctx["施法者"], UNIT_STATE_MAX_LIFE)
        SetUnitState(
            ctx["施法者"],
            UNIT_STATE_MAX_LIFE,
            _____53D6_975E_8D1F_6570(_____5F53_524D_6700_5927_751F_547D - ctx["汲取值"])
        )
    end
    ctx["最大生命已回滚"] = true
end
function _____7ED3_675F_6697_6C72_53D6_5F39_9053(ctx, _____7ACB_5373_56DE_6EDA)
    if ctx["已结束"] then
        if _____7ACB_5373_56DE_6EDA then
            _____56DE_6EDA_6697_6C72_53D6_6700_5927_751F_547D(ctx)
        end
        return
    end
    if ctx["回调ID"] ~= 0 then
        removePeriodicCallback(ctx["回调ID"])
    end
    ctx["回调ID"] = 0
    if ctx["回滚回调ID"] ~= 0 then
        removePeriodicCallback(ctx["回滚回调ID"])
    end
    ctx["回滚回调ID"] = 0
    _____9500_6BC1_6697_6C72_53D6_5F39_9053_7279_6548(ctx)
    if _____7ACB_5373_56DE_6EDA then
        _____56DE_6EDA_6697_6C72_53D6_6700_5927_751F_547D(ctx)
    end
    ctx["已结束"] = true
end
function _____6E05_7406_6697_6C72_53D6_5F39_9053_5217_8868(rctx)
    do
        local i = 0
        while i < #rctx["暗汲取弹道列表"] do
            _____7ED3_675F_6697_6C72_53D6_5F39_9053(rctx["暗汲取弹道列表"][i + 1], true)
            i = i + 1
        end
    end
    __TS__ArraySetLength(rctx["暗汲取弹道列表"], 0)
end
function _____68C0_67E5_6697_6C72_53D6_6700_5927_751F_547D(variable)
    local ctx = variable
    if ctx == nil or ctx["已结束"] or not ctx["最大生命已增加"] then
        return
    end
    if not _____62E5_6709_88C1_51B3_5BA1_5224(ctx["施法者"]) then
        _____7ED3_675F_6697_6C72_53D6_5F39_9053(ctx, true)
    end
end
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_0["移除单位指定Buff"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_2.registerSpellEffectListener
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_3.registerDeathListener
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_4.addDelayedCallback
local removeDelayedCallback = ____require_result_4.removeDelayedCallback
local addPeriodicCallback = ____require_result_4.addPeriodicCallback
removePeriodicCallback = ____require_result_4.removePeriodicCallback
local ____require_result_5 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_5["造成技能伤害"]
local ____require_result_6 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_6.doHeal
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_51CF_901F = ____require_result_7["施加减速"]
local _____65BD_52A0_7729_6655 = ____require_result_7["施加眩晕"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____4E34_65F6_8C03_6574_653B_51FB = ____require_result_8["临时调整攻击"]
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_8["调整玩家属性"]
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统")
local _____5F00_59CB_51FB_9000 = ____require_result_9["开始击退"]
local ____require_result_10 = require("系统.05．Buff系统.05．Buff清除函数")
local _____79FB_9664_5355_4F4D_8D1F_9762Buff = ____require_result_10["移除单位负面Buff"]
local ____require_result_11 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_11.getUnitsInRange
local ____require_result_12 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_12["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_12["单位存活"]
local ____require_result_13 = require("lib.扩展函数.BJ函数.08．单位BJ扩展")
local ResetUnitAnimation = ____require_result_13.ResetUnitAnimation
local ____require_result_14 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_14["创建点特效"]
local createTimedUnitEffect = ____require_result_14.createTimedUnitEffect
local ____R_6280_80FDID = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["R技能ID"])
local ____R_4E8C_6BB5_6280_80FDID = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["R二段技能ID"])
local _____5929_5802_547C_5524_5F3A_5316BuffID = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["天堂呼唤强化BuffID"])
local _____88C1_51B3_5BA1_5224_5F3A_5316BuffID = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["裁决审判强化BuffID"])
local _____88C1_51B3_5BA1_5224_5F3A_5316_6280_80FDID = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["裁决审判强化技能ID"])
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local ATTACK_TYPE_CHAOS = jass.ATTACK_TYPE_CHAOS
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFlyHeight = jass.GetUnitFlyHeight
GetUnitState = jass.GetUnitState
SetUnitState = jass.SetUnitState
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UnitAddAbility = jass.UnitAddAbility
local UnitRemoveAbility = jass.UnitRemoveAbility
local SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable
DestroyEffect = jass.DestroyEffect
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local IsUnitEnemy = jass.IsUnitEnemy
local PauseUnit = jass.PauseUnit
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local EXSetEffectXY = japi.EXSetEffectXY
local EXSetEffectX = japi.EXSetEffectX
local EXSetEffectY = japi.EXSetEffectY
local EXSetEffectZ = japi.EXSetEffectZ
local Cos = jass.Cos
local Sin = jass.Sin
local R2I = jass.R2I
local _____89D2_5EA6_8F6C_5F27_5EA6 = 0.017453292519943295
local function _____53D6_56DB_820D_4E94_5165_6574_6570(value)
    return R2I(value + 0.5)
end
local ____R_6280_80FD_4E0A_4E0B_6587_8868 = {}
local function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____83B7_53D6R_6280_80FD_4E0A_4E0B_6587(unit)
    local unitId = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    local ____temp_15
    if unitId == 0 then
        ____temp_15 = nil
    else
        ____temp_15 = ____R_6280_80FD_4E0A_4E0B_6587_8868[unitId]
    end
    return ____temp_15
end
--- 每次施放都新建独立上下文（覆盖旧引用），旧回调通过“表引用一致”判定自身已过期。
local function _____521B_5EFAR_6280_80FD_4E0A_4E0B_6587(unit, ____type)
    local unitId = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unitId == 0 then
        return nil
    end
    local created = {
        ["施法者"] = unit,
        ["类型"] = ____type,
        ["周期回调ID"] = 0,
        ["强化回调ID"] = 0,
        ["已结束"] = false,
        ["光加攻值"] = 0,
        ["光减伤已应用"] = false,
        ["光强化特效回调ID"] = 0,
        ["暗二段开放回调ID"] = 0,
        ["暗汲取弹道列表"] = {},
        ["暗汲取弹道延迟回调ID列表"] = {}
    }
    ____R_6280_80FD_4E0A_4E0B_6587_8868[unitId] = created
    return created
end
local function _____505C_6B62R_6280_80FD_5468_671F(ctx)
    if ctx["周期回调ID"] ~= 0 then
        removePeriodicCallback(ctx["周期回调ID"])
        ctx["周期回调ID"] = 0
    end
end
--- 让单位恢复正常动作/时间缩放（源 JASS 的 PauseUnit false + SetUnitTimeScale 1.00）。
local function _____6062_590D_65BD_6CD5_8005_52A8_4F5C(_____65BD_6CD5_8005)
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 or not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        return
    end
    PauseUnit(_____65BD_6CD5_8005, false)
    SetUnitTimeScale(_____65BD_6CD5_8005, 1)
    ResetUnitAnimation(_____65BD_6CD5_8005)
end
--- 结束减速：20% 移动/攻击速度减慢，持续 3 秒（源 JASS 结束均施加减速）。
local function _____65BD_52A0_7ED3_675F_51CF_901F(_____65BD_6CD5_8005)
    if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 or not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        return
    end
    local cfg = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.R
    _____65BD_52A0_51CF_901F(
        _____65BD_6CD5_8005,
        _____65BD_6CD5_8005,
        cfg["结束减速比例"],
        cfg["结束减速持续秒"],
        "阿伦劳特-R-结束减速",
        "技能"
    )
end
--- 统一清理：停止周期、取消强化延迟、若仍是当前上下文则移除表引用，再执行形态结束还原。
-- 幂等（已结束直接返回），防止 6 秒到期回调与监视器 / 重复施放 / 死亡多条路径重复结算。
local function _____6E05_7406R_6280_80FD_4E0A_4E0B_6587(ctx, _____65BD_6CD5_8005, _____7ED3_675F_65F6)
    if ctx["已结束"] then
        return
    end
    ctx["已结束"] = true
    _____505C_6B62R_6280_80FD_5468_671F(ctx)
    if ctx["强化回调ID"] ~= 0 then
        removeDelayedCallback(ctx["强化回调ID"])
    end
    ctx["强化回调ID"] = 0
    if ctx["光强化特效回调ID"] ~= 0 then
        removePeriodicCallback(ctx["光强化特效回调ID"])
    end
    ctx["光强化特效回调ID"] = 0
    if ctx["暗二段开放回调ID"] ~= 0 then
        removeDelayedCallback(ctx["暗二段开放回调ID"])
    end
    ctx["暗二段开放回调ID"] = 0
    do
        local i = 0
        while i < #ctx["暗汲取弹道延迟回调ID列表"] do
            removeDelayedCallback(ctx["暗汲取弹道延迟回调ID列表"][i + 1])
            i = i + 1
        end
    end
    __TS__ArraySetLength(ctx["暗汲取弹道延迟回调ID列表"], 0)
    _____6E05_7406_6697_6C72_53D6_5F39_9053_5217_8868(ctx)
    local unitId = _____53D6_5355_4F4D_53E5_67C4ID(_____65BD_6CD5_8005)
    if unitId ~= 0 and ____R_6280_80FD_4E0A_4E0B_6587_8868[unitId] == ctx then
        __TS__Delete(____R_6280_80FD_4E0A_4E0B_6587_8868, unitId)
    end
    _____7ED3_675F_65F6(_____65BD_6CD5_8005, ctx)
end
local function _____7ED3_675F_5149_5F62_6001_6548_679C(_____65BD_6CD5_8005, ctx)
    local cfg = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.R
    SetUnitState(_____65BD_6CD5_8005, UNIT_STATE_MANA, 0)
    _____79FB_9664_539F_751FBuff(_____65BD_6CD5_8005, _____5929_5802_547C_5524_5F3A_5316BuffID)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____65BD_6CD5_8005, _____963F_4F26_52B3_7279BuffID["天堂呼唤"])
    if ctx["光加攻值"] > 0 then
        _____4E34_65F6_8C03_6574_653B_51FB(_____65BD_6CD5_8005, -ctx["光加攻值"])
    end
    if ctx["光减伤已应用"] then
        _____8C03_6574_73A9_5BB6_5C5E_6027(_____65BD_6CD5_8005, cfg["光强化魔法减伤属性名"], -cfg["光强化魔法减伤"])
    end
    _____6062_590D_65BD_6CD5_8005_52A8_4F5C(_____65BD_6CD5_8005)
    _____65BD_52A0_7ED3_675F_51CF_901F(_____65BD_6CD5_8005)
end
local function _____5149_5F3A_5316_5230_671F(_____65BD_6CD5_8005, ctx)
    if ctx["已结束"] then
        return
    end
    _____6E05_7406R_6280_80FD_4E0A_4E0B_6587(ctx, _____65BD_6CD5_8005, _____7ED3_675F_5149_5F62_6001_6548_679C)
end
local function _____5149_7948_7977_5B8C_6210(_____65BD_6CD5_8005, rctx)
    local cfg = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.R
    if _____83B7_53D6R_6280_80FD_4E0A_4E0B_6587(_____65BD_6CD5_8005) ~= rctx then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
        __TS__Delete(
            ____R_6280_80FD_4E0A_4E0B_6587_8868,
            _____53D6_5355_4F4D_53E5_67C4ID(_____65BD_6CD5_8005)
        )
        return
    end
    _____6DFB_52A0_539F_751FBuff_6301_7EED(_____65BD_6CD5_8005, _____5929_5802_547C_5524_5F3A_5316BuffID, cfg["光强化持续秒"])
    local _____653B_51FB_529B = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____65BD_6CD5_8005)
    local _____52A0_653B_503C = _____653B_51FB_529B * cfg["光强化攻击倍率"]
    if _____52A0_653B_503C > 0 then
        _____4E34_65F6_8C03_6574_653B_51FB(_____65BD_6CD5_8005, _____52A0_653B_503C)
        rctx["光加攻值"] = _____52A0_653B_503C
    end
    _____8C03_6574_73A9_5BB6_5C5E_6027(_____65BD_6CD5_8005, cfg["光强化魔法减伤属性名"], cfg["光强化魔法减伤"])
    rctx["光减伤已应用"] = true
    registerManualBuff(_____65BD_6CD5_8005, _____963F_4F26_52B3_7279BuffID["天堂呼唤"], cfg["光强化持续秒"], _____52A0_653B_503C)
    local function _____64AD_4E00_6B21_5149_5F3A_5316_7279_6548()
        if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 or not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) then
            return
        end
        local fx = createTimedUnitEffect(_____65BD_6CD5_8005, "chest", cfg["光强化特效"], cfg["光强化特效单次持续秒"])
        if fx ~= nil and fx ~= 0 then
            do
                pcall(function()
                    japi:EXSetEffectSpeed(fx, 0.5)
                end)
            end
        end
    end
    _____64AD_4E00_6B21_5149_5F3A_5316_7279_6548()
    rctx["光强化特效回调ID"] = addPeriodicCallback(
        _____53D6_56DB_820D_4E94_5165_6574_6570(cfg["光强化特效周期秒"] * 1000),
        function()
            if rctx["已结束"] or rctx["光强化特效回调ID"] == 0 then
                return
            end
            _____64AD_4E00_6B21_5149_5F3A_5316_7279_6548()
        end
    )
    _____6062_590D_65BD_6CD5_8005_52A8_4F5C(_____65BD_6CD5_8005)
    rctx["类型"] = "光强化"
    rctx["强化回调ID"] = addDelayedCallback(
        _____53D6_56DB_820D_4E94_5165_6574_6570(cfg["光强化持续秒"] * 1000),
        function()
            rctx["强化回调ID"] = 0
            _____5149_5F3A_5316_5230_671F(_____65BD_6CD5_8005, rctx)
        end
    )
    rctx["周期回调ID"] = addPeriodicCallback(
        200,
        function()
            if rctx["已结束"] or rctx["周期回调ID"] == 0 then
                return
            end
            if _____65BD_6CD5_8005 == nil or _____65BD_6CD5_8005 == 0 then
                return
            end
            local _____6709buff = _____62E5_6709_5929_5802_547C_5524(_____65BD_6CD5_8005)
            if not _____5355_4F4D_5B58_6D3B(_____65BD_6CD5_8005) or not _____6709buff then
                _____5149_5F3A_5316_5230_671F(_____65BD_6CD5_8005, rctx)
            end
        end
    )
end
local function _____5149_5F62_6001R(_____65BD_6CD5_8005)
    local cfg = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.R
    local _____5F53_524Dctx = _____83B7_53D6R_6280_80FD_4E0A_4E0B_6587(_____65BD_6CD5_8005)
    if _____5F53_524Dctx ~= nil and not _____5F53_524Dctx["已结束"] and _____5F53_524Dctx["类型"] == "光强化" then
        return
    end
    local _____65E7ctx = _____5F53_524Dctx
    if _____65E7ctx ~= nil and not _____65E7ctx["已结束"] then
        _____6E05_7406R_6280_80FD_4E0A_4E0B_6587(_____65E7ctx, _____65BD_6CD5_8005, _____7ED3_675F_5149_5F62_6001_6548_679C)
    end
    local rctx = _____521B_5EFAR_6280_80FD_4E0A_4E0B_6587(_____65BD_6CD5_8005, "光祈祷")
    if rctx == nil then
        return
    end
    addDelayedCallback(
        0,
        function()
            if rctx["已结束"] then
                return
            end
            if _____83B7_53D6R_6280_80FD_4E0A_4E0B_6587(_____65BD_6CD5_8005) ~= rctx then
                return
            end
            PauseUnit(_____65BD_6CD5_8005, true)
            SetUnitAnimationByIndex(_____65BD_6CD5_8005, 4)
            createTimedUnitEffect(_____65BD_6CD5_8005, "origin", cfg["光起手特效"], cfg["光起手特效持续秒"])
            local _____7948_7977_4E0A_4E0B_6587 = {["施法者"] = _____65BD_6CD5_8005, ["剩余次数"] = cfg["光祈祷次数"], ["回调ID"] = 0}
            _____7948_7977_4E0A_4E0B_6587["回调ID"] = addPeriodicCallback(
                _____53D6_56DB_820D_4E94_5165_6574_6570(cfg["光祈祷周期秒"] * 1000),
                function()
                    local _____7948_7977 = _____7948_7977_4E0A_4E0B_6587
                    if _____7948_7977["剩余次数"] <= 0 or not _____5355_4F4D_5B58_6D3B(_____7948_7977["施法者"]) then
                        removePeriodicCallback(_____7948_7977["回调ID"])
                        if rctx["周期回调ID"] == _____7948_7977["回调ID"] then
                            rctx["周期回调ID"] = 0
                        end
                        _____5149_7948_7977_5B8C_6210(_____7948_7977["施法者"], rctx)
                        return
                    end
                    _____7948_7977["剩余次数"] = _____7948_7977["剩余次数"] - 1
                    if _____7948_7977["剩余次数"] == cfg["光祈祷次数"] - 1 then
                        SetUnitTimeScale(_____7948_7977["施法者"], 0)
                    end
                    local _____65BD_6CD5_8005_73A9_5BB6 = GetOwningPlayer(_____7948_7977["施法者"])
                    local _____65BD_6CD5_8005X = GetUnitX(_____7948_7977["施法者"])
                    local _____65BD_6CD5_8005Y = GetUnitY(_____7948_7977["施法者"])
                    local _____653B_51FB_529B = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____7948_7977["施法者"])
                    local _____6CBB_7597_91CF = _____653B_51FB_529B * cfg["光周期治疗倍率"]
                    local _____5355_4F4D_5217_8868 = getUnitsInRange(_____65BD_6CD5_8005X, _____65BD_6CD5_8005Y, cfg["光友军范围"])
                    do
                        local i = 0
                        while i < #_____5355_4F4D_5217_8868 do
                            do
                                local _____53CB_519B = _____5355_4F4D_5217_8868[i + 1]
                                if not _____662F_6709_6548_76EE_6807(_____53CB_519B) then
                                    goto __continue55
                                end
                                if IsUnitEnemy(_____53CB_519B, _____65BD_6CD5_8005_73A9_5BB6) == true then
                                    goto __continue55
                                end
                                if _____6CBB_7597_91CF > 0 then
                                    doHeal({
                                        HealSource = _____7948_7977["施法者"],
                                        HealTarget = _____53CB_519B,
                                        HealAmount = _____6CBB_7597_91CF,
                                        ItemHeal = false,
                                        HealEffect = true
                                    })
                                end
                                _____79FB_9664_5355_4F4D_8D1F_9762Buff(_____53CB_519B, false)
                            end
                            ::__continue55::
                            i = i + 1
                        end
                    end
                    local _____98DE_884C_9AD8_5EA6 = GetUnitFlyHeight(_____7948_7977["施法者"])
                    _____521B_5EFA_70B9_7279_6548({
                        ["模型路径"] = cfg["光周期特效1"],
                        X = _____65BD_6CD5_8005X,
                        Y = _____65BD_6CD5_8005Y,
                        Z = _____98DE_884C_9AD8_5EA6,
                        ["缩放"] = cfg["光周期特效1缩放"],
                        ["持续秒"] = cfg["光周期特效持续秒"]
                    })
                    _____521B_5EFA_70B9_7279_6548({
                        ["模型路径"] = cfg["光周期特效2"],
                        X = _____65BD_6CD5_8005X,
                        Y = _____65BD_6CD5_8005Y,
                        Z = _____98DE_884C_9AD8_5EA6,
                        ["持续秒"] = cfg["光周期特效持续秒"]
                    })
                end
            )
            rctx["周期回调ID"] = _____7948_7977_4E0A_4E0B_6587["回调ID"]
        end
    )
end
--- 弹道命中施法者：先增加最大生命，再增加当前生命，不能被旧最大生命封顶。
local function _____7ED3_7B97_6697_6C72_53D6_6062_590D(ctx)
    if ctx["施法者"] == nil or ctx["施法者"] == 0 or not _____5355_4F4D_5B58_6D3B(ctx["施法者"]) or not (ctx["汲取值"] > 0) then
        return
    end
    local _____5F53_524D_6700_5927_751F_547D = GetUnitState(ctx["施法者"], UNIT_STATE_MAX_LIFE)
    SetUnitState(ctx["施法者"], UNIT_STATE_MAX_LIFE, _____5F53_524D_6700_5927_751F_547D + ctx["汲取值"])
    SetUnitState(
        ctx["施法者"],
        UNIT_STATE_LIFE,
        GetUnitState(ctx["施法者"], UNIT_STATE_LIFE) + ctx["汲取值"]
    )
    ctx["最大生命已增加"] = true
    ctx["回滚回调ID"] = addPeriodicCallback(1000, _____68C0_67E5_6697_6C72_53D6_6700_5927_751F_547D, ctx)
end
local function _____4E09_6B21_8D1D_585E_5C14_503C(_____8D77_70B9, _____63A7_5236_70B91, _____63A7_5236_70B92, _____7EC8_70B9, t)
    local _____53CD_5411_8FDB_5EA6 = 1 - t
    return _____53CD_5411_8FDB_5EA6 * _____53CD_5411_8FDB_5EA6 * _____53CD_5411_8FDB_5EA6 * _____8D77_70B9 + 3 * _____53CD_5411_8FDB_5EA6 * _____53CD_5411_8FDB_5EA6 * t * _____63A7_5236_70B91 + 3 * _____53CD_5411_8FDB_5EA6 * t * t * _____63A7_5236_70B92 + t * t * t * _____7EC8_70B9
end
local function _____8BA1_7B97_6697_6C72_53D6_8D1D_585E_5C14_70B9(ctx, _____7EC8_70B9X, _____7EC8_70B9Y, _____7EC8_70B9Z, t)
    local dx = _____7EC8_70B9X - ctx["起点X"]
    local dy = _____7EC8_70B9Y - ctx["起点Y"]
    local _____5E73_9762_8DDD_79BB = _____4E24_70B9_8DDD_79BB(ctx["起点X"], ctx["起点Y"], _____7EC8_70B9X, _____7EC8_70B9Y)
    local _____5355_4F4D_65B9_5411X = _____5E73_9762_8DDD_79BB > 0 and dx / _____5E73_9762_8DDD_79BB or 0
    local _____5355_4F4D_65B9_5411Y = _____5E73_9762_8DDD_79BB > 0 and dy / _____5E73_9762_8DDD_79BB or 0
    local _____5782_7EBF_65B9_5411X = -_____5355_4F4D_65B9_5411Y
    local _____5782_7EBF_65B9_5411Y = _____5355_4F4D_65B9_5411X
    local _____63A7_5236_70B91X = ctx["起点X"] + dx * 0.3 + _____5782_7EBF_65B9_5411X * ctx["弧线侧偏"]
    local _____63A7_5236_70B91Y = ctx["起点Y"] + dy * 0.3 + _____5782_7EBF_65B9_5411Y * ctx["弧线侧偏"]
    local _____63A7_5236_70B92X = _____7EC8_70B9X - dx * 0.3 + _____5782_7EBF_65B9_5411X * ctx["弧线侧偏"] * 0.5
    local _____63A7_5236_70B92Y = _____7EC8_70B9Y - dy * 0.3 + _____5782_7EBF_65B9_5411Y * ctx["弧线侧偏"] * 0.5
    local _____63A7_5236_70B91Z = ctx["起点Z"] + _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.R["暗汲取弹道贝塞尔高度"]
    local _____63A7_5236_70B92Z = _____7EC8_70B9Z + _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.R["暗汲取弹道贝塞尔高度"] * 0.75
    return {
        X = _____4E09_6B21_8D1D_585E_5C14_503C(
            ctx["起点X"],
            _____63A7_5236_70B91X,
            _____63A7_5236_70B92X,
            _____7EC8_70B9X,
            t
        ),
        Y = _____4E09_6B21_8D1D_585E_5C14_503C(
            ctx["起点Y"],
            _____63A7_5236_70B91Y,
            _____63A7_5236_70B92Y,
            _____7EC8_70B9Y,
            t
        ),
        Z = _____4E09_6B21_8D1D_585E_5C14_503C(
            ctx["起点Z"],
            _____63A7_5236_70B91Z,
            _____63A7_5236_70B92Z,
            _____7EC8_70B9Z,
            t
        )
    }
end
local function _____8BBE_7F6E_6697_6C72_53D6_5F39_9053_4F4D_7F6E(effect, x, y, z)
    if effect == nil or effect == 0 then
        return
    end
    if EXSetEffectXY ~= nil then
        EXSetEffectXY(effect, x, y)
    else
        if EXSetEffectX ~= nil then
            EXSetEffectX(effect, x)
        end
        if EXSetEffectY ~= nil then
            EXSetEffectY(effect, y)
        end
    end
    if EXSetEffectZ ~= nil then
        EXSetEffectZ(effect, z)
    end
end
local function _____63A8_8FDB_6697_6C72_53D6_5F39_9053(variable)
    local ctx = variable
    if ctx == nil or ctx["已结束"] then
        return
    end
    if ctx["所属R上下文"]["已结束"] or not _____5355_4F4D_5B58_6D3B(ctx["施法者"]) then
        _____7ED3_675F_6697_6C72_53D6_5F39_9053(ctx, true)
        return
    end
    if ctx["剩余tick"] <= 0 then
        _____7ED3_675F_6697_6C72_53D6_5F39_9053(ctx, false)
        return
    end
    ctx["剩余tick"] = ctx["剩余tick"] - 1
    local _____65BD_6CD5_8005X = GetUnitX(ctx["施法者"])
    local _____65BD_6CD5_8005Y = GetUnitY(ctx["施法者"])
    local _____65BD_6CD5_8005Z = GetUnitFlyHeight(ctx["施法者"]) + _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.R["暗汲取弹道Z偏移"]
    local _____4E0A_4E00X = ctx["当前X"]
    local _____4E0A_4E00Y = ctx["当前Y"]
    ctx["进度"] = ctx["进度"] + 1 / _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.R["暗汲取弹道最大tick"]
    local _____8FDB_5EA6 = ctx["进度"] > 1 and 1 or ctx["进度"]
    local _____8D1D_585E_5C14_70B9 = _____8BA1_7B97_6697_6C72_53D6_8D1D_585E_5C14_70B9(
        ctx,
        _____65BD_6CD5_8005X,
        _____65BD_6CD5_8005Y,
        _____65BD_6CD5_8005Z,
        _____8FDB_5EA6
    )
    local _____8DEF_5F84_89D2_5EA6 = _____4E24_70B9_89D2_5EA6(_____4E0A_4E00X, _____4E0A_4E00Y, _____8D1D_585E_5C14_70B9.X, _____8D1D_585E_5C14_70B9.Y)
    ctx["当前X"] = _____8D1D_585E_5C14_70B9.X
    ctx["当前Y"] = _____8D1D_585E_5C14_70B9.Y
    ctx["当前Z"] = _____8D1D_585E_5C14_70B9.Z
    _____8BBE_7F6E_6697_6C72_53D6_5F39_9053_4F4D_7F6E(ctx["弹道1"], _____8D1D_585E_5C14_70B9.X, _____8D1D_585E_5C14_70B9.Y, _____8D1D_585E_5C14_70B9.Z)
    _____8BBE_7F6E_6697_6C72_53D6_5F39_9053_4F4D_7F6E(
        ctx["弹道2"],
        _____8D1D_585E_5C14_70B9.X - Cos(_____8DEF_5F84_89D2_5EA6 * _____89D2_5EA6_8F6C_5F27_5EA6) * _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.R["暗汲取弹道后方偏移"],
        _____8D1D_585E_5C14_70B9.Y - Sin(_____8DEF_5F84_89D2_5EA6 * _____89D2_5EA6_8F6C_5F27_5EA6) * _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.R["暗汲取弹道后方偏移"],
        _____8D1D_585E_5C14_70B9.Z
    )
    if _____8FDB_5EA6 >= 1 or _____4E24_70B9_8DDD_79BB(ctx["当前X"], ctx["当前Y"], _____65BD_6CD5_8005X, _____65BD_6CD5_8005Y) <= 100 then
        if ctx["回调ID"] ~= 0 then
            removePeriodicCallback(ctx["回调ID"])
        end
        ctx["回调ID"] = 0
        _____9500_6BC1_6697_6C72_53D6_5F39_9053_7279_6548(ctx)
        ctx["已命中"] = true
        _____7ED3_7B97_6697_6C72_53D6_6062_590D(ctx)
    end
end
local function _____5F00_59CB_6697_6C72_53D6_5F39_9053(_____65BD_6CD5_8005, _____76EE_6807_5355_4F4D, _____6C72_53D6_503C, _____6240_5C5ER_4E0A_4E0B_6587, _____5F27_7EBF_4FA7_504F)
    local cfg = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.R
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 or _____6240_5C5ER_4E0A_4E0B_6587["已结束"] then
        return
    end
    local _____76EE_6807X = GetUnitX(_____76EE_6807_5355_4F4D)
    local _____76EE_6807Y = GetUnitY(_____76EE_6807_5355_4F4D)
    local _____98DE_884C_9AD8_5EA6 = GetUnitFlyHeight(_____76EE_6807_5355_4F4D)
    local _____65BD_6CD5_8005X = GetUnitX(_____65BD_6CD5_8005)
    local _____65BD_6CD5_8005Y = GetUnitY(_____65BD_6CD5_8005)
    local _____89D2_5EA6 = _____4E24_70B9_89D2_5EA6(_____76EE_6807X, _____76EE_6807Y, _____65BD_6CD5_8005X, _____65BD_6CD5_8005Y)
    local _____9C9C_8840X = _____76EE_6807X - Cos(_____89D2_5EA6 * _____89D2_5EA6_8F6C_5F27_5EA6) * cfg["暗汲取弹道后方偏移"]
    local _____9C9C_8840Y = _____76EE_6807Y - Sin(_____89D2_5EA6 * _____89D2_5EA6_8F6C_5F27_5EA6) * cfg["暗汲取弹道后方偏移"]
    local _____5F39_90531 = _____521B_5EFA_70B9_7279_6548({["模型路径"] = cfg["暗汲取弹道1"], X = _____76EE_6807X, Y = _____76EE_6807Y, Z = _____98DE_884C_9AD8_5EA6 + cfg["暗汲取弹道Z偏移"]})
    local _____5F39_90532 = _____521B_5EFA_70B9_7279_6548({["模型路径"] = cfg["暗汲取弹道2"], X = _____9C9C_8840X, Y = _____9C9C_8840Y, Z = _____98DE_884C_9AD8_5EA6 + cfg["暗汲取弹道Z偏移"]})
    if _____5F39_90531 == nil or _____5F39_90531 == 0 or _____5F39_90532 == nil or _____5F39_90532 == 0 then
        if _____5F39_90531 ~= nil and _____5F39_90531 ~= 0 then
            DestroyEffect(_____5F39_90531)
        end
        if _____5F39_90532 ~= nil and _____5F39_90532 ~= 0 then
            DestroyEffect(_____5F39_90532)
        end
        return
    end
    local _____5F39_9053_4E0A_4E0B_6587 = {
        ["施法者"] = _____65BD_6CD5_8005,
        ["所属R上下文"] = _____6240_5C5ER_4E0A_4E0B_6587,
        ["弹道1"] = _____5F39_90531,
        ["弹道2"] = _____5F39_90532,
        ["当前X"] = _____76EE_6807X,
        ["当前Y"] = _____76EE_6807Y,
        ["汲取值"] = _____6C72_53D6_503C,
        ["剩余tick"] = cfg["暗汲取弹道最大tick"],
        ["回调ID"] = 0,
        ["回滚回调ID"] = 0,
        ["已命中"] = false,
        ["最大生命已增加"] = false,
        ["最大生命已回滚"] = false,
        ["已结束"] = false,
        ["当前Z"] = _____98DE_884C_9AD8_5EA6 + cfg["暗汲取弹道Z偏移"],
        ["起点X"] = _____76EE_6807X,
        ["起点Y"] = _____76EE_6807Y,
        ["起点Z"] = _____98DE_884C_9AD8_5EA6 + cfg["暗汲取弹道Z偏移"],
        ["进度"] = 0,
        ["弧线侧偏"] = _____5F27_7EBF_4FA7_504F
    }
    local ____6240_5C5ER_4E0A_4E0B_6587__6697_6C72_53D6_5F39_9053_5217_8868_16 = _____6240_5C5ER_4E0A_4E0B_6587["暗汲取弹道列表"]
    ____6240_5C5ER_4E0A_4E0B_6587__6697_6C72_53D6_5F39_9053_5217_8868_16[#____6240_5C5ER_4E0A_4E0B_6587__6697_6C72_53D6_5F39_9053_5217_8868_16 + 1] = _____5F39_9053_4E0A_4E0B_6587
    _____5F39_9053_4E0A_4E0B_6587["回调ID"] = addPeriodicCallback(20, _____63A8_8FDB_6697_6C72_53D6_5F39_9053, _____5F39_9053_4E0A_4E0B_6587)
end
local function _____5EF6_8FDF_5F00_59CB_6697_6C72_53D6_5F39_9053(variable)
    local _____53C2_6570 = variable
    if _____53C2_6570 == nil or _____53C2_6570["所属R上下文"]["已结束"] then
        return
    end
    _____5F00_59CB_6697_6C72_53D6_5F39_9053(
        _____53C2_6570["施法者"],
        _____53C2_6570["目标单位"],
        _____53C2_6570["汲取值"],
        _____53C2_6570["所属R上下文"],
        _____53C2_6570["弧线侧偏"]
    )
end
local function _____5F00_653E_6697_5F62_6001R_4E8C_6BB5(variable)
    local rctx = variable
    if rctx == nil or rctx["已结束"] or not _____62E5_6709_88C1_51B3_5BA1_5224(rctx["施法者"]) then
        return
    end
    rctx["暗二段开放回调ID"] = 0
    UnitAddAbility(rctx["施法者"], ____R_4E8C_6BB5_6280_80FDID)
    UnitAddAbility(rctx["施法者"], _____88C1_51B3_5BA1_5224_5F3A_5316_6280_80FDID)
    SetPlayerAbilityAvailable(
        GetOwningPlayer(rctx["施法者"]),
        ____R_6280_80FDID,
        false
    )
end
local function _____7ED3_675F_6697_5F62_6001_6548_679C(_____65BD_6CD5_8005, _ctx)
    SetUnitState(_____65BD_6CD5_8005, UNIT_STATE_MANA, 0)
    UnitRemoveAbility(_____65BD_6CD5_8005, ____R_4E8C_6BB5_6280_80FDID)
    _____79FB_9664_539F_751FBuff(_____65BD_6CD5_8005, _____88C1_51B3_5BA1_5224_5F3A_5316BuffID)
    UnitRemoveAbility(_____65BD_6CD5_8005, _____88C1_51B3_5BA1_5224_5F3A_5316_6280_80FDID)
    SetPlayerAbilityAvailable(
        GetOwningPlayer(_____65BD_6CD5_8005),
        ____R_6280_80FDID,
        true
    )
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____65BD_6CD5_8005, _____963F_4F26_52B3_7279BuffID["裁决审判"])
    _____65BD_52A0_7ED3_675F_51CF_901F(_____65BD_6CD5_8005)
end
local function _____6697_5F3A_5316_5230_671F(_____65BD_6CD5_8005, ctx)
    if ctx["已结束"] then
        return
    end
    _____6E05_7406R_6280_80FD_4E0A_4E0B_6587(ctx, _____65BD_6CD5_8005, _____7ED3_675F_6697_5F62_6001_6548_679C)
end
local function _____6697_5F3A_5316_5EF6_8FDF_7ED3_675F(variable)
    local ctx = variable
    if ctx == nil or ctx["已结束"] then
        return
    end
    ctx["强化回调ID"] = 0
    _____6697_5F3A_5316_5230_671F(ctx["施法者"], ctx)
end
local function _____68C0_67E5_6697_5F3A_5316_72B6_6001(variable)
    local ctx = variable
    if ctx == nil or ctx["已结束"] or ctx["周期回调ID"] == 0 then
        return
    end
    if ctx["施法者"] == nil or ctx["施法者"] == 0 then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(ctx["施法者"]) or not _____62E5_6709_88C1_51B3_5BA1_5224(ctx["施法者"]) then
        _____6697_5F3A_5316_5230_671F(ctx["施法者"], ctx)
    end
end
local function _____6697_5F62_6001R(_____65BD_6CD5_8005)
    local cfg = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.R
    local _____65E7ctx = _____83B7_53D6R_6280_80FD_4E0A_4E0B_6587(_____65BD_6CD5_8005)
    if _____65E7ctx ~= nil and not _____65E7ctx["已结束"] then
        _____6E05_7406R_6280_80FD_4E0A_4E0B_6587(_____65E7ctx, _____65BD_6CD5_8005, _____7ED3_675F_6697_5F62_6001_6548_679C)
    end
    local rctx = _____521B_5EFAR_6280_80FD_4E0A_4E0B_6587(_____65BD_6CD5_8005, "暗汲取")
    if rctx == nil then
        return
    end
    local _____65BD_6CD5_8005X = GetUnitX(_____65BD_6CD5_8005)
    local _____65BD_6CD5_8005Y = GetUnitY(_____65BD_6CD5_8005)
    local _____65BD_6CD5_8005_73A9_5BB6 = GetOwningPlayer(_____65BD_6CD5_8005)
    local _____65BD_6CD5_8005_5355_4F4DID = GetUnitTypeId(_____65BD_6CD5_8005)
    local _____5355_4F4D_5217_8868 = getUnitsInRange(_____65BD_6CD5_8005X, _____65BD_6CD5_8005Y, cfg["暗汲取范围"])
    local _____6709_6548_76EE_6807_6570_91CF = 0
    do
        local i = 0
        while i < #_____5355_4F4D_5217_8868 do
            do
                local _____76EE_6807 = _____5355_4F4D_5217_8868[i + 1]
                if not _____662F_6709_6548_76EE_6807(_____76EE_6807) then
                    goto __continue116
                end
                if GetUnitTypeId(_____76EE_6807) == _____65BD_6CD5_8005_5355_4F4DID then
                    goto __continue116
                end
                local _____76EE_6807_5F53_524D_751F_547D = GetUnitState(_____76EE_6807, UNIT_STATE_LIFE)
                local _____6C72_53D6_503C = _____76EE_6807_5F53_524D_751F_547D * cfg["暗汲取比例"]
                if not (_____6C72_53D6_503C > 0) then
                    goto __continue116
                end
                _____6709_6548_76EE_6807_6570_91CF = _____6709_6548_76EE_6807_6570_91CF + 1
                SetUnitState(_____76EE_6807, UNIT_STATE_LIFE, _____76EE_6807_5F53_524D_751F_547D - _____6C72_53D6_503C)
                _____9020_6210_6280_80FD_4F24_5BB3({
                    ["来源"] = _____65BD_6CD5_8005,
                    ["目标"] = _____76EE_6807,
                    ["伤害"] = cfg["暗汲取固定伤害"],
                    ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
                    attack = false,
                    attackType = ATTACK_TYPE_CHAOS,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "单位技能",
                    ["技能ID"] = ____R_6280_80FDID,
                    ["标签"] = "阿伦劳特-R-裁决审判",
                    ["伤害形态"] = "AOE",
                    ["参与技能伤害加成"] = true
                })
                _____521B_5EFA_70B9_7279_6548({
                    ["模型路径"] = cfg["暗汲取命中特效"],
                    X = GetUnitX(_____76EE_6807),
                    Y = GetUnitY(_____76EE_6807),
                    Z = GetUnitFlyHeight(_____76EE_6807) + cfg["暗汲取弹道Z偏移"],
                    ["持续秒"] = cfg["暗汲取命中特效持续秒"]
                })
                local _____5F39_9053_5EF6_8FDF_56DE_8C03ID = addDelayedCallback(500, _____5EF6_8FDF_5F00_59CB_6697_6C72_53D6_5F39_9053, {
                    ["施法者"] = _____65BD_6CD5_8005,
                    ["目标单位"] = _____76EE_6807,
                    ["汲取值"] = _____6C72_53D6_503C,
                    ["所属R上下文"] = rctx,
                    ["弧线侧偏"] = i % 2 == 0 and cfg["暗汲取弹道贝塞尔侧偏"] or -cfg["暗汲取弹道贝塞尔侧偏"]
                })
                local ____rctx__6697_6C72_53D6_5F39_9053_5EF6_8FDF_56DE_8C03ID_5217_8868_17 = rctx["暗汲取弹道延迟回调ID列表"]
                ____rctx__6697_6C72_53D6_5F39_9053_5EF6_8FDF_56DE_8C03ID_5217_8868_17[#____rctx__6697_6C72_53D6_5F39_9053_5EF6_8FDF_56DE_8C03ID_5217_8868_17 + 1] = _____5F39_9053_5EF6_8FDF_56DE_8C03ID
            end
            ::__continue116::
            i = i + 1
        end
    end
    _____6DFB_52A0_539F_751FBuff_6301_7EED(_____65BD_6CD5_8005, _____88C1_51B3_5BA1_5224_5F3A_5316BuffID, cfg["暗强化持续秒"])
    registerManualBuff(_____65BD_6CD5_8005, _____963F_4F26_52B3_7279BuffID["裁决审判"], cfg["暗强化持续秒"], 0)
    if _____6709_6548_76EE_6807_6570_91CF > 0 then
        rctx["暗二段开放回调ID"] = addDelayedCallback(500, _____5F00_653E_6697_5F62_6001R_4E8C_6BB5, rctx)
    end
    rctx["类型"] = "暗强化"
    rctx["强化回调ID"] = addDelayedCallback(
        _____53D6_56DB_820D_4E94_5165_6574_6570(cfg["暗强化持续秒"] * 1000),
        _____6697_5F3A_5316_5EF6_8FDF_7ED3_675F,
        rctx
    )
    rctx["周期回调ID"] = addPeriodicCallback(200, _____68C0_67E5_6697_5F3A_5316_72B6_6001, rctx)
end
local function _____65BD_653E_88C1_51B3_51B2_51FB(_____65BD_6CD5_8005)
    local cfg = _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E.R2
    local _____65BD_6CD5_8005X = GetUnitX(_____65BD_6CD5_8005)
    local _____65BD_6CD5_8005Y = GetUnitY(_____65BD_6CD5_8005)
    local _____76EE_6807X = GetSpellTargetX()
    local _____76EE_6807Y = GetSpellTargetY()
    local _____89D2_5EA6 = _____4E24_70B9_89D2_5EA6(_____65BD_6CD5_8005X, _____65BD_6CD5_8005Y, _____76EE_6807X, _____76EE_6807Y)
    local _____98DE_884C_9AD8_5EA6 = GetUnitFlyHeight(_____65BD_6CD5_8005)
    local _____65E7ctx = _____83B7_53D6R_6280_80FD_4E0A_4E0B_6587(_____65BD_6CD5_8005)
    if _____65E7ctx ~= nil and not _____65E7ctx["已结束"] then
        _____6E05_7406R_6280_80FD_4E0A_4E0B_6587(_____65E7ctx, _____65BD_6CD5_8005, _____7ED3_675F_6697_5F62_6001_6548_679C)
    end
    local rctx = _____521B_5EFAR_6280_80FD_4E0A_4E0B_6587(_____65BD_6CD5_8005, "R2")
    if rctx == nil then
        return
    end
    SetUnitState(_____65BD_6CD5_8005, UNIT_STATE_MANA, 0)
    _____79FB_9664_539F_751FBuff(_____65BD_6CD5_8005, _____88C1_51B3_5BA1_5224_5F3A_5316BuffID)
    local _____8840_5899X = _____65BD_6CD5_8005X + Cos(_____89D2_5EA6 * _____89D2_5EA6_8F6C_5F27_5EA6) * cfg["血墙点距离"]
    local _____8840_5899Y = _____65BD_6CD5_8005Y + Sin(_____89D2_5EA6 * _____89D2_5EA6_8F6C_5F27_5EA6) * cfg["血墙点距离"]
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["血墙特效"],
        X = _____8840_5899X,
        Y = _____8840_5899Y,
        Z = _____98DE_884C_9AD8_5EA6,
        ["缩放"] = cfg["血墙缩放"],
        ["Z轴角度"] = _____89D2_5EA6 + 90,
        ["持续秒"] = 1
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["冲击特效"],
        X = _____65BD_6CD5_8005X,
        Y = _____65BD_6CD5_8005Y,
        Z = _____98DE_884C_9AD8_5EA6,
        ["缩放"] = cfg["冲击缩放"],
        ["Z轴角度"] = _____89D2_5EA6,
        ["持续秒"] = 1
    })
    local _____5DF2_547D_4E2D_5355_4F4DID_96C6_5408 = {}
    local _____63A8_8FDB_4E0A_4E0B_6587 = {
        ["施法者"] = _____65BD_6CD5_8005,
        ["当前X"] = _____65BD_6CD5_8005X,
        ["当前Y"] = _____65BD_6CD5_8005Y,
        ["剩余tick"] = cfg["弹幕最大tick"],
        ["回调ID"] = 0
    }
    _____63A8_8FDB_4E0A_4E0B_6587["回调ID"] = addPeriodicCallback(
        20,
        function()
            local _____63A8_8FDB = _____63A8_8FDB_4E0A_4E0B_6587
            if _____63A8_8FDB["剩余tick"] <= 0 or _____63A8_8FDB["施法者"] == nil or _____63A8_8FDB["施法者"] == 0 or not _____5355_4F4D_5B58_6D3B(_____63A8_8FDB["施法者"]) then
                removePeriodicCallback(_____63A8_8FDB["回调ID"])
                if rctx["周期回调ID"] == _____63A8_8FDB["回调ID"] then
                    rctx["周期回调ID"] = 0
                    rctx["已结束"] = true
                    if _____83B7_53D6R_6280_80FD_4E0A_4E0B_6587(_____65BD_6CD5_8005) == rctx then
                        __TS__Delete(
                            ____R_6280_80FD_4E0A_4E0B_6587_8868,
                            _____53D6_5355_4F4D_53E5_67C4ID(_____65BD_6CD5_8005)
                        )
                    end
                end
                return
            end
            _____63A8_8FDB["剩余tick"] = _____63A8_8FDB["剩余tick"] - 1
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = cfg["路径特效"],
                X = _____63A8_8FDB["当前X"],
                Y = _____63A8_8FDB["当前Y"],
                Z = _____98DE_884C_9AD8_5EA6,
                ["Z轴角度"] = _____89D2_5EA6,
                ["持续秒"] = cfg["路径特效持续秒"]
            })
            local _____654C_4EBA_5217_8868 = getUnitsInRange(_____63A8_8FDB["当前X"], _____63A8_8FDB["当前Y"], cfg["路径扫描半径"])
            do
                local i = 0
                while i < #_____654C_4EBA_5217_8868 do
                    do
                        local _____76EE_6807 = _____654C_4EBA_5217_8868[i + 1]
                        if not _____662F_6709_6548_76EE_6807(_____76EE_6807) then
                            goto __continue129
                        end
                        if IsUnitEnemy(
                            _____76EE_6807,
                            GetOwningPlayer(_____63A8_8FDB["施法者"])
                        ) ~= true then
                            goto __continue129
                        end
                        local _____76EE_6807ID = GetHandleId(_____76EE_6807)
                        if _____76EE_6807ID == 0 or _____5DF2_547D_4E2D_5355_4F4DID_96C6_5408[_____76EE_6807ID] == true then
                            goto __continue129
                        end
                        _____5DF2_547D_4E2D_5355_4F4DID_96C6_5408[_____76EE_6807ID] = true
                        local _____81EA_8EAB_5F53_524D_751F_547D = GetUnitState(_____63A8_8FDB["施法者"], UNIT_STATE_LIFE)
                        local _____76EE_6807_5DF2_635F_5931_751F_547D = _____53D6_975E_8D1F_6570(GetUnitState(_____76EE_6807, UNIT_STATE_MAX_LIFE) - GetUnitState(_____76EE_6807, UNIT_STATE_LIFE))
                        local _____4F24_5BB3 = _____81EA_8EAB_5F53_524D_751F_547D * cfg["自身生命倍率"] + _____76EE_6807_5DF2_635F_5931_751F_547D * cfg["目标损失生命倍率"]
                        _____9020_6210_6280_80FD_4F24_5BB3({
                            ["来源"] = _____63A8_8FDB["施法者"],
                            ["目标"] = _____76EE_6807,
                            ["伤害"] = _____4F24_5BB3,
                            ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
                            attack = false,
                            attackType = ATTACK_TYPE_NORMAL,
                            weaponType = WEAPON_TYPE_WHOKNOWS,
                            ["来源类型"] = "单位技能",
                            ["技能ID"] = ____R_4E8C_6BB5_6280_80FDID,
                            ["标签"] = "阿伦劳特-R2-裁决冲击",
                            ["伤害形态"] = "AOE",
                            ["参与技能伤害加成"] = true
                        })
                        _____65BD_52A0_7729_6655(
                            _____63A8_8FDB["施法者"],
                            _____76EE_6807,
                            cfg["眩晕秒"],
                            "阿伦劳特-R2-裁决冲击",
                            "技能"
                        )
                        _____5F00_59CB_51FB_9000(_____76EE_6807, {
                            ["来源单位"] = _____63A8_8FDB["施法者"],
                            ["距离"] = cfg["击退距离"],
                            ["持续时间"] = cfg["击退持续秒"],
                            ["检查地形"] = true,
                            ["禁用碰撞"] = true
                        })
                    end
                    ::__continue129::
                    i = i + 1
                end
            end
            _____63A8_8FDB["当前X"] = _____63A8_8FDB["当前X"] + Cos(_____89D2_5EA6 * _____89D2_5EA6_8F6C_5F27_5EA6) * cfg["弹幕每tick距离"]
            _____63A8_8FDB["当前Y"] = _____63A8_8FDB["当前Y"] + Sin(_____89D2_5EA6 * _____89D2_5EA6_8F6C_5F27_5EA6) * cfg["弹幕每tick距离"]
        end
    )
    rctx["周期回调ID"] = _____63A8_8FDB_4E0A_4E0B_6587["回调ID"]
end
local function _____963F_4F26_52B3_7279R_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    if not _____662F_963F_4F26_52B3_7279_82F1_96C4(dyingUnit) then
        return
    end
    local ctx = _____83B7_53D6R_6280_80FD_4E0A_4E0B_6587(dyingUnit)
    if ctx == nil or ctx["已结束"] then
        return
    end
    local _____65BD_6CD5_8005 = ctx["施法者"]
    if ctx["类型"] == "光祈祷" or ctx["类型"] == "光强化" then
        _____6E05_7406R_6280_80FD_4E0A_4E0B_6587(ctx, _____65BD_6CD5_8005, _____7ED3_675F_5149_5F62_6001_6548_679C)
    else
        _____6E05_7406R_6280_80FD_4E0A_4E0B_6587(ctx, _____65BD_6CD5_8005, _____7ED3_675F_6697_5F62_6001_6548_679C)
    end
end
--- R：A0D5，按形态分流（光 = 天堂呼唤，暗 = 裁决审判）
____exports["on阿伦劳特R"] = function(_____65BD_6CD5_8005, _____6280_80FDID_6570_503C)
    if _____6280_80FDID_6570_503C ~= ____R_6280_80FDID then
        return
    end
    if not _____662F_963F_4F26_52B3_7279_82F1_96C4(_____65BD_6CD5_8005) then
        return
    end
    if _____662F_5149_5F62_6001(_____65BD_6CD5_8005) then
        _____5149_5F62_6001R(_____65BD_6CD5_8005)
    elseif _____662F_6697_5F62_6001(_____65BD_6CD5_8005) then
        _____6697_5F62_6001R(_____65BD_6CD5_8005)
    end
end
--- R 二段：裁决冲击（A0D2）——暗形态 R 的 B015 提供开放窗口
____exports["on阿伦劳特R2"] = function(_____65BD_6CD5_8005, _____6280_80FDID_6570_503C)
    if _____6280_80FDID_6570_503C ~= ____R_4E8C_6BB5_6280_80FDID then
        return
    end
    if not _____662F_963F_4F26_52B3_7279_82F1_96C4(_____65BD_6CD5_8005) then
        return
    end
    if not _____662F_6697_5F62_6001(_____65BD_6CD5_8005) or not _____62E5_6709_88C1_51B3_5BA1_5224(_____65BD_6CD5_8005) then
        return
    end
    local rctx = _____83B7_53D6R_6280_80FD_4E0A_4E0B_6587(_____65BD_6CD5_8005)
    if rctx == nil or rctx["类型"] ~= "暗强化" and rctx["类型"] ~= "暗汲取" then
        return
    end
    _____65BD_653E_88C1_51B3_51B2_51FB(_____65BD_6CD5_8005)
end
registerSpellEffectListener(____exports["on阿伦劳特R"])
registerSpellEffectListener(____exports["on阿伦劳特R2"])
registerDeathListener(_____963F_4F26_52B3_7279R_5355_4F4D_6B7B_4EA1)
return ____exports

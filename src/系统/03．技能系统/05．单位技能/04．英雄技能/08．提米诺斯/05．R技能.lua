local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.08．提米诺斯.00．配置")
local _____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["提米诺斯单位技能配置"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.08．提米诺斯.00A．表现工具")
local _____64AD_653E_63D0_7C73_8BFA_65AF_5355_4F4D_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放提米诺斯单位音效"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.03．技能系统.02．技能消耗.01．魔法消耗返还")
local getAbilityManaCost = ____require_result_1.getAbilityManaCost
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local getBuffRuntime = ____require_result_2.getBuffRuntime
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_2["移除单位指定Buff"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_3["创建点特效"]
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWESetUnitAbilityStateSafe = ____require_result_4.YDWESetUnitAbilityStateSafe
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_5.stringToFourCCSafe
local ____R_6280_80FDID = stringToFourCCSafe(_____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E["R技能ID"])
local _____63D0_7C73_8BFA_65AF_5355_4F4DID = stringToFourCCSafe(_____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local _____539F_751F_72B6_6001_6280_80FDID = stringToFourCCSafe(_____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E.R["原生状态技能ID"])
local _____795D_798F_8868 = {}
local function _____6E05_7406_795D_798F(target)
    if target == nil or target == 0 then
        return
    end
    __TS__Delete(
        _____795D_798F_8868,
        jass.GetHandleId(target)
    )
    jass.UnitRemoveAbility(target, _____539F_751F_72B6_6001_6280_80FDID)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(target, _____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E.R.BuffID)
end
local function ____on_795D_798F_79FB_9664(target)
    if target == nil or target == 0 then
        return
    end
    __TS__Delete(
        _____795D_798F_8868,
        jass.GetHandleId(target)
    )
    jass.UnitRemoveAbility(target, _____539F_751F_72B6_6001_6280_80FDID)
end
local function _____65BD_52A0_63D0_7C73_8BFA_65AF_795D_798F(caster, target)
    local cfg = _____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E.R
    local hid = jass.GetHandleId(target)
    if _____795D_798F_8868[hid] ~= nil or getBuffRuntime(target, cfg.BuffID) ~= nil then
        _____6E05_7406_795D_798F(target)
    end
    _____795D_798F_8868[hid] = {["剩余次数"] = cfg["刷新次数"]}
    jass.UnitAddAbility(target, _____539F_751F_72B6_6001_6280_80FDID)
    registerManualBuff(
        target,
        cfg.BuffID,
        cfg["持续秒"],
        cfg["刷新次数"],
        {
            sourceUnit = caster,
            sourceName = "圣火神爱尔福林克的祝福",
            stack = cfg["刷新次数"],
            nativeBuffAbilityIds = {_____539F_751F_72B6_6001_6280_80FDID},
            onRemove = ____on_795D_798F_79FB_9664
        }
    )
    do
        local i = 0
        while i < #cfg["特效"] do
            local effect = cfg["特效"][i + 1]
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = effect["模型"],
                X = jass.GetUnitX(target),
                Y = jass.GetUnitY(target),
                Z = effect.Z,
                ["Z轴角度"] = 270,
                ["缩放"] = effect["缩放"],
                ["持续秒"] = cfg["特效持续秒"]
            })
            i = i + 1
        end
    end
end
local function ____on_63D0_7C73_8BFA_65AFR_4E0E_795D_798F_6280_80FD(caster, abilityId)
    if abilityId == ____R_6280_80FDID and jass.GetUnitTypeId(caster) == _____63D0_7C73_8BFA_65AF_5355_4F4DID then
        local target = jass.GetSpellTargetUnit()
        if target == nil or target == 0 then
            return
        end
        _____64AD_653E_63D0_7C73_8BFA_65AF_5355_4F4D_97F3_6548(caster, _____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E.R["全局音效键"])
        _____65BD_52A0_63D0_7C73_8BFA_65AF_795D_798F(caster, target)
        return
    end
    local hid = jass.GetHandleId(caster)
    local record = _____795D_798F_8868[hid]
    local buff = getBuffRuntime(caster, _____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E.R.BuffID)
    if record == nil or buff == nil then
        return
    end
    local level = jass.GetUnitAbilityLevel(caster, abilityId)
    if not (level > 0) or getAbilityManaCost(caster, abilityId, level) > _____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E.R["最大基础魔耗"] then
        return
    end
    YDWESetUnitAbilityStateSafe(caster, abilityId, 1, 0)
    record["剩余次数"] = record["剩余次数"] - 1
    if record["剩余次数"] <= 0 then
        _____6E05_7406_795D_798F(caster)
    else
        buff.stack = record["剩余次数"]
        buff.effect = record["剩余次数"]
    end
end
registerSpellEffectListener(____on_63D0_7C73_8BFA_65AFR_4E0E_795D_798F_6280_80FD)
return ____exports

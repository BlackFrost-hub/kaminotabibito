local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____5237_65B0VF_8868_73B0, registerManualBuff, _____79FB_9664_5355_4F4D_6307_5B9ABuff, ____VF_573ABuffID, ____VF_6B8B_7F3ABuffID, _____88AB_52A8_914D_7F6E
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.22．朱雀院椿.00．配置")
local _____6731_96C0_9662_693F_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿技能配置"]
local _____6731_96C0_9662_693FBuff_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿Buff配置"]
local _____6731_96C0_9662_693F_88AB_52A8_914D_7F6E = ____00_FF0E_914D_7F6E["朱雀院椿被动配置"]
function _____5237_65B0VF_8868_73B0(_____82F1_96C4, _____72B6_6001)
    local _____6B8B_7F3A = _____72B6_6001["VF当前"] <= 0 or _____72B6_6001["VF当前"] < _____88AB_52A8_914D_7F6E["VF上限"] * _____88AB_52A8_914D_7F6E["VF残缺阈值"]
    _____72B6_6001["VF残缺"] = _____6B8B_7F3A
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, ____VF_573ABuffID)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, ____VF_6B8B_7F3ABuffID)
    if _____72B6_6001["VF当前"] > 0 then
        if _____6B8B_7F3A then
            registerManualBuff(
                _____82F1_96C4,
                ____VF_6B8B_7F3ABuffID,
                9999,
                1,
                {stack = 1}
            )
        else
            registerManualBuff(
                _____82F1_96C4,
                ____VF_573ABuffID,
                9999,
                _____72B6_6001["VF当前"],
                {stack = 1}
            )
        end
    end
end
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getGameTime = ____require_result_1.getGameTime
local addDelayedCallback = ____require_result_1.addDelayedCallback
local removeDelayedCallback = ____require_result_1.removeDelayedCallback
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_2.registerDeathListener
local ____require_result_3 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local registerPlayerHeroListener = ____require_result_3.registerPlayerHeroListener
local ____require_result_4 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_4.registerAppliedFinalDamageListener
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____require_result_5["单位存活"]
local ____require_result_6 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_6.registerDamageModifier
local ____require_result_7 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_7["造成技能伤害"]
local ____require_result_8 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_8.registerManualBuff
_____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_8["移除单位指定Buff"]
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6731_96C0_9662_693F_6280_80FD_914D_7F6E["单位类型ID"])
____VF_573ABuffID = _____6731_96C0_9662_693FBuff_914D_7F6E["VF场"]
____VF_6B8B_7F3ABuffID = _____6731_96C0_9662_693FBuff_914D_7F6E["VF残缺"]
local _____53CD_51FB_51C6_5907BuffID = _____6731_96C0_9662_693FBuff_914D_7F6E["反击准备"]
local _____4E00_5200BuffID = _____6731_96C0_9662_693FBuff_914D_7F6E["一刀守势"]
local _____4E8C_5200BuffID = _____6731_96C0_9662_693FBuff_914D_7F6E["二刀攻势"]
local _____51B3_6597BuffID = _____6731_96C0_9662_693FBuff_914D_7F6E["决斗距离"]
_____88AB_52A8_914D_7F6E = _____6731_96C0_9662_693F_88AB_52A8_914D_7F6E
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local GetHandleId = jass.GetHandleId
local _____82F1_96C4_72B6_6001_8868 = {}
local function _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)
    local id = GetHandleId(_____82F1_96C4)
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[id]
    if _____72B6_6001 == nil then
        _____72B6_6001 = {
            ["VF当前"] = _____88AB_52A8_914D_7F6E["VF上限"],
            ["VF残缺"] = false,
            ["反击准备到期"] = 0,
            ["反击准备方向"] = 0,
            ["反击准备来源"] = nil,
            ["姿态"] = "一刀",
            ["决斗距离到期"] = 0,
            ["决斗距离方向"] = 0,
            ["VF恢复冷却到期"] = 0,
            ["姿态锁"] = false,
            ["技能清理表"] = {}
        }
        _____82F1_96C4_72B6_6001_8868[id] = _____72B6_6001
        _____5237_65B0VF_8868_73B0(_____82F1_96C4, _____72B6_6001)
        registerManualBuff(
            _____82F1_96C4,
            _____4E00_5200BuffID,
            9999,
            1,
            {stack = 1}
        )
    end
    return _____72B6_6001
end
--- 是否是朱雀院椿
____exports["是朱雀院椿"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    return jass.GetUnitTypeId(unit) == _____82F1_96C4_5355_4F4D_7C7B_578BID
end
--- 登记技能清理函数（Q/W/E/R/D 模块调用；死亡/场景清理统一执行，幂等）
____exports["登记椿清理"] = function(_____82F1_96C4, _____540D_79F0, _____6E05_7406)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)["技能清理表"][_____540D_79F0] = _____6E05_7406
end
--- 幂等统一清理：死亡/复活重置/重复初始化/场景清理
____exports["清理朱雀院椿状态"] = function(_____82F1_96C4, ______539F_56E0)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local id = GetHandleId(_____82F1_96C4)
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[id]
    if _____72B6_6001 == nil then
        return
    end
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, ____VF_573ABuffID)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, ____VF_6B8B_7F3ABuffID)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____53CD_51FB_51C6_5907BuffID)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____4E00_5200BuffID)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____4E8C_5200BuffID)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____51B3_6597BuffID)
    for key in pairs(_____72B6_6001["技能清理表"]) do
        local _____6E05_7406 = _____72B6_6001["技能清理表"][key]
        if _____6E05_7406 ~= nil then
            _____6E05_7406()
        end
    end
    __TS__Delete(_____82F1_96C4_72B6_6001_8868, id)
end
____exports["获取VF"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return 0
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____82F1_96C4)]
    return _____72B6_6001 ~= nil and _____72B6_6001["VF当前"] or 0
end
--- 初始化/重置 VF 到上限（死亡重置/复活/场景清理后重建状态时调用）
____exports["初始化VF"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local _____72B6_6001 = _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)
    _____72B6_6001["VF当前"] = _____88AB_52A8_914D_7F6E["VF上限"]
    _____72B6_6001["VF残缺"] = false
    _____5237_65B0VF_8868_73B0(_____82F1_96C4, _____72B6_6001)
end
--- 恢复 VF（内部冷却：任何入口都不能靠攻速无限回满）；成功返回 true
____exports["恢复VF"] = function(_____82F1_96C4, _____91CF)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or _____91CF <= 0 then
        return false
    end
    local _____72B6_6001 = _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)
    local _____73B0_5728 = getGameTime()
    if _____73B0_5728 < _____72B6_6001["VF恢复冷却到期"] then
        return false
    end
    _____72B6_6001["VF恢复冷却到期"] = _____73B0_5728 + _____88AB_52A8_914D_7F6E["VF恢复冷却秒"]
    _____72B6_6001["VF当前"] = _____72B6_6001["VF当前"] + _____91CF > _____88AB_52A8_914D_7F6E["VF上限"] and _____88AB_52A8_914D_7F6E["VF上限"] or _____72B6_6001["VF当前"] + _____91CF
    _____5237_65B0VF_8868_73B0(_____82F1_96C4, _____72B6_6001)
    return true
end
--- 扣除 VF（二刀持续消耗等）；返回扣除后的剩余
____exports["扣除VF"] = function(_____82F1_96C4, _____91CF)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or _____91CF <= 0 then
        return 0
    end
    local _____72B6_6001 = _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)
    _____72B6_6001["VF当前"] = _____72B6_6001["VF当前"] - _____91CF < 0 and 0 or _____72B6_6001["VF当前"] - _____91CF
    _____5237_65B0VF_8868_73B0(_____82F1_96C4, _____72B6_6001)
    return _____72B6_6001["VF当前"]
end
local ____VF_4FEE_6539_5668ID = 0
local function _____6CE8_518CVF_5438_6536()
    if ____VF_4FEE_6539_5668ID ~= 0 then
        return
    end
    ____VF_4FEE_6539_5668ID = registerDamageModifier(
        function(context)
            local ____temp_9
            if context ~= nil then
                ____temp_9 = context.target
            else
                ____temp_9 = nil
            end
            local _____5355_4F4D = ____temp_9
            if not ____exports["是朱雀院椿"](_____5355_4F4D) then
                return context.currentDamage
            end
            local _____72B6_6001 = _____53D6_82F1_96C4_72B6_6001(_____5355_4F4D)
            if _____72B6_6001["VF当前"] <= 0 then
                return context.currentDamage
            end
            if context.currentDamage <= 0 then
                return context.currentDamage
            end
            local _____5438_6536 = context.currentDamage > _____72B6_6001["VF当前"] and _____72B6_6001["VF当前"] or context.currentDamage
            _____72B6_6001["VF当前"] = _____72B6_6001["VF当前"] - _____5438_6536
            _____5237_65B0VF_8868_73B0(_____5355_4F4D, _____72B6_6001)
            return context.currentDamage - _____5438_6536
        end,
        40
    )
end
____exports["有反击准备"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return false
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____82F1_96C4)]
    return _____72B6_6001 ~= nil and getGameTime() <= _____72B6_6001["反击准备到期"]
end
--- 创建反击准备（1.2s 窗口；刷新时重置到期；Buff 同步）
____exports["创建反击准备"] = function(_____82F1_96C4, _____65B9_5411, _____6765_6E90)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local _____72B6_6001 = _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)
    _____72B6_6001["反击准备到期"] = getGameTime() + _____88AB_52A8_914D_7F6E["反击准备持续秒"]
    _____72B6_6001["反击准备方向"] = _____65B9_5411
    local ____temp_10
    if _____6765_6E90 ~= nil and _____6765_6E90 ~= 0 then
        ____temp_10 = _____6765_6E90
    else
        ____temp_10 = nil
    end
    _____72B6_6001["反击准备来源"] = ____temp_10
    registerManualBuff(
        _____82F1_96C4,
        _____53CD_51FB_51C6_5907BuffID,
        _____88AB_52A8_914D_7F6E["反击准备持续秒"],
        1,
        {stack = 1}
    )
end
--- 消费反击准备（普攻/Q/E 各最多一次；无或过期返回 null）
____exports["消费反击准备"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return nil
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____82F1_96C4)]
    if _____72B6_6001 == nil then
        return nil
    end
    if getGameTime() > _____72B6_6001["反击准备到期"] then
        return nil
    end
    _____72B6_6001["反击准备到期"] = 0
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____53CD_51FB_51C6_5907BuffID)
    return {["方向"] = _____72B6_6001["反击准备方向"], ["来源"] = _____72B6_6001["反击准备来源"]}
end
____exports["获取姿态"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return "一刀"
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____82F1_96C4)]
    return _____72B6_6001 ~= nil and _____72B6_6001["姿态"] or "一刀"
end
--- 设置姿态（互斥 Buff/特效；切换前由 D 模块校验可切换性）
____exports["设置姿态"] = function(_____82F1_96C4, _____59FF_6001)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local _____72B6_6001 = _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)
    if _____72B6_6001["姿态"] == _____59FF_6001 then
        return
    end
    _____72B6_6001["姿态"] = _____59FF_6001
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____4E00_5200BuffID)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____4E8C_5200BuffID)
    if _____59FF_6001 == "一刀" then
        registerManualBuff(
            _____82F1_96C4,
            _____4E00_5200BuffID,
            9999,
            1,
            {stack = 1}
        )
    else
        registerManualBuff(
            _____82F1_96C4,
            _____4E8C_5200BuffID,
            9999,
            1,
            {stack = 1}
        )
    end
end
--- R 蓄力期间锁定姿态（D 不得中途改写本次 R 分支）
____exports["锁定姿态"] = function(_____82F1_96C4, _____9501_5B9A)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)["姿态锁"] = _____9501_5B9A
end
____exports["姿态是否锁定"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return false
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____82F1_96C4)]
    return _____72B6_6001 ~= nil and _____72B6_6001["姿态锁"]
end
--- 设置决斗距离（默认 2.5s，供 R 读取方向）
____exports["设置决斗距离"] = function(_____82F1_96C4, _____65B9_5411, _____6301_7EED_79D2)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local _____72B6_6001 = _____53D6_82F1_96C4_72B6_6001(_____82F1_96C4)
    _____72B6_6001["决斗距离到期"] = getGameTime() + _____6301_7EED_79D2
    _____72B6_6001["决斗距离方向"] = _____65B9_5411
    registerManualBuff(
        _____82F1_96C4,
        _____51B3_6597BuffID,
        _____6301_7EED_79D2,
        1,
        {stack = 1}
    )
end
____exports["有决斗距离"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return false
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____82F1_96C4)]
    return _____72B6_6001 ~= nil and getGameTime() <= _____72B6_6001["决斗距离到期"]
end
____exports["获取决斗距离方向"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return 0
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____82F1_96C4)]
    return _____72B6_6001 ~= nil and getGameTime() <= _____72B6_6001["决斗距离到期"] and _____72B6_6001["决斗距离方向"] or 0
end
--- 清除决斗距离（R 终式读取方向后消费）
____exports["清除决斗距离"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(_____82F1_96C4)]
    if _____72B6_6001 == nil then
        return
    end
    _____72B6_6001["决斗距离到期"] = 0
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____82F1_96C4, _____51B3_6597BuffID)
end
local function _____5904_7406_693F_666E_653B_53CD_51FB_65A9(target, attacker, applied, snapshot)
    if not ____exports["是朱雀院椿"](attacker) then
        return
    end
    if snapshot == nil then
        return
    end
    if snapshot.isNormalAttack ~= true then
        return
    end
    if snapshot.isWrappedSkillDamage == true then
        return
    end
    if target == nil or target == 0 then
        return
    end
    local _____72B6_6001 = _____82F1_96C4_72B6_6001_8868[GetHandleId(attacker)]
    if _____72B6_6001 == nil then
        return
    end
    if getGameTime() > _____72B6_6001["反击准备到期"] then
        return
    end
    _____72B6_6001["反击准备到期"] = 0
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(attacker, _____53CD_51FB_51C6_5907BuffID)
    local _____8FFD_52A0_4F24_5BB3 = applied * _____88AB_52A8_914D_7F6E["反击斩伤害倍率"]
    _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = attacker,
        ["目标"] = target,
        ["伤害"] = _____8FFD_52A0_4F24_5BB3,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        ["攻击类型"] = ATTACK_TYPE_NORMAL,
        ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = 0,
        ["标签"] = "朱雀院椿-反击斩",
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = false
    })
    if _____72B6_6001["姿态"] == "一刀" then
        ____exports["恢复VF"](attacker, _____88AB_52A8_914D_7F6E["反击斩恢复VF"])
    else
        _____9020_6210_6280_80FD_4F24_5BB3({
            ["来源"] = attacker,
            ["目标"] = target,
            ["伤害"] = applied * _____88AB_52A8_914D_7F6E["二刀反击斩额外倍率"],
            ["伤害类型"] = DAMAGE_TYPE_NORMAL,
            ["攻击类型"] = ATTACK_TYPE_NORMAL,
            ["武器类型"] = WEAPON_TYPE_WHOKNOWS,
            ["来源类型"] = "单位技能",
            ["技能ID"] = 0,
            ["标签"] = "朱雀院椿-反击斩二刀",
            ["伤害形态"] = "单体",
            ["参与技能伤害加成"] = false
        })
    end
end
local _____5DF2_6CE8_518C = false
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____786E_4FDD_6B7B_4EA1_6E05_7406()
    if _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        return
    end
    _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
    registerDeathListener(function(dyingUnit, _killingUnit)
        if dyingUnit == nil or dyingUnit == 0 then
            return
        end
        if ____exports["是朱雀院椿"](dyingUnit) then
            ____exports["清理朱雀院椿状态"](dyingUnit, "英雄死亡")
        end
    end)
end
--- 注册朱雀院椿被动（VF 吸收 + 普攻反击斩 + 死亡清理；幂等）
____exports["注册朱雀院椿被动"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____786E_4FDD_6B7B_4EA1_6E05_7406()
    registerPlayerHeroListener(function(_player, hero)
        if ____exports["是朱雀院椿"](hero) then
            ____exports["初始化VF"](hero)
        end
    end)
    _____6CE8_518CVF_5438_6536()
    registerAppliedFinalDamageListener(_____5904_7406_693F_666E_653B_53CD_51FB_65A9)
end
--- 播放椿施法动作（接收动作槽，索引/持续秒全部配置驱动；0 跳过），持续后恢复 stand；随英雄清理移除恢复回调
____exports["播放椿动作"] = function(_____82F1_96C4, _____69FD)
    local _____52A8_4F5C_7D22_5F15 = _____69FD["索引"]
    local _____6301_7EED_79D2 = _____69FD["持续秒"]
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or _____52A8_4F5C_7D22_5F15 <= 0 then
        return
    end
    jass.SetUnitAnimationByIndex(_____82F1_96C4, _____52A8_4F5C_7D22_5F15)
    if _____6301_7EED_79D2 > 0 then
        local _____6062_590DID = addDelayedCallback(
            _____6301_7EED_79D2 * 1000,
            function()
                if _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
                    jass.SetUnitAnimation(_____82F1_96C4, "stand")
                end
            end
        )
        ____exports["登记椿清理"](
            _____82F1_96C4,
            "椿动作-" .. tostring(_____52A8_4F5C_7D22_5F15),
            function()
                removeDelayedCallback(_____6062_590DID)
            end
        )
    end
end
____exports["朱雀院椿被动模块"] = {["英雄ID"] = _____6731_96C0_9662_693F_6280_80FD_914D_7F6E["单位类型ID"], ["注册"] = ____exports["注册朱雀院椿被动"]}
return ____exports

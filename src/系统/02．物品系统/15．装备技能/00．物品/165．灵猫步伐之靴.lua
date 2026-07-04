local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6709_6548_5B58_6D3B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位有效存活"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["播放单位特效"]
local jass = require("jass.common")
local GetUnitDefaultMoveSpeed = jass.GetUnitDefaultMoveSpeed
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_1.getServerTime
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_2.SGSS_SetState
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_88C5_5907 = ____require_result_3["单位持有装备"]
local _____53D6_88C5_5907_51B7_5374_952E = ____require_result_3["取装备冷却键"]
local _____88C5_5907_51B7_5374_4E2D = ____require_result_3["装备冷却中"]
local _____8FDB_5165_88C5_5907_51B7_5374 = ____require_result_3["进入装备冷却"]
local _____7075_732B_8DC3_6B65_51B7_5374_79D2_6570 = 10
local _____7075_732B_8DC3_6B65_79FB_901F_6BD4_4F8B = 0.3
local _____7075_732B_8DC3_6B65_6301_7EED_79D2_6570 = 2
local _____7075_732B_8DC3_6B65_7279_6548 = "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl"
local _____53E0_52A0_79FB_52A8_901F_5EA6_5C5E_6027ID = 9
local _____7075_732B_4E34_65F6_79FB_901F_79FB_9664_961F_5217 = {}
local _____7075_732B_4E34_65F6_79FB_901FTick_5DF2_542F_52A8 = false
local function _____5904_7406_7075_732B_4E34_65F6_79FB_901F_79FB_9664()
    local now = getServerTime()
    do
        local i = #_____7075_732B_4E34_65F6_79FB_901F_79FB_9664_961F_5217 - 1
        while i >= 0 do
            do
                local _____8BB0_5F55 = _____7075_732B_4E34_65F6_79FB_901F_79FB_9664_961F_5217[i + 1]
                if _____8BB0_5F55 == nil or now < _____8BB0_5F55["到期时间"] then
                    goto __continue4
                end
                SGSS_SetState(_____8BB0_5F55["单位"], _____53E0_52A0_79FB_52A8_901F_5EA6_5C5E_6027ID, -_____8BB0_5F55["移速比例"])
                __TS__ArraySplice(_____7075_732B_4E34_65F6_79FB_901F_79FB_9664_961F_5217, i, 1)
            end
            ::__continue4::
            i = i - 1
        end
    end
end
local function _____786E_4FDD_7075_732B_4E34_65F6_79FB_901FTick()
    if _____7075_732B_4E34_65F6_79FB_901FTick_5DF2_542F_52A8 then
        return
    end
    _____7075_732B_4E34_65F6_79FB_901FTick_5DF2_542F_52A8 = true
    addPeriodicCallback(100, _____5904_7406_7075_732B_4E34_65F6_79FB_901F_79FB_9664)
end
local function _____8BA1_7B97_7075_732B_79FB_901F_589E_91CF(unit, _____79FB_901F_6BD4_4F8B)
    return GetUnitDefaultMoveSpeed(unit) * _____79FB_901F_6BD4_4F8B
end
local function _____65BD_52A0_7075_732B_4E34_65F6_79FB_901F(unit, _____79FB_901F_6BD4_4F8B, _____6301_7EED_79D2_6570)
    if unit == nil or unit == 0 or _____79FB_901F_6BD4_4F8B == 0 or not (_____6301_7EED_79D2_6570 > 0) then
        return
    end
    local _____79FB_901F_589E_91CF = _____8BA1_7B97_7075_732B_79FB_901F_589E_91CF(unit, _____79FB_901F_6BD4_4F8B)
    SGSS_SetState(unit, _____53E0_52A0_79FB_52A8_901F_5EA6_5C5E_6027ID, _____79FB_901F_589E_91CF)
    _____7075_732B_4E34_65F6_79FB_901F_79FB_9664_961F_5217[#_____7075_732B_4E34_65F6_79FB_901F_79FB_9664_961F_5217 + 1] = {
        ["单位"] = unit,
        ["移速比例"] = _____79FB_901F_589E_91CF,
        ["到期时间"] = getServerTime() + _____6301_7EED_79D2_6570 * 1000
    }
    _____786E_4FDD_7075_732B_4E34_65F6_79FB_901FTick()
end
local function ____on_7075_732B_6B65_4F10_4E4B_9774_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    if not (applied > 0) then
        return
    end
    if not _____5355_4F4D_6709_6548_5B58_6D3B(target) then
        return
    end
    if not _____5355_4F4D_6301_6709_88C5_5907(target, "灵猫步伐之靴") then
        return
    end
    local key = _____53D6_88C5_5907_51B7_5374_952E(target, "灵猫步伐之靴:灵猫跃步", "米亚战利品")
    if _____88C5_5907_51B7_5374_4E2D(key) then
        return
    end
    _____8FDB_5165_88C5_5907_51B7_5374(key, _____7075_732B_8DC3_6B65_51B7_5374_79D2_6570)
    _____65BD_52A0_7075_732B_4E34_65F6_79FB_901F(target, _____7075_732B_8DC3_6B65_79FB_901F_6BD4_4F8B, _____7075_732B_8DC3_6B65_6301_7EED_79D2_6570)
    _____64AD_653E_5355_4F4D_7279_6548(target, _____7075_732B_8DC3_6B65_7279_6548, "origin", 1)
end
registerAppliedFinalDamageListener(____on_7075_732B_6B65_4F10_4E4B_9774_6700_7EC8_4F24_5BB3)
return ____exports

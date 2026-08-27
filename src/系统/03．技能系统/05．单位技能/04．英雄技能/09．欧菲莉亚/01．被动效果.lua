--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.09．欧菲莉亚.00．配置")
local _____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["欧菲莉亚单位技能配置"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.04．英雄复活系统")
local _____76F4_63A5_590D_6D3B_73A9_5BB6_82F1_96C4 = ____require_result_1["直接复活玩家英雄"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_2.getServerTime
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local _____6B27_83F2_8389_4E9A_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local _____6B27_83F2_8389_4E9AR_6280_80FDID = stringToFourCCSafe(_____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E["R技能ID"])
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetUnitStateJapi = japi.GetUnitState
local _____88AB_52A8_590D_6D3B_51B7_5374_5230_671F_8868 = {}
local function _____8BBE_7F6E_6B27_83F2_8389_4E9A_88AB_52A8_590D_6D3B_751F_547D(hero)
    local maxLife = GetUnitStateJapi(hero, jass.UNIT_STATE_MAX_LIFE)
    if not (maxLife > 0) then
        return
    end
    jass:SetUnitState(hero, jass.UNIT_STATE_LIFE, maxLife * _____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.R["被动复活生命百分比"] * 0.01)
end
local function _____5904_7406_6B27_83F2_8389_4E9A_6B7B_4EA1_88AB_52A8(dyingUnit, _killingUnit)
    if dyingUnit == nil or dyingUnit == 0 or GetUnitTypeId(dyingUnit) ~= _____6B27_83F2_8389_4E9A_5355_4F4D_7C7B_578BID then
        return
    end
    local level = GetUnitAbilityLevel(dyingUnit, _____6B27_83F2_8389_4E9AR_6280_80FDID)
    if not (level > 0) then
        return
    end
    local handleId = GetHandleId(dyingUnit)
    local now = getServerTime()
    local cooldownUntil = _____88AB_52A8_590D_6D3B_51B7_5374_5230_671F_8868[handleId] or 0
    if now < cooldownUntil then
        return
    end
    if not _____76F4_63A5_590D_6D3B_73A9_5BB6_82F1_96C4(dyingUnit, true) then
        return
    end
    _____8BBE_7F6E_6B27_83F2_8389_4E9A_88AB_52A8_590D_6D3B_751F_547D(dyingUnit)
    _____88AB_52A8_590D_6D3B_51B7_5374_5230_671F_8868[handleId] = now + (_____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.R["被动冷却基础秒"] - _____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.R["被动冷却每级减少秒"] * level) * 1000
end
registerDeathListener(_____5904_7406_6B27_83F2_8389_4E9A_6B7B_4EA1_88AB_52A8)
return ____exports

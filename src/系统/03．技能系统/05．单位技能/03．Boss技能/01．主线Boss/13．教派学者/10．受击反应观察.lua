--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.00．配置")
local _____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["教派学者单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.02．数值与表现配置")
local _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["教派学者技能配置"]
local _____6559_6D3E_5B66_8005_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["教派学者音效配置"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_1.getServerTime
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____require_result_3["播放Boss坐标音效"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local GetUnitState = jass.GetUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____6559_6D3E_5B66_8005_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____53D7_51FB_97F3_6548_51B7_5374_6BEB_79D2 = 3000
local _____6559_6D3E_5B66_8005_53D7_51FB_97F3_6548_4E0A_6B21_64AD_653E_6BEB_79D2 = 0
local _____6559_6D3E_5B66_8005_53D7_51FB_53CD_5E94_89C2_5BDF_5DF2_6CE8_518C = false
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and not IsUnitType(unit, UNIT_TYPE_DEAD) and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
local function ____on_6559_6D3E_5B66_8005_53D7_5230_6700_7EC8_4F24_5BB3(target, _attacker, applied, _snapshot)
    if not (applied > 0) or not _____5355_4F4D_5B58_6D3B(target) or GetUnitTypeId(target) ~= _____6559_6D3E_5B66_8005_5355_4F4D_7C7B_578BID then
        return
    end
    local _____5F53_524D_6BEB_79D2 = getServerTime()
    if _____5F53_524D_6BEB_79D2 - _____6559_6D3E_5B66_8005_53D7_51FB_97F3_6548_4E0A_6B21_64AD_653E_6BEB_79D2 < _____53D7_51FB_97F3_6548_51B7_5374_6BEB_79D2 then
        return
    end
    _____6559_6D3E_5B66_8005_53D7_51FB_97F3_6548_4E0A_6B21_64AD_653E_6BEB_79D2 = _____5F53_524D_6BEB_79D2
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____6559_6D3E_5B66_8005_97F3_6548_914D_7F6E["受击"],
        GetUnitX(target),
        GetUnitY(target),
        _____6559_6D3E_5B66_8005_6280_80FD_914D_7F6E["公共施法"]["音效裁断距离"]
    )
end
____exports["注册教派学者受击反应观察"] = function()
    if _____6559_6D3E_5B66_8005_53D7_51FB_53CD_5E94_89C2_5BDF_5DF2_6CE8_518C then
        return
    end
    _____6559_6D3E_5B66_8005_53D7_51FB_53CD_5E94_89C2_5BDF_5DF2_6CE8_518C = true
    registerAppliedFinalDamageListener(____on_6559_6D3E_5B66_8005_53D7_5230_6700_7EC8_4F24_5BB3)
end
return ____exports

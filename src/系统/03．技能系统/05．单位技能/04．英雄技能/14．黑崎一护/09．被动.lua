--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．黑崎一护.00．配置")
local _____9ED1_5D0E_4E00_62A4_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["黑崎一护技能配置"]
local ____01_FF0E_72B6_6001_8868 = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．黑崎一护.01．状态表")
local _____9ED1_5D0E_4E00_62A4_662F_5426_534D_89E3 = ____01_FF0E_72B6_6001_8868["黑崎一护是否卍解"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.04．伤害系统.01．伤害事件")
local registerDamageCallback = ____require_result_0.registerDamageCallback
local ____require_result_1 = require("系统.03．技能系统.01．技能冷却.05．技能冷却查询")
local _____8BFB_53D6_6280_80FD_5269_4F59_51B7_5374 = ____require_result_1["读取技能剩余冷却"]
local ____require_result_2 = require("平台扩展API动作")
local _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4 = ____require_result_2["技能_设置技能冷却时间"]
local GetUnitTypeId = jass.GetUnitTypeId
local IsUnitAlly = jass.IsUnitAlly
local IsUnitOwnedByPlayer = jass.IsUnitOwnedByPlayer
local GetOwningPlayer = jass.GetOwningPlayer
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local stringToFourCC = stringToFourCCSafe
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local _____914D_7F6E = _____9ED1_5D0E_4E00_62A4_6280_80FD_914D_7F6E
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
local ____Q_7C7B_578BID = stringToFourCC(_____914D_7F6E.Q["技能ID"])
local function _____5904_7406_534D_89E3_666E_653B_7F29Q(unit, _damage, damageType, _fromDotTickBatch, source, isNormalAttack)
    if isNormalAttack ~= true then
        return
    end
    if damageType ~= DAMAGE_TYPE_NORMAL then
        return
    end
    if source == nil or source == 0 then
        return
    end
    if GetUnitTypeId(source) ~= _____82F1_96C4_5355_4F4D_7C7B_578BID then
        return
    end
    local attackerPlayer = GetOwningPlayer(source)
    if IsUnitAlly(unit, attackerPlayer) or IsUnitOwnedByPlayer(unit, attackerPlayer) then
        return
    end
    if not _____9ED1_5D0E_4E00_62A4_662F_5426_534D_89E3(source) then
        return
    end
    local _____5269_4F59 = _____8BFB_53D6_6280_80FD_5269_4F59_51B7_5374(source, ____Q_7C7B_578BID)
    if _____5269_4F59 >= _____914D_7F6E["被动"]["Q冷却剩余阈值秒"] then
        local _____65B0_51B7_5374 = _____5269_4F59 - _____914D_7F6E["被动"]["Q冷却缩减秒"]
        _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(source, ____Q_7C7B_578BID, _____65B0_51B7_5374 > 0 and _____65B0_51B7_5374 or 0, _____914D_7F6E.Q["物编冷却秒"])
    end
end
local _____5DF2_6CE8_518C = false
____exports["注册黑崎一护被动"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    registerDamageCallback(_____5904_7406_534D_89E3_666E_653B_7F29Q)
end
____exports["注册黑崎一护被动"]()
return ____exports

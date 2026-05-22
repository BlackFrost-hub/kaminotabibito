--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8F6C_56DB_4F4DID = ____require_result_0["转四位ID"]
local _____5355_4F4D_62E5_6709_539F_751FBuff = ____require_result_0["单位拥有原生Buff"]
local _____8BFB_53D6_5355_4F4D_7D2F_8BA1_5B9E_6570 = ____require_result_0["读取单位累计实数"]
local _____5199_5165_5355_4F4D_7D2F_8BA1_5B9E_6570 = ____require_result_0["写入单位累计实数"]
local _____6CE8_518C_6307_5B9A_5355_4F4D_66B4_51FB_7387_4FEE_6B63 = ____require_result_0["注册指定单位暴击率修正"]
local _____6CE8_518C_6307_5B9A_5355_4F4D_66B4_51FB_540E_76D1_542C = ____require_result_0["注册指定单位暴击后监听"]
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_1.getRegisteredPlayerHero
local ____require_result_2 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．沙漠食人魔.00．配置")
local _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E = ____require_result_2["沙漠食人魔单位技能配置"]
local _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID = _____8F6C_56DB_4F4DID(_____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____6C99_6F20_98DF_4EBA_9B54_89E6_53D1BuffID = _____8F6C_56DB_4F4DID(_____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["触发BuffID"])
local function _____76EE_6807_662F_5DF2_6CE8_518C_73A9_5BB6_82F1_96C4(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local owner = jass.GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return false
    end
    return getRegisteredPlayerHero(owner) == unit
end
local function _____6C99_6F20_98DF_4EBA_9B54_66B4_51FB_7387_4FEE_6B63(context)
    if not _____5355_4F4D_62E5_6709_539F_751FBuff(context.attacker, _____6C99_6F20_98DF_4EBA_9B54_89E6_53D1BuffID) then
        return context["暴击率"]
    end
    if not _____76EE_6807_662F_5DF2_6CE8_518C_73A9_5BB6_82F1_96C4(context.target) then
        return context["暴击率"]
    end
    local stack = _____8BFB_53D6_5355_4F4D_7D2F_8BA1_5B9E_6570(context.target, _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["累计键"])
    if not (stack > 0) then
        return context["暴击率"]
    end
    return context["暴击率"] + stack * _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["暴击加成系数"]
end
local function _____6C99_6F20_98DF_4EBA_9B54_66B4_51FB_540E_5904_7406(record, _applied, _snapshot)
    if not _____5355_4F4D_62E5_6709_539F_751FBuff(record.attacker, _____6C99_6F20_98DF_4EBA_9B54_89E6_53D1BuffID) then
        return
    end
    if not _____76EE_6807_662F_5DF2_6CE8_518C_73A9_5BB6_82F1_96C4(record.target) then
        return
    end
    _____5199_5165_5355_4F4D_7D2F_8BA1_5B9E_6570(record.target, _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["累计键"], 0)
    _____5199_5165_5355_4F4D_7D2F_8BA1_5B9E_6570(record.target, _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["清空键"], 0)
end
____exports["注册沙漠食人魔被动效果"] = function()
    _____6CE8_518C_6307_5B9A_5355_4F4D_66B4_51FB_7387_4FEE_6B63(_____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID, _____6C99_6F20_98DF_4EBA_9B54_66B4_51FB_7387_4FEE_6B63)
    _____6CE8_518C_6307_5B9A_5355_4F4D_66B4_51FB_540E_76D1_542C(_____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID, _____6C99_6F20_98DF_4EBA_9B54_66B4_51FB_540E_5904_7406)
end
____exports["注册沙漠食人魔被动效果"]()
return ____exports

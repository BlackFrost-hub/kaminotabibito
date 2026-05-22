--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8F6C_56DB_4F4DID = ____require_result_0["转四位ID"]
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.00．公共.05．原生Buff必定暴击修正")
local _____6CE8_518C_76EE_6807_5E26_539F_751FBuff_65F6_5FC5_5B9A_66B4_51FB = ____require_result_1["注册目标带原生Buff时必定暴击"]
local ____require_result_2 = require("系统.03．技能系统.05．单位技能.05．异界Boss.01．神罗战士.00．配置")
local _____795E_7F57_6218_58EB_5355_4F4D_6280_80FD_914D_7F6E = ____require_result_2["神罗战士单位技能配置"]
local _____795E_7F57_6218_58EB_5355_4F4D_7C7B_578BID = _____8F6C_56DB_4F4DID(_____795E_7F57_6218_58EB_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____795E_7F57_6218_58EB_7729_6655BuffID = _____8F6C_56DB_4F4DID(_____795E_7F57_6218_58EB_5355_4F4D_6280_80FD_914D_7F6E["眩晕BuffID"])
____exports["注册神罗战士被动效果"] = function()
    _____6CE8_518C_76EE_6807_5E26_539F_751FBuff_65F6_5FC5_5B9A_66B4_51FB(_____795E_7F57_6218_58EB_5355_4F4D_7C7B_578BID, _____795E_7F57_6218_58EB_7729_6655BuffID)
end
____exports["注册神罗战士被动效果"]()
return ____exports

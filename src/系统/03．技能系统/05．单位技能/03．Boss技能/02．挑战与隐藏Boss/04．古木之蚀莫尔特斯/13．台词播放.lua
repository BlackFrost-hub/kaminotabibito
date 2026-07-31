--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.04．古木之蚀莫尔特斯.00．配置")
local _____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["莫尔特斯单位技能配置"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.12．Boss台词广播")
local _____64AD_653EBoss_53F0_8BCD = ____require_result_0["播放Boss台词"]
local ____require_result_1 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_1["广播单位提示"]
____exports["播放莫尔特斯台词"] = function(boss, _____7C7B_578B, index)
    _____64AD_653EBoss_53F0_8BCD(boss, _____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E, _____7C7B_578B, index)
    local _____5E7F_64AD_63D0_793A = _____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["广播提示"][_____7C7B_578B]
    if _____5E7F_64AD_63D0_793A ~= nil and _____5E7F_64AD_63D0_793A ~= "" then
        _____5E7F_64AD_5355_4F4D_63D0_793A(boss, _____5E7F_64AD_63D0_793A, _____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["广播持续时间Ms"])
    end
end
return ____exports

--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.00．配置")
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["巴尔扎罗斯单位技能配置"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.12．Boss台词广播")
local _____64AD_653EBoss_53F0_8BCD = ____require_result_0["播放Boss台词"]
____exports["播放巴尔扎罗斯台词"] = function(boss, _____7C7B_578B, index)
    _____64AD_653EBoss_53F0_8BCD(boss, _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E, _____7C7B_578B, index)
end
____exports["播放格鲁姆台词"] = function(grum, _____7C7B_578B, index)
    _____64AD_653EBoss_53F0_8BCD(grum, _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E["护卫"]["格鲁姆"], _____7C7B_578B, index)
end
____exports["播放塞拉台词"] = function(sera, _____7C7B_578B, index)
    _____64AD_653EBoss_53F0_8BCD(sera, _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E["护卫"]["塞拉"], _____7C7B_578B, index)
end
return ____exports

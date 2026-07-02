--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.00．配置")
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["巴尔扎罗斯单位技能配置"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.12．Boss台词广播")
local _____64AD_653EBoss_53F0_8BCD_5E7F_64AD = ____require_result_0["播放Boss台词广播"]
____exports["播放巴尔扎罗斯台词"] = function(boss, _____7C7B_578B, index)
    _____64AD_653EBoss_53F0_8BCD_5E7F_64AD(
        boss,
        _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E["台词"],
        _____7C7B_578B,
        _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E["广播持续时间Ms"],
        index
    )
end
return ____exports

--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.00．配置")
local _____5361_745F_62C9_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["卡瑟拉单位技能配置"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.12．Boss台词广播")
local _____64AD_653EBoss_53F0_8BCD = ____require_result_0["播放Boss台词"]
____exports["播放卡瑟拉台词"] = function(boss, _____7C7B_578B, index)
    _____64AD_653EBoss_53F0_8BCD(boss, _____5361_745F_62C9_5355_4F4D_6280_80FD_914D_7F6E, _____7C7B_578B, index)
end
return ____exports

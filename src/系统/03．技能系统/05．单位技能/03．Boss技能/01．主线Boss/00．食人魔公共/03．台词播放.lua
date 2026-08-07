--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.00．食人魔公共.00．配置")
local _____98DF_4EBA_9B54_516C_5171_53F0_8BCD_8868 = ____00_FF0E_914D_7F6E["食人魔公共台词表"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.12．Boss台词广播")
local _____53D6Boss_53F0_8BCD_6587_672C = ____require_result_0["取Boss台词文本"]
local ____require_result_1 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_1["广播单位提示"]
____exports["播放食人魔公共台词"] = function(boss, _____7C7B_578B, _____540E_7F00_6587_672C)
    local _____6587_672C = _____53D6Boss_53F0_8BCD_6587_672C(_____98DF_4EBA_9B54_516C_5171_53F0_8BCD_8868["台词"], _____7C7B_578B)
    if _____6587_672C == nil or _____6587_672C == "" then
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(boss, _____6587_672C .. (_____540E_7F00_6587_672C or ""), _____98DF_4EBA_9B54_516C_5171_53F0_8BCD_8868["广播持续时间Ms"])
end
return ____exports

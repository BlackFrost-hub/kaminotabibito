--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_653B_51FB_6548_679C_5DE5_5177 = require("系统.02．物品系统.15．装备技能.08．攻击效果.00．公共.01．攻击效果工具")
local _____653B_51FB_8005_7C7B_578B_6EE1_8DB3 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["攻击者类型满足"]
local _____8DDD_79BB_6EE1_8DB3_9650_5236 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["距离满足限制"]
local _____53D6_653B_51FB_529B = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["取攻击力"]
local _____653B_51FB_6548_679C_9020_6210_4F24_5BB3 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["攻击效果造成伤害"]
local ____08_FF0E_88C5_5907_89E6_53D1_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.index")
local _____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F = ____08_FF0E_88C5_5907_89E6_53D1_6A21_677F["注册最终伤害触发模板"]
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口")
local SFB_setCurse = ____require_result_0.SFB_setCurse
local _____88C5_5907_540D = "|cffcc99ff黑暗猎人手套|r"
local _____89E6_53D1_6982_7387 = 0.15
local _____51B7_5374_79D2_6570 = 8
local _____6700_5927_653B_51FB_8DDD_79BB = 200
local _____653B_51FB_529B_7CFB_6570 = 2
local _____8BC5_5492_6301_7EED_79D2 = 1.5
_____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F({
    ["名称"] = "黑暗猎人手套",
    ["装备名"] = _____88C5_5907_540D,
    ["持有者"] = "攻击者",
    ["伤害过滤"] = "纯普攻",
    ["概率"] = _____89E6_53D1_6982_7387,
    ["冷却秒数"] = _____51B7_5374_79D2_6570,
    ["自定义过滤"] = function(event)
        local snapshot = event["伤害快照"]
        if snapshot == nil or snapshot.isTrueDamage == true then
            return false
        end
        if not _____653B_51FB_8005_7C7B_578B_6EE1_8DB3(event["攻击者"], "近战") then
            return false
        end
        return _____8DDD_79BB_6EE1_8DB3_9650_5236(event["攻击者"], event["目标"], nil, _____6700_5927_653B_51FB_8DDD_79BB)
    end,
    ["on触发"] = function(event)
        SFB_setCurse(event["攻击者"], event["目标"], _____8BC5_5492_6301_7EED_79D2)
        _____653B_51FB_6548_679C_9020_6210_4F24_5BB3(
            event["攻击者"],
            event["目标"],
            _____53D6_653B_51FB_529B(event["攻击者"]) * _____653B_51FB_529B_7CFB_6570,
            "暗影"
        )
    end
})
return ____exports

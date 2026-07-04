--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_653B_51FB_6548_679C_5DE5_5177 = require("系统.02．物品系统.15．装备技能.08．攻击效果.00．公共.01．攻击效果工具")
local _____653B_51FB_8005_7C7B_578B_6EE1_8DB3 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["攻击者类型满足"]
local _____8DDD_79BB_6EE1_8DB3_9650_5236 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["距离满足限制"]
local _____53D6_653B_51FB_529B = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["取攻击力"]
local _____653B_51FB_6548_679C_9020_6210_4F24_5BB3 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["攻击效果造成伤害"]
local _____83B7_53D6_654C_65B9_8303_56F4_5355_4F4D = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["获取敌方范围单位"]
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____8BFB_53D6_73A9_5BB6_66B4_51FB_4F24_5BB3 = ____20_FF0E_7269_54C1_8F85_52A9["读取玩家暴击伤害"]
local _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C = ____20_FF0E_7269_54C1_8F85_52A9["施加临时属性效果"]
local ____09_FF0E_88C5_5907_901A_7528_673A_5236 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.index")
local _____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F = ____09_FF0E_88C5_5907_901A_7528_673A_5236["注册最终伤害触发模板"]
local _____88C5_5907_540D = "狂暴熔刃"
local _____89E6_53D1_6982_7387 = 0.1
local _____51B7_5374_79D2_6570 = 2
local _____6700_5927_653B_51FB_8DDD_79BB = 200
local _____653B_901F_589E_52A0 = 300
local _____6301_7EED_6BEB_79D2 = 2000
local _____8303_56F4 = 500
local _____653B_51FB_529B_500D_7387 = 2
local function _____8BA1_7B97_66B4_51FB_4F24_5BB3(attacker)
    return _____53D6_653B_51FB_529B(attacker) * _____653B_51FB_529B_500D_7387 * (1 + _____8BFB_53D6_73A9_5BB6_66B4_51FB_4F24_5BB3(attacker))
end
local function _____65BD_52A0_72C2_66B4_7194_5203_653B_901F(attacker)
    _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C(attacker, _____6301_7EED_6BEB_79D2, {{["类型"] = "攻速", ["数值"] = _____653B_901F_589E_52A0}})
end
_____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F({
    ["名称"] = "狂暴熔刃",
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
        _____65BD_52A0_72C2_66B4_7194_5203_653B_901F(event["攻击者"])
        local damage = _____8BA1_7B97_66B4_51FB_4F24_5BB3(event["攻击者"])
        local enemies = _____83B7_53D6_654C_65B9_8303_56F4_5355_4F4D(event["攻击者"], event["目标"], _____8303_56F4, true)
        do
            local i = 0
            while i < #enemies do
                _____653B_51FB_6548_679C_9020_6210_4F24_5BB3(event["攻击者"], enemies[i + 1], damage, "物理")
                i = i + 1
            end
        end
    end
})
return ____exports

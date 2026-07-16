--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____08_FF0E_88C5_5907_89E6_53D1_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.index")
local _____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F = ____08_FF0E_88C5_5907_89E6_53D1_6A21_677F["注册最终伤害触发模板"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____662FAOE_6280_80FD_4F24_5BB3 = ____07_FF0E_88C5_5907_8F85_52A9["是AOE技能伤害"]
local _____53D6_653B_51FB_529B = ____07_FF0E_88C5_5907_8F85_52A9["取攻击力"]
local _____53D6_8303_56F4_654C_4EBA = ____07_FF0E_88C5_5907_8F85_52A9["取范围敌人"]
local _____9020_6210_88C5_5907_4F24_5BB3 = ____07_FF0E_88C5_5907_8F85_52A9["造成装备伤害"]
local _____64AD_653E_70B9_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放点特效"]
local _____56DBBoss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["四Boss战利品装备名"]
local _____56DBBoss_88C5_5907_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["四Boss装备特效"]
local _____88C5_5907_4F24_5BB3_7C7B_578B = ____07_FF0E_88C5_5907_8F85_52A9["装备伤害类型"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
_____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F({
    ["名称"] = "英灵送葬法典",
    ["装备名"] = _____56DBBoss_6218_5229_54C1_88C5_5907_540D["英灵送葬法典"],
    ["伤害过滤"] = "技能",
    ["冷却秒数"] = 10,
    ["自定义过滤"] = function(e) return _____662FAOE_6280_80FD_4F24_5BB3(e["伤害快照"]) end,
    ["on触发"] = function(e)
        local s = e["持有者"]
        local t = e["目标"]
        local x = jass.GetUnitX(t)
        local y = jass.GetUnitY(t)
        _____64AD_653E_70B9_7279_6548(
            _____56DBBoss_88C5_5907_7279_6548["英灵陨星预警"],
            x,
            y,
            1,
            0.55
        )
        addDelayedCallback(
            900,
            function()
                _____64AD_653E_70B9_7279_6548(
                    _____56DBBoss_88C5_5907_7279_6548["英灵陨星"],
                    x,
                    y,
                    1,
                    0.65
                )
                _____64AD_653E_70B9_7279_6548(
                    _____56DBBoss_88C5_5907_7279_6548["英灵陨星落地"],
                    x,
                    y,
                    1,
                    0.5
                )
                local us = _____53D6_8303_56F4_654C_4EBA(s, t, 300)
                local d = _____53D6_653B_51FB_529B(s) * 0.65 + 350
                do
                    local i = 0
                    while i < #us do
                        _____9020_6210_88C5_5907_4F24_5BB3(
                            s,
                            us[i + 1],
                            d,
                            _____88C5_5907_4F24_5BB3_7C7B_578B["魔法"],
                            true,
                            nil,
                            {["装备技能类型"] = "装备被动", ["标签"] = "英灵送葬", ["伤害形态"] = "AOE"}
                        )
                        i = i + 1
                    end
                end
            end
        )
    end
})
return ____exports

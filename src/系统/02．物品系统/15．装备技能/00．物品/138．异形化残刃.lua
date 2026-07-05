--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____9020_6210_88C5_5907_4F24_5BB3 = ____07_FF0E_88C5_5907_8F85_52A9["造成装备伤害"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____76D1_542C_88C5_5907_4E22_5F03_6E05_7406 = ____07_FF0E_88C5_5907_8F85_52A9["监听装备丢弃清理"]
local _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["第二章后段Boss战利品装备名"]
local _____88C5_5907_4F24_5BB3_7C7B_578B = ____07_FF0E_88C5_5907_8F85_52A9["装备伤害类型"]
local ____08_FF0E_88C5_5907_89E6_53D1_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.index")
local _____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F = ____08_FF0E_88C5_5907_89E6_53D1_6A21_677F["注册最终伤害触发模板"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.09．非伤害生命移除")
local _____6309_6BD4_4F8B_79FB_9664_5F53_524D_751F_547D = ____require_result_0["按比例移除当前生命"]
local _____5F02_5F62_5316_6B8B_5203_5185_7F6ECD_79D2 = 5
local _____5F02_5F62_5316_6B8B_5203_6D3E_751F_4F24_5BB3_4E2D = false
local function _____9020_6210_5F02_5F62_5316_6B8B_5203_989D_5916_4F24_5BB3(source, target, amount)
    if not (amount > 0) then
        return
    end
    _____5F02_5F62_5316_6B8B_5203_6D3E_751F_4F24_5BB3_4E2D = true
    _____9020_6210_88C5_5907_4F24_5BB3(
        source,
        target,
        amount,
        _____88C5_5907_4F24_5BB3_7C7B_578B["暗影"],
        false,
        nil,
        {["伤害形态"] = "单体"}
    )
    _____5F02_5F62_5316_6B8B_5203_6D3E_751F_4F24_5BB3_4E2D = false
end
local function _____5F02_5F62_5316_6B8B_5203_8FC7_6EE4()
    return _____5F02_5F62_5316_6B8B_5203_6D3E_751F_4F24_5BB3_4E2D ~= true
end
local function ____on_5F02_5F62_5316_6B8B_5203_89E6_53D1(event)
    local attacker = event["攻击者"]
    local target = event["目标"]
    _____6309_6BD4_4F8B_79FB_9664_5F53_524D_751F_547D(attacker, 0.05, true)
    _____64AD_653E_5355_4F4D_7279_6548("Common\\Effect\\Element\\Dark\\ShadowHitBurst.mdx", target, "origin", 0.8)
    _____9020_6210_5F02_5F62_5316_6B8B_5203_989D_5916_4F24_5BB3(attacker, target, event["本次伤害"] * 0.3)
end
local _____5F02_5F62_5316_6B8B_5203_89E6_53D1 = _____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F({
    ["名称"] = "异形化残刃",
    ["装备名"] = _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D["异形化残刃"],
    ["伤害过滤"] = "技能",
    ["次数阈值"] = 5,
    ["冷却秒数"] = _____5F02_5F62_5316_6B8B_5203_5185_7F6ECD_79D2,
    ["冷却前缀"] = "第二章后段Boss战利品",
    ["要求双方存活"] = false,
    ["自定义过滤"] = _____5F02_5F62_5316_6B8B_5203_8FC7_6EE4,
    ["on触发"] = ____on_5F02_5F62_5316_6B8B_5203_89E6_53D1
})
_____76D1_542C_88C5_5907_4E22_5F03_6E05_7406(
    _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D["异形化残刃"],
    function(unit)
        _____5F02_5F62_5316_6B8B_5203_89E6_53D1["清空"](unit)
    end
)
return ____exports

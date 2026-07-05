--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1 = ____07_FF0E_88C5_5907_8F85_52A9["单位持有第二章后段Boss战利品"]
local _____662F_6280_80FD_4F24_5BB3 = ____07_FF0E_88C5_5907_8F85_52A9["是技能伤害"]
local _____53D6_8303_56F4_654C_4EBA = ____07_FF0E_88C5_5907_8F85_52A9["取范围敌人"]
local _____9020_6210_88C5_5907_4F24_5BB3 = ____07_FF0E_88C5_5907_8F85_52A9["造成装备伤害"]
local _____64AD_653E_70B9_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放点特效"]
local _____53D6_5355_4F4DX = ____07_FF0E_88C5_5907_8F85_52A9["取单位X"]
local _____53D6_5355_4F4DY = ____07_FF0E_88C5_5907_8F85_52A9["取单位Y"]
local _____53D6_653B_51FB_529B = ____07_FF0E_88C5_5907_8F85_52A9["取攻击力"]
local _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["第二章后段Boss战利品装备名"]
local _____88C5_5907_4F24_5BB3_7C7B_578B = ____07_FF0E_88C5_5907_8F85_52A9["装备伤害类型"]
local _____88C5_5907_5C0F_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["装备小特效"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.10．窗口承伤次数触发")
local _____521B_5EFA_7A97_53E3_627F_4F24_6B21_6570_89E6_53D1_5668 = ____require_result_0["创建窗口承伤次数触发器"]
local function ____on_514B_6797_59C6_5FB7_98CE_7EB9_6CD5_6756_89E6_53D1(event)
    local target = event["单位"]
    local attacker = event["攻击者"]
    _____64AD_653E_70B9_7279_6548(
        _____88C5_5907_5C0F_7279_6548["小风爆"],
        _____53D6_5355_4F4DX(target),
        _____53D6_5355_4F4DY(target),
        0.9
    )
    local enemies = _____53D6_8303_56F4_654C_4EBA(attacker, target, 260)
    do
        local i = 0
        while i < #enemies do
            _____9020_6210_88C5_5907_4F24_5BB3(
                attacker,
                enemies[i + 1],
                _____53D6_653B_51FB_529B(attacker) * 0.4,
                _____88C5_5907_4F24_5BB3_7C7B_578B["风"],
                false,
                nil,
                {["伤害形态"] = "AOE"}
            )
            i = i + 1
        end
    end
end
local function _____8FC7_6EE4_514B_6797_59C6_5FB7_98CE_7EB9_6CD5_6756_4F24_5BB3(event)
    return _____662F_6280_80FD_4F24_5BB3(event["伤害快照"]) and _____5355_4F4D_6301_6709_7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1(event["攻击者"], _____7B2C_4E8C_7AE0_540E_6BB5Boss_6218_5229_54C1_88C5_5907_540D["克林姆德风纹法杖"])
end
_____521B_5EFA_7A97_53E3_627F_4F24_6B21_6570_89E6_53D1_5668({
    ["名称"] = "克林姆德风纹法杖",
    ["窗口秒"] = 6,
    ["次数阈值"] = 3,
    ["内置CD秒"] = 6,
    ["过滤伤害"] = _____8FC7_6EE4_514B_6797_59C6_5FB7_98CE_7EB9_6CD5_6756_4F24_5BB3,
    ["on触发"] = ____on_514B_6797_59C6_5FB7_98CE_7EB9_6CD5_6756_89E6_53D1
})
return ____exports

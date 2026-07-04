--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____5355_4F4D_662F_82F1_96C4 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["单位是英雄"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["播放单位特效"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.08．潜行状态模板")
local _____65BD_52A0_6F5C_884C_72B6_6001 = ____require_result_0["施加潜行状态"]
local _____5F71_9AA8_6F5C_884C_70DF_96FE_7279_6548 = "Common\\Effect\\Element\\Dark\\ShadowStealthSmoke.mdx"
local function ____on_5F71_9AA8_62AB_98CE_6F5C_884C_5F00_59CB(_____72B6_6001)
    _____64AD_653E_5355_4F4D_7279_6548(_____5F71_9AA8_6F5C_884C_70DF_96FE_7279_6548, _____72B6_6001["单位"], "origin", 1.2)
end
____exports["处理影骨披风使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["影骨披风"]) then
        return
    end
    local unit = ctx["施法单位"]
    if not _____5355_4F4D_662F_82F1_96C4(unit) then
        return
    end
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["影骨披风"]
    _____65BD_52A0_6F5C_884C_72B6_6001({
        ["单位"] = unit,
        ["来源单位"] = unit,
        ["名称"] = "影骨披风",
        ["持续秒数"] = cfg["持续秒数"],
        ["基础移速百分比"] = cfg["基础移速百分比"],
        ["破隐伤害倍率"] = cfg["破隐伤害倍率"],
        ["on开始"] = ____on_5F71_9AA8_62AB_98CE_6F5C_884C_5F00_59CB
    })
end
return ____exports

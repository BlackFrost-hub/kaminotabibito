--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____64AD_653E_70B9_7279_6548 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["播放点特效"]
local _____53D6_5355_4F4DX = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位Y"]
local _____9020_6210_5F3A_5316_4F24_5BB3 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["造成强化伤害"]
local ____00_FF0E_8BA1_6570_5468_671F_6267_884C = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.10．周期执行模板.00．计数周期执行")
local _____542F_52A8_8BA1_6570_5468_671F_6267_884C = ____00_FF0E_8BA1_6570_5468_671F_6267_884C["启动计数周期执行"]
local ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.19．临时属性效果")
local _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C = ____19_FF0E_4E34_65F6_5C5E_6027_6548_679C["施加临时属性效果"]
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____00_FF0EBuff_7CFB_7EDF.registerManualBuff
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local function _____6267_884C_72C2_66B4_6811_679D_81EA_4F24Tick(unit)
    _____9020_6210_5F3A_5316_4F24_5BB3(unit, unit, _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["狂暴树枝"]["自伤"])
end
____exports["处理狂暴树枝使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["狂暴树枝"]) then
        return
    end
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["狂暴树枝"]
    local unit = ctx["施法单位"]
    _____64AD_653E_70B9_7279_6548(
        "Abilities\\Spells\\Items\\AIda\\AIdaCaster.mdl",
        _____53D6_5355_4F4DX(unit),
        _____53D6_5355_4F4DY(unit)
    )
    _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C(unit, cfg["持续毫秒"], {{["类型"] = "攻速", ["数值"] = cfg["攻速"]}})
    registerManualBuff(
        unit,
        _____5E38_89C4BuffID["狂暴树枝_狂暴"],
        cfg["持续毫秒"] / 1000,
        cfg["攻速显示"],
        {sourceUnit = unit, effectSourceName = "狂暴树枝", effectSourceType = "装备", effectValue2 = cfg["自伤"]}
    )
    _____542F_52A8_8BA1_6570_5468_671F_6267_884C({
        ["间隔毫秒"] = cfg["自伤间隔毫秒"],
        ["最大次数"] = cfg["持续毫秒"] / cfg["自伤间隔毫秒"],
        ["on周期"] = function()
            _____6267_884C_72C2_66B4_6811_679D_81EA_4F24Tick(unit)
        end
    })
end
return ____exports

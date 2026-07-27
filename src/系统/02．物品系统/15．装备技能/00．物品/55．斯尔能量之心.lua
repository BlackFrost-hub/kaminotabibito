--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____83B7_53D6_7269_54C1_6B21_6570 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["获取物品次数"]
local _____8BBE_7F6E_7269_54C1_6B21_6570 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["设置物品次数"]
local _____8BFB_53D6_5355_4F4D_5C5E_6027 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["读取单位属性"]
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C = ____20_FF0E_7269_54C1_8F85_52A9["施加临时属性效果"]
local _____5EF6_8FDF_6267_884C = ____20_FF0E_7269_54C1_8F85_52A9["延迟执行"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____20_FF0E_7269_54C1_8F85_52A9["播放单位特效"]
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____00_FF0EBuff_7CFB_7EDF.registerManualBuff
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local _____65AF_5C14_80FD_91CF_4E4B_5FC3_4E34_65F6_4F24_5BB3_5C5E_6027_540D = "wp55斯尔能量之心伤害加成"
____exports["处理斯尔能量之心使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["斯尔能量之心"]) then
        return
    end
    local unit = ctx["施法单位"]
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["斯尔能量之心"]
    local _____4F7F_7528_540E_5C42_6570 = _____83B7_53D6_7269_54C1_6B21_6570(unit, _____7269_54C1_4F7F_7528_88C5_5907ID["斯尔能量之心"])
    if _____4F7F_7528_540E_5C42_6570 < cfg["触发层数"] then
        _____5EF6_8FDF_6267_884C(
            0,
            function()
                _____8BBE_7F6E_7269_54C1_6B21_6570(unit, _____7269_54C1_4F7F_7528_88C5_5907ID["斯尔能量之心"], _____4F7F_7528_540E_5C42_6570 + 1)
            end
        )
        return
    end
    _____5EF6_8FDF_6267_884C(
        0,
        function()
            _____8BBE_7F6E_7269_54C1_6B21_6570(unit, _____7269_54C1_4F7F_7528_88C5_5907ID["斯尔能量之心"], 1)
        end
    )
    _____64AD_653E_5355_4F4D_7279_6548("war3mapImported\\ArcaneBurstOnlyPurple.mdx", unit, "origin", 1)
    _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C(unit, cfg["持续毫秒"], {{["类型"] = "单位属性", ["属性名"] = _____65AF_5C14_80FD_91CF_4E4B_5FC3_4E34_65F6_4F24_5BB3_5C5E_6027_540D, ["数值"] = cfg["伤害提升"]}})
    registerManualBuff(
        unit,
        _____5E38_89C4BuffID["斯尔能量之心_能量爆发"],
        cfg["持续毫秒"] / 1000,
        cfg["伤害提升"] * 100,
        {sourceUnit = unit, effectSourceName = "斯尔能量之心", effectSourceType = "装备"}
    )
end
____exports["处理斯尔能量之心伤害修正"] = function(context)
    local bonus = _____8BFB_53D6_5355_4F4D_5C5E_6027(context.attacker, _____65AF_5C14_80FD_91CF_4E4B_5FC3_4E34_65F6_4F24_5BB3_5C5E_6027_540D)
    if not (bonus > 0) then
        return context.currentDamage
    end
    return context.currentDamage * (1 + bonus)
end
return ____exports

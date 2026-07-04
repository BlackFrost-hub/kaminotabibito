--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.00．伤害事件配置表")
local _____4F24_5BB3_4E8B_4EF6_88C5_5907ID = ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868["伤害事件装备ID"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local _____53D6_5F53_524D_751F_547D = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取当前生命"]
local _____53D6_6700_5927_751F_547D = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["取最大生命"]
local _____6267_884C_7269_54C1_6CBB_7597 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["执行物品治疗"]
local ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.07．获得物品.00．公共.00．获得物品配置表")
local _____83B7_5F97_7269_54C1_88C5_5907ID = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["获得物品装备ID"]
local _____8C7A_72FC_76AE_7532_914D_7F6E = ____00_FF0E_83B7_5F97_7269_54C1_914D_7F6E_8868["豺狼皮甲配置"]
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____521B_5EFA_5355_4F4D_52A8_6001_52A0_6210_540C_6B65_5668 = ____20_FF0E_7269_54C1_8F85_52A9["创建单位动态加成同步器"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果")
local _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C = ____require_result_0["注册持有型周期效果"]
local ____require_result_1 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_1["调整玩家属性"]
local _____8C7A_72FC_76AE_7532_52A8_6001_5C5E_6027 = _____521B_5EFA_5355_4F4D_52A8_6001_52A0_6210_540C_6B65_5668(function(unit, mode, delta)
    _____8C03_6574_73A9_5BB6_5C5E_6027(unit, mode, delta)
end)
local function _____540C_6B65_8C7A_72FC_76AE_7532_72B6_6001(unit, currentCount)
    local shouldUseRegen = _____53D6_5F53_524D_751F_547D(unit) >= _____53D6_6700_5927_751F_547D(unit) * _____8C7A_72FC_76AE_7532_914D_7F6E["高生命阈值"]
    local nextMode = shouldUseRegen and "生命恢复" or "伤害减少%"
    local nextValue = (nextMode == "生命恢复" and _____8C7A_72FC_76AE_7532_914D_7F6E["生命恢复增加"] or _____8C7A_72FC_76AE_7532_914D_7F6E["伤害减少增加"]) * currentCount
    _____8C7A_72FC_76AE_7532_52A8_6001_5C5E_6027["同步"](unit, nextMode, nextValue)
end
local function _____6E05_7406_8C7A_72FC_76AE_7532_72B6_6001(unit)
    _____8C7A_72FC_76AE_7532_52A8_6001_5C5E_6027["清理"](unit)
end
local function ____on_8C7A_72FC_76AE_7532_5468_671F(unit, currentCount)
    if currentCount <= 0 then
        _____6E05_7406_8C7A_72FC_76AE_7532_72B6_6001(unit)
        return
    end
    _____540C_6B65_8C7A_72FC_76AE_7532_72B6_6001(unit, currentCount)
end
local function ____on_8C7A_72FC_76AE_7532_4E22_5F03(unit)
    _____6E05_7406_8C7A_72FC_76AE_7532_72B6_6001(unit)
end
local function _____521D_59CB_5316_8C7A_72FC_76AE_7532_6301_6709_6548_679C()
    if _____83B7_5F97_7269_54C1_88C5_5907ID["豺狼皮甲"] == 0 then
        return
    end
    _____6CE8_518C_6301_6709_578B_5468_671F_6548_679C({["物品类型ID"] = _____83B7_5F97_7269_54C1_88C5_5907ID["豺狼皮甲"], ["间隔毫秒"] = _____8C7A_72FC_76AE_7532_914D_7F6E["检查间隔毫秒"], ["周期回调"] = ____on_8C7A_72FC_76AE_7532_5468_671F, ["丢弃回调"] = ____on_8C7A_72FC_76AE_7532_4E22_5F03})
end
____exports["处理豺狼皮甲受伤"] = function(ctx)
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(ctx.target, _____4F24_5BB3_4E8B_4EF6_88C5_5907ID["豺狼皮甲"]) then
        return
    end
    if _____53D6_5F53_524D_751F_547D(ctx.target) >= _____53D6_6700_5927_751F_547D(ctx.target) * 0.7 then
        return
    end
    _____6267_884C_7269_54C1_6CBB_7597(ctx.target, ctx.target, ctx.applied * 0.1, nil)
end
_____521D_59CB_5316_8C7A_72FC_76AE_7532_6301_6709_6548_679C()
return ____exports

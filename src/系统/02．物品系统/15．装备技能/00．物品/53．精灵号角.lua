--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____83B7_53D6_8303_56F4_53CB_519B = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["获取范围友军"]
local _____53D6_5355_4F4DX = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位Y"]
local _____53D6_5355_4F4D_653B_51FB = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位攻击"]
local _____53D6_53E5_67C4ID = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取句柄ID"]
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C = ____20_FF0E_7269_54C1_8F85_52A9["施加临时属性效果"]
local ____16_FF0E_5C5E_6027_4F4D_79FB_4E0E_6307_4EE4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____8C03_6574_72B6_6001ID_5C5E_6027 = ____16_FF0E_5C5E_6027_4F4D_79FB_4E0E_6307_4EE4["调整状态ID属性"]
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____00_FF0EBuff_7CFB_7EDF.registerManualBuff
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.23．光环.02．数值Buff范围光环")
local _____6CE8_518C_6570_503CBuff_8303_56F4_5149_73AF = ____require_result_0["注册数值Buff范围光环"]
local _____653B_51FB_5C5E_6027ID = 1
local _____62A4_7532_5C5E_6027ID = 2
local _____7CBE_7075_53F7_89D2_5149_73AF_5468_671F_6BEB_79D2 = 500
local _____7CBE_7075_53F7_89D2Buff_6301_7EED_79D2 = 1
local _____5DF2_521D_59CB_5316_7CBE_7075_53F7_89D2_5149_73AF = false
local function _____8BA1_7B97_7CBE_7075_53F7_89D2_5149_73AF_653B_51FB(target, _____5C42_6570, _____5DF2_52A0_653B_51FB)
    local baseAttack = _____53D6_5355_4F4D_653B_51FB(target) - _____5DF2_52A0_653B_51FB
    if not (baseAttack > 0) or _____5C42_6570 <= 0 then
        return 0
    end
    return baseAttack * _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["号角"]["精灵号角光环攻击比例"] * _____5C42_6570
end
local function _____8BA1_7B97_7CBE_7075_53F7_89D2_5149_73AF_62A4_7532(_target, _____5C42_6570)
    return _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["号角"]["精灵号角光环护甲"] * _____5C42_6570
end
local function _____5E94_7528_7CBE_7075_53F7_89D2_653B_51FB_5DEE_503C(target, delta)
    _____8C03_6574_72B6_6001ID_5C5E_6027(target, _____653B_51FB_5C5E_6027ID, delta)
end
local function _____5E94_7528_7CBE_7075_53F7_89D2_62A4_7532_5DEE_503C(target, delta)
    _____8C03_6574_72B6_6001ID_5C5E_6027(target, _____62A4_7532_5C5E_6027ID, delta)
end
local function _____53D6_7CBE_7075_53F7_89D2_5149_73AFBuff_9644_52A0(_target, _____5C42_6570, holder)
    return {sourceUnit = holder, effectSourceName = "精灵号角", effectSourceType = "装备", effectValue2 = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["号角"]["精灵号角光环护甲"] * _____5C42_6570}
end
____exports["初始化精灵号角光环"] = function()
    if _____5DF2_521D_59CB_5316_7CBE_7075_53F7_89D2_5149_73AF then
        return
    end
    _____5DF2_521D_59CB_5316_7CBE_7075_53F7_89D2_5149_73AF = true
    if _____7269_54C1_4F7F_7528_88C5_5907ID["精灵号角"] == 0 then
        return
    end
    _____6CE8_518C_6570_503CBuff_8303_56F4_5149_73AF({
        ["状态ID"] = "精灵号角光环",
        ["物品类型ID"] = _____7269_54C1_4F7F_7528_88C5_5907ID["精灵号角"],
        ["间隔毫秒"] = _____7CBE_7075_53F7_89D2_5149_73AF_5468_671F_6BEB_79D2,
        ["半径"] = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["号角"]["半径"],
        ["目标类型"] = "友军含自己",
        ["数值效果列表"] = {{key = "攻击", ["计算总值"] = _____8BA1_7B97_7CBE_7075_53F7_89D2_5149_73AF_653B_51FB, ["应用差值"] = _____5E94_7528_7CBE_7075_53F7_89D2_653B_51FB_5DEE_503C}, {key = "护甲", ["计算总值"] = _____8BA1_7B97_7CBE_7075_53F7_89D2_5149_73AF_62A4_7532, ["应用差值"] = _____5E94_7528_7CBE_7075_53F7_89D2_62A4_7532_5DEE_503C}},
        Buff = {
            BuffID = _____5E38_89C4BuffID["精灵号角_号角光环"],
            ["持续秒"] = _____7CBE_7075_53F7_89D2Buff_6301_7EED_79D2,
            ["取显示值"] = function(_target, _____5C42_6570)
                return 10 * _____5C42_6570
            end,
            ["取附加参数"] = _____53D6_7CBE_7075_53F7_89D2_5149_73AFBuff_9644_52A0
        }
    })
end
____exports["处理精灵号角使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["精灵号角"]) then
        return
    end
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["号角"]
    local unit = ctx["施法单位"]
    local allies = _____83B7_53D6_8303_56F4_53CB_519B(
        unit,
        _____53D6_5355_4F4DX(unit),
        _____53D6_5355_4F4DY(unit),
        cfg["半径"]
    )
    local count = #allies
    if count <= 0 then
        return
    end
    local selfExtraAttack = cfg["精灵号角每单位攻击"] * count
    do
        local i = 0
        while i < #allies do
            local target = allies[i + 1]
            local activeAttack = _____53D6_5355_4F4D_653B_51FB(target) * cfg["精灵号角主动攻击比例"]
            local extraAttack = _____53D6_53E5_67C4ID(target) == _____53D6_53E5_67C4ID(unit) and selfExtraAttack or 0
            _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C(target, cfg["持续毫秒"], {{["类型"] = "攻击", ["数值"] = activeAttack + extraAttack}})
            registerManualBuff(
                target,
                _____5E38_89C4BuffID["精灵号角_王之号角"],
                cfg["持续毫秒"] / 1000,
                15,
                {sourceUnit = unit, effectSourceName = "精灵号角", effectSourceType = "装备", effectValue2 = extraAttack}
            )
            i = i + 1
        end
    end
end
____exports["初始化精灵号角光环"]()
return ____exports

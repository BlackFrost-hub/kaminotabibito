--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____83B7_53D6_8303_56F4_654C_4EBA = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["获取范围敌人"]
local _____53D6_5355_4F4DX = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位Y"]
local _____53D6_5355_4F4D_653B_51FB = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取单位攻击"]
local _____5355_4F4D_662F_82F1_96C4 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["单位是英雄"]
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C = ____20_FF0E_7269_54C1_8F85_52A9["施加临时属性效果"]
local ____16_FF0E_5C5E_6027_4F4D_79FB_4E0E_6307_4EE4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____8C03_6574_72B6_6001ID_5C5E_6027 = ____16_FF0E_5C5E_6027_4F4D_79FB_4E0E_6307_4EE4["调整状态ID属性"]
local ____24_FF0E_53E5_67C4_4E0A_4E0B_6587_6258_7BA1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.24．句柄上下文托管")
local _____521B_5EFA_53E5_67C4_4E0A_4E0B_6587_6258_7BA1_5668 = ____24_FF0E_53E5_67C4_4E0A_4E0B_6587_6258_7BA1["创建句柄上下文托管器"]
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____00_FF0EBuff_7CFB_7EDF.registerManualBuff
local getBuffRuntime = ____00_FF0EBuff_7CFB_7EDF.getBuffRuntime
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
local _____65BD_52A0_6050_60E7 = ____require_result_0["施加恐惧"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.23．光环.01．范围光环")
local _____6CE8_518C_6301_6709_578B_8303_56F4_5149_73AF = ____require_result_1["注册持有型范围光环"]
local _____653B_51FB_5C5E_6027ID = 1
local _____6076_9B54_94C3_94DB_5149_73AF_5468_671F_6BEB_79D2 = 500
local _____6076_9B54_94C3_94DB_5149_73AFBuff_6301_7EED_79D2 = 1
local _____6076_9B54_94C3_94DB_5149_73AF_6258_7BA1_5668 = _____521B_5EFA_53E5_67C4_4E0A_4E0B_6587_6258_7BA1_5668("恶魔铃铛光环")
local _____5DF2_521D_59CB_5316_6076_9B54_94C3_94DB_5149_73AF = false
local function _____8BA1_7B97_6076_9B54_94C3_94DB_5149_73AF_653B_51FB_964D_4F4E(target, _____5DF2_964D_653B_51FB, _____5C42_6570)
    local baseAttack = _____53D6_5355_4F4D_653B_51FB(target) + _____5DF2_964D_653B_51FB
    if not (baseAttack > 0) or _____5C42_6570 <= 0 then
        return 0
    end
    return baseAttack * _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶魔铃铛"]["光环攻击降低比例"] * _____5C42_6570
end
local function _____540C_6B65_6076_9B54_94C3_94DB_5149_73AF_5C5E_6027(target, _____5C42_6570)
    local old = _____6076_9B54_94C3_94DB_5149_73AF_6258_7BA1_5668["读取"](target)
    local oldAttack = old and old["已降攻击"] or 0
    local nextAttack = _____8BA1_7B97_6076_9B54_94C3_94DB_5149_73AF_653B_51FB_964D_4F4E(target, oldAttack, _____5C42_6570)
    local deltaAttack = oldAttack - nextAttack
    if deltaAttack ~= 0 then
        _____8C03_6574_72B6_6001ID_5C5E_6027(target, _____653B_51FB_5C5E_6027ID, deltaAttack)
    end
    _____6076_9B54_94C3_94DB_5149_73AF_6258_7BA1_5668["写入"](target, {["层数"] = _____5C42_6570, ["已降攻击"] = nextAttack})
end
local function _____5237_65B0_6076_9B54_94C3_94DB_653B_51FB_964D_4F4EBuff(target, _____653B_51FB_964D_4F4E, _____6301_7EED_79D2, _____6765_6E90_540D_79F0)
    if not (_____653B_51FB_964D_4F4E > 0) or _____6301_7EED_79D2 <= 0 then
        return
    end
    local old = getBuffRuntime(target, _____5E38_89C4BuffID["攻击力降低"])
    if old ~= nil and old.sourceName ~= _____6765_6E90_540D_79F0 and old.effect > _____653B_51FB_964D_4F4E then
        return
    end
    registerManualBuff(
        target,
        _____5E38_89C4BuffID["攻击力降低"],
        _____6301_7EED_79D2,
        _____653B_51FB_964D_4F4E,
        {sourceName = _____6765_6E90_540D_79F0}
    )
end
local function _____5237_65B0_6076_9B54_94C3_94DB_5149_73AFBuff(target)
    local ctx = _____6076_9B54_94C3_94DB_5149_73AF_6258_7BA1_5668["读取"](target)
    if ctx == nil or ctx["层数"] <= 0 then
        return
    end
    _____5237_65B0_6076_9B54_94C3_94DB_653B_51FB_964D_4F4EBuff(target, ctx["已降攻击"], _____6076_9B54_94C3_94DB_5149_73AFBuff_6301_7EED_79D2, "恶魔铃铛光环")
end
local function _____5E94_7528_6076_9B54_94C3_94DB_5149_73AF(target, _holder, currentCount)
    local count = currentCount <= 0 and 1 or currentCount
    local old = _____6076_9B54_94C3_94DB_5149_73AF_6258_7BA1_5668["读取"](target)
    _____540C_6B65_6076_9B54_94C3_94DB_5149_73AF_5C5E_6027(target, (old and old["层数"] or 0) + count)
    _____5237_65B0_6076_9B54_94C3_94DB_5149_73AFBuff(target)
end
local function _____540C_6B65_6076_9B54_94C3_94DB_5149_73AF(target, _holder, _currentCount)
    local old = _____6076_9B54_94C3_94DB_5149_73AF_6258_7BA1_5668["读取"](target)
    if old == nil or old["层数"] <= 0 then
        return
    end
    _____540C_6B65_6076_9B54_94C3_94DB_5149_73AF_5C5E_6027(target, old["层数"])
    _____5237_65B0_6076_9B54_94C3_94DB_5149_73AFBuff(target)
end
local function _____79FB_9664_6076_9B54_94C3_94DB_5149_73AF(target, _holder, currentCount)
    local count = currentCount <= 0 and 1 or currentCount
    local old = _____6076_9B54_94C3_94DB_5149_73AF_6258_7BA1_5668["读取"](target)
    local next = (old and old["层数"] or 0) - count
    if next > 0 then
        _____540C_6B65_6076_9B54_94C3_94DB_5149_73AF_5C5E_6027(target, next)
        _____5237_65B0_6076_9B54_94C3_94DB_5149_73AFBuff(target)
        return
    end
    if old ~= nil and old["已降攻击"] ~= 0 then
        _____8C03_6574_72B6_6001ID_5C5E_6027(target, _____653B_51FB_5C5E_6027ID, old["已降攻击"])
    end
    _____6076_9B54_94C3_94DB_5149_73AF_6258_7BA1_5668["清空"](target)
end
____exports["初始化恶魔铃铛光环"] = function()
    if _____5DF2_521D_59CB_5316_6076_9B54_94C3_94DB_5149_73AF then
        return
    end
    _____5DF2_521D_59CB_5316_6076_9B54_94C3_94DB_5149_73AF = true
    if _____7269_54C1_4F7F_7528_88C5_5907ID["恶魔铃铛"] == 0 then
        return
    end
    _____6CE8_518C_6301_6709_578B_8303_56F4_5149_73AF({
        ["物品类型ID"] = _____7269_54C1_4F7F_7528_88C5_5907ID["恶魔铃铛"],
        ["间隔毫秒"] = _____6076_9B54_94C3_94DB_5149_73AF_5468_671F_6BEB_79D2,
        ["半径"] = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶魔铃铛"]["光环半径"],
        ["目标类型"] = "敌人",
        ["应用目标效果"] = _____5E94_7528_6076_9B54_94C3_94DB_5149_73AF,
        ["同步目标效果"] = _____540C_6B65_6076_9B54_94C3_94DB_5149_73AF,
        ["移除目标效果"] = _____79FB_9664_6076_9B54_94C3_94DB_5149_73AF
    })
end
____exports["处理恶魔铃铛使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["恶魔铃铛"]) then
        return
    end
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["恶魔铃铛"]
    local unit = ctx["施法单位"]
    local enemies = _____83B7_53D6_8303_56F4_654C_4EBA(
        unit,
        _____53D6_5355_4F4DX(unit),
        _____53D6_5355_4F4DY(unit),
        cfg["半径"]
    )
    for ____, enemy in ipairs(enemies) do
        local fearTime = _____5355_4F4D_662F_82F1_96C4(enemy) and cfg["恐惧英雄"] or cfg["恐惧普通"]
        _____65BD_52A0_6050_60E7(unit, enemy, {["持续时间"] = fearTime, ["模式"] = "逃离施法者"})
        local attack = _____53D6_5355_4F4D_653B_51FB(enemy) * cfg["攻击降低比例"]
        _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C(enemy, cfg["持续毫秒"], {{["类型"] = "攻击", ["数值"] = -attack}})
        _____5237_65B0_6076_9B54_94C3_94DB_653B_51FB_964D_4F4EBuff(enemy, attack, cfg["持续毫秒"] / 1000, "恶魔铃铛")
    end
end
____exports["初始化恶魔铃铛光环"]()
return ____exports

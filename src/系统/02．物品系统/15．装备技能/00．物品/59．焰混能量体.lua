--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____521B_5EFA_5355_4F4D_4E34_65F6_5C5E_6027_6548_679C_6258_7BA1_5668 = ____20_FF0E_7269_54C1_8F85_52A9["创建单位临时属性效果托管器"]
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听")
local _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03 = ____require_result_0["监听指定物品获取丢弃"]
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_1["移除单位指定Buff"]
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_2.YDUserDataSetSafe
local _____7130_6DF7_80FD_91CF_4F53_6548_679C_6258_7BA1_5668 = _____521B_5EFA_5355_4F4D_4E34_65F6_5C5E_6027_6548_679C_6258_7BA1_5668()
local _____5DF2_521D_59CB_5316_7130_6DF7_80FD_91CF_4F53_88AB_52A8 = false
local function _____6E05_9664_7130_6DF7_80FD_91CF_4F53(unit)
    _____7130_6DF7_80FD_91CF_4F53_6548_679C_6258_7BA1_5668["清除"](unit)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, _____5E38_89C4BuffID["焰混能量体_混焰"])
end
local function _____8BBE_7F6E_7130_6DF7_80FD_91CF_4F53_65E0_89C6_9B54_6297(unit, enabled)
    if unit == nil or unit == 0 then
        return
    end
    YDUserDataSetSafe(
        "unit",
        unit,
        "无视魔抗",
        "boolean",
        enabled
    )
end
local function ____on_83B7_5F97_7130_6DF7_80FD_91CF_4F53(unit)
    _____8BBE_7F6E_7130_6DF7_80FD_91CF_4F53_65E0_89C6_9B54_6297(unit, true)
end
local function ____on_4E22_5F03_7130_6DF7_80FD_91CF_4F53(unit, _item, currentCount)
    if currentCount <= 0 then
        _____8BBE_7F6E_7130_6DF7_80FD_91CF_4F53_65E0_89C6_9B54_6297(unit, false)
    end
end
____exports["处理焰混能量体使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["焰混能量体"]) then
        return
    end
    local unit = ctx["施法单位"]
    _____6E05_9664_7130_6DF7_80FD_91CF_4F53(unit)
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["焰混能量体"]
    _____7130_6DF7_80FD_91CF_4F53_6548_679C_6258_7BA1_5668["施加"](
        unit,
        cfg["持续毫秒"],
        {{["类型"] = "攻速", ["数值"] = cfg["攻速"]}},
        {
            ["次数"] = cfg["普攻次数"],
            ["on清除"] = function(u)
                _____79FB_9664_5355_4F4D_6307_5B9ABuff(u, _____5E38_89C4BuffID["焰混能量体_混焰"])
            end
        }
    )
    registerManualBuff(
        unit,
        _____5E38_89C4BuffID["焰混能量体_混焰"],
        cfg["持续毫秒"] / 1000,
        cfg["攻速显示"],
        {sourceUnit = unit, effectSourceName = "焰混能量体", effectSourceType = "装备", effectValue2 = cfg["普攻次数"]}
    )
end
____exports["处理焰混能量体伤害"] = function(_target, attacker, _applied, snapshot)
    if snapshot == nil or snapshot.isNormalAttack ~= true then
        return
    end
    _____7130_6DF7_80FD_91CF_4F53_6548_679C_6258_7BA1_5668["消耗次数"](attacker, 1)
end
____exports["初始化焰混能量体被动"] = function()
    if _____5DF2_521D_59CB_5316_7130_6DF7_80FD_91CF_4F53_88AB_52A8 then
        return
    end
    _____5DF2_521D_59CB_5316_7130_6DF7_80FD_91CF_4F53_88AB_52A8 = true
    _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03(_____7269_54C1_4F7F_7528_88C5_5907ID["焰混能量体"], ____on_83B7_5F97_7130_6DF7_80FD_91CF_4F53, ____on_4E22_5F03_7130_6DF7_80FD_91CF_4F53)
end
return ____exports

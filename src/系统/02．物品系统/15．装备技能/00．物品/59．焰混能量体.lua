local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____53D6_53E5_67C4ID = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["取句柄ID"]
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C = ____20_FF0E_7269_54C1_8F85_52A9["施加临时属性效果"]
local _____6FC0_6D3B_8868 = {}
local function _____6E05_9664_7130_6DF7_80FD_91CF_4F53(unit)
    local id = _____53D6_53E5_67C4ID(unit)
    if id == 0 then
        return
    end
    local _____5B9E_4F8B = _____6FC0_6D3B_8868[id]
    if _____5B9E_4F8B == nil then
        return
    end
    __TS__Delete(_____6FC0_6D3B_8868, id)
    _____5B9E_4F8B["清除"]()
end
____exports["处理焰混能量体使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["焰混能量体"]) then
        return
    end
    local unit = ctx["施法单位"]
    local id = _____53D6_53E5_67C4ID(unit)
    if id == 0 then
        return
    end
    _____6E05_9664_7130_6DF7_80FD_91CF_4F53(unit)
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["焰混能量体"]
    local _____5B9E_4F8B = _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C(
        unit,
        cfg["持续毫秒"],
        {{["类型"] = "攻速", ["数值"] = cfg["攻速"]}},
        {
            ["次数"] = cfg["普攻次数"],
            ["on清除"] = function()
                __TS__Delete(_____6FC0_6D3B_8868, id)
            end
        }
    )
    if _____5B9E_4F8B["是否激活"]() then
        _____6FC0_6D3B_8868[id] = _____5B9E_4F8B
    end
end
____exports["处理焰混能量体伤害"] = function(_target, attacker, _applied, snapshot)
    if snapshot == nil or snapshot.isNormalAttack ~= true then
        return
    end
    local id = _____53D6_53E5_67C4ID(attacker)
    if id == 0 then
        return
    end
    local _____5B9E_4F8B = _____6FC0_6D3B_8868[id]
    if _____5B9E_4F8B == nil or not _____5B9E_4F8B["是否激活"]() then
        return
    end
    _____5B9E_4F8B["消耗次数"](1)
end
return ____exports

--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.00．伤害事件配置表")
local _____4F24_5BB3_4E8B_4EF6_88C5_5907ID = ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868["伤害事件装备ID"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local _____6267_884C_7269_54C1_6CBB_7597 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["执行物品治疗"]
local ____09_FF0E_88C5_5907_901A_7528_673A_5236 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.index")
local _____521B_5EFA_5355_4F4D_7A97_53E3_7D2F_8BA1_503C = ____09_FF0E_88C5_5907_901A_7528_673A_5236["创建单位窗口累计值"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____53D6_88C5_5907_51B7_5374_952E = ____07_FF0E_88C5_5907_8F85_52A9["取装备冷却键"]
local _____88C5_5907_51B7_5374_4E2D = ____07_FF0E_88C5_5907_8F85_52A9["装备冷却中"]
local _____8FDB_5165_88C5_5907_51B7_5374 = ____07_FF0E_88C5_5907_8F85_52A9["进入装备冷却"]
local _____7075_77F3_6CBB_7597_7279_6548_8DEF_5F84 = "Abilities\\Spells\\Items\\AIhe\\AIheTarget.mdl"
local _____7075_77F3_89E6_53D1_9608_503C = 300
local _____7075_77F3_6CBB_7597_91CF = 300
local _____7075_77F3_51B7_5374_79D2_6570 = 3
local _____7075_77F3_7D2F_8BA1 = _____521B_5EFA_5355_4F4D_7A97_53E3_7D2F_8BA1_503C("灵石累计承伤", 3)
____exports["处理灵石受伤"] = function(ctx)
    local _____6301_6709_7075_77F3 = _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(ctx.target, _____4F24_5BB3_4E8B_4EF6_88C5_5907ID["灵石"])
    if not _____6301_6709_7075_77F3 then
        return
    end
    local _____51B7_5374_952E = _____53D6_88C5_5907_51B7_5374_952E(ctx.target, "灵石", "伤害事件装备")
    local _____51B7_5374_4E2D = _____88C5_5907_51B7_5374_4E2D(_____51B7_5374_952E)
    if _____51B7_5374_4E2D then
        return
    end
    local _____7269_7406_4F24_5BB3 = ctx.snapshot ~= nil and ctx.snapshot.isPhysicalDamage == true
    if not _____7269_7406_4F24_5BB3 then
        return
    end
    local _____7D2F_8BA1_4F24_5BB3 = _____7075_77F3_7D2F_8BA1["增加"](_____7075_77F3_7D2F_8BA1, ctx.target, ctx.applied)
    if _____7D2F_8BA1_4F24_5BB3 < _____7075_77F3_89E6_53D1_9608_503C then
        return
    end
    _____7075_77F3_7D2F_8BA1["清空"](_____7075_77F3_7D2F_8BA1, ctx.target)
    _____8FDB_5165_88C5_5907_51B7_5374(_____51B7_5374_952E, _____7075_77F3_51B7_5374_79D2_6570)
    _____6267_884C_7269_54C1_6CBB_7597(
        ctx.target,
        ctx.target,
        _____7075_77F3_6CBB_7597_91CF,
        _____7075_77F3_6CBB_7597_7279_6548_8DEF_5F84,
        0,
        nil,
        true
    )
end
return ____exports

local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.00．伤害事件配置表")
local _____4F24_5BB3_4E8B_4EF6_88C5_5907ID = ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868["伤害事件装备ID"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local _____6267_884C_7269_54C1_6CBB_7597 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["执行物品治疗"]
local ____02_FF0E_4F24_5BB3_4E8B_4EF6_72B6_6001 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.02．伤害事件状态")
local _____5355_4F4D_51B7_5374_4E2D = ____02_FF0E_4F24_5BB3_4E8B_4EF6_72B6_6001["单位冷却中"]
local _____8BBE_7F6E_5355_4F4D_51B7_5374 = ____02_FF0E_4F24_5BB3_4E8B_4EF6_72B6_6001["设置单位冷却"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local _____7075_77F3_7D2F_8BA1 = {}
local _____7075_77F3_6CBB_7597_7279_6548_8DEF_5F84 = "Abilities\\Spells\\Items\\AIhe\\AIheTarget.mdl"
local _____7075_77F3_7D2F_8BA1_7A97_53E3_6BEB_79D2 = 3000
local _____7075_77F3_89E6_53D1_9608_503C = 300
local _____7075_77F3_6CBB_7597_91CF = 300
local _____7075_77F3_51B7_5374_79D2_6570 = 3
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
____exports["处理灵石受伤"] = function(ctx)
    local _____6301_6709_7075_77F3 = _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(ctx.target, _____4F24_5BB3_4E8B_4EF6_88C5_5907ID["灵石"])
    if not _____6301_6709_7075_77F3 then
        return
    end
    local id = GetHandleId(ctx.target)
    local _____51B7_5374_952E = "灵石:" .. tostring(id)
    local _____51B7_5374_4E2D = _____5355_4F4D_51B7_5374_4E2D(_____51B7_5374_952E)
    if _____51B7_5374_4E2D then
        return
    end
    local _____7269_7406_4F24_5BB3 = ctx.snapshot ~= nil and ctx.snapshot.isPhysicalDamage == true
    if not _____7269_7406_4F24_5BB3 then
        return
    end
    local _____5F53_524D_65F6_95F4 = getServerTime()
    local _____8BB0_5F55 = _____7075_77F3_7D2F_8BA1[id]
    if _____8BB0_5F55 == nil or _____5F53_524D_65F6_95F4 >= _____8BB0_5F55["结束时间"] then
        _____8BB0_5F55 = {["数值"] = 0, ["结束时间"] = _____5F53_524D_65F6_95F4 + _____7075_77F3_7D2F_8BA1_7A97_53E3_6BEB_79D2}
        _____7075_77F3_7D2F_8BA1[id] = _____8BB0_5F55
    end
    _____8BB0_5F55["数值"] = _____8BB0_5F55["数值"] + ctx.applied
    if _____8BB0_5F55["数值"] < _____7075_77F3_89E6_53D1_9608_503C then
        return
    end
    __TS__Delete(_____7075_77F3_7D2F_8BA1, id)
    _____8BBE_7F6E_5355_4F4D_51B7_5374(_____51B7_5374_952E, _____7075_77F3_51B7_5374_79D2_6570)
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

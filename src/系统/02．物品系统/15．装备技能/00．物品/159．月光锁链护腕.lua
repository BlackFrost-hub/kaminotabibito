--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.00．伤害事件配置表")
local _____4F24_5BB3_4E8B_4EF6_88C5_5907ID = ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868["伤害事件装备ID"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["造成伤害事件伤害"]
local _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["伤害事件伤害类型"]
local ____14_FF0E_5355_4F4D_65F6_9650_6807_8BB0 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.14．单位时限标记")
local _____521B_5EFA_5355_4F4D_65F6_9650_6807_8BB0 = ____14_FF0E_5355_4F4D_65F6_9650_6807_8BB0["创建单位时限标记"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____53D6_88C5_5907_51B7_5374_952E = ____07_FF0E_88C5_5907_8F85_52A9["取装备冷却键"]
local _____88C5_5907_51B7_5374_5C31_7EEA = ____07_FF0E_88C5_5907_8F85_52A9["装备冷却就绪"]
local _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A = ____07_FF0E_88C5_5907_8F85_52A9["进入装备冷却并显示"]
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____5EF6_8FDF_6267_884C = ____20_FF0E_7269_54C1_8F85_52A9["延迟执行"]
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local _____5355_4F4D_62E5_6709_4EFB_610FBuff = ____require_result_0["单位拥有任意Buff"]
local _____6708_5149_9501_94FE_62A4_8155_51CF_4F24_6807_8BB0 = _____521B_5EFA_5355_4F4D_65F6_9650_6807_8BB0("月光锁链护腕减伤")
local _____6708_5149_9501_94FE_62A4_8155_63A7_5236Buff_5217_8868 = {
    "C001",
    "C002",
    "C003",
    "C004",
    "C005",
    "C006",
    "C007",
    "C008",
    "C009",
    "C023"
}
local function _____89E6_53D1_6708_5149_9501_94FE_62A4_8155(target, attacker, amount)
    local key = _____53D6_88C5_5907_51B7_5374_952E(target, "月光锁链护腕", "伤害事件装备")
    if not _____88C5_5907_51B7_5374_5C31_7EEA(key) then
        return
    end
    _____8FDB_5165_88C5_5907_51B7_5374_5E76_663E_793A(key, 12, target, "月光锁链护腕")
    _____6708_5149_9501_94FE_62A4_8155_51CF_4F24_6807_8BB0["标记"](_____6708_5149_9501_94FE_62A4_8155_51CF_4F24_6807_8BB0, target, 2)
    _____5EF6_8FDF_6267_884C(
        1,
        function()
            _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3(target, attacker, amount, _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["强化"])
        end
    )
end
____exports["处理月光锁链护腕伤害修正"] = function(context)
    local target = context.target
    local attacker = context.attacker
    if target == nil or target == 0 or attacker == nil or attacker == 0 then
        return context.currentDamage
    end
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(target, _____4F24_5BB3_4E8B_4EF6_88C5_5907ID["月光锁链护腕"]) then
        return context.currentDamage
    end
    if _____5355_4F4D_62E5_6709_4EFB_610FBuff(target, _____6708_5149_9501_94FE_62A4_8155_63A7_5236Buff_5217_8868) then
        _____89E6_53D1_6708_5149_9501_94FE_62A4_8155(target, attacker, context.currentDamage * 0.3)
    end
    if not _____6708_5149_9501_94FE_62A4_8155_51CF_4F24_6807_8BB0["存在"](_____6708_5149_9501_94FE_62A4_8155_51CF_4F24_6807_8BB0, target) then
        return context.currentDamage
    end
    return context.currentDamage * 0.7
end
return ____exports

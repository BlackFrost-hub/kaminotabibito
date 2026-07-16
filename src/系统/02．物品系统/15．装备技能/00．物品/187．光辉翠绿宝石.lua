--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____04_FF0E_6301_6709_6218_6597_5468_671F_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.04．持有战斗周期模板")
local _____6CE8_518C_6301_6709_6218_6597_5468_671F_6A21_677F = ____04_FF0E_6301_6709_6218_6597_5468_671F_6A21_677F["注册持有战斗周期模板"]
local ____08_FF0E_6B21_6570_578B_4F24_5BB3_514D_75AB = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.08．次数型伤害免疫")
local _____521B_5EFA_6B21_6570_578B_4F24_5BB3_514D_75AB = ____08_FF0E_6B21_6570_578B_4F24_5BB3_514D_75AB["创建次数型伤害免疫"]
local ____24_FF0E_53E5_67C4_4E0A_4E0B_6587_6258_7BA1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.24．句柄上下文托管")
local _____521B_5EFA_53E5_67C4_4E0A_4E0B_6587_6258_7BA1_5668 = ____24_FF0E_53E5_67C4_4E0A_4E0B_6587_6258_7BA1["创建句柄上下文托管器"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____53D6_88C5_5907_7269_54C1ID = ____07_FF0E_88C5_5907_8F85_52A9["取装备物品ID"]
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____56DBBoss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["四Boss战利品装备名"]
local _____56DBBoss_88C5_5907_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["四Boss装备特效"]
local _____9632_62A4 = _____521B_5EFA_53E5_67C4_4E0A_4E0B_6587_6258_7BA1_5668("光辉翠绿宝石")
local function _____5237_65B0_7FE0_7EFF_9632_62A4(unit)
    local old = _____9632_62A4["取出"](unit)
    if old ~= nil and old["是否生效"](old) then
        old["取消"](old)
    end
    local shield = _____521B_5EFA_6B21_6570_578B_4F24_5BB3_514D_75AB({
        ["名称"] = "光辉翠绿体",
        ["单位"] = unit,
        ["免疫类型"] = "物理伤害",
        ["免疫次数"] = 1,
        ["持续秒"] = 22,
        ["最低伤害"] = 800,
        ["最低伤害占最大生命比例"] = 0.08,
        ["过滤伤害"] = function(c) return c.isDotDamage ~= true and c.isReflectedDamage ~= true and c.isDamageTransfer ~= true and c.isEquipmentSkillDamage ~= true end,
        ["on抵挡"] = function(e) return _____64AD_653E_5355_4F4D_7279_6548(
            _____56DBBoss_88C5_5907_7279_6548["翠绿护盾"],
            e["单位"],
            "origin",
            1.2,
            0.32
        ) end
    })
    _____9632_62A4["写入"](unit, shield)
    _____64AD_653E_5355_4F4D_7279_6548(
        _____56DBBoss_88C5_5907_7279_6548["翠绿护盾"],
        unit,
        "origin",
        1,
        0.25
    )
end
_____6CE8_518C_6301_6709_6218_6597_5468_671F_6A21_677F({
    ["名称"] = "光辉翠绿宝石-周期防护",
    ["物品类型ID"] = _____53D6_88C5_5907_7269_54C1ID(_____56DBBoss_6218_5229_54C1_88C5_5907_540D["光辉翠绿宝石"]),
    ["周期秒"] = 20,
    ["on获取"] = function(e)
        if e["前次数量"] <= 0 then
            _____5237_65B0_7FE0_7EFF_9632_62A4(e["单位"])
        end
    end,
    ["on丢弃"] = function(e)
        if e["持有数量"] <= 0 then
            local c = _____9632_62A4["取出"](e["单位"])
            if c ~= nil and c["是否生效"](c) then
                c["取消"](c)
            end
        end
    end,
    ["on周期"] = function(e) return _____5237_65B0_7FE0_7EFF_9632_62A4(e["单位"]) end
})
return ____exports

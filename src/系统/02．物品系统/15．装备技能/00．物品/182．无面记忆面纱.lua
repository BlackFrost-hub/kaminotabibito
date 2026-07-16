--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____29_FF0E_91CD_590D_4F24_5BB3_7C7B_578B_9002_5E94 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.29．重复伤害类型适应")
local _____521B_5EFA_91CD_590D_4F24_5BB3_7C7B_578B_9002_5E94 = ____29_FF0E_91CD_590D_4F24_5BB3_7C7B_578B_9002_5E94["创建重复伤害类型适应"]
local ____07_FF0E_88C5_5907_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助")
local _____64AD_653E_5355_4F4D_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["播放单位特效"]
local _____56DBBoss_6218_5229_54C1_88C5_5907_540D = ____07_FF0E_88C5_5907_8F85_52A9["四Boss战利品装备名"]
local _____56DBBoss_88C5_5907_7279_6548 = ____07_FF0E_88C5_5907_8F85_52A9["四Boss装备特效"]
_____521B_5EFA_91CD_590D_4F24_5BB3_7C7B_578B_9002_5E94({
    ["名称"] = "无面记忆面纱-记忆剥落",
    ["装备名"] = _____56DBBoss_6218_5229_54C1_88C5_5907_540D["无面记忆面纱"],
    ["记录持续秒"] = 6,
    ["重复伤害倍率"] = 0.7,
    ["冷却秒数"] = 10,
    ["过滤伤害"] = function(c) return (c.isSkillDamage == true or c.isSkillAttack == true) and c.isEquipmentSkillDamage ~= true end,
    ["on适应"] = function(e) return _____64AD_653E_5355_4F4D_7279_6548(
        _____56DBBoss_88C5_5907_7279_6548["灵魂崩解"],
        e["单位"],
        "overhead",
        1,
        0.2
    ) end
})
return ____exports

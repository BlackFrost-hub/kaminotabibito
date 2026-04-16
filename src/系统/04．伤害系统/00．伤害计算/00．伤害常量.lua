--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 玩家属性上下限（仅对玩家生效）
-- 格式：{ max: 上限, min: 下限 }
-- 默认值：max = 1（无上限），min = -1（无下限）
____exports.STAT_LIMITS = {
    ["魔抗"] = {max = 0.5, min = -1},
    ["物理抗性"] = {max = 0.3, min = -1},
    ["技能抗性"] = {max = 0.8, min = -1},
    ["普攻抗性"] = {max = 0.8, min = -1},
    ["伤害减少%"] = {max = 0.8, min = -1},
    ["金属性抗性"] = {max = 0.8, min = -1},
    ["木属性抗性"] = {max = 0.8, min = -1},
    ["水属性抗性"] = {max = 0.8, min = -1},
    ["火属性抗性"] = {max = 0.8, min = -1},
    ["雷属性抗性"] = {max = 0.8, min = -1},
    ["光属性抗性"] = {max = 0.8, min = -1},
    ["暗属性抗性"] = {max = 0.8, min = -1},
    ["召唤物抗性"] = {max = 0.8, min = -1},
    ["最终伤害%"] = {max = 0.8, min = -1},
    ["伤害吸血"] = {max = 0.05, min = -1},
    ["魔法伤害吸血"] = {max = 0.15, min = -1},
    ["普攻伤害吸血"] = {max = 0.25, min = -1},
    ["伤害吸魔"] = {max = 0.05, min = -1}
}
--- 敌对单位属性上下限（仅对非玩家单位生效）
-- 格式：{ max: 上限, min: 下限 }
-- 默认值：max = 1（无上限），min = -1（无下限）
____exports.ENEMY_STAT_LIMITS = {
    ["魔抗"] = {max = 1, min = -1},
    ["物理抗性"] = {max = 1, min = -1},
    ["技能抗性"] = {max = 1, min = -1},
    ["普攻抗性"] = {max = 1, min = -1},
    ["伤害减少%"] = {max = 1, min = -1},
    ["金属性抗性"] = {max = 1, min = -1},
    ["木属性抗性"] = {max = 1, min = -1},
    ["水属性抗性"] = {max = 1, min = -1},
    ["火属性抗性"] = {max = 1, min = -1},
    ["雷属性抗性"] = {max = 1, min = -1},
    ["光属性抗性"] = {max = 1, min = -1},
    ["暗属性抗性"] = {max = 1, min = -1},
    ["召唤物抗性"] = {max = 1, min = -1},
    ["最终伤害%"] = {max = 1, min = -1},
    ["伤害吸血"] = {max = 1, min = -1},
    ["魔法伤害吸血"] = {max = 1, min = -1},
    ["普攻伤害吸血"] = {max = 1, min = -1},
    ["伤害吸魔"] = {max = 1, min = -1}
}
--- 可突破上限的属性配置
-- key: 属性名
-- value: 突破上限所需的特殊属性名
____exports.BREAKABLE_LIMITS = {["伤害吸血"] = "伤害吸血上限", ["伤害吸魔"] = "伤害吸魔突破"}
--- 叠加类型枚举
____exports.STACK_TYPE = {ADDITIVE = "additive", MULTIPLICATIVE = "multiplicative", MAX = "max"}
--- 属性叠加方式配置
-- 
-- 设计原则：
-- 1. 伤害加成类 → 加法叠加（避免收益递减过快）
-- 2. 抗性减伤类 → 乘法叠加（独立乘区，防止叠加过强）
-- 3. 移动速度 → 取最高值（防止无限加速）
____exports.STAT_STACK_CONFIG = {
    ["伤害%"] = ____exports.STACK_TYPE.ADDITIVE,
    ["物理伤害"] = ____exports.STACK_TYPE.ADDITIVE,
    ["魔法伤害"] = ____exports.STACK_TYPE.ADDITIVE,
    ["强化伤害"] = ____exports.STACK_TYPE.ADDITIVE,
    ["技能伤害"] = ____exports.STACK_TYPE.ADDITIVE,
    ["普攻伤害"] = ____exports.STACK_TYPE.ADDITIVE,
    ["魔法普攻伤害"] = ____exports.STACK_TYPE.ADDITIVE,
    ["金属性伤害"] = ____exports.STACK_TYPE.ADDITIVE,
    ["木属性伤害"] = ____exports.STACK_TYPE.ADDITIVE,
    ["水属性伤害"] = ____exports.STACK_TYPE.ADDITIVE,
    ["火属性伤害"] = ____exports.STACK_TYPE.ADDITIVE,
    ["雷属性伤害"] = ____exports.STACK_TYPE.ADDITIVE,
    ["光属性伤害"] = ____exports.STACK_TYPE.ADDITIVE,
    ["暗属性伤害"] = ____exports.STACK_TYPE.ADDITIVE,
    ["召唤物伤害"] = ____exports.STACK_TYPE.ADDITIVE,
    ["蝼蚁专精"] = ____exports.STACK_TYPE.ADDITIVE,
    ["Boss专精"] = ____exports.STACK_TYPE.ADDITIVE,
    ["魔抗"] = ____exports.STACK_TYPE.MULTIPLICATIVE,
    ["物理抗性"] = ____exports.STACK_TYPE.MULTIPLICATIVE,
    ["技能抗性"] = ____exports.STACK_TYPE.MULTIPLICATIVE,
    ["普攻抗性"] = ____exports.STACK_TYPE.MULTIPLICATIVE,
    ["伤害减少%"] = ____exports.STACK_TYPE.MULTIPLICATIVE,
    ["金属性抗性"] = ____exports.STACK_TYPE.MULTIPLICATIVE,
    ["木属性抗性"] = ____exports.STACK_TYPE.MULTIPLICATIVE,
    ["水属性抗性"] = ____exports.STACK_TYPE.MULTIPLICATIVE,
    ["火属性抗性"] = ____exports.STACK_TYPE.MULTIPLICATIVE,
    ["雷属性抗性"] = ____exports.STACK_TYPE.MULTIPLICATIVE,
    ["光属性抗性"] = ____exports.STACK_TYPE.MULTIPLICATIVE,
    ["暗属性抗性"] = ____exports.STACK_TYPE.MULTIPLICATIVE,
    ["召唤物抗性"] = ____exports.STACK_TYPE.MULTIPLICATIVE,
    ["最终伤害%"] = ____exports.STACK_TYPE.MULTIPLICATIVE,
    ["移动速度"] = ____exports.STACK_TYPE.MAX
}
--- JASS代码中的错误属性名 → 正确属性名映射
-- 用于修正JASS代码中的属性名错误
____exports.JASS_ATTR_NAME_FIX = {["受到的治疗加成"] = "受到的治疗率", ["最终伤害"] = "最终伤害%"}
--- 伤害类型对应的属性名映射
-- 用于根据伤害类型获取对应的伤害/抗性属性名
____exports.DAMAGE_TYPE_ATTRS = {
    DAMAGE_TYPE_NORMAL = {damage = "物理伤害", resist = "物理抗性"},
    DAMAGE_TYPE_ENHANCED = {damage = "强化伤害", resist = ""},
    DAMAGE_TYPE_SLOW_POISON = {damage = "金属性伤害", resist = "金属性抗性"},
    DAMAGE_TYPE_POISON = {damage = "金属性伤害", resist = "金属性抗性"},
    DAMAGE_TYPE_ACID = {damage = "金属性伤害", resist = "金属性抗性"},
    DAMAGE_TYPE_PLANT = {damage = "木属性伤害", resist = "木属性抗性"},
    DAMAGE_TYPE_COLD = {damage = "水属性伤害", resist = "水属性抗性"},
    DAMAGE_TYPE_FIRE = {damage = "火属性伤害", resist = "火属性抗性"},
    DAMAGE_TYPE_LIGHTNING = {damage = "雷属性伤害", resist = "雷属性抗性"},
    DAMAGE_TYPE_DIVINE = {damage = "光属性伤害", resist = "光属性抗性"},
    DAMAGE_TYPE_SHADOW_STRIKE = {damage = "暗属性伤害", resist = "暗属性抗性"}
}
--- 护甲减伤公式常量
-- 减伤比例 = 护甲 / (护甲 + ARMOR_FACTOR)
____exports.ARMOR_FACTOR = 50
--- 获取属性值（应用上下限）
-- 
-- @param attrName 属性名
-- @param value 原始值
-- @param isPlayer 是否为玩家单位
function ____exports.applyStatLimit(self, attrName, value, isPlayer)
    local limit = isPlayer and ____exports.STAT_LIMITS[attrName] or ____exports.ENEMY_STAT_LIMITS[attrName]
    if limit == nil then
        return value
    end
    if value > limit.max then
        value = limit.max
    end
    if value < limit.min then
        value = limit.min
    end
    return value
end
--- 修正JASS属性名
-- 
-- @param attrName JASS中的属性名
-- @returns 正确的属性名
function ____exports.fixJassAttrName(self, attrName)
    return ____exports.JASS_ATTR_NAME_FIX[attrName] or attrName
end
--- 获取属性的叠加方式
-- 
-- @param attrName 属性名
-- @returns 叠加方式，默认为加法叠加
function ____exports.getStackType(self, attrName)
    return ____exports.STAT_STACK_CONFIG[attrName] or ____exports.STACK_TYPE.ADDITIVE
end
return ____exports

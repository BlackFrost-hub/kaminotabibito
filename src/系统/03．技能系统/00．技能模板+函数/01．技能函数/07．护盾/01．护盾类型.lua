--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 护盾类型定义
-- 
-- 定义护盾类型枚举、优先级常量、回调类型
local ShieldType = {
    ["通用"] = 0,
    ["物理"] = 1,
    ["魔法"] = 2,
    ["强化"] = 3,
    ["金"] = 4,
    ["木"] = 5,
    ["水"] = 6,
    ["火"] = 7,
    ["冰"] = 8,
    ["雷"] = 9,
    ["风"] = 10,
    ["暗"] = 11,
    ["光"] = 12,
    ["毒"] = 13
}
____exports["护盾类型"] = ShieldType
____exports["护盾属性转类型"] = function(_____5C5E_6027)
    if _____5C5E_6027 == "强化" then
        return ShieldType["强化"]
    end
    if _____5C5E_6027 == "金" then
        return ShieldType["金"]
    end
    if _____5C5E_6027 == "木" then
        return ShieldType["木"]
    end
    if _____5C5E_6027 == "水" then
        return ShieldType["水"]
    end
    if _____5C5E_6027 == "火" then
        return ShieldType["火"]
    end
    if _____5C5E_6027 == "冰" then
        return ShieldType["冰"]
    end
    if _____5C5E_6027 == "雷" then
        return ShieldType["雷"]
    end
    if _____5C5E_6027 == "风" then
        return ShieldType["风"]
    end
    if _____5C5E_6027 == "暗" then
        return ShieldType["暗"]
    end
    if _____5C5E_6027 == "光" then
        return ShieldType["光"]
    end
    if _____5C5E_6027 == "毒" then
        return ShieldType["毒"]
    end
    return ShieldType["通用"]
end
--- 类型优先级：专用护盾 > 通用护盾
____exports["类型优先级"] = {
    [ShieldType["物理"]] = 100,
    [ShieldType["魔法"]] = 100,
    [ShieldType["强化"]] = 120,
    [ShieldType["金"]] = 120,
    [ShieldType["木"]] = 120,
    [ShieldType["水"]] = 120,
    [ShieldType["火"]] = 120,
    [ShieldType["冰"]] = 120,
    [ShieldType["雷"]] = 120,
    [ShieldType["风"]] = 120,
    [ShieldType["暗"]] = 120,
    [ShieldType["光"]] = 120,
    [ShieldType["毒"]] = 120,
    [ShieldType["通用"]] = 50
}
--- 默认抵挡优先级
____exports["默认抵挡优先级"] = 50
return ____exports

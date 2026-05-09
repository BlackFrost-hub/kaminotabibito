--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 护盾类型
____exports["护盾类型"] = 护盾类型 or ({})
____exports["护盾类型"]["通用"] = 0
____exports["护盾类型"][____exports["护盾类型"]["通用"]] = "通用"
____exports["护盾类型"]["物理"] = 1
____exports["护盾类型"][____exports["护盾类型"]["物理"]] = "物理"
____exports["护盾类型"]["魔法"] = 2
____exports["护盾类型"][____exports["护盾类型"]["魔法"]] = "魔法"
--- 类型优先级：专用护盾 > 通用护盾
____exports["类型优先级"] = {[____exports["护盾类型"]["物理"]] = 100, [____exports["护盾类型"]["魔法"]] = 100, [____exports["护盾类型"]["通用"]] = 50}
--- 默认抵挡优先级
____exports["默认抵挡优先级"] = 50
return ____exports

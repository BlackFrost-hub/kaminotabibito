--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 护盾类型定义
-- 
-- 定义护盾类型枚举、优先级常量、回调类型
local ShieldType = {["通用"] = 0, ["物理"] = 1, ["魔法"] = 2}
____exports["护盾类型"] = ShieldType
--- 类型优先级：专用护盾 > 通用护盾
____exports["类型优先级"] = {[ShieldType["物理"]] = 100, [ShieldType["魔法"]] = 100, [ShieldType["通用"]] = 50}
--- 默认抵挡优先级
____exports["默认抵挡优先级"] = 50
return ____exports

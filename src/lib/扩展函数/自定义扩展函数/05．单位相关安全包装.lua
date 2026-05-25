--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 单位相关安全包装
-- 
-- 说明：
-- 1. 不改老的 `00．单位相关.ts` 导出 ABI
-- 2. 专门给 TS 调用侧提供无 self 错位风险的安全入口
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
local _____767B_8BB0_5355_4F4D_6392_6CC4 = ____require_result_0["登记单位排泄"]
local CreateUnit = jass.CreateUnit
____exports["创建单位并登记排泄安全"] = function(owner, unitTypeId, x, y, facing)
    local _____5355_4F4D = CreateUnit(
        owner,
        unitTypeId,
        x,
        y,
        facing
    )
    return _____767B_8BB0_5355_4F4D_6392_6CC4(_____5355_4F4D)
end
return ____exports

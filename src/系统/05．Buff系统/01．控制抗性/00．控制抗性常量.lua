--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 通用控制时间削减上限
-- 单位/玩家的「减少控制时间」属性上限
-- 默认：0.90（90%削减，即控制时间缩短为原来的10%）
-- 修改示例：改为0.80表示80%上限
____exports.CONTROL_REDUCTION_CAP = 0.9
--- Boss单位控制时间上限配置
-- 
-- key: 单位类型ID（字符串形式，如 'N05U'）
-- value: 最大控制时间（秒）
____exports.BOSS_CONTROL_LIMITS = {N05U = 1}
--- 不参与控制抗性的单位类型ID（字符串形式）
____exports.EXCLUDED_UNIT_TYPES = {"e02A", "bHun"}
return ____exports

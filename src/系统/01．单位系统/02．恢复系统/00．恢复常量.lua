--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 力量转生命恢复系数
-- 公式：基础生命恢复 = 力量 × 此系数
-- 默认：0.32（每点力量提供0.32生命恢复/秒）
____exports.STRENGTH_TO_LIFE_REGEN = 0.32
--- 智力转魔法恢复系数
-- 公式：基础魔法恢复 = 智力 × 此系数
-- 默认：0.15（每点智力提供0.15魔法恢复/秒）
____exports.INTELLIGENCE_TO_MANA_REGEN = 0.15
--- 百分比生命恢复上限
-- 玩家的「百分比生命回复」属性上限
-- 默认：0.06（6%最大生命/秒）
-- 修改示例：改为0.08表示8%上限
____exports.LIFE_REGEN_PERCENT_CAP = 0.06
--- 百分比魔法恢复上限
-- 玩家的「百分比魔法回复」属性上限
-- 默认：0.04（4%最大魔法/秒）
-- 修改示例：改为0.06表示6%上限
____exports.MANA_REGEN_PERCENT_CAP = 0.04
--- 固定恢复阈值
-- 总恢复值低于此阈值时不执行恢复操作
-- 默认：0.50
-- 修改示例：改为0.005表示更低的阈值
____exports.REGEN_THRESHOLD = 0.005
--- 百分比恢复阈值
-- 百分比恢复低于此阈值时不执行恢复操作
-- 默认：0.005（0.5%）
-- 修改示例：改为0.01表示1%阈值
____exports.PERCENT_REGEN_THRESHOLD = 0.005
return ____exports

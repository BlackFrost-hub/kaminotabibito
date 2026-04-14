--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 显示技能名字系统2
-- 
-- 功能：当单位发动技能效果时触发
-- 事件：EVENT_PLAYER_UNIT_SPELL_EFFECT（发动技能效果）
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.BJ函数.index")
local TriggerRegisterAnyUnitEventBJ = ____require_result_0.TriggerRegisterAnyUnitEventBJ
local ____require_result_1 = require("lib.扩展函数.BJ函数.07．杂项")
local GetSpellAbilityId = ____require_result_1.GetSpellAbilityId
--- 发动技能效果的触发动作
local function onSpellEffect(self)
    local unit = jass.GetTriggerUnit()
    local abilityId = GetSpellAbilityId(nil)
end
--- 初始化
function ____exports.initShowSkillName2(self)
    local trig = jass.CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(nil, trig, jass.EVENT_PLAYER_UNIT_SPELL_EFFECT)
    jass.TriggerAddAction(trig, onSpellEffect)
end
return ____exports

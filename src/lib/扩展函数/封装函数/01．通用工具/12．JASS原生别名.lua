--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 小范围复用的 JASS 原生别名。
-- 
-- 只收敛高频、稳定、纯函数式调用的 common.j 原生，
-- 避免每个业务文件重复声明同一批局部别名。
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.BJ函数.01．触发与事件")
local BJTriggerRegisterEnterRectSimple = ____require_result_0.TriggerRegisterEnterRectSimple
local ____require_result_1 = require("lib.扩展函数.BJ函数.07．杂项")
local BJGetUnitsInRectMatching = ____require_result_1.GetUnitsInRectMatching
____exports.AddSpecialEffect = jass.AddSpecialEffect
____exports.Condition = jass.Condition
____exports.CreateFogModifierRect = jass.CreateFogModifierRect
____exports.CreateItem = jass.CreateItem
____exports.CreateTrigger = jass.CreateTrigger
____exports.CreateUnit = jass.CreateUnit
____exports.DestroyGroup = jass.DestroyGroup
____exports.FirstOfGroup = jass.FirstOfGroup
____exports.FogModifierStart = jass.FogModifierStart
____exports.GetEnumUnit = jass.GetEnumUnit
____exports.GetFilterUnit = jass.GetFilterUnit
____exports.GetRandomReal = jass.GetRandomReal
____exports.GetTriggerUnit = jass.GetTriggerUnit
____exports.GetUnitTypeId = jass.GetUnitTypeId
____exports.GetUnitX = jass.GetUnitX
____exports.GetUnitY = jass.GetUnitY
____exports.GetUnitsInRectMatching = BJGetUnitsInRectMatching
____exports.GroupRemoveUnit = jass.GroupRemoveUnit
____exports.IssueImmediateOrder = jass.IssueImmediateOrder
____exports.IsUnitInGroup = jass.IsUnitInGroup
____exports.Location = jass.Location
____exports.PauseUnit = jass.PauseUnit
____exports.Player = jass.Player
____exports.RemoveLocation = jass.RemoveLocation
____exports.RemoveRect = jass.RemoveRect
____exports.SetUnitFacing = jass.SetUnitFacing
____exports.SetUnitFacingTimed = jass.SetUnitFacingTimed
____exports.SetUnitInvulnerable = jass.SetUnitInvulnerable
____exports.SetUnitOwner = jass.SetUnitOwner
____exports.StopMusic = jass.StopMusic
____exports.TriggerAddAction = jass.TriggerAddAction
____exports.TriggerRegisterEnterRectSimple = BJTriggerRegisterEnterRectSimple
____exports.FOG_OF_WAR_VISIBLE = jass.FOG_OF_WAR_VISIBLE
____exports.PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
return ____exports

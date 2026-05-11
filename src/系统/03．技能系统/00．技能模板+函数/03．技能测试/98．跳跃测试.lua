--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local onPauseTestUnit, onResumeTestUnit, g, createDelayedCall, debugLogForce, PauseUnit
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.index")
local _____5F00_59CB_8DF3_8DC3 = ____index["开始跳跃"]
function onPauseTestUnit()
    local testUnit = g.gg_unit_Hamg_0002
    if testUnit == nil or testUnit == 0 then
        return
    end
    debugLogForce(nil, "jump-test", "pause")
    PauseUnit(testUnit, true)
    createDelayedCall(0.5, onResumeTestUnit)
end
function onResumeTestUnit()
    local testUnit = g.gg_unit_Hamg_0002
    if testUnit == nil or testUnit == 0 then
        return
    end
    debugLogForce(nil, "jump-test", "resume")
    PauseUnit(testUnit, false)
end
--- Jump system temporary test.
-- 
-- Flow:
-- 1. After 2s, make `gg_unit_Hamg_0002` jump once.
-- 2. After 1.8s, pause the unit.
-- 3. After 0.5s, unpause the unit.
-- 4. Verify jump resumes instead of ending.
local jass = require("jass.common")
g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
createDelayedCall = ____require_result_0.createDelayedCall
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.index")
debugLogForce = ____require_result_1.debugLogForce
local GetUnitFacing = jass.GetUnitFacing
PauseUnit = jass.PauseUnit
local function runJumpTest()
    debugLogForce(nil, "jump-test", "run")
    local testUnit = g.gg_unit_Hamg_0002
    if testUnit == nil or testUnit == 0 then
        debugLogForce(nil, "jump-test", "unit-missing", "gg_unit_Hamg_0002")
        return
    end
    local angle = GetUnitFacing(testUnit) + 180
    debugLogForce(
        nil,
        "jump-test",
        "start-jump",
        "angle=" .. tostring(angle)
    )
    _____5F00_59CB_8DF3_8DC3(testUnit, {
        ["角度"] = angle,
        ["距离"] = 1000,
        ["持续时间"] = 3,
        ["跳跃高度"] = 300,
        ["朝向跟随跳跃"] = false
    })
    createDelayedCall(1.8, onPauseTestUnit)
end
local _____542F_7528_6D4B_8BD5 = true
if _____542F_7528_6D4B_8BD5 then
    debugLogForce(nil, "jump-test", "loaded", "delay=2.0")
    createDelayedCall(4, runJumpTest)
end
return ____exports

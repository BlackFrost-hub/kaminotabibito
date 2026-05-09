--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 移动速度突破系统测试
-- 
-- 游戏开始0.1秒后，将 gg_unit_Hamg_0002 设置为700移速
-- 3秒后取消注册，测试特效是否正确删除
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.05．移动速度突破系统")
local SOS_SetUnitSpeed = ____require_result_0.SOS_SetUnitSpeed
local SOS_UnSetUnitSpeed = ____require_result_0.SOS_UnSetUnitSpeed
local _cancelTimer = nil
local _initTimer = nil
local function onCancelTimerExpire()
    local testUnit = g.gg_unit_Hamg_0002
    if testUnit then
        SOS_UnSetUnitSpeed(nil, testUnit)
        jass:DisplayTimedTextToPlayer(
            jass:Player(0),
            0,
            0,
            5,
            "[移动速度突破测试] 已取消 gg_unit_Hamg_0002 的移动速度突破注册"
        )
    end
    if _cancelTimer then
        jass:DestroyTimer(_cancelTimer)
        _cancelTimer = nil
    end
end
local function testMoveSpeedBreakthrough()
    local testUnit = g.gg_unit_Hamg_0002
    if not testUnit then
        jass:DisplayTimedTextToPlayer(
            jass:Player(0),
            0,
            0,
            5,
            "[移动速度突破测试] 错误：找不到单位 gg_unit_Hamg_0002"
        )
        return
    end
    SOS_SetUnitSpeed(nil, testUnit, 700)
    jass:DisplayTimedTextToPlayer(
        jass:Player(0),
        0,
        0,
        5,
        "[移动速度突破测试] 已将 gg_unit_Hamg_0002 设置为700移速，3秒后取消注册"
    )
    _cancelTimer = jass:CreateTimer()
    jass:TimerStart(_cancelTimer, 3, false, onCancelTimerExpire)
end
local function onInitTimerExpire()
    testMoveSpeedBreakthrough()
    if _initTimer then
        jass:DestroyTimer(_initTimer)
        _initTimer = nil
    end
end
local function initTest()
    _initTimer = jass:CreateTimer()
    jass:TimerStart(_initTimer, 0.1, false, onInitTimerExpire)
end
initTest()
return ____exports

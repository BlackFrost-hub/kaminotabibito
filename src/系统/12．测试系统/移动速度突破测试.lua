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
--- 测试移动速度突破
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
    local cancelTimer = jass:CreateTimer()
    jass:TimerStart(
        cancelTimer,
        3,
        false,
        function()
            SOS_UnSetUnitSpeed(nil, testUnit)
            jass:DisplayTimedTextToPlayer(
                jass:Player(0),
                0,
                0,
                5,
                "[移动速度突破测试] 已取消 gg_unit_Hamg_0002 的移动速度突破注册"
            )
            jass:DestroyTimer(cancelTimer)
        end
    )
end
--- 初始化测试
local function initTest()
    local timer = jass:CreateTimer()
    jass:TimerStart(
        timer,
        0.1,
        false,
        function()
            testMoveSpeedBreakthrough()
            jass:DestroyTimer(timer)
        end
    )
end
initTest()
return ____exports

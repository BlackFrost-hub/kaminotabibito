--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 快捷键技能功能
-- 
-- 按B传送BB：按B键让BB单位传送到鼠标位置
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local ____require_result_1 = require("lib.扩展函数.BJ函数.index")
local SelectUnitForPlayerSingle = ____require_result_1.SelectUnitForPlayerSingle
local ____require_result_2 = require("lib.扩展函数.BJ函数.07．杂项")
local String2OrderIdBJ = ____require_result_2.String2OrderIdBJ
local ____require_result_3 = require("lib.扩展函数.封装函数.04．硬件输入.08．同步硬件输入中心")
local registerSyncHardwareKey = ____require_result_3.registerSyncHardwareKey
local ____require_result_4 = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义")
local KEY = ____require_result_4.KEY
local KEY_STATE = ____require_result_4.KEY_STATE
local IssuePointOrderById = jass.IssuePointOrderById
local DzGetMouseTerrainX = require("jass.japi").DzGetMouseTerrainX
local DzGetMouseTerrainY = require("jass.japi").DzGetMouseTerrainY
local DzGetTriggerKeyPlayer = require("jass.japi").DzGetTriggerKeyPlayer
local ____BB_4F20_9001_547D_4EE4ID = String2OrderIdBJ("blink")
--- 触发器
local bbTeleportTrigger = nil
--- 按B传送BB事件处理
local function onBKeyTeleport(event)
    if event.key ~= KEY.B and event.key ~= "B" then
        return
    end
    local player = event.player or DzGetTriggerKeyPlayer()
    if player == nil or player == 0 then
        return
    end
    local bbUnit = YDUserDataGetSafe("player", player, "BB", "unit")
    if bbUnit == nil or bbUnit == 0 then
        return
    end
    local mouseX = DzGetMouseTerrainX()
    local mouseY = DzGetMouseTerrainY()
    IssuePointOrderById(bbUnit, ____BB_4F20_9001_547D_4EE4ID, mouseX, mouseY)
    SelectUnitForPlayerSingle(bbUnit, player)
end
--- 初始化按B传送BB功能
function ____exports.initBBTeleport()
    if bbTeleportTrigger ~= nil then
        return
    end
    bbTeleportTrigger = registerSyncHardwareKey(KEY.B, KEY_STATE.UP, onBKeyTeleport)
end
return ____exports

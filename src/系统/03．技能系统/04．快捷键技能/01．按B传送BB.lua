--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 快捷键技能功能
-- 
-- 按B传送BB：按B键让BB单位传送到鼠标位置
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local ____require_result_1 = require("lib.扩展函数.BJ函数.index")
local SelectUnitForPlayerSingle = ____require_result_1.SelectUnitForPlayerSingle
local ____require_result_2 = require("lib.扩展函数.KK扩展API.index")
local DzTriggerRegisterKeyEventTrg = ____require_result_2.DzTriggerRegisterKeyEventTrg
--- BB传送技能ID
local BB_TELEPORT_ABILITY = "A0FC"
--- 触发器
local bbTeleportTrigger = nil
--- 按B传送BB事件处理
local function onBKeyTeleport(self)
    local key = japi.DzGetTriggerKey()
    if key ~= "B" then
        return
    end
    local player = japi.DzGetTriggerKeyPlayer()
    local bbUnit = YDUserDataGet(
        nil,
        "player",
        player,
        "BB",
        "unit"
    )
    if bbUnit == nil then
        return
    end
    local mouseX = japi.DzGetMouseTerrainX()
    local mouseY = japi.DzGetMouseTerrainY()
    local abilityId = jass.FourCC(BB_TELEPORT_ABILITY)
    jass.IssuePointOrderById(bbUnit, abilityId, mouseX, mouseY)
    SelectUnitForPlayerSingle(nil, bbUnit, player)
end
--- 初始化按B传送BB功能
function ____exports.initBBTeleport(self)
    if bbTeleportTrigger ~= nil then
        return
    end
    bbTeleportTrigger = jass.CreateTrigger()
    DzTriggerRegisterKeyEventTrg(nil, bbTeleportTrigger, 0, "B")
    jass.TriggerAddAction(bbTeleportTrigger, onBKeyTeleport)
end
return ____exports

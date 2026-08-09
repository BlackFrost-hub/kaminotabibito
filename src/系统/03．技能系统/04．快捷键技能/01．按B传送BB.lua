local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local ____exports = {}
--- 快捷键技能功能
-- 
-- 按B传送BB：按B键让BB单位传送到鼠标位置
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local ____require_result_1 = require("lib.扩展函数.BJ函数.index")
local SelectUnitForPlayerSingle = ____require_result_1.SelectUnitForPlayerSingle
local ____require_result_2 = require("lib.扩展函数.BJ函数.07．杂项")
local String2OrderIdBJ = ____require_result_2.String2OrderIdBJ
local ____require_result_3 = require("lib.扩展函数.KK扩展API.02．事件注册函数")
local DzSyncData = ____require_result_3.DzSyncData
local DzTriggerRegisterSyncDataTrg = ____require_result_3.DzTriggerRegisterSyncDataTrg
local DzGetTriggerSyncPlayer = ____require_result_3.DzGetTriggerSyncPlayer
local DzGetTriggerSyncData = ____require_result_3.DzGetTriggerSyncData
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_4.debugLogForce
local ____require_result_5 = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义")
local KEY = ____require_result_5.KEY
local KEY_STATE = ____require_result_5.KEY_STATE
local IssuePointOrderById = jass.IssuePointOrderById
local CreateTrigger = jass.CreateTrigger
local TriggerAddAction = jass.TriggerAddAction
local R2S = jass.R2S
local S2R = jass.S2R
local GetHandleId = jass.GetHandleId
local DzTriggerRegisterKeyEventByCode = japi.DzTriggerRegisterKeyEventByCode
local DzIsChatBoxOpen = japi.DzIsChatBoxOpen
local DzGetMouseTerrainX = japi.DzGetMouseTerrainX
local DzGetMouseTerrainY = japi.DzGetMouseTerrainY
local ____BB_4F20_9001_547D_4EE4ID = String2OrderIdBJ("blink")
local ____BB_4F20_9001_540C_6B65_524D_7F00 = "BBTP"
local ____BB_4F20_9001_5750_6807_5206_9694_7B26 = "|"
local ____BB_4F20_9001_8C03_8BD5_6A21_5757 = "按B传送BB诊断"
--- 本机按键触发器与同步数据触发器。
local bbTeleportKeyTrigger = nil
local bbTeleportSyncTrigger = nil
--- 本机确认聊天框未激活后，由键盘中心调用并发送鼠标坐标。
local function onBKeyLocal()
    local chatBoxOpen = DzIsChatBoxOpen() == true
    debugLogForce(____BB_4F20_9001_8C03_8BD5_6A21_5757, "本机B回调", "聊天框", chatBoxOpen)
    if chatBoxOpen then
        return
    end
    local mouseX = DzGetMouseTerrainX()
    local mouseY = DzGetMouseTerrainY()
    DzSyncData(
        ____BB_4F20_9001_540C_6B65_524D_7F00,
        (R2S(mouseX) .. ____BB_4F20_9001_5750_6807_5206_9694_7B26) .. R2S(mouseY)
    )
    debugLogForce(____BB_4F20_9001_8C03_8BD5_6A21_5757, "已发送同步坐标", mouseX, mouseY)
end
--- 在同步数据回调中统一执行 BB 传送。
local function onBKeyTeleportSync()
    local player = DzGetTriggerSyncPlayer()
    local syncData = DzGetTriggerSyncData()
    debugLogForce(
        ____BB_4F20_9001_8C03_8BD5_6A21_5757,
        "收到同步消息",
        "玩家",
        (player == nil or player == 0) and 0 or GetHandleId(player),
        "数据",
        syncData
    )
    if player == nil or player == 0 then
        return
    end
    local bbUnit = YDUserDataGetSafe("player", player, "BB", "unit")
    if bbUnit == nil or bbUnit == 0 then
        debugLogForce(____BB_4F20_9001_8C03_8BD5_6A21_5757, "未找到BB单位")
        return
    end
    local coordinateParts = __TS__StringSplit(syncData, ____BB_4F20_9001_5750_6807_5206_9694_7B26)
    if #coordinateParts < 2 then
        return
    end
    local mouseX = S2R(coordinateParts[1] or "0")
    local mouseY = S2R(coordinateParts[2] or "0")
    local orderResult = IssuePointOrderById(bbUnit, ____BB_4F20_9001_547D_4EE4ID, mouseX, mouseY)
    debugLogForce(
        ____BB_4F20_9001_8C03_8BD5_6A21_5757,
        "发布传送命令",
        "BB",
        GetHandleId(bbUnit),
        "结果",
        orderResult
    )
    SelectUnitForPlayerSingle(bbUnit, player)
end
--- 初始化按B传送BB功能
function ____exports.initBBTeleport()
    if bbTeleportKeyTrigger ~= nil or bbTeleportSyncTrigger ~= nil then
        return
    end
    bbTeleportSyncTrigger = CreateTrigger()
    TriggerAddAction(bbTeleportSyncTrigger, onBKeyTeleportSync)
    DzTriggerRegisterSyncDataTrg(bbTeleportSyncTrigger, ____BB_4F20_9001_540C_6B65_524D_7F00, false)
    bbTeleportKeyTrigger = CreateTrigger()
    DzTriggerRegisterKeyEventByCode(
        bbTeleportKeyTrigger,
        KEY.B,
        KEY_STATE.UP,
        false,
        onBKeyLocal
    )
    debugLogForce(____BB_4F20_9001_8C03_8BD5_6A21_5757, "初始化完成")
end
return ____exports

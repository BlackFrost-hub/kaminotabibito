--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.09．表现系统.05．仇恨面板.00．常量定义")
local THREAT_PANEL_PLAYER_UNIT_MAX_PID = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_PLAYER_UNIT_MAX_PID
local THREAT_PANEL_PLAYER_SLOTS = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_PLAYER_SLOTS
local THREAT_PANEL_REFRESH_MS = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_REFRESH_MS
local ____01_FF0E_5171_4EAB = require("系统.09．表现系统.05．仇恨面板.01．共享")
local DzGetGameUI = ____01_FF0E_5171_4EAB.DzGetGameUI
local GetLocalPlayer = ____01_FF0E_5171_4EAB.GetLocalPlayer
local GetPlayerId = ____01_FF0E_5171_4EAB.GetPlayerId
local Player = ____01_FF0E_5171_4EAB.Player
local _____73A9_5BB6_9762_677F_663E_793A_72B6_6001_8868 = ____01_FF0E_5171_4EAB["玩家面板显示状态表"]
local ____02_FF0E_9762_677F_521B_5EFA = require("系统.09．表现系统.05．仇恨面板.02．面板创建")
local _____52A0_8F7D_4EC7_6068_9762_677FToc = ____02_FF0E_9762_677F_521B_5EFA["加载仇恨面板Toc"]
local _____521B_5EFA_5168_90E8_73A9_5BB6_9762_677F = ____02_FF0E_9762_677F_521B_5EFA["创建全部玩家面板"]
local ____04_FF0E_9A71_52A8 = require("系统.09．表现系统.05．仇恨面板.04．驱动")
local ____on_4EC7_6068_9762_677F_5237_65B0Tick = ____04_FF0E_9A71_52A8["on仇恨面板刷新Tick"]
local ____05_FF0E_4E2D_5FC3_8BA1_65F6_5668 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____05_FF0E_4E2D_5FC3_8BA1_65F6_5668.addPeriodicCallback
local ____01_FF0E_5E38_91CF_5B9A_4E49 = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义")
local KEY = ____01_FF0E_5E38_91CF_5B9A_4E49.KEY
local ____01_FF0E_5E38_91CF_5B9A_4E49 = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义")
local KEY_STATE = ____01_FF0E_5E38_91CF_5B9A_4E49.KEY_STATE
--- 仇恨面板 - 入口
-- 
-- 包含初始化入口函数。
local jass = require("jass.common")
local japi = require("jass.japi")
local _____5DF2_521D_59CB_5316 = false
local _____5237_65B0_56DE_8C03ID = 0
local _____5DF2_6CE8_518C_70ED_952E_73A9_5BB6_8868 = {}
local CreateTrigger = jass.CreateTrigger
local DzTriggerRegisterKeyEventByCode = japi.DzTriggerRegisterKeyEventByCode
local DzGetTriggerKeyPlayer = japi.DzGetTriggerKeyPlayer
local DzGetTriggerKey = japi.DzGetTriggerKey
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local _____5DF2_81EA_52A8_5C55_5F00_63D0_793A_73A9_5BB6_8868 = {}
local function _____521D_59CB_5316_73A9_5BB6_663E_793A_72B6_6001()
    do
        local playerId = 0
        while playerId < THREAT_PANEL_PLAYER_SLOTS do
            if _____73A9_5BB6_9762_677F_663E_793A_72B6_6001_8868[playerId] == nil then
                _____73A9_5BB6_9762_677F_663E_793A_72B6_6001_8868[playerId] = false
            end
            playerId = playerId + 1
        end
    end
end
local function ____on_4EC7_6068_9762_677FV_952E_62AC_8D77(whichPlayer, _key)
    if whichPlayer == nil or whichPlayer == 0 then
        return
    end
    local playerId = GetPlayerId(whichPlayer)
    if playerId < 0 or playerId >= THREAT_PANEL_PLAYER_SLOTS then
        return
    end
    _____73A9_5BB6_9762_677F_663E_793A_72B6_6001_8868[playerId] = _____73A9_5BB6_9762_677F_663E_793A_72B6_6001_8868[playerId] ~= true
    ____on_4EC7_6068_9762_677F_5237_65B0Tick()
end
local function ____on_4EC7_6068_9762_677FV_952E_672C_5730_56DE_8C03()
    ____on_4EC7_6068_9762_677FV_952E_62AC_8D77(
        DzGetTriggerKeyPlayer(),
        DzGetTriggerKey()
    )
end
local function _____6CE8_518C_73A9_5BB6V_952E(playerId)
    if playerId < 0 or playerId >= THREAT_PANEL_PLAYER_SLOTS then
        return
    end
    if _____5DF2_6CE8_518C_70ED_952E_73A9_5BB6_8868[playerId] == true then
        return
    end
    local _____672C_5730_73A9_5BB6 = GetLocalPlayer()
    if _____672C_5730_73A9_5BB6 == nil or _____672C_5730_73A9_5BB6 == 0 then
        return
    end
    if GetPlayerId(_____672C_5730_73A9_5BB6) ~= playerId then
        return
    end
    _____5DF2_6CE8_518C_70ED_952E_73A9_5BB6_8868[playerId] = true
    local trig = CreateTrigger()
    if trig == nil or trig == 0 then
        return
    end
    DzTriggerRegisterKeyEventByCode(
        trig,
        KEY.V,
        KEY_STATE.UP,
        false,
        ____on_4EC7_6068_9762_677FV_952E_672C_5730_56DE_8C03
    )
end
function ____exports.initThreatPanel()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    local gameUI = DzGetGameUI()
    if gameUI == 0 then
        return
    end
    _____52A0_8F7D_4EC7_6068_9762_677FToc()
    _____521D_59CB_5316_73A9_5BB6_663E_793A_72B6_6001()
    _____521B_5EFA_5168_90E8_73A9_5BB6_9762_677F(gameUI)
    ____on_4EC7_6068_9762_677F_5237_65B0Tick()
    if _____5237_65B0_56DE_8C03ID == 0 then
        _____5237_65B0_56DE_8C03ID = addPeriodicCallback(THREAT_PANEL_REFRESH_MS, ____on_4EC7_6068_9762_677F_5237_65B0Tick)
    end
end
____exports["自动展开仇恨面板一次"] = function(playerId)
    if playerId < 0 or playerId >= THREAT_PANEL_PLAYER_SLOTS then
        return
    end
    if _____5DF2_81EA_52A8_5C55_5F00_63D0_793A_73A9_5BB6_8868[playerId] == true then
        return
    end
    _____5DF2_81EA_52A8_5C55_5F00_63D0_793A_73A9_5BB6_8868[playerId] = true
    _____73A9_5BB6_9762_677F_663E_793A_72B6_6001_8868[playerId] = true
    ____on_4EC7_6068_9762_677F_5237_65B0Tick()
    local _____672C_5730_73A9_5BB6 = GetLocalPlayer()
    if _____672C_5730_73A9_5BB6 == nil or _____672C_5730_73A9_5BB6 == 0 then
        return
    end
    if GetPlayerId(_____672C_5730_73A9_5BB6) ~= playerId then
        return
    end
    DisplayTimedTextToPlayer(
        Player(playerId),
        0,
        0,
        8,
        "|cffffcc33首次进入战斗时会自动打开仇恨面板，之后不再自动展开，按 V 可随时开关。|r"
    )
end
function ____exports.onPlayerHeroRegistered(whichPlayer, whichHero)
    if whichPlayer == nil or whichPlayer == 0 then
        return
    end
    if whichHero == nil or whichHero == 0 then
        return
    end
    local playerId = GetPlayerId(whichPlayer)
    if playerId < 0 or playerId > THREAT_PANEL_PLAYER_UNIT_MAX_PID then
        return
    end
    ____exports.initThreatPanel()
    _____6CE8_518C_73A9_5BB6V_952E(playerId)
    ____on_4EC7_6068_9762_677F_5237_65B0Tick()
end
return ____exports

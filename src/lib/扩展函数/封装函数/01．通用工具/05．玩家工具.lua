--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 玩家工具函数
-- 玩家状态调整、消息显示等
local jass = require("jass.common")
local SOUND_GOLD = "Abilities\\Spells\\Items\\ResourceItems\\ReceiveGold.wav"
--- 调整玩家状态（如金币、木材），在原有基础上增加 delta。
function ____exports.AdjustPlayerStateBJ(self, delta, whichPlayer, whichPlayerState)
    local current = jass:GetPlayerState(whichPlayer, whichPlayerState)
    jass:SetPlayerState(whichPlayer, whichPlayerState, current + delta)
end
--- 增减金币，并自动反馈：
-- - 传 player：只对该玩家播放"收金币"音效，不创建漂浮字
-- - 传 unit：在该单位头顶创建漂浮字（+/-数值），并在单位附近播放 3D 音效（cutoff=1500）
function ____exports.AddGoldWithFeedback(self, params)
    local ____params_0 = params
    local delta = ____params_0.delta
    local player = ____params_0.player
    local unit = ____params_0.unit
    if delta == 0 then
        return
    end
    local ____temp_2
    if player ~= nil then
        ____temp_2 = player
    else
        local ____temp_1
        if unit ~= nil then
            ____temp_1 = jass:GetOwningPlayer(unit)
        else
            ____temp_1 = nil
        end
        ____temp_2 = ____temp_1
    end
    local p = ____temp_2
    if not p then
        return
    end
    ____exports.AdjustPlayerStateBJ(nil, delta, p, jass.PLAYER_STATE_RESOURCE_GOLD)
    local ____require_result_3 = require("lib.扩展函数.封装函数.02．音效系统.index")
    local Sound3DII_Mp3Play = ____require_result_3.Sound3DII_Mp3Play
    local Sound3DII_UnitPlay = ____require_result_3.Sound3DII_UnitPlay
    local ____require_result_4 = require("lib.扩展函数.封装函数.03．漂浮文字.index")
    local CreateFloatTextOnUnit = ____require_result_4.CreateFloatTextOnUnit
    if unit ~= nil then
        local txt = delta > 0 and "+" .. tostring(nil, delta) or tostring(nil, delta)
        CreateFloatTextOnUnit(nil, unit, txt, {red = 255, green = 215, blue = 0, alpha = 0})
        Sound3DII_UnitPlay(nil, SOUND_GOLD, unit, 1500)
    else
        Sound3DII_Mp3Play(nil, SOUND_GOLD, p)
    end
end
--- 向指定玩家显示屏幕消息（仅该玩家可见）
-- 
-- @param player 玩家句柄（可用 jass.Player(index) 获取）
-- @param msg 消息内容
-- @param duration 显示时长（秒），默认6秒
function ____exports.printToPlayer(self, player, msg, duration)
    if duration == nil then
        duration = 6
    end
    if not player then
        return
    end
    jass:DisplayTimedTextToPlayer(
        player,
        0,
        0,
        duration,
        msg
    )
end
--- 向多个玩家显示屏幕消息
-- 
-- @param players 玩家数组
-- @param msg 消息内容
-- @param duration 显示时长（秒），默认6秒
function ____exports.printToPlayers(self, players, msg, duration)
    if duration == nil then
        duration = 6
    end
    for ____, p in ipairs(players) do
        ____exports.printToPlayer(nil, p, msg, duration)
    end
end
return ____exports

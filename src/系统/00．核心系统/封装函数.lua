--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 通用 JASS 封装工具箱（会逐步堆很多“小而散”的 helper）。
-- 
-- 约定：
-- - 这里放“跨模块通用、但又不值得单独建系统文件”的封装函数（例如：资源调整、常用 JASS 小工具等）
-- - 若某类功能已经演化成完整系统（例如 音效函数/漂浮文字/泄露审计），应放到对应模块，不要继续堆在这里
-- - 这里的函数尽量保持：无复杂状态、易复用、参数清晰
local jass = require("jass.common")
local SOUND_GOLD = "Abilities\\Spells\\Items\\ResourceItems\\ReceiveGold.wav"
--- 调整玩家状态（如金币、木材），在原有基础上增加 delta。
function ____exports.AdjustPlayerStateBJ(self, delta, whichPlayer, whichPlayerState)
    local current = jass.GetPlayerState(whichPlayer, whichPlayerState)
    jass.SetPlayerState(whichPlayer, whichPlayerState, current + delta)
end
--- 增减金币，并自动反馈：
-- - 传 player：只对该玩家播放“收金币”音效，不创建漂浮字
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
        if unit ~= nil and type(jass.GetOwningPlayer) == "function" then
            ____temp_1 = jass.GetOwningPlayer(unit)
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
    local ____require_result_3 = require("系统.00．核心系统.音效函数")
    local Sound3DII_Mp3Play = ____require_result_3.Sound3DII_Mp3Play
    local Sound3DII_UnitPlay = ____require_result_3.Sound3DII_UnitPlay
    local ____require_result_4 = require("系统.00．核心系统.漂浮文字函数")
    local CreateFloatTextOnUnit = ____require_result_4.CreateFloatTextOnUnit
    if unit ~= nil then
        local txt = delta > 0 and "+" .. tostring(delta) or tostring(delta)
        CreateFloatTextOnUnit(nil, unit, txt, {red = 255, green = 215, blue = 0, alpha = 0})
        Sound3DII_UnitPlay(nil, SOUND_GOLD, unit, 1500)
    else
        Sound3DII_Mp3Play(nil, SOUND_GOLD, p)
    end
end
return ____exports

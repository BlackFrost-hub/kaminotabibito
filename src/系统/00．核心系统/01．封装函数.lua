local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local ____exports = {}
--- 通用 JASS 封装工具箱（会逐步堆很多“小而散”的 helper）。
-- 
-- 约定：
-- - 这里放“跨模块通用、但又不值得单独建系统文件”的封装函数（例如：资源调整、常用 JASS 小工具等）
-- - 若某类功能已经演化成完整系统（例如 音效函数/漂浮文字/泄露审计），应放到对应模块，不要继续堆在这里
-- - 这里的函数尽量保持：无复杂状态、易复用、参数清晰
local jass = require("jass.common")
local japi = require("jass.japi")
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
    local ____require_result_3 = require("系统.00．核心系统.02．音效函数")
    local Sound3DII_Mp3Play = ____require_result_3.Sound3DII_Mp3Play
    local Sound3DII_UnitPlay = ____require_result_3.Sound3DII_UnitPlay
    local ____require_result_4 = require("系统.00．核心系统.03．漂浮文字函数")
    local CreateFloatTextOnUnit = ____require_result_4.CreateFloatTextOnUnit
    if unit ~= nil then
        local txt = delta > 0 and "+" .. tostring(delta) or tostring(delta)
        CreateFloatTextOnUnit(nil, unit, txt, {red = 255, green = 215, blue = 0, alpha = 0})
        Sound3DII_UnitPlay(nil, SOUND_GOLD, unit, 1500)
    else
        Sound3DII_Mp3Play(nil, SOUND_GOLD, p)
    end
end
--- 将 4 字符字符串转换为 FourCC 数字（用于物品/单位 ID）
function ____exports.stringToFourCC(self, s)
    local b1 = string.byte(s, 1)
    local b2 = string.byte(s, 2)
    local b3 = string.byte(s, 3)
    local b4 = string.byte(s, 4)
    return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4
end
--- 将 FourCC 数字转换为 4 字符字符串
function ____exports.fourCCToString(self, fourcc)
    local c1 = string.char(fourcc % 256)
    local c2 = string.char(math.floor(fourcc / 256) % 256)
    local c3 = string.char(math.floor(fourcc / 65536) % 256)
    local c4 = string.char(math.floor(fourcc / 16777216) % 256)
    return ((c4 .. c3) .. c2) .. c1
end
--- 获取单位的攻击类型（Attack Type）
-- 单位状态0x23对应攻击类型，使用ConvertUnitState转换
function ____exports.Ir_GetUnitAttackType(self, u)
    return jass.R2I(japi.GetUnitState(
        u,
        jass.ConvertUnitState(35)
    ))
end
function ____exports.Ir_SetUnitAttackType(self, u, atp)
    japi.SetUnitState(
        u,
        jass.ConvertUnitState(35),
        atp
    )
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
    if type(jass.DisplayTimedTextToPlayer) ~= "function" then
        return
    end
    jass.DisplayTimedTextToPlayer(
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
--- 判断单位是否为"特殊单位"（召唤物/幻象），这些单位通常不触发装备等功能
function ____exports.isSpecialUnit(self, unit)
    if not unit then
        return true
    end
    if jass.UNIT_TYPE_SUMMONED ~= nil and jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED) then
        return true
    end
    if type(jass.IsUnitIllusionBJ) == "function" and jass.IsUnitIllusionBJ(unit) then
        return true
    end
    if type(jass.IsUnitIllusion) == "function" and jass.IsUnitIllusion(unit) then
        return true
    end
    return false
end
local g = require("jass.globals")
--- 判断单位是否为英雄单位
function ____exports.isHeroUnit(self, unit)
    if not unit then
        return false
    end
    local ____jass_UNIT_TYPE_HERO_5 = jass.UNIT_TYPE_HERO
    if ____jass_UNIT_TYPE_HERO_5 == nil then
        ____jass_UNIT_TYPE_HERO_5 = g.UNIT_TYPE_HERO
    end
    local utHero = ____jass_UNIT_TYPE_HERO_5
    if utHero ~= nil and type(jass.IsUnitType) == "function" then
        return jass.IsUnitType(unit, utHero) == true
    end
    if type(jass.GetHeroLevel) == "function" then
        return jass.GetHeroLevel(unit) > 0
    end
    return false
end
--- 延迟执行回调（自动创建/销毁计时器）
-- 
-- @param delaySec 延迟秒数
-- @param callback 回调函数
-- @param periodic 是否重复执行（默认 false）
-- @param name 调试用名称（可选）
-- @returns 计时器句柄（periodic=true 时可用，用于停止），不需要可忽略
function ____exports.withTimer(self, delaySec, callback, periodic, name)
    if periodic == nil then
        periodic = false
    end
    local ____this_7
    ____this_7 = jass
    local ____opt_6 = ____this_7.CreateTimer
    if ____opt_6 ~= nil then
        ____opt_6 = ____opt_6(____this_7)
    end
    local t = ____opt_6
    if not t then
        callback(nil)
        return nil
    end
    if type(jass.TimerStart) ~= "function" then
        callback(nil)
        return nil
    end
    if periodic then
        jass.TimerStart(
            t,
            delaySec,
            true,
            function()
                callback(nil)
            end
        )
    else
        jass.TimerStart(
            t,
            delaySec,
            false,
            function()
                callback(nil)
                if type(jass.DestroyTimer) == "function" then
                    jass.DestroyTimer(t)
                end
            end
        )
    end
    return t
end
--- 停止并销毁指定的周期性计时器
-- 
-- @param t 计时器句柄（withTimer 返回的）
function ____exports.stopTimer(self, t)
    if not t then
        return
    end
    if type(jass.PauseTimer) == "function" then
        jass.PauseTimer(t)
    end
    if type(jass.DestroyTimer) == "function" then
        jass.DestroyTimer(t)
    end
end
--- 创建特效并在指定时间后自动销毁（自动处理 1.27 兼容）
-- 
-- @param modelPath 特效模型路径
-- @param x x坐标
-- @param y y坐标
-- @param z z坐标（可选，默认0）
-- @param duration 持续时间秒数（默认2秒）
-- @returns 特效句柄
function ____exports.createTimedEffect(self, modelPath, x, y, z, duration)
    if z == nil then
        z = 0
    end
    if duration == nil then
        duration = 2
    end
    local eff
    if type(jass.AddSpecialEffectZ) == "function" then
        eff = jass.AddSpecialEffectZ(modelPath, x, y, z)
    elseif type(jass.AddSpecialEffect) == "function" then
        eff = jass.AddSpecialEffect(modelPath, x, y)
    end
    if not eff then
        return nil
    end
    ____exports.withTimer(
        nil,
        duration,
        function()
            if type(jass.DestroyEffect) == "function" then
                jass.DestroyEffect(eff)
            end
        end
    )
    return eff
end
--- 查找指定玩家的英雄单位
-- 
-- @param playerId 玩家索引（0-15）
-- @returns 英雄单位，如果没有找到返回 null
function ____exports.findHeroOfPlayer(self, playerId)
    if type(jass.CreateGroup) ~= "function" or type(jass.GroupEnumUnitsOfPlayer) ~= "function" then
        return nil
    end
    local group = jass.CreateGroup()
    jass.GroupEnumUnitsOfPlayer(
        group,
        jass.Player(playerId),
        nil
    )
    local unit = jass.FirstOfGroup(group)
    jass.DestroyGroup(group)
    if unit and ____exports.isHeroUnit(nil, unit) then
        return unit
    end
    return nil
end
--- 存储单位绑定的特效（key: 单位句柄ID, value: 特效句柄）
local unitEffectMap = __TS__New(Map)
--- 在单位上创建绑定特效
-- 
-- @param unit 目标单位
-- @param attachPoint 绑定点（如 "overhead", "origin", "chest" 等）
-- @param modelPath 特效模型路径
-- @param duration 持续时间（秒），不传则永久存在直到手动销毁
-- @returns 是否创建成功
function ____exports.createUnitEffect(self, unit, attachPoint, modelPath, duration)
    if not unit then
        return false
    end
    local ____japi_DzGetUnitObjectId_8
    if japi.DzGetUnitObjectId then
        ____japi_DzGetUnitObjectId_8 = japi.DzGetUnitObjectId(unit)
    else
        ____japi_DzGetUnitObjectId_8 = 0
    end
    local handleId = ____japi_DzGetUnitObjectId_8
    if not handleId then
        return false
    end
    local existingEffect = unitEffectMap:get(handleId)
    if existingEffect and type(jass.DestroyEffect) == "function" then
        jass.DestroyEffect(existingEffect)
    end
    local effect = jass.AddSpecialEffectTarget(modelPath, unit, attachPoint)
    if not effect then
        return false
    end
    unitEffectMap:set(handleId, effect)
    if duration ~= nil and duration > 0 then
        ____exports.withTimer(
            nil,
            duration,
            function()
                local currentEffect = unitEffectMap:get(handleId)
                if currentEffect == effect and type(jass.DestroyEffect) == "function" then
                    jass.DestroyEffect(effect)
                    unitEffectMap:delete(handleId)
                end
            end
        )
    end
    return true
end
--- 销毁单位上的绑定特效
-- 
-- @param unit 目标单位
function ____exports.destroyUnitEffect(self, unit)
    if not unit then
        return
    end
    local ____japi_DzGetUnitObjectId_9
    if japi.DzGetUnitObjectId then
        ____japi_DzGetUnitObjectId_9 = japi.DzGetUnitObjectId(unit)
    else
        ____japi_DzGetUnitObjectId_9 = 0
    end
    local handleId = ____japi_DzGetUnitObjectId_9
    if not handleId then
        return
    end
    local effect = unitEffectMap:get(handleId)
    if effect and type(jass.DestroyEffect) == "function" then
        jass.DestroyEffect(effect)
    end
    unitEffectMap:delete(handleId)
end
return ____exports

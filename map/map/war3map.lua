package = {}
package.path = './?.lua;./?/init.lua;./Override/?.lua;./lib/stdlib/?.lua;./lib/stdlib/?/init.lua'

local P
do
    local preloadType, preload, _errorhandler
    do
        preloadType = 'string'
        preload = load
        _errorhandler = function(msg)
            return print(msg)
        end
    end

    local _G = _G
    local package = package
    local string, table = string, table
    local error, xpcall, type, setmetatable, tostring, ipairs, load = error, xpcall, type, setmetatable, tostring,
                                                                      ipairs, load

    local _FILES = {}
    local _LOADED_MODULES = {}
    local _LOADED_FILES = {}
    local _LOADING_FILES = {}

    local function errorhandler(msg)
        if _errorhandler and msg then
            return _errorhandler(msg)
        end
    end

    local function resolvefile(module)
        module = module:gsub('[./\\]+', '/')

        for item in package.path:gmatch('[^;]+') do
            local filename = item:gsub('^%.[/\\]+', ''):gsub('%?', module)
            if _FILES[filename] then
                return filename
            end
        end
    end

    local function compilefile(filename, mode, env, level)
        local code = _FILES[filename]
        if not code then
            error(string.format('cannot open %s: No such file or directory', filename), (level or 1) + 1)
        end
        return preload(code, '@' .. filename, mode, env or _G)
    end

    
    local orgRequire = require
    

    function require(module)
        local loaded = _LOADED_MODULES[module]
        if loaded then
            return loaded
        end

        local filename = resolvefile(module)
        if not filename then
            
            if orgRequire then
                return orgRequire(module)
            end
            
            error(string.format('module \'%s\' not found', module), 2)
        end

        loaded = _LOADED_FILES[filename]
        if loaded then
            return loaded
        end

        if _LOADING_FILES[filename] then
            error('critical dependency', 2)
        end

        local f, err = compilefile(filename, nil, nil, 2)
        if not f then
            error(err, 2)
        end

        _LOADING_FILES[filename] = true
        local ok, ret = xpcall(f, errorhandler, module, filename)
        _LOADING_FILES[filename] = false
        if not ok then
            error()
        end

        ret = ret or true

        _LOADED_MODULES[module] = ret
        _LOADED_FILES[filename] = ret

        return ret
    end

    function loadfile(filename, mode, env)
        return compilefile(filename, mode, env, 2)
    end

    function dofile(filename)
        compilefile(filename, nil, nil, 2)()
    end

    function seterrorhandler(handler)
        if type(handler) ~= 'function' then
            error(string.format('bad argument #1 to `seterrorhandler` (function expected, got %s)', type(handler)), 2)
        end
        _errorhandler = handler
    end

    function geterrorhandler()
        return _errorhandler
    end

    -- hook for errorhandler
    do
        local function tryreturn(ok, ...)
            if ok then
                return ...
            end
        end

        local function generate(index, count)
            local args = {}
            for i = 1, count do
                table.insert(args, 'ARG' .. i)
            end
            args = table.concat(args, ',')

            local code = [[
local o, r, e = ...
return function({ARGS})
    if type(ARG{N}) == 'function' then
        local c = ARG{N}
        ARG{N} = function(...)
            return r(xpcall(c, e, ...))
        end
    end
    return o({ARGS})
end
]]
            code = code:gsub('{N}', tostring(index)):gsub('{ARGS}', args)

            return load(code)
        end

        local apis = {
            {'TimerStart', 4, 4}, {'ForGroup', 2, 2}, {'ForForce', 2, 2}, {'Condition', 1, 1}, {'Filter', 1, 1},
            {'EnumDestructablesInRect', 3, 3}, {'EnumItemsInRect', 3, 3}, {'TriggerAddAction', 2, 2},
        }

        for _, v in ipairs(apis) do
            local name, index, count = v[1], v[2], v[3]
            _G[name] = generate(index, count)(_G[name], tryreturn, errorhandler)
        end
    end

    P = setmetatable({}, {
        __newindex = function(t, k, v)
            if type(v) ~= preloadType then
                error('PRELOADED value must be ' .. preloadType)
            end
            _FILES[k] = v
        end,
        __index = function(t, k)
            error('Can`t read')
        end,
        __metatable = false,
    })
end

P['jass/blizzard.lua'] = [=[--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- blizzard.j 封装 - 基于 common.j 原生实现 Blizzard 辅助函数
-- 因 jass.common 仅暴露 common.j，不包含 blizzard.j
local jass = require("jass.common")
--- 游戏开始 N 秒后触发一次（对应 TriggerRegisterTimerEventSingle）
function ____exports.TriggerRegisterTimerEventSingle(self, trig, timeout)
    return jass.TriggerRegisterTimerEvent(trig, timeout, false)
end
--- 每 N 秒周期触发（对应 TriggerRegisterTimerEventPeriodic）
function ____exports.TriggerRegisterTimerEventPeriodic(self, trig, timeout)
    return jass.TriggerRegisterTimerEvent(trig, timeout, true)
end
____exports.jass = jass
return ____exports]=]

P['jass/stes_expose.lua'] = [=[--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- STES 暴露模块 - 将 JASS 的 STES_* 暴露到 _G，供 Lua 模块使用
-- 在 main 中最早加载
local jass = require("jass.common")
local g = require("jass.globals")
local DEBUG = true
local P0 = jass.Player(0)
local function dbg(self, msg)
    if DEBUG then
        jass.DisplayTimedTextToPlayer(
            P0,
            0,
            0,
            12,
            "[STES] " .. msg
        )
    end
end
local function expose(self)
    local ____jass_STES_Register_0 = jass.STES_Register
    if ____jass_STES_Register_0 == nil then
        ____jass_STES_Register_0 = g.STES_Register
    end
    local sr = ____jass_STES_Register_0
    local ____jass_STES_Trigger_1 = jass.STES_Trigger
    if ____jass_STES_Trigger_1 == nil then
        ____jass_STES_Trigger_1 = g.STES_Trigger
    end
    local st = ____jass_STES_Trigger_1
    local ____jass_STES_GetTriggerPlayer_2 = jass.STES_GetTriggerPlayer
    if ____jass_STES_GetTriggerPlayer_2 == nil then
        ____jass_STES_GetTriggerPlayer_2 = g.STES_GetTriggerPlayer
    end
    local gp = ____jass_STES_GetTriggerPlayer_2
    if type(sr) == "function" then
        _G.STES_Register = sr
        if not jass.STES_Register then
            jass.STES_Register = sr
        end
        dbg(nil, "STES_Register: 已暴露")
    else
        dbg(nil, "STES_Register: 未找到 (jass.common 无此函数)")
    end
    if type(st) == "function" then
        _G.STES_Trigger = st
        if not jass.STES_Trigger then
            jass.STES_Trigger = st
        end
        dbg(nil, "STES_Trigger: 已暴露")
    end
    if type(gp) == "function" then
        _G.STES_GetTriggerPlayer = gp
        if not jass.STES_GetTriggerPlayer then
            jass.STES_GetTriggerPlayer = gp
        end
    end
end
expose(nil)
return ____exports]=]

P['lib/init.lua'] = [=[--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lib.native")
require("lib.base")
require("lib.oop")]=]

P['lib/japi.lua'] = [=[--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local g = _G
local ____g_hjapi_1 = g.hjapi
if ____g_hjapi_1 == nil then
    local ____temp_0 = {}
    g.hjapi = ____temp_0
    ____g_hjapi_1 = ____temp_0
end
____exports.hjapi = ____g_hjapi_1
____exports.hjapi._tips = ____exports.hjapi._tips or ({})
local ____exports_hjapi__cache_3 = ____exports.hjapi._cache
if ____exports_hjapi__cache_3 == nil then
    local ____temp_2 = {
        DzLoadToc = {},
        Z = {},
        FrameTagIndex = 0,
        IsWideScreen = false,
        FrameBlackTop = 0.02,
        FrameBlackBottom = 0.13,
        FrameInnerHeight = 0.45
    }
    ____exports.hjapi._cache = ____temp_2
    ____exports_hjapi__cache_3 = ____temp_2
end
____exports.hjapi._cache = ____exports_hjapi__cache_3
____exports.hjapi.echo = function(____, msg)
    if type(msg) ~= "string" then
        return
    end
    if ____exports.hjapi._tips[msg] == nil then
        ____exports.hjapi._tips[msg] = 1
        local ____ = DEBUGGING
    end
end
____exports.hjapi.has = function(____, method)
    if type(method) ~= "string" then
        return false
    end
    local lib = JassJapi
    return not not lib and type(lib[method]) == "function"
end
____exports.hjapi.exec = function(____, method, ...)
    if type(method) ~= "string" then
        return false
    end
    local lib = JassJapi
    if not lib or type(lib[method]) ~= "function" then
        ____exports.hjapi:echo(method .. " function does not exist!")
        return false
    end
    return lib[method](lib, ...)
end
____exports.hjapi.DzAPI_Map_SaveServerValue = function(____, whichPlayer, key, value)
    return not not ____exports.hjapi:exec("DzAPI_Map_SaveServerValue", whichPlayer, key, value)
end
____exports.hjapi.DzAPI_Map_GetServerValue = function(____, whichPlayer, key)
    return ____exports.hjapi:exec("DzAPI_Map_GetServerValue", whichPlayer, key)
end
____exports.hjapi.DzAPI_Map_GetServerValueErrorCode = function(____, whichPlayer)
    return ____exports.hjapi:exec("DzAPI_Map_GetServerValueErrorCode", whichPlayer)
end
____exports.hjapi.GetPlayerServerValueSuccess = function(____, whichPlayer)
    local res = ____exports.hjapi:DzAPI_Map_GetServerValueErrorCode(whichPlayer)
    local mf = math and type(math.floor) == "function" and math.floor or nil
    local v = type(mf) == "function" and mf(nil, res) or math.floor(res)
    return v == 0
end
____exports.hjapi.DzAPI_Map_IsRPGLadder = function()
    return not not ____exports.hjapi:exec("DzAPI_Map_IsRPGLadder", nil)
end
____exports.hjapi.DzAPI_Map_IsRPGLobby = function()
    return not not ____exports.hjapi:exec("DzAPI_Map_IsRPGLobby", nil)
end
____exports.hjapi.DzAPI_Map_GetGameStartTime = function()
    return ____exports.hjapi:exec("DzAPI_Map_GetGameStartTime", nil)
end
____exports.hjapi.DzAPI_Map_GetActivityData = function()
    return ____exports.hjapi:exec("DzAPI_Map_GetActivityData", nil)
end
____exports.hjapi.DzAPI_Map_GetMatchType = function()
    return ____exports.hjapi:exec("DzAPI_Map_GetMatchType", nil)
end
____exports.hjapi.DzAPI_Map_Ladder_SetStat = function(____, whichPlayer, key, value)
    ____exports.hjapi:exec("DzAPI_Map_Ladder_SetStat", whichPlayer, key, value)
end
____exports.hjapi.DzAPI_Map_Stat_SetStat = function(____, whichPlayer, key, value)
    ____exports.hjapi:exec("DzAPI_Map_Stat_SetStat", whichPlayer, key, value)
end
____exports.hjapi.DzLoadToc = function(____, fileName)
    ____exports.hjapi:exec("DzLoadToc", fileName)
end
____exports.hjapi.DzFrameFindByName = function(____, name, id)
    return ____exports.hjapi:exec("DzFrameFindByName", name, id)
end
____exports.hjapi.DzCreateFrame = function(____, frame, parent, id)
    return ____exports.hjapi:exec("DzCreateFrame", frame, parent, id)
end
____exports.hjapi.DzCreateSimpleFrame = function(____, frame, parent, id)
    return ____exports.hjapi:exec("DzCreateSimpleFrame", frame, parent, id)
end
____exports.hjapi.DzDestroyFrame = function(____, frame)
    ____exports.hjapi:exec("DzDestroyFrame", frame)
end
____exports.hjapi.DzFrameShow = function(____, frame, enable)
    ____exports.hjapi:exec("DzFrameShow", frame, enable)
end
____exports.hjapi.DzFrameSetText = function(____, frame, text)
    ____exports.hjapi:exec("DzFrameSetText", frame, text)
end
____exports.hjapi.DzFrameGetText = function(____, frame)
    return ____exports.hjapi:exec("DzFrameGetText", frame)
end
____exports.hjapi.DzFrameSetPoint = function(____, frame, point, relativeFrame, relativePoint, x, y)
    ____exports.hjapi:exec(
        "DzFrameSetPoint",
        frame,
        point,
        relativeFrame,
        relativePoint,
        x,
        y
    )
end
____exports.hjapi.DzFrameSetAbsolutePoint = function(____, frame, point, x, y)
    ____exports.hjapi:exec(
        "DzFrameSetAbsolutePoint",
        frame,
        point,
        x,
        y
    )
end
____exports.hjapi.DzFrameClearAllPoints = function(____, frame)
    ____exports.hjapi:exec("DzFrameClearAllPoints", frame)
end
____exports.hjapi.DzFrameSetSize = function(____, frame, w, h)
    ____exports.hjapi:exec("DzFrameSetSize", frame, w, h)
end
____exports.hjapi.DzGetGameUI = function()
    return ____exports.hjapi:exec("DzGetGameUI", nil)
end
____exports.hjapi.DzGetClientWidth = function()
    return ____exports.hjapi:exec("DzGetClientWidth", nil)
end
____exports.hjapi.DzGetClientHeight = function()
    return ____exports.hjapi:exec("DzGetClientHeight", nil)
end
____exports.hjapi.DzGetMouseXRelative = function()
    return ____exports.hjapi:exec("DzGetMouseXRelative", nil)
end
____exports.hjapi.DzGetMouseYRelative = function()
    return ____exports.hjapi:exec("DzGetMouseYRelative", nil)
end
____exports.hjapi.Z = function(____, x, y)
    if type(x) == "number" and type(y) == "number" then
        local mf = math and type(math.floor) == "function" and math.floor or nil
        local xx = type(mf) == "function" and mf(nil, x) or math.floor(x)
        local yy = type(mf) == "function" and mf(nil, y) or math.floor(y)
        local k = (tostring(xx) .. "_") .. tostring(yy)
        if ____exports.hjapi._cache.Z[k] == nil then
            if not cj or type(cj.Location) ~= "function" or type(cj.GetLocationZ) ~= "function" or type(cj.RemoveLocation) ~= "function" then
                return 0
            end
            local loc = cj:Location(xx, yy)
            local z = cj:GetLocationZ(loc)
            cj:RemoveLocation(loc)
            ____exports.hjapi._cache.Z[k] = z
        end
        return ____exports.hjapi._cache.Z[k]
    end
    return 0
end
____exports.hjapi.PX = function(____, x)
    return ____exports.hjapi:DzGetClientWidth() * x / 0.8
end
____exports.hjapi.PY = function(____, y)
    return ____exports.hjapi:DzGetClientHeight() * y / 0.6
end
____exports.hjapi.RX = function(____, x)
    return x / ____exports.hjapi:DzGetClientWidth() * 0.8
end
____exports.hjapi.RY = function(____, y)
    return y / ____exports.hjapi:DzGetClientHeight() * 0.6
end
____exports.hjapi.MousePX = function()
    return ____exports.hjapi:DzGetMouseXRelative()
end
____exports.hjapi.MousePY = function()
    return ____exports.hjapi:DzGetClientHeight() - ____exports.hjapi:DzGetMouseYRelative()
end
____exports.hjapi.MouseRX = function()
    return ____exports.hjapi:RX(____exports.hjapi:MousePX())
end
____exports.hjapi.MouseRY = function()
    return ____exports.hjapi:RY(____exports.hjapi:MousePY())
end
____exports.hjapi.InWindow = function(____, rx, ry)
    return rx > 0 and rx < 0.8 and ry > 0 and ry < 0.6
end
____exports.hjapi.InWindowMouse = function()
    return ____exports.hjapi:InWindow(
        ____exports.hjapi:MouseRX(),
        ____exports.hjapi:MouseRY()
    )
end
local AUTO_METHODS = {
    "DzAPI_Map_ChangeStoreItemCoolDown",
    "DzAPI_Map_ChangeStoreItemCount",
    "DzAPI_Map_GetActivityData",
    "DzAPI_Map_GetGameStartTime",
    "DzAPI_Map_GetGuildName",
    "DzAPI_Map_GetGuildRole",
    "DzAPI_Map_GetLadderLevel",
    "DzAPI_Map_GetLadderRank",
    "DzAPI_Map_GetMapConfig",
    "DzAPI_Map_GetMapLevel",
    "DzAPI_Map_GetMapLevelRank",
    "DzAPI_Map_GetMatchType",
    "DzAPI_Map_GetPlatformVIP",
    "DzAPI_Map_GetPublicArchive",
    "DzAPI_Map_GetServerArchiveDrop",
    "DzAPI_Map_GetServerArchiveEquip",
    "DzAPI_Map_GetServerValue",
    "DzAPI_Map_GetServerValueErrorCode",
    "GetPlayerServerValueSuccess",
    "DzAPI_Map_GetUserID",
    "DzAPI_Map_HasMallItem",
    "DzAPI_Map_IsBlueVIP",
    "DzAPI_Map_IsRPGLadder",
    "DzAPI_Map_IsRPGLobby",
    "DzAPI_Map_IsRedVIP",
    "DzAPI_Map_Ladder_SetPlayerStat",
    "DzAPI_Map_Ladder_SubmitPlayerRank",
    "DzAPI_Map_Ladder_SetStat",
    "DzAPI_Map_Ladder_SubmitTitle",
    "DzAPI_Map_Ladder_SubmitPlayerExtraExp",
    "DzAPI_Map_MissionComplete",
    "DzAPI_Map_OrpgTrigger",
    "DzAPI_Map_SavePublicArchive",
    "DzAPI_Map_SaveServerValue",
    "DzAPI_Map_Stat_SetStat",
    "DzAPI_Map_Statistics",
    "DzAPI_Map_ToggleStore",
    "DzAPI_Map_UpdatePlayerHero",
    "DzAPI_Map_UseConsumablesItem",
    "DzClickFrame",
    "DzConvertWorldPosition",
    "DzCreateFrame",
    "DzCreateFrameByTagName",
    "FrameTag",
    "DzCreateSimpleFrame",
    "DzDestroyFrame",
    "DzDestructablePosition",
    "DzEnableWideScreen",
    "DzExecuteFunc",
    "DzFrameCageMouse",
    "DzFrameClearAllPoints",
    "DzFrameEditBlackBorders",
    "DzFrameFindByName",
    "DzFrameGetAlpha",
    "DzFrameGetChatMessage",
    "DzFrameGetCommandBarButton",
    "DzFrameGetEnable",
    "DzFrameGetHeight",
    "DzFrameGetHeroBarButton",
    "DzFrameGetHeroHPBar",
    "DzFrameGetHeroManaBar",
    "DzFrameGetItemBarButton",
    "DzFrameGetMinimap",
    "DzFrameGetMinimapButton",
    "DzFrameGetName",
    "DzFrameGetParent",
    "DzFrameGetPortrait",
    "DzFrameGetText",
    "DzFrameGetTextSizeLimit",
    "DzFrameGetTooltip",
    "DzFrameGetTopMessage",
    "DzFrameGetUnitMessage",
    "DzFrameGetUpperButtonBarButton",
    "DzFrameGetValue",
    "DzFrameHideInterface",
    "DzFrameSetAbsolutePoint",
    "DzFrameSetAllPoints",
    "DzFrameSetAlpha",
    "DzFrameSetAnimate",
    "DzFrameSetAnimateOffset",
    "DzFrameSetEnable",
    "DzFrameSetFocus",
    "DzFrameSetFont",
    "DzFrameSetMinMaxValue",
    "DzFrameSetModel",
    "DzFrameSetParent",
    "DzFrameSetPoint",
    "FrameRelation",
    "DzFrameSetPriority",
    "DzFrameSetScale",
    "DzFrameSetScript",
    "DzFrameSetScriptByCode",
    "DzFrameSetSize",
    "DzFrameSetStepValue",
    "DzFrameSetText",
    "DzFrameSetTextAlignment",
    "DzFrameSetTextColor",
    "DzFrameSetTextSizeLimit",
    "DzFrameSetTexture",
    "DzFrameSetTooltip",
    "DzFrameSetUpdateCallback",
    "DzFrameSetUpdateCallbackByCode",
    "DzFrameSetValue",
    "DzFrameSetVertexColor",
    "DzFrameShow",
    "DzGetClientHeight",
    "DzGetClientWidth",
    "DzGetColor",
    "DzGetConvertWorldPositionX",
    "DzGetConvertWorldPositionY",
    "DzGetGameMode",
    "DzGetGameUI",
    "DzGetLocale",
    "DzGetMouseFocus",
    "DzGetMouseTerrainX",
    "DzGetMouseTerrainY",
    "DzGetMouseTerrainZ",
    "DzGetMouseX",
    "DzGetMouseXRelative",
    "DzGetMouseY",
    "DzGetMouseYRelative",
    "DzGetPlayerInitGold",
    "DzGetPlayerName",
    "DzGetPlayerSelectedHero",
    "DzGetTriggerKey",
    "DzGetTriggerKeyPlayer",
    "DzGetTriggerSyncData",
    "DzGetTriggerSyncPlayer",
    "DzGetTriggerUIEventFrame",
    "DzGetTriggerUIEventPlayer",
    "DzGetUnitNeededXP",
    "DzGetUnitUnderMouse",
    "DzGetWheelDelta",
    "DzGetWindowHeight",
    "DzGetWindowWidth",
    "DzGetWindowX",
    "DzGetWindowY",
    "DzIsKeyDown",
    "DzIsMouseOverUI",
    "DzIsWindowActive",
    "DzLoadToc",
    "DzOriginalUIAutoResetPoint",
    "DzSetCustomFovFix",
    "DzSetMemory",
    "DzSetMousePos",
    "DzSetUnitID",
    "DzSetUnitModel",
    "DzSetUnitPosition",
    "DzSetUnitTexture",
    "DzSetWar3MapMap",
    "DzSimpleFontStringFindByName",
    "DzSimpleFrameFindByName",
    "DzSimpleTextureFindByName",
    "DzSyncBuffer",
    "DzSyncData",
    "DzSyncDataImmediately",
    "DzTriggerRegisterKeyEvent",
    "DzTriggerRegisterKeyEventByCode",
    "DzTriggerRegisterMouseEvent",
    "DzTriggerRegisterMouseEventByCode",
    "DzTriggerRegisterMouseMoveEvent",
    "DzTriggerRegisterMouseMoveEventByCode",
    "DzTriggerRegisterMouseWheelEvent",
    "DzTriggerRegisterMouseWheelEventByCode",
    "DzTriggerRegisterSyncData",
    "DzTriggerRegisterWindowResizeEvent",
    "DzTriggerRegisterWindowResizeEventByCode",
    "DzUnitDisableAttack",
    "DzUnitDisableInventory",
    "DzUnitLearningSkill",
    "DzUnitSilence",
    "EXBlendButtonIcon",
    "EXDclareButtonIcon",
    "EXDisplayChat",
    "EXEffectMatReset",
    "EXEffectMatRotateX",
    "EXEffectMatRotateY",
    "EXEffectMatRotateZ",
    "EXEffectMatScale",
    "EXExecuteScript",
    "EXGetAbilityDataInteger",
    "EXGetAbilityDataReal",
    "EXGetAbilityDataString",
    "EXGetAbilityId",
    "EXGetAbilityState",
    "EXGetAbilityString",
    "EXGetBuffDataString",
    "EXGetEffectSize",
    "EXGetEffectX",
    "EXGetEffectY",
    "EXGetEffectZ",
    "EXGetEventDamageData",
    "EXGetItemDataString",
    "EXGetUnitAbility",
    "EXGetUnitAbilityByIndex",
    "EXGetUnitArrayString",
    "EXGetUnitInteger",
    "EXGetUnitReal",
    "EXGetUnitString",
    "EXPauseUnit",
    "UnitAddSwim",
    "UnitRemoveSwim",
    "EXSetAbilityAEmeDataA",
    "EXSetAbilityDataInteger",
    "EXSetAbilityDataReal",
    "EXSetAbilityDataString",
    "EXSetAbilityState",
    "EXSetAbilityString",
    "EXSetBuffDataString",
    "EXSetEffectSize",
    "EXSetEffectSpeed",
    "EXSetEffectXY",
    "EXSetEffectZ",
    "EXSetEventDamage",
    "EXSetItemDataString",
    "EXSetUnitArrayString",
    "EXSetUnitCollisionType",
    "EXSetUnitFacing",
    "EXSetUnitInteger",
    "EXSetUnitMoveType",
    "EXSetUnitReal",
    "EXSetUnitString",
    "GetEventDamage",
    "GetUnitState",
    "RequestExtraBooleanData",
    "RequestExtraIntegerData",
    "RequestExtraRealData",
    "RequestExtraStringData",
    "SetUnitState",
    "DzAPI_Map_IsPlatformVIP",
    "DzTriggerRegisterMallItemSyncData",
    "DzAPI_Map_Global_ChangeMsg",
    "DzAPI_Map_IsRPGQuickMatch",
    "DzAPI_Map_GetMallItemCount",
    "DzAPI_Map_ConsumeMallItem",
    "DzAPI_Map_EnablePlatformSettings",
    "DzAPI_Map_IsBuyReforged",
    "DzAPI_Map_PlayedGames",
    "DzAPI_Map_CommentCount",
    "DzAPI_Map_FriendCount",
    "DzAPI_Map_IsConnoisseur",
    "DzAPI_Map_IsBattleNetAccount",
    "DzAPI_Map_IsAuthor",
    "DzAPI_Map_CommentTotalCount",
    "DzAPI_Map_CustomRanking",
    "DzAPI_Map_IsPlatformReturn",
    "DzAPI_Map_IsMapReturn",
    "DzAPI_Map_IsPlatformReturnUsed",
    "DzAPI_Map_IsMapReturnUsed",
    "DzAPI_Map_IsCollected",
    "DzAPI_Map_ContinuousCount",
    "DzAPI_Map_IsPlayer",
    "DzAPI_Map_MapsTotalPlayed",
    "DzAPI_Map_MapsLevel",
    "DzAPI_Map_MapsConsumeGold",
    "DzAPI_Map_MapsConsumeLumber",
    "DzAPI_Map_MapsConsume_1_199",
    "DzAPI_Map_MapsConsume_200_499",
    "DzAPI_Map_MapsConsume_500_999",
    "DzAPI_Map_MapsConsume_1000",
    "DzAPI_Map_GetForumData",
    "DzAPI_Map_OpenMall",
    "GetFrameBorders",
    "IsWideScreen",
    "IsEventPhysicalDamage",
    "IsEventAttackDamage",
    "IsEventRangedDamage",
    "IsEventDamageType",
    "IsEventWeaponType",
    "IsEventAttackType"
}
do
    local i = 0
    while i < #AUTO_METHODS do
        local name = AUTO_METHODS[i + 1]
        if type(____exports.hjapi[name]) ~= "function" then
            ____exports.hjapi[name] = function(____, ...) return ____exports.hjapi:exec(name, ...) end
        end
        i = i + 1
    end
end
____exports.default = ____exports.hjapi
return ____exports]=]

P['lualib_bundle.lua'] = [=[local function __TS__ArrayAt(self, relativeIndex)
    local absoluteIndex = relativeIndex < 0 and #self + relativeIndex or relativeIndex
    if absoluteIndex >= 0 and absoluteIndex < #self then
        return self[absoluteIndex + 1]
    end
    return nil
end

local function __TS__ArrayIsArray(value)
    return type(value) == "table" and (value[1] ~= nil or next(value) == nil)
end

local function __TS__ArrayConcat(self, ...)
    local items = {...}
    local result = {}
    local len = 0
    for i = 1, #self do
        len = len + 1
        result[len] = self[i]
    end
    for i = 1, #items do
        local item = items[i]
        if __TS__ArrayIsArray(item) then
            for j = 1, #item do
                len = len + 1
                result[len] = item[j]
            end
        else
            len = len + 1
            result[len] = item
        end
    end
    return result
end

local __TS__Symbol, Symbol
do
    local symbolMetatable = {__tostring = function(self)
        return ("Symbol(" .. (self.description or "")) .. ")"
    end}
    function __TS__Symbol(description)
        return setmetatable({description = description}, symbolMetatable)
    end
    Symbol = {
        asyncDispose = __TS__Symbol("Symbol.asyncDispose"),
        dispose = __TS__Symbol("Symbol.dispose"),
        iterator = __TS__Symbol("Symbol.iterator"),
        hasInstance = __TS__Symbol("Symbol.hasInstance"),
        species = __TS__Symbol("Symbol.species"),
        toStringTag = __TS__Symbol("Symbol.toStringTag")
    }
end

local function __TS__ArrayEntries(array)
    local key = 0
    return {
        [Symbol.iterator] = function(self)
            return self
        end,
        next = function(self)
            local result = {done = array[key + 1] == nil, value = {key, array[key + 1]}}
            key = key + 1
            return result
        end
    }
end

local function __TS__ArrayEvery(self, callbackfn, thisArg)
    for i = 1, #self do
        if not callbackfn(thisArg, self[i], i - 1, self) then
            return false
        end
    end
    return true
end

local function __TS__ArrayFill(self, value, start, ____end)
    local relativeStart = start or 0
    local relativeEnd = ____end or #self
    if relativeStart < 0 then
        relativeStart = relativeStart + #self
    end
    if relativeEnd < 0 then
        relativeEnd = relativeEnd + #self
    end
    do
        local i = relativeStart
        while i < relativeEnd do
            self[i + 1] = value
            i = i + 1
        end
    end
    return self
end

local function __TS__ArrayFilter(self, callbackfn, thisArg)
    local result = {}
    local len = 0
    for i = 1, #self do
        if callbackfn(thisArg, self[i], i - 1, self) then
            len = len + 1
            result[len] = self[i]
        end
    end
    return result
end

local function __TS__ArrayForEach(self, callbackFn, thisArg)
    for i = 1, #self do
        callbackFn(thisArg, self[i], i - 1, self)
    end
end

local function __TS__ArrayFind(self, predicate, thisArg)
    for i = 1, #self do
        local elem = self[i]
        if predicate(thisArg, elem, i - 1, self) then
            return elem
        end
    end
    return nil
end

local function __TS__ArrayFindIndex(self, callbackFn, thisArg)
    for i = 1, #self do
        if callbackFn(thisArg, self[i], i - 1, self) then
            return i - 1
        end
    end
    return -1
end

local __TS__Iterator
do
    local function iteratorGeneratorStep(self)
        local co = self.____coroutine
        local status, value = coroutine.resume(co)
        if not status then
            error(value, 0)
        end
        if coroutine.status(co) == "dead" then
            return
        end
        return true, value
    end
    local function iteratorIteratorStep(self)
        local result = self:next()
        if result.done then
            return
        end
        return true, result.value
    end
    local function iteratorStringStep(self, index)
        index = index + 1
        if index > #self then
            return
        end
        return index, string.sub(self, index, index)
    end
    function __TS__Iterator(iterable)
        if type(iterable) == "string" then
            return iteratorStringStep, iterable, 0
        elseif iterable.____coroutine ~= nil then
            return iteratorGeneratorStep, iterable
        elseif iterable[Symbol.iterator] then
            local iterator = iterable[Symbol.iterator](iterable)
            return iteratorIteratorStep, iterator
        else
            return ipairs(iterable)
        end
    end
end

local __TS__ArrayFrom
do
    local function arrayLikeStep(self, index)
        index = index + 1
        if index > self.length then
            return
        end
        return index, self[index]
    end
    local function arrayLikeIterator(arr)
        if type(arr.length) == "number" then
            return arrayLikeStep, arr, 0
        end
        return __TS__Iterator(arr)
    end
    function __TS__ArrayFrom(arrayLike, mapFn, thisArg)
        local result = {}
        if mapFn == nil then
            for ____, v in arrayLikeIterator(arrayLike) do
                result[#result + 1] = v
            end
        else
            local i = 0
            for ____, v in arrayLikeIterator(arrayLike) do
                local ____mapFn_3 = mapFn
                local ____thisArg_1 = thisArg
                local ____v_2 = v
                local ____i_0 = i
                i = ____i_0 + 1
                result[#result + 1] = ____mapFn_3(____thisArg_1, ____v_2, ____i_0)
            end
        end
        return result
    end
end

local function __TS__ArrayIncludes(self, searchElement, fromIndex)
    if fromIndex == nil then
        fromIndex = 0
    end
    local len = #self
    local k = fromIndex
    if fromIndex < 0 then
        k = len + fromIndex
    end
    if k < 0 then
        k = 0
    end
    for i = k + 1, len do
        if self[i] == searchElement then
            return true
        end
    end
    return false
end

local function __TS__ArrayIndexOf(self, searchElement, fromIndex)
    if fromIndex == nil then
        fromIndex = 0
    end
    local len = #self
    if len == 0 then
        return -1
    end
    if fromIndex >= len then
        return -1
    end
    if fromIndex < 0 then
        fromIndex = len + fromIndex
        if fromIndex < 0 then
            fromIndex = 0
        end
    end
    for i = fromIndex + 1, len do
        if self[i] == searchElement then
            return i - 1
        end
    end
    return -1
end

local function __TS__ArrayJoin(self, separator)
    if separator == nil then
        separator = ","
    end
    local parts = {}
    for i = 1, #self do
        parts[i] = tostring(self[i])
    end
    return table.concat(parts, separator)
end

local function __TS__ArrayMap(self, callbackfn, thisArg)
    local result = {}
    for i = 1, #self do
        result[i] = callbackfn(thisArg, self[i], i - 1, self)
    end
    return result
end

local function __TS__ArrayPush(self, ...)
    local items = {...}
    local len = #self
    for i = 1, #items do
        len = len + 1
        self[len] = items[i]
    end
    return len
end

local function __TS__ArrayPushArray(self, items)
    local len = #self
    for i = 1, #items do
        len = len + 1
        self[len] = items[i]
    end
    return len
end

local function __TS__CountVarargs(...)
    return select("#", ...)
end

local function __TS__ArrayReduce(self, callbackFn, ...)
    local len = #self
    local k = 0
    local accumulator = nil
    if __TS__CountVarargs(...) ~= 0 then
        accumulator = ...
    elseif len > 0 then
        accumulator = self[1]
        k = 1
    else
        error("Reduce of empty array with no initial value", 0)
    end
    for i = k + 1, len do
        accumulator = callbackFn(
            nil,
            accumulator,
            self[i],
            i - 1,
            self
        )
    end
    return accumulator
end

local function __TS__ArrayReduceRight(self, callbackFn, ...)
    local len = #self
    local k = len - 1
    local accumulator = nil
    if __TS__CountVarargs(...) ~= 0 then
        accumulator = ...
    elseif len > 0 then
        accumulator = self[k + 1]
        k = k - 1
    else
        error("Reduce of empty array with no initial value", 0)
    end
    for i = k + 1, 1, -1 do
        accumulator = callbackFn(
            nil,
            accumulator,
            self[i],
            i - 1,
            self
        )
    end
    return accumulator
end

local function __TS__ArrayReverse(self)
    local i = 1
    local j = #self
    while i < j do
        local temp = self[j]
        self[j] = self[i]
        self[i] = temp
        i = i + 1
        j = j - 1
    end
    return self
end

local function __TS__ArrayUnshift(self, ...)
    local items = {...}
    local numItemsToInsert = #items
    if numItemsToInsert == 0 then
        return #self
    end
    for i = #self, 1, -1 do
        self[i + numItemsToInsert] = self[i]
    end
    for i = 1, numItemsToInsert do
        self[i] = items[i]
    end
    return #self
end

local function __TS__ArraySort(self, compareFn)
    if compareFn ~= nil then
        table.sort(
            self,
            function(a, b) return compareFn(nil, a, b) < 0 end
        )
    else
        table.sort(self)
    end
    return self
end

local function __TS__ArraySlice(self, first, last)
    local len = #self
    first = first or 0
    if first < 0 then
        first = len + first
        if first < 0 then
            first = 0
        end
    else
        if first > len then
            first = len
        end
    end
    last = last or len
    if last < 0 then
        last = len + last
        if last < 0 then
            last = 0
        end
    else
        if last > len then
            last = len
        end
    end
    local out = {}
    first = first + 1
    last = last + 1
    local n = 1
    while first < last do
        out[n] = self[first]
        first = first + 1
        n = n + 1
    end
    return out
end

local function __TS__ArraySome(self, callbackfn, thisArg)
    for i = 1, #self do
        if callbackfn(thisArg, self[i], i - 1, self) then
            return true
        end
    end
    return false
end

local function __TS__ArraySplice(self, ...)
    local args = {...}
    local len = #self
    local actualArgumentCount = __TS__CountVarargs(...)
    local start = args[1]
    local deleteCount = args[2]
    if start < 0 then
        start = len + start
        if start < 0 then
            start = 0
        end
    elseif start > len then
        start = len
    end
    local itemCount = actualArgumentCount - 2
    if itemCount < 0 then
        itemCount = 0
    end
    local actualDeleteCount
    if actualArgumentCount == 0 then
        actualDeleteCount = 0
    elseif actualArgumentCount == 1 then
        actualDeleteCount = len - start
    else
        actualDeleteCount = deleteCount or 0
        if actualDeleteCount < 0 then
            actualDeleteCount = 0
        end
        if actualDeleteCount > len - start then
            actualDeleteCount = len - start
        end
    end
    local out = {}
    for k = 1, actualDeleteCount do
        local from = start + k
        if self[from] ~= nil then
            out[k] = self[from]
        end
    end
    if itemCount < actualDeleteCount then
        for k = start + 1, len - actualDeleteCount do
            local from = k + actualDeleteCount
            local to = k + itemCount
            if self[from] then
                self[to] = self[from]
            else
                self[to] = nil
            end
        end
        for k = len - actualDeleteCount + itemCount + 1, len do
            self[k] = nil
        end
    elseif itemCount > actualDeleteCount then
        for k = len - actualDeleteCount, start + 1, -1 do
            local from = k + actualDeleteCount
            local to = k + itemCount
            if self[from] then
                self[to] = self[from]
            else
                self[to] = nil
            end
        end
    end
    local j = start + 1
    for i = 3, actualArgumentCount do
        self[j] = args[i]
        j = j + 1
    end
    for k = #self, len - actualDeleteCount + itemCount + 1, -1 do
        self[k] = nil
    end
    return out
end

local function __TS__ArrayToObject(self)
    local object = {}
    for i = 1, #self do
        object[i - 1] = self[i]
    end
    return object
end

local function __TS__ArrayFlat(self, depth)
    if depth == nil then
        depth = 1
    end
    local result = {}
    local len = 0
    for i = 1, #self do
        local value = self[i]
        if depth > 0 and __TS__ArrayIsArray(value) then
            local toAdd
            if depth == 1 then
                toAdd = value
            else
                toAdd = __TS__ArrayFlat(value, depth - 1)
            end
            for j = 1, #toAdd do
                local val = toAdd[j]
                len = len + 1
                result[len] = val
            end
        else
            len = len + 1
            result[len] = value
        end
    end
    return result
end

local function __TS__ArrayFlatMap(self, callback, thisArg)
    local result = {}
    local len = 0
    for i = 1, #self do
        local value = callback(thisArg, self[i], i - 1, self)
        if __TS__ArrayIsArray(value) then
            for j = 1, #value do
                len = len + 1
                result[len] = value[j]
            end
        else
            len = len + 1
            result[len] = value
        end
    end
    return result
end

local function __TS__ArraySetLength(self, length)
    if length < 0 or length ~= length or length == math.huge or math.floor(length) ~= length then
        error(
            "invalid array length: " .. tostring(length),
            0
        )
    end
    for i = length + 1, #self do
        self[i] = nil
    end
    return length
end

local __TS__Unpack = table.unpack or unpack

local function __TS__ArrayToReversed(self)
    local copy = {__TS__Unpack(self)}
    __TS__ArrayReverse(copy)
    return copy
end

local function __TS__ArrayToSorted(self, compareFn)
    local copy = {__TS__Unpack(self)}
    __TS__ArraySort(copy, compareFn)
    return copy
end

local function __TS__ArrayToSpliced(self, start, deleteCount, ...)
    local copy = {__TS__Unpack(self)}
    __TS__ArraySplice(copy, start, deleteCount, ...)
    return copy
end

local function __TS__ArrayWith(self, index, value)
    local copy = {__TS__Unpack(self)}
    copy[index + 1] = value
    return copy
end

local function __TS__New(target, ...)
    local instance = setmetatable({}, target.prototype)
    instance:____constructor(...)
    return instance
end

local function __TS__InstanceOf(obj, classTbl)
    if type(classTbl) ~= "table" then
        error("Right-hand side of 'instanceof' is not an object", 0)
    end
    if classTbl[Symbol.hasInstance] ~= nil then
        return not not classTbl[Symbol.hasInstance](classTbl, obj)
    end
    if type(obj) == "table" then
        local luaClass = obj.constructor
        while luaClass ~= nil do
            if luaClass == classTbl then
                return true
            end
            luaClass = luaClass.____super
        end
    end
    return false
end

local function __TS__Class(self)
    local c = {prototype = {}}
    c.prototype.__index = c.prototype
    c.prototype.constructor = c
    return c
end

local __TS__Promise
do
    local function makeDeferredPromiseFactory()
        local resolve
        local reject
        local function executor(____, res, rej)
            resolve = res
            reject = rej
        end
        return function()
            local promise = __TS__New(__TS__Promise, executor)
            return promise, resolve, reject
        end
    end
    local makeDeferredPromise = makeDeferredPromiseFactory()
    local function isPromiseLike(value)
        return __TS__InstanceOf(value, __TS__Promise)
    end
    local function doNothing(self)
    end
    local ____pcall = _G.pcall
    __TS__Promise = __TS__Class()
    __TS__Promise.name = "__TS__Promise"
    function __TS__Promise.prototype.____constructor(self, executor)
        self.state = 0
        self.fulfilledCallbacks = {}
        self.rejectedCallbacks = {}
        self.finallyCallbacks = {}
        local success, ____error = ____pcall(
            executor,
            nil,
            function(____, v) return self:resolve(v) end,
            function(____, err) return self:reject(err) end
        )
        if not success then
            self:reject(____error)
        end
    end
    function __TS__Promise.resolve(value)
        if __TS__InstanceOf(value, __TS__Promise) then
            return value
        end
        local promise = __TS__New(__TS__Promise, doNothing)
        promise.state = 1
        promise.value = value
        return promise
    end
    function __TS__Promise.reject(reason)
        local promise = __TS__New(__TS__Promise, doNothing)
        promise.state = 2
        promise.rejectionReason = reason
        return promise
    end
    __TS__Promise.prototype["then"] = function(self, onFulfilled, onRejected)
        local promise, resolve, reject = makeDeferredPromise()
        self:addCallbacks(
            onFulfilled and self:createPromiseResolvingCallback(onFulfilled, resolve, reject) or resolve,
            onRejected and self:createPromiseResolvingCallback(onRejected, resolve, reject) or reject
        )
        return promise
    end
    function __TS__Promise.prototype.addCallbacks(self, fulfilledCallback, rejectedCallback)
        if self.state == 1 then
            return fulfilledCallback(nil, self.value)
        end
        if self.state == 2 then
            return rejectedCallback(nil, self.rejectionReason)
        end
        local ____self_fulfilledCallbacks_0 = self.fulfilledCallbacks
        ____self_fulfilledCallbacks_0[#____self_fulfilledCallbacks_0 + 1] = fulfilledCallback
        local ____self_rejectedCallbacks_1 = self.rejectedCallbacks
        ____self_rejectedCallbacks_1[#____self_rejectedCallbacks_1 + 1] = rejectedCallback
    end
    function __TS__Promise.prototype.catch(self, onRejected)
        return self["then"](self, nil, onRejected)
    end
    function __TS__Promise.prototype.finally(self, onFinally)
        if onFinally then
            local ____self_finallyCallbacks_2 = self.finallyCallbacks
            ____self_finallyCallbacks_2[#____self_finallyCallbacks_2 + 1] = onFinally
            if self.state ~= 0 then
                onFinally(nil)
            end
        end
        return self
    end
    function __TS__Promise.prototype.resolve(self, value)
        if isPromiseLike(value) then
            return value:addCallbacks(
                function(____, v) return self:resolve(v) end,
                function(____, err) return self:reject(err) end
            )
        end
        if self.state == 0 then
            self.state = 1
            self.value = value
            return self:invokeCallbacks(self.fulfilledCallbacks, value)
        end
    end
    function __TS__Promise.prototype.reject(self, reason)
        if self.state == 0 then
            self.state = 2
            self.rejectionReason = reason
            return self:invokeCallbacks(self.rejectedCallbacks, reason)
        end
    end
    function __TS__Promise.prototype.invokeCallbacks(self, callbacks, value)
        local callbacksLength = #callbacks
        local finallyCallbacks = self.finallyCallbacks
        local finallyCallbacksLength = #finallyCallbacks
        if callbacksLength ~= 0 then
            for i = 1, callbacksLength - 1 do
                callbacks[i](callbacks, value)
            end
            if finallyCallbacksLength == 0 then
                return callbacks[callbacksLength](callbacks, value)
            end
            callbacks[callbacksLength](callbacks, value)
        end
        if finallyCallbacksLength ~= 0 then
            for i = 1, finallyCallbacksLength - 1 do
                finallyCallbacks[i](finallyCallbacks)
            end
            return finallyCallbacks[finallyCallbacksLength](finallyCallbacks)
        end
    end
    function __TS__Promise.prototype.createPromiseResolvingCallback(self, f, resolve, reject)
        return function(____, value)
            local success, resultOrError = ____pcall(f, nil, value)
            if not success then
                return reject(nil, resultOrError)
            end
            return self:handleCallbackValue(resultOrError, resolve, reject)
        end
    end
    function __TS__Promise.prototype.handleCallbackValue(self, value, resolve, reject)
        if isPromiseLike(value) then
            local nextpromise = value
            if nextpromise.state == 1 then
                return resolve(nil, nextpromise.value)
            elseif nextpromise.state == 2 then
                return reject(nil, nextpromise.rejectionReason)
            else
                return nextpromise:addCallbacks(resolve, reject)
            end
        else
            return resolve(nil, value)
        end
    end
end

local __TS__AsyncAwaiter, __TS__Await
do
    local ____coroutine = _G.coroutine or ({})
    local cocreate = ____coroutine.create
    local coresume = ____coroutine.resume
    local costatus = ____coroutine.status
    local coyield = ____coroutine.yield
    function __TS__AsyncAwaiter(generator)
        return __TS__New(
            __TS__Promise,
            function(____, resolve, reject)
                local fulfilled, step, resolved, asyncCoroutine
                function fulfilled(self, value)
                    local success, resultOrError = coresume(asyncCoroutine, value)
                    if success then
                        return step(resultOrError)
                    end
                    return reject(nil, resultOrError)
                end
                function step(result)
                    if resolved then
                        return
                    end
                    if costatus(asyncCoroutine) == "dead" then
                        return resolve(nil, result)
                    end
                    return __TS__Promise.resolve(result):addCallbacks(fulfilled, reject)
                end
                resolved = false
                asyncCoroutine = cocreate(generator)
                local success, resultOrError = coresume(
                    asyncCoroutine,
                    function(____, v)
                        resolved = true
                        return __TS__Promise.resolve(v):addCallbacks(resolve, reject)
                    end
                )
                if success then
                    return step(resultOrError)
                else
                    return reject(nil, resultOrError)
                end
            end
        )
    end
    function __TS__Await(thing)
        return coyield(thing)
    end
end

local function __TS__ClassExtends(target, base)
    target.____super = base
    local staticMetatable = setmetatable({__index = base}, base)
    setmetatable(target, staticMetatable)
    local baseMetatable = getmetatable(base)
    if baseMetatable then
        if type(baseMetatable.__index) == "function" then
            staticMetatable.__index = baseMetatable.__index
        end
        if type(baseMetatable.__newindex) == "function" then
            staticMetatable.__newindex = baseMetatable.__newindex
        end
    end
    setmetatable(target.prototype, base.prototype)
    if type(base.prototype.__index) == "function" then
        target.prototype.__index = base.prototype.__index
    end
    if type(base.prototype.__newindex) == "function" then
        target.prototype.__newindex = base.prototype.__newindex
    end
    if type(base.prototype.__tostring) == "function" then
        target.prototype.__tostring = base.prototype.__tostring
    end
end

local function __TS__CloneDescriptor(____bindingPattern0)
    local value
    local writable
    local set
    local get
    local configurable
    local enumerable
    enumerable = ____bindingPattern0.enumerable
    configurable = ____bindingPattern0.configurable
    get = ____bindingPattern0.get
    set = ____bindingPattern0.set
    writable = ____bindingPattern0.writable
    value = ____bindingPattern0.value
    local descriptor = {enumerable = enumerable == true, configurable = configurable == true}
    local hasGetterOrSetter = get ~= nil or set ~= nil
    local hasValueOrWritableAttribute = writable ~= nil or value ~= nil
    if hasGetterOrSetter and hasValueOrWritableAttribute then
        error("Invalid property descriptor. Cannot both specify accessors and a value or writable attribute.", 0)
    end
    if get or set then
        descriptor.get = get
        descriptor.set = set
    else
        descriptor.value = value
        descriptor.writable = writable == true
    end
    return descriptor
end

local function __TS__Decorate(self, originalValue, decorators, context)
    local result = originalValue
    do
        local i = #decorators
        while i >= 0 do
            local decorator = decorators[i + 1]
            if decorator ~= nil then
                local ____decorator_result_0 = decorator(self, result, context)
                if ____decorator_result_0 == nil then
                    ____decorator_result_0 = result
                end
                result = ____decorator_result_0
            end
            i = i - 1
        end
    end
    return result
end

local function __TS__ObjectAssign(target, ...)
    local sources = {...}
    for i = 1, #sources do
        local source = sources[i]
        for key in pairs(source) do
            target[key] = source[key]
        end
    end
    return target
end

local function __TS__ObjectGetOwnPropertyDescriptor(object, key)
    local metatable = getmetatable(object)
    if not metatable then
        return
    end
    if not rawget(metatable, "_descriptors") then
        return
    end
    return rawget(metatable, "_descriptors")[key]
end

local __TS__DescriptorGet
do
    local getmetatable = _G.getmetatable
    local ____rawget = _G.rawget
    function __TS__DescriptorGet(self, metatable, key)
        while metatable do
            local rawResult = ____rawget(metatable, key)
            if rawResult ~= nil then
                return rawResult
            end
            local descriptors = ____rawget(metatable, "_descriptors")
            if descriptors then
                local descriptor = descriptors[key]
                if descriptor ~= nil then
                    if descriptor.get then
                        return descriptor.get(self)
                    end
                    return descriptor.value
                end
            end
            metatable = getmetatable(metatable)
        end
    end
end

local __TS__DescriptorSet
do
    local getmetatable = _G.getmetatable
    local ____rawget = _G.rawget
    local rawset = _G.rawset
    function __TS__DescriptorSet(self, metatable, key, value)
        while metatable do
            local descriptors = ____rawget(metatable, "_descriptors")
            if descriptors then
                local descriptor = descriptors[key]
                if descriptor ~= nil then
                    if descriptor.set then
                        descriptor.set(self, value)
                    else
                        if descriptor.writable == false then
                            error(
                                ((("Cannot assign to read only property '" .. key) .. "' of object '") .. tostring(self)) .. "'",
                                0
                            )
                        end
                        descriptor.value = value
                    end
                    return
                end
            end
            metatable = getmetatable(metatable)
        end
        rawset(self, key, value)
    end
end

local __TS__SetDescriptor
do
    local getmetatable = _G.getmetatable
    local function descriptorIndex(self, key)
        return __TS__DescriptorGet(
            self,
            getmetatable(self),
            key
        )
    end
    local function descriptorNewIndex(self, key, value)
        return __TS__DescriptorSet(
            self,
            getmetatable(self),
            key,
            value
        )
    end
    function __TS__SetDescriptor(target, key, desc, isPrototype)
        if isPrototype == nil then
            isPrototype = false
        end
        local ____isPrototype_0
        if isPrototype then
            ____isPrototype_0 = target
        else
            ____isPrototype_0 = getmetatable(target)
        end
        local metatable = ____isPrototype_0
        if not metatable then
            metatable = {}
            setmetatable(target, metatable)
        end
        local value = rawget(target, key)
        if value ~= nil then
            rawset(target, key, nil)
        end
        if not rawget(metatable, "_descriptors") then
            metatable._descriptors = {}
        end
        metatable._descriptors[key] = __TS__CloneDescriptor(desc)
        metatable.__index = descriptorIndex
        metatable.__newindex = descriptorNewIndex
    end
end

local function __TS__DecorateLegacy(decorators, target, key, desc)
    local result = target
    do
        local i = #decorators
        while i >= 0 do
            local decorator = decorators[i + 1]
            if decorator ~= nil then
                local oldResult = result
                if key == nil then
                    result = decorator(nil, result)
                elseif desc == true then
                    local value = rawget(target, key)
                    local descriptor = __TS__ObjectGetOwnPropertyDescriptor(target, key) or ({configurable = true, writable = true, value = value})
                    local desc = decorator(nil, target, key, descriptor) or descriptor
                    local isSimpleValue = desc.configurable == true and desc.writable == true and not desc.get and not desc.set
                    if isSimpleValue then
                        rawset(target, key, desc.value)
                    else
                        __TS__SetDescriptor(
                            target,
                            key,
                            __TS__ObjectAssign({}, descriptor, desc)
                        )
                    end
                elseif desc == false then
                    result = decorator(nil, target, key, desc)
                else
                    result = decorator(nil, target, key)
                end
                result = result or oldResult
            end
            i = i - 1
        end
    end
    return result
end

local function __TS__DecorateParam(paramIndex, decorator)
    return function(____, target, key) return decorator(nil, target, key, paramIndex) end
end

local function __TS__StringIncludes(self, searchString, position)
    if not position then
        position = 1
    else
        position = position + 1
    end
    local index = string.find(self, searchString, position, true)
    return index ~= nil
end

local Error, RangeError, ReferenceError, SyntaxError, TypeError, URIError
do
    local function getErrorStack(self, constructor)
        if debug == nil then
            return nil
        end
        local level = 1
        while true do
            local info = debug.getinfo(level, "f")
            level = level + 1
            if not info then
                level = 1
                break
            elseif info.func == constructor then
                break
            end
        end
        if __TS__StringIncludes(_VERSION, "Lua 5.0") then
            return debug.traceback(("[Level " .. tostring(level)) .. "]")
        elseif _VERSION == "Lua 5.1" then
            return string.sub(
                debug.traceback("", level),
                2
            )
        else
            return debug.traceback(nil, level)
        end
    end
    local function wrapErrorToString(self, getDescription)
        return function(self)
            local description = getDescription(self)
            local caller = debug.getinfo(3, "f")
            local isClassicLua = __TS__StringIncludes(_VERSION, "Lua 5.0")
            if isClassicLua or caller and caller.func ~= error then
                return description
            else
                return (description .. "\n") .. tostring(self.stack)
            end
        end
    end
    local function initErrorClass(self, Type, name)
        Type.name = name
        return setmetatable(
            Type,
            {__call = function(____, _self, message) return __TS__New(Type, message) end}
        )
    end
    local ____initErrorClass_1 = initErrorClass
    local ____class_0 = __TS__Class()
    ____class_0.name = ""
    function ____class_0.prototype.____constructor(self, message)
        if message == nil then
            message = ""
        end
        self.message = message
        self.name = "Error"
        self.stack = getErrorStack(nil, __TS__New)
        local metatable = getmetatable(self)
        if metatable and not metatable.__errorToStringPatched then
            metatable.__errorToStringPatched = true
            metatable.__tostring = wrapErrorToString(nil, metatable.__tostring)
        end
    end
    function ____class_0.prototype.__tostring(self)
        return self.message ~= "" and (self.name .. ": ") .. self.message or self.name
    end
    Error = ____initErrorClass_1(nil, ____class_0, "Error")
    local function createErrorClass(self, name)
        local ____initErrorClass_3 = initErrorClass
        local ____class_2 = __TS__Class()
        ____class_2.name = ____class_2.name
        __TS__ClassExtends(____class_2, Error)
        function ____class_2.prototype.____constructor(self, ...)
            ____class_2.____super.prototype.____constructor(self, ...)
            self.name = name
        end
        return ____initErrorClass_3(nil, ____class_2, name)
    end
    RangeError = createErrorClass(nil, "RangeError")
    ReferenceError = createErrorClass(nil, "ReferenceError")
    SyntaxError = createErrorClass(nil, "SyntaxError")
    TypeError = createErrorClass(nil, "TypeError")
    URIError = createErrorClass(nil, "URIError")
end

local function __TS__ObjectGetOwnPropertyDescriptors(object)
    local metatable = getmetatable(object)
    if not metatable then
        return {}
    end
    return rawget(metatable, "_descriptors") or ({})
end

local function __TS__Delete(target, key)
    local descriptors = __TS__ObjectGetOwnPropertyDescriptors(target)
    local descriptor = descriptors[key]
    if descriptor then
        if not descriptor.configurable then
            error(
                __TS__New(
                    TypeError,
                    ((("Cannot delete property " .. tostring(key)) .. " of ") .. tostring(target)) .. "."
                ),
                0
            )
        end
        descriptors[key] = nil
        return true
    end
    target[key] = nil
    return true
end

local function __TS__StringAccess(self, index)
    if index >= 0 and index < #self then
        return string.sub(self, index + 1, index + 1)
    end
end

local function __TS__DelegatedYield(iterable)
    if type(iterable) == "string" then
        for index = 0, #iterable - 1 do
            coroutine.yield(__TS__StringAccess(iterable, index))
        end
    elseif iterable.____coroutine ~= nil then
        local co = iterable.____coroutine
        while true do
            local status, value = coroutine.resume(co)
            if not status then
                error(value, 0)
            end
            if coroutine.status(co) == "dead" then
                return value
            else
                coroutine.yield(value)
            end
        end
    elseif iterable[Symbol.iterator] then
        local iterator = iterable[Symbol.iterator](iterable)
        while true do
            local result = iterator:next()
            if result.done then
                return result.value
            else
                coroutine.yield(result.value)
            end
        end
    else
        for ____, value in ipairs(iterable) do
            coroutine.yield(value)
        end
    end
end

local function __TS__FunctionBind(fn, ...)
    local boundArgs = {...}
    return function(____, ...)
        local args = {...}
        __TS__ArrayUnshift(
            args,
            __TS__Unpack(boundArgs)
        )
        return fn(__TS__Unpack(args))
    end
end

local __TS__Generator
do
    local function generatorIterator(self)
        return self
    end
    local function generatorNext(self, ...)
        local co = self.____coroutine
        if coroutine.status(co) == "dead" then
            return {done = true}
        end
        local status, value = coroutine.resume(co, ...)
        if not status then
            error(value, 0)
        end
        return {
            value = value,
            done = coroutine.status(co) == "dead"
        }
    end
    function __TS__Generator(fn)
        return function(...)
            local args = {...}
            local argsLength = __TS__CountVarargs(...)
            return {
                ____coroutine = coroutine.create(function() return fn(__TS__Unpack(args, 1, argsLength)) end),
                [Symbol.iterator] = generatorIterator,
                next = generatorNext
            }
        end
    end
end

local function __TS__InstanceOfObject(value)
    local valueType = type(value)
    return valueType == "table" or valueType == "function"
end

local function __TS__LuaIteratorSpread(self, state, firstKey)
    local results = {}
    local key, value = self(state, firstKey)
    while key do
        results[#results + 1] = {key, value}
        key, value = self(state, key)
    end
    return __TS__Unpack(results)
end

local Map
do
    Map = __TS__Class()
    Map.name = "Map"
    function Map.prototype.____constructor(self, entries)
        self[Symbol.toStringTag] = "Map"
        self.items = {}
        self.size = 0
        self.nextKey = {}
        self.previousKey = {}
        if entries == nil then
            return
        end
        local iterable = entries
        if iterable[Symbol.iterator] then
            local iterator = iterable[Symbol.iterator](iterable)
            while true do
                local result = iterator:next()
                if result.done then
                    break
                end
                local value = result.value
                self:set(value[1], value[2])
            end
        else
            local array = entries
            for ____, kvp in ipairs(array) do
                self:set(kvp[1], kvp[2])
            end
        end
    end
    function Map.prototype.clear(self)
        self.items = {}
        self.nextKey = {}
        self.previousKey = {}
        self.firstKey = nil
        self.lastKey = nil
        self.size = 0
    end
    function Map.prototype.delete(self, key)
        local contains = self:has(key)
        if contains then
            self.size = self.size - 1
            local next = self.nextKey[key]
            local previous = self.previousKey[key]
            if next ~= nil and previous ~= nil then
                self.nextKey[previous] = next
                self.previousKey[next] = previous
            elseif next ~= nil then
                self.firstKey = next
                self.previousKey[next] = nil
            elseif previous ~= nil then
                self.lastKey = previous
                self.nextKey[previous] = nil
            else
                self.firstKey = nil
                self.lastKey = nil
            end
            self.nextKey[key] = nil
            self.previousKey[key] = nil
        end
        self.items[key] = nil
        return contains
    end
    function Map.prototype.forEach(self, callback)
        for ____, key in __TS__Iterator(self:keys()) do
            callback(nil, self.items[key], key, self)
        end
    end
    function Map.prototype.get(self, key)
        return self.items[key]
    end
    function Map.prototype.has(self, key)
        return self.nextKey[key] ~= nil or self.lastKey == key
    end
    function Map.prototype.set(self, key, value)
        local isNewValue = not self:has(key)
        if isNewValue then
            self.size = self.size + 1
        end
        self.items[key] = value
        if self.firstKey == nil then
            self.firstKey = key
            self.lastKey = key
        elseif isNewValue then
            self.nextKey[self.lastKey] = key
            self.previousKey[key] = self.lastKey
            self.lastKey = key
        end
        return self
    end
    Map.prototype[Symbol.iterator] = function(self)
        return self:entries()
    end
    function Map.prototype.entries(self)
        local items = self.items
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = {key, items[key]}}
                key = nextKey[key]
                return result
            end
        }
    end
    function Map.prototype.keys(self)
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = key}
                key = nextKey[key]
                return result
            end
        }
    end
    function Map.prototype.values(self)
        local items = self.items
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = items[key]}
                key = nextKey[key]
                return result
            end
        }
    end
    Map[Symbol.species] = Map
end

local function __TS__MapGroupBy(items, keySelector)
    local result = __TS__New(Map)
    local i = 0
    for ____, item in __TS__Iterator(items) do
        local key = keySelector(nil, item, i)
        if result:has(key) then
            local ____temp_0 = result:get(key)
            ____temp_0[#____temp_0 + 1] = item
        else
            result:set(key, {item})
        end
        i = i + 1
    end
    return result
end

local __TS__Match = string.match

local __TS__MathAtan2 = math.atan2 or math.atan

local __TS__MathModf = math.modf

local function __TS__NumberIsNaN(value)
    return value ~= value
end

local function __TS__MathSign(val)
    if __TS__NumberIsNaN(val) or val == 0 then
        return val
    end
    if val < 0 then
        return -1
    end
    return 1
end

local function __TS__NumberIsFinite(value)
    return type(value) == "number" and value == value and value ~= math.huge and value ~= -math.huge
end

local function __TS__MathTrunc(val)
    if not __TS__NumberIsFinite(val) or val == 0 then
        return val
    end
    return val > 0 and math.floor(val) or math.ceil(val)
end

local function __TS__Number(value)
    local valueType = type(value)
    if valueType == "number" then
        return value
    elseif valueType == "string" then
        local numberValue = tonumber(value)
        if numberValue then
            return numberValue
        end
        if value == "Infinity" then
            return math.huge
        end
        if value == "-Infinity" then
            return -math.huge
        end
        local stringWithoutSpaces = string.gsub(value, "%s", "")
        if stringWithoutSpaces == "" then
            return 0
        end
        return 0 / 0
    elseif valueType == "boolean" then
        return value and 1 or 0
    else
        return 0 / 0
    end
end

local function __TS__NumberIsInteger(value)
    return __TS__NumberIsFinite(value) and math.floor(value) == value
end

local function __TS__StringSubstring(self, start, ____end)
    if ____end ~= ____end then
        ____end = 0
    end
    if ____end ~= nil and start > ____end then
        start, ____end = ____end, start
    end
    if start >= 0 then
        start = start + 1
    else
        start = 1
    end
    if ____end ~= nil and ____end < 0 then
        ____end = 0
    end
    return string.sub(self, start, ____end)
end

local __TS__ParseInt
do
    local parseIntBasePattern = "0123456789aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTvVwWxXyYzZ"
    function __TS__ParseInt(numberString, base)
        if base == nil then
            base = 10
            local hexMatch = __TS__Match(numberString, "^%s*-?0[xX]")
            if hexMatch ~= nil then
                base = 16
                numberString = (__TS__Match(hexMatch, "-")) and "-" .. __TS__StringSubstring(numberString, #hexMatch) or __TS__StringSubstring(numberString, #hexMatch)
            end
        end
        if base < 2 or base > 36 then
            return 0 / 0
        end
        local allowedDigits = base <= 10 and __TS__StringSubstring(parseIntBasePattern, 0, base) or __TS__StringSubstring(parseIntBasePattern, 0, 10 + 2 * (base - 10))
        local pattern = ("^%s*(-?[" .. allowedDigits) .. "]*)"
        local number = tonumber((__TS__Match(numberString, pattern)), base)
        if number == nil then
            return 0 / 0
        end
        if number >= 0 then
            return math.floor(number)
        else
            return math.ceil(number)
        end
    end
end

local function __TS__ParseFloat(numberString)
    local infinityMatch = __TS__Match(numberString, "^%s*(-?Infinity)")
    if infinityMatch ~= nil then
        return __TS__StringAccess(infinityMatch, 0) == "-" and -math.huge or math.huge
    end
    local number = tonumber((__TS__Match(numberString, "^%s*(-?%d+%.?%d*)")))
    return number or 0 / 0
end

local __TS__NumberToString
do
    local radixChars = "0123456789abcdefghijklmnopqrstuvwxyz"
    function __TS__NumberToString(self, radix)
        if radix == nil or radix == 10 or self == math.huge or self == -math.huge or self ~= self then
            return tostring(self)
        end
        radix = math.floor(radix)
        if radix < 2 or radix > 36 then
            error("toString() radix argument must be between 2 and 36", 0)
        end
        local integer, fraction = __TS__MathModf(math.abs(self))
        local result = ""
        if radix == 8 then
            result = string.format("%o", integer)
        elseif radix == 16 then
            result = string.format("%x", integer)
        else
            repeat
                do
                    result = __TS__StringAccess(radixChars, integer % radix) .. result
                    integer = math.floor(integer / radix)
                end
            until not (integer ~= 0)
        end
        if fraction ~= 0 then
            result = result .. "."
            local delta = 1e-16
            repeat
                do
                    fraction = fraction * radix
                    delta = delta * radix
                    local digit = math.floor(fraction)
                    result = result .. __TS__StringAccess(radixChars, digit)
                    fraction = fraction - digit
                end
            until not (fraction >= delta)
        end
        if self < 0 then
            result = "-" .. result
        end
        return result
    end
end

local function __TS__NumberToFixed(self, fractionDigits)
    if math.abs(self) >= 1e+21 or self ~= self then
        return tostring(self)
    end
    local f = math.floor(fractionDigits or 0)
    if f < 0 or f > 99 then
        error("toFixed() digits argument must be between 0 and 99", 0)
    end
    return string.format(
        ("%." .. tostring(f)) .. "f",
        self
    )
end

local function __TS__ObjectDefineProperty(target, key, desc)
    local luaKey = type(key) == "number" and key + 1 or key
    local value = rawget(target, luaKey)
    local hasGetterOrSetter = desc.get ~= nil or desc.set ~= nil
    local descriptor
    if hasGetterOrSetter then
        if value ~= nil then
            error(
                "Cannot redefine property: " .. tostring(key),
                0
            )
        end
        descriptor = desc
    else
        local valueExists = value ~= nil
        local ____desc_set_4 = desc.set
        local ____desc_get_5 = desc.get
        local ____desc_configurable_0 = desc.configurable
        if ____desc_configurable_0 == nil then
            ____desc_configurable_0 = valueExists
        end
        local ____desc_enumerable_1 = desc.enumerable
        if ____desc_enumerable_1 == nil then
            ____desc_enumerable_1 = valueExists
        end
        local ____desc_writable_2 = desc.writable
        if ____desc_writable_2 == nil then
            ____desc_writable_2 = valueExists
        end
        local ____temp_3
        if desc.value ~= nil then
            ____temp_3 = desc.value
        else
            ____temp_3 = value
        end
        descriptor = {
            set = ____desc_set_4,
            get = ____desc_get_5,
            configurable = ____desc_configurable_0,
            enumerable = ____desc_enumerable_1,
            writable = ____desc_writable_2,
            value = ____temp_3
        }
    end
    __TS__SetDescriptor(target, luaKey, descriptor)
    return target
end

local function __TS__ObjectEntries(obj)
    local result = {}
    local len = 0
    for key in pairs(obj) do
        len = len + 1
        result[len] = {key, obj[key]}
    end
    return result
end

local function __TS__ObjectFromEntries(entries)
    local obj = {}
    local iterable = entries
    if iterable[Symbol.iterator] then
        local iterator = iterable[Symbol.iterator](iterable)
        while true do
            local result = iterator:next()
            if result.done then
                break
            end
            local value = result.value
            obj[value[1]] = value[2]
        end
    else
        for ____, entry in ipairs(entries) do
            obj[entry[1]] = entry[2]
        end
    end
    return obj
end

local function __TS__ObjectGroupBy(items, keySelector)
    local result = {}
    local i = 0
    for ____, item in __TS__Iterator(items) do
        local key = keySelector(nil, item, i)
        if result[key] ~= nil then
            local ____result_key_0 = result[key]
            ____result_key_0[#____result_key_0 + 1] = item
        else
            result[key] = {item}
        end
        i = i + 1
    end
    return result
end

local function __TS__ObjectKeys(obj)
    local result = {}
    local len = 0
    for key in pairs(obj) do
        len = len + 1
        result[len] = key
    end
    return result
end

local function __TS__ObjectRest(target, usedProperties)
    local result = {}
    for property in pairs(target) do
        if not usedProperties[property] then
            result[property] = target[property]
        end
    end
    return result
end

local function __TS__ObjectValues(obj)
    local result = {}
    local len = 0
    for key in pairs(obj) do
        len = len + 1
        result[len] = obj[key]
    end
    return result
end

local function __TS__PromiseAll(iterable)
    local results = {}
    local toResolve = {}
    local numToResolve = 0
    local i = 0
    for ____, item in __TS__Iterator(iterable) do
        if __TS__InstanceOf(item, __TS__Promise) then
            if item.state == 1 then
                results[i + 1] = item.value
            elseif item.state == 2 then
                return __TS__Promise.reject(item.rejectionReason)
            else
                numToResolve = numToResolve + 1
                toResolve[i] = item
            end
        else
            results[i + 1] = item
        end
        i = i + 1
    end
    if numToResolve == 0 then
        return __TS__Promise.resolve(results)
    end
    return __TS__New(
        __TS__Promise,
        function(____, resolve, reject)
            for index, promise in pairs(toResolve) do
                promise["then"](
                    promise,
                    function(____, data)
                        results[index + 1] = data
                        numToResolve = numToResolve - 1
                        if numToResolve == 0 then
                            resolve(nil, results)
                        end
                    end,
                    function(____, reason)
                        reject(nil, reason)
                    end
                )
            end
        end
    )
end

local function __TS__PromiseAllSettled(iterable)
    local results = {}
    local toResolve = {}
    local numToResolve = 0
    local i = 0
    for ____, item in __TS__Iterator(iterable) do
        if __TS__InstanceOf(item, __TS__Promise) then
            if item.state == 1 then
                results[i + 1] = {status = "fulfilled", value = item.value}
            elseif item.state == 2 then
                results[i + 1] = {status = "rejected", reason = item.rejectionReason}
            else
                numToResolve = numToResolve + 1
                toResolve[i] = item
            end
        else
            results[i + 1] = {status = "fulfilled", value = item}
        end
        i = i + 1
    end
    if numToResolve == 0 then
        return __TS__Promise.resolve(results)
    end
    return __TS__New(
        __TS__Promise,
        function(____, resolve)
            for index, promise in pairs(toResolve) do
                promise["then"](
                    promise,
                    function(____, data)
                        results[index + 1] = {status = "fulfilled", value = data}
                        numToResolve = numToResolve - 1
                        if numToResolve == 0 then
                            resolve(nil, results)
                        end
                    end,
                    function(____, reason)
                        results[index + 1] = {status = "rejected", reason = reason}
                        numToResolve = numToResolve - 1
                        if numToResolve == 0 then
                            resolve(nil, results)
                        end
                    end
                )
            end
        end
    )
end

local function __TS__PromiseAny(iterable)
    local rejections = {}
    local pending = {}
    for ____, item in __TS__Iterator(iterable) do
        if __TS__InstanceOf(item, __TS__Promise) then
            if item.state == 1 then
                return __TS__Promise.resolve(item.value)
            elseif item.state == 2 then
                rejections[#rejections + 1] = item.rejectionReason
            else
                pending[#pending + 1] = item
            end
        else
            return __TS__Promise.resolve(item)
        end
    end
    if #pending == 0 then
        return __TS__Promise.reject("No promises to resolve with .any()")
    end
    local numResolved = 0
    return __TS__New(
        __TS__Promise,
        function(____, resolve, reject)
            for ____, promise in ipairs(pending) do
                promise["then"](
                    promise,
                    function(____, data)
                        resolve(nil, data)
                    end,
                    function(____, reason)
                        rejections[#rejections + 1] = reason
                        numResolved = numResolved + 1
                        if numResolved == #pending then
                            reject(nil, {name = "AggregateError", message = "All Promises rejected", errors = rejections})
                        end
                    end
                )
            end
        end
    )
end

local function __TS__PromiseRace(iterable)
    local pending = {}
    for ____, item in __TS__Iterator(iterable) do
        if __TS__InstanceOf(item, __TS__Promise) then
            if item.state == 1 then
                return __TS__Promise.resolve(item.value)
            elseif item.state == 2 then
                return __TS__Promise.reject(item.rejectionReason)
            else
                pending[#pending + 1] = item
            end
        else
            return __TS__Promise.resolve(item)
        end
    end
    return __TS__New(
        __TS__Promise,
        function(____, resolve, reject)
            for ____, promise in ipairs(pending) do
                promise["then"](
                    promise,
                    function(____, value) return resolve(nil, value) end,
                    function(____, reason) return reject(nil, reason) end
                )
            end
        end
    )
end

local Set
do
    Set = __TS__Class()
    Set.name = "Set"
    function Set.prototype.____constructor(self, values)
        self[Symbol.toStringTag] = "Set"
        self.size = 0
        self.nextKey = {}
        self.previousKey = {}
        if values == nil then
            return
        end
        local iterable = values
        if iterable[Symbol.iterator] then
            local iterator = iterable[Symbol.iterator](iterable)
            while true do
                local result = iterator:next()
                if result.done then
                    break
                end
                self:add(result.value)
            end
        else
            local array = values
            for ____, value in ipairs(array) do
                self:add(value)
            end
        end
    end
    function Set.prototype.add(self, value)
        local isNewValue = not self:has(value)
        if isNewValue then
            self.size = self.size + 1
        end
        if self.firstKey == nil then
            self.firstKey = value
            self.lastKey = value
        elseif isNewValue then
            self.nextKey[self.lastKey] = value
            self.previousKey[value] = self.lastKey
            self.lastKey = value
        end
        return self
    end
    function Set.prototype.clear(self)
        self.nextKey = {}
        self.previousKey = {}
        self.firstKey = nil
        self.lastKey = nil
        self.size = 0
    end
    function Set.prototype.delete(self, value)
        local contains = self:has(value)
        if contains then
            self.size = self.size - 1
            local next = self.nextKey[value]
            local previous = self.previousKey[value]
            if next ~= nil and previous ~= nil then
                self.nextKey[previous] = next
                self.previousKey[next] = previous
            elseif next ~= nil then
                self.firstKey = next
                self.previousKey[next] = nil
            elseif previous ~= nil then
                self.lastKey = previous
                self.nextKey[previous] = nil
            else
                self.firstKey = nil
                self.lastKey = nil
            end
            self.nextKey[value] = nil
            self.previousKey[value] = nil
        end
        return contains
    end
    function Set.prototype.forEach(self, callback)
        for ____, key in __TS__Iterator(self:keys()) do
            callback(nil, key, key, self)
        end
    end
    function Set.prototype.has(self, value)
        return self.nextKey[value] ~= nil or self.lastKey == value
    end
    Set.prototype[Symbol.iterator] = function(self)
        return self:values()
    end
    function Set.prototype.entries(self)
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = {key, key}}
                key = nextKey[key]
                return result
            end
        }
    end
    function Set.prototype.keys(self)
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = key}
                key = nextKey[key]
                return result
            end
        }
    end
    function Set.prototype.values(self)
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = key}
                key = nextKey[key]
                return result
            end
        }
    end
    function Set.prototype.union(self, other)
        local result = __TS__New(Set, self)
        for ____, item in __TS__Iterator(other) do
            result:add(item)
        end
        return result
    end
    function Set.prototype.intersection(self, other)
        local result = __TS__New(Set)
        for ____, item in __TS__Iterator(self) do
            if other:has(item) then
                result:add(item)
            end
        end
        return result
    end
    function Set.prototype.difference(self, other)
        local result = __TS__New(Set, self)
        for ____, item in __TS__Iterator(other) do
            result:delete(item)
        end
        return result
    end
    function Set.prototype.symmetricDifference(self, other)
        local result = __TS__New(Set, self)
        for ____, item in __TS__Iterator(other) do
            if self:has(item) then
                result:delete(item)
            else
                result:add(item)
            end
        end
        return result
    end
    function Set.prototype.isSubsetOf(self, other)
        for ____, item in __TS__Iterator(self) do
            if not other:has(item) then
                return false
            end
        end
        return true
    end
    function Set.prototype.isSupersetOf(self, other)
        for ____, item in __TS__Iterator(other) do
            if not self:has(item) then
                return false
            end
        end
        return true
    end
    function Set.prototype.isDisjointFrom(self, other)
        for ____, item in __TS__Iterator(self) do
            if other:has(item) then
                return false
            end
        end
        return true
    end
    Set[Symbol.species] = Set
end

local function __TS__SparseArrayNew(...)
    local sparseArray = {...}
    sparseArray.sparseLength = __TS__CountVarargs(...)
    return sparseArray
end

local function __TS__SparseArrayPush(sparseArray, ...)
    local args = {...}
    local argsLen = __TS__CountVarargs(...)
    local listLen = sparseArray.sparseLength
    for i = 1, argsLen do
        sparseArray[listLen + i] = args[i]
    end
    sparseArray.sparseLength = listLen + argsLen
end

local function __TS__SparseArraySpread(sparseArray)
    local _unpack = unpack or table.unpack
    return _unpack(sparseArray, 1, sparseArray.sparseLength)
end

local WeakMap
do
    WeakMap = __TS__Class()
    WeakMap.name = "WeakMap"
    function WeakMap.prototype.____constructor(self, entries)
        self[Symbol.toStringTag] = "WeakMap"
        self.items = {}
        setmetatable(self.items, {__mode = "k"})
        if entries == nil then
            return
        end
        local iterable = entries
        if iterable[Symbol.iterator] then
            local iterator = iterable[Symbol.iterator](iterable)
            while true do
                local result = iterator:next()
                if result.done then
                    break
                end
                local value = result.value
                self.items[value[1]] = value[2]
            end
        else
            for ____, kvp in ipairs(entries) do
                self.items[kvp[1]] = kvp[2]
            end
        end
    end
    function WeakMap.prototype.delete(self, key)
        local contains = self:has(key)
        self.items[key] = nil
        return contains
    end
    function WeakMap.prototype.get(self, key)
        return self.items[key]
    end
    function WeakMap.prototype.has(self, key)
        return self.items[key] ~= nil
    end
    function WeakMap.prototype.set(self, key, value)
        self.items[key] = value
        return self
    end
    WeakMap[Symbol.species] = WeakMap
end

local WeakSet
do
    WeakSet = __TS__Class()
    WeakSet.name = "WeakSet"
    function WeakSet.prototype.____constructor(self, values)
        self[Symbol.toStringTag] = "WeakSet"
        self.items = {}
        setmetatable(self.items, {__mode = "k"})
        if values == nil then
            return
        end
        local iterable = values
        if iterable[Symbol.iterator] then
            local iterator = iterable[Symbol.iterator](iterable)
            while true do
                local result = iterator:next()
                if result.done then
                    break
                end
                self.items[result.value] = true
            end
        else
            for ____, value in ipairs(values) do
                self.items[value] = true
            end
        end
    end
    function WeakSet.prototype.add(self, value)
        self.items[value] = true
        return self
    end
    function WeakSet.prototype.delete(self, value)
        local contains = self:has(value)
        self.items[value] = nil
        return contains
    end
    function WeakSet.prototype.has(self, value)
        return self.items[value] == true
    end
    WeakSet[Symbol.species] = WeakSet
end

local function __TS__SourceMapTraceBack(fileName, sourceMap)
    _G.__TS__sourcemap = _G.__TS__sourcemap or ({})
    _G.__TS__sourcemap[fileName] = sourceMap
    if _G.__TS__originalTraceback == nil then
        local originalTraceback = debug.traceback
        _G.__TS__originalTraceback = originalTraceback
        debug.traceback = function(thread, message, level)
            local trace
            if thread == nil and message == nil and level == nil then
                trace = originalTraceback()
            elseif __TS__StringIncludes(_VERSION, "Lua 5.0") then
                trace = originalTraceback((("[Level " .. tostring(level)) .. "] ") .. tostring(message))
            else
                trace = originalTraceback(thread, message, level)
            end
            if type(trace) ~= "string" then
                return trace
            end
            local function replacer(____, file, srcFile, line)
                local fileSourceMap = _G.__TS__sourcemap[file]
                if fileSourceMap ~= nil and fileSourceMap[line] ~= nil then
                    local data = fileSourceMap[line]
                    if type(data) == "number" then
                        return (srcFile .. ":") .. tostring(data)
                    end
                    return (data.file .. ":") .. tostring(data.line)
                end
                return (file .. ":") .. line
            end
            local result = string.gsub(
                trace,
                "(%S+)%.lua:(%d+)",
                function(file, line) return replacer(nil, file .. ".lua", file .. ".ts", line) end
            )
            local function stringReplacer(____, file, line)
                local fileSourceMap = _G.__TS__sourcemap[file]
                if fileSourceMap ~= nil and fileSourceMap[line] ~= nil then
                    local chunkName = (__TS__Match(file, "%[string \"([^\"]+)\"%]"))
                    local sourceName = string.gsub(chunkName, ".lua$", ".ts")
                    local data = fileSourceMap[line]
                    if type(data) == "number" then
                        return (sourceName .. ":") .. tostring(data)
                    end
                    return (data.file .. ":") .. tostring(data.line)
                end
                return (file .. ":") .. line
            end
            result = string.gsub(
                result,
                "(%[string \"[^\"]+\"%]):(%d+)",
                function(file, line) return stringReplacer(nil, file, line) end
            )
            return result
        end
    end
end

local function __TS__Spread(iterable)
    local arr = {}
    if type(iterable) == "string" then
        for i = 0, #iterable - 1 do
            arr[i + 1] = __TS__StringAccess(iterable, i)
        end
    else
        local len = 0
        for ____, item in __TS__Iterator(iterable) do
            len = len + 1
            arr[len] = item
        end
    end
    return __TS__Unpack(arr)
end

local function __TS__StringCharAt(self, pos)
    if pos ~= pos then
        pos = 0
    end
    if pos < 0 then
        return ""
    end
    return string.sub(self, pos + 1, pos + 1)
end

local function __TS__StringCharCodeAt(self, index)
    if index ~= index then
        index = 0
    end
    if index < 0 then
        return 0 / 0
    end
    return string.byte(self, index + 1) or 0 / 0
end

local function __TS__StringEndsWith(self, searchString, endPosition)
    if endPosition == nil or endPosition > #self then
        endPosition = #self
    end
    return string.sub(self, endPosition - #searchString + 1, endPosition) == searchString
end

local function __TS__StringPadEnd(self, maxLength, fillString)
    if fillString == nil then
        fillString = " "
    end
    if maxLength ~= maxLength then
        maxLength = 0
    end
    if maxLength == -math.huge or maxLength == math.huge then
        error("Invalid string length", 0)
    end
    if #self >= maxLength or #fillString == 0 then
        return self
    end
    maxLength = maxLength - #self
    if maxLength > #fillString then
        fillString = fillString .. string.rep(
            fillString,
            math.floor(maxLength / #fillString)
        )
    end
    return self .. string.sub(
        fillString,
        1,
        math.floor(maxLength)
    )
end

local function __TS__StringPadStart(self, maxLength, fillString)
    if fillString == nil then
        fillString = " "
    end
    if maxLength ~= maxLength then
        maxLength = 0
    end
    if maxLength == -math.huge or maxLength == math.huge then
        error("Invalid string length", 0)
    end
    if #self >= maxLength or #fillString == 0 then
        return self
    end
    maxLength = maxLength - #self
    if maxLength > #fillString then
        fillString = fillString .. string.rep(
            fillString,
            math.floor(maxLength / #fillString)
        )
    end
    return string.sub(
        fillString,
        1,
        math.floor(maxLength)
    ) .. self
end

local __TS__StringReplace
do
    local sub = string.sub
    function __TS__StringReplace(source, searchValue, replaceValue)
        local startPos, endPos = string.find(source, searchValue, nil, true)
        if not startPos then
            return source
        end
        local before = sub(source, 1, startPos - 1)
        local replacement = type(replaceValue) == "string" and replaceValue or replaceValue(nil, searchValue, startPos - 1, source)
        local after = sub(source, endPos + 1)
        return (before .. replacement) .. after
    end
end

local __TS__StringSplit
do
    local sub = string.sub
    local find = string.find
    function __TS__StringSplit(source, separator, limit)
        if limit == nil then
            limit = 4294967295
        end
        if limit == 0 then
            return {}
        end
        local result = {}
        local resultIndex = 1
        if separator == nil or separator == "" then
            for i = 1, #source do
                result[resultIndex] = sub(source, i, i)
                resultIndex = resultIndex + 1
            end
        else
            local currentPos = 1
            while resultIndex <= limit do
                local startPos, endPos = find(source, separator, currentPos, true)
                if not startPos then
                    break
                end
                result[resultIndex] = sub(source, currentPos, startPos - 1)
                resultIndex = resultIndex + 1
                currentPos = endPos + 1
            end
            if resultIndex <= limit then
                result[resultIndex] = sub(source, currentPos)
            end
        end
        return result
    end
end

local __TS__StringReplaceAll
do
    local sub = string.sub
    local find = string.find
    function __TS__StringReplaceAll(source, searchValue, replaceValue)
        if type(replaceValue) == "string" then
            local concat = table.concat(
                __TS__StringSplit(source, searchValue),
                replaceValue
            )
            if #searchValue == 0 then
                return (replaceValue .. concat) .. replaceValue
            end
            return concat
        end
        local parts = {}
        local partsIndex = 1
        if #searchValue == 0 then
            parts[1] = replaceValue(nil, "", 0, source)
            partsIndex = 2
            for i = 1, #source do
                parts[partsIndex] = sub(source, i, i)
                parts[partsIndex + 1] = replaceValue(nil, "", i, source)
                partsIndex = partsIndex + 2
            end
        else
            local currentPos = 1
            while true do
                local startPos, endPos = find(source, searchValue, currentPos, true)
                if not startPos then
                    break
                end
                parts[partsIndex] = sub(source, currentPos, startPos - 1)
                parts[partsIndex + 1] = replaceValue(nil, searchValue, startPos - 1, source)
                partsIndex = partsIndex + 2
                currentPos = endPos + 1
            end
            parts[partsIndex] = sub(source, currentPos)
        end
        return table.concat(parts)
    end
end

local function __TS__StringSlice(self, start, ____end)
    if start == nil or start ~= start then
        start = 0
    end
    if ____end ~= ____end then
        ____end = 0
    end
    if start >= 0 then
        start = start + 1
    end
    if ____end ~= nil and ____end < 0 then
        ____end = ____end - 1
    end
    return string.sub(self, start, ____end)
end

local function __TS__StringStartsWith(self, searchString, position)
    if position == nil or position < 0 then
        position = 0
    end
    return string.sub(self, position + 1, #searchString + position) == searchString
end

local function __TS__StringSubstr(self, from, length)
    if from ~= from then
        from = 0
    end
    if length ~= nil then
        if length ~= length or length <= 0 then
            return ""
        end
        length = length + from
    end
    if from >= 0 then
        from = from + 1
    end
    return string.sub(self, from, length)
end

local function __TS__StringTrim(self)
    local result = string.gsub(self, "^[%s ﻿]*(.-)[%s ﻿]*$", "%1")
    return result
end

local function __TS__StringTrimEnd(self)
    local result = string.gsub(self, "[%s ﻿]*$", "")
    return result
end

local function __TS__StringTrimStart(self)
    local result = string.gsub(self, "^[%s ﻿]*", "")
    return result
end

local __TS__SymbolRegistryFor, __TS__SymbolRegistryKeyFor
do
    local symbolRegistry = {}
    function __TS__SymbolRegistryFor(key)
        if not symbolRegistry[key] then
            symbolRegistry[key] = __TS__Symbol(key)
        end
        return symbolRegistry[key]
    end
    function __TS__SymbolRegistryKeyFor(sym)
        for key in pairs(symbolRegistry) do
            if symbolRegistry[key] == sym then
                return key
            end
        end
        return nil
    end
end

local function __TS__TypeOf(value)
    local luaType = type(value)
    if luaType == "table" then
        return "object"
    elseif luaType == "nil" then
        return "undefined"
    else
        return luaType
    end
end

local function __TS__Using(self, cb, ...)
    local args = {...}
    local thrownError
    local ok, result = xpcall(
        function() return cb(__TS__Unpack(args)) end,
        function(err)
            thrownError = err
            return thrownError
        end
    )
    local argArray = {__TS__Unpack(args)}
    do
        local i = #argArray - 1
        while i >= 0 do
            local ____self_0 = argArray[i + 1]
            ____self_0[Symbol.dispose](____self_0)
            i = i - 1
        end
    end
    if not ok then
        error(thrownError, 0)
    end
    return result
end

local function __TS__UsingAsync(self, cb, ...)
    local args = {...}
    return __TS__AsyncAwaiter(function(____awaiter_resolve)
        local thrownError
        local ok, result = xpcall(
            function() return cb(
                nil,
                __TS__Unpack(args)
            ) end,
            function(err)
                thrownError = err
                return thrownError
            end
        )
        local argArray = {__TS__Unpack(args)}
        do
            local i = #argArray - 1
            while i >= 0 do
                if argArray[i + 1][Symbol.dispose] ~= nil then
                    local ____self_0 = argArray[i + 1]
                    ____self_0[Symbol.dispose](____self_0)
                end
                if argArray[i + 1][Symbol.asyncDispose] ~= nil then
                    local ____self_1 = argArray[i + 1]
                    __TS__Await(____self_1[Symbol.asyncDispose](____self_1))
                end
                i = i - 1
            end
        end
        if not ok then
            error(thrownError, 0)
        end
        return ____awaiter_resolve(nil, result)
    end)
end

return {
  __TS__ArrayAt = __TS__ArrayAt,
  __TS__ArrayConcat = __TS__ArrayConcat,
  __TS__ArrayEntries = __TS__ArrayEntries,
  __TS__ArrayEvery = __TS__ArrayEvery,
  __TS__ArrayFill = __TS__ArrayFill,
  __TS__ArrayFilter = __TS__ArrayFilter,
  __TS__ArrayForEach = __TS__ArrayForEach,
  __TS__ArrayFind = __TS__ArrayFind,
  __TS__ArrayFindIndex = __TS__ArrayFindIndex,
  __TS__ArrayFrom = __TS__ArrayFrom,
  __TS__ArrayIncludes = __TS__ArrayIncludes,
  __TS__ArrayIndexOf = __TS__ArrayIndexOf,
  __TS__ArrayIsArray = __TS__ArrayIsArray,
  __TS__ArrayJoin = __TS__ArrayJoin,
  __TS__ArrayMap = __TS__ArrayMap,
  __TS__ArrayPush = __TS__ArrayPush,
  __TS__ArrayPushArray = __TS__ArrayPushArray,
  __TS__ArrayReduce = __TS__ArrayReduce,
  __TS__ArrayReduceRight = __TS__ArrayReduceRight,
  __TS__ArrayReverse = __TS__ArrayReverse,
  __TS__ArrayUnshift = __TS__ArrayUnshift,
  __TS__ArraySort = __TS__ArraySort,
  __TS__ArraySlice = __TS__ArraySlice,
  __TS__ArraySome = __TS__ArraySome,
  __TS__ArraySplice = __TS__ArraySplice,
  __TS__ArrayToObject = __TS__ArrayToObject,
  __TS__ArrayFlat = __TS__ArrayFlat,
  __TS__ArrayFlatMap = __TS__ArrayFlatMap,
  __TS__ArraySetLength = __TS__ArraySetLength,
  __TS__ArrayToReversed = __TS__ArrayToReversed,
  __TS__ArrayToSorted = __TS__ArrayToSorted,
  __TS__ArrayToSpliced = __TS__ArrayToSpliced,
  __TS__ArrayWith = __TS__ArrayWith,
  __TS__AsyncAwaiter = __TS__AsyncAwaiter,
  __TS__Await = __TS__Await,
  __TS__Class = __TS__Class,
  __TS__ClassExtends = __TS__ClassExtends,
  __TS__CloneDescriptor = __TS__CloneDescriptor,
  __TS__CountVarargs = __TS__CountVarargs,
  __TS__Decorate = __TS__Decorate,
  __TS__DecorateLegacy = __TS__DecorateLegacy,
  __TS__DecorateParam = __TS__DecorateParam,
  __TS__Delete = __TS__Delete,
  __TS__DelegatedYield = __TS__DelegatedYield,
  __TS__DescriptorGet = __TS__DescriptorGet,
  __TS__DescriptorSet = __TS__DescriptorSet,
  Error = Error,
  RangeError = RangeError,
  ReferenceError = ReferenceError,
  SyntaxError = SyntaxError,
  TypeError = TypeError,
  URIError = URIError,
  __TS__FunctionBind = __TS__FunctionBind,
  __TS__Generator = __TS__Generator,
  __TS__InstanceOf = __TS__InstanceOf,
  __TS__InstanceOfObject = __TS__InstanceOfObject,
  __TS__Iterator = __TS__Iterator,
  __TS__LuaIteratorSpread = __TS__LuaIteratorSpread,
  Map = Map,
  __TS__MapGroupBy = __TS__MapGroupBy,
  __TS__Match = __TS__Match,
  __TS__MathAtan2 = __TS__MathAtan2,
  __TS__MathModf = __TS__MathModf,
  __TS__MathSign = __TS__MathSign,
  __TS__MathTrunc = __TS__MathTrunc,
  __TS__New = __TS__New,
  __TS__Number = __TS__Number,
  __TS__NumberIsFinite = __TS__NumberIsFinite,
  __TS__NumberIsInteger = __TS__NumberIsInteger,
  __TS__NumberIsNaN = __TS__NumberIsNaN,
  __TS__ParseInt = __TS__ParseInt,
  __TS__ParseFloat = __TS__ParseFloat,
  __TS__NumberToString = __TS__NumberToString,
  __TS__NumberToFixed = __TS__NumberToFixed,
  __TS__ObjectAssign = __TS__ObjectAssign,
  __TS__ObjectDefineProperty = __TS__ObjectDefineProperty,
  __TS__ObjectEntries = __TS__ObjectEntries,
  __TS__ObjectFromEntries = __TS__ObjectFromEntries,
  __TS__ObjectGetOwnPropertyDescriptor = __TS__ObjectGetOwnPropertyDescriptor,
  __TS__ObjectGetOwnPropertyDescriptors = __TS__ObjectGetOwnPropertyDescriptors,
  __TS__ObjectGroupBy = __TS__ObjectGroupBy,
  __TS__ObjectKeys = __TS__ObjectKeys,
  __TS__ObjectRest = __TS__ObjectRest,
  __TS__ObjectValues = __TS__ObjectValues,
  __TS__ParseFloat = __TS__ParseFloat,
  __TS__ParseInt = __TS__ParseInt,
  __TS__Promise = __TS__Promise,
  __TS__PromiseAll = __TS__PromiseAll,
  __TS__PromiseAllSettled = __TS__PromiseAllSettled,
  __TS__PromiseAny = __TS__PromiseAny,
  __TS__PromiseRace = __TS__PromiseRace,
  Set = Set,
  __TS__SetDescriptor = __TS__SetDescriptor,
  __TS__SparseArrayNew = __TS__SparseArrayNew,
  __TS__SparseArrayPush = __TS__SparseArrayPush,
  __TS__SparseArraySpread = __TS__SparseArraySpread,
  WeakMap = WeakMap,
  WeakSet = WeakSet,
  __TS__SourceMapTraceBack = __TS__SourceMapTraceBack,
  __TS__Spread = __TS__Spread,
  __TS__StringAccess = __TS__StringAccess,
  __TS__StringCharAt = __TS__StringCharAt,
  __TS__StringCharCodeAt = __TS__StringCharCodeAt,
  __TS__StringEndsWith = __TS__StringEndsWith,
  __TS__StringIncludes = __TS__StringIncludes,
  __TS__StringPadEnd = __TS__StringPadEnd,
  __TS__StringPadStart = __TS__StringPadStart,
  __TS__StringReplace = __TS__StringReplace,
  __TS__StringReplaceAll = __TS__StringReplaceAll,
  __TS__StringSlice = __TS__StringSlice,
  __TS__StringSplit = __TS__StringSplit,
  __TS__StringStartsWith = __TS__StringStartsWith,
  __TS__StringSubstr = __TS__StringSubstr,
  __TS__StringSubstring = __TS__StringSubstring,
  __TS__StringTrim = __TS__StringTrim,
  __TS__StringTrimEnd = __TS__StringTrimEnd,
  __TS__StringTrimStart = __TS__StringTrimStart,
  __TS__Symbol = __TS__Symbol,
  Symbol = Symbol,
  __TS__SymbolRegistryFor = __TS__SymbolRegistryFor,
  __TS__SymbolRegistryKeyFor = __TS__SymbolRegistryKeyFor,
  __TS__TypeOf = __TS__TypeOf,
  __TS__Unpack = __TS__Unpack,
  __TS__Using = __TS__Using,
  __TS__UsingAsync = __TS__UsingAsync
}]=]

P['main.lua'] = [=[--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local runtime = require("jass.runtime")
runtime.console = true
local jassConsole = require("jass.console")
require("jass.japi");
(function()
    local g = _G
    local japi = nil
    do
        local function ____catch(_e)
            japi = nil
        end
        local ____try, ____hasReturned = pcall(function()
            japi = require("jass.japi")
        end)
        if not ____try then
            ____catch(____hasReturned)
        end
    end
    if not japi then
        return
    end
    for k in pairs(japi) do
        do
            local __continue6
            repeat
                if type(k) ~= "string" then
                    __continue6 = true
                    break
                end
                if (string.find(k, "Dz", nil, true) or 0) - 1 ~= 0 then
                    __continue6 = true
                    break
                end
                local v = japi[k]
                if type(v) ~= "function" then
                    __continue6 = true
                    break
                end
                if type(g[k]) == "function" then
                    __continue6 = true
                    break
                end
                g[k] = v
                __continue6 = true
            until true
            if not __continue6 then
                break
            end
        end
    end
end)(nil)
local jass = require("jass.common")
local g = require("jass.globals")
local slk = require("jass.slk")
_G.slk = slk
if g.YDUserDataGet2 and not jass.YDUserDataGet2 then
    jass.YDUserDataGet2 = g.YDUserDataGet2
end
if g.YDUserDataGet and not jass.YDUserDataGet then
    jass.YDUserDataGet = g.YDUserDataGet
end
if g.Ir_GetUnitAttackType and not jass.Ir_GetUnitAttackType then
    jass.Ir_GetUnitAttackType = g.Ir_GetUnitAttackType
end
if g.Ir_SetUnitAttackType and not jass.Ir_SetUnitAttackType then
    jass.Ir_SetUnitAttackType = g.Ir_SetUnitAttackType
end
_G.print = function(...)
    local args = {...}
    local str = ""
    do
        local i = 0
        while i < #args do
            str = str .. tostring(args[i + 1])
            if i < #args - 1 then
                str = str .. "\t"
            end
            i = i + 1
        end
    end
    jassConsole.write(str .. "\n")
end
require("系统.装备.装备提取")
require("系统.装备.装备掉落")
require("系统.单位.单位狂暴")
require("系统.装备.装备限制")
require("系统.00_核心.封装函数")
require("系统.00_核心.音效函数")
require("系统.00_核心.漂浮文字函数")
require("系统.00_核心.硬件函数")
require("系统.00_核心.泄露审计")
require("系统.07_任务.任务接受")
require("系统.07_任务.任务完成")
require("系统.07_任务.任务目标更新")
require("系统.测试.测试事件")
require("系统.测试.测试事件2")
require("系统.测试.测试233注册")
local ok, err = pcall(function () return require("系统.装备.装备系统") end
    )
if not ok then
    _G.print(
        "装备系统加载失败:",
        tostring(err)
    )
end
require("系统.装备.装备移速")
require("系统.装备.装备回复")
require("系统.装备.装备成长")
require("系统.装备.物品加工")
require("系统.伤害.伤害事件")
require("系统.伤害.伤害测试")
require("系统.伤害.dot伤害")
local _____533A_57DF_4F20_9001 = require("系统.地形.区域传送")
if type(_____533A_57DF_4F20_9001["init区域传送"]) == "function" then
    _____533A_57DF_4F20_9001["init区域传送"](_____533A_57DF_4F20_9001)
end
local _____6FC0_6D3B_4F20_9001_70B9 = require("系统.地形.激活传送点")
if type(_____6FC0_6D3B_4F20_9001_70B9["init激活传送点"]) == "function" then
    _____6FC0_6D3B_4F20_9001_70B9["init激活传送点"](_____6FC0_6D3B_4F20_9001_70B9)
end
local _____4EFB_52A1_7BA1_7406_5668 = require("系统.07_任务.任务管理器")
if type(_____4EFB_52A1_7BA1_7406_5668.init) == "function" then
    _____4EFB_52A1_7BA1_7406_5668:init()
end
local _____4EFB_52A1UI = require("系统.07_任务.任务UI")
if type(_____4EFB_52A1UI.init) == "function" then
    _____4EFB_52A1UI:init()
end
if type(_____4EFB_52A1UI.registerHotkey) == "function" then
    _____4EFB_52A1UI:registerHotkey()
end
require("系统.测试.任务测试")
return ____exports]=]

P['系统/00_核心/封装函数.lua'] = [=[--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
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
    local ____require_result_3 = require("系统.00_核心.音效函数")
    local Sound3DII_Mp3Play = ____require_result_3.Sound3DII_Mp3Play
    local Sound3DII_UnitPlay = ____require_result_3.Sound3DII_UnitPlay
    local ____require_result_4 = require("系统.00_核心.漂浮文字函数")
    local CreateFloatTextOnUnit = ____require_result_4.CreateFloatTextOnUnit
    if unit ~= nil then
        local txt = delta > 0 and "+" .. tostring(delta) or tostring(delta)
        CreateFloatTextOnUnit(nil, unit, txt, {red = 255, green = 215, blue = 0, alpha = 0})
        Sound3DII_UnitPlay(nil, SOUND_GOLD, unit, 1500)
    else
        Sound3DII_Mp3Play(nil, SOUND_GOLD, p)
    end
end
return ____exports]=]

P['系统/00_核心/泄露审计.lua'] = [[local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Iterator = ____lualib.__TS__Iterator
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringTrim = ____lualib.__TS__StringTrim
local ____exports = {}
--- 泄露审计工具（轻量版，TS + TSTL 友好）
-- 
-- 功能：
-- - 通过包装常见“容易泄露”的 API（计时器 / 单位组 / 触发器 / 特效 / 矩形 / 雾修正器）
-- - 记录：创建次数、销毁次数、当前存活数量
-- - 每个资源可以带一个 tag（来源标记，例如 "dot伤害" / "装备系统"）
-- - 玩家 0 输入 "-leak" 或按 ESC 跳过动画时，打印当前统计信息
-- 
-- 注意：
-- - 只能统计“通过本工具包装创建 / 销毁”的资源，旧代码直接调用 JASS 原生的不会被统计到。
-- - 建议先在你最怀疑泄露的系统里尝试用这些包装函数。
local jass = require("jass.common")
local alive = __TS__New(Map)
local types = {
    "timer",
    "group",
    "trigger",
    "effect",
    "rect",
    "sound",
    "texttag"
}
local stats = {
    timer = {created = 0, destroyed = 0},
    group = {created = 0, destroyed = 0},
    trigger = {created = 0, destroyed = 0},
    effect = {created = 0, destroyed = 0},
    rect = {created = 0, destroyed = 0},
    sound = {created = 0, destroyed = 0},
    texttag = {created = 0, destroyed = 0}
}
local function track(self, ____type, handle, tag)
    if not handle then
        return
    end
    local s = stats[____type]
    s.created = s.created + 1
    alive:set(handle, {type = ____type, tag = tag, createdIndex = s.created})
end
local function untrack(self, ____type, handle)
    if not handle then
        return
    end
    local s = stats[____type]
    if alive:delete(handle) then
        s.destroyed = s.destroyed + 1
    end
end
____exports.LeakWatcher = {
    createTimer = function(self, tag)
        local t = jass.CreateTimer()
        track(nil, "timer", t, tag)
        return t
    end,
    destroyTimer = function(self, t)
        if not t then
            return
        end
        untrack(nil, "timer", t)
        if type(jass.DestroyTimer) == "function" then
            jass.DestroyTimer(t)
        end
    end,
    createGroup = function(self, tag)
        local g = jass.CreateGroup()
        track(nil, "group", g, tag)
        return g
    end,
    destroyGroup = function(self, gp)
        if not gp then
            return
        end
        untrack(nil, "group", gp)
        if type(jass.DestroyGroup) == "function" then
            jass.DestroyGroup(gp)
        end
    end,
    createTrigger = function(self, tag)
        local trg = jass.CreateTrigger()
        track(nil, "trigger", trg, tag)
        return trg
    end,
    destroyTrigger = function(self, trg)
        if not trg then
            return
        end
        untrack(nil, "trigger", trg)
        if type(jass.DestroyTrigger) == "function" then
            jass.DestroyTrigger(trg)
        end
    end,
    trackEffect = function(self, tag, eff)
        track(nil, "effect", eff, tag)
    end,
    destroyEffect = function(self, eff)
        if not eff then
            return
        end
        untrack(nil, "effect", eff)
        if type(jass.DestroyEffect) == "function" then
            jass.DestroyEffect(eff)
        end
    end,
    trackRect = function(self, tag, rect)
        track(nil, "rect", rect, tag)
    end,
    removeRect = function(self, rect)
        if not rect then
            return
        end
        untrack(nil, "rect", rect)
        if type(jass.RemoveRect) == "function" then
            jass.RemoveRect(rect)
        end
    end,
    createSound = function(self, tag, fileName, looping, is3D, stopwhenoutofrange, fadeInRate, fadeOutRate, eaxSetting)
        if type(jass.CreateSound) ~= "function" then
            return nil
        end
        local s = jass.CreateSound(
            fileName,
            looping,
            is3D,
            stopwhenoutofrange,
            fadeInRate,
            fadeOutRate,
            eaxSetting
        )
        track(nil, "sound", s, tag)
        return s
    end,
    killSoundWhenDone = function(self, s)
        if not s then
            return
        end
        if type(jass.KillSoundWhenDone) == "function" then
            jass.KillSoundWhenDone(s)
        end
        untrack(nil, "sound", s)
    end,
    stopSoundAndKill = function(self, s, killWhenDone, fadeOut)
        if killWhenDone == nil then
            killWhenDone = true
        end
        if fadeOut == nil then
            fadeOut = false
        end
        if not s then
            return
        end
        if type(jass.StopSound) == "function" then
            jass.StopSound(s, killWhenDone, fadeOut)
        elseif type(jass.KillSoundWhenDone) == "function" then
            jass.KillSoundWhenDone(s)
        end
        untrack(nil, "sound", s)
    end,
    createTextTag = function(self, tag)
        if type(jass.CreateTextTag) ~= "function" then
            return nil
        end
        local tt = jass.CreateTextTag()
        track(nil, "texttag", tt, tag)
        return tt
    end,
    destroyTextTag = function(self, tt)
        if not tt then
            return
        end
        untrack(nil, "texttag", tt)
        if type(jass.DestroyTextTag) == "function" then
            jass.DestroyTextTag(tt)
        end
    end,
    dump = function(self, tagFilter)
        if type(jass.DisplayTimedTextToPlayer) ~= "function" then
            return
        end
        local ____table_Player_0
        if jass.Player then
            ____table_Player_0 = jass.Player(0)
        else
            ____table_Player_0 = nil
        end
        local p0 = ____table_Player_0
        local function printLine(____, msg)
            if not p0 then
                return
            end
            jass.DisplayTimedTextToPlayer(
                p0,
                0,
                0,
                15,
                msg
            )
        end
        printLine(nil, "=== 泄露审计 (仅统计使用 LeakWatcher 的资源) ===")
        for ____, tp in ipairs(types) do
            local s = stats[tp]
            local aliveCount = s.created - s.destroyed
            printLine(
                nil,
                (((((tp .. ": alive=") .. tostring(aliveCount)) .. ", created=") .. tostring(s.created)) .. ", destroyed=") .. tostring(s.destroyed)
            )
        end
        if tagFilter then
            printLine(nil, ("--- 详情 tag=" .. tagFilter) .. " ---")
            for ____, ____value in __TS__Iterator(alive) do
                local handle = ____value[1]
                local info = ____value[2]
                if info.tag == tagFilter then
                    printLine(
                        nil,
                        ((((((info.type .. "#") .. tostring(info.createdIndex)) .. " (") .. info.tag) .. ") [") .. tostring(handle)) .. "]"
                    )
                end
            end
        end
    end
}
--- 注册聊天 "-leak" 触发方式，方便临时查看
local function initLeakWatcherTriggers(self)
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" or type(jass.Player) ~= "function" then
        return
    end
    if type(jass.TriggerRegisterPlayerChatEvent) == "function" then
        local trChat = jass.CreateTrigger()
        jass.TriggerRegisterPlayerChatEvent(
            trChat,
            jass.Player(0),
            "-leak",
            false
        )
        jass.TriggerAddAction(
            trChat,
            function()
                local tag
                if type(jass.GetEventPlayerChatString) == "function" then
                    local raw = jass.GetEventPlayerChatString()
                    if raw ~= nil and #raw > 5 then
                        local idx = (string.find(raw, " ", nil, true) or 0) - 1
                        if idx >= 0 and idx < #raw - 1 then
                            tag = __TS__StringTrim(__TS__StringSubstring(raw, idx + 1))
                            if tag == "" then
                                tag = nil
                            end
                        end
                    end
                end
                ____exports.LeakWatcher:dump(tag)
            end
        )
    end
end
initLeakWatcherTriggers(nil)
return ____exports]]

P['系统/00_核心/漂浮文字函数.lua'] = [[local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
--- 漂浮文字系统 - 创建各种浮动文字效果
-- 
-- 功能：
-- - 可附着单位（自动跟随）
-- - 可固定坐标
-- - 自定义颜色、透明度、大小
-- - 自定义移动速度
-- - 自动销毁（存在时间）
local jass = require("jass.common")
local ____require_result_0 = require("系统.00_核心.泄露审计")
local LeakWatcher = ____require_result_0.LeakWatcher
local floatTextQueue = {}
local floatTextRecycleTimer = nil
local RECYCLE_TICK = 0.05
local function ensureFloatTextRecycleTimer(self)
    if floatTextRecycleTimer ~= nil then
        return
    end
    if type(jass.TimerStart) ~= "function" then
        return
    end
    local ____temp_3
    if LeakWatcher and type(LeakWatcher.createTimer) == "function" then
        ____temp_3 = LeakWatcher:createTimer("float_text_recycle")
    else
        local ____this_2
        ____this_2 = jass
        local ____opt_1 = ____this_2.CreateTimer
        if ____opt_1 ~= nil then
            ____opt_1 = ____opt_1(____this_2)
        end
        ____temp_3 = ____opt_1
    end
    floatTextRecycleTimer = ____temp_3
    if floatTextRecycleTimer == nil then
        return
    end
    jass.TimerStart(
        floatTextRecycleTimer,
        RECYCLE_TICK,
        true,
        function()
            do
                local i = #floatTextQueue - 1
                while i >= 0 do
                    local it = floatTextQueue[i + 1]
                    it.ticksLeft = it.ticksLeft - 1
                    if it.ticksLeft <= 0 then
                        local tt = it.tt
                        if tt then
                            if LeakWatcher and type(LeakWatcher.destroyTextTag) == "function" then
                                LeakWatcher:destroyTextTag(tt)
                            elseif type(jass.DestroyTextTag) == "function" then
                                jass.DestroyTextTag(tt)
                            end
                        end
                        __TS__ArraySplice(floatTextQueue, i, 1)
                    end
                    i = i - 1
                end
            end
            if #floatTextQueue == 0 then
                local t = floatTextRecycleTimer
                floatTextRecycleTimer = nil
                if LeakWatcher and type(LeakWatcher.destroyTimer) == "function" then
                    LeakWatcher:destroyTimer(t)
                elseif type(jass.DestroyTimer) == "function" then
                    jass.DestroyTimer(t)
                end
            end
        end
    )
end
____exports.lastCreatedTextTag = nil
--- 创建漂浮文字
-- 
-- @param targetUnit 目标单位（指定则忽略坐标）
-- @param x X坐标（当targetUnit为null时使用）
-- @param y Y坐标（当targetUnit为null时使用）
-- @param options 文字配置选项
-- @returns 创建的漂浮文字句柄
function ____exports.CreateFloatText(self, targetUnit, x, y, options)
    local ____options_4 = options
    local text = ____options_4.text
    local size = ____options_4.size
    if size == nil then
        size = 10
    end
    local red = ____options_4.red
    if red == nil then
        red = 255
    end
    local green = ____options_4.green
    if green == nil then
        green = 255
    end
    local blue = ____options_4.blue
    if blue == nil then
        blue = 255
    end
    local alpha = ____options_4.alpha
    if alpha == nil then
        alpha = 0
    end
    local duration = ____options_4.duration
    if duration == nil then
        duration = 1
    end
    local speedX = ____options_4.speedX
    if speedX == nil then
        speedX = 0
    end
    local speedY = ____options_4.speedY
    if speedY == nil then
        speedY = 0.07
    end
    local height = ____options_4.height
    if height == nil then
        height = 0
    end
    local permanent = ____options_4.permanent
    if permanent == nil then
        permanent = false
    end
    local ____temp_6
    if LeakWatcher and type(LeakWatcher.createTextTag) == "function" then
        ____temp_6 = LeakWatcher:createTextTag("float_text")
    else
        local ____temp_5
        if type(jass.CreateTextTag) == "function" then
            ____temp_5 = jass.CreateTextTag()
        else
            ____temp_5 = nil
        end
        ____temp_6 = ____temp_5
    end
    local textTag = ____temp_6
    if not textTag then
        return nil
    end
    local sizeToHeight = size * 0.0023
    if type(jass.SetTextTagText) == "function" then
        jass.SetTextTagText(textTag, text, sizeToHeight)
    end
    if type(jass.SetTextTagColor) == "function" then
        jass.SetTextTagColor(
            textTag,
            red,
            green,
            blue,
            alpha
        )
    end
    if targetUnit and type(jass.SetTextTagPosUnit) == "function" then
        jass.SetTextTagPosUnit(textTag, targetUnit, height)
    elseif type(jass.SetTextTagPos) == "function" then
        jass.SetTextTagPos(textTag, x, y, height)
    end
    if type(jass.SetTextTagVisibility) == "function" then
        jass.SetTextTagVisibility(textTag, true)
    end
    if (speedX ~= 0 or speedY ~= 0) and type(jass.SetTextTagVelocity) == "function" then
        jass.SetTextTagVelocity(textTag, speedX, speedY)
    end
    if not permanent and duration > 0 then
        if type(jass.SetTextTagLifespan) == "function" then
            jass.SetTextTagLifespan(textTag, duration)
        end
        if type(jass.SetTextTagFadepoint) == "function" then
            jass.SetTextTagFadepoint(textTag, duration - 0.5)
        end
        local ticks = math.max(
            1,
            math.floor(duration / RECYCLE_TICK + 0.999)
        )
        floatTextQueue[#floatTextQueue + 1] = {tt = textTag, ticksLeft = ticks}
        ensureFloatTextRecycleTimer(nil)
    end
    ____exports.lastCreatedTextTag = textTag
    return textTag
end
--- 创建漂浮文字（简化版，仅单位）
function ____exports.CreateFloatTextOnUnit(self, unit, text, options)
    return ____exports.CreateFloatText(
        nil,
        unit,
        0,
        0,
        __TS__ObjectAssign({text = text}, options)
    )
end
--- 创建漂浮文字（简化版，仅坐标）
function ____exports.CreateFloatTextAtPoint(self, x, y, text, options)
    return ____exports.CreateFloatText(
        nil,
        nil,
        x,
        y,
        __TS__ObjectAssign({text = text}, options)
    )
end
--- 销毁漂浮文字
function ____exports.DestroyFloatText(self, textTag)
    if not textTag then
        return
    end
    if LeakWatcher and type(LeakWatcher.destroyTextTag) == "function" then
        LeakWatcher:destroyTextTag(textTag)
    elseif type(jass.DestroyTextTag) == "function" then
        jass.DestroyTextTag(textTag)
    end
end
--- 设置漂浮文字文字内容
function ____exports.SetFloatTextText(self, textTag, text)
    if textTag then
        jass.SetTextTagText(textTag, text, 0)
    end
end
--- 设置漂浮文字颜色
function ____exports.SetFloatTextColor(self, textTag, red, green, blue, alpha)
    if textTag then
        jass.SetTextTagColor(
            textTag,
            red,
            green,
            blue,
            alpha
        )
    end
end
--- 设置漂浮文字位置（固定坐标）
function ____exports.SetFloatTextPosition(self, textTag, x, y, height)
    if textTag then
        jass.SetTextTagPos(textTag, x, y, height)
    end
end
--- 设置漂浮文字速度
function ____exports.SetFloatTextVelocity(self, textTag, speedX, speedY)
    if textTag then
        jass.SetTextTagVelocity(textTag, speedX, speedY)
    end
end
return ____exports]]

P['系统/00_核心/硬件函数.lua'] = [=[--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- DZ/JAPI 硬件函数封装（键盘/鼠标/窗口/UI Frame）
-- 
-- 目标：
-- - 只依赖运行时注入的 Dz* / EX*（平台本地/联机环境）
-- - 调用前做存在性检查，缺失时静默降级
-- - 避开 TSTL 坑：禁止对 jass API 用可选链调用；禁止把 jass.xxx 赋给局部变量再调用
local jass = require("jass.common")
local japi = require("jass.japi")
--- 按键状态（BzAPI：1=按下，2=抬起）
____exports.KEY_STATE = {DOWN = 1, UP = 2}
--- 鼠标按键（BzAPI：1=左，2=右，3=中）
____exports.MOUSE_BUTTON = {LEFT = 1, RIGHT = 2, MIDDLE = 3}
--- A-Z
____exports.KEY = {
    A = 65,
    B = 66,
    C = 67,
    D = 68,
    E = 69,
    F = 70,
    G = 71,
    H = 72,
    I = 73,
    J = 74,
    K = 75,
    L = 76,
    M = 77,
    N = 78,
    O = 79,
    P = 80,
    Q = 81,
    R = 82,
    S = 83,
    T = 84,
    U = 85,
    V = 86,
    W = 87,
    X = 88,
    Y = 89,
    Z = 90
}
--- F1-F12
____exports.KEY_F = {
    F1 = 112,
    F2 = 113,
    F3 = 114,
    F4 = 115,
    F5 = 116,
    F6 = 117,
    F7 = 118,
    F8 = 119,
    F9 = 120,
    F10 = 121,
    F11 = 122,
    F12 = 123
}
--- 字母键
____exports.KEY_LETTER = {
    A = 65,
    B = 66,
    C = 67,
    D = 68,
    E = 69,
    F = 70,
    G = 71,
    H = 72,
    I = 73,
    J = 74,
    K = 75,
    L = 76,
    M = 77,
    N = 78,
    O = 79,
    P = 80,
    Q = 81,
    R = 82,
    S = 83,
    T = 84,
    U = 85,
    V = 86,
    W = 87,
    X = 88,
    Y = 89,
    Z = 90
}
--- 0-9
____exports.KEY_NUM = {
    K0 = 48,
    K1 = 49,
    K2 = 50,
    K3 = 51,
    K4 = 52,
    K5 = 53,
    K6 = 54,
    K7 = 55,
    K8 = 56,
    K9 = 57
}
local function japiFn(self, name)
    local f = japi[name]
    local ____temp_0
    if type(f) == "function" then
        ____temp_0 = f
    else
        ____temp_0 = nil
    end
    return ____temp_0
end
function ____exports.has(self, name)
    return type(japi[name]) == "function"
end
function ____exports.isHardwareAPIAvailable(self)
    return type(japi.DzIsKeyDown) == "function" and type(japi.DzGetMouseX) == "function" and type(japi.DzGetMouseY) == "function"
end
function ____exports.getMouseTerrainX(self)
    local f = japiFn(nil, "DzGetMouseTerrainX")
    local ____f_1
    if f then
        ____f_1 = f()
    else
        ____f_1 = 0
    end
    return ____f_1
end
function ____exports.getMouseTerrainY(self)
    local f = japiFn(nil, "DzGetMouseTerrainY")
    local ____f_2
    if f then
        ____f_2 = f()
    else
        ____f_2 = 0
    end
    return ____f_2
end
function ____exports.getMouseTerrainZ(self)
    local f = japiFn(nil, "DzGetMouseTerrainZ")
    local ____f_3
    if f then
        ____f_3 = f()
    else
        ____f_3 = 0
    end
    return ____f_3
end
function ____exports.isMouseOverUI(self)
    local f = japiFn(nil, "DzIsMouseOverUI")
    local ____f_4
    if f then
        ____f_4 = not not f()
    else
        ____f_4 = false
    end
    return ____f_4
end
function ____exports.getMouseX(self)
    local f = japiFn(nil, "DzGetMouseX")
    local ____f_5
    if f then
        ____f_5 = f()
    else
        ____f_5 = 0
    end
    return ____f_5
end
function ____exports.getMouseY(self)
    local f = japiFn(nil, "DzGetMouseY")
    local ____f_6
    if f then
        ____f_6 = f()
    else
        ____f_6 = 0
    end
    return ____f_6
end
function ____exports.getMouseXRelative(self)
    local f = japiFn(nil, "DzGetMouseXRelative")
    local ____f_7
    if f then
        ____f_7 = f()
    else
        ____f_7 = 0
    end
    return ____f_7
end
function ____exports.getMouseYRelative(self)
    local f = japiFn(nil, "DzGetMouseYRelative")
    local ____f_8
    if f then
        ____f_8 = f()
    else
        ____f_8 = 0
    end
    return ____f_8
end
function ____exports.setMousePos(self, x, y)
    local f = japiFn(nil, "DzSetMousePos")
    if f then
        f(x, y)
    end
end
function ____exports.isKeyDown(self, keyCode)
    local f = japiFn(nil, "DzIsKeyDown")
    local ____f_9
    if f then
        ____f_9 = not not f(keyCode)
    else
        ____f_9 = false
    end
    return ____f_9
end
local function createTriggerOrNull(self)
    if type(jass.CreateTrigger) ~= "function" then
        return nil
    end
    return jass.CreateTrigger()
end
--- 注册按键事件（by code）。注意：这里不做 try/catch 兜底，避免不必要的同步差异。
function ____exports.registerKeyEventByCode(self, keyCode, status, sync, action)
    local trig = createTriggerOrNull(nil)
    if not trig then
        return nil
    end
    local fTrg = japiFn(nil, "DzTriggerRegisterKeyEventTrg") or _G.DzTriggerRegisterKeyEventTrg
    if type(fTrg) == "function" then
        local keyChar = string and type(string.char) == "function" and string.char(keyCode) or ""
        do
            local function ____catch(_e0)
                do
                    pcall(function()
                        fTrg(trig, status, keyCode)
                    end)
                end
            end
            local ____try, ____hasReturned = pcall(function()
                fTrg(trig, status, keyChar)
            end)
            if not ____try then
                ____catch(____hasReturned)
            end
        end
        if type(jass.TriggerAddAction) == "function" then
            jass.TriggerAddAction(trig, action)
        end
        return trig
    end
    local fByCode = japiFn(nil, "DzTriggerRegisterKeyEventByCode")
    if fByCode then
        fByCode(trig,
            keyCode,
            status,
            sync,
            action
        )
        return trig
    end
    local fStr = japiFn(nil, "DzTriggerRegisterKeyEvent")
    if fStr then
        fStr(trig,
            keyCode,
            status,
            sync,
            ""
        )
        if type(jass.TriggerAddAction) == "function" then
            jass.TriggerAddAction(trig, action)
        end
        return trig
    end
    return trig
end
function ____exports.registerKeyDown(self, keyCode, callback)
    return ____exports.registerKeyEventByCode(
        nil,
        keyCode,
        ____exports.KEY_STATE.DOWN,
        false,
        function()
            local getP = japiFn(nil, "DzGetTriggerKeyPlayer")
            local getK = japiFn(nil, "DzGetTriggerKey")
            local ____getP_10
            if getP then
                ____getP_10 = getP()
            else
                ____getP_10 = nil
            end
            local p = ____getP_10
            local ____getK_11
            if getK then
                ____getK_11 = getK()
            else
                ____getK_11 = 0
            end
            local k = ____getK_11
            callback(nil, p, k)
        end
    )
end
function ____exports.registerKeyUp(self, keyCode, callback)
    return ____exports.registerKeyEventByCode(
        nil,
        keyCode,
        ____exports.KEY_STATE.UP,
        false,
        function()
            local getP = japiFn(nil, "DzGetTriggerKeyPlayer")
            local getK = japiFn(nil, "DzGetTriggerKey")
            local ____getP_12
            if getP then
                ____getP_12 = getP()
            else
                ____getP_12 = nil
            end
            local p = ____getP_12
            local ____getK_13
            if getK then
                ____getK_13 = getK()
            else
                ____getK_13 = 0
            end
            local k = ____getK_13
            callback(nil, p, k)
        end
    )
end
--- 仅用于测试：允许传原始 status 数值（0/1/2）
local function registerKeyEventRawStatus(self, keyCode, status, sync, action)
    return ____exports.registerKeyEventByCode(
        nil,
        keyCode,
        status,
        sync,
        action
    )
end
function ____exports.getTriggerKeyPlayer(self)
    local f = japiFn(nil, "DzGetTriggerKeyPlayer")
    local ____f_14
    if f then
        ____f_14 = f()
    else
        ____f_14 = nil
    end
    return ____f_14
end
function ____exports.getTriggerKey(self)
    local f = japiFn(nil, "DzGetTriggerKey")
    local ____f_15
    if f then
        ____f_15 = f()
    else
        ____f_15 = 0
    end
    return ____f_15
end
function ____exports.getWheelDelta(self)
    local f = japiFn(nil, "DzGetWheelDelta")
    local ____f_16
    if f then
        ____f_16 = f()
    else
        ____f_16 = 0
    end
    return ____f_16
end
function ____exports.registerMouseWheel(self, sync, action)
    local trig = createTriggerOrNull(nil)
    if not trig then
        return nil
    end
    local f = japiFn(nil, "DzTriggerRegisterMouseWheelEventByCode")
    if not f then
        return nil
    end
    f(trig, sync, action)
    return trig
end
function ____exports.getWindowWidth(self)
    local f = japiFn(nil, "DzGetWindowWidth")
    local ____f_17
    if f then
        ____f_17 = f()
    else
        ____f_17 = 800
    end
    return ____f_17
end
function ____exports.getWindowHeight(self)
    local f = japiFn(nil, "DzGetWindowHeight")
    local ____f_18
    if f then
        ____f_18 = f()
    else
        ____f_18 = 600
    end
    return ____f_18
end
function ____exports.getWindowX(self)
    local f = japiFn(nil, "DzGetWindowX")
    local ____f_19
    if f then
        ____f_19 = f()
    else
        ____f_19 = 0
    end
    return ____f_19
end
function ____exports.getWindowY(self)
    local f = japiFn(nil, "DzGetWindowY")
    local ____f_20
    if f then
        ____f_20 = f()
    else
        ____f_20 = 0
    end
    return ____f_20
end
function ____exports.isWindowActive(self)
    local f = japiFn(nil, "DzIsWindowActive")
    local ____f_21
    if f then
        ____f_21 = not not f()
    else
        ____f_21 = true
    end
    return ____f_21
end
function ____exports.getGameUI(self)
    local f = japiFn(nil, "DzGetGameUI")
    local ____f_22
    if f then
        ____f_22 = f()
    else
        ____f_22 = 0
    end
    return ____f_22
end
function ____exports.frameFindByName(self, name, id)
    local f = japiFn(nil, "DzFrameFindByName")
    local ____f_23
    if f then
        ____f_23 = f(name, id)
    else
        ____f_23 = 0
    end
    return ____f_23
end
--- UI 回调：eventId 参考 DzAPI.j（1点击/2进入/3离开/4释放/6滚轮/12双击...），参数顺序与原生一致
function ____exports.frameSetScriptByCode(self, frame, eventId, action, sync)
    local f = japiFn(nil, "DzFrameSetScriptByCode")
    if f then
        f(frame,
            eventId,
            action,
            sync
        )
    end
end
local function initTestKeyB(self)
    if type(jass.DisplayTimedTextToPlayer) ~= "function" or type(jass.Player) ~= "function" then
        return
    end
    --- 去抖 / 只在“松开”触发一次：
    -- 
    -- 平台环境里键盘事件（DzTriggerRegisterKeyEventByCode）存在以下实测特性：
    -- - 必须 `sync=false` 才会触发回调（sync=true 不触发）
    -- - `status` 参数在 Lua/ByCode 这条链上不严格（0/1/2 都可能触发；甚至按住会重复派发）
    -- 
    -- 因此不能指望只靠 status 区分按下/抬起。
    -- 这里改用 DzIsKeyDown(keyCode) 做“边沿检测”：
    -- - last=true 且 down=false 时，判定为“从按下→松开”，只触发一次。
    local lastDownByPid = {}
    local ____temp_24
    if type(jass.GetPlayerId) == "function" then
        ____temp_24 = jass.GetPlayerId
    else
        ____temp_24 = nil
    end
    local getPid = ____temp_24
    local function hook(____, st)
        registerKeyEventRawStatus(
            nil,
            ____exports.KEY.B,
            st,
            false,
            function()
                local getP = japiFn(nil, "DzGetTriggerKeyPlayer")
                local ____getP_25
                if getP then
                    ____getP_25 = getP()
                else
                    ____getP_25 = nil
                end
                local p = ____getP_25
                local ____temp_26
                if getPid and p then
                    ____temp_26 = getPid(p)
                else
                    ____temp_26 = 0
                end
                local pid = ____temp_26
                local down = ____exports.isKeyDown(nil, ____exports.KEY.B)
                local last = not not lastDownByPid[pid]
                lastDownByPid[pid] = down
                if last and not down then
                    do
                        local i = 0
                        while i < 12 do
                            jass.DisplayTimedTextToPlayer(
                                jass.Player(i),
                                0,
                                0,
                                3,
                                "9999"
                            )
                            i = i + 1
                        end
                    end
                    if type(jass.GetPlayerName) == "function" and p then
                        jass.DisplayTimedTextToPlayer(
                            jass.Player(0),
                            0,
                            0,
                            3,
                            "from=" .. tostring(jass.GetPlayerName(p))
                        )
                    end
                end
            end
        )
    end
    hook(nil, 0)
    hook(nil, 1)
    hook(nil, 2)
    do
        local i = 0
        while i < 12 do
            lastDownByPid[i + 1] = false
            i = i + 1
        end
    end
end
initTestKeyB(nil)
return ____exports]=]

P['系统/00_核心/音效函数.lua'] = [[local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
--- 3D音效系统 - 纯原生函数实现
-- 对应 JASS 的 Sound3DII 库，不使用任何 BJ 函数
-- 
-- 功能：
-- - 在单位位置播放3D音效
-- - 在坐标处播放3D音效
-- - 在点位置播放3D音效
-- - 播放MP3音效（可指定玩家）
-- - 音效参数控制（音量、距离、方向、速度等）
-- - 音效池管理（同一音效路径最多4个同时播放）
local jass = require("jass.common")
local hash = jass.InitHashtable()
local KEY_COUNT = 1000
local KEY_INDEX = 1001
local KEY_TIMER = 1002
local KEY_SOUND = 1003
local KEY_PATH = 1004
local KEY_ENABLED = 1005
local KEY_ENABLED_SLOT_BASE = 2000
local POOL_MAX = 4
local DEBUG_SOUND = false
____exports.lastPlayedSound = nil
local defaultSoundModel
--- 声音衰减距离
____exports.SoundDistances = __TS__Class()
local SoundDistances = ____exports.SoundDistances
SoundDistances.name = "SoundDistances"
function SoundDistances.prototype.____constructor(self)
    self.minDis = 2500
    self.maxDis = 2500
end
function SoundDistances.prototype.set(self, mindis, maxdis)
    self.minDis = mindis
    self.maxDis = maxdis
end
--- 声音投射角
____exports.SoundConeOrientation = __TS__Class()
local SoundConeOrientation = ____exports.SoundConeOrientation
SoundConeOrientation.name = "SoundConeOrientation"
function SoundConeOrientation.prototype.____constructor(self)
    self.x = 0
    self.y = 0
    self.z = 0
end
function SoundConeOrientation.prototype.set(self, x, y, z)
    self.x = x
    self.y = y
    self.z = z
end
--- 声音速度
____exports.SoundVelocity = __TS__Class()
local SoundVelocity = ____exports.SoundVelocity
SoundVelocity.name = "SoundVelocity"
function SoundVelocity.prototype.____constructor(self)
    self.x = 0
    self.y = 0
    self.z = 0
end
function SoundVelocity.prototype.set(self, x, y, z)
    self.x = x
    self.y = y
    self.z = z
end
--- 声音锥形角度
____exports.ConeAngles = __TS__Class()
local ConeAngles = ____exports.ConeAngles
ConeAngles.name = "ConeAngles"
function ConeAngles.prototype.____constructor(self)
    self.inside = 0
    self.outside = 0
    self.volume = 127
end
function ConeAngles.prototype.set(self, inside, outside, volume)
    self.inside = inside
    self.outside = outside
    self.volume = volume
end
--- 声音模型 - 包含所有音效参数
____exports.SoundModel = __TS__Class()
local SoundModel = ____exports.SoundModel
SoundModel.name = "SoundModel"
function SoundModel.prototype.____constructor(self)
    self.ca = __TS__New(____exports.ConeAngles)
    self.channel = 0
    self.pitch = 1
    self.sv = __TS__New(____exports.SoundVelocity)
    self.sco = __TS__New(____exports.SoundConeOrientation)
    self.sd = __TS__New(____exports.SoundDistances)
    self.volume = 127
    self.soundType = "DefaultEAXON"
    self.fadeInRate = 10
    self.fadeOutRate = 10
end
function SoundModel.create(self)
    local model = __TS__New(____exports.SoundModel)
    model.ca:set(0, 0, 127)
    model.sv:set(0, 0, 0)
    model.sco:set(0, 0, 0)
    model.sd:set(2500, 2500)
    return model
end
function SoundModel.prototype.applyToSound(self, sound, x, y, z, cutoff)
    local j = jass
    if type(j.SetSoundDistances) == "function" then
        jass.SetSoundDistances(sound, self.sd.minDis, self.sd.maxDis)
    end
    if type(j.SetSoundDistanceCutoff) == "function" then
        jass.SetSoundDistanceCutoff(sound, cutoff)
    end
    if type(j.SetSoundPosition) == "function" then
        jass.SetSoundPosition(sound, x, y, z)
    end
    if type(j.SetSoundChannel) == "function" then
        jass.SetSoundChannel(sound, self.channel)
    end
    if type(j.SetSoundVolume) == "function" then
        jass.SetSoundVolume(sound, self.volume)
    end
    if type(j.SetSoundPitch) == "function" then
        jass.SetSoundPitch(sound, self.pitch)
    end
    if type(j.SetSoundConeOrientation) == "function" then
        jass.SetSoundConeOrientation(sound, self.sco.x, self.sco.y, self.sco.z)
    end
    if type(j.SetSoundConeAngles) == "function" then
        jass.SetSoundConeAngles(sound, self.ca.inside, self.ca.outside, self.ca.volume)
    end
    if type(j.SetSoundVelocity) == "function" then
        jass.SetSoundVelocity(sound, self.sv.x, self.sv.y, self.sv.z)
    end
end
--- 获取声音类型字符串
local function getSoundTypeByID(self, id)
    local types = {
        [1] = "CombatSoundsEAX",
        [2] = "KotoDrumsEAX",
        [3] = "SpellsEAX",
        [4] = "MissilesEAX",
        [5] = "HeroAcksEAX",
        [6] = "DoodadsEAX"
    }
    return types[id] or "DefaultEAXON"
end
--- 创建新音效（内部使用）
local function createSoundInternal(self, path, cutoff, index, x, y, z, is3d, model)
    if model == nil then
        model = defaultSoundModel
    end
    local timer = jass.CreateTimer()
    local sound = jass.CreateSound(
        path,
        false,
        is3d,
        false,
        model.fadeInRate,
        model.fadeOutRate,
        model.soundType
    )
    if not sound then
        return nil
    end
    model:applyToSound(
        sound,
        x,
        y,
        z,
        cutoff
    )
    local pathHash = jass.StringHash(path)
    jass.SaveSoundHandle(hash, pathHash, index, sound)
    jass.SaveTimerHandle(
        hash,
        jass.GetHandleId(sound),
        KEY_TIMER,
        timer
    )
    jass.SaveSoundHandle(
        hash,
        jass.GetHandleId(timer),
        KEY_SOUND,
        sound
    )
    jass.SaveBoolean(hash, pathHash, index + KEY_ENABLED_SLOT_BASE, false)
    jass.SaveInteger(
        hash,
        jass.GetHandleId(sound),
        KEY_INDEX,
        index
    )
    jass.SaveStr(
        hash,
        jass.GetHandleId(sound),
        KEY_PATH,
        path
    )
    local duration = jass.GetSoundFileDuration(path) * 0.001
    if duration <= 0 or duration > 3600 then
        duration = 1
    end
    jass.TimerStart(
        timer,
        duration,
        false,
        function()
            local expiredTimer = jass.GetExpiredTimer()
            local s = jass.LoadSoundHandle(
                hash,
                jass.GetHandleId(expiredTimer),
                KEY_SOUND
            )
            if s then
                local idx = jass.LoadInteger(
                    hash,
                    jass.GetHandleId(s),
                    KEY_INDEX
                )
                local p = jass.LoadStr(
                    hash,
                    jass.GetHandleId(s),
                    KEY_PATH
                )
                local ph = jass.StringHash(p)
                jass.SaveBoolean(hash, ph, idx + KEY_ENABLED_SLOT_BASE, true)
            end
            jass.DestroyTimer(expiredTimer)
        end
    )
    return sound
end
--- 获取已存在的音效（内部使用）
local function getSoundInternal(self, path, cutoff, index, x, y, z, model)
    if model == nil then
        model = defaultSoundModel
    end
    local pathHash = jass.StringHash(path)
    local sound = jass.LoadSoundHandle(hash, pathHash, index)
    if not sound then
        return nil
    end
    local timer = jass.LoadTimerHandle(
        hash,
        jass.GetHandleId(sound),
        KEY_TIMER
    )
    model:applyToSound(
        sound,
        x,
        y,
        z,
        cutoff
    )
    if timer then
        jass.DestroyTimer(timer)
        local newTimer = jass.CreateTimer()
        jass.SaveTimerHandle(
            hash,
            jass.GetHandleId(sound),
            KEY_TIMER,
            newTimer
        )
        jass.SaveSoundHandle(
            hash,
            jass.GetHandleId(newTimer),
            KEY_SOUND,
            sound
        )
        local duration = jass.GetSoundFileDuration(path) * 0.001
        if duration <= 0 or duration > 3600 then
            duration = 1
        end
        jass.TimerStart(
            newTimer,
            duration,
            false,
            function()
                local expiredTimer = jass.GetExpiredTimer()
                local s = jass.LoadSoundHandle(
                    hash,
                    jass.GetHandleId(expiredTimer),
                    KEY_SOUND
                )
                if s then
                    local idx = jass.LoadInteger(
                        hash,
                        jass.GetHandleId(s),
                        KEY_INDEX
                    )
                    local p = jass.LoadStr(
                        hash,
                        jass.GetHandleId(s),
                        KEY_PATH
                    )
                    local ph = jass.StringHash(p)
                    jass.SaveBoolean(hash, ph, idx + KEY_ENABLED_SLOT_BASE, true)
                end
                jass.DestroyTimer(expiredTimer)
            end
        )
    end
    jass.SaveBoolean(hash, pathHash, index + KEY_ENABLED_SLOT_BASE, false)
    return sound
end
--- 在坐标处播放3D音效
-- 
-- @param path 音效路径
-- @param x X坐标
-- @param y Y坐标
-- @param z Z坐标
-- @param cutoff 裁断距离
-- @param model 声音模型（可选）
-- @returns 播放的音效句柄
function ____exports.Sound3DII_CooPlay(self, path, x, y, z, cutoff, model)
    if model == nil then
        model = defaultSoundModel
    end
    local pathHash = jass.StringHash(path)
    local count = jass.LoadInteger(hash, pathHash, KEY_COUNT) or 0
    local index = jass.LoadInteger(hash, pathHash, KEY_INDEX) or 0
    if count > POOL_MAX then
        count = POOL_MAX
    end
    local slot = index % POOL_MAX
    local sound
    if slot >= count then
        sound = createSoundInternal(
            nil,
            path,
            cutoff,
            slot,
            x,
            y,
            z,
            true,
            model
        )
        if sound then
            jass.SaveInteger(hash, pathHash, KEY_COUNT, count + 1 > POOL_MAX and POOL_MAX or count + 1)
            jass.SaveInteger(hash, pathHash, KEY_INDEX, index + 1)
        end
    else
        sound = getSoundInternal(
            nil,
            path,
            cutoff,
            slot,
            x,
            y,
            z,
            model
        )
        if sound then
            jass.SaveInteger(hash, pathHash, KEY_INDEX, index + 1)
        end
    end
    if sound then
        jass.StartSound(sound)
        ____exports.lastPlayedSound = sound
    end
    return sound
end
--- 在单位位置播放3D音效
-- 
-- @param path 音效路径
-- @param unit 目标单位
-- @param cutoff 裁断距离
-- @param model 声音模型（可选）
function ____exports.Sound3DII_UnitPlay(self, path, unit, cutoff, model)
    local x = jass.GetUnitX(unit)
    local y = jass.GetUnitY(unit)
    local z = jass.GetUnitFlyHeight(unit)
    return ____exports.Sound3DII_CooPlay(
        nil,
        path,
        x,
        y,
        z,
        cutoff,
        model
    )
end
--- 在点位置播放3D音效
-- 
-- @param path 音效路径
-- @param loc 位置
-- @param cutoff 裁断距离
-- @param model 声音模型（可选）
function ____exports.Sound3DII_LocPlay(self, path, loc, cutoff, model)
    local x = jass.GetLocationX(loc)
    local y = jass.GetLocationY(loc)
    local z = jass.GetLocationZ(loc)
    return ____exports.Sound3DII_CooPlay(
        nil,
        path,
        x,
        y,
        z,
        cutoff,
        model
    )
end
--- 播放MP3音效（可指定玩家）
-- 
-- @param path 音效路径
-- @param player 指定玩家（为null时所有玩家都能听到）
-- @param model 声音模型（可选）
function ____exports.Sound3DII_Mp3Play(self, path, player, model)
    if model == nil then
        model = defaultSoundModel
    end
    if type(jass.CreateSound) == "function" and type(jass.StartSound) == "function" and type(jass.KillSoundWhenDone) == "function" then
        local Leak = require("系统.00_核心.泄露审计")
        local ____temp_0
        if Leak and Leak.LeakWatcher then
            ____temp_0 = Leak.LeakWatcher
        else
            ____temp_0 = nil
        end
        local LW = ____temp_0
        local ____temp_1
        if LW and type(LW.createSound) == "function" then
            ____temp_1 = LW:createSound(
                "sound_mp3",
                path,
                false,
                false,
                false,
                model.fadeInRate,
                model.fadeOutRate,
                model.soundType
            )
        else
            ____temp_1 = jass.CreateSound(
                path,
                false,
                false,
                false,
                model.fadeInRate,
                model.fadeOutRate,
                model.soundType
            )
        end
        local s = ____temp_1
        if s then
            if type(jass.SetSoundChannel) == "function" then
                jass.SetSoundChannel(s, model.channel)
            end
            if type(jass.SetSoundVolume) == "function" then
                jass.SetSoundVolume(s, model.volume)
            end
            if type(jass.SetSoundPitch) == "function" then
                jass.SetSoundPitch(s, model.pitch)
            end
            local shouldPlay = not player or type(jass.GetLocalPlayer) == "function" and jass.GetLocalPlayer() == player
            if shouldPlay then
                jass.StartSound(s)
            end
            if LW and type(LW.killSoundWhenDone) == "function" then
                LW:killSoundWhenDone(s)
            else
                jass.KillSoundWhenDone(s)
            end
            ____exports.lastPlayedSound = s
            if DEBUG_SOUND and _G.print then
                _G.print("[Sound3DII_Mp3Play] new sound, localPlay=", shouldPlay)
            end
            return s
        end
    end
    local pathHash = jass.StringHash(path)
    local count = jass.LoadInteger(hash, pathHash, KEY_COUNT) or 0
    if count > POOL_MAX then
        count = POOL_MAX
    end
    local availableIndex = -1
    do
        local i = 0
        while i < count do
            if jass.LoadBoolean(hash, pathHash, i + KEY_ENABLED_SLOT_BASE) then
                availableIndex = i
                break
            end
            i = i + 1
        end
    end
    local sound
    if availableIndex == -1 then
        if count >= POOL_MAX then
            return nil
        end
        sound = createSoundInternal(
            nil,
            path,
            4000,
            count,
            0,
            0,
            0,
            false,
            model
        )
        if sound then
            jass.SaveInteger(hash, pathHash, KEY_COUNT, count + 1)
        end
    else
        sound = getSoundInternal(
            nil,
            path,
            4000,
            availableIndex,
            0,
            0,
            0,
            model
        )
    end
    if sound then
        if player then
            if jass.GetLocalPlayer() == player then
                jass.StartSound(sound)
            end
        else
            jass.StartSound(sound)
        end
        ____exports.lastPlayedSound = sound
    end
    return sound
end
--- 设置声音效果类型
-- 
-- @param id 1=战斗,2=战鼓,3=魔法,4=投射物,5=英雄语音,6=装饰物
function ____exports.Sound3DII_SetSoundTypeByID(self, id)
    defaultSoundModel.soundType = getSoundTypeByID(nil, id)
end
--- 设置声音通道 (0-14)
function ____exports.Sound3DII_SetChannel(self, channel)
    if channel > 14 then
        channel = 0
    end
    defaultSoundModel.channel = channel
end
--- 设置音量 (0-127)
function ____exports.Sound3DII_SetVolume(self, volume)
    if volume > 127 then
        volume = 127
    end
    if volume < 0 then
        volume = 0
    end
    defaultSoundModel.volume = volume
end
--- 设置声音衰减距离
function ____exports.Sound3DII_SetDistances(self, min, max)
    defaultSoundModel.sd:set(min, max)
end
--- 设置声音方向
function ____exports.Sound3DII_SetConeOrientation(self, x, y, z)
    defaultSoundModel.sco:set(x, y, z)
end
--- 设置声音速度
function ____exports.Sound3DII_SetVelocity(self, x, y, z)
    defaultSoundModel.sv:set(x, y, z)
end
--- 设置声音锥形角度
function ____exports.Sound3DII_SetConeAngle(self, inside, outside, volume)
    defaultSoundModel.ca:set(inside, outside, volume)
end
--- 设置淡入速率
function ____exports.Sound3DII_SetFadeInRate(self, rate)
    defaultSoundModel.fadeInRate = rate
end
--- 设置淡出速率
function ____exports.Sound3DII_SetFadeOutRate(self, rate)
    defaultSoundModel.fadeOutRate = rate
end
--- 获取最后播放的音效
function ____exports.Sound3DII_GetLastPlayedSound(self)
    return ____exports.lastPlayedSound
end
--- 初始化音效系统
function ____exports.initSound3DII(self)
    defaultSoundModel = ____exports.SoundModel:create()
end
____exports.initSound3DII(nil)
return ____exports]]

P['系统/07_任务/index.lua'] = [=[--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.07_任务.任务数据")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.07_任务.任务管理器")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.07_任务.任务UI")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
function ____exports.init(self)
    local ____require_result_0 = require("./任务管理器")
    local questManager = ____require_result_0.questManager
    questManager:initialize()
end
return ____exports]=]

P['系统/07_任务/任务UI.lua'] = [[local ____lualib = require("lualib_bundle")
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__Class = ____lualib.__TS__Class
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local _____786C_4EF6_51FD_6570 = require("系统.00_核心.硬件函数")
local getGameUI = _____786C_4EF6_51FD_6570.getGameUI
local registerKeyDown = _____786C_4EF6_51FD_6570.registerKeyDown
local KEY_LETTER = _____786C_4EF6_51FD_6570.KEY_LETTER
local KEY_NUM = _____786C_4EF6_51FD_6570.KEY_NUM
local frameSetScriptByCode = _____786C_4EF6_51FD_6570.frameSetScriptByCode
local getWheelDelta = _____786C_4EF6_51FD_6570.getWheelDelta
local ____UI_5DE5_5177 = require("系统.表现.UI工具")
local createFrame = ____UI_5DE5_5177.createFrame
local setFramePosition = ____UI_5DE5_5177.setFramePosition
local setFrameSize = ____UI_5DE5_5177.setFrameSize
local setButtonText = ____UI_5DE5_5177.setButtonText
local setFrameClickEvent = ____UI_5DE5_5177.setFrameClickEvent
local setFramePointRelative = ____UI_5DE5_5177.setFramePointRelative
local setFrameHoverEvents = ____UI_5DE5_5177.setFrameHoverEvents
local createTextLabel = ____UI_5DE5_5177.createTextLabel
local loadTocOnce = ____UI_5DE5_5177.loadTocOnce
local tryCreateFromFdfSafe = ____UI_5DE5_5177.tryCreateFromFdfSafe
local FrameType = ____UI_5DE5_5177.FrameType
local FramePoint = ____UI_5DE5_5177.FramePoint
local EventType = ____UI_5DE5_5177.EventType
local hideFrame = ____UI_5DE5_5177.hideFrame
local showFrame = ____UI_5DE5_5177.showFrame
local _____4EFB_52A1_7BA1_7406_5668 = require("系统.07_任务.任务管理器")
local questManager = _____4EFB_52A1_7BA1_7406_5668.questManager
local _____4EFB_52A1_6570_636E = require("系统.07_任务.任务数据")
local questDB = _____4EFB_52A1_6570_636E.questDB
local QuestType = _____4EFB_52A1_6570_636E.QuestType
local QuestStatus = _____4EFB_52A1_6570_636E.QuestStatus
--- 任务系统 - 全新任务 UI（魔兽原生风格）
-- 入口图标 F9 下方，点击/P 展开，三标签：主线｜支线｜小任务
local jass = require("jass.common")
local japi = require("jass.japi")
local TASK_UI_TOC_PATHS = {"UI\\TaskUI.toc"}
local TASK_UI_TOC_LOAD_KEY = "TaskUI"
local ENABLE_FDF_A = true
local ENABLE_FDF_B = true
local ENABLE_FDF_SCROLLBAR = true
local ENABLE_FDF_SCROLLTHUMB = true
local ENTRY_SIZE = 0.04
local ENTRY_X = 0.02
local ENTRY_Y = 0.55
local PANEL_W = 0.35
local PANEL_H = 0.5
local TAB_TEXT_Y_NUDGE = -0.01
local LIST_ITEM_H = 0.12
local BG_TEX = "UI\\Widgets\\EscMenu\\Human\\human-options-menu-background.blp"
local BORDER_TEX = "UI\\Widgets\\EscMenu\\Human\\human-options-menu-border.blp"
local PANEL_TOP = 0.5
local LIST_TOP = 0.36
local TAB_Y = 0.44
local TAB_REL_Y = TAB_Y - PANEL_TOP
local LIST_LEFT = 0.05
local LIST_RIGHT = 0.34
local LIST_BOTTOM = 0.06
local LIST_VIEW_H = LIST_TOP - LIST_BOTTOM - 0.04
local LIST_CONTAINER_W = 0.32
local SCROLLBAR_W = 0.015
local SCROLL_THUMB_H = 0.035
local EMPTY_X = 0.2
local EMPTY_Y = 0.35
local function debugPrint(self, msg)
    local pr = _G.print
    if pr ~= nil then
        pr("[TaskUI] " .. msg)
    end
end
local function isFdfFrameEnabled(self, frameName)
    local isA = frameName == "TaskEntryIcon" or frameName == "TaskMainPanel" or frameName == "TaskListContainer"
    local isB = frameName == "TaskTabMain" or frameName == "TaskTabSide" or frameName == "TaskTabDaily" or frameName == "TaskCloseButton" or frameName == "TaskTabMainBg" or frameName == "TaskTabSideBg" or frameName == "TaskTabDailyBg"
    if frameName == "TaskScrollBar" then
        return ENABLE_FDF_SCROLLBAR
    end
    if frameName == "TaskScrollThumb" then
        return ENABLE_FDF_SCROLLTHUMB
    end
    if isA then
        return ENABLE_FDF_A
    end
    if isB then
        return ENABLE_FDF_B
    end
    return false
end
local function tryCreateFromFdf(self, name, parent, fallback)
    if not isFdfFrameEnabled(nil, name) then
        return fallback(nil)
    end
    loadTocOnce(nil, TASK_UI_TOC_LOAD_KEY, TASK_UI_TOC_PATHS, "TaskUI")
    return tryCreateFromFdfSafe(
        nil,
        name,
        parent,
        fallback,
        {tocLoadKey = TASK_UI_TOC_LOAD_KEY, tocPaths = TASK_UI_TOC_PATHS, debugPrefix = "TaskUI"}
    )
end
local function tryCreateFromFdfWithSource(self, name, parent, fallback)
    if not isFdfFrameEnabled(nil, name) then
        return {
            frame = fallback(nil),
            fromFdf = false
        }
    end
    loadTocOnce(nil, TASK_UI_TOC_LOAD_KEY, TASK_UI_TOC_PATHS, "TaskUI")
    if type(japi.DzCreateFrame) ~= "function" then
        return {
            frame = fallback(nil),
            fromFdf = false
        }
    end
    local f = 0
    local ok = pcall(function ()
            f = japi.DzCreateFrame(name, parent, 0)
        end
    )
    if ok and f ~= nil and f ~= 0 then
        return {frame = f, fromFdf = true}
    end
    return {
        frame = fallback(nil),
        fromFdf = false
    }
end
local function tryCreateFromFdfOnly(self, name, parent)
    local res = tryCreateFromFdfWithSource(
        nil,
        name,
        parent,
        function() return nil end
    )
    if res.fromFdf and res.frame and res.frame ~= 0 then
        debugPrint(nil, "FDF创建成功: " .. name)
        return res.frame
    end
    debugPrint(nil, "FDF创建失败: " .. name)
    return nil
end
local function getStatusText(self, status)
    local m = {
        [QuestStatus.IN_PROGRESS] = "进行中",
        [QuestStatus.COMPLETED] = "已完成",
        [QuestStatus.FAILED] = "已失败",
        [QuestStatus.DISCOVERED] = "已发现",
        [QuestStatus.UNDISCOVERED] = "未发现"
    }
    return m[status] or status
end
--- 获取任务列表（进行中 + 已完成，保留历史）
local function getQuestsForUI(self, playerId, ____type)
    local active = questManager:getPlayerQuests(playerId, ____type)
    local completedIds = questDB:getPlayerCompletedQuests(playerId)
    local result = __TS__ArraySlice(active)
    for ____, id in ipairs(completedIds) do
        do
            local __continue20
            repeat
                local template = questDB:getQuest(id)
                if not template or template.type ~= ____type then
                    __continue20 = true
                    break
                end
                if __TS__ArraySome(
                    active,
                    function(____, q) return q.id == id end
                ) then
                    __continue20 = true
                    break
                end
                result[#result + 1] = __TS__ObjectAssign(
                    {},
                    template,
                    {
                        status = QuestStatus.COMPLETED,
                        objectives = __TS__ArrayMap(
                            template.objectives,
                            function(____, o) return __TS__ObjectAssign({}, o, {completed = true, current = o.required}) end
                        )
                    }
                )
                __continue20 = true
            until true
            if not __continue20 then
                break
            end
        end
    end
    return result
end
local EMPTY_TEXTS = {[QuestType.MAIN] = "暂无主线任务", [QuestType.SIDE] = "暂无支线任务", [QuestType.DAILY] = "暂无小任务"}
local TaskUI = __TS__Class()
TaskUI.name = "TaskUI"
function TaskUI.prototype.____constructor(self)
    self.entryFrame = nil
    self.entryText = nil
    self.entryHint = nil
    self.mainPanel = nil
    self.listContainer = nil
    self.closeBtn = nil
    self.tabMain = nil
    self.tabSide = nil
    self.tabDaily = nil
    self.tabMainBg = nil
    self.tabSideBg = nil
    self.tabDailyBg = nil
    self.currentCategory = QuestType.MAIN
    self.listItemFrames = {}
    self.scrollBarFrame = nil
    self.scrollThumbFrame = nil
    self.scrollInputFrame = nil
    self.wheelOverlay = nil
    self.scrollOffset = 0
    self._updatingScrollBar = false
    self.totalContentHeight = 0
    self.expandedQuestIds = __TS__New(Set)
    self.isVisible = false
    self.currentPlayerId = 0
end
function TaskUI.prototype.init(self)
    local gameUI = getGameUI(nil)
    if not gameUI then
        debugPrint(nil, "无法获取游戏UI")
        return
    end
    self:createEntryIcon(gameUI)
    self:createMainPanel(gameUI)
    self:hide()
    debugPrint(nil, "任务UI初始化完成")
end
function TaskUI.prototype.createEntryIcon(self, parent)
    self.entryFrame = tryCreateFromFdfOnly(nil, "TaskEntryIcon", parent)
    if not self.entryFrame then
        return
    end
    setFramePosition(nil, self.entryFrame, {point = FramePoint.TOPLEFT, x = ENTRY_X, y = ENTRY_Y})
    setFrameSize(nil, self.entryFrame, {width = ENTRY_SIZE, height = ENTRY_SIZE})
    self.entryText = createTextLabel(
        nil,
        "TaskEntryText",
        self.entryFrame,
        "|cffffcc00任务（P）|r",
        {
            relativeTo = self.entryFrame,
            point = FramePoint.CENTER,
            relativePoint = FramePoint.CENTER,
            x = 0,
            y = 0
        },
        {width = ENTRY_SIZE * 1, height = ENTRY_SIZE * 0.5}
    )
    self.entryHint = createTextLabel(
        nil,
        "TaskEntryHint",
        self.entryFrame,
        "|cff888888按P打开|r",
        {
            relativeTo = self.entryFrame,
            point = FramePoint.TOP,
            relativePoint = FramePoint.BOTTOM,
            x = 0,
            y = -0.005
        },
        {width = ENTRY_SIZE * 1, height = ENTRY_SIZE * 0.35}
    )
    local btn = createFrame(nil, {
        type = FrameType.GLUETEXTBUTTON,
        name = "TaskEntryBtn",
        parent = self.entryFrame,
        template = "template",
        visible = true,
        enable = true,
        alpha = 0
    })
    if btn and type(japi.DzFrameSetAllPoints) == "function" then
        japi.DzFrameSetAllPoints(btn, self.entryFrame)
        setFrameClickEvent(
            nil,
            btn,
            function() local ok, err = pcall(function() return self:togglePanel() end) if not ok then local j = require("jass.common") if type(j) == "table" and type(j.DisplayTextToPlayer) == "function" then local p = j.Player(0) if p then j.DisplayTextToPlayer(p, 0, 0, "TaskUI err: " .. tostring(err)) end end end end,
            false
        )
    end
end
function TaskUI.prototype.createMainPanel(self, parent)
    self.mainPanel = tryCreateFromFdfOnly(nil, "TaskMainPanel", parent)
    if not self.mainPanel then
        return
    end
    setFramePosition(nil, self.mainPanel, {point = FramePoint.TOPLEFT, x = 0.02, y = PANEL_TOP})
    setFrameSize(nil, self.mainPanel, {width = PANEL_W, height = PANEL_H})
    self.listContainer = tryCreateFromFdfOnly(nil, "TaskListContainer", self.mainPanel)
    if self.listContainer and type(japi.DzFrameShow) == "function" then
        pcall(function () return japi.DzFrameShow(self.listContainer, true) end
        )
    end
    local tabParent = self.mainPanel
    self.tabMainBg = tryCreateFromFdfOnly(nil, "TaskTabMainBg", tabParent)
    if self.tabMainBg then
        if type(japi.DzFrameClearAllPoints) == "function" then
            japi.DzFrameClearAllPoints(self.tabMainBg)
        end
        setFramePointRelative(
            nil,
            self.tabMainBg,
            FramePoint.TOPLEFT,
            tabParent,
            FramePoint.TOPLEFT,
            0.02,
            TAB_REL_Y
        )
        setFrameSize(nil, self.tabMainBg, {width = 0.04, height = 0.035})
        if type(japi.DzFrameShow) == "function" then
            pcall(function () return japi.DzFrameShow(self.tabMainBg, true) end
            )
        end
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(self.tabMainBg, 7)
        end
    end
    self.tabMain = tryCreateFromFdfOnly(nil, "TaskTabMain", tabParent)
    if self.tabMain then
        if type(japi.DzFrameClearAllPoints) == "function" then
            japi.DzFrameClearAllPoints(self.tabMain)
        end
        setFramePointRelative(
            nil,
            self.tabMain,
            FramePoint.TOPLEFT,
            tabParent,
            FramePoint.TOPLEFT,
            0.02,
            TAB_REL_Y + TAB_TEXT_Y_NUDGE
        )
        setFrameSize(nil, self.tabMain, {width = 0.04, height = 0.035})
        if type(japi.DzFrameShow) == "function" then
            pcall(function () return japi.DzFrameShow(self.tabMain, true) end
            )
        end
        setButtonText(nil, self.tabMain, "|cffffcc00主线(1)|r")
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(self.tabMain, 8)
        end
        setFrameClickEvent(
            nil,
            self.tabMain,
            function() local ok, err = pcall(function() return self:switchCategory(QuestType.MAIN) end) if not ok then local j = require("jass.common") if type(j) == "table" and type(j.DisplayTextToPlayer) == "function" then local p = j.Player(0) if p then j.DisplayTextToPlayer(p, 0, 0, "TaskUI err: " .. tostring(err)) end end end end,
            false
        )
        setFrameHoverEvents(
            nil,
            self.tabMain,
            function() return self:showTabTooltip("按 1 切换主线任务") end,
            function()
            end,
            false
        )
    end
    self.tabSideBg = tryCreateFromFdfOnly(nil, "TaskTabSideBg", tabParent)
    if self.tabSideBg then
        if type(japi.DzFrameClearAllPoints) == "function" then
            japi.DzFrameClearAllPoints(self.tabSideBg)
        end
        setFramePointRelative(
            nil,
            self.tabSideBg,
            FramePoint.TOPLEFT,
            tabParent,
            FramePoint.TOPLEFT,
            0.135,
            TAB_REL_Y
        )
        setFrameSize(nil, self.tabSideBg, {width = 0.04, height = 0.035})
        if type(japi.DzFrameShow) == "function" then
            pcall(function () return japi.DzFrameShow(self.tabSideBg, true) end
            )
        end
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(self.tabSideBg, 7)
        end
    end
    self.tabSide = tryCreateFromFdfOnly(nil, "TaskTabSide", tabParent)
    if self.tabSide then
        if type(japi.DzFrameClearAllPoints) == "function" then
            japi.DzFrameClearAllPoints(self.tabSide)
        end
        setFramePointRelative(
            nil,
            self.tabSide,
            FramePoint.TOPLEFT,
            tabParent,
            FramePoint.TOPLEFT,
            0.135,
            TAB_REL_Y + TAB_TEXT_Y_NUDGE
        )
        setFrameSize(nil, self.tabSide, {width = 0.04, height = 0.035})
        if type(japi.DzFrameShow) == "function" then
            pcall(function () return japi.DzFrameShow(self.tabSide, true) end
            )
        end
        setButtonText(nil, self.tabSide, "|cffffcc00支线(2)|r")
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(self.tabSide, 8)
        end
        setFrameClickEvent(
            nil,
            self.tabSide,
            function() local ok, err = pcall(function() return self:switchCategory(QuestType.SIDE) end) if not ok then local j = require("jass.common") if type(j) == "table" and type(j.DisplayTextToPlayer) == "function" then local p = j.Player(0) if p then j.DisplayTextToPlayer(p, 0, 0, "TaskUI err: " .. tostring(err)) end end end end,
            false
        )
        setFrameHoverEvents(
            nil,
            self.tabSide,
            function() return self:showTabTooltip("按 2 切换支线任务") end,
            function()
            end,
            false
        )
    end
    self.tabDailyBg = tryCreateFromFdfOnly(nil, "TaskTabDailyBg", tabParent)
    if self.tabDailyBg then
        if type(japi.DzFrameClearAllPoints) == "function" then
            japi.DzFrameClearAllPoints(self.tabDailyBg)
        end
        setFramePointRelative(
            nil,
            self.tabDailyBg,
            FramePoint.TOPLEFT,
            tabParent,
            FramePoint.TOPLEFT,
            0.25,
            TAB_REL_Y
        )
        setFrameSize(nil, self.tabDailyBg, {width = 0.04, height = 0.035})
        if type(japi.DzFrameShow) == "function" then
            pcall(function () return japi.DzFrameShow(self.tabDailyBg, true) end
            )
        end
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(self.tabDailyBg, 7)
        end
    end
    self.tabDaily = tryCreateFromFdfOnly(nil, "TaskTabDaily", tabParent)
    if self.tabDaily then
        if type(japi.DzFrameClearAllPoints) == "function" then
            japi.DzFrameClearAllPoints(self.tabDaily)
        end
        setFramePointRelative(
            nil,
            self.tabDaily,
            FramePoint.TOPLEFT,
            tabParent,
            FramePoint.TOPLEFT,
            0.25,
            TAB_REL_Y + TAB_TEXT_Y_NUDGE
        )
        setFrameSize(nil, self.tabDaily, {width = 0.04, height = 0.035})
        if type(japi.DzFrameShow) == "function" then
            pcall(function () return japi.DzFrameShow(self.tabDaily, true) end
            )
        end
        setButtonText(nil, self.tabDaily, "|cffffcc00小任务(3)|r")
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(self.tabDaily, 8)
        end
        setFrameClickEvent(
            nil,
            self.tabDaily,
            function() local ok, err = pcall(function() return self:switchCategory(QuestType.DAILY) end) if not ok then local j = require("jass.common") if type(j) == "table" and type(j.DisplayTextToPlayer) == "function" then local p = j.Player(0) if p then j.DisplayTextToPlayer(p, 0, 0, "TaskUI err: " .. tostring(err)) end end end end,
            false
        )
        setFrameHoverEvents(
            nil,
            self.tabDaily,
            function() return self:showTabTooltip("按 3 切换小任务") end,
            function()
            end,
            false
        )
    end
    self.closeBtn = tryCreateFromFdfOnly(nil, "TaskCloseButton", self.mainPanel)
    if self.closeBtn then
        if type(japi.DzFrameClearAllPoints) == "function" then
            japi.DzFrameClearAllPoints(self.closeBtn)
        end
        setFramePointRelative(
            nil,
            self.closeBtn,
            FramePoint.TOPRIGHT,
            self.mainPanel,
            FramePoint.TOPRIGHT,
            -0.005,
            TAB_REL_Y
        )
        setFrameSize(nil, self.closeBtn, {width = 0.04, height = 0.035})
        if type(japi.DzFrameShow) == "function" then
            pcall(function () return japi.DzFrameShow(self.closeBtn, true) end
            )
        end
        setButtonText(nil, self.closeBtn, "|cffffcc00X|r")
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(self.closeBtn, 9)
        end
        setFrameClickEvent(
            nil,
            self.closeBtn,
            function() local ok, err = pcall(function() return self:hide() end) if not ok then local j = require("jass.common") if type(j) == "table" and type(j.DisplayTextToPlayer) == "function" then local p = j.Player(0) if p then j.DisplayTextToPlayer(p, 0, 0, "TaskUI err: " .. tostring(err)) end end end end,
            true
        )
    end
    if self.mainPanel then
        local sbSrc = tryCreateFromFdfWithSource(
            nil,
            "TaskScrollBar",
            self.mainPanel,
            function()
                local f = createFrame(nil, {
                    type = FrameType.BACKDROP,
                    name = "TaskScrollBarBtn",
                    parent = self.mainPanel,
                    template = "template",
                    visible = true
                })
                return f or 0
            end
        )
        self.scrollBarFrame = sbSrc.frame
        debugPrint(
            nil,
            (("scrollBar=" .. tostring(self.scrollBarFrame)) .. " fromFdf=") .. tostring(sbSrc.fromFdf)
        )
        if self.scrollBarFrame and self.scrollBarFrame ~= 0 and self.mainPanel then
            if type(japi.DzFrameShow) == "function" then
                japi.DzFrameShow(self.scrollBarFrame, true)
            end
            if sbSrc.fromFdf then
                if type(japi.DzFrameSetLevel) == "function" then
                    japi.DzFrameSetLevel(self.scrollBarFrame, 30)
                end
            else
                if type(japi.DzFrameClearAllPoints) == "function" then
                    japi.DzFrameClearAllPoints(self.scrollBarFrame)
                end
                setFramePointRelative(
                    nil,
                    self.scrollBarFrame,
                    FramePoint.TOPRIGHT,
                    self.mainPanel,
                    FramePoint.TOPRIGHT,
                    -0.006,
                    -0.08
                )
                setFramePointRelative(
                    nil,
                    self.scrollBarFrame,
                    FramePoint.BOTTOMRIGHT,
                    self.mainPanel,
                    FramePoint.BOTTOMRIGHT,
                    -0.006,
                    0.03
                )
                setFrameSize(nil, self.scrollBarFrame, {width = SCROLLBAR_W, height = LIST_VIEW_H})
                if type(japi.DzFrameSetLevel) == "function" then
                    japi.DzFrameSetLevel(self.scrollBarFrame, 30)
                end
            end
        end
        local stSrc = tryCreateFromFdfWithSource(
            nil,
            "TaskScrollThumb",
            self.mainPanel,
            function()
                local f = createFrame(nil, {
                    type = FrameType.BACKDROP,
                    name = "TaskScrollThumbBtn",
                    parent = self.mainPanel,
                    template = "template",
                    visible = true
                })
                if f and f ~= 0 then
                    if type(japi.DzFrameSetLevel) == "function" then
                        japi.DzFrameSetLevel(f, 2)
                    end
                end
                return f or 0
            end
        )
        self.scrollThumbFrame = stSrc.frame
        debugPrint(
            nil,
            (("scrollThumb=" .. tostring(self.scrollThumbFrame)) .. " fromFdf=") .. tostring(stSrc.fromFdf)
        )
        if self.scrollThumbFrame and self.scrollThumbFrame ~= 0 then
            if type(japi.DzFrameShow) == "function" then
                japi.DzFrameShow(self.scrollThumbFrame, true)
            end
            if stSrc.fromFdf then
                if type(japi.DzFrameSetLevel) == "function" then
                    japi.DzFrameSetLevel(self.scrollThumbFrame, 31)
                end
            else
                setFrameSize(nil, self.scrollThumbFrame, {width = SCROLLBAR_W, height = SCROLL_THUMB_H})
                if type(japi.DzFrameSetLevel) == "function" then
                    japi.DzFrameSetLevel(self.scrollThumbFrame, 31)
                end
            end
        end
        self.scrollInputFrame = createFrame(nil, {
            type = FrameType.SCROLLBAR,
            name = "TaskScrollInput",
            parent = self.mainPanel,
            template = "EscMenuScrollBarTemplate",
            visible = true,
            enable = true,
            alpha = 0
        })
        if not self.scrollInputFrame or self.scrollInputFrame == 0 then
            self.scrollInputFrame = createFrame(nil, {
                type = FrameType.SLIDER,
                name = "TaskScrollInput",
                parent = self.mainPanel,
                template = "template",
                visible = true,
                enable = true,
                alpha = 0
            })
        end
        if self.scrollInputFrame and self.scrollInputFrame ~= 0 then
            if type(japi.DzFrameClearAllPoints) == "function" then
                japi.DzFrameClearAllPoints(self.scrollInputFrame)
            end
            setFramePointRelative(
                nil,
                self.scrollInputFrame,
                FramePoint.TOPRIGHT,
                self.mainPanel,
                FramePoint.TOPRIGHT,
                -0.006,
                -0.08
            )
            setFramePointRelative(
                nil,
                self.scrollInputFrame,
                FramePoint.BOTTOMRIGHT,
                self.mainPanel,
                FramePoint.BOTTOMRIGHT,
                -0.006,
                0.03
            )
            setFrameSize(nil, self.scrollInputFrame, {width = SCROLLBAR_W, height = LIST_VIEW_H})
            if type(japi.DzFrameSetLevel) == "function" then
                japi.DzFrameSetLevel(self.scrollInputFrame, 32)
            end
            frameSetScriptByCode(
                nil,
                self.scrollInputFrame,
                EventType.SLIDER_VALUE_CHANGED,
                function() return self:onScrollBarChange() end,
                false
            )
        end
        self.wheelOverlay = createFrame(nil, {
            type = FrameType.GLUETEXTBUTTON,
            name = "TaskWheelOverlay",
            parent = self.mainPanel,
            template = "template",
            visible = true,
            enable = true,
            alpha = 0
        })
        if self.wheelOverlay and self.listContainer and type(japi.DzFrameSetAllPoints) == "function" then
            japi.DzFrameSetAllPoints(self.wheelOverlay, self.listContainer)
            frameSetScriptByCode(
                nil,
                self.wheelOverlay,
                EventType.MOUSE_WHEEL,
                function() return self:onListWheel() end,
                false
            )
        end
    end
end
function TaskUI.prototype.onListWheel(self)
    if not self.isVisible then
        return
    end
    local delta = type(getWheelDelta) == "function" and getWheelDelta(nil) or 0
    if delta == 0 then
        return
    end
    local units = math.max(
        1,
        math.floor(math.abs(delta) / 120)
    )
    local step = math.max(0.004, LIST_VIEW_H * 0.05) * units
    if delta > 0 then
        self.scrollOffset = math.max(0, self.scrollOffset - step)
    elseif delta < 0 then
        local maxScroll = math.max(0, self.totalContentHeight - LIST_VIEW_H)
        self.scrollOffset = math.min(maxScroll, self.scrollOffset + step)
    end
    self:syncScrollBarValue()
    self:updateScrollThumb()
    self:refreshList()
end
function TaskUI.prototype.onScrollBarChange(self)
    if self._updatingScrollBar then
        return
    end
    local getVal = japi.DzFrameGetValue
    if type(getVal) ~= "function" then
        return
    end
    if self.scrollInputFrame and self.scrollInputFrame ~= 0 then
        self.scrollOffset = getVal(nil, self.scrollInputFrame)
    elseif self.scrollBarFrame and self.scrollBarFrame ~= 0 then
        self.scrollOffset = getVal(nil, self.scrollBarFrame)
    else
        return
    end
    self:updateScrollThumb()
    self:refreshList()
end
function TaskUI.prototype.syncScrollBarValue(self)
    local setVal = japi.DzFrameSetValue
    if type(setVal) == "function" and self.scrollBarFrame and self.scrollBarFrame ~= 0 then
        self._updatingScrollBar = true
        setVal(nil, self.scrollBarFrame, self.scrollOffset)
        self._updatingScrollBar = false
    end
    if type(setVal) == "function" and self.scrollInputFrame and self.scrollInputFrame ~= 0 then
        self._updatingScrollBar = true
        setVal(nil, self.scrollInputFrame, self.scrollOffset)
        self._updatingScrollBar = false
    end
end
function TaskUI.prototype.updateScrollThumb(self)
    if not self.scrollThumbFrame or self.scrollThumbFrame == 0 or not self.listContainer or not self.scrollBarFrame or self.scrollBarFrame == 0 then
        return
    end
    local maxScroll = math.max(0, self.totalContentHeight - LIST_VIEW_H)
    local thumbH = SCROLL_THUMB_H
    local trackH = LIST_VIEW_H
    local moveRange = math.max(0, trackH - thumbH)
    local ratio = maxScroll > 0 and self.scrollOffset / maxScroll or 0
    local offsetFromTop = 0.02 + moveRange * ratio
    if type(japi.DzFrameClearAllPoints) == "function" then
        japi.DzFrameClearAllPoints(self.scrollThumbFrame)
    end
    setFramePointRelative(
        nil,
        self.scrollThumbFrame,
        FramePoint.TOPLEFT,
        self.scrollBarFrame,
        FramePoint.TOPLEFT,
        0,
        -offsetFromTop
    )
    setFramePointRelative(
        nil,
        self.scrollThumbFrame,
        FramePoint.BOTTOMLEFT,
        self.scrollBarFrame,
        FramePoint.TOPLEFT,
        0,
        -offsetFromTop - thumbH
    )
    setFrameSize(nil, self.scrollThumbFrame, {width = SCROLLBAR_W, height = thumbH})
end
function TaskUI.prototype.clearList(self)
    for ____, f in ipairs(self.listItemFrames) do
        if type(japi.DzDestroyFrame) == "function" then
            japi.DzDestroyFrame(f)
        end
    end
    self.listItemFrames = {}
end
function TaskUI.prototype.showTabTooltip(self, msg)
    if type(japi.DzGetTriggerUIEventPlayer) ~= "function" or type(jass.DisplayTextToPlayer) ~= "function" then
        return
    end
    local p = japi.DzGetTriggerUIEventPlayer()
    if p then
        jass.DisplayTextToPlayer(p, 0, 0, msg)
    end
end
function TaskUI.prototype.switchCategory(self, ____type)
    self.currentCategory = ____type
    self.expandedQuestIds:clear()
    self.scrollOffset = 0
    self:refreshList()
end
function TaskUI.prototype.toggleExpand(self, questId)
    if self.expandedQuestIds:has(questId) then
        self.expandedQuestIds:delete(questId)
    else
        self.expandedQuestIds:add(questId)
    end
    self:refreshList()
end
function TaskUI.prototype.refreshList(self)
    if not self.listContainer then
        return
    end
    self:clearList()
    local quests = getQuestsForUI(nil, self.currentPlayerId, self.currentCategory)
    if #quests == 0 then
        self.totalContentHeight = 0
        local empty = createTextLabel(
            nil,
            "TaskEmpty",
            self.listContainer,
            EMPTY_TEXTS[self.currentCategory],
            {point = FramePoint.CENTER, x = EMPTY_X, y = EMPTY_Y},
            {width = 0.9, height = 0.1}
        )
        if empty then
            local ____self_listItemFrames_2 = self.listItemFrames
            ____self_listItemFrames_2[#____self_listItemFrames_2 + 1] = empty
        end
        return
    end
    local totalH = 0
    do
        local i = 0
        while i < #quests do
            do
                local __continue140
                repeat
                    local q = quests[i + 1]
                    if not q then
                        __continue140 = true
                        break
                    end
                    local expanded = self.expandedQuestIds:has(q.id)
                    local itemH = expanded and LIST_ITEM_H + #q.objectives * 0.03 + (q.timeLimit and q.timeLimit > 0 and 0.02 or 0) or LIST_ITEM_H * 0.4
                    totalH = totalH + (itemH + 0.01)
                    __continue140 = true
                until true
                if not __continue140 then
                    break
                end
            end
            i = i + 1
        end
    end
    self.totalContentHeight = totalH
    local maxScroll = math.max(0, totalH - LIST_VIEW_H)
    self.scrollOffset = math.min(maxScroll, self.scrollOffset)
    local setMinMax = japi.DzFrameSetMinMaxValue
    local setVal = japi.DzFrameSetValue
    if type(setMinMax) == "function" and type(setVal) == "function" and self.scrollBarFrame and self.scrollBarFrame ~= 0 then
        setMinMax(
            nil,
            self.scrollBarFrame,
            0,
            math.max(1, maxScroll)
        )
        self._updatingScrollBar = true
        setVal(nil, self.scrollBarFrame, self.scrollOffset)
        self._updatingScrollBar = false
    end
    if type(setMinMax) == "function" and type(setVal) == "function" and self.scrollInputFrame and self.scrollInputFrame ~= 0 then
        setMinMax(
            nil,
            self.scrollInputFrame,
            0,
            math.max(1, maxScroll)
        )
        self._updatingScrollBar = true
        setVal(nil, self.scrollInputFrame, self.scrollOffset)
        self._updatingScrollBar = false
    end
    self:updateScrollThumb()
    local absY = LIST_TOP + self.scrollOffset
    do
        local i = 0
        while i < #quests do
            do
                local __continue145
                repeat
                    local q = quests[i + 1]
                    if not q then
                        __continue145 = true
                        break
                    end
                    local expanded = self.expandedQuestIds:has(q.id)
                    local itemH = expanded and LIST_ITEM_H + #q.objectives * 0.03 + (q.timeLimit and q.timeLimit > 0 and 0.02 or 0) or LIST_ITEM_H * 0.4
                    local item = self:createListItem(q, absY, expanded)
                    if item then
                        local ____self_listItemFrames_3 = self.listItemFrames
                        ____self_listItemFrames_3[#____self_listItemFrames_3 + 1] = item
                    end
                    absY = absY - (itemH + 0.01)
                    __continue145 = true
                until true
                if not __continue145 then
                    break
                end
            end
            i = i + 1
        end
    end
end
function TaskUI.prototype.createListItem(self, quest, absY, expanded)
    if not self.listContainer then
        return nil
    end
    local statusText = getStatusText(nil, quest.status)
    local titleFrame = createTextLabel(
        nil,
        "TaskItem_" .. quest.id,
        self.listContainer,
        ((quest.title .. " [") .. statusText) .. "]",
        {point = FramePoint.TOPLEFT, x = LIST_LEFT, y = absY},
        {width = 0.9, height = LIST_ITEM_H * 0.4}
    )
    if not titleFrame then
        return nil
    end
    if expanded then
        local objY = absY - LIST_ITEM_H * 0.4
        for ____, obj in ipairs(quest.objectives) do
            local txt = ((((((obj.completed and "[v] " or "[ ] ") .. obj.description) .. " (") .. tostring(obj.current)) .. "/") .. tostring(obj.required)) .. ")"
            local objFrame = createTextLabel(
                nil,
                (("TaskObj_" .. quest.id) .. "_") .. obj.id,
                self.listContainer,
                txt,
                {point = FramePoint.TOPLEFT, x = LIST_LEFT + 0.02, y = objY},
                {width = 0.85, height = LIST_ITEM_H * 0.25}
            )
            if objFrame then
                local ____self_listItemFrames_4 = self.listItemFrames
                ____self_listItemFrames_4[#____self_listItemFrames_4 + 1] = objFrame
            end
            objY = objY - LIST_ITEM_H * 0.25
        end
        if quest.timeLimit and quest.timeLimit > 0 then
            local failFrame = createTextLabel(
                nil,
                "TaskFail_" .. quest.id,
                self.listContainer,
                ("失败: 时间限制 " .. tostring(quest.timeLimit)) .. "秒",
                {point = FramePoint.TOPLEFT, x = LIST_LEFT + 0.02, y = objY},
                {width = 0.85, height = LIST_ITEM_H * 0.2}
            )
            if failFrame then
                local ____self_listItemFrames_5 = self.listItemFrames
                ____self_listItemFrames_5[#____self_listItemFrames_5 + 1] = failFrame
            end
        end
    end
    local itemH = expanded and LIST_ITEM_H + #quest.objectives * 0.03 + (quest.timeLimit and quest.timeLimit > 0 and 0.02 or 0) or LIST_ITEM_H * 0.4
    local clickBtn = createFrame(nil, {
        type = FrameType.GLUETEXTBUTTON,
        name = "TaskItemClick_" .. quest.id,
        parent = self.listContainer,
        template = "template",
        visible = true,
        enable = true,
        alpha = 0
    })
    if clickBtn and type(japi.DzFrameSetAbsolutePoint) == "function" then
        setFramePosition(nil, clickBtn, {point = FramePoint.TOPLEFT, x = LIST_LEFT - 0.01, y = absY})
        setFrameSize(nil, clickBtn, {width = 0.9, height = itemH})
        setFrameClickEvent(
            nil,
            clickBtn,
            function() return self:toggleExpand(quest.id) end,
            false
        )
        frameSetScriptByCode(
            nil,
            clickBtn,
            EventType.MOUSE_WHEEL,
            function() return self:onListWheel() end,
            false
        )
        local ____self_listItemFrames_6 = self.listItemFrames
        ____self_listItemFrames_6[#____self_listItemFrames_6 + 1] = clickBtn
    end
    return titleFrame
end
function TaskUI.prototype.togglePanel(self)
    self.isVisible = not self.isVisible
    if self.isVisible then
        self:show(self.currentPlayerId)
    else
        self:hide()
    end
end
function TaskUI.prototype.show(self, playerId)
    if not self.mainPanel then
        return
    end
    self.currentPlayerId = playerId
    self.isVisible = true
    showFrame(nil, self.mainPanel)
    self:refreshList()
    debugPrint(
        nil,
        "任务UI显示，玩家ID: " .. tostring(playerId)
    )
end
function TaskUI.prototype.hide(self)
    if not self.mainPanel then
        return
    end
    self.isVisible = false
    hideFrame(nil, self.mainPanel)
    debugPrint(nil, "任务UI隐藏")
end
function TaskUI.prototype.registerHotkey(self)
    if type(registerKeyDown) ~= "function" then
        return
    end
    local function toggle()
        return self:togglePanel()
    end
    registerKeyDown(nil, KEY_LETTER.P, toggle)
    registerKeyDown(nil, KEY_LETTER.T, toggle)
    registerKeyDown(
        nil,
        KEY_NUM.K1,
        function()
            if self.isVisible then
                self:switchCategory(QuestType.MAIN)
            end
        end
    )
    registerKeyDown(
        nil,
        KEY_NUM.K2,
        function()
            if self.isVisible then
                self:switchCategory(QuestType.SIDE)
            end
        end
    )
    registerKeyDown(
        nil,
        KEY_NUM.K3,
        function()
            if self.isVisible then
                self:switchCategory(QuestType.DAILY)
            end
        end
    )
    debugPrint(nil, "已注册 P/T 打开任务，1/2/3 切换标签")
end
____exports.taskUI = __TS__New(TaskUI)
function ____exports.init(self)
    ____exports.taskUI:init()
end
function ____exports.registerHotkey(self)
    ____exports.taskUI:registerHotkey()
end
return ____exports]]

P['系统/07_任务/任务完成.lua'] = [=[--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____4EFB_52A1_7BA1_7406_5668 = require("系统.07_任务.任务管理器")
local handleQuestCompleted = _____4EFB_52A1_7BA1_7406_5668.handleQuestCompleted
--- 任务系统 - “完成任务”事件桥接（预备版）
-- 
-- 设计目标：
-- - JASS 端在“玩家完成任务”时，通过 STES + Bridge_STES_Register 触发一个自定义事件；
-- - TS / Lua 端在这里统一接收事件，后续可以根据全局变量（任务 ID、完成状态等）更新任务数据。
-- 
-- 约定：
-- - 只能调用：STES_Register(udg_RegTrigger, udg_RegEventStr)
-- - Lua 侧流程：
--   1) 创建 Trigger 并设置回调；
--   2) 写入 jass.globals.udg_RegTrigger = trig；
--   3) 写入 jass.globals.udg_RegEventStr = "LuaEvent_QuestCompleted"；
--   4) jass.ExecuteFunc("Bridge_STES_Register") 交给 JASS 侧调用 STES_Register。
local jass = require("jass.common")
local g = require("jass.globals")
local function debugPrint(self, msg)
    local pr = _G.print
    if pr ~= nil then
        pr("[QuestComplete] " .. msg)
    end
    if type(jass.DisplayTimedTextToPlayer) == "function" then
        jass.DisplayTimedTextToPlayer(
            jass.Player(0),
            0,
            0,
            8,
            "[任务完成] " .. msg
        )
    end
end
local function registerQuestCompletedEvent(self)
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" or type(jass.ExecuteFunc) ~= "function" then
        debugPrint(nil, "JASS API 不完整，无法注册任务完成事件")
        return
    end
    local trig = jass.CreateTrigger()
    jass.TriggerAddAction(
        trig,
        function()
            debugPrint(nil, "任务完成事件触发，调用任务管理器...")
            do
                local function ____catch(____error)
                    debugPrint(
                        nil,
                        "处理任务完成事件时出错: " .. tostring(____error)
                    )
                end
                local ____try, ____hasReturned = pcall(function()
                    handleQuestCompleted(nil)
                end)
                if not ____try then
                    ____catch(____hasReturned)
                end
            end
        end
    )
    g.udg_RegTrigger = trig
    g.udg_RegEventStr = "LuaEvent_QuestCompleted"
    jass.ExecuteFunc("Bridge_STES_Register")
    debugPrint(nil, "已通过 Bridge_STES_Register 注册 LuaEvent_QuestCompleted")
end
local function init(self)
    registerQuestCompletedEvent(nil)
end
init(nil)
return ____exports]=]

P['系统/07_任务/任务接受.lua'] = [=[--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____4EFB_52A1_7BA1_7406_5668 = require("系统.07_任务.任务管理器")
local handleQuestAccepted = _____4EFB_52A1_7BA1_7406_5668.handleQuestAccepted
--- 任务系统 - “接受任务”事件桥接（预备版）
-- 
-- 设计目标：
-- - JASS 端在“玩家接受任务”时，通过 STES + Bridge_STES_Register 触发一个自定义事件；
-- - TS / Lua 端在这里统一接收事件，后续可以根据全局变量（任务 ID 等）更新任务数据。
-- 
-- 约定（当前支持的签名）：
-- - 只能调用：STES_Register(udg_RegTrigger, udg_RegEventStr)
-- - 因此 Lua 侧需要：
--   1) 创建 Trigger，并把回调挂到上面；
--   2) 把该 Trigger 写入 jass.globals 的 udg_RegTrigger；
--   3) 把事件名写入 udg_RegEventStr，比如 "LuaEvent_QuestAccepted"；
--   4) 调用 jass.ExecuteFunc("Bridge_STES_Register")，由 JASS 侧函数执行 STES_Register。
-- 
-- 未来扩展：
-- - 你可以在 JASS 里在触发事件前，写入更多全局变量（如 udg_QuestId、udg_QuestState 等），
--   本文件会从 jass.globals 里读取这些全局变量来判断“接受的是哪个任务”。
local jass = require("jass.common")
local g = require("jass.globals")
--- 简单的调试输出，方便验证管道是否通畅
local function debugPrint(self, msg)
    local pr = _G.print
    if pr ~= nil then
        pr("[QuestAccept] " .. msg)
    end
    if type(jass.DisplayTimedTextToPlayer) == "function" then
        jass.DisplayTimedTextToPlayer(
            jass.Player(0),
            0,
            0,
            8,
            "[任务接受] " .. msg
        )
    end
end
--- 使用 Bridge_STES_Register 注册一个自定义事件。
-- 
-- 当前 Bridge_STES_Register 的 JASS 侧实现：
--   function Bridge_STES_Register takes nothing returns nothing
--       call STES_Register(udg_RegTrigger, udg_RegEventStr)
--   endfunction
-- 
-- 因此这里严格按该签名设置全局变量再 ExecuteFunc。
local function registerQuestAcceptedEvent(self)
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" or type(jass.ExecuteFunc) ~= "function" then
        debugPrint(nil, "JASS API 不完整，无法注册任务接受事件")
        return
    end
    local trig = jass.CreateTrigger()
    jass.TriggerAddAction(
        trig,
        function()
            debugPrint(nil, "任务接受事件触发，调用任务管理器...")
            do
                local function ____catch(____error)
                    debugPrint(
                        nil,
                        "处理任务接受事件时出错: " .. tostring(____error)
                    )
                end
                local ____try, ____hasReturned = pcall(function()
                    handleQuestAccepted(nil)
                end)
                if not ____try then
                    ____catch(____hasReturned)
                end
            end
        end
    )
    g.udg_RegTrigger = trig
    g.udg_RegEventStr = "LuaEvent_QuestAccepted"
    jass.ExecuteFunc("Bridge_STES_Register")
    debugPrint(nil, "已通过 Bridge_STES_Register 注册 LuaEvent_QuestAccepted")
end
local function init(self)
    registerQuestAcceptedEvent(nil)
end
init(nil)
return ____exports]=]

P['系统/07_任务/任务数据.lua'] = [[local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__ArrayFrom = ____lualib.__TS__ArrayFrom
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local Set = ____lualib.Set
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayEvery = ____lualib.__TS__ArrayEvery
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local ____exports = {}
--- 获取当前时间戳（War3 Lua 环境下替代 Date.now）
local function now(self)
    return os.time()
end
____exports.QuestType = QuestType or ({})
____exports.QuestType.MAIN = "主线"
____exports.QuestType.SIDE = "支线"
____exports.QuestType.DAILY = "小任务"
--- 任务状态枚举（与War3原生状态对应）
-- 参考：bj_QUESTTYPE_REQ_DISCOVERED, bj_QUESTTYPE_REQ_UNDISCOVERED
____exports.QuestStatus = QuestStatus or ({})
____exports.QuestStatus.UNDISCOVERED = "未发现"
____exports.QuestStatus.DISCOVERED = "已发现"
____exports.QuestStatus.IN_PROGRESS = "进行中"
____exports.QuestStatus.COMPLETED = "已完成"
____exports.QuestStatus.FAILED = "已失败"
--- 任务数据库类
____exports.QuestDatabase = __TS__Class()
local QuestDatabase = ____exports.QuestDatabase
QuestDatabase.name = "QuestDatabase"
function QuestDatabase.prototype.____constructor(self)
    self.quests = __TS__New(Map)
    self.playerData = __TS__New(Map)
end
function QuestDatabase.getInstance(self)
    if not ____exports.QuestDatabase.instance then
        ____exports.QuestDatabase.instance = __TS__New(____exports.QuestDatabase)
    end
    return ____exports.QuestDatabase.instance
end
function QuestDatabase.prototype.registerQuest(self, quest)
    quest.createdAt = quest.createdAt or now(nil)
    quest.updatedAt = quest.updatedAt or now(nil)
    self.quests:set(quest.id, quest)
end
function QuestDatabase.prototype.getQuest(self, id)
    return self.quests:get(id)
end
function QuestDatabase.prototype.getAllQuests(self)
    return __TS__ArrayFrom(self.quests:values())
end
function QuestDatabase.prototype.getQuestsByType(self, ____type)
    return __TS__ArrayFilter(
        __TS__ArrayFrom(self.quests:values()),
        function(____, quest) return quest.type == ____type end
    )
end
function QuestDatabase.prototype.getAvailableQuests(self, playerId, ____type)
    local playerData = self:getPlayerData(playerId)
    if not playerData then
        return {}
    end
    local source = ____type and self:getQuestsByType(____type) or self:getAllQuests()
    return __TS__ArrayFilter(
        source,
        function(____, quest)
            if playerData.quests:has(quest.id) or playerData.completedQuests:has(quest.id) or playerData.failedQuests:has(quest.id) then
                return false
            end
            if quest.requiredQuests and #quest.requiredQuests > 0 then
                for ____, rid in ipairs(quest.requiredQuests) do
                    if not playerData.completedQuests:has(rid) then
                        return false
                    end
                end
            end
            return true
        end
    )
end
function QuestDatabase.prototype.initPlayerData(self, playerId)
    if not self.playerData:has(playerId) then
        self.playerData:set(
            playerId,
            {
                playerId = playerId,
                quests = __TS__New(Map),
                completedQuests = __TS__New(Set),
                failedQuests = __TS__New(Set)
            }
        )
    end
end
function QuestDatabase.prototype.getPlayerData(self, playerId)
    return self.playerData:get(playerId)
end
function QuestDatabase.prototype.acceptQuest(self, playerId, questId)
    local quest = self:getQuest(questId)
    if not quest then
        return false
    end
    local playerData = self:getPlayerData(playerId)
    if not playerData then
        return false
    end
    if playerData.quests:has(questId) or playerData.completedQuests:has(questId) or playerData.failedQuests:has(questId) then
        return false
    end
    if quest.requiredQuests and #quest.requiredQuests > 0 then
        for ____, requiredId in ipairs(quest.requiredQuests) do
            if not playerData.completedQuests:has(requiredId) then
                return false
            end
        end
    end
    local acceptedQuest = __TS__ObjectAssign(
        {},
        quest,
        {
            status = ____exports.QuestStatus.IN_PROGRESS,
            createdAt = now(nil),
            updatedAt = now(nil),
            startTime = now(nil)
        }
    )
    playerData.quests:set(questId, acceptedQuest)
    return true
end
function QuestDatabase.prototype.completeQuest(self, playerId, questId)
    local playerData = self:getPlayerData(playerId)
    if not playerData then
        return false
    end
    local quest = playerData.quests:get(questId)
    if not quest then
        return false
    end
    local allObjectivesCompleted = __TS__ArrayEvery(
        quest.objectives,
        function(____, obj) return obj.completed end
    )
    if not allObjectivesCompleted then
        return false
    end
    quest.status = ____exports.QuestStatus.COMPLETED
    quest.updatedAt = now(nil)
    playerData.quests:delete(questId)
    playerData.completedQuests:add(questId)
    return true
end
function QuestDatabase.prototype.abandonQuest(self, playerId, questId)
    local playerData = self:getPlayerData(playerId)
    if not playerData then
        return false
    end
    local quest = playerData.quests:get(questId)
    if not quest then
        return false
    end
    if quest.status ~= ____exports.QuestStatus.IN_PROGRESS then
        return false
    end
    quest.status = ____exports.QuestStatus.UNDISCOVERED
    playerData.quests:delete(questId)
    return true
end
function QuestDatabase.prototype.failQuest(self, playerId, questId)
    local playerData = self:getPlayerData(playerId)
    if not playerData then
        return false
    end
    local quest = playerData.quests:get(questId)
    if not quest then
        return false
    end
    if quest.status ~= ____exports.QuestStatus.IN_PROGRESS then
        return false
    end
    quest.status = ____exports.QuestStatus.FAILED
    quest.updatedAt = now(nil)
    playerData.quests:delete(questId)
    playerData.failedQuests:add(questId)
    return true
end
function QuestDatabase.prototype.updateObjective(self, playerId, questId, objectiveId, progress)
    local playerData = self:getPlayerData(playerId)
    if not playerData then
        return false
    end
    local quest = playerData.quests:get(questId)
    if not quest then
        return false
    end
    local objective = __TS__ArrayFind(
        quest.objectives,
        function(____, obj) return obj.id == objectiveId end
    )
    if not objective then
        return false
    end
    objective.current = math.min(progress, objective.required)
    objective.completed = objective.current >= objective.required
    quest.updatedAt = now(nil)
    return true
end
function QuestDatabase.prototype.getPlayerActiveQuests(self, playerId)
    local playerData = self:getPlayerData(playerId)
    if not playerData then
        return {}
    end
    return __TS__ArrayFilter(
        __TS__ArrayFrom(playerData.quests:values()),
        function(____, quest) return quest.status == ____exports.QuestStatus.IN_PROGRESS end
    )
end
function QuestDatabase.prototype.getPlayerCompletedQuests(self, playerId)
    local playerData = self:getPlayerData(playerId)
    if not playerData then
        return {}
    end
    return __TS__ArrayFrom(playerData.completedQuests)
end
function QuestDatabase.prototype.getPlayerQuestStatus(self, playerId, questId)
    local playerData = self:getPlayerData(playerId)
    if not playerData then
        return nil
    end
    local quest = playerData.quests:get(questId)
    if quest then
        return quest.status
    end
    if playerData.completedQuests:has(questId) then
        return ____exports.QuestStatus.COMPLETED
    end
    if playerData.failedQuests:has(questId) then
        return ____exports.QuestStatus.FAILED
    end
    return ____exports.QuestStatus.UNDISCOVERED
end
function QuestDatabase.prototype.resetPlayerData(self, playerId)
    self.playerData:delete(playerId)
    self:initPlayerData(playerId)
end
function QuestDatabase.prototype.clearAll(self)
    self.quests:clear()
    self.playerData:clear()
end
____exports.questDB = ____exports.QuestDatabase:getInstance()
function ____exports.createTestQuests(self)
    local db = ____exports.QuestDatabase:getInstance()
    do
        local i = 1
        while i <= 99 do
            local id = "main_" .. (i < 10 and "00" .. tostring(i) or (i < 100 and "0" .. tostring(i) or "" .. tostring(i)))
            local title = "主线任务" .. (i < 10 and "00" .. tostring(i) or (i < 100 and "0" .. tostring(i) or "" .. tostring(i)))
            db:registerQuest({
                id = id,
                type = ____exports.QuestType.MAIN,
                title = title,
                description = "完成基础训练，了解游戏操作",
                objectives = {{
                    id = "obj1",
                    description = "击败训练假人",
                    current = 0,
                    required = 5,
                    completed = false
                }, {
                    id = "obj2",
                    description = "学习技能",
                    current = 0,
                    required = 1,
                    completed = false
                }},
                rewards = {{type = "experience", value = 100, description = "100经验"}, {type = "gold", value = 50, description = "50金币"}},
                status = ____exports.QuestStatus.UNDISCOVERED,
                requiredLevel = 1,
                zone = "新手村",
                icon = "ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp",
                createdAt = now(nil),
                updatedAt = now(nil)
            })
            i = i + 1
        end
    end
    db:registerQuest({
        id = "side_002",
        type = ____exports.QuestType.SIDE,
        title = "击杀步兵",
        description = "击杀1个步兵，任务奖励：200金币",
        objectives = {{
            id = "obj1",
            description = "击杀1个步兵",
            current = 0,
            required = 1,
            completed = false
        }},
        rewards = {{type = "gold", value = 200, description = "200金币"}},
        status = ____exports.QuestStatus.UNDISCOVERED,
        requiredLevel = 1,
        zone = "战场",
        icon = "ReplaceableTextures\\CommandButtons\\BTNFootman.blp",
        createdAt = now(nil),
        updatedAt = now(nil)
    })
    db:registerQuest({
        id = "side_001",
        type = ____exports.QuestType.SIDE,
        title = "收集材料",
        description = "为铁匠收集10个铁矿",
        objectives = {{
            id = "obj1",
            description = "收集铁矿",
            current = 0,
            required = 10,
            completed = false
        }},
        rewards = {{type = "item", value = 0, itemId = "item_iron_sword", description = "铁剑"}, {type = "gold", value = 30, description = "30金币"}},
        status = ____exports.QuestStatus.UNDISCOVERED,
        requiredLevel = 3,
        requiredQuests = {"main_001"},
        zone = "矿山",
        icon = "ReplaceableTextures\\CommandButtons\\BTNIronForge.blp",
        createdAt = now(nil),
        updatedAt = now(nil)
    })
    db:registerQuest({
        id = "daily_001",
        type = ____exports.QuestType.DAILY,
        title = "日常巡逻",
        description = "巡逻村庄周边，确保安全",
        objectives = {{
            id = "obj1",
            description = "巡逻指定区域",
            current = 0,
            required = 3,
            completed = false
        }},
        rewards = {{type = "experience", value = 50, description = "50经验"}, {type = "gold", value = 20, description = "20金币"}},
        status = ____exports.QuestStatus.UNDISCOVERED,
        requiredLevel = 2,
        zone = "村庄",
        icon = "ReplaceableTextures\\CommandButtons\\BTNPeon.blp",
        timeLimit = 3600,
        createdAt = now(nil),
        updatedAt = now(nil)
    })
end
return ____exports]]

P['系统/07_任务/任务目标更新.lua'] = [=[--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____4EFB_52A1_7BA1_7406_5668 = require("系统.07_任务.任务管理器")
local handleObjectiveUpdated = _____4EFB_52A1_7BA1_7406_5668.handleObjectiveUpdated
--- 任务系统 - "目标更新"事件桥接
-- 
-- 设计目标：
-- - JASS 端在"任务目标进度更新"时，通过 STES + Bridge_STES_Register 触发一个自定义事件；
-- - TS / Lua 端在这里统一接收事件，根据全局变量更新任务目标进度。
-- 
-- 约定：
-- - 只能调用：STES_Register(udg_RegTrigger, udg_RegEventStr)
-- - Lua 侧流程：
--   1) 创建 Trigger 并设置回调；
--   2) 写入 jass.globals.udg_RegTrigger = trig；
--   3) 写入 jass.globals.udg_RegEventStr = "LuaEvent_QuestObjectiveUpdate"；
--   4) jass.ExecuteFunc("Bridge_STES_Register") 交给 JASS 侧调用 STES_Register。
-- 
-- 触发前需设置的全局变量：
-- - udg_QuestPlayerId: 玩家ID
-- - udg_QuestId: 任务ID字符串
-- - udg_ObjectiveId: 目标ID字符串
-- - udg_Progress: 当前进度值
local jass = require("jass.common")
local g = require("jass.globals")
local function debugPrint(self, msg)
    local pr = _G.print
    if pr ~= nil then
        pr("[QuestObjective] " .. msg)
    end
    if type(jass.DisplayTimedTextToPlayer) == "function" then
        jass.DisplayTimedTextToPlayer(
            jass.Player(0),
            0,
            0,
            8,
            "[任务目标] " .. msg
        )
    end
end
local function registerObjectiveUpdateEvent(self)
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" or type(jass.ExecuteFunc) ~= "function" then
        debugPrint(nil, "JASS API 不完整，无法注册目标更新事件")
        return
    end
    local trig = jass.CreateTrigger()
    jass.TriggerAddAction(
        trig,
        function()
            debugPrint(nil, "目标更新事件触发，调用任务管理器...")
            do
                local function ____catch(____error)
                    debugPrint(
                        nil,
                        "处理目标更新事件时出错: " .. tostring(____error)
                    )
                end
                local ____try, ____hasReturned = pcall(function()
                    handleObjectiveUpdated(nil)
                end)
                if not ____try then
                    ____catch(____hasReturned)
                end
            end
        end
    )
    g.udg_RegTrigger = trig
    g.udg_RegEventStr = "LuaEvent_QuestObjectiveUpdate"
    jass.ExecuteFunc("Bridge_STES_Register")
    debugPrint(nil, "已通过 Bridge_STES_Register 注册 LuaEvent_QuestObjectiveUpdate")
end
local function init(self)
    registerObjectiveUpdateEvent(nil)
end
init(nil)
return ____exports]=]

P['系统/07_任务/任务管理器.lua'] = [[local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local Map = ____lualib.Map
local __TS__ArrayEvery = ____lualib.__TS__ArrayEvery
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local ____exports = {}
local _____4EFB_52A1_6570_636E = require("系统.07_任务.任务数据")
local questDB = _____4EFB_52A1_6570_636E.questDB
local QuestType = _____4EFB_52A1_6570_636E.QuestType
local QuestStatus = _____4EFB_52A1_6570_636E.QuestStatus
local createTestQuests = _____4EFB_52A1_6570_636E.createTestQuests
--- 任务系统 - 任务管理器和事件处理
local jass = require("jass.common")
local g = require("jass.globals")
local function debugPrint(self, msg)
    local pr = _G.print
    if pr ~= nil then
        pr("[QuestManager] " .. msg)
    end
    if type(jass.DisplayTimedTextToPlayer) == "function" then
        jass.DisplayTimedTextToPlayer(
            jass.Player(0),
            0,
            0,
            8,
            "[任务管理器] " .. msg
        )
    end
end
--- 任务管理器类
____exports.QuestManager = __TS__Class()
local QuestManager = ____exports.QuestManager
QuestManager.name = "QuestManager"
function QuestManager.prototype.____constructor(self)
    self.isInitialized = false
    self.uiRefreshCallbacks = {}
end
function QuestManager.getInstance(self)
    if not ____exports.QuestManager.instance then
        ____exports.QuestManager.instance = __TS__New(____exports.QuestManager)
    end
    return ____exports.QuestManager.instance
end
function QuestManager.prototype.initialize(self)
    if self.isInitialized then
        return
    end
    debugPrint(nil, "初始化任务系统...")
    createTestQuests(nil)
    do
        local i = 0
        while i < 12 do
            questDB:initPlayerData(i)
            i = i + 1
        end
    end
    do
        local i = 1
        while i <= 99 do
            local id = "main_" .. (i < 10 and "00" .. tostring(i) or (i < 100 and "0" .. tostring(i) or "" .. tostring(i)))
            questDB:acceptQuest(0, id)
            i = i + 1
        end
    end
    questDB:acceptQuest(0, "side_002")
    self:setupWar3QuestSync()
    self.isInitialized = true
    debugPrint(nil, "任务系统初始化完成")
end
function QuestManager.prototype.getPlayerHero(self, playerId)
    if type(jass.FirstOfGroup) ~= "function" or type(jass.CreateGroup) ~= "function" or type(jass.GroupEnumUnitsOfPlayer) ~= "function" or type(jass.DestroyGroup) ~= "function" then
        return nil
    end
    local group = jass.CreateGroup()
    jass.GroupEnumUnitsOfPlayer(
        group,
        jass.Player(playerId),
        nil
    )
    local hero = nil
    local unit = jass.FirstOfGroup(group)
    if unit and type(jass.IsUnitType) == "function" and jass.IsUnitType(unit, jass.UNIT_TYPE_HERO) then
        hero = unit
    end
    jass.DestroyGroup(group)
    return hero
end
function QuestManager.prototype.setupWar3QuestSync(self)
    debugPrint(nil, "War3原生任务同步已就绪")
end
function QuestManager.prototype.setupTimeLimit(self, playerId, questId)
    local ____opt_2 = questDB:getPlayerData(playerId)
    local quest = ____opt_2 and ____opt_2.quests:get(questId)
    if not quest or not quest.timeLimit or quest.timeLimit <= 0 then
        return
    end
    if type(jass.CreateTimer) ~= "function" or type(jass.TimerStart) ~= "function" or type(jass.GetExpiredTimer) ~= "function" then
        debugPrint(nil, "计时器API不可用，无法设置时间限制")
        return
    end
    local timer = jass.CreateTimer()
    if not timer then
        return
    end
    local ____G___questTimers_5 = _G.__questTimers
    if not ____G___questTimers_5 then
        local ____TS__New_result_4 = __TS__New(Map)
        _G.__questTimers = ____TS__New_result_4
        ____G___questTimers_5 = ____TS__New_result_4
    end
    local timerData = ____G___questTimers_5
    timerData:set(timer, {playerId = playerId, questId = questId})
    jass.TimerStart(
        timer,
        quest.timeLimit,
        false,
        function()
            local expired = jass.GetExpiredTimer()
            local ____opt_6 = _G.__questTimers
            if ____opt_6 ~= nil then
                ____opt_6 = ____opt_6:get(expired)
            end
            local data = ____opt_6
            if data then
                debugPrint(
                    nil,
                    ("任务 " .. tostring(data.questId)) .. " 时间到期"
                )
                ____exports.questManager:onQuestFailed(data.playerId, data.questId)
                _G.__questTimers:delete(expired)
            end
            if type(jass.PauseTimer) == "function" then
                jass.PauseTimer(expired)
            end
            if type(jass.DestroyTimer) == "function" then
                jass.DestroyTimer(expired)
            end
        end
    )
    debugPrint(
        nil,
        ((("已为任务 " .. questId) .. " 设置 ") .. tostring(quest.timeLimit)) .. " 秒时间限制"
    )
end
function QuestManager.prototype.onQuestFailed(self, playerId, questId)
    debugPrint(
        nil,
        ((("玩家 " .. tostring(playerId)) .. " 任务 ") .. questId) .. " 失败"
    )
    local success = questDB:failQuest(playerId, questId)
    if success then
        self:triggerUIRefresh(playerId, questId)
        self:showQuestFailedMessage(playerId, questId)
    else
        debugPrint(
            nil,
            ((("玩家 " .. tostring(playerId)) .. " 任务 ") .. questId) .. " 失败处理失败"
        )
    end
    return success
end
function QuestManager.prototype.onQuestAbandoned(self, playerId, questId)
    debugPrint(
        nil,
        (("玩家 " .. tostring(playerId)) .. " 放弃任务 ") .. questId
    )
    local ____opt_10 = questDB:getPlayerData(playerId)
    local ____opt_8 = ____opt_10 and ____opt_10.quests:get(questId)
    local nativeHandle = ____opt_8 and ____opt_8.nativeHandle
    local success = questDB:abandonQuest(playerId, questId)
    if success then
        if nativeHandle and type(jass.DestroyQuest) == "function" then
            jass.DestroyQuest(nativeHandle)
        end
        self:triggerUIRefresh(playerId, questId)
        if type(jass.DisplayTimedTextToPlayer) == "function" then
            local player = jass.Player(playerId)
            if player then
                jass.DisplayTimedTextToPlayer(
                    player,
                    0,
                    0,
                    8,
                    "已放弃任务: " .. questId
                )
            end
        end
    else
        debugPrint(
            nil,
            ((("玩家 " .. tostring(playerId)) .. " 放弃任务 ") .. questId) .. " 失败"
        )
    end
    return success
end
function QuestManager.prototype.toggleQuestTracking(self, playerId, questId)
    local ____opt_12 = questDB:getPlayerData(playerId)
    local questData = ____opt_12 and ____opt_12.quests:get(questId)
    if not questData then
        return false
    end
    debugPrint(nil, "已追踪任务 " .. questId)
    local player = jass.Player(playerId)
    if player and type(jass.DisplayTimedTextToPlayer) == "function" then
        jass.DisplayTimedTextToPlayer(
            player,
            0,
            0,
            6,
            "正在追踪: " .. questData.title
        )
    end
    self:triggerUIRefresh(playerId, questId)
    return true
end
function QuestManager.prototype.showQuestFailedMessage(self, playerId, questId)
    local quest = questDB:getQuest(questId)
    if not quest then
        return
    end
    local player = jass.Player(playerId)
    if not player then
        return
    end
    if type(jass.DisplayTimedTextToPlayer) == "function" then
        local message = "任务失败: " .. quest.title
        jass.DisplayTimedTextToPlayer(
            player,
            0,
            0,
            10,
            message
        )
    end
end
function QuestManager.prototype.registerUIRefreshCallback(self, callback)
    local ____self_uiRefreshCallbacks_14 = self.uiRefreshCallbacks
    ____self_uiRefreshCallbacks_14[#____self_uiRefreshCallbacks_14 + 1] = callback
end
function QuestManager.prototype.triggerUIRefresh(self, playerId, questId)
    for ____, callback in ipairs(self.uiRefreshCallbacks) do
        do
            local function ____catch(____error)
                debugPrint(
                    nil,
                    "UI刷新回调错误: " .. tostring(____error)
                )
            end
            local ____try, ____hasReturned = pcall(function()
                callback(nil, playerId, questId)
            end)
            if not ____try then
                ____catch(____hasReturned)
            end
        end
    end
end
function QuestManager.prototype.onQuestAccepted(self, playerId, questId)
    debugPrint(
        nil,
        (("玩家 " .. tostring(playerId)) .. " 接受任务 ") .. questId
    )
    local success = questDB:acceptQuest(playerId, questId)
    if success then
        self:setupTimeLimit(playerId, questId)
        self:triggerUIRefresh(playerId, questId)
        self:showQuestAcceptedMessage(playerId, questId)
    else
        debugPrint(
            nil,
            ((("玩家 " .. tostring(playerId)) .. " 接受任务 ") .. questId) .. " 失败"
        )
    end
    return success
end
function QuestManager.prototype.onQuestCompleted(self, playerId, questId)
    debugPrint(
        nil,
        (("玩家 " .. tostring(playerId)) .. " 完成任务 ") .. questId
    )
    local success = questDB:completeQuest(playerId, questId)
    if success then
        self:giveQuestRewards(playerId, questId)
        self:triggerUIRefresh(playerId, questId)
        self:showQuestCompletedMessage(playerId, questId)
    else
        debugPrint(
            nil,
            ((("玩家 " .. tostring(playerId)) .. " 完成任务 ") .. questId) .. " 失败"
        )
    end
    return success
end
function QuestManager.prototype.updateQuestObjective(self, playerId, questId, objectiveId, progress)
    local success = questDB:updateObjective(playerId, questId, objectiveId, progress)
    if success then
        self:triggerUIRefresh(playerId, questId)
        local ____opt_15 = questDB:getPlayerData(playerId)
        local quest = ____opt_15 and ____opt_15.quests:get(questId)
        if quest and __TS__ArrayEvery(
            quest.objectives,
            function(____, obj) return obj.completed end
        ) then
            self:onQuestCompleted(playerId, questId)
        end
    end
    return success
end
function QuestManager.prototype.getPlayerQuests(self, playerId, ____type)
    local activeQuests = questDB:getPlayerActiveQuests(playerId)
    if not ____type then
        return activeQuests
    end
    return __TS__ArrayFilter(
        activeQuests,
        function(____, quest) return quest.type == ____type end
    )
end
function QuestManager.prototype.getAvailableQuests(self, playerId, ____type)
    return questDB:getAvailableQuests(playerId, ____type)
end
function QuestManager.prototype.getQuestData(self, questId)
    return questDB:getQuest(questId)
end
function QuestManager.prototype.getPlayerQuestStatus(self, playerId, questId)
    return questDB:getPlayerQuestStatus(playerId, questId)
end
function QuestManager.prototype.syncToWar3Quest(self, playerId, questId)
    if type(jass.CreateQuest) ~= "function" then
        return
    end
    local ____opt_17 = questDB:getPlayerData(playerId)
    local questData = ____opt_17 and ____opt_17.quests:get(questId)
    if not questData then
        return
    end
    if questData.nativeHandle and type(jass.DestroyQuest) == "function" then
        jass.DestroyQuest(questData.nativeHandle)
    end
    local nativeQuest = jass.CreateQuest()
    questData.nativeHandle = nativeQuest
    if not nativeQuest then
        return
    end
    if type(jass.QuestSetTitle) == "function" then
        jass.QuestSetTitle(nativeQuest, questData.title)
    end
    if type(jass.QuestSetDescription) == "function" then
        jass.QuestSetDescription(nativeQuest, questData.description)
    end
    if questData.icon and type(jass.QuestSetIconPath) == "function" then
        jass.QuestSetIconPath(nativeQuest, questData.icon)
    end
    if type(jass.QuestSetRequired) == "function" then
        jass.QuestSetRequired(nativeQuest, questData.type == QuestType.MAIN)
    end
    repeat
        local ____switch72 = questData.status
        local ____cond72 = ____switch72 == QuestStatus.IN_PROGRESS
        if ____cond72 then
            if type(jass.QuestSetDiscovered) == "function" then
                jass.QuestSetDiscovered(nativeQuest, true)
            end
            break
        end
        ____cond72 = ____cond72 or ____switch72 == QuestStatus.COMPLETED
        if ____cond72 then
            if type(jass.QuestSetCompleted) == "function" then
                jass.QuestSetCompleted(nativeQuest, true)
            end
            break
        end
        ____cond72 = ____cond72 or ____switch72 == QuestStatus.FAILED
        if ____cond72 then
            if type(jass.QuestSetFailed) == "function" then
                jass.QuestSetFailed(nativeQuest, true)
            end
            break
        end
    until true
    debugPrint(nil, ("已同步任务 " .. questId) .. " 到War3原生任务系统")
end
function QuestManager.prototype.giveQuestRewards(self, playerId, questId)
    local quest = questDB:getQuest(questId)
    if not quest then
        return
    end
    local player = jass.Player(playerId)
    if not player then
        return
    end
    local hero = self:getPlayerHero(playerId)
    for ____, reward in ipairs(quest.rewards) do
        repeat
            local ____switch80 = reward.type
            local ____cond80 = ____switch80 == "experience"
            if ____cond80 then
                if hero and type(jass.AddHeroXP) == "function" then
                    jass.AddHeroXP(hero, reward.value, true)
                    debugPrint(
                        nil,
                        ((("给予玩家 " .. tostring(playerId)) .. " ") .. tostring(reward.value)) .. " 经验"
                    )
                else
                    debugPrint(nil, "无法给予经验：未找到英雄或API不可用")
                end
                break
            end
            ____cond80 = ____cond80 or ____switch80 == "gold"
            if ____cond80 then
                if type(jass.SetPlayerState) == "function" and type(jass.GetPlayerState) == "function" then
                    local currentGold = jass.GetPlayerState(player, jass.PLAYER_STATE_RESOURCE_GOLD) or 0
                    jass.SetPlayerState(player, jass.PLAYER_STATE_RESOURCE_GOLD, currentGold + reward.value)
                    debugPrint(
                        nil,
                        ((("给予玩家 " .. tostring(playerId)) .. " ") .. tostring(reward.value)) .. " 金币"
                    )
                end
                break
            end
            ____cond80 = ____cond80 or ____switch80 == "item"
            if ____cond80 then
                if hero and type(jass.CreateItem) == "function" and type(jass.UnitAddItemById) == "function" and reward.itemId then
                    local itemTypeId = jass.FourCC(reward.itemId)
                    jass.UnitAddItemById(hero, itemTypeId)
                    debugPrint(
                        nil,
                        (("给予玩家 " .. tostring(playerId)) .. " 物品 ") .. reward.description
                    )
                else
                    debugPrint(nil, "无法给予物品：未找到英雄或API不可用")
                end
                break
            end
            ____cond80 = ____cond80 or ____switch80 == "attribute"
            if ____cond80 then
                if hero and type(jass.SetHeroStr) == "function" and type(jass.SetHeroAgi) == "function" and type(jass.SetHeroInt) == "function" then
                    jass.SetHeroStr(
                        hero,
                        jass.GetHeroStr(hero, false) + reward.value,
                        true
                    )
                    jass.SetHeroAgi(
                        hero,
                        jass.GetHeroAgi(hero, false) + reward.value,
                        true
                    )
                    jass.SetHeroInt(
                        hero,
                        jass.GetHeroInt(hero, false) + reward.value,
                        true
                    )
                    debugPrint(
                        nil,
                        ((("给予玩家 " .. tostring(playerId)) .. " ") .. tostring(reward.value)) .. " 全属性"
                    )
                end
                break
            end
            do
                debugPrint(nil, "未知奖励类型: " .. reward.type)
            end
        until true
    end
end
function QuestManager.prototype.showQuestAcceptedMessage(self, playerId, questId)
    local quest = questDB:getQuest(questId)
    if not quest then
        return
    end
    local player = jass.Player(playerId)
    if not player then
        return
    end
    if type(jass.DisplayTimedTextToPlayer) == "function" then
        local message = (("已接受任务: " .. quest.title) .. "\n") .. quest.description
        jass.DisplayTimedTextToPlayer(
            player,
            0,
            0,
            10,
            message
        )
    end
end
function QuestManager.prototype.showQuestCompletedMessage(self, playerId, questId)
    local quest = questDB:getQuest(questId)
    if not quest then
        return
    end
    local player = jass.Player(playerId)
    if not player then
        return
    end
    if type(jass.DisplayTimedTextToPlayer) == "function" then
        local message = ("任务完成: " .. quest.title) .. "\n已获得奖励！"
        jass.DisplayTimedTextToPlayer(
            player,
            0,
            0,
            10,
            message
        )
    end
end
function QuestManager.prototype.resetPlayerQuests(self, playerId)
    questDB:resetPlayerData(playerId)
    debugPrint(
        nil,
        ("已重置玩家 " .. tostring(playerId)) .. " 的任务数据"
    )
end
function QuestManager.prototype.getStatus(self)
    local allQuests = questDB:getAllQuests()
    return {initialized = self.isInitialized, questCount = #allQuests}
end
____exports.questManager = ____exports.QuestManager:getInstance()
--- 处理任务接受事件
-- JASS端应该在触发事件前设置全局变量：
-- - udg_QuestPlayerId: 玩家ID
-- - udg_QuestId: 任务ID字符串（或数字转换为字符串）
function ____exports.handleQuestAccepted(self)
    local playerId = g.udg_QuestPlayerId
    local questId = g.udg_QuestId
    if playerId == nil or questId == nil then
        debugPrint(nil, "任务接受事件缺少参数: udg_QuestPlayerId 或 udg_QuestId")
        return
    end
    ____exports.questManager:onQuestAccepted(playerId, questId)
end
--- 处理任务完成事件
-- JASS端应该在触发事件前设置全局变量：
-- - udg_QuestPlayerId: 玩家ID
-- - udg_QuestId: 任务ID字符串
function ____exports.handleQuestCompleted(self)
    local playerId = g.udg_QuestPlayerId
    local questId = g.udg_QuestId
    if playerId == nil or questId == nil then
        debugPrint(nil, "任务完成事件缺少参数: udg_QuestPlayerId 或 udg_QuestId")
        return
    end
    ____exports.questManager:onQuestCompleted(playerId, questId)
end
--- 处理任务目标更新事件
-- JASS端应该在触发事件前设置全局变量：
-- - udg_QuestPlayerId: 玩家ID
-- - udg_QuestId: 任务ID字符串
-- - udg_ObjectiveId: 目标ID字符串
-- - udg_Progress: 进度值
function ____exports.handleObjectiveUpdated(self)
    local playerId = g.udg_QuestPlayerId
    local questId = g.udg_QuestId
    local objectiveId = g.udg_ObjectiveId
    local progress = g.udg_Progress
    if playerId == nil or questId == nil or objectiveId == nil or progress == nil then
        debugPrint(nil, "任务目标更新事件缺少参数")
        return
    end
    ____exports.questManager:updateQuestObjective(playerId, questId, objectiveId, progress)
end
--- 处理任务失败事件
-- JASS端应该在触发事件前设置全局变量：
-- - udg_QuestPlayerId: 玩家ID
-- - udg_QuestId: 任务ID字符串
function ____exports.handleQuestFailed(self)
    local playerId = g.udg_QuestPlayerId
    local questId = g.udg_QuestId
    if playerId == nil or questId == nil then
        debugPrint(nil, "任务失败事件缺少参数: udg_QuestPlayerId 或 udg_QuestId")
        return
    end
    ____exports.questManager:onQuestFailed(playerId, questId)
end
--- 处理任务放弃事件
-- JASS端应该在触发事件前设置全局变量：
-- - udg_QuestPlayerId: 玩家ID
-- - udg_QuestId: 任务ID字符串
function ____exports.handleQuestAbandoned(self)
    local playerId = g.udg_QuestPlayerId
    local questId = g.udg_QuestId
    if playerId == nil or questId == nil then
        debugPrint(nil, "任务放弃事件缺少参数: udg_QuestPlayerId 或 udg_QuestId")
        return
    end
    ____exports.questManager:onQuestAbandoned(playerId, questId)
end
function ____exports.init(self)
    ____exports.questManager:initialize()
end
return ____exports]]

P['系统/伤害/dot伤害.lua'] = [[local ____lualib = require("lualib_bundle")
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local ____exports = {}
--- 【通用 DOT 框架】持续伤害/减益（如反恢复、燃烧、中毒等）统一在此注册与驱动。
-- 
-- 设计说明（给后续维护或 AI 参考）：
-- - 每种 DOT 通过 registerDotType(config) 注册，配置里包含：解析装备 Buff、取“最强”参数、算每秒伤害、伤害类型、特效模型等。
-- - 覆盖规则：新效果×新持续 > 当前效果×当前剩余 才覆盖；同一次或自己 DOT 触发的伤害不会重复施加（通过 ignoredTargetByType 忽略）。
-- - 共用一套计时器：tickTimer 每 TICK 秒减 remaining；dotTimer 每 1 秒按条目的 amount 造成伤害并播特效；effectRecycleTimer 统一回收特效，无单次计时器泄漏。
-- - 若某 DOT 需要“附加效果”（如 10 秒内减 50 攻），可在 config 里提供 onApply/onTick/onEnd 回调，在施加/每跳/结束时执行。
-- 
-- 当前仅注册一种：反恢复（装备 Buff:dmg:AntiHeal200%;time3，精神伤害，持续 3 秒，每秒 regenHP×200%）。
local jass = require("jass.common")
local g = require("jass.globals")
local damageEventModule = require("系统.伤害.伤害事件")
local leakCore = require("系统.00_核心.泄露审计")
local ____leakCore_LeakWatcher_0 = leakCore.LeakWatcher
if ____leakCore_LeakWatcher_0 == nil then
    ____leakCore_LeakWatcher_0 = leakCore
end
local LeakWatcher = ____leakCore_LeakWatcher_0
local TICK = 0.25
--- 伤害类型位：2048=技能 256=精神，用于 Lua 造成的伤害在事件里显示正确文案
local DAMAGE_TYPE_SKILL = 2048
local DAMAGE_TYPE_MIND = 256
local dotTypes = {}
--- 注册一种 DOT，后续伤害回调会按配置解析装备并施加/覆盖
function ____exports.registerDotType(self, config)
    dotTypes[#dotTypes + 1] = config
end
--- 按类型、再按目标存状态。stateByType[typeId][target] = { effect, remaining, ... }
local stateByType = {}
local dotTicks = {}
--- 刚被我们「某类型」伤害打到的单位，下一帧伤害回调里跳过对该类型施加，避免 DOT 触发的伤害再次叠 DOT
local ignoredTargetByType = {}
local tickTimer = nil
local dotTimer = nil
--- 特效回收：每 0.2s 检查，到期 DestroyEffect；只用一个周期计时器，不创建单次计时器
local EFFECT_RECYCLE_INTERVAL = 0.2
local effectRecycleList = {}
local effectRecycleTimer = nil
local itemsData = require("系统.装备.装备数据").items or require("系统.装备.装备数据").default or ({})
local function fourCCToString(self, fourcc)
    local c1 = string.char(fourcc % 256)
    local c2 = string.char(math.floor(fourcc / 256) % 256)
    local c3 = string.char(math.floor(fourcc / 65536) % 256)
    local c4 = string.char(math.floor(fourcc / 16777216) % 256)
    return ((c4 .. c3) .. c2) .. c1
end
local function unitItemInSlot(self, unit, slot)
    if type(jass.UnitItemInSlot) ~= "function" then
        return nil
    end
    return jass.UnitItemInSlot(unit, slot)
end
local function getItemTypeId(self, item)
    if type(jass.GetItemTypeId) ~= "function" then
        return 0
    end
    return jass.GetItemTypeId(item)
end
--- 来源是否为玩家 1–4 的英雄（当前仅这类来源会触发装备 DOT）
local function isSourceHeroPlayer1to4(self, unit)
    if not unit or type(jass.GetOwningPlayer) ~= "function" or type(jass.IsUnitType) ~= "function" then
        return false
    end
    local owner = jass.GetOwningPlayer(unit)
    local playerIdx = -1
    do
        local i = 0
        while i <= 15 do
            if jass.Player(i) == owner then
                playerIdx = i
                break
            end
            i = i + 1
        end
    end
    if playerIdx < 0 or playerIdx > 3 then
        return false
    end
    local ____temp_1
    if jass.ConvertUnitType and jass.UNIT_TYPE_HERO ~= nil then
        ____temp_1 = jass.ConvertUnitType(jass.UNIT_TYPE_HERO)
    else
        ____temp_1 = nil
    end
    local utHero = ____temp_1
    if utHero == nil then
        return true
    end
    return jass.IsUnitType(unit, utHero) == true
end
local function tick(self)
    for typeId in pairs(stateByType) do
        do
            local __continue16
            repeat
                local tab = stateByType[typeId]
                if tab == nil then
                    __continue16 = true
                    break
                end
                for k in pairs(tab) do
                    do
                        local __continue18
                        repeat
                            local v = tab[k]
                            if v == nil then
                                __continue18 = true
                                break
                            end
                            v.remaining = v.remaining - TICK
                            if v.remaining <= 0 then
                                local cfg = __TS__ArrayFind(
                                    dotTypes,
                                    function(____, c) return c.id == typeId end
                                )
                                if cfg ~= nil and type(cfg.onEnd) == "function" then
                                    cfg:onEnd(k, v)
                                end
                                __TS__Delete(tab, k)
                            end
                            __continue18 = true
                        until true
                        if not __continue18 then
                            break
                        end
                    end
                end
                __continue16 = true
            until true
            if not __continue16 then
                break
            end
        end
    end
    local hasAny = false
    for typeId in pairs(stateByType) do
        do
            local __continue25
            repeat
                local tab = stateByType[typeId]
                if tab == nil then
                    __continue25 = true
                    break
                end
                for _ in pairs(tab) do
                    hasAny = true
                    break
                end
                if hasAny then
                    break
                end
                __continue25 = true
            until true
            if not __continue25 then
                break
            end
        end
    end
    if not hasAny and tickTimer ~= nil then
        LeakWatcher:destroyTimer(tickTimer)
        tickTimer = nil
    end
end
--- 在目标身上挂特效，model/duration 由调用方传入；回收走统一列表
local function addDotEffectOnUnit(self, unit, model, duration)
    if not unit or type(jass.AddSpecialEffectTarget) ~= "function" then
        return
    end
    local eff = jass.AddSpecialEffectTarget(model, unit, "origin")
    if eff == nil then
        return
    end
    if type(jass.YDWETimerDestroyEffect) == "function" then
        jass.YDWETimerDestroyEffect(duration, eff)
        return
    end
    local ticks = math.ceil(duration / EFFECT_RECYCLE_INTERVAL)
    effectRecycleList[#effectRecycleList + 1] = {eff = eff, ticksLeft = ticks}
    if effectRecycleTimer == nil and type(jass.TimerStart) == "function" then
        effectRecycleTimer = LeakWatcher:createTimer("dot_effectRecycle")
        jass.TimerStart(
            effectRecycleTimer,
            EFFECT_RECYCLE_INTERVAL,
            true,
            function()
                do
                    local i = #effectRecycleList - 1
                    while i >= 0 do
                        local x = effectRecycleList[i + 1]
                        x.ticksLeft = x.ticksLeft - 1
                        if x.ticksLeft <= 0 then
                            if x.eff ~= nil and type(jass.DestroyEffect) == "function" then
                                jass.DestroyEffect(x.eff)
                            end
                            __TS__ArraySplice(effectRecycleList, i, 1)
                        end
                        i = i - 1
                    end
                end
                if #effectRecycleList == 0 and effectRecycleTimer ~= nil then
                    LeakWatcher:destroyTimer(effectRecycleTimer)
                    effectRecycleTimer = nil
                end
            end
        )
    end
end
--- 造成指定类型的 DOT 伤害，并标记该目标为本类型“自伤”，避免回调里再次施加。来源/目标写入 udg_TempUnit[4]/[3] 供 JASS 读
local function dealDamageForType(self, typeId, source, target, amount)
    if type(jass.UnitDamageTarget) ~= "function" then
        return
    end
    local cfg = __TS__ArrayFind(
        dotTypes,
        function(____, c) return c.id == typeId end
    )
    if cfg == nil then
        return
    end
    local j = jass
    if j.udg_TempUnit ~= nil then
        j.udg_TempUnit[3] = target
        j.udg_TempUnit[4] = source
    end
    if ignoredTargetByType[typeId] == nil then
        ignoredTargetByType[typeId] = {}
    end
    ignoredTargetByType[typeId][target] = true
    damageEventModule:setNextDamageTypeOverride(DAMAGE_TYPE_SKILL + DAMAGE_TYPE_MIND)
    jass.UnitDamageTarget(
        source,
        target,
        amount,
        false,
        false,
        jass.ATTACK_TYPE_NORMAL,
        cfg.damageType,
        jass.WEAPON_TYPE_WHOKNOWS
    )
end
local function dotTickRun(self)
    do
        local i = #dotTicks - 1
        while i >= 0 do
            local e = dotTicks[i + 1]
            dealDamageForType(
                nil,
                e.typeId,
                e.source,
                e.target,
                e.amount
            )
            addDotEffectOnUnit(nil, e.target, e.effectModel, e.effectDuration)
            local cfg = __TS__ArrayFind(
                dotTypes,
                function(____, c) return c.id == e.typeId end
            )
            local ____temp_2
            if stateByType[e.typeId] ~= nil then
                ____temp_2 = stateByType[e.typeId][e.target]
            else
                ____temp_2 = nil
            end
            local state = ____temp_2
            if cfg ~= nil and type(cfg.onTick) == "function" and state ~= nil then
                cfg:onTick(e.target, state)
            end
            e.ticksLeft = e.ticksLeft - 1
            if e.ticksLeft <= 0 then
                __TS__ArraySplice(dotTicks, i, 1)
            end
            i = i - 1
        end
    end
    if #dotTicks == 0 and dotTimer ~= nil then
        LeakWatcher:destroyTimer(dotTimer)
        dotTimer = nil
    end
end
local function onDamage(self, target, damage, damageType)
    if not target or damage <= 0 then
        return
    end
    local j = jass
    local ____temp_3
    if j.udg_TempUnit ~= nil and j.udg_TempUnit[6] ~= nil then
        ____temp_3 = j.udg_TempUnit[6]
    else
        ____temp_3 = nil
    end
    local source = ____temp_3
    if not source then
        return
    end
    if not isSourceHeroPlayer1to4(nil, source) then
        return
    end
    do
        local t = 0
        while t < #dotTypes do
            do
                local __continue61
                repeat
                    local cfg = dotTypes[t + 1]
                    local typeId = cfg.id
                    if ignoredTargetByType[typeId] ~= nil and ignoredTargetByType[typeId][target] == true then
                        __TS__Delete(ignoredTargetByType[typeId], target)
                        __continue61 = true
                        break
                    end
                    local best = cfg:getBestFromUnit(source)
                    if best == nil then
                        __continue61 = true
                        break
                    end
                    local amount = cfg:computeAmount(target, best)
                    if amount <= 0 then
                        __continue61 = true
                        break
                    end
                    if stateByType[typeId] == nil then
                        stateByType[typeId] = {}
                    end
                    local tab = stateByType[typeId]
                    local cur = tab[target]
                    local currentProduct = cur ~= nil and cur.effect * cur.remaining or 0
                    local newProduct = amount * best.duration
                    if newProduct <= currentProduct then
                        __continue61 = true
                        break
                    end
                    if cur ~= nil and type(cfg.onEnd) == "function" then
                        cfg:onEnd(target, cur)
                    end
                    local state = {effect = amount, remaining = best.duration}
                    tab[target] = state
                    if type(cfg.onApply) == "function" then
                        cfg:onApply(target, state)
                    end
                    do
                        local i = #dotTicks - 1
                        while i >= 0 do
                            if dotTicks[i + 1].target == target and dotTicks[i + 1].typeId == typeId then
                                __TS__ArraySplice(dotTicks, i, 1)
                            end
                            i = i - 1
                        end
                    end
                    dotTicks[#dotTicks + 1] = {
                        typeId = typeId,
                        source = source,
                        target = target,
                        amount = amount,
                        ticksLeft = best.duration,
                        effectModel = cfg.effectModel,
                        effectDuration = cfg.effectDuration
                    }
                    if dotTimer == nil and type(jass.TimerStart) == "function" then
                        dotTimer = LeakWatcher:createTimer("dot_tick")
                        jass.TimerStart(dotTimer, 1, true, dotTickRun)
                    end
                    if tickTimer == nil and type(jass.TimerStart) == "function" then
                        tickTimer = LeakWatcher:createTimer("dot_state")
                        jass.TimerStart(tickTimer, TICK, true, tick)
                    end
                    __continue61 = true
                until true
                if not __continue61 then
                    break
                end
            end
            t = t + 1
        end
    end
end
local function parseAntiHealBuff(self, buffStr)
    if not buffStr or type(buffStr) ~= "string" then
        return nil
    end
    local s = __TS__StringTrim(buffStr)
    if (string.find(s, "Buff:dmg:", nil, true) or 0) - 1 ~= 0 then
        return nil
    end
    local rest = __TS__StringSubstring(s, 9)
    local antiIdx = (string.find(rest, "AntiHeal", nil, true) or 0) - 1
    if antiIdx < 0 then
        return nil
    end
    local numEnd = antiIdx + 8
    while numEnd < #rest do
        local c = __TS__StringCharAt(rest, numEnd)
        if c >= "0" and c <= "9" then
            numEnd = numEnd + 1
        else
            break
        end
    end
    local effectPct = numEnd > antiIdx + 8 and (__TS__ParseInt(
        __TS__StringSubstring(rest, antiIdx + 8, numEnd),
        10
    ) or 0) or 0
    local timeIdx = (string.find(rest, "time", nil, true) or 0) - 1
    if timeIdx < 0 then
        return nil
    end
    local tEnd = timeIdx + 4
    while tEnd < #rest do
        local c = __TS__StringCharAt(rest, tEnd)
        if c >= "0" and c <= "9" then
            tEnd = tEnd + 1
        else
            break
        end
    end
    local duration = tEnd > timeIdx + 4 and (__TS__ParseInt(
        __TS__StringSubstring(rest, timeIdx + 4, tEnd),
        10
    ) or 0) or 0
    if duration <= 0 then
        return nil
    end
    return {effectPct = effectPct, duration = duration}
end
local function getTargetRegenHP(self, targetUnit)
    if type(jass.GetUnitTypeId) ~= "function" or not targetUnit then
        return 0
    end
    local typeId = jass.GetUnitTypeId(targetUnit)
    local idStr = fourCCToString(nil, typeId)
    local slk = _G.slk
    local slkUnit = slk ~= nil and slk.unit and slk.unit[idStr] or nil
    if slkUnit == nil then
        return 0
    end
    local regenStr = slkUnit.regenHP or slkUnit.regenHP
    if regenStr == nil or type(regenStr) ~= "string" then
        return 0
    end
    local n = __TS__ParseFloat(regenStr)
    return type(n) == "number" and not __TS__NumberIsNaN(__TS__Number(n)) and n or 0
end
local function getBestAntiHealFromUnit(self, unit)
    local best = nil
    do
        local slot = 0
        while slot <= 5 do
            do
                local __continue92
                repeat
                    local item = unitItemInSlot(nil, unit, slot)
                    if not item then
                        __continue92 = true
                        break
                    end
                    local idStr = fourCCToString(
                        nil,
                        getItemTypeId(nil, item)
                    )
                    local entry = itemsData[idStr]
                    local ____temp_6
                    if (entry and entry.Buff) ~= nil then
                        ____temp_6 = parseAntiHealBuff(nil, entry.Buff)
                    else
                        ____temp_6 = nil
                    end
                    local parsed = ____temp_6
                    if not parsed then
                        __continue92 = true
                        break
                    end
                    local product = parsed.effectPct * parsed.duration
                    if best == nil or product > best.product then
                        best = {effectPct = parsed.effectPct, duration = parsed.duration, product = product}
                    end
                    __continue92 = true
                until true
                if not __continue92 then
                    break
                end
            end
            slot = slot + 1
        end
    end
    return best ~= nil and ({effectPct = best.effectPct, duration = best.duration}) or nil
end
____exports.registerDotType(
    nil,
    {
        id = "antiHeal",
        parseBuff = parseAntiHealBuff,
        getBestFromUnit = getBestAntiHealFromUnit,
        computeAmount = function(____, target, parsed)
            local regenHP = getTargetRegenHP(nil, target)
            return regenHP * (parsed.effectPct / 100)
        end,
        damageType = jass.DAMAGE_TYPE_MIND,
        effectModel = "Abilities\\Spells\\NightElf\\CorrosiveBreath\\ChimaeraAcidTargetArt.mdl",
        effectDuration = 0.8
    }
)
local registered = false
local function init(self, damageEvent)
    if registered then
        return
    end
    registered = true
    damageEvent:registerDamageCallback(function(____, unit, damage, dmgType)
        onDamage(nil, unit, damage, dmgType)
    end)
end
--- 供治疗等系统读取：单位当前反恢复状态，无则返回 null
function ____exports.getUnitAntiHeal(self, unit)
    local tab = stateByType.antiHeal
    local ____temp_8
    if tab ~= nil then
        local ____tab_unit_7 = tab[unit]
        if ____tab_unit_7 == nil then
            ____tab_unit_7 = nil
        end
        ____temp_8 = ____tab_unit_7
    else
        ____temp_8 = nil
    end
    return ____temp_8
end
--- 造成精神伤害（供外部直接调用，如其他技能）；会标记 target 以免伤害回调再次施加同源 DOT。来源/目标由 dealDamageForType 写入 udg_TempUnit[4]/[3] 供 JASS 读
function ____exports.dealSpiritDamage(self, source, target, amount)
    dealDamageForType(
        nil,
        "antiHeal",
        source,
        target,
        amount
    )
end
init(nil, damageEventModule)
return ____exports]]

P['系统/伤害/伤害事件.lua'] = [[local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local ____exports = {}
local getEventUnitDamaged, lowestSetBit, onAnyUnitDamagedAction, runDeferredDamageDisplay, recreateDamageTrigger, jass, g, EVENT_UNIT_DAMAGED_ID, DamageEventQueue, DamageCallbacks, DamageEventNumber, MNDamageEventTrigger, ta, UnitGroup, damagePendingQueue, remainingType, remainingHigh, ATTR_BITS
function getEventUnitDamaged(self)
    if type(jass.ConvertUnitEvent) == "function" then
        return jass.ConvertUnitEvent(EVENT_UNIT_DAMAGED_ID)
    end
    return nil
end
--- 检测位标志（Lua5.1 无 & 运算符）
function ____exports.hasBit(self, v, ____bit)
    return math.floor(v / ____bit) % 2 >= 1
end
function lowestSetBit(self, v)
    do
        local i = 0
        while i < #ATTR_BITS do
            if ____exports.hasBit(nil, v, ATTR_BITS[i + 1]) then
                return ATTR_BITS[i + 1]
            end
            i = i + 1
        end
    end
    return 0
end
function onAnyUnitDamagedAction(self)
    local gu = g
    local j = jass
    local ____temp_7
    if type(jass.GetTriggerUnit) == "function" then
        ____temp_7 = jass.GetTriggerUnit()
    else
        local ____temp_6
        if j.udg_TempUnit ~= nil then
            ____temp_6 = j.udg_TempUnit[5]
        else
            ____temp_6 = nil
        end
        ____temp_7 = ____temp_6
    end
    local savedUnit = ____temp_7
    local jr = jass.udg_TempReal
    local ____temp_8
    if type(jass.GetEventDamage) == "function" then
        ____temp_8 = jass.GetEventDamage()
    else
        ____temp_8 = jr ~= nil and type(jr[1]) == "number" and jr[1] or 0
    end
    local savedDamage = ____temp_8
    local savedSource = nil
    if type(g.GetEventDamageSource) == "function" then
        savedSource = g:GetEventDamageSource()
    end
    if savedSource == nil and type(jass.GetEventDamageSource) == "function" then
        savedSource = jass.GetEventDamageSource()
    end
    if savedSource == nil and type(jass.BlzGetEventDamageSource) == "function" then
        savedSource = jass.BlzGetEventDamageSource()
    end
    if savedSource == nil and j.udg_TempUnit ~= nil and j.udg_TempUnit[6] ~= nil then
        savedSource = j.udg_TempUnit[6]
    end
    if j.udg_TempUnit ~= nil then
        j.udg_TempUnit[5] = savedUnit
        if savedSource ~= nil then
            j.udg_TempUnit[6] = savedSource
        end
    end
    if jr ~= nil then
        jr[10] = 0
    end
    local i = 0
    while i < DamageEventNumber do
        local trg = DamageEventQueue[i + 1]
        if trg ~= nil and type(jass.IsTriggerEnabled) == "function" and jass.IsTriggerEnabled(trg) then
            if type(jass.TriggerEvaluate) == "function" and jass.TriggerEvaluate(trg) then
                if type(jass.TriggerExecute) == "function" then
                    jass.TriggerExecute(trg)
                end
            end
        end
        i = i + 1
    end
    if type(jass.CreateTimer) == "function" and type(jass.TimerStart) == "function" then
        local tRead = jass.CreateTimer()
        local function afterRead()
            if type(jass.DestroyTimer) == "function" then
                jass.DestroyTimer(tRead)
            end
            local jrAfter = jass.udg_TempReal
            local ____temp_9
            if jrAfter ~= nil then
                ____temp_9 = jrAfter[10]
            else
                ____temp_9 = nil
            end
            local tr10 = ____temp_9
            if jrAfter ~= nil then
                jrAfter[10] = 0
            end
            local finalDamage = savedDamage
            if type(tr10) == "number" and not __TS__NumberIsNaN(__TS__Number(tr10)) and tr10 > 0 then
                finalDamage = tr10
            end
            if jr ~= nil then
                jr[1] = finalDamage
            end
            local override = g.__nextDamageTypeOverride
            if override ~= nil then
                g.__nextDamageTypeOverride = nil
            end
            damagePendingQueue[#damagePendingQueue + 1] = {
                unit = savedUnit,
                damage = finalDamage,
                source = savedSource,
                damageTypeOverride = type(override) == "number" and override or nil
            }
            runDeferredDamageDisplay(nil)
        end
        jass.TimerStart(tRead, 0, false, afterRead)
    else
        local jrAfter = jass.udg_TempReal
        local ____temp_10
        if jrAfter ~= nil then
            ____temp_10 = jrAfter[10]
        else
            ____temp_10 = nil
        end
        local tr10 = ____temp_10
        if jrAfter ~= nil then
            jrAfter[10] = 0
        end
        local finalDamage = savedDamage
        if type(tr10) == "number" and not __TS__NumberIsNaN(__TS__Number(tr10)) and tr10 > 0 then
            finalDamage = tr10
        end
        if jr ~= nil then
            jr[1] = finalDamage
        end
        local override = g.__nextDamageTypeOverride
        if override ~= nil then
            g.__nextDamageTypeOverride = nil
        end
        damagePendingQueue[#damagePendingQueue + 1] = {
            unit = savedUnit,
            damage = finalDamage,
            source = savedSource,
            damageTypeOverride = type(override) == "number" and override or nil
        }
        runDeferredDamageDisplay(nil)
    end
end
function runDeferredDamageDisplay(self)
    local gu = g
    if type(jass.CreateTimer) == "function" and type(jass.TimerStart) == "function" then
        local t = jass.CreateTimer()
        local function deferred()
            if type(jass.DestroyTimer) == "function" then
                jass.DestroyTimer(t)
            end
            local entry = table.remove(damagePendingQueue, 1)
            if entry == nil then
                return
            end
            local su = entry.unit
            local sd = entry.damage
            local j = jass
            if j.udg_TempUnit ~= nil then
                j.udg_TempUnit[5] = su
                local ____j_udg_TempUnit_12 = j.udg_TempUnit
                local ____temp_11
                if entry.source ~= nil then
                    ____temp_11 = entry.source
                else
                    ____temp_11 = j.udg_TempUnit[6]
                end
                ____j_udg_TempUnit_12[6] = ____temp_11
            end
            local mergedType
            local isFirstInBatch = false
            local isLastInBatch = false
            if entry.damageTypeOverride ~= nil and type(entry.damageTypeOverride) == "number" then
                mergedType = entry.damageTypeOverride
                isFirstInBatch = true
                isLastInBatch = true
            else
                if remainingType <= 0 then
                    isFirstInBatch = true
                    remainingHigh = 0
                    local raw = gu.udg_TempDamageType
                    local rawNum = type(raw) == "number" and raw or (raw == nil and 0 or __TS__Number(raw))
                    remainingType = rawNum - 2048 * math.floor(rawNum / 2048)
                    if remainingType < 0 then
                        remainingType = remainingType + 2048
                    end
                    remainingHigh = (____exports.hasBit(nil, rawNum, 2048) and 2048 or 0) + (____exports.hasBit(nil, rawNum, 4096) and 4096 or 0) + (____exports.hasBit(nil, rawNum, 8192) and 8192 or 0) + (____exports.hasBit(nil, rawNum, 16384) and 16384 or 0)
                    gu.udg_TempDamageType = 0
                end
                local oneBit = lowestSetBit(nil, remainingType)
                remainingType = remainingType - oneBit
                mergedType = oneBit + remainingHigh
                if remainingType <= 0 then
                    remainingHigh = 0
                    gu.udg_TempDamageType = 0
                end
                isFirstInBatch = remainingType <= 0
                isLastInBatch = remainingType <= 0
            end
            if remainingType <= 0 and entry.damageTypeOverride == nil then
                remainingHigh = 0
                gu.udg_TempDamageType = 0
            end
            ____exports.currentDamageType = mergedType
            do
                local c = 0
                while c < #DamageCallbacks do
                    local cb = DamageCallbacks[c + 1]
                    if type(cb) == "function" then
                        cb(nil, su,
                            sd,
                            mergedType,
                            isFirstInBatch,
                            isLastInBatch
                        )
                    end
                    c = c + 1
                end
            end
        end
        jass.TimerStart(t, 0, false, deferred)
    end
end
function recreateDamageTrigger(self)
    if MNDamageEventTrigger and type(jass.TriggerRemoveAction) == "function" and ta ~= nil then
        jass.TriggerRemoveAction(MNDamageEventTrigger, ta)
    end
    if MNDamageEventTrigger and type(jass.DestroyTrigger) == "function" then
        jass.DestroyTrigger(MNDamageEventTrigger)
    end
    if type(jass.CreateTrigger) == "function" then
        MNDamageEventTrigger = jass.CreateTrigger()
    end
    if MNDamageEventTrigger and type(jass.TriggerAddAction) == "function" then
        ta = jass.TriggerAddAction(MNDamageEventTrigger, onAnyUnitDamagedAction)
    end
    if UnitGroup and type(jass.ForGroup) == "function" and MNDamageEventTrigger then
        local ev = getEventUnitDamaged()
        if ev ~= nil then
            jass.ForGroup(
                UnitGroup,
                function()
                    local u = jass.GetEnumUnit()
                    if u and type(jass.TriggerRegisterUnitEvent) == "function" then
                        jass.TriggerRegisterUnitEvent(MNDamageEventTrigger, u, ev)
                    end
                end
            )
        end
    end
end
jass = require("jass.common")
g = require("jass.globals")
local ALOC = 1097625443
EVENT_UNIT_DAMAGED_ID = 52
DamageEventQueue = {}
DamageCallbacks = {}
DamageEventNumber = 0
--- 本次伤害的类型标志位（由 JASS udg_TempDamageType 读取后立即清零），供外部模块直接读取
____exports.currentDamageType = 0
MNDamageEventTrigger = nil
ta = nil
local TimerHandle = nil
UnitGroup = nil
damagePendingQueue = {}
--- Lua 造成的伤害（如 DOT）在调用 UnitDamageTarget 前调用此函数，传入合并类型（如 2048 技能+256 精神=2304），避免被 JASS GetDmgType 覆盖
function ____exports.setNextDamageTypeOverride(self, mergedType)
    g.__nextDamageTypeOverride = mergedType
end
remainingType = 0
remainingHigh = 0
ATTR_BITS = {
    1,
    2,
    4,
    8,
    16,
    32,
    64,
    128,
    256,
    512,
    1024
}
local function getUnitTypeHero(self)
    if type(jass.ConvertUnitType) == "function" then
        local ____self_1 = jass
        local ____self_1_ConvertUnitType_2 = ____self_1.ConvertUnitType
        local ____jass_UNIT_TYPE_HERO_0 = jass.UNIT_TYPE_HERO
        if ____jass_UNIT_TYPE_HERO_0 == nil then
            ____jass_UNIT_TYPE_HERO_0 = 1
        end
        return ____self_1_ConvertUnitType_2(____self_1, ____jass_UNIT_TYPE_HERO_0)
    end
    return nil
end
local function unitDeathCondition(self)
    local ____temp_3
    if type(jass.GetTriggerUnit) == "function" then
        ____temp_3 = jass.GetTriggerUnit()
    else
        ____temp_3 = nil
    end
    local u = ____temp_3
    if not u then
        return false
    end
    local utHero = getUnitTypeHero()
    local ____temp_4
    if utHero ~= nil and type(jass.IsUnitType) == "function" then
        ____temp_4 = jass.IsUnitType(u, utHero)
    else
        ____temp_4 = false
    end
    local isHero = ____temp_4
    return isHero ~= true
end
local function unitDeathAction(self)
    if not UnitGroup then
        return
    end
    local ____temp_5
    if type(jass.GetTriggerUnit) == "function" then
        ____temp_5 = jass.GetTriggerUnit()
    else
        ____temp_5 = nil
    end
    local u = ____temp_5
    if not u then
        return
    end
    if type(jass.GroupRemoveUnit) == "function" then
        jass.GroupRemoveUnit(UnitGroup, u)
    end
    recreateDamageTrigger()
end
local function anyUnitDamagedFilter(self)
    local ____temp_13
    if type(jass.GetFilterUnit) == "function" then
        ____temp_13 = jass.GetFilterUnit()
    else
        ____temp_13 = nil
    end
    local u = ____temp_13
    if not u then
        return false
    end
    local ____temp_14
    if type(jass.GetUnitAbilityLevel) == "function" then
        ____temp_14 = jass.GetUnitAbilityLevel(u, ALOC)
    else
        ____temp_14 = 0
    end
    local lvl = ____temp_14
    if lvl > 0 then
        return false
    end
    if UnitGroup and type(jass.GroupAddUnit) == "function" then
        jass.GroupAddUnit(UnitGroup, u)
    end
    if MNDamageEventTrigger and type(jass.TriggerRegisterUnitEvent) == "function" then
        local ev = getEventUnitDamaged()
        if ev ~= nil then
            jass.TriggerRegisterUnitEvent(MNDamageEventTrigger, u, ev)
        end
    end
    return false
end
local function initEnumUnit(self)
    local CreateTrigger = jass.CreateTrigger
    local CreateRegion = jass.CreateRegion
    local CreateGroup = jass.CreateGroup
    local GetWorldBounds = jass.GetWorldBounds
    local RegionAddRect = jass.RegionAddRect
    local TriggerRegisterEnterRegion = jass.TriggerRegisterEnterRegion
    local Condition = jass.Condition
    local TriggerAddCondition = jass.TriggerAddCondition
    local TriggerAddAction = jass.TriggerAddAction
    local GroupEnumUnitsInRect = jass.GroupEnumUnitsInRect
    local DestroyGroup = jass.DestroyGroup
    local RegisterPlayerUnitEvent = jass.TriggerRegisterPlayerUnitEvent
    local ____jass_EVENT_PLAYER_UNIT_DEATH_15 = jass.EVENT_PLAYER_UNIT_DEATH
    if ____jass_EVENT_PLAYER_UNIT_DEATH_15 == nil then
        ____jass_EVENT_PLAYER_UNIT_DEATH_15 = 52
    end
    local evDeath = ____jass_EVENT_PLAYER_UNIT_DEATH_15
    if type(CreateTrigger) ~= "function" or type(CreateRegion) ~= "function" then
        return
    end
    local t = CreateTrigger()
    local r = CreateRegion()
    local ____temp_16
    if type(CreateGroup) == "function" then
        ____temp_16 = CreateGroup()
    else
        ____temp_16 = nil
    end
    local grp = ____temp_16
    local ____temp_17
    if type(GetWorldBounds) == "function" then
        ____temp_17 = GetWorldBounds()
    else
        ____temp_17 = nil
    end
    local bounds = ____temp_17
    if bounds and type(RegionAddRect) == "function" then
        RegionAddRect(r, bounds)
    end
    if type(TriggerRegisterEnterRegion) == "function" then
        local ____temp_18
        if type(Condition) == "function" then
            ____temp_18 = Condition(anyUnitDamagedFilter)
        else
            ____temp_18 = nil
        end
        TriggerRegisterEnterRegion(t, r, ____temp_18)
    end
    if grp and bounds and type(GroupEnumUnitsInRect) == "function" and type(Condition) == "function" then
        local function alwaysTrue()
            return true
        end
        GroupEnumUnitsInRect(grp,
            bounds,
            Condition(alwaysTrue)
        )
        if UnitGroup and MNDamageEventTrigger and type(jass.ForGroup) == "function" and type(jass.TriggerRegisterUnitEvent) == "function" then
            jass.ForGroup(
                grp,
                function()
                    local u = jass.GetEnumUnit()
                    if not u then
                        return
                    end
                    local ____temp_19
                    if type(jass.GetUnitAbilityLevel) == "function" then
                        ____temp_19 = jass.GetUnitAbilityLevel(u, ALOC)
                    else
                        ____temp_19 = 0
                    end
                    local lvl = ____temp_19
                    if lvl > 0 then
                        return
                    end
                    jass.GroupAddUnit(UnitGroup, u)
                    local ev = getEventUnitDamaged()
                    if ev ~= nil and type(jass.TriggerRegisterUnitEvent) == "function" then
                        jass.TriggerRegisterUnitEvent(MNDamageEventTrigger, u, ev)
                    end
                end
            )
        end
    end
    local trideath = CreateTrigger()
    if type(RegisterPlayerUnitEvent) == "function" and evDeath ~= nil then
        do
            local pi = 0
            while pi <= 15 do
                local p = jass.Player(pi)
                if p ~= nil then
                    RegisterPlayerUnitEvent(trideath,
                        p,
                        evDeath,
                        nil
                    )
                end
                pi = pi + 1
            end
        end
    end
    if type(TriggerAddCondition) == "function" and type(Condition) == "function" then
        TriggerAddCondition(trideath,
            Condition(unitDeathCondition)
        )
    end
    if type(TriggerAddAction) == "function" then
        TriggerAddAction(trideath, unitDeathAction)
    end
    if type(DestroyGroup) == "function" and grp then
        DestroyGroup(grp)
    end
end
local function timeout(self)
    recreateDamageTrigger()
end
--- 注册一个触发器：当任意单位受到伤害时，若该触发器启用且条件通过则执行。
-- 
-- @param trg 触发器（需在 JASS/TS 中创建并设置 condition/action）
-- @param intervalSeconds 定期重建伤害触发的间隔（秒），用于避免泄漏/堆积
function ____exports.MNAnyUnitDamaged(self, trg, intervalSeconds)
    if trg == nil then
        return
    end
    if DamageEventNumber == 0 then
        if type(jass.CreateTrigger) == "function" then
            MNDamageEventTrigger = jass.CreateTrigger()
        end
        if type(jass.CreateGroup) == "function" then
            UnitGroup = jass.CreateGroup()
        end
        if MNDamageEventTrigger and type(jass.TriggerAddAction) == "function" then
            ta = jass.TriggerAddAction(MNDamageEventTrigger, onAnyUnitDamagedAction)
        end
        initEnumUnit()
        if type(jass.CreateTimer) == "function" and intervalSeconds > 0 then
            TimerHandle = jass.CreateTimer()
            if TimerHandle and type(jass.TimerStart) == "function" then
                jass.TimerStart(TimerHandle, intervalSeconds, true, timeout)
            end
        end
    end
    DamageEventQueue[DamageEventNumber + 1] = trg
    DamageEventNumber = DamageEventNumber + 1
end
--- 注册 Lua 回调：单位受伤时直接调用，不依赖 TriggerExecute（引擎可能不执行 Lua 动作）
function ____exports.registerDamageCallback(self, cb, intervalSeconds)
    if type(cb) ~= "function" then
        return
    end
    if MNDamageEventTrigger == nil then
        if type(jass.CreateTrigger) == "function" then
            MNDamageEventTrigger = jass.CreateTrigger()
        end
        if type(jass.CreateGroup) == "function" then
            UnitGroup = jass.CreateGroup()
        end
        if MNDamageEventTrigger and type(jass.TriggerAddAction) == "function" then
            ta = jass.TriggerAddAction(MNDamageEventTrigger, onAnyUnitDamagedAction)
        end
        initEnumUnit()
        local sec = type(intervalSeconds) == "number" and intervalSeconds > 0 and intervalSeconds or 60
        if type(jass.CreateTimer) == "function" then
            TimerHandle = jass.CreateTimer()
            if TimerHandle and type(jass.TimerStart) == "function" then
                jass.TimerStart(TimerHandle, sec, true, timeout)
            end
        end
    end
    DamageCallbacks[#DamageCallbacks + 1] = cb
end
return ____exports]]

P['系统/伤害/伤害测试.lua'] = [=[--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 伤害事件测试：任意单位受到伤害时发送「XX单位受到了XX伤害」
-- 若 JASS 里 YDWEIsEventDamageType(COLD) 将 udg_TempInteger[1] 置为 1，伤害事件在 JASS 后立即读出并传入 tempInteger，此处置 0 并发送 111。
local jass = require("jass.common")
local g = require("jass.globals")
local damageEvent = require("系统.伤害.伤害事件")
local function sendMsg(self, msg)
    if type(jass.DisplayTextToPlayer) ~= "function" then
        return
    end
    do
        local i = 0
        while i <= 15 do
            local p = jass.Player(i)
            if p ~= nil then
                jass.DisplayTextToPlayer(p, 0, 0, msg)
            end
            i = i + 1
        end
    end
end
local function onDamage(self, unit, damage, damageType, isFirstInBatch, isLastInBatch)
    if not unit then
        return
    end
    local hb = damageEvent.hasBit
    local ____temp_0
    if type(jass.GetUnitName) == "function" then
        ____temp_0 = jass.GetUnitName(unit)
    else
        ____temp_0 = "单位"
    end
    local name = ____temp_0
    local ____temp_1
    if type(jass.R2S) == "function" then
        ____temp_1 = jass.R2S(damage)
    else
        ____temp_1 = tostring(damage)
    end
    local damageStr = ____temp_1
    local isSkill = hb(nil, damageType, 2048)
    local isPhysical = hb(nil, damageType, 4096)
    local isAttack = hb(nil, damageType, 8192)
    local isRanged = hb(nil, damageType, 16384)
    local msg
    if isSkill then
        local attrNames = {
            {1, "普通"},
            {2, "强化"},
            {4, "火属性"},
            {8, "冰属性"},
            {16, "雷属性"},
            {32, "金属性"},
            {64, "光属性"},
            {128, "魔法"},
            {256, "精神"},
            {512, "风属性"},
            {1024, "暗属性"}
        }
        local detail = ""
        do
            local a = 0
            while a < #attrNames do
                if hb(nil, damageType, attrNames[a + 1][1]) then
                    detail = ("（" .. attrNames[a + 1][2]) .. "）"
                    break
                end
                a = a + 1
            end
        end
        if (isAttack or isRanged) and (isFirstInBatch or isLastInBatch) then
            msg = (((tostring(name) .. "受到了") .. tostring(damageStr)) .. "点技能攻击伤害") .. detail
        else
            msg = (((tostring(name) .. "受到了") .. tostring(damageStr)) .. "点技能伤害") .. detail
        end
    elseif isRanged then
        msg = (((tostring(name) .. "受到了") .. tostring(damageStr)) .. "点远程普攻") .. (isPhysical and "（物理）" or "")
    elseif isAttack then
        msg = (((tostring(name) .. "受到了") .. tostring(damageStr)) .. "点普攻伤害") .. (isPhysical and "（物理）" or "")
    else
        msg = ((tostring(name) .. "受到了") .. tostring(damageStr)) .. "点伤害"
    end
    local j = jass
    local ____temp_2
    if j.udg_TempUnit ~= nil and j.udg_TempUnit[6] ~= nil then
        ____temp_2 = j.udg_TempUnit[6]
    else
        ____temp_2 = nil
    end
    local source = ____temp_2
    if source ~= nil and type(jass.GetUnitName) == "function" then
        local sourceName = jass.GetUnitName(source)
        if sourceName ~= nil and sourceName ~= "" then
            msg = (msg .. " 伤害来源：") .. tostring(sourceName)
        end
    end
    sendMsg(
        nil,
        ((msg .. " [类型:") .. tostring(damageType)) .. "]"
    )
end
damageEvent:registerDamageCallback(onDamage, 60)
return ____exports]=]

P['系统/单位/单位狂暴.lua'] = [[local ____lualib = require("lualib_bundle")
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local ____exports = {}
--- 单位狂暴：装备掉落表里 berserk 非空的单位死亡时，按默认 6.25% 概率在原地创建指定单位、继承面向，并震动击杀者镜头。
-- 面向与镜头震动通过 JASS 全局 udg_TempUnit[1]/udg_TempReal[1]/udg_TempPlayer 调用 UnitBerserk。
local jass = require("jass.common")
local idData = require("系统.装备.装备掉落表").default or ({})
local function stringToFourCC(self, s)
    local b1 = string.byte(s, 1)
    local b2 = string.byte(s, 2)
    local b3 = string.byte(s, 3)
    local b4 = string.byte(s, 4)
    return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4
end
local function typeIdToUnitId(self, typeId)
    for id in pairs(idData) do
        if stringToFourCC(nil, id) == typeId then
            return id
        end
    end
    return nil
end
local function onDeath(self)
    local dying = jass.GetTriggerUnit()
    if not dying then
        return
    end
    if type(jass.GetUnitTypeId) ~= "function" then
        return
    end
    local typeId = jass.GetUnitTypeId(dying)
    local unitId = typeIdToUnitId(nil, typeId)
    local entry = unitId and idData[unitId] or nil
    local berserkRaw = entry and entry.berserk
    if berserkRaw == nil then
        return
    end
    local berserkId = __TS__StringTrim(tostring(berserkRaw))
    if berserkId == "" then
        return
    end
    local BERSERK_PROC = 0.0625
    if math.random(1, 10000) > BERSERK_PROC * 10000 then
        return
    end
    local x = 0
    local y = 0
    local facingDeg = 270
    if type(jass.GetUnitX) == "function" and type(jass.GetUnitY) == "function" then
        x = jass.GetUnitX(dying)
        y = jass.GetUnitY(dying)
    end
    if type(jass.GetUnitFacingDegrees) == "function" then
        facingDeg = jass.GetUnitFacingDegrees(dying)
    elseif type(jass.GetUnitFacing) == "function" then
        facingDeg = jass.GetUnitFacing(dying) * (180 / 3.14159265359)
    end
    local four = stringToFourCC(
        nil,
        __TS__StringSubstring(berserkId, 0, 4)
    )
    local ____temp_2
    if type(jass.GetOwningPlayer) == "function" then
        ____temp_2 = jass.GetOwningPlayer(dying)
    else
        ____temp_2 = jass.Player(15)
    end
    local owner = ____temp_2
    local created = nil
    if type(jass.CreateUnit) == "function" then
        created = jass.CreateUnit(
            owner,
            four,
            x,
            y,
            facingDeg
        )
    end
    local ____temp_3
    if type(jass.GetKillingUnit) == "function" then
        ____temp_3 = jass.GetKillingUnit()
    else
        ____temp_3 = nil
    end
    local killer = ____temp_3
    local ____temp_4
    if killer and type(jass.GetOwningPlayer) == "function" then
        ____temp_4 = jass.GetOwningPlayer(killer)
    else
        ____temp_4 = nil
    end
    local killerPlayer = ____temp_4
    if created and killerPlayer then
        jass.udg_TempUnit[1] = created
        jass.udg_TempReal[1] = facingDeg
        jass.udg_TempPlayer[1] = killerPlayer
        jass.ExecuteFunc("UnitBerserk")
    end
end
local function init(self)
    local trig = jass.CreateTrigger()
    local ____jass_EVENT_PLAYER_UNIT_DEATH_5 = jass.EVENT_PLAYER_UNIT_DEATH
    if ____jass_EVENT_PLAYER_UNIT_DEATH_5 == nil then
        ____jass_EVENT_PLAYER_UNIT_DEATH_5 = 52
    end
    local eventId = ____jass_EVENT_PLAYER_UNIT_DEATH_5
    do
        local i = 0
        while i < 16 do
            jass.TriggerRegisterPlayerUnitEvent(
                trig,
                jass.Player(i),
                eventId,
                nil
            )
            i = i + 1
        end
    end
    local ____this_8
    ____this_8 = jass
    local ____opt_6 = ____this_8.Player
    if ____opt_6 ~= nil then
        local ____jass_PLAYER_NEUTRAL_AGGRESSIVE_7 = jass.PLAYER_NEUTRAL_AGGRESSIVE
        if ____jass_PLAYER_NEUTRAL_AGGRESSIVE_7 == nil then
            ____jass_PLAYER_NEUTRAL_AGGRESSIVE_7 = 12
        end
        ____opt_6 = ____opt_6(____this_8, ____jass_PLAYER_NEUTRAL_AGGRESSIVE_7)
    end
    local neutral = ____opt_6
    if neutral ~= nil then
        jass.TriggerRegisterPlayerUnitEvent(trig, neutral, eventId, nil)
    end
    local ____this_11
    ____this_11 = jass
    local ____opt_9 = ____this_11.Player
    if ____opt_9 ~= nil then
        local ____jass_PLAYER_NEUTRAL_PASSIVE_10 = jass.PLAYER_NEUTRAL_PASSIVE
        if ____jass_PLAYER_NEUTRAL_PASSIVE_10 == nil then
            ____jass_PLAYER_NEUTRAL_PASSIVE_10 = 15
        end
        ____opt_9 = ____opt_9(____this_11, ____jass_PLAYER_NEUTRAL_PASSIVE_10)
    end
    local neutralPassive = ____opt_9
    if neutralPassive ~= nil then
        jass.TriggerRegisterPlayerUnitEvent(trig, neutralPassive, eventId, nil)
    end
    jass.TriggerAddAction(trig, onDeath)
end
init(nil)
return ____exports]]

P['系统/地形/区域传送.lua'] = [[local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local ____exports = {}
local _____533A_57DF_4F20_9001_914D_7F6E = require("系统.地形.区域传送配置")
local _____533A_57DF_4F20_9001_914D_7F6E = _____533A_57DF_4F20_9001_914D_7F6E.default
local _____955C_5934_7CFB_7EDF = require("系统.地形.镜头系统")
local panCameraToTimedForPlayer = _____955C_5934_7CFB_7EDF.panCameraToTimedForPlayer
--- 区域传送：
-- - 开局按 `区域传送配置` 批量创建 Region 并注册进入事件
-- - 单位进入 Region 时，根据配置表把单位瞬移到目标点、移动镜头、显示文字
-- - 只对非中立敌对玩家生效，传送后立刻下达 stop 命令防止继续走回去
local jass = require("jass.common")
local regionMap = __TS__New(Map)
local function dbg(self, _msg)
end
local function checkRegionCondition(self, cond, _unit)
    if not cond or cond == "always" then
        return true
    end
    return true
end
local function runRegionRule(self, rule, unit, owner)
    if not rule then
        return
    end
    local parts = __TS__StringSplit(rule, ";")
    local items = {}
    local totalWeight = 0
    for ____, raw in ipairs(parts) do
        do
            local __continue7
            repeat
                local s = __TS__StringTrim(raw)
                if not s then
                    __continue7 = true
                    break
                end
                local percentIdx = (string.find(s, "%", nil, true) or 0) - 1
                if percentIdx <= 0 then
                    __continue7 = true
                    break
                end
                local weightStr = __TS__StringTrim(__TS__StringSubstring(s, 0, percentIdx))
                local rest = __TS__StringTrim(__TS__StringSubstring(s, percentIdx + 1))
                local weight = __TS__Number(weightStr)
                if not weight or not __TS__NumberIsFinite(__TS__Number(weight)) or weight <= 0 then
                    __continue7 = true
                    break
                end
                local colonIdx = (string.find(rest, ":", nil, true) or 0) - 1
                local actionName = __TS__StringTrim(colonIdx >= 0 and __TS__StringSubstring(rest, 0, colonIdx) or rest)
                local param = colonIdx >= 0 and __TS__StringTrim(__TS__StringSubstring(rest, colonIdx + 1)) or ""
                if actionName == "KillUnit" then
                    items[#items + 1] = {weight = weight, action = "KillUnit", text = param}
                    totalWeight = totalWeight + weight
                elseif actionName == "传送" or string.lower(actionName) == "teleport" then
                    local coords = __TS__StringSplit(param, ",")
                    if #coords >= 2 then
                        local x = __TS__Number(coords[1])
                        local y = __TS__Number(coords[2])
                        if __TS__NumberIsFinite(__TS__Number(x)) and __TS__NumberIsFinite(__TS__Number(y)) then
                            items[#items + 1] = {weight = weight, action = "Teleport", x = x, y = y}
                            totalWeight = totalWeight + weight
                        end
                    end
                end
                __continue7 = true
            until true
            if not __continue7 then
                break
            end
        end
    end
    if #items == 0 or totalWeight <= 0 then
        return
    end
    local r
    if type(jass.GetRandomInt) == "function" then
        r = jass.GetRandomInt(1, totalWeight)
    else
        local m = math
        local ____temp_0
        if type(m.random) == "function" then
            ____temp_0 = m:random(1, totalWeight)
        else
            ____temp_0 = 1
        end
        r = ____temp_0
    end
    local chosen
    for ____, it in ipairs(items) do
        if r <= it.weight then
            chosen = it
            break
        end
        r = r - it.weight
    end
    if not chosen then
        chosen = items[#items]
    end
    local unitName = "单位"
    if type(jass.GetUnitName) == "function" then
        local n = jass.GetUnitName(unit)
        if n ~= nil then
            unitName = tostring(n)
        end
    end
    local function formatText(____, raw)
        if not raw then
            return nil
        end
        return table.concat(
            __TS__StringSplit(raw, "{unit}"),
            unitName or ","
        )
    end
    if chosen.action == "KillUnit" then
        if type(jass.KillUnit) == "function" then
            jass.KillUnit(unit)
        end
        local msg = formatText(nil, chosen.text)
        if msg and owner ~= nil and type(jass.DisplayTimedTextToPlayer) == "function" then
            jass.DisplayTimedTextToPlayer(
                owner,
                0,
                0,
                8,
                msg
            )
        end
    elseif chosen.action == "Teleport" then
        if type(jass.SetUnitPosition) == "function" and chosen.x ~= nil and chosen.y ~= nil then
            jass.SetUnitPosition(unit, chosen.x, chosen.y)
        end
        local msg = formatText(nil, nil)
        if msg and owner ~= nil and type(jass.DisplayTimedTextToPlayer) == "function" then
            jass.DisplayTimedTextToPlayer(
                owner,
                0,
                0,
                8,
                msg
            )
        end
    end
end
local function initRegionTeleport(self)
    if type(jass.CreateTrigger) ~= "function" then
        return
    end
    local trig = jass.CreateTrigger()
    local total = 0
    local enabledCount = 0
    for k in pairs(_____533A_57DF_4F20_9001_914D_7F6E) do
        total = total + 1
        local cfg = _____533A_57DF_4F20_9001_914D_7F6E[k]
        local enabled = cfg ~= nil and cfg.enabled
        if enabled then
            enabledCount = enabledCount + 1
        end
    end
    for k in pairs(_____533A_57DF_4F20_9001_914D_7F6E) do
        do
            local __continue38
            repeat
                local cfg = _____533A_57DF_4F20_9001_914D_7F6E[k]
                if cfg == nil or not cfg.enabled then
                    __continue38 = true
                    break
                end
                if type(jass.CreateRegion) ~= "function" then
                    __continue38 = true
                    break
                end
                local region = jass.CreateRegion()
                if type(jass.Rect) ~= "function" then
                    __continue38 = true
                    break
                end
                local rect = jass.Rect(cfg.left, cfg.bottom, cfg.right, cfg.top)
                if type(jass.RegionAddRect) == "function" then
                    jass.RegionAddRect(region, rect)
                end
                if type(jass.TriggerRegisterEnterRegion) == "function" then
                    jass.TriggerRegisterEnterRegion(trig, region, nil)
                end
                regionMap:set(region, cfg)
                __continue38 = true
            until true
            if not __continue38 then
                break
            end
        end
    end
    local function onEnter()
        local ____temp_1
        if type(jass.GetTriggerUnit) == "function" then
            ____temp_1 = jass.GetTriggerUnit()
        else
            ____temp_1 = nil
        end
        local unit = ____temp_1
        local ____temp_2
        if type(jass.GetTriggeringRegion) == "function" then
            ____temp_2 = jass.GetTriggeringRegion()
        else
            ____temp_2 = nil
        end
        local region = ____temp_2
        if unit == nil or region == nil then
            return
        end
        local ____temp_3
        if type(jass.GetOwningPlayer) == "function" then
            ____temp_3 = jass.GetOwningPlayer(unit)
        else
            ____temp_3 = nil
        end
        local owner = ____temp_3
        if owner ~= nil and type(jass.Player) == "function" and jass.PLAYER_NEUTRAL_AGGRESSIVE ~= nil then
            local neutralAgg = jass.Player(jass.PLAYER_NEUTRAL_AGGRESSIVE)
            if owner == neutralAgg then
                return
            end
        end
        local cfg = regionMap:get(region)
        if cfg == nil then
            return
        end
        if not checkRegionCondition(nil, cfg.condition, unit) then
            return
        end
        local useRule = cfg.teleportX == 0 and cfg.teleportY == 0 and type(cfg.rule) == "string" and #cfg.rule > 0
        if useRule then
            runRegionRule(nil, cfg.rule, unit, owner)
            return
        end
        if type(jass.SetUnitPosition) == "function" then
            jass.SetUnitPosition(unit, cfg.teleportX, cfg.teleportY)
        end
        if type(jass.IssueImmediateOrder) == "function" then
            jass.IssueImmediateOrder(unit, "stop")
        end
        local player = owner
        if player ~= nil then
            panCameraToTimedForPlayer(
                nil,
                player,
                cfg.teleportX,
                cfg.teleportY,
                cfg.cameraTime
            )
            if type(jass.DisplayTimedTextToPlayer) == "function" then
                jass.DisplayTimedTextToPlayer(
                    player,
                    0,
                    0,
                    8,
                    cfg.text
                )
            end
        end
    end
    if type(jass.TriggerAddAction) == "function" then
        jass.TriggerAddAction(trig, onEnter)
    end
end
--- 在游戏初始化时调用（建议用 0.00 秒计时器或地图初始化事件）
____exports["init区域传送"] = function(self)
    if type(jass.CreateTimer) == "function" and type(jass.TimerStart) == "function" then
        local t = jass.CreateTimer()
        jass.TimerStart(
            t,
            0,
            false,
            function()
                if type(jass.DestroyTimer) == "function" then
                    jass.DestroyTimer(t)
                end
                initRegionTeleport(nil)
            end
        )
    else
        initRegionTeleport(nil)
    end
end
return ____exports]]

P['系统/地形/区域传送配置.lua'] = [=[--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["区域传送配置"] = {
    ["1"] = {
        id = "1",
        name = "传送1",
        left = -640,
        bottom = -224,
        right = -416,
        top = 32,
        teleportX = 72,
        teleportY = -817,
        cameraTime = 0.1,
        text = "你触发了传送",
        condition = "always",
        enabled = true
    },
    ["2"] = {
        id = "2",
        name = "静林森-精灵村",
        left = -27520,
        bottom = -6592,
        right = -27264,
        top = -6304,
        teleportX = -29740.7,
        teleportY = -28601.9,
        cameraTime = 0.1,
        text = "|cffffff00『系统提示』|r：现在的场景为：|cff00ff00『精灵村』|r",
        condition = "always",
        firstEnterActions = "UpdateMapUI",
        enabled = false
    },
    ["3"] = {
        id = "3",
        name = "精灵村-静林森",
        left = -29952,
        bottom = -28704,
        right = -29696,
        top = -28448,
        teleportX = -27416.4,
        teleportY = -6632.5,
        cameraTime = 0.1,
        text = "|cffffff00『系统提示』|r：现在的场景为：|cffccffcc『静灵森』|r",
        condition = "zhuxian≤2",
        enabled = false
    },
    ["4"] = {
        id = "4",
        name = "精灵村-精灵村长老房",
        left = -29248,
        bottom = -27744,
        right = -28928,
        top = -27424,
        teleportX = 29666.3,
        teleportY = -29646.5,
        cameraTime = 0.1,
        text = "|cffffff00『系统提示』|r：现在的场景为：|cffccffcc『精灵村族长房』|r",
        condition = "always",
        enabled = false
    },
    ["5"] = {
        id = "5",
        name = "精灵村长老房-精灵村",
        left = 29728,
        bottom = -29760,
        right = 29920,
        top = -29536,
        teleportX = -29095.2,
        teleportY = -27851.3,
        cameraTime = 0.1,
        text = "|cffffff00『系统提示』|r：现在的场景为：|cffccffcc『精灵村』|r",
        condition = "always",
        enabled = false
    },
    ["6"] = {
        id = "6",
        name = "贤者房-精灵村",
        left = 26336,
        bottom = -30176,
        right = 26560,
        top = -30016,
        teleportX = -29661.8,
        teleportY = -28557.5,
        cameraTime = 0.1,
        text = "|cffffff00『系统提示』|r：现在的场景为：|cffccffcc『精灵村』|r",
        condition = "always",
        enabled = false
    },
    ["7"] = {
        id = "7",
        name = "精灵森-地精洞窟",
        left = -29504,
        bottom = -20064,
        right = -29248,
        top = -19872,
        teleportX = -29333.5,
        teleportY = -18411.7,
        cameraTime = 0.1,
        text = "|cffffff00『系统提示』|r：现在的场景为：|cff339966『地精洞窟』|r",
        condition = "always",
        firstEnterActions = "UpdateMapUI",
        enabled = false
    },
    ["8"] = {
        id = "8",
        name = "地精洞窟-精灵森",
        left = -29536,
        bottom = -18240,
        right = -29248,
        top = -17952,
        teleportX = -29339,
        teleportY = -20188.6,
        cameraTime = 0.1,
        text = "|cffffff00『系统提示』|r：现在的场景为：|cff339966『精灵森』|r",
        condition = "always",
        enabled = false
    },
    ["9"] = {
        id = "9",
        name = "地精洞窟-地精洞窟（深处）",
        left = -28608,
        bottom = -17376,
        right = -28352,
        top = -17184,
        teleportX = -29232.8,
        teleportY = -13945.9,
        cameraTime = 0.1,
        text = "|cffffff00『系统提示』|r：现在的场景为：|cff339966『地精洞窟』|r|cffff0000（深处）|r",
        condition = "zhuxian≥1",
        enabled = false
    },
    ["10"] = {
        id = "10",
        name = "地精洞窟（深处）-地精洞窟",
        left = -29536,
        bottom = -13728,
        right = -29248,
        top = -13440,
        teleportX = -28473.4,
        teleportY = -17542.3,
        cameraTime = 0.1,
        text = "|cffffff00『系统提示』|r：现在的场景为：|cff339966『地精洞窟』|r",
        condition = "always",
        enabled = false
    },
    ["11"] = {
        id = "11",
        name = "飓风沙漠-蛇人领地",
        left = 1728,
        bottom = -22112,
        right = 2048,
        top = -21504,
        teleportX = -25936,
        teleportY = 137.5,
        cameraTime = 0.1,
        text = "|cffffff00『系统提示』|r：现在的场景为：|cffff6600『蛇人领地』|r",
        condition = "zhuxian≥7",
        enabled = false
    },
    ["12"] = {
        id = "12",
        name = "蛇人领地-飓风沙漠",
        left = -26144,
        bottom = -192,
        right = -25728,
        top = -32,
        teleportX = 1572.9,
        teleportY = -21982.5,
        cameraTime = 0.1,
        text = "|cffffff00『系统提示』|r：现在的场景为：|cffffcc99『飓风沙漠』|r",
        condition = "always",
        enabled = false
    },
    ["13"] = {
        id = "13",
        name = "食人魔挑战",
        left = -640,
        bottom = -224,
        right = -416,
        top = 32,
        teleportX = 29791.9,
        teleportY = 11914.5,
        cameraTime = 0.1,
        condition = "zhuxian≥10",
        enabled = false
    },
    ["14"] = {
        id = "14",
        name = "长老房-精灵村圣物处",
        left = 28864,
        bottom = -28480,
        right = 29120,
        top = -28256,
        teleportX = 16287.9,
        teleportY = -29469.6,
        cameraTime = 0.1,
        text = "|cffffff00『系统提示』|r：现在的场景为：|cffff6600『西里尔村圣物处』|r",
        condition = "zhuxian≥19",
        enabled = false
    },
    ["15"] = {
        id = "15",
        name = "精灵村圣物处-长老房",
        left = 16192,
        bottom = 16384,
        right = -29344,
        top = -29152,
        teleportX = 29000.6,
        teleportY = -28626.1,
        cameraTime = 0.1,
        text = "|cffffff00『系统提示』|r：现在的场景为：|cffccffcc『精灵村族长房』|r",
        condition = "zhuxian≥19",
        enabled = false
    },
    ["16"] = {
        id = "16",
        name = "克林姆德城-克林姆德王宫",
        left = -10848,
        bottom = -10784,
        right = -10624,
        top = -10496,
        teleportX = 15901.3,
        teleportY = -26039,
        cameraTime = 0.1,
        text = "|cffffff00『系统提示』|r：现在的场景为：|cffff6600『克林姆德王宫』|r",
        condition = "zhuxian≥20",
        enabled = false
    },
    ["17"] = {
        id = "17",
        name = "克林姆德王宫-克林姆德城",
        left = 15776,
        bottom = -26464,
        right = 16128,
        top = -26336,
        teleportX = -10804.1,
        teleportY = -10578.7,
        cameraTime = 0.1,
        text = "|cffffff00『系统提示』|r：现在的场景为：|cffff6600『克林姆德城』|r",
        condition = "zhuxian≥20",
        enabled = false
    },
    ["18"] = {
        id = "18",
        name = "熔岩小镇-恶魔城",
        left = 9440,
        bottom = -21024,
        right = 9600,
        top = -20640,
        teleportX = 0,
        teleportY = 0,
        cameraTime = 0.1,
        text = "|cffffff00『系统提示』|r：现在的场景为：|cff993366『万浴熔灵』|r",
        condition = "always",
        rule = "40%KillUnit:跳入熔浆不知所踪;20%传送:14783,-14913;20%传送:19009,-11590;20%传送:21077,-16342",
        enabled = false
    },
    ["19"] = {
        id = "19",
        name = "熔岩迷宫-王之墓冢",
        left = 28448,
        bottom = -3360,
        right = 28864,
        top = -3136,
        teleportX = 10941,
        teleportY = -15743,
        cameraTime = 0.1,
        text = "|cffffff00『系统提示』|r：现在的场景为：|cff993366『王之墓冢』|r",
        condition = "zhuxian≥99",
        enabled = false
    }
}
____exports.default = ____exports["区域传送配置"]
return ____exports]=]

P['系统/地形/激活传送点.lua'] = [[local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local _____6FC0_6D3B_4F20_9001_70B9_914D_7F6E = require("系统.地形.激活传送点配置")
local _____6FC0_6D3B_4F20_9001_70B9_914D_7F6E = _____6FC0_6D3B_4F20_9001_70B9_914D_7F6E.default
--- 激活传送点系统：
-- - 根据《激活传送点配置》在地图上创建一次性 Region
-- - 单位首次进入时：删除用于检测的 Rect，可选地：
--   - 把配置里指定的单位交给玩家7（绿色，Player(6)）
--   - 为玩家1（红色，Player(0)）在指定 Rect 开视野
--   - 向所有玩家显示提示文字
local jass = require("jass.common")
local g = require("jass.globals")
local regionMap = __TS__New(Map)
local function dbg(self, _msg)
end
local function initActivationPointsInternal(self)
    if type(jass.CreateTrigger) ~= "function" or type(jass.CreateRegion) ~= "function" or type(jass.Rect) ~= "function" then
        return
    end
    local enabledCount = 0
    for key in pairs(_____6FC0_6D3B_4F20_9001_70B9_914D_7F6E) do
        do
            local __continue5
            repeat
                local cfg = _____6FC0_6D3B_4F20_9001_70B9_914D_7F6E[key]
                if not cfg or not cfg.enabled then
                    __continue5 = true
                    break
                end
                enabledCount = enabledCount + 1
                local region = jass.CreateRegion()
                local rect = jass.Rect(cfg.left, cfg.bottom, cfg.right, cfg.top)
                if type(jass.RegionAddRect) == "function" then
                    jass.RegionAddRect(region, rect)
                end
                local trig = jass.CreateTrigger()
                if type(jass.TriggerRegisterEnterRegion) == "function" then
                    jass.TriggerRegisterEnterRegion(trig, region, nil)
                end
                if type(jass.TriggerAddAction) == "function" then
                    local fired = false
                    jass.TriggerAddAction(
                        trig,
                        function()
                            if fired then
                                return
                            end
                            fired = true
                            local ____temp_0
                            if type(jass.GetTriggerUnit) == "function" then
                                ____temp_0 = jass.GetTriggerUnit()
                            else
                                ____temp_0 = nil
                            end
                            local unit = ____temp_0
                            if not unit then
                                return
                            end
                            if rect and type(jass.RemoveRect) == "function" then
                                jass.RemoveRect(rect)
                            end
                            if cfg.UnitID and type(jass.SetUnitOwner) == "function" and type(jass.Player) == "function" then
                                local u = g[cfg.UnitID]
                                local p6 = jass.Player(6)
                                if u and p6 then
                                    jass.SetUnitOwner(u, p6, true)
                                end
                            end
                            if cfg.reveal and type(jass.CreateFogModifierRect) == "function" and type(jass.FogModifierStart) == "function" and type(jass.Player) == "function" then
                                local revealRect = g[cfg.reveal]
                                if revealRect then
                                    local mode = jass.FOG_OF_WAR_VISIBLE
                                    local fog = jass.CreateFogModifierRect(
                                        jass.Player(0),
                                        mode,
                                        revealRect,
                                        true,
                                        false
                                    )
                                    jass.FogModifierStart(fog)
                                end
                            end
                            if cfg.text and type(jass.DisplayTimedTextToPlayer) == "function" and type(jass.Player) == "function" then
                                do
                                    local i = 0
                                    while i < 12 do
                                        jass.DisplayTimedTextToPlayer(
                                            jass.Player(i),
                                            0,
                                            0,
                                            8,
                                            cfg.text
                                        )
                                        i = i + 1
                                    end
                                end
                            end
                            if type(jass.DestroyTrigger) == "function" then
                                jass.DestroyTrigger(trig)
                            end
                            if type(jass.RemoveRegion) == "function" then
                                jass.RemoveRegion(region)
                            end
                        end
                    )
                end
                __continue5 = true
            until true
            if not __continue5 then
                break
            end
        end
    end
end
--- 在地图初始化时调用（建议用 0.00 秒计时器）
____exports["init激活传送点"] = function(self)
    if type(jass.CreateTimer) == "function" and type(jass.TimerStart) == "function" then
        local t = jass.CreateTimer()
        jass.TimerStart(
            t,
            0,
            false,
            function()
                if type(jass.DestroyTimer) == "function" then
                    jass.DestroyTimer(t)
                end
                initActivationPointsInternal(nil)
            end
        )
    else
        initActivationPointsInternal(nil)
    end
end
return ____exports]]

P['系统/地形/激活传送点配置.lua'] = [=[--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["激活传送点配置"] = {
    ["1"] = {
        id = "1",
        name = "111",
        left = 384,
        bottom = -288,
        right = 800,
        top = 192,
        UnitID = "gg_unit_htow_0030",
        text = "|cffffff00『系统提示』|r：激活了|cffff8080『精灵森』|r传送点。",
        reveal = "gg_rct______________002",
        enabled = true
    },
    ["2"] = {
        id = "2",
        name = "精灵森",
        left = -25344,
        bottom = -19328,
        right = -24832,
        top = -18976,
        UnitID = "gg_unit_n025_0373",
        text = "|cffffff00『系统提示』|r：激活了|cffff8080『精灵森』|r传送点。",
        reveal = "gg_rct________________RYEMC",
        enabled = false
    },
    ["3"] = {
        id = "3",
        name = "恶魔领地",
        left = 20896,
        bottom = -16224,
        right = 21280,
        top = -15744,
        UnitID = "gg_unit_ndrr_0005",
        text = "|cffffff00『系统提示』|r：激活『恶魔领地』传送点。",
        enabled = false
    },
    ["4"] = {
        id = "4",
        name = "恶魔迷宫口",
        left = 22752,
        bottom = -8832,
        right = 23424,
        top = -8128,
        UnitID = "gg_unit_ndrr_0036",
        text = "|cffffff00『系统提示』|r：激活『恶魔迷宫口』传送点。",
        enabled = false
    },
    ["5"] = {
        id = "5",
        name = "王之墓冢",
        left = 10144,
        bottom = -16352,
        right = 10720,
        top = -15808,
        UnitID = "gg_unit_ndrr_0069",
        text = "|cffffff00『系统提示』|r：激活『王之墓冢』传送点。",
        enabled = false
    }
}
____exports.default = ____exports["激活传送点配置"]
return ____exports]=]

P['系统/地形/镜头系统.lua'] = [=[--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 镜头系统：仅对指定玩家移动镜头（TS 重写 StarOther_PanCameraToTimedForPlayer 逻辑）。
-- 通过 GetLocalPlayer() 判断本地玩家，仅在该玩家等于 whichPlayer 时调用 PanCameraToTimed，避免多玩家不同步。
-- 
-- 使用：import { panCameraToTimedForPlayer } from './镜头系统'
local jass = require("jass.common")
--- 对指定玩家在指定时间内平移镜头到 (x, y)。
-- 仅在被移动镜头的玩家本地执行 PanCameraToTimed，其他玩家不受影响。
-- 
-- @param whichPlayer 要移动镜头的玩家（jhandle_t）
-- @param x 目标 X 坐标
-- @param y 目标 Y 坐标
-- @param duration 平移耗时（秒）
function ____exports.panCameraToTimedForPlayer(self, whichPlayer, x, y, duration)
    if type(jass.GetLocalPlayer) ~= "function" then
        return
    end
    local localPlayer = jass.GetLocalPlayer()
    if localPlayer ~= whichPlayer then
        return
    end
    if type(jass.PanCameraToTimed) ~= "function" then
        return
    end
    jass.PanCameraToTimed(x, y, duration)
end
return ____exports]=]

P['系统/测试/任务测试.lua'] = [=[--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____4EFB_52A1_7BA1_7406_5668 = require("系统.07_任务.任务管理器")
local questManager = _____4EFB_52A1_7BA1_7406_5668.questManager
local _____4EFB_52A1UI = require("系统.07_任务.任务UI")
local taskUI = _____4EFB_52A1UI.taskUI
local _____4EFB_52A1_6570_636E = require("系统.07_任务.任务数据")
local questDB = _____4EFB_52A1_6570_636E.questDB
local QuestType = _____4EFB_52A1_6570_636E.QuestType
local _____786C_4EF6_51FD_6570 = require("系统.00_核心.硬件函数")
local registerKeyDown = _____786C_4EF6_51FD_6570.registerKeyDown
local KEY_LETTER = _____786C_4EF6_51FD_6570.KEY_LETTER
--- 任务系统测试
local jass = require("jass.common")
local function debugPrint(self, msg)
    local pr = _G.print
    if pr ~= nil then
        pr("[QuestTest] " .. msg)
    end
    if type(jass.DisplayTimedTextToPlayer) == "function" then
        jass.DisplayTimedTextToPlayer(
            jass.Player(0),
            0,
            0,
            8,
            "[任务测试] " .. msg
        )
    end
end
--- 测试任务接受和完成
function ____exports.testQuestAcceptComplete(self)
    debugPrint(nil, "开始任务接受/完成测试...")
    local playerId = 0
    questManager:resetPlayerQuests(playerId)
    local questId = "main_001"
    local success = questManager:onQuestAccepted(playerId, questId)
    if success then
        debugPrint(
            nil,
            (("✓ 玩家 " .. tostring(playerId)) .. " 成功接受任务 ") .. questId
        )
    else
        debugPrint(
            nil,
            ((("✗ 玩家 " .. tostring(playerId)) .. " 接受任务 ") .. questId) .. " 失败"
        )
    end
    local quests = questManager:getPlayerQuests(playerId, QuestType.MAIN)
    debugPrint(
        nil,
        ((("玩家 " .. tostring(playerId)) .. " 进行中的主线任务: ") .. tostring(#quests)) .. " 个"
    )
    local updateSuccess = questManager:updateQuestObjective(playerId, questId, "obj1", 3)
    if updateSuccess then
        debugPrint(nil, "✓ 更新任务目标成功")
    else
        debugPrint(nil, "✗ 更新任务目标失败")
    end
    local completeSuccess1 = questManager:onQuestCompleted(playerId, questId)
    if not completeSuccess1 then
        debugPrint(nil, "✓ 任务未完成时无法完成（预期行为）")
    end
    questManager:updateQuestObjective(playerId, questId, "obj1", 5)
    questManager:updateQuestObjective(playerId, questId, "obj2", 1)
    local completeSuccess2 = questManager:onQuestCompleted(playerId, questId)
    if completeSuccess2 then
        debugPrint(
            nil,
            (("✓ 玩家 " .. tostring(playerId)) .. " 成功完成任务 ") .. questId
        )
    else
        debugPrint(
            nil,
            ((("✗ 玩家 " .. tostring(playerId)) .. " 完成任务 ") .. questId) .. " 失败"
        )
    end
    debugPrint(nil, "任务接受/完成测试完成")
end
--- 测试UI显示
function ____exports.testUI(self)
    debugPrint(nil, "测试任务UI...")
    taskUI:show(0)
    debugPrint(nil, "任务UI已显示")
    if type(jass.CreateTimer) == "function" and type(jass.TimerStart) == "function" then
        local timer = jass.CreateTimer()
        jass.TimerStart(
            timer,
            3,
            false,
            function()
                taskUI:hide()
                debugPrint(nil, "任务UI已隐藏")
                if type(jass.DestroyTimer) == "function" then
                    jass.DestroyTimer(timer)
                end
            end
        )
    end
end
--- 测试任务数据
function ____exports.testQuestData(self)
    debugPrint(nil, "测试任务数据...")
    local quest = questDB:getQuest("main_001")
    if quest then
        debugPrint(nil, ((("找到任务: " .. quest.title) .. " (") .. quest.type) .. ")")
        debugPrint(nil, "描述: " .. quest.description)
        debugPrint(
            nil,
            "目标数量: " .. tostring(#quest.objectives)
        )
        debugPrint(
            nil,
            "奖励数量: " .. tostring(#quest.rewards)
        )
    else
        debugPrint(nil, "未找到测试任务")
    end
    local allQuests = questDB:getAllQuests()
    debugPrint(
        nil,
        "总任务数量: " .. tostring(#allQuests)
    )
    local mainQuests = questDB:getQuestsByType(QuestType.MAIN)
    local sideQuests = questDB:getQuestsByType(QuestType.SIDE)
    local dailyQuests = questDB:getQuestsByType(QuestType.DAILY)
    debugPrint(
        nil,
        "主线任务: " .. tostring(#mainQuests)
    )
    debugPrint(
        nil,
        "支线任务: " .. tostring(#sideQuests)
    )
    debugPrint(
        nil,
        "小任务: " .. tostring(#dailyQuests)
    )
end
--- 运行所有测试
function ____exports.runAllTests(self)
    debugPrint(nil, "===== 开始任务系统测试 =====")
    ____exports.testQuestData(nil)
    ____exports.testQuestAcceptComplete(nil)
    ____exports.testUI(nil)
    debugPrint(nil, "===== 任务系统测试完成 =====")
end
function ____exports.registerTestCommand(self)
    if type(registerKeyDown) == "function" then
        registerKeyDown(
            nil,
            KEY_LETTER.Y,
            function(____, player, key)
                local ____temp_2
                if type(jass.GetPlayerId) == "function" then
                    ____temp_2 = jass.GetPlayerId
                else
                    ____temp_2 = nil
                end
                local getPid = ____temp_2
                local ____temp_3
                if getPid and player then
                    ____temp_3 = getPid(player)
                else
                    ____temp_3 = 0
                end
                local playerId = ____temp_3
                if playerId == 0 then
                    ____exports.runAllTests(nil)
                end
            end
        )
        debugPrint(nil, "已注册测试命令: Y 运行任务系统测试")
    end
end
____exports.registerTestCommand(nil)
return ____exports]=]

P['系统/测试/测试233注册.lua'] = [[local ____lualib = require("lualib_bundle")
local __TS__TypeOf = ____lualib.__TS__TypeOf
local ____exports = {}
local jass = require("jass.common")
local function dumpJapiKeys(self)
    local pr = _G.print
    if not pr then
        return
    end
    do
        local function ____catch(e)
            local ____this_1
            ____this_1 = _G
            local ____opt_0 = ____this_1.print
            if ____opt_0 ~= nil then
                _G.print("[japi] require failed: " .. tostring(e)
                )
            end
        end
        local ____try, ____hasReturned = pcall(function()
            local japi = require("jass.japi")
            pr("[japi] typeof=" .. tostring(__TS__TypeOf(japi)
                )
            )
            local keys = {}
            for k in pairs(japi) do
                if type(k) == "string" then
                    keys[#keys + 1] = k
                end
            end
            pr("[japi] keys=" .. tostring(#keys)
            )
            pr("[japi] list=" .. table.concat(keys, ", ")
            )
        end)
        if not ____try then
            ____catch(____hasReturned)
        end
    end
end
local function dumpDzKeyEventTrgType(self)
    local pr = _G.print
    if not pr then
        return
    end
    local g = _G
    local t0 = "nil"
    local t1 = "nil"
    local t2 = "nil"
    local tP0 = "nil"
    local tP1 = "nil"
    local tBy0 = "nil"
    local tBy1 = "nil"
    local tBy2 = "nil"
    do
        pcall(function()
            t0 = tostring(__TS__TypeOf(g.DzTriggerRegisterKeyEventTrg)
            )
        end)
    end
    do
        pcall(function()
            t1 = tostring(__TS__TypeOf(require("jass.common").DzTriggerRegisterKeyEventTrg)
            )
        end)
    end
    do
        pcall(function()
            t2 = tostring(__TS__TypeOf(require("jass.globals").DzTriggerRegisterKeyEventTrg)
            )
        end)
    end
    pr("[type] _G.DzTriggerRegisterKeyEventTrg=" .. t0)
    pr("[type] jass.common.DzTriggerRegisterKeyEventTrg=" .. t1)
    pr("[type] jass.globals.DzTriggerRegisterKeyEventTrg=" .. t2)
    do
        pcall(function()
            tP0 = tostring(__TS__TypeOf(require("jass.common").DzGetTriggerKeyPlayer)
            )
        end)
    end
    do
        pcall(function()
            tP1 = tostring(__TS__TypeOf(require("jass.japi").DzGetTriggerKeyPlayer)
            )
        end)
    end
    pr("[type] jass.common.DzGetTriggerKeyPlayer=" .. tP0)
    pr("[type] jass.japi.DzGetTriggerKeyPlayer=" .. tP1)
    do
        pcall(function()
            tBy0 = tostring(__TS__TypeOf(g.DzTriggerRegisterKeyEventByCode)
            )
        end)
    end
    do
        pcall(function()
            tBy1 = tostring(__TS__TypeOf(require("jass.common").DzTriggerRegisterKeyEventByCode)
            )
        end)
    end
    do
        pcall(function()
            tBy2 = tostring(__TS__TypeOf(require("jass.japi").DzTriggerRegisterKeyEventByCode)
            )
        end)
    end
    pr("[type] _G.DzTriggerRegisterKeyEventByCode=" .. tBy0)
    pr("[type] jass.common.DzTriggerRegisterKeyEventByCode=" .. tBy1)
    pr("[type] jass.japi.DzTriggerRegisterKeyEventByCode=" .. tBy2)
    local tMx0 = "nil"
    local tMx1 = "nil"
    do
        pcall(function()
            tMx0 = tostring(__TS__TypeOf(g.DzGetMouseX)
            )
        end)
    end
    do
        pcall(function()
            tMx1 = tostring(__TS__TypeOf(require("jass.japi").DzGetMouseX)
            )
        end)
    end
    pr("[type] _G.DzGetMouseX=" .. tMx0)
    pr("[type] jass.japi.DzGetMouseX=" .. tMx1)
end
local function bindKeyBN_once_min(self)
    local pr = _G.print
    if not pr then
        return
    end
    local g = _G
    if g.__keytest_bound then
        pr("[keytest] already bound")
        return
    end
    g.__keytest_bound = true
    local japi = require("jass.japi")
    if type(jass.CreateTrigger) ~= "function" or type(jass.DisplayTimedTextToPlayer) ~= "function" or type(jass.Player) ~= "function" then
        pr("[keytest] missing basic jass funcs")
        return
    end
    local f = japi.DzTriggerRegisterKeyEventByCode
    if type(f) ~= "function" then
        pr("[keytest] DzTriggerRegisterKeyEventByCode not function")
        return
    end
    local function bind(____, key, label)
        local trig = jass.CreateTrigger()
        f(trig,
            key,
            1,
            false,
            function()
                local msg = ((("[KEYOK] " .. label) .. " key=") .. tostring(key)) .. " sync=false"
                do
                    local i = 0
                    while i < 12 do
                        jass.DisplayTimedTextToPlayer(
                            jass.Player(i),
                            0,
                            0,
                            5,
                            msg
                        )
                        i = i + 1
                    end
                end
            end
        )
    end
    pr("[keytest] bind B/N (sync=false, key=66/78)")
    bind(nil, 66, "B")
    bind(nil, 78, "N")
end
local function onChat233(self)
    dumpJapiKeys(nil)
    dumpDzKeyEventTrgType(nil)
    bindKeyBN_once_min(nil)
    if type(jass.DisplayTimedTextToPlayer) == "function" and type(jass.Player) == "function" then
        jass.DisplayTimedTextToPlayer(
            jass.Player(0),
            0,
            0,
            6,
            "[japi] 已打印 jass.japi keys"
        )
    end
end
local function init(self)
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" or type(jass.TriggerRegisterPlayerChatEvent) ~= "function" or type(jass.Player) ~= "function" then
        return
    end
    local tr = jass.CreateTrigger()
    jass.TriggerRegisterPlayerChatEvent(
        tr,
        jass.Player(0),
        "233",
        true
    )
    jass.TriggerAddAction(tr, onChat233)
end
init(nil)
return ____exports]]

P['系统/测试/测试事件.lua'] = [=[--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local g = require("jass.globals")
local function onTestEvent(self)
    local t = jass.CreateTimer()
    jass.TimerStart(
        t,
        0,
        false,
        function()
            local out = ""
            local ok, err = pcall(function ()
                        local u = g.gg_unit_Hamg_0002
                        local hasSet = not not jass.Ir_SetUnitAttackType
                        out = (("u=" .. tostring(not not u)) .. " hasSet=") .. tostring(hasSet)
                        if u and hasSet then
                            local hasGet = not not jass.Ir_GetUnitAttackType
                            local ____hasGet_0
                            if hasGet then
                                ____hasGet_0 = jass.Ir_GetUnitAttackType(u)
                            else
                                ____hasGet_0 = -1
                            end
                            local before = ____hasGet_0
                            jass.Ir_SetUnitAttackType(u, 5)
                            local ____hasGet_1
                            if hasGet then
                                ____hasGet_1 = jass.Ir_GetUnitAttackType(u)
                            else
                                ____hasGet_1 = -1
                            end
                            local after = ____hasGet_1
                            out = (("before=" .. tostring(before)) .. " after=") .. tostring(after)
                        end
                    end
                )
            if not ok then
                out = "pcall err: " .. tostring(err)
            end
            local line = "[TestEvent] " .. out
            local ____this_3
            ____this_3 = _G
            local ____opt_2 = ____this_3.print
            if ____opt_2 ~= nil then
                ____opt_2(____this_3, line)
            end
            jass.DisplayTimedTextToPlayer(
                jass.Player(0),
                0,
                0,
                15,
                line
            )
        end
    )
end
local function init(self)
    local evtTrig = jass.CreateTrigger()
    jass.TriggerAddAction(evtTrig, onTestEvent)
    local ____jass_STES_Register_4 = jass.STES_Register
    if ____jass_STES_Register_4 == nil then
        ____jass_STES_Register_4 = g.STES_Register
    end
    local ____jass_STES_Register_4_5 = ____jass_STES_Register_4
    if ____jass_STES_Register_4_5 == nil then
        ____jass_STES_Register_4_5 = _G.STES_Register
    end
    local STES_Reg = ____jass_STES_Register_4_5
    if type(STES_Reg) == "function" then
        STES_Reg(evtTrig, "测试事件")
    else
        g.udg_RegTrigger = evtTrig
        g.udg_RegEventStr = "测试事件"
        jass.ExecuteFunc("Bridge_STES_Register")
    end
end
init(nil)
return ____exports]=]

P['系统/测试/测试事件2.lua'] = [=[--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("系统.00_核心.封装函数")
local AdjustPlayerStateBJ = ____require_result_0.AdjustPlayerStateBJ
local ____require_result_1 = require("系统.00_核心.音效函数")
local Sound3DII_Mp3Play = ____require_result_1.Sound3DII_Mp3Play
local ____require_result_2 = require("系统.00_核心.漂浮文字函数")
local CreateFloatTextOnUnit = ____require_result_2.CreateFloatTextOnUnit
local SOUND_GOLD = "Abilities\\Spells\\Items\\ResourceItems\\ReceiveGold.wav"
local GOLD_R = 255
local GOLD_G = 215
local GOLD_B = 0
local function onChat222(self)
    AdjustPlayerStateBJ(
        nil,
        1000,
        jass.Player(0),
        jass.PLAYER_STATE_RESOURCE_GOLD
    )
    if type(jass.CreateTimer) == "function" and type(jass.TimerStart) == "function" and type(jass.DestroyTimer) == "function" then
        local t = jass.CreateTimer()
        local n = 0
        jass.TimerStart(
            t,
            0.1,
            true,
            function()
                n = n + 1
                Sound3DII_Mp3Play(
                    nil,
                    SOUND_GOLD,
                    jass.Player(0)
                )
                if n >= 10 then
                    jass.DestroyTimer(t)
                end
            end
        )
    else
        Sound3DII_Mp3Play(
            nil,
            SOUND_GOLD,
            jass.Player(0)
        )
    end
    if g.gg_unit_Hamg_0002 ~= nil then
        CreateFloatTextOnUnit(nil, g.gg_unit_Hamg_0002, "+2000", {
            size = 12,
            red = GOLD_R,
            green = GOLD_G,
            blue = GOLD_B,
            alpha = 0
        })
    end
    if type(jass.DisplayTimedTextToPlayer) == "function" then
        jass.DisplayTimedTextToPlayer(
            jass.Player(0),
            0,
            0,
            10,
            "[测试事件2] 已给玩家0增加 1000 金币"
        )
    end
end
local function init(self)
    local tr = jass.CreateTrigger()
    if type(jass.TriggerRegisterPlayerChatEvent) == "function" and type(jass.TriggerAddAction) == "function" and type(jass.Player) == "function" then
        jass.TriggerRegisterPlayerChatEvent(
            tr,
            jass.Player(0),
            "222",
            true
        )
        jass.TriggerAddAction(tr, onChat222)
    end
end
init(nil)
return ____exports]=]

P['系统/表现/UI工具.lua'] = [=[--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local japi
local _____786C_4EF6_51FD_6570 = require("系统.00_核心.硬件函数")
local getGameUI = _____786C_4EF6_51FD_6570.getGameUI
local frameSetScriptByCode = _____786C_4EF6_51FD_6570.frameSetScriptByCode
--- 销毁Frame
function ____exports.destroyFrame(self, frame)
    if not frame or type(japi.DzDestroyFrame) ~= "function" then
        return false
    end
    japi.DzDestroyFrame(frame)
    return true
end
--- UI工具函数 - 通用的UI创建和管理函数
-- 只使用 BACKDROP + GLUETEXTBUTTON（War3 JAPI 兼容的帧类型）
local jass = require("jass.common")
japi = require("jass.japi")
--- Frame类型常量（DzAPI 支持的类型）
____exports.FrameType = {
    BACKDROP = "BACKDROP",
    TEXT = "TEXT",
    TEXTAREA = "TEXTAREA",
    GLUETEXTBUTTON = "GLUETEXTBUTTON",
    GLUECHECKBOX = "GLUECHECKBOX",
    POPUPMENU = "POPUPMENU",
    SCROLLBAR = "SCROLLBAR",
    SPRITE = "SPRITE",
    SLIDER = "SLIDER",
    BUTTON = "BUTTON",
    EDITBOX = "EDITBOX",
    HIGHLIGHT = "HIGHLIGHT",
    MENU = "MENU",
    DIALOG = "DIALOG",
    SIMPLEFRAME = "SIMPLEFRAME",
    SIMPLESTATUSBAR = "SIMPLESTATUSBAR",
    SIMPLECHECKBOX = "SIMPLECHECKBOX"
}
--- FDF 层：Layer "ARTWORK" = 插图层
____exports.FrameLayer = {ARTWORK = "ARTWORK"}
--- Frame点常量（对应DzFrameSetAbsolutePoint的point参数）
____exports.FramePoint = {
    TOPLEFT = 0,
    TOP = 1,
    TOPRIGHT = 2,
    LEFT = 3,
    CENTER = 4,
    RIGHT = 5,
    BOTTOMLEFT = 6,
    BOTTOM = 7,
    BOTTOMRIGHT = 8
}
--- 事件类型常量（对应DzFrameSetScript的eventId参数）
____exports.EventType = {
    MOUSE_CLICK = 1,
    MOUSE_ENTER = 2,
    MOUSE_LEAVE = 3,
    MOUSE_UP = 4,
    MOUSE_WHEEL = 6,
    MOUSE_DOUBLE_CLICK = 12,
    SLIDER_VALUE_CHANGED = 11
}
--- 创建Frame
function ____exports.createFrame(self, config)
    local ____config_0 = config
    local ____type = ____config_0.type
    local name = ____config_0.name
    local parent = ____config_0.parent
    if parent == nil then
        parent = 0
    end
    local template = ____config_0.template
    if template == nil then
        template = "template"
    end
    local id = ____config_0.id
    if id == nil then
        id = 0
    end
    if type(japi.DzCreateFrameByTagName) ~= "function" then
        return nil
    end
    if ____type == ____exports.FrameType.SIMPLEFRAME then
        return nil
    end
    local frame = japi.DzCreateFrameByTagName(
        ____type,
        name,
        parent,
        template,
        id
    )
    if frame == nil or frame == 0 then
        return nil
    end
    if config.visible ~= nil and type(japi.DzFrameShow) == "function" then
        pcall(function ()
                japi.DzFrameShow(frame, config.visible)
            end
        )
    end
    if config.enable == false and type(japi.DzFrameSetEnable) == "function" then
        pcall(function ()
                japi.DzFrameSetEnable(frame, false)
            end
        )
    end
    if config.alpha ~= nil and type(japi.DzFrameSetAlpha) == "function" then
        pcall(function ()
                japi.DzFrameSetAlpha(frame, config.alpha)
            end
        )
    end
    if config.level ~= nil and type(japi.DzFrameSetLevel) == "function" then
        pcall(function ()
                japi.DzFrameSetLevel(frame, config.level)
            end
        )
    end
    return frame
end
--- 安全加载 TOC（只加载一次）：
-- - 允许同时传多个可能路径（你这套项目里常见：`UI\\xxx.toc` 与 `war3mapImported\\UI\\xxx.toc`）
-- - 用 `pcall` 包住 Lua 层异常，避免初始化流程被 Lua 报错打断
-- 
-- 注意：如果客户端在绘制/交互阶段对某些 FDF 帧直接“引擎级崩溃”，`pcall` 也拦不住；
-- 所以仍建议“分阶段/白名单”逐步替换控件类型。
local __tocLoadedOnce = {}
function ____exports.loadTocOnce(self, tocLoadKey, tocPaths, debugPrefix)
    if debugPrefix == nil then
        debugPrefix = "UI"
    end
    if __tocLoadedOnce[tocLoadKey] then
        return
    end
    __tocLoadedOnce[tocLoadKey] = true
    if type(japi.DzLoadToc) ~= "function" then
        return
    end
    for ____, p in ipairs(tocPaths) do
        local ok = pcall(function ()
                japi.DzLoadToc(p)
            end
        )
        if not ok then
            local pr = _G.print
            if type(pr) == "function" then
                pr((("[" .. debugPrefix) .. "] DzLoadToc fail: ") .. p)
            end
        end
    end
end
--- `DzLoadToc` + `DzCreateFrame` try/fallback 的通用封装。
-- 
-- 用法示例（放在某个 UI 模块里）：
-- ```ts
-- const f = tryCreateFromFdfSafe("TaskEntryIcon", parent, () =>
--   createFrame({ type: FrameType.BACKDROP, name: "TaskEntryIcon", parent, template: "template", visible: true })
-- , {
--   tocLoadKey: "TaskUI",
--   tocPaths: ["UI\\\\TaskUI.toc", "war3mapImported\\\\UI\\\\TaskUI.toc"],
--   debugPrefix: "TaskUI"
-- });
-- ```
-- 
-- @returns 失败时返回 fallback 的结果（允许 fallback 返回 null）
function ____exports.tryCreateFromFdfSafe(self, frameName, parent, fallback, opts)
    ____exports.loadTocOnce(nil, opts.tocLoadKey, opts.tocPaths, opts.debugPrefix or "UI")
    if type(japi.DzCreateFrame) ~= "function" then
        return fallback(nil)
    end
    local f = 0
    local ok = pcall(function ()
            f = japi.DzCreateFrame(frameName, parent, 0)
        end
    )
    if ok and f ~= nil and f ~= 0 then
        return f
    end
    return fallback(nil)
end
--- 设置Frame位置（绝对坐标，屏幕）
function ____exports.setFramePosition(self, frame, position)
    if frame == 0 or frame == nil or type(japi.DzFrameSetAbsolutePoint) ~= "function" then
        return false
    end
    japi.DzFrameSetAbsolutePoint(frame, position.point, position.x, position.y)
    return true
end
--- 设置Frame相对位置（相对父/参考帧，用于子控件）
function ____exports.setFramePointRelative(self, frame, point, relativeFrame, relativePoint, x, y)
    if frame == 0 or frame == nil or relativeFrame == 0 or relativeFrame == nil or type(japi.DzFrameSetPoint) ~= "function" then
        return false
    end
    japi.DzFrameSetPoint(
        frame,
        point,
        relativeFrame,
        relativePoint,
        x,
        y
    )
    return true
end
--- 设置Frame尺寸
function ____exports.setFrameSize(self, frame, size)
    if frame == 0 or frame == nil or type(japi.DzFrameSetSize) ~= "function" then
        return false
    end
    japi.DzFrameSetSize(frame, size.width, size.height)
    return true
end
--- 设置Frame纹理（仅设置纹理和透明度，不使用DzFrameSetVertexColor）
function ____exports.setFrameTexture(self, frame, texture)
    if frame == 0 or frame == nil then
        return false
    end
    if texture and type(japi.DzFrameSetTexture) == "function" then
        japi.DzFrameSetTexture(frame, texture, 0)
    end
    return true
end
--- 设置Frame点击事件
function ____exports.setFrameClickEvent(self, frame, callback, sync)
    if sync == nil then
        sync = true
    end
    if frame == 0 or frame == nil then
        return false
    end
    frameSetScriptByCode(
        nil,
        frame,
        ____exports.EventType.MOUSE_CLICK,
        callback,
        sync
    )
    return true
end
--- 设置Frame悬停事件
function ____exports.setFrameHoverEvents(self, frame, onEnter, onLeave, sync)
    if sync == nil then
        sync = true
    end
    if frame == 0 or frame == nil then
        return false
    end
    frameSetScriptByCode(
        nil,
        frame,
        ____exports.EventType.MOUSE_ENTER,
        onEnter,
        sync
    )
    frameSetScriptByCode(
        nil,
        frame,
        ____exports.EventType.MOUSE_LEAVE,
        onLeave,
        sync
    )
    return true
end
--- 设置GLUETEXTBUTTON的文本（DzFrameSetText仅对GLUETEXTBUTTON有效）
function ____exports.setButtonText(self, frame, text)
    if not frame or type(japi.DzFrameSetText) ~= "function" then
        return false
    end
    japi.DzFrameSetText(frame, text)
    return true
end
--- 创建可点击的图标（BACKDROP + GLUETEXTBUTTON组合）
function ____exports.createClickableIcon(self, name, parent, texture, position, size, onClick)
    local backdrop = ____exports.createFrame(nil, {
        type = ____exports.FrameType.BACKDROP,
        name = name .. "_Backdrop",
        parent = parent,
        template = "template",
        visible = true
    })
    if not backdrop then
        return nil
    end
    ____exports.setFramePosition(nil, backdrop, position)
    ____exports.setFrameSize(nil, backdrop, size)
    ____exports.setFrameTexture(nil, backdrop, texture)
    local button = ____exports.createFrame(nil, {
        type = ____exports.FrameType.GLUETEXTBUTTON,
        name = name .. "_Button",
        parent = backdrop,
        template = "template",
        visible = true,
        enable = true,
        alpha = 0
    })
    if not button then
        return nil
    end
    if type(japi.DzFrameSetAllPoints) == "function" then
        japi.DzFrameSetAllPoints(button, backdrop)
    else
        ____exports.setFramePosition(nil, button, position)
        ____exports.setFrameSize(nil, button, size)
    end
    ____exports.setFrameClickEvent(nil, button, onClick)
    return {backdrop = backdrop, button = button}
end
--- 创建文本按钮（GLUETEXTBUTTON显示文本，可点击）
function ____exports.createTextButton(self, name, parent, text, position, size, onClick)
    local frame = ____exports.createFrame(nil, {
        type = ____exports.FrameType.GLUETEXTBUTTON,
        name = name,
        parent = parent,
        template = "template",
        visible = true,
        enable = true
    })
    if not frame then
        return nil
    end
    ____exports.setFramePosition(nil, frame, position)
    ____exports.setFrameSize(nil, frame, size)
    ____exports.setButtonText(nil, frame, text)
    if onClick then
        ____exports.setFrameClickEvent(nil, frame, onClick)
    end
    return frame
end
--- 创建纯文本标签（使用TEXT类型）
-- position 支持 PositionConfig（绝对）或 RelativePositionConfig（相对父帧）
function ____exports.createTextLabel(self, name, parent, text, position, size)
    local isRelative = position.relativeTo ~= nil
    local function setPos(____, f)
        if isRelative then
            local r = position
            ____exports.setFramePointRelative(
                nil,
                f,
                r.point,
                r.relativeTo,
                r.relativePoint,
                r.x,
                r.y
            )
        else
            ____exports.setFramePosition(nil, f, position)
        end
    end
    local frame = ____exports.createFrame(nil, {
        type = ____exports.FrameType.TEXT,
        name = name,
        parent = parent,
        template = "template",
        visible = true
    })
    if frame then
        setPos(nil, frame)
        ____exports.setFrameSize(nil, frame, size)
        if type(japi.DzFrameSetText) == "function" then
            japi.DzFrameSetText(frame, text)
        end
        return frame
    end
    local fallbackFrame = ____exports.createFrame(nil, {
        type = ____exports.FrameType.GLUETEXTBUTTON,
        name = name,
        parent = parent,
        template = "template",
        visible = true
    })
    if not fallbackFrame then
        return nil
    end
    setPos(nil, fallbackFrame)
    ____exports.setFrameSize(nil, fallbackFrame, size)
    ____exports.setButtonText(nil, fallbackFrame, text)
    return fallbackFrame
end
--- 创建文本框（使用TEXTAREA类型，带背景）
function ____exports.createTextArea(self, name, parent, text, position, size, backgroundTexture)
    local backdrop = ____exports.createFrame(nil, {
        type = ____exports.FrameType.BACKDROP,
        name = name .. "_Backdrop",
        parent = parent,
        template = "template",
        visible = true
    })
    if backdrop then
        ____exports.setFramePosition(nil, backdrop, position)
        ____exports.setFrameSize(nil, backdrop, size)
        if backgroundTexture and type(japi.DzFrameSetTexture) == "function" then
            japi.DzFrameSetTexture(backdrop, backgroundTexture, 0)
        end
    end
    local frame = ____exports.createFrame(nil, {
        type = ____exports.FrameType.TEXTAREA,
        name = name,
        parent = backdrop or parent,
        template = "template",
        visible = true
    })
    if frame then
        if backdrop and type(japi.DzFrameSetAllPoints) == "function" then
            japi.DzFrameSetAllPoints(frame, backdrop)
        else
            ____exports.setFramePosition(nil, frame, position)
            ____exports.setFrameSize(nil, frame, size)
        end
        if type(japi.DzFrameSetText) == "function" then
            japi.DzFrameSetText(frame, text)
        end
        return frame
    end
    return ____exports.createTextLabel(
        nil,
        name,
        parent,
        text,
        position,
        size
    )
end
--- 创建带背景的文本框容器
function ____exports.createTextBox(self, name, parent, text, position, size, backgroundTexture)
    local backdrop = ____exports.createFrame(nil, {
        type = ____exports.FrameType.BACKDROP,
        name = name .. "_Backdrop",
        parent = parent,
        template = "template",
        visible = true
    })
    if not backdrop then
        return nil
    end
    ____exports.setFramePosition(nil, backdrop, position)
    ____exports.setFrameSize(nil, backdrop, size)
    ____exports.setFrameTexture(nil, backdrop, backgroundTexture)
    local textFrame = ____exports.createFrame(nil, {
        type = ____exports.FrameType.TEXT,
        name = name .. "_Text",
        parent = backdrop,
        template = "template",
        visible = true
    })
    if not textFrame then
        ____exports.destroyFrame(nil, backdrop)
        return nil
    end
    local innerPos = {point = position.point, x = position.x + 0.005, y = position.y - 0.005}
    local innerSize = {width = size.width - 0.01, height = size.height - 0.01}
    ____exports.setFramePosition(nil, textFrame, innerPos)
    ____exports.setFrameSize(nil, textFrame, innerSize)
    if type(japi.DzFrameSetText) == "function" then
        japi.DzFrameSetText(textFrame, text)
    end
    return {backdrop = backdrop, text = textFrame}
end
--- 隐藏Frame
function ____exports.hideFrame(self, frame)
    if not frame or type(japi.DzFrameShow) ~= "function" then
        return false
    end
    japi.DzFrameShow(frame, false)
    return true
end
--- 显示Frame
function ____exports.showFrame(self, frame)
    if not frame or type(japi.DzFrameShow) ~= "function" then
        return false
    end
    japi.DzFrameShow(frame, true)
    return true
end
--- 获取游戏UI根Frame
function ____exports.getGameUIFrame(self)
    return getGameUI(nil)
end
return ____exports]=]

P['系统/装备/物品加工.lua'] = [[local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Number = ____lualib.__TS__Number
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local Set = ____lualib.Set
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
--- 物品加工系统（篝火 h00C）
-- 
-- 触发：
-- - 玩家1-4（Player(0..3)）单位拾取物品：EVENT_PLAYER_UNIT_PICKUP_ITEM
-- 
-- 规则：
-- - 只有“篝火单位（h00C）”拾取物品才进入加工/烤焦逻辑
-- - 玩家从篝火取回物品：表现为“其他单位拾取该 item”，此时取消对应计时器
-- 
-- recipe 格式：
--   h00C:加工秒数->结果:超时秒数
--   结果支持多项，用 ; 分隔；支持概率：20%I036*1；支持数量：I02H*2
--   示例：
--   - h00C:10->I02H*2:5
--   - h00C:20->I034*1;20%I036*1:5
local jass = require("jass.common")
local itemsData = require("系统.装备.装备数据").default
local ____require_result_0 = require("系统.00_核心.泄露审计")
local LeakWatcher = ____require_result_0.LeakWatcher
local ____require_result_1 = require("系统.00_核心.漂浮文字函数")
local CreateFloatTextAtPoint = ____require_result_1.CreateFloatTextAtPoint
local CAMPFIRE_ID = 1747988547
local EFFECT_FIREBOMB = "war3mapImported\\Firebomb.mdl"
local itemState = __TS__New(Map)
local campfireItems = __TS__New(Map)
local function isCampfire(self, u)
    return type(jass.GetUnitTypeId) == "function" and jass.GetUnitTypeId(u) == CAMPFIRE_ID
end
local function fourCCToInt(self, id)
    if not id or #id ~= 4 then
        return 0
    end
    local c1 = string.byte(id, 1) or 0 / 0
    local c2 = string.byte(id, 2) or 0 / 0
    local c3 = string.byte(id, 3) or 0 / 0
    local c4 = string.byte(id, 4) or 0 / 0
    return c1 * 16777216 + c2 * 65536 + c3 * 256 + c4
end
local function getItemIdStr(self, item)
    local ____temp_2
    if type(jass.GetItemTypeId) == "function" then
        ____temp_2 = jass.GetItemTypeId(item)
    else
        ____temp_2 = 0
    end
    local itemId = ____temp_2
    local c1 = string.char(itemId % 256)
    local c2 = string.char(math.floor(itemId / 256) % 256)
    local c3 = string.char(math.floor(itemId / 65536) % 256)
    local c4 = string.char(math.floor(itemId / 16777216) % 256)
    return ((c4 .. c3) .. c2) .. c1
end
local function getItemNameSafe(self, item)
    local ____temp_3
    if type(jass.GetItemName) == "function" then
        ____temp_3 = jass.GetItemName(item)
    else
        ____temp_3 = "物品"
    end
    return ____temp_3
end
local function getItemChargesSafe(self, item)
    if type(jass.GetItemCharges) ~= "function" then
        return 1
    end
    local n = jass.GetItemCharges(item)
    local ____TS__Number_result_4 = __TS__Number(n)
    if ____TS__Number_result_4 == nil then
        ____TS__Number_result_4 = 0
    end
    local v = math.floor(____TS__Number_result_4) or 0
    return v > 0 and v or 1
end
local function setItemChargesSafe(self, item, n)
    if not item then
        return
    end
    if type(jass.SetItemCharges) ~= "function" then
        return
    end
    local v = math.floor(n) or 1
    jass.SetItemCharges(item, v > 0 and v or 1)
end
local function getUnitXY(self, u)
    local ____temp_5
    if type(jass.GetUnitX) == "function" then
        ____temp_5 = jass.GetUnitX(u)
    else
        ____temp_5 = 0
    end
    local x = ____temp_5
    local ____temp_6
    if type(jass.GetUnitY) == "function" then
        ____temp_6 = jass.GetUnitY(u)
    else
        ____temp_6 = 0
    end
    local y = ____temp_6
    return {x = x, y = y}
end
local function floatBurnText(self, campfire, itemName)
    local ____getUnitXY_result_7 = getUnitXY(nil, campfire)
    local x = ____getUnitXY_result_7.x
    local y = ____getUnitXY_result_7.y
    CreateFloatTextAtPoint(
        nil,
        x,
        y,
        itemName .. "被烤焦了！",
        {
            red = 255,
            green = 0,
            blue = 0,
            alpha = 0,
            duration = 3,
            speedY = 0.07,
            size = 10,
            height = 50
        }
    )
end
local function playFinishEffect(self, campfire)
    if type(jass.AddSpecialEffect) ~= "function" then
        return
    end
    local ____getUnitXY_result_8 = getUnitXY(nil, campfire)
    local x = ____getUnitXY_result_8.x
    local y = ____getUnitXY_result_8.y
    local eff = jass.AddSpecialEffect(EFFECT_FIREBOMB, x, y)
    if eff then
        LeakWatcher:trackEffect("craft_firebomb", eff)
    end
    local t = LeakWatcher:createTimer("craft_firebomb")
    if t and type(jass.TimerStart) == "function" then
        jass.TimerStart(
            t,
            2,
            false,
            function()
                if eff then
                    LeakWatcher:destroyEffect(eff)
                end
                LeakWatcher:destroyTimer(t)
            end
        )
    end
end
local function getRecipeForItem(self, item)
    local idStr = getItemIdStr(nil, item)
    local entry = itemsData[idStr]
    local recipe = entry and entry.recipe and entry.recipe or nil
    if not recipe then
        return nil
    end
    local prefix = "h00C:"
    if (string.find(recipe, prefix, nil, true) or 0) - 1 ~= 0 then
        return nil
    end
    local rest = __TS__StringSubstring(recipe, #prefix)
    local arrowIdx = (string.find(rest, "->", nil, true) or 0) - 1
    local colonIdx = -1
    do
        local i = #rest - 1
        while i >= 0 do
            if __TS__StringSubstring(rest, i, i + 1) == ":" then
                colonIdx = i
                break
            end
            i = i - 1
        end
    end
    if arrowIdx < 0 or colonIdx < 0 or colonIdx <= arrowIdx + 2 then
        return nil
    end
    local cookStr = __TS__StringTrim(__TS__StringSubstring(rest, 0, arrowIdx))
    local resultsStr = __TS__StringTrim(__TS__StringSubstring(rest, arrowIdx + 2, colonIdx))
    local timeoutStr = __TS__StringTrim(__TS__StringSubstring(rest, colonIdx + 1))
    local cookSec = math.floor(__TS__ParseFloat(cookStr) or 0)
    local timeoutSec = math.floor(__TS__ParseFloat(timeoutStr) or 0)
    if cookSec <= 0 then
        return nil
    end
    local rawOpts = __TS__ArrayFilter(
        __TS__ArrayMap(
            __TS__StringSplit(resultsStr, ";"),
            function(____, s) return __TS__StringTrim(s) end
        ),
        function(____, s) return s ~= "" end
    )
    if #rawOpts == 0 then
        return nil
    end
    local opts = {}
    for ____, raw in ipairs(rawOpts) do
        local s = raw
        local prob = nil
        local pctIdx = (string.find(s, "%", nil, true) or 0) - 1
        if pctIdx > 0 then
            local p = __TS__ParseFloat(__TS__StringTrim(__TS__StringSubstring(s, 0, pctIdx)))
            if not __TS__NumberIsNaN(__TS__Number(p)) and p > 0 then
                prob = p
            end
            s = __TS__StringTrim(__TS__StringSubstring(s, pctIdx + 1))
        end
        local starIdx = (string.find(s, "*", nil, true) or 0) - 1
        local idPart = __TS__StringTrim(starIdx >= 0 and __TS__StringSubstring(s, 0, starIdx) or s)
        local qtyPart = __TS__StringTrim(starIdx >= 0 and __TS__StringSubstring(s, starIdx + 1) or "")
        local qty = math.floor(__TS__ParseFloat(qtyPart) or 1)
        local itemId = fourCCToInt(nil, idPart)
        if itemId ~= 0 and qty > 0 then
            opts[#opts + 1] = {prob = prob, itemId = itemId, qty = qty}
        end
    end
    if #opts == 0 then
        return nil
    end
    return {cookSec = cookSec, timeoutSec = timeoutSec, results = opts}
end
local function pickResult(self, results)
    local sumExplicit = 0
    local unspecified = 0
    for ____, r in ipairs(results) do
        if type(r.prob) == "number" then
            sumExplicit = sumExplicit + r.prob
        else
            unspecified = unspecified + 1
        end
    end
    local base = 0
    if unspecified > 0 then
        local remain = 100 - sumExplicit
        base = remain > 0 and remain / unspecified or 0
    end
    local total = 0
    local weights = {}
    do
        local i = 0
        while i < #results do
            local w = type(results[i + 1].prob) == "number" and results[i + 1].prob or base
            local ww = w > 0 and w or 0
            weights[i + 1] = ww
            total = total + ww
            i = i + 1
        end
    end
    if total <= 0 then
        local idx = math.random(1, #results)
        return results[idx]
    end
    local roll = math.random() * total
    do
        local i = 0
        while i < #results do
            roll = roll - weights[i + 1]
            if roll <= 0 then
                return results[i + 1]
            end
            i = i + 1
        end
    end
    return results[#results]
end
local function createItemAtCampfire(self, campfire, itemId)
    local ____getUnitXY_result_9 = getUnitXY(nil, campfire)
    local x = ____getUnitXY_result_9.x
    local y = ____getUnitXY_result_9.y
    if type(jass.CreateItem) ~= "function" then
        return nil
    end
    return jass.CreateItem(itemId, x, y)
end
local function tryGiveItemToCampfire(self, campfire, item)
    if not item then
        return false
    end
    if type(jass.UnitAddItem) ~= "function" then
        return false
    end
    return not not jass.UnitAddItem(campfire, item)
end
local function stopAndDestroyTimer(self, t)
    if not t then
        return
    end
    LeakWatcher:destroyTimer(t)
end
local function untrackItem(self, item)
    local st = itemState:get(item)
    if not st then
        return
    end
    if st.cookTimer then
        stopAndDestroyTimer(nil, st.cookTimer)
    end
    if st.burnTimer then
        stopAndDestroyTimer(nil, st.burnTimer)
    end
    itemState:delete(item)
    local set = campfireItems:get(st.campfire)
    if set then
        set:delete(item)
        if set.size == 0 then
            campfireItems:delete(st.campfire)
        end
    end
end
local function startBurnTimer(self, item, campfire, sec)
    local t = LeakWatcher:createTimer("craft_burn")
    if not t or type(jass.TimerStart) ~= "function" then
        return
    end
    local st = itemState:get(item)
    if st then
        st.burnTimer = t
    end
    jass.TimerStart(
        t,
        sec,
        false,
        function()
            if not itemState:has(item) then
                LeakWatcher:destroyTimer(t)
                return
            end
            local name = getItemNameSafe(nil, item)
            floatBurnText(nil, campfire, name)
            if type(jass.RemoveItem) == "function" then
                jass.RemoveItem(item)
            end
            untrackItem(nil, item)
        end
    )
end
local function startCookTimer(self, item, campfire, recipe)
    local t = LeakWatcher:createTimer("craft_cook")
    if not t or type(jass.TimerStart) ~= "function" then
        return
    end
    local st = itemState:get(item)
    if st then
        st.cookTimer = t
    end
    jass.TimerStart(
        t,
        recipe.cookSec,
        false,
        function()
            if not itemState:has(item) then
                LeakWatcher:destroyTimer(t)
                return
            end
            playFinishEffect(nil, campfire)
            local chosen = pickResult(nil, recipe.results)
            local inputCharges = getItemChargesSafe(nil, item)
            if type(jass.RemoveItem) == "function" then
                jass.RemoveItem(item)
            end
            untrackItem(nil, item)
            local timeout = recipe.timeoutSec > 0 and recipe.timeoutSec or 0
            local remaining = chosen.qty * inputCharges
            while remaining > 0 do
                local it = createItemAtCampfire(nil, campfire, chosen.itemId)
                if not it then
                    break
                end
                setItemChargesSafe(nil, it, remaining)
                local ok = tryGiveItemToCampfire(nil, campfire, it)
                if not ok then
                    local roll = math.random(1, 100)
                    if roll > 20 and type(jass.RemoveItem) == "function" then
                        jass.RemoveItem(it)
                    end
                else
                    itemState:set(it, {campfire = campfire, stage = "done"})
                    local set = campfireItems:get(campfire)
                    if not set then
                        set = __TS__New(Set)
                        campfireItems:set(campfire, set)
                    end
                    set:add(it)
                    if timeout > 0 then
                        startBurnTimer(nil, it, campfire, timeout)
                    end
                end
                remaining = 0
            end
        end
    )
end
local function onAnyPickup(self)
    local ____temp_10
    if type(jass.GetTriggerUnit) == "function" then
        ____temp_10 = jass.GetTriggerUnit()
    else
        ____temp_10 = nil
    end
    local u = ____temp_10
    local ____temp_11
    if type(jass.GetManipulatedItem) == "function" then
        ____temp_11 = jass.GetManipulatedItem()
    else
        ____temp_11 = nil
    end
    local item = ____temp_11
    if not u or not item then
        return
    end
    if not isCampfire(nil, u) then
        if itemState:has(item) then
            untrackItem(nil, item)
        end
        return
    end
    if itemState:has(item) then
        return
    end
    local recipe = getRecipeForItem(nil, item)
    local campfire = u
    itemState:set(item, {campfire = campfire, stage = "raw"})
    local set = campfireItems:get(campfire)
    if not set then
        set = __TS__New(Set)
        campfireItems:set(campfire, set)
    end
    set:add(item)
    if not recipe then
        startBurnTimer(nil, item, campfire, 15)
    else
        startCookTimer(nil, item, campfire, recipe)
    end
end
local function onAnyDeath(self)
    local ____temp_12
    if type(jass.GetTriggerUnit) == "function" then
        ____temp_12 = jass.GetTriggerUnit()
    else
        ____temp_12 = nil
    end
    local u = ____temp_12
    if not u or not isCampfire(nil, u) then
        return
    end
    local set = campfireItems:get(u)
    if not set then
        return
    end
    for ____, it in __TS__Iterator(set) do
        untrackItem(nil, it)
    end
    campfireItems:delete(u)
end
____exports["init物品加工"] = function(self)
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerAddAction) ~= "function" or type(jass.Player) ~= "function" then
        return
    end
    local ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_13 = jass.EVENT_PLAYER_UNIT_PICKUP_ITEM
    if ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_13 == nil then
        ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_13 = 18
    end
    local pickEv = ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_13
    local trigPick = jass.CreateTrigger()
    do
        local i = 0
        while i <= 3 do
            if type(jass.TriggerRegisterPlayerUnitEvent) == "function" then
                jass.TriggerRegisterPlayerUnitEvent(
                    trigPick,
                    jass.Player(i),
                    pickEv,
                    nil
                )
            end
            i = i + 1
        end
    end
    jass.TriggerAddAction(trigPick, onAnyPickup)
    local ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_14 = jass.EVENT_PLAYER_UNIT_DROP_ITEM
    if ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_14 == nil then
        ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_14 = 19
    end
    local dropEv = ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_14
    local trigDrop = jass.CreateTrigger()
    do
        local i = 0
        while i <= 3 do
            if type(jass.TriggerRegisterPlayerUnitEvent) == "function" then
                jass.TriggerRegisterPlayerUnitEvent(
                    trigDrop,
                    jass.Player(i),
                    dropEv,
                    nil
                )
            end
            i = i + 1
        end
    end
    jass.TriggerAddAction(
        trigDrop,
        function()
            local ____temp_15
            if type(jass.GetManipulatingUnit) == "function" then
                ____temp_15 = jass.GetManipulatingUnit()
            else
                ____temp_15 = nil
            end
            local unit = ____temp_15
            local ____temp_16
            if type(jass.GetManipulatedItem) == "function" then
                ____temp_16 = jass.GetManipulatedItem()
            else
                ____temp_16 = nil
            end
            local item = ____temp_16
            if unit and item and isCampfire(nil, unit) and itemState:has(item) then
                untrackItem(nil, item)
            end
        end
    )
    local trigDeath = jass.CreateTrigger()
    if type(jass.TriggerRegisterPlayerUnitEvent) == "function" then
        local ____jass_EVENT_PLAYER_UNIT_DEATH_17 = jass.EVENT_PLAYER_UNIT_DEATH
        if ____jass_EVENT_PLAYER_UNIT_DEATH_17 == nil then
            ____jass_EVENT_PLAYER_UNIT_DEATH_17 = 56
        end
        local ev = ____jass_EVENT_PLAYER_UNIT_DEATH_17
        do
            local i = 0
            while i < 16 do
                jass.TriggerRegisterPlayerUnitEvent(
                    trigDeath,
                    jass.Player(i),
                    ev,
                    nil
                )
                i = i + 1
            end
        end
    end
    jass.TriggerAddAction(trigDeath, onAnyDeath)
end
____exports["init物品加工"](nil)
return ____exports]]

P['系统/装备/装备回复.lua'] = [[local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__StringEndsWith = ____lualib.__TS__StringEndsWith
local ____exports = {}
--- 装备回复：单位使用物品时解析 hot 字段，支持多段（+分隔）、百分比(%hp/%hpLost/%mp)、固定值、wait延迟。
-- 规则详见 .cursor/rules/equip-heal-hot-format.md
-- 防重复事件见 .cursor/rules/equip-heal-use-item.md
local jass = require("jass.common")
local g = require("jass.globals")
local itemsData = require("系统.装备.装备数据").default
local function fourCCToString(self, fourcc)
    local c1 = string.char(fourcc % 256)
    local c2 = string.char(math.floor(fourcc / 256) % 256)
    local c3 = string.char(math.floor(fourcc / 65536) % 256)
    local c4 = string.char(math.floor(fourcc / 16777216) % 256)
    return ((c4 .. c3) .. c2) .. c1
end
--- 解析 hot 字符串和 abilList，返回每段的信息
local function parseSegments(self, hotStr, abilList)
    local segments = __TS__StringSplit(hotStr, "+")
    local abilIds = __TS__ArrayMap(
        __TS__StringSplit(abilList, ","),
        function(____, x) return __TS__StringTrim(x) end
    )
    local result = {}
    do
        local i = 0
        while i < #segments do
            do
                local __continue6
                repeat
                    local seg = __TS__StringTrim(segments[i + 1])
                    if seg == "" then
                        __continue6 = true
                        break
                    end
                    local tokens = __TS__ArrayFilter(
                        __TS__ArrayMap(
                            __TS__StringSplit(seg, ";"),
                            function(____, x) return __TS__StringTrim(x) end
                        ),
                        function(____, x) return x ~= "" end
                    )
                    local waitSec = 0
                    for ____, t in ipairs(tokens) do
                        local waitIdx = (string.find(t, ":wait", nil, true) or 0) - 1
                        if waitIdx >= 0 then
                            local w = __TS__ParseFloat(__TS__StringSubstring(t, waitIdx + 5)) or 0
                            if w > waitSec then
                                waitSec = w
                            end
                        end
                    end
                    result[#result + 1] = {tokens = tokens, abilId = abilIds[i + 1] or "", waitSec = waitSec}
                    __continue6 = true
                until true
                if not __continue6 then
                    break
                end
            end
            i = i + 1
        end
    end
    return result
end
--- 根据 token 列表和单位，计算 TempReal[1]=HP、TempReal[2]=MP，token 中 :waitN 后缀在此忽略（已提取）
local function calcHpMp(self, tokens, unit)
    local hp = 0
    local mp = 0
    local ____temp_0
    if type(jass.GetUnitState) == "function" then
        ____temp_0 = jass.GetUnitState(
            unit,
            jass.ConvertUnitState(1)
        )
    else
        ____temp_0 = 0
    end
    local maxHp = ____temp_0
    local ____temp_1
    if type(jass.GetWidgetLife) == "function" then
        ____temp_1 = jass.GetWidgetLife(unit)
    else
        ____temp_1 = 0
    end
    local curHp = ____temp_1
    local ____temp_2
    if type(jass.GetUnitState) == "function" then
        ____temp_2 = jass.GetUnitState(
            unit,
            jass.ConvertUnitState(3)
        )
    else
        ____temp_2 = 0
    end
    local maxMp = ____temp_2
    local lostHp = maxHp - curHp
    for ____, rawToken in ipairs(tokens) do
        local waitIdx = (string.find(rawToken, ":wait", nil, true) or 0) - 1
        local t = __TS__StringTrim(waitIdx >= 0 and __TS__StringSubstring(rawToken, 0, waitIdx) or rawToken)
        local tl = string.lower(t)
        if __TS__StringEndsWith(tl, "hplost") then
            local prefix = __TS__StringSubstring(t, 0, #t - 6)
            if __TS__StringEndsWith(prefix, "%") then
                local pct = __TS__ParseFloat(__TS__StringSubstring(prefix, 0, #prefix - 1)) / 100
                hp = hp + lostHp * pct
            else
                hp = hp + (__TS__ParseFloat(prefix) or 0)
            end
        elseif __TS__StringEndsWith(tl, "hp") then
            local prefix = __TS__StringSubstring(t, 0, #t - 2)
            if __TS__StringEndsWith(prefix, "%") then
                local pct = __TS__ParseFloat(__TS__StringSubstring(prefix, 0, #prefix - 1)) / 100
                hp = hp + maxHp * pct
            else
                hp = hp + (__TS__ParseFloat(prefix) or 0)
            end
        elseif __TS__StringEndsWith(tl, "mp") then
            local prefix = __TS__StringSubstring(t, 0, #t - 2)
            if __TS__StringEndsWith(prefix, "%") then
                local pct = __TS__ParseFloat(__TS__StringSubstring(prefix, 0, #prefix - 1)) / 100
                mp = mp + maxMp * pct
            else
                mp = mp + (__TS__ParseFloat(prefix) or 0)
            end
        end
    end
    return {hp = hp, mp = mp}
end
--- 立即执行一段的赋值+TriggerExecute
local function executeSegment(self, unit, seg)
    local ____calcHpMp_result_3 = calcHpMp(nil, seg.tokens, unit)
    local hp = ____calcHpMp_result_3.hp
    local mp = ____calcHpMp_result_3.mp
    local ____temp_5
    if g.udg_TempReal ~= nil then
        ____temp_5 = g.udg_TempReal
    else
        local ____temp_4 = {}
        g.udg_TempReal = ____temp_4
        ____temp_5 = ____temp_4
    end
    local tr = ____temp_5
    tr[1] = hp
    tr[2] = mp
    jass.udg_TempUnit[1] = unit
    g.udg_TempString[0] = seg.abilId
    local trig = g.gg_trg_HealItemEffect
    if trig and type(jass.TriggerExecute) == "function" then
        jass.TriggerExecute(trig)
    end
end
local function onUseItem(self)
    local ____this_7
    ____this_7 = jass
    local ____opt_6 = ____this_7.GetManipulatingUnit
    if ____opt_6 ~= nil then
        ____opt_6 = ____opt_6(____this_7)
    end
    local ____opt_6_10 = ____opt_6
    if ____opt_6_10 == nil then
        local ____this_9
        ____this_9 = jass
        local ____opt_8 = ____this_9.GetTriggerUnit
        if ____opt_8 ~= nil then
            ____opt_8 = ____opt_8(____this_9)
        end
        ____opt_6_10 = ____opt_8
    end
    local unit = ____opt_6_10
    local ____this_12
    ____this_12 = jass
    local ____opt_11 = ____this_12.GetManipulatedItem
    if ____opt_11 ~= nil then
        ____opt_11 = ____opt_11(____this_12)
    end
    local item = ____opt_11
    if not unit or not item then
        return
    end
    if type(jass.IsUnitType) == "function" and jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED) then
        return
    end
    if type(jass.IsUnitIllusionBJ) == "function" and jass.IsUnitIllusionBJ(unit) then
        return
    end
    local ____temp_13
    if type(jass.GetItemTypeId) == "function" then
        ____temp_13 = jass.GetItemTypeId(item)
    else
        ____temp_13 = 0
    end
    local itemId = ____temp_13
    local idStr = fourCCToString(nil, itemId)
    local entry = itemsData[idStr]
    if not entry or not entry.hot or not entry.abilList then
        return
    end
    local glob = _G
    local key = (tostring(unit) .. "_") .. idStr
    if glob.__EquipHealExecutedKey == key then
        return
    end
    glob.__EquipHealExecutedKey = key
    local ____this_15
    ____this_15 = jass
    local ____opt_14 = ____this_15.CreateTimer
    if ____opt_14 ~= nil then
        ____opt_14 = ____opt_14(____this_15)
    end
    local clearTimer = ____opt_14
    if clearTimer and type(jass.TimerStart) == "function" then
        local ct = clearTimer
        jass.TimerStart(
            ct,
            0.5,
            false,
            function()
                glob.__EquipHealExecutedKey = nil
                if type(jass.DestroyTimer) == "function" then
                    jass.DestroyTimer(ct)
                end
            end
        )
    end
    local segments = parseSegments(nil, entry.hot, entry.abilList)
    for ____, seg in ipairs(segments) do
        do
            local __continue37
            repeat
                if seg.abilId == "" then
                    __continue37 = true
                    break
                end
                if seg.waitSec <= 0 then
                    executeSegment(nil, unit, seg)
                else
                    local ____this_17
                    ____this_17 = jass
                    local ____opt_16 = ____this_17.CreateTimer
                    if ____opt_16 ~= nil then
                        ____opt_16 = ____opt_16(____this_17)
                    end
                    local delayTimer = ____opt_16
                    if delayTimer and type(jass.TimerStart) == "function" then
                        local dt = delayTimer
                        local capturedSeg = seg
                        local capturedUnit = unit
                        jass.TimerStart(
                            dt,
                            seg.waitSec,
                            false,
                            function()
                                executeSegment(nil, capturedUnit, capturedSeg)
                                if type(jass.DestroyTimer) == "function" then
                                    jass.DestroyTimer(dt)
                                end
                            end
                        )
                    end
                end
                __continue37 = true
            until true
            if not __continue37 then
                break
            end
        end
    end
end
local INIT_KEY = "__EquipHealInited"
local function init(self)
    if g[INIT_KEY] then
        return
    end
    g[INIT_KEY] = true
    local ____jass_EVENT_PLAYER_UNIT_USE_ITEM_18 = jass.EVENT_PLAYER_UNIT_USE_ITEM
    if ____jass_EVENT_PLAYER_UNIT_USE_ITEM_18 == nil then
        ____jass_EVENT_PLAYER_UNIT_USE_ITEM_18 = 35
    end
    local useItemEv = ____jass_EVENT_PLAYER_UNIT_USE_ITEM_18
    local trig = jass.CreateTrigger()
    do
        local i = 0
        while i <= 6 do
            jass.TriggerRegisterPlayerUnitEvent(
                trig,
                jass.Player(i),
                useItemEv,
                nil
            )
            i = i + 1
        end
    end
    local ____this_20
    ____this_20 = jass
    local ____opt_19 = ____this_20.Player
    if ____opt_19 ~= nil then
        ____opt_19 = ____opt_19(____this_20, 13)
    end
    local p13 = ____opt_19
    if p13 ~= nil then
        jass.TriggerRegisterPlayerUnitEvent(trig, p13, useItemEv, nil)
    end
    jass.TriggerAddAction(trig, onUseItem)
end
init(nil)
return ____exports]]

P['系统/装备/装备成长.lua'] = [[local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__StringEndsWith = ____lualib.__TS__StringEndsWith
local ____exports = {}
--- 装备成长：单位使用物品时，若装备数据有 PowerUP 字段，执行属性成长。
-- 格式：  段1+段2+...，段内用 ; 分隔效果；time>0 表示临时（N秒后撤销），time0/无time=永久
-- 效果类型：Nstat / N%stat / Nexp / Nlevel / (level*N)stat / (level*N)exp
-- 规则详见 .cursor/rules/equip-heal-hot-format.md
local jass = require("jass.common")
local g = require("jass.globals")
local itemsData = require("系统.装备.装备数据").default
local ____require_result_0 = require("系统.00_核心.封装函数")
local AddGoldWithFeedback = ____require_result_0.AddGoldWithFeedback
--- key -> 显示名（与装备系统.ts STAT_CONFIG 保持一致）
local KEY_TO_NAME = {
    hp = "生命值",
    mp = "魔法值",
    dmg = "攻击力",
    armor = "护甲",
    atkSpeed = "攻速",
    movespeed = "叠加移动速度",
    str = "力量",
    agi = "敏捷",
    int = "智力",
    all = "全属性",
    critRate = "暴击率",
    critDmg = "暴击伤害",
    magicResist = "魔抗",
    hpRegen = "生命恢复",
    hpRegenPct = "生命恢复%",
    hpRegenEff = "生命恢复效率",
    skillHeal = "技能治疗率",
    healReceived = "受到的治疗率",
    mpRegen = "魔法恢复",
    mpRegenPct = "魔法恢复%",
    mpCost = "魔法消耗",
    cdReduction = "冷却缩减",
    accuracy = "命中率",
    dodge = "闪避率",
    armorPierce = "护甲穿透",
    magicPierce = "魔法穿透",
    skillDmg = "技能伤害",
    skillResist = "技能抗性",
    magicDmg = "魔法伤害",
    physDmg = "物理伤害",
    physResist = "物理抗性",
    enhanceDmg = "强化伤害",
    atkDmg = "普攻伤害",
    atkResist = "普攻抗性",
    lightDmg = "光属性伤害",
    lightResist = "光属性抗性",
    darkDmg = "暗属性伤害",
    darkResist = "暗属性抗性",
    woodDmg = "木属性伤害",
    woodResist = "木属性抗性",
    fireDmg = "火属性伤害",
    fireResist = "火属性抗性",
    thunderDmg = "雷属性伤害",
    thunderResist = "雷属性抗性",
    waterDmg = "水属性伤害",
    waterResist = "水属性抗性",
    MetalResist = "金属性抗性",
    summonDmg = "召唤物伤害",
    summonResist = "召唤物抗性",
    dmgReduction = "伤害减少",
    dmgReductionPct = "伤害减少%",
    lifeSteal = "伤害吸血",
    magicLifeSteal = "魔法伤害吸血",
    atkLifeSteal = "普攻伤害吸血",
    critRateTaken = "被暴击率",
    critDmgTaken = "被暴击伤害",
    stunResist = "眩晕抗性",
    magicAtkDmg = "魔法普攻伤害",
    antMastery = "蝼蚁专精",
    movespeed2 = "移动速度",
    dmgBonus = "伤害%",
    finalDamageMultiplier = "最终伤害%",
    expGainRate = "经验获取率",
    hpPct = "最大生命值%",
    baseDmgPct = "基础攻击力%"
}
local function fourCCToString(self, fourcc)
    local c1 = string.char(fourcc % 256)
    local c2 = string.char(math.floor(fourcc / 256) % 256)
    local c3 = string.char(math.floor(fourcc / 65536) % 256)
    local c4 = string.char(math.floor(fourcc / 16777216) % 256)
    return ((c4 .. c3) .. c2) .. c1
end
--- 根据原始 key 字符串（大小写不敏感）查找 KEY_TO_NAME 里的正确 key
local function findStatKey(self, raw)
    if KEY_TO_NAME[raw] ~= nil then
        return raw
    end
    local rl = string.lower(raw)
    for k in pairs(KEY_TO_NAME) do
        if string.lower(k) == rl then
            return k
        end
    end
    return ""
end
local function parsePowerUP(self, powerUpStr)
    local segments = {}
    local rawSegs = __TS__StringSplit(powerUpStr, "+")
    do
        local si = 0
        while si < #rawSegs do
            do
                local __continue10
                repeat
                    local rawSeg = __TS__StringTrim(rawSegs[si + 1])
                    if rawSeg == "" then
                        __continue10 = true
                        break
                    end
                    local tokens = __TS__ArrayFilter(
                        __TS__ArrayMap(
                            __TS__StringSplit(rawSeg, ";"),
                            function(____, x) return __TS__StringTrim(x) end
                        ),
                        function(____, x) return x ~= "" end
                    )
                    local timeSec = 0
                    local effectTokens = {}
                    for ____, t in ipairs(tokens) do
                        local tl = string.lower(t)
                        if (string.find(tl, "time", nil, true) or 0) - 1 == 0 then
                            local w = __TS__ParseFloat(__TS__StringSubstring(t, 4)) or 0
                            if w > timeSec then
                                timeSec = w
                            end
                        else
                            effectTokens[#effectTokens + 1] = t
                        end
                    end
                    local effects = {}
                    for ____, t in ipairs(effectTokens) do
                        do
                            local __continue19
                            repeat
                                local tl0 = string.lower(t)
                                if __TS__StringEndsWith(tl0, "gold") then
                                    if (string.find(tl0, "%gold", nil, true) or 0) - 1 >= 0 then
                                        local pctStr = __TS__StringTrim(__TS__StringSubstring(
                                            t,
                                            0,
                                            (string.find(tl0, "%", nil, true) or 0) - 1
                                        ))
                                        local pctNum = __TS__ParseFloat(pctStr) or 0
                                        effects[#effects + 1] = {type = "gold", isPct = true, value = pctNum / 100, isLevelMult = false}
                                        __continue19 = true
                                        break
                                    end
                                    local core = __TS__StringTrim(__TS__StringSubstring(t, 0, #t - 4))
                                    local dash = (string.find(core, "-", nil, true) or 0) - 1
                                    if dash >= 0 then
                                        local a = __TS__ParseFloat(__TS__StringTrim(__TS__StringSubstring(core, 0, dash))) or 0
                                        local b = __TS__ParseFloat(__TS__StringTrim(__TS__StringSubstring(core, dash + 1))) or 0
                                        local mn = a < b and a or b
                                        local mx = a < b and b or a
                                        effects[#effects + 1] = {
                                            type = "gold",
                                            isPct = false,
                                            value = 0,
                                            isLevelMult = false,
                                            min = mn,
                                            max = mx
                                        }
                                    else
                                        local v = __TS__ParseFloat(core) or 0
                                        effects[#effects + 1] = {
                                            type = "gold",
                                            isPct = false,
                                            value = 0,
                                            isLevelMult = false,
                                            min = v,
                                            max = v
                                        }
                                    end
                                    __continue19 = true
                                    break
                                end
                                if (string.find(t, "(level*", nil, true) or 0) - 1 == 0 then
                                    local closeIdx = (string.find(t, ")", nil, true) or 0) - 1
                                    if closeIdx < 0 then
                                        __continue19 = true
                                        break
                                    end
                                    local mult = __TS__ParseFloat(__TS__StringSubstring(t, 7, closeIdx)) or 0
                                    local rawKey = __TS__StringTrim(__TS__StringSubstring(t, closeIdx + 1))
                                    local kl = string.lower(rawKey)
                                    if kl == "exp" then
                                        effects[#effects + 1] = {type = "exp", isPct = false, value = mult, isLevelMult = true}
                                    elseif kl == "level" then
                                        effects[#effects + 1] = {type = "level", isPct = false, value = mult, isLevelMult = true}
                                    else
                                        local ak = findStatKey(nil, rawKey)
                                        if ak ~= "" then
                                            effects[#effects + 1] = {
                                                type = "stat",
                                                key = ak,
                                                isPct = false,
                                                value = mult,
                                                isLevelMult = true
                                            }
                                        end
                                    end
                                    __continue19 = true
                                    break
                                end
                                local pctIdx = (string.find(t, "%", nil, true) or 0) - 1
                                local isPct = pctIdx >= 0
                                local cleaned = isPct and __TS__StringSubstring(t, 0, pctIdx) .. __TS__StringSubstring(t, pctIdx + 1) or t
                                local numEnd = 0
                                while numEnd < #cleaned do
                                    local ch = __TS__StringSubstring(cleaned, numEnd, numEnd + 1)
                                    if ch >= "0" and ch <= "9" or ch == "." or numEnd == 0 and ch == "-" then
                                        numEnd = numEnd + 1
                                    else
                                        break
                                    end
                                end
                                local num = __TS__ParseFloat(__TS__StringSubstring(cleaned, 0, numEnd)) or 0
                                local rawKey = __TS__StringTrim(__TS__StringSubstring(cleaned, numEnd))
                                local kl = string.lower(rawKey)
                                if kl == "exp" then
                                    effects[#effects + 1] = {type = "exp", isPct = false, value = num, isLevelMult = false}
                                elseif kl == "level" then
                                    effects[#effects + 1] = {type = "level", isPct = false, value = num, isLevelMult = false}
                                elseif kl == "gold" then
                                    if isPct then
                                        effects[#effects + 1] = {type = "gold", isPct = true, value = num / 100, isLevelMult = false}
                                    else
                                        effects[#effects + 1] = {
                                            type = "gold",
                                            isPct = false,
                                            value = 0,
                                            isLevelMult = false,
                                            min = num,
                                            max = num
                                        }
                                    end
                                else
                                    local ak = findStatKey(nil, rawKey)
                                    if ak ~= "" then
                                        effects[#effects + 1] = {
                                            type = "stat",
                                            key = ak,
                                            isPct = isPct,
                                            value = isPct and num / 100 or num,
                                            isLevelMult = false
                                        }
                                    end
                                end
                                __continue19 = true
                            until true
                            if not __continue19 then
                                break
                            end
                        end
                    end
                    if #effects > 0 then
                        segments[#segments + 1] = {effects = effects, timeSec = timeSec}
                    end
                    __continue10 = true
                until true
                if not __continue10 then
                    break
                end
            end
            si = si + 1
        end
    end
    return segments
end
--- key → ApplyItemBonus 读取的固定全局变量名
local KEY_TO_UDG = {
    hp = "udg_TempHp",
    mp = "udg_TempMp",
    dmg = "udg_TempDmg",
    armor = "udg_TempArmor",
    atkSpeed = "udg_TempAtkSpeed",
    movespeed = "udg_TempMoveSpeed",
    str = "udg_TempStr",
    agi = "udg_TempAgi",
    int = "udg_TempInt",
    all = "udg_TempAll"
}
--- 通过 ApplyItemBonus 批量加/减属性
-- value 永远传正数；isAdd 控制加/减方向（固定全局由 TempIsAdd 控制符号；TempAmount 需带符号用于数据追踪）
local function applyStats(self, unit, statEffects, isAdd)
    if #statEffects == 0 then
        return
    end
    g.udg_TempHp = 0
    g.udg_TempMp = 0
    g.udg_TempDmg = 0
    g.udg_TempArmor = 0
    g.udg_TempAtkSpeed = 0
    g.udg_TempMoveSpeed = 0
    g.udg_TempStr = 0
    g.udg_TempAgi = 0
    g.udg_TempInt = 0
    g.udg_TempAll = 0
    do
        local i = 0
        while i < #statEffects do
            local udgKey = KEY_TO_UDG[statEffects[i + 1].key]
            if udgKey ~= nil then
                g[udgKey] = statEffects[i + 1].value
            end
            i = i + 1
        end
    end
    jass.udg_TempUnit[1] = unit
    g.udg_TempIsAdd = isAdd
    g.udg_TempStatCount = #statEffects
    g.udg_TempString = {}
    g.udg_TempAmount = {}
    do
        local i = 0
        while i < #statEffects do
            g.udg_TempString[i + 1] = statEffects[i + 1].name
            g.udg_TempAmount[i + 1] = isAdd and statEffects[i + 1].value or -statEffects[i + 1].value
            i = i + 1
        end
    end
    if type(jass.ExecuteFunc) == "function" then
        jass.ExecuteFunc("ApplyItemBonus")
    end
end
--- 分 10 份给经验，避免跳级触发不到
local function addHeroXP(self, unit, amount)
    if amount <= 0 then
        return
    end
    local chunk = math.floor(amount / 10)
    do
        local i = 0
        while i < 10 do
            if type(jass.AddHeroXP) == "function" then
                jass.AddHeroXP(unit, chunk, true)
            end
            i = i + 1
        end
    end
    local remainder = amount - chunk * 10
    if remainder > 0 and type(jass.AddHeroXP) == "function" then
        jass.AddHeroXP(unit, remainder, true)
    end
end
local function getHeroLevel(self, unit)
    local ____temp_1
    if type(jass.GetHeroLevel) == "function" then
        ____temp_1 = jass.GetHeroLevel(unit)
    else
        ____temp_1 = 1
    end
    return ____temp_1
end
--- 获取单位当前属性的绝对值，用于百分比计算。
-- str/agi/int 用 GetHeroStr/Agi/Int；hp/mp 用 GetUnitState+ConvertUnitState；
-- dmg=ConvertUnitState(0x15)，armor=ConvertUnitState(0x20)（需要 japi）
local function getPctStatValue(self, unit, key)
    if key == "int" then
        local ____temp_2
        if type(jass.GetHeroInt) == "function" then
            ____temp_2 = jass.GetHeroInt(unit, true)
        else
            ____temp_2 = 0
        end
        return ____temp_2
    end
    if key == "str" then
        local ____temp_3
        if type(jass.GetHeroStr) == "function" then
            ____temp_3 = jass.GetHeroStr(unit, true)
        else
            ____temp_3 = 0
        end
        return ____temp_3
    end
    if key == "agi" then
        local ____temp_4
        if type(jass.GetHeroAgi) == "function" then
            ____temp_4 = jass.GetHeroAgi(unit, true)
        else
            ____temp_4 = 0
        end
        return ____temp_4
    end
    if key == "hp" then
        local ____temp_5
        if type(jass.GetUnitState) == "function" then
            ____temp_5 = jass.GetUnitState(
                unit,
                jass.ConvertUnitState(1)
            )
        else
            ____temp_5 = 0
        end
        return ____temp_5
    end
    if key == "mp" then
        local ____temp_6
        if type(jass.GetUnitState) == "function" then
            ____temp_6 = jass.GetUnitState(
                unit,
                jass.ConvertUnitState(3)
            )
        else
            ____temp_6 = 0
        end
        return ____temp_6
    end
    if key == "dmg" then
        local ____temp_7
        if type(jass.GetUnitState) == "function" then
            ____temp_7 = jass.GetUnitState(
                unit,
                jass.ConvertUnitState(21)
            )
        else
            ____temp_7 = 0
        end
        return ____temp_7
    end
    if key == "armor" then
        local ____temp_8
        if type(jass.GetUnitState) == "function" then
            ____temp_8 = jass.GetUnitState(
                unit,
                jass.ConvertUnitState(32)
            )
        else
            ____temp_8 = 0
        end
        return ____temp_8
    end
    return 0
end
--- 对 unit 所属玩家的金币做一次百分比加减（pct 可负）
local function applyGoldPct(self, unit, pct)
    if type(jass.GetOwningPlayer) ~= "function" then
        return
    end
    local player = jass.GetOwningPlayer(unit)
    if not player then
        return
    end
    local stateGold = jass.ConvertPlayerState(1)
    local ____temp_9
    if type(jass.GetPlayerState) == "function" then
        ____temp_9 = jass.GetPlayerState(player, stateGold)
    else
        ____temp_9 = 0
    end
    local cur = ____temp_9
    local delta = math.floor(cur * pct + 0.5)
    local newVal = cur + delta < 0 and 0 or cur + delta
    if type(jass.SetPlayerState) == "function" then
        jass.SetPlayerState(player, stateGold, newVal)
    end
end
local function executeSegment(self, unit, seg)
    local statEffects = {}
    local goldPct = 0
    local goldFixed = {}
    for ____, eff in ipairs(seg.effects) do
        do
            local __continue70
            repeat
                if eff.type == "gold" then
                    if eff.isPct then
                        goldPct = goldPct + eff.value
                    else
                        local mn = type(eff.min) == "number" and eff.min or 0
                        local mx = type(eff.max) == "number" and eff.max or mn
                        goldFixed[#goldFixed + 1] = {min = mn, max = mx}
                    end
                elseif eff.type == "exp" then
                    local amount = eff.isLevelMult and math.floor(getHeroLevel(nil, unit) * eff.value) or math.floor(eff.value)
                    addHeroXP(nil, unit, amount)
                elseif eff.type == "level" then
                    local cur = getHeroLevel(nil, unit)
                    local add = eff.isLevelMult and math.floor(cur * eff.value) or math.floor(eff.value)
                    if add > 0 and type(jass.SetHeroLevel) == "function" then
                        jass.SetHeroLevel(unit, cur + add, true)
                    end
                elseif eff.type == "stat" and eff.key ~= nil and eff.key ~= "" then
                    local name = KEY_TO_NAME[eff.key]
                    if name == nil then
                        __continue70 = true
                        break
                    end
                    local val
                    if eff.isPct then
                        val = getPctStatValue(nil, unit, eff.key) * eff.value
                    elseif eff.isLevelMult then
                        val = getHeroLevel(nil, unit) * eff.value
                    else
                        val = eff.value
                    end
                    statEffects[#statEffects + 1] = {name = name, key = eff.key, value = val}
                end
                __continue70 = true
            until true
            if not __continue70 then
                break
            end
        end
    end
    if goldPct ~= 0 then
        if seg.timeSec <= 0 then
            applyGoldPct(nil, unit, goldPct)
        else
            local capturedUnit = unit
            local capturedPct = goldPct
            local remaining = math.floor(seg.timeSec)
            local ____temp_10
            if type(jass.CreateTimer) == "function" then
                ____temp_10 = jass.CreateTimer()
            else
                ____temp_10 = nil
            end
            local dt = ____temp_10
            if dt and type(jass.TimerStart) == "function" then
                local t = dt
                jass.TimerStart(
                    t,
                    1,
                    true,
                    function()
                        applyGoldPct(nil, capturedUnit, capturedPct)
                        remaining = remaining - 1
                        if remaining <= 0 then
                            if type(jass.DestroyTimer) == "function" then
                                jass.DestroyTimer(t)
                            end
                        end
                    end
                )
            end
        end
    end
    if #goldFixed > 0 then
        do
            local i = 0
            while i < #goldFixed do
                local mn = math.floor(goldFixed[i + 1].min)
                local mx = math.floor(goldFixed[i + 1].max)
                local delta = mn
                if mx ~= mn then
                    local a = mn < mx and mn or mx
                    local b = mn < mx and mx or mn
                    delta = math.random(a, b)
                end
                if delta ~= 0 then
                    AddGoldWithFeedback(nil, {delta = delta, unit = unit})
                end
                i = i + 1
            end
        end
    end
    if #statEffects > 0 then
        applyStats(nil, unit, statEffects, true)
        if seg.timeSec > 0 then
            local capturedStats = statEffects
            local capturedUnit = unit
            local ____temp_11
            if type(jass.CreateTimer) == "function" then
                ____temp_11 = jass.CreateTimer()
            else
                ____temp_11 = nil
            end
            local dt = ____temp_11
            if dt and type(jass.TimerStart) == "function" then
                local t = dt
                jass.TimerStart(
                    t,
                    seg.timeSec,
                    false,
                    function()
                        applyStats(nil, capturedUnit, capturedStats, false)
                        if type(jass.DestroyTimer) == "function" then
                            jass.DestroyTimer(t)
                        end
                    end
                )
            end
        end
    end
end
local function onUseItem(self)
    local ____temp_12
    if type(jass.GetManipulatingUnit) == "function" then
        ____temp_12 = jass.GetManipulatingUnit()
    else
        ____temp_12 = nil
    end
    local unit = ____temp_12
    local ____temp_13
    if type(jass.GetManipulatedItem) == "function" then
        ____temp_13 = jass.GetManipulatedItem()
    else
        ____temp_13 = nil
    end
    local item = ____temp_13
    if not unit or not item then
        return
    end
    if type(jass.IsUnitType) == "function" and jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED) then
        return
    end
    if type(jass.IsUnitIllusionBJ) == "function" and jass.IsUnitIllusionBJ(unit) then
        return
    end
    local ____temp_14
    if type(jass.GetItemTypeId) == "function" then
        ____temp_14 = jass.GetItemTypeId(item)
    else
        ____temp_14 = 0
    end
    local itemId = ____temp_14
    local idStr = fourCCToString(nil, itemId)
    local entry = itemsData[idStr]
    if not entry or not entry.PowerUP then
        return
    end
    local glob = _G
    local key = (("__EquipPowerUP_" .. tostring(unit)) .. "_") .. idStr
    if glob[key] then
        return
    end
    glob[key] = true
    local ____temp_15
    if type(jass.CreateTimer) == "function" then
        ____temp_15 = jass.CreateTimer()
    else
        ____temp_15 = nil
    end
    local ct = ____temp_15
    if ct and type(jass.TimerStart) == "function" then
        local t = ct
        jass.TimerStart(
            t,
            0.5,
            false,
            function()
                glob[key] = nil
                if type(jass.DestroyTimer) == "function" then
                    jass.DestroyTimer(t)
                end
            end
        )
    end
    local segments = parsePowerUP(nil, entry.PowerUP)
    for ____, seg in ipairs(segments) do
        executeSegment(nil, unit, seg)
    end
end
local INIT_KEY = "__EquipPowerUPInited"
local function init(self)
    if g[INIT_KEY] then
        return
    end
    g[INIT_KEY] = true
    local ____jass_EVENT_PLAYER_UNIT_USE_ITEM_16 = jass.EVENT_PLAYER_UNIT_USE_ITEM
    if ____jass_EVENT_PLAYER_UNIT_USE_ITEM_16 == nil then
        ____jass_EVENT_PLAYER_UNIT_USE_ITEM_16 = 35
    end
    local useItemEv = ____jass_EVENT_PLAYER_UNIT_USE_ITEM_16
    local trig = jass.CreateTrigger()
    do
        local i = 0
        while i <= 6 do
            jass.TriggerRegisterPlayerUnitEvent(
                trig,
                jass.Player(i),
                useItemEv,
                nil
            )
            i = i + 1
        end
    end
    local ____this_18
    ____this_18 = jass
    local ____opt_17 = ____this_18.Player
    if ____opt_17 ~= nil then
        ____opt_17 = ____opt_17(____this_18, 13)
    end
    local p13 = ____opt_17
    if p13 ~= nil then
        jass.TriggerRegisterPlayerUnitEvent(trig, p13, useItemEv, nil)
    end
    jass.TriggerAddAction(trig, onUseItem)
end
init(nil)
return ____exports]]

P['系统/装备/装备掉落.lua'] = [[local ____lualib = require("lualib_bundle")
local __TS__StringCharCodeAt = ____lualib.__TS__StringCharCodeAt
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__Number = ____lualib.__TS__Number
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local getItemsByScoreRange, itemsData
function getItemsByScoreRange(self, minScore, maxScore)
    local result = {}
    for id in pairs(itemsData) do
        do
            local __continue84
            repeat
                if type(id) ~= "string" or #id ~= 4 then
                    __continue84 = true
                    break
                end
                local entry = itemsData[id]
                local score = entry and entry.score
                if type(score) ~= "number" then
                    __continue84 = true
                    break
                end
                if score >= minScore and score <= maxScore then
                    result[#result + 1] = id
                end
                __continue84 = true
            until true
            if not __continue84 then
                break
            end
        end
    end
    return result
end
--- 装备掉落表格式说明：
-- - picks：最多掉落多少件（不是必定掉满）。
-- - itemIds 带百分数（如 I03Y:7%;I04R:7%）：每项独立按概率判定，不重复；最多 picks 件。仅当 picks > 物品种类数时，差额按权重再抽（可重复）。
-- - itemIds 纯权重（如 I02C:1.5;I01G:1）：按权重在池中随机抽 picks 件。
-- - itemIds 无权重（如 I00C;I00E;I00D;I00G）：从池中选 min(picks, 池大小) 件不重复；picks > 池大小时多出的可重复随机。
-- - always：必掉且仅掉一次。
-- - unitType 为 elite/Boss 且 T>1 时，picks = round(basePicks×(1+0.334×(T-1)))。
local jass = require("jass.common")
local g = require("jass.globals")
local equipExcrete = require("系统.装备.装备排泄")
local idData = require("系统.装备.装备掉落表").default or require("系统.装备.装备掉落表").idData or ({})
itemsData = require("系统.装备.装备数据").default or ({})
local _seed = 0
local PREFIX = "|cffffff00『系统提示』：|r";
(function()
    local key = "__equip_drop_seeded"
    if _G[key] then
        return
    end
    _G[key] = true
    local s = tostring({})
    local h = 0
    do
        local i = 0
        while i < #s do
            h = (h * 33 + __TS__StringCharCodeAt(s, i)) % 2147483647
            i = i + 1
        end
    end
    if h <= 0 then
        h = 12345
    end
    _seed = h
    math.randomseed(_seed)
end)(nil)
local function stringToFourCC(self, s)
    local b1 = string.byte(s, 1)
    local b2 = string.byte(s, 2)
    local b3 = string.byte(s, 3)
    local b4 = string.byte(s, 4)
    return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4
end
local function typeIdToUnitId(self, typeId)
    for id in pairs(idData) do
        if stringToFourCC(nil, id) == typeId then
            return id
        end
    end
    return nil
end
--- 解析 itemIds → [{id, weight, always?}]。always 标记必掉且仅掉一次、不参与重复抽取
local function parseItemPool(self, itemIdsStr)
    local raw = __TS__StringTrim(tostring(itemIdsStr))
    if not raw then
        return {}
    end
    local parts = __TS__ArrayFilter(
        __TS__ArrayMap(
            __TS__StringSplit(raw, ";"),
            function(____, p) return __TS__StringTrim(p) end
        ),
        function(____, p) return #p >= 4 end
    )
    local hasColon = __TS__ArraySome(
        parts,
        function(____, p) return (string.find(p, ":", nil, true) or 0) - 1 >= 0 end
    )
    local pool = {}
    if hasColon then
        for ____, p in ipairs(parts) do
            do
                local __continue18
                repeat
                    local colon = (string.find(p, ":", nil, true) or 0) - 1
                    if colon < 0 then
                        __continue18 = true
                        break
                    end
                    local id = __TS__StringTrim(__TS__StringSubstring(p, 0, colon))
                    local w = 0
                    local always = false
                    local rest = string.lower(__TS__StringTrim(__TS__StringSubstring(p, colon + 1)))
                    if rest == "always" then
                        w = 1
                        always = true
                    elseif (string.find(rest, "%", nil, true) or 0) - 1 >= 0 then
                        w = __TS__ParseFloat(rest) / 100
                    else
                        w = __TS__ParseFloat(rest)
                    end
                    if #id >= 4 then
                        pool[#pool + 1] = {
                            id = __TS__StringSubstring(id, 0, 4),
                            weight = w,
                            always = always
                        }
                    end
                    __continue18 = true
                until true
                if not __continue18 then
                    break
                end
            end
        end
    else
        for ____, p in ipairs(parts) do
            local id = __TS__StringSubstring(p, 0, 4)
            if #id == 4 then
                pool[#pool + 1] = {id = id, weight = 1}
            end
        end
    end
    return pool
end
--- Jass 全局 T = 玩家人数。unitType 为 elite/Boss 时，picks = round(basePicks × (1 + 0.334×(T-1)))，如 T=5、picks=2 得 5
local function getEffectivePicks(self, basePicks, unitType)
    local ut = string.lower(tostring(unitType or ""))
    if ut ~= "elite" and ut ~= "boss" then
        return basePicks
    end
    local T = g.udg_T ~= nil and __TS__Number(g.udg_T) or 0
    if T <= 1 then
        return basePicks
    end
    local mult = 1 + 0.334 * (T - 1)
    return math.floor(basePicks * mult + 0.5)
end
--- 加权随机取一个（权重不必归一化）
local function weightedPickOne(self, pool)
    if #pool == 0 then
        return nil
    end
    local sum = 0
    for ____, p in ipairs(pool) do
        sum = sum + p.weight
    end
    if sum <= 0 then
        local ____opt_0 = pool[math.random(1, #pool)]
        if ____opt_0 ~= nil then
            ____opt_0 = ____opt_0.id
        end
        return ____opt_0
    end
    local r = math.random(1, 10000) / 10000 * sum
    local acc = 0
    for ____, p in ipairs(pool) do
        acc = acc + p.weight
        if r <= acc then
            return p.id
        end
    end
    return pool[#pool].id
end
--- 权重/百分比池：最多 picks 件；首轮每项独立按概率 roll，不重复。
-- 仅当 picks > 池子物品种类数时，差额按权重再抽（可重复掉落）。
local function pickFromWeightedPool(self, pool, picks)
    if #pool == 0 then
        return {}
    end
    if picks == 1 then
        local one = weightedPickOne(nil, pool)
        return one and ({one}) or ({})
    end
    local out = {}
    for ____, p in ipairs(pool) do
        if p.weight >= 1 or p.always then
            out[#out + 1] = p.id
        else
            local r = math.random(1, 10000) / 10000
            if r < p.weight then
                out[#out + 1] = p.id
            end
        end
    end
    if #out > picks then
        do
            local i = #out - 1
            while i >= 1 do
                local j = math.random(1, i + 1)
                local t = out[i + 1]
                out[i + 1] = out[j]
                out[j] = t
                i = i - 1
            end
        end
        while #out > picks do
            table.remove(out)
        end
    end
    local needMore = picks - #out
    if needMore <= 0 then
        return out
    end
    if picks <= #pool then
        return out
    end
    do
        local i = 0
        while i < needMore do
            local one = weightedPickOne(nil, pool)
            if one ~= nil then
                out[#out + 1] = one
            end
            i = i + 1
        end
    end
    return out
end
--- 无权重池（I00C;I00E;I00D;I00G）：从池中选 min(picks, 池大小) 件不重复；若 picks > 池大小，多出的按池内随机再抽（可重复）
local function pickFromEqualPool(self, ids, picks)
    if #ids == 0 or picks <= 0 then
        return {}
    end
    local out = {}
    local list = __TS__ArraySlice(ids)
    local firstPicks = picks <= #list and picks or #list
    do
        local i = 0
        while i < firstPicks do
            local idx = math.random(1, #list)
            local id = list[idx - 1]
            out[#out + 1] = id
            __TS__ArraySplice(list, idx - 1, 1)
            i = i + 1
        end
    end
    local needMore = picks - #out
    do
        local i = 0
        while i < needMore do
            local idx = math.random(1, #ids)
            out[#out + 1] = ids[idx - 1]
            i = i + 1
        end
    end
    return out
end
local function createItemAtUnit(self, unit, itemId)
    local four = stringToFourCC(nil, itemId)
    local loc = nil
    if type(jass.GetUnitLoc) == "function" then
        loc = jass.GetUnitLoc(unit)
    end
    if loc and type(jass.CreateItemLoc) == "function" then
        equipExcrete:setLastCreatedItem(jass.CreateItemLoc(four, loc))
    elseif jass.GetUnitX ~= nil then
        local x = jass.GetUnitX(unit)
        local y = jass.GetUnitY(unit)
        equipExcrete:setLastCreatedItem(jass.CreateItem(four, x, y))
    end
    if loc and type(jass.RemoveLocation) == "function" then
        jass.RemoveLocation(loc)
    end
end
local function onUnitDeath(self)
    local unit = jass.GetTriggerUnit()
    if not unit then
        return
    end
    if type(jass.GetUnitTypeId) ~= "function" then
        return
    end
    local typeId = jass.GetUnitTypeId(unit)
    local unitId = typeIdToUnitId(nil, typeId)
    local entry = unitId and idData[unitId] or nil
    if entry and entry.itemIds ~= nil then
        local dropProc = entry.dropProc ~= nil and __TS__Number(entry.dropProc) or 1
        local r = math.random(1, 10000)
        if r > dropProc * 10000 then
            return
        end
        local rawItemIds = tostring(entry.itemIds)
        local pool = parseItemPool(nil, rawItemIds)
        if #pool == 0 then
            return
        end
        local picksNum = math.max(
            1,
            math.floor(__TS__Number(entry.picks) or 1)
        )
        picksNum = getEffectivePicks(nil, picksNum, entry.unitType)
        local ids = __TS__ArrayMap(
            pool,
            function(____, p) return p.id end
        )
        local isEqualPool = (string.find(rawItemIds, ":", nil, true) or 0) - 1 < 0
        local toDrop = isEqualPool and pickFromEqualPool(nil, ids, picksNum) or pickFromWeightedPool(nil, pool, picksNum)
        for ____, id in ipairs(toDrop) do
            createItemAtUnit(nil, unit, id)
        end
        return
    end
    local DROP_RULES = {{unitId = "hfoo", minScore = 150, maxScore = 250, proc = 1}}
    for ____, rule in ipairs(DROP_RULES) do
        do
            local __continue77
            repeat
                if typeId ~= stringToFourCC(nil, rule.unitId) then
                    __continue77 = true
                    break
                end
                local r = math.random(1, 10000)
                if r > rule.proc * 10000 then
                    __continue77 = true
                    break
                end
                local list = getItemsByScoreRange(nil, rule.minScore, rule.maxScore)
                if #list == 0 then
                    __continue77 = true
                    break
                end
                local idx = math.random(1, #list)
                local itemId = list[idx]
                if itemId ~= nil and itemId ~= "" then
                    createItemAtUnit(nil, unit, itemId)
                end
                break
            until true
            if not __continue77 then
                break
            end
        end
    end
end
local function condition(self)
    local u = jass.GetTriggerUnit()
    if not u then
        return false
    end
    if type(jass.IsUnitIllusionBJ) == "function" and jass.IsUnitIllusionBJ(u) then
        return false
    end
    if jass.IsUnitType(u, jass.UNIT_TYPE_SUMMONED) then
        return false
    end
    return true
end
local function init(self)
    local trig = jass.CreateTrigger()
    local ____jass_EVENT_PLAYER_UNIT_DEATH_4 = jass.EVENT_PLAYER_UNIT_DEATH
    if ____jass_EVENT_PLAYER_UNIT_DEATH_4 == nil then
        ____jass_EVENT_PLAYER_UNIT_DEATH_4 = 52
    end
    local eventId = ____jass_EVENT_PLAYER_UNIT_DEATH_4
    do
        local i = 0
        while i < 16 do
            jass.TriggerRegisterPlayerUnitEvent(
                trig,
                jass.Player(i),
                eventId,
                nil
            )
            i = i + 1
        end
    end
    local ____this_7
    ____this_7 = jass
    local ____opt_5 = ____this_7.Player
    if ____opt_5 ~= nil then
        local ____jass_PLAYER_NEUTRAL_AGGRESSIVE_6 = jass.PLAYER_NEUTRAL_AGGRESSIVE
        if ____jass_PLAYER_NEUTRAL_AGGRESSIVE_6 == nil then
            ____jass_PLAYER_NEUTRAL_AGGRESSIVE_6 = 13
        end
        ____opt_5 = ____opt_5(____this_7, ____jass_PLAYER_NEUTRAL_AGGRESSIVE_6)
    end
    local neutral = ____opt_5
    if neutral ~= nil then
        jass.TriggerRegisterPlayerUnitEvent(trig, neutral, eventId, nil)
    end
    local ____this_10
    ____this_10 = jass
    local ____opt_8 = ____this_10.Player
    if ____opt_8 ~= nil then
        local ____jass_PLAYER_NEUTRAL_PASSIVE_9 = jass.PLAYER_NEUTRAL_PASSIVE
        if ____jass_PLAYER_NEUTRAL_PASSIVE_9 == nil then
            ____jass_PLAYER_NEUTRAL_PASSIVE_9 = 15
        end
        ____opt_8 = ____opt_8(____this_10, ____jass_PLAYER_NEUTRAL_PASSIVE_9)
    end
    local neutralPassive = ____opt_8
    if neutralPassive ~= nil then
        jass.TriggerRegisterPlayerUnitEvent(trig, neutralPassive, eventId, nil)
    end
    local cond = jass.Condition
    if type(cond) == "function" then
        jass.TriggerAddCondition(
            trig,
            cond(nil, condition)
        )
    end
    jass.TriggerAddAction(trig, onUnitDeath)
end
init(nil)
return ____exports]]

P['系统/装备/装备掉落表.lua'] = [=[--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["装备掉落表"] = {
    n012 = {id = "n012", name = "森林野猪", level = 1, unitType = "normal"},
    nwlt = {id = "nwlt", name = "森林之狼", level = 1, unitType = "normal"},
    hfoo = {
        id = "hfoo",
        name = "步兵",
        level = 2,
        itemIds = "I03U:50%;I00S:50%",
        picks = 2,
        isUniversal = "TRUE",
        unitType = "normal"
    },
    n009 = {
        id = "n009",
        name = "普通地精",
        level = 2,
        itemIds = "I01X:6%;I01P:6%",
        picks = 2,
        isUniversal = "TRUE",
        unitType = "normal"
    },
    n000 = {
        id = "n000",
        name = "蓝色史莱姆",
        level = 2,
        itemIds = "I00B:10%;I010:6%",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    n002 = {
        id = "n002",
        name = "绿色史莱姆",
        level = 2,
        itemIds = "I00B:10%;I010:6%",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    ngna = {
        id = "ngna",
        name = "豺狼偷猎者",
        level = 3,
        itemIds = "I01O:10%;I01S:5%;I01T:5%",
        picks = 2,
        isUniversal = "TRUE",
        unitType = "normal"
    },
    ngns = {
        id = "ngns",
        name = "豺狼刺客",
        level = 3,
        itemIds = "I01O:10%;I01S:5%;I01T:5%;I00Q:6%;I01F:6%",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    nsc2 = {
        id = "nsc2",
        name = "蜘蛛螃蟹",
        level = 4,
        itemIds = "I02H:12.5%;I02K:6.25%",
        picks = 2,
        isUniversal = "TRUE",
        unitType = "normal"
    },
    n004 = {
        id = "n004",
        name = "豺狼人长矛手",
        level = 4,
        itemIds = "I01O:10%;I01S:5%;I01T:5%",
        picks = 2,
        isUniversal = "TRUE",
        unitType = "normal"
    },
    n008 = {
        id = "n008",
        name = "地精长矛战士",
        level = 5,
        itemIds = "I021:6%;I022:6%",
        picks = 2,
        isUniversal = "TRUE",
        unitType = "normal"
    },
    ngrk = {
        id = "ngrk",
        name = "泥潭傀儡",
        level = 5,
        itemIds = "I02J:5%",
        picks = 1,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    ngst = {
        id = "ngst",
        name = "岩石傀儡",
        level = 6,
        itemIds = "I02J:10%",
        picks = 1,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    nssp = {
        id = "nssp",
        name = "沙漠蜘蛛",
        level = 7,
        itemIds = "I03L:21%;I04R:15%",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    nanb = {
        id = "nanb",
        name = "阿卡那瑟德刺人",
        level = 8,
        itemIds = "I03Y:7%;I04R:7%",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    nane = {
        id = "nane",
        name = "阿卡那瑟德掘地者 ",
        level = 8,
        itemIds = "I03Y:7%;I04R:7%",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    nanw = {
        id = "nanw",
        name = "阿卡那瑟德战士",
        level = 8,
        itemIds = "I03Y:7%;I04R:7%",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    n001 = {id = "n001", name = "史莱姆", level = 10, unitType = "normal"},
    n01Z = {id = "n01Z", name = "小蛇", level = 10, unitType = "normal"},
    N00B = {
        id = "N00B",
        name = "地精剑客",
        level = 11,
        itemIds = "I02C:1.5;I01G:1;I02D:1;I02F:1;I02E:1;I02G:1",
        picks = 4,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    nbdm = {id = "nbdm", name = "蛇之盗贼", level = 11, unitType = "normal"},
    nhar = {
        id = "nhar",
        name = "女妖侦察者",
        level = 12,
        itemIds = "I04S:19%;I04Q:19%",
        picks = 2,
        isUniversal = "TRUE",
        unitType = "normal"
    },
    n01W = {
        id = "n01W",
        name = "狼人战士",
        level = 13,
        itemIds = "I04T:6%",
        picks = 1,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    nbdw = {id = "nbdw", name = "蛇之护卫", level = 14, unitType = "normal"},
    nhrw = {
        id = "nhrw",
        name = "鹰身女妖巫婆",
        level = 14,
        itemIds = "I04S:19%;I04Q:19%",
        picks = 2,
        isUniversal = "TRUE",
        unitType = "normal"
    },
    n01A = {id = "n01A", name = "水底水母", level = 15, unitType = "normal"},
    n003 = {
        id = "n003",
        name = "狼人骑士",
        level = 16,
        itemIds = "I057:6%;I04T:6%",
        picks = 1,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    n013 = {id = "n013", name = "熔岩蝎子", level = 17, unitType = "normal"},
    nsko = {
        id = "nsko",
        name = "有毒杂草",
        level = 17,
        itemIds = "I0CS:14%",
        picks = 1,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    n04G = {id = "n04G", name = "咆哮之熊", level = 18, unitType = "normal"},
    nslr = {id = "nslr", name = "蜥蜴怪物", level = 18, unitType = "normal"},
    n037 = {
        id = "n037",
        name = "恶魔犬",
        level = 19,
        itemIds = "I06A:8%;I06B:8%;I066:2%;I065:2%;I069:8%;I090:2%;I091:2%;I08Y:2%;I08Z:16%",
        picks = 7,
        isUniversal = "TRUE",
        unitType = "normal"
    },
    nsog = {id = "nsog", name = "骷髅盗贼", level = 19, unitType = "normal"},
    nhrh = {
        id = "nhrh",
        name = "女妖风暴巫师",
        level = 19,
        itemIds = "I04S:19%;I04Q:19%",
        unitType = "normal"
    },
    o001 = {
        id = "o001",
        name = "恶魔步兵",
        level = 20,
        itemIds = "I066:2%;I065:2%;I069:8%;I090:2%;I091:2%;I08Y:2%;I08Z:16%",
        picks = 7,
        isUniversal = "TRUE",
        unitType = "normal"
    },
    nsoc = {id = "nsoc", name = "骸骨战士", level = 20, unitType = "normal"},
    e05W = {id = "e05W", name = "森林妖精", level = 21, unitType = "normal"},
    n03D = {
        id = "n03D",
        name = "女猎恶魔骑士",
        level = 21,
        itemIds = "I06A:8%;I06B:8%;I066:2%;I065:2%;I069:8%;I090:2%;I091:2%;I08Y:2%;I08Z:16%",
        picks = 7,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    n03I = {
        id = "n03I",
        name = "恶魔巫师",
        level = 21,
        itemIds = "I066:2%;I065:2%;I069:8%;I090:2%;I091:2%;I08Y:2%;I08Z:16%",
        picks = 7,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    n03L = {
        id = "n03L",
        name = "恶魔战士",
        level = 22,
        itemIds = "I066:2%;I065:2%;I069:8%;I090:2%;I091:2%;I08Y:2%;I08Z:16%",
        picks = 7,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    n03M = {
        id = "n03M",
        name = "恶魔战士",
        level = 22,
        itemIds = "I066:2%;I065:2%;I069:8%;I090:2%;I091:2%;I08Y:2%;I08Z:16%",
        picks = 7,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    u001 = {
        id = "u001",
        name = "恶魔食尸鬼",
        level = 22,
        itemIds = "I064:5%;I066:2%;I065:2%;I069:8%;I090:2%;I091:2%;I08Y:2%;I08Z:16%",
        picks = 8,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    n03K = {
        id = "n03K",
        name = "恶魔地狱犬骑士",
        level = 22,
        itemIds = "I06A:8%;I06B:8%;I066:2%;I065:2%;I069:8%;I090:2%;I091:2%;I08Y:2%;I08Z:16%",
        picks = 7,
        unitType = "normal"
    },
    n027 = {id = "n027", name = "熔岩元素", level = 23, unitType = "normal"},
    n00L = {
        id = "n00L",
        name = "奥术熔灵",
        level = 24,
        itemIds = "I06J:5%",
        picks = 1,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    n00Q = {
        id = "n00Q",
        name = "熔岩地狱火",
        level = 24,
        itemIds = "I06I:5%",
        picks = 1,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    n04Y = {id = "n04Y", name = "树魔猎手", level = 24, unitType = "normal"},
    u002 = {
        id = "u002",
        name = "双翼恶魔",
        level = 24,
        itemIds = "I067:10%;I066:2%;I065:2%;I069:8%;I090:2%;I091:2%;I08Y:2%;I08Z:16%",
        picks = 7,
        isUniversal = "TRUE",
        unitType = "normal"
    },
    u003 = {
        id = "u003",
        name = "双翼恶魔",
        level = 24,
        itemIds = "I067:10%;I066:2%;I065:2%;I069:8%;I090:2%;I091:2%;I08Y:2%;I08Z:16%",
        picks = 7,
        unitType = "normal"
    },
    n00Y = {
        id = "n00Y",
        name = "火焰恶魔",
        level = 24,
        itemIds = "I068:7%;I066:2%;I065:2%;I069:8%;I090:2%;I091:2%;I08Y:2%;I08Z:16%",
        picks = 8,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    n03R = {
        id = "n03R",
        name = "火焰恶魔战士",
        level = 24,
        itemIds = "I066:2%;I065:2%;I069:8%;I090:2%;I091:2%;I08Y:2%;I08Z:16%",
        picks = 7,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    n04B = {id = "n04B", name = "血色恶魔", level = 24, unitType = "normal"},
    n041 = {
        id = "n041",
        name = "亡灵骷髅",
        level = 25,
        itemIds = "I094:8%",
        picks = 1,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    n043 = {id = "n043", name = "亡灵巫师", level = 25, unitType = "normal"},
    n04F = {id = "n04F", name = "亡灵骷髅", level = 25, unitType = "normal"},
    n00G = {
        id = "n00G",
        name = "蒙面人",
        level = 25,
        itemIds = "afac:6%",
        picks = 1,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    ners = {id = "ners", name = "恶魔男巫", level = 25, unitType = "normal"},
    h00U = {
        id = "h00U",
        name = "巨魔投掷者",
        level = 25,
        itemIds = "I0C1:5%",
        picks = 1,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    ohun = {
        id = "ohun",
        name = "巨魔猎头者",
        level = 25,
        itemIds = "I0C4:5%",
        picks = 1,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    n04K = {
        id = "n04K",
        name = "大嘴食人花",
        level = 26,
        itemIds = "I0BU:4%;I0BW:2%;I0BV:2%",
        picks = 1,
        isUniversal = "FALSE",
        unitType = "normal"
    },
    n042 = {
        id = "n042",
        name = "亡灵守卫巫师",
        level = 35,
        itemIds = "I08U:1;I08X:1;I08W:1;I08V:1",
        picks = 2,
        unitType = "normal"
    },
    n04E = {id = "n04E", name = "恶魔使魔", unitType = "normal"},
    nnwl = {id = "nnwl", name = "火焰蜘蛛", unitType = "normal"},
    nass = {id = "nass", name = "沙漠神秘刺客", unitType = "normal"},
    n01F = {
        id = "n01F",
        name = "狂暴史莱姆",
        level = 3,
        itemIds = "I00C:1;I00O:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "berserk\t"
    },
    nwld = {
        id = "nwld",
        name = "森林狼王",
        level = 3,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n049 = {
        id = "n049",
        name = "|cff00ffff水触须|r|cffff0000（头目LV4）|r",
        level = 4,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n00I = {
        id = "n00I",
        name = "神秘刺客",
        level = 4,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n01E = {
        id = "n01E",
        name = "巨型史莱姆",
        level = 5,
        itemIds = "I00C:1;I00E:1;I00D:1;I00G:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n01G = {
        id = "n01G",
        name = "奇妙鹿|cffff0000（Boss，LV7）|r",
        level = 7,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n05B = {
        id = "n05B",
        name = "豺狼首领|cffff00ff（异变LV8）|r",
        level = 10,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n05C = {
        id = "n05C",
        name = "豺狼守望者|cffff00ff（异变LV8）|r",
        level = 10,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    N00E = {
        id = "N00E",
        name = "湖中精灵",
        level = 10,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    N00F = {
        id = "N00F",
        name = "湖中精灵",
        level = 10,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n02T = {
        id = "n02T",
        name = "巨虾|cffff0000（精英，给予额外金钱）|r",
        level = 10,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n02X = {
        id = "n02X",
        name = "狂暴沙漠蜘蛛",
        level = 10,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n00A = {
        id = "n00A",
        name = "地精大哥|cffff0000（头目boss）|r",
        level = 11,
        itemIds = "I01V:1;I020:1;I01Z:1;I01Y:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n02Y = {
        id = "n02Y",
        name = "沙丘之虫",
        level = 15,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n05O = {
        id = "n05O",
        name = "|cff993366地狱犬|r-（|cff99ccff减少魔法值|r）",
        level = 15,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n05P = {
        id = "n05P",
        name = "|cff993366恶魔行者|r",
        level = 15,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    u00G = {
        id = "u00G",
        name = "|cff993366邪尸鬼|r-（|cffff0000治疗量降低|r）",
        level = 15,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    nbds = {
        id = "nbds",
        name = "蛇之看守者(精英)",
        level = 16,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    nano = {
        id = "nano",
        name = "沙漠蝎王",
        level = 17,
        itemIds = "I05E:1;I05G:1;I04W:1;I03Y:1;I04R:1",
        picks = 4,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n00Z = {
        id = "n00Z",
        name = "火焰狼蛛",
        level = 17,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n04J = {
        id = "n04J",
        name = "食人花",
        level = 18,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n005 = {
        id = "n005",
        name = "狼人魔法师",
        level = 20,
        itemIds = "I051:1;I050:1;I052:1;I054:0.8;I056:0.5",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    nanc = {
        id = "nanc",
        name = "|cff99cc00变异蝎子|r|cffff0000（头目LV20）|r",
        level = 20,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n04T = {
        id = "n04T",
        name = "战斗者暴斯",
        level = 20,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n02R = {
        id = "n02R",
        name = "两栖鱼人|cffff0000（精英，给予额外经验）|r",
        level = 20,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n034 = {
        id = "n034",
        name = "狂暴火焰狼蛛",
        level = 20,
        itemIds = "I05V:1;I05W:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "berserk\t"
    },
    n035 = {
        id = "n035",
        name = "狂暴熔岩蝎子",
        level = 20,
        itemIds = "I05V:1;I05W:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "berserk\t"
    },
    n02S = {
        id = "n02S",
        name = "|cff00ccff湖底元素|r|cffff0000(头目)LV22|r",
        level = 22,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n02U = {
        id = "n02U",
        name = "|cff00ffff龙虾守卫|r|cffff0000（挑战Boss）LV22|r",
        level = 22,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n04H = {
        id = "n04H",
        name = "狂啸熊王",
        level = 23,
        itemIds = "I0BR:1;I0BQ:1;I0BS:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n026 = {
        id = "n026",
        name = "火焰九头蛇",
        level = 25,
        itemIds = "I05P:1;I05Q:1;I060:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n02F = {
        id = "n02F",
        name = "沙漠幽灵|cffff0000（Boss）LV25|r",
        level = 25,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n02V = {
        id = "n02V",
        name = "蜘蛛女皇|cffff0000（BossLV25）|r",
        level = 25,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n032 = {
        id = "n032",
        name = "蒙面人小队长",
        level = 25,
        itemIds = "I0B7:1;I00R:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    ucs2 = {
        id = "ucs2",
        name = "沙漠母虫护卫",
        level = 25,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n021 = {
        id = "n021",
        name = "蛇人死灵",
        level = 25,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n04L = {
        id = "n04L",
        name = "远古食人花",
        level = 26,
        itemIds = "I0C0:1;I0BZ:1;I0BX:0.3;I0BY:0.3",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n00M = {
        id = "n00M",
        name = "暗影之灵(Boss)",
        level = 27,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n02Q = {
        id = "n02Q",
        name = "|cffffcc99沙漠蜥蜴（变异）|r|cffff0000BossLV29|r",
        level = 29,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    edry = {
        id = "edry",
        name = "森林妖精",
        level = 29,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n04X = {
        id = "n04X",
        name = "树魔狂战士",
        level = 29,
        itemIds = "I0C2:1;I0C6:1;I0C8:1;I0C9:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n00K = {
        id = "n00K",
        name = "黑暗魔法女王",
        level = 30,
        itemIds = "I075:1;I07O:1;I07A:1;I07K:1;I074:1;I072:1;I071:0.5",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n01R = {
        id = "n01R",
        name = "蒙面人队长",
        level = 30,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n038 = {
        id = "n038",
        name = "地狱犬（精英)",
        level = 30,
        itemIds = "I06C:1;I06D:1;I06G:1;I06F:1;I06E:1;I09H:1;I09B:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n03E = {
        id = "n03E",
        name = "苦难女王",
        level = 30,
        itemIds = "I07I:1;I07G:1;I07J:1;I07H:1;I07K:1;I072:1;I071:0.5",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    nbdo = {
        id = "nbdo",
        name = "蛇之领主-奢恩|cffff0000（BossLV30）|r",
        level = 30,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n00W = {
        id = "n00W",
        name = "超级地狱火",
        level = 30,
        itemIds = "I06N:1;I06P:1;I06M:1;I06O:1;I09H:0.4;I09B:0.4",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n03H = {
        id = "n03H",
        name = "熔岩恶魔护卫",
        level = 30,
        itemIds = "I08C:1;I089:1;I08A:1;I085:0.25",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n03J = {
        id = "n03J",
        name = "恶魔邪恶巫师（精英）",
        level = 30,
        itemIds = "I079:1;I07B:1;I07A:1;I077:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n03T = {
        id = "n03T",
        name = "熔岩元素（精英）",
        level = 30,
        itemIds = "I06Q:1;I06W:1;I06V:1;I06U:1;I09H:1;I09B:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n011 = {
        id = "n011",
        name = "水龙蛇|cffff0000（BossLV33）|r",
        level = 33,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n03N = {
        id = "n03N",
        name = "恶魔队长",
        level = 35,
        itemIds = "I07S:1;I07R:1;I08J:1;I07U:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n044 = {
        id = "n044",
        name = "亡灵高级巫师（精英）",
        level = 35,
        itemIds = "I098:1;I08S:1;I096:1;I097:1;I08T:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    u004 = {
        id = "u004",
        name = "双翼究极恶魔（精英）",
        level = 35,
        itemIds = "I08G:1;I08H:1;I08H:1;I09B:0.5",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n03F = {
        id = "n03F",
        name = "熔岩恶魔",
        level = 35,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    nubk = {
        id = "nubk",
        name = "无敌黑暗猎人（精英）",
        level = 35,
        itemIds = "I08P:1;I08L:1;I08K:1;I08M:1;I08N:1;I08O:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    o000 = {
        id = "o000",
        name = "|cffffcc99蛇之遗迹看守者-奢隆|r|cffff0000（BossLV37）|r",
        level = 37,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    n03S = {
        id = "n03S",
        name = "恶魔看守者|cffff0000（Boss，无等级限制）|r",
        level = 38,
        itemIds = "I07V:1;I07X:1;I07W:1;I085:0.5",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "Boss"
    },
    n033 = {
        id = "n033",
        name = "泽图（挑战boss）",
        level = 40,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    h00E = {id = "h00E", name = "火凤凰", isUniversal = "FALSE", unitType = "elite"},
    n04V = {id = "n04V", name = "沙漠刺客", isUniversal = "FALSE", unitType = "elite"},
    n05E = {id = "n05E", name = "元素灵体", isUniversal = "FALSE", unitType = "elite"},
    n05F = {id = "n05F", name = "元素史莱姆", isUniversal = "FALSE", unitType = "elite"},
    n051 = {id = "n051", name = "穆戈尔切割者", isUniversal = "FALSE", unitType = "elite"},
    n052 = {id = "n052", name = "远古遗迹精灵（变异）", isUniversal = "FALSE", unitType = "elite"},
    n053 = {id = "n053", name = "变异精灵", isUniversal = "FALSE", unitType = "elite"},
    n054 = {id = "n054", name = "穆戈尔钩手", isUniversal = "FALSE", unitType = "elite"},
    n055 = {id = "n055", name = "远古遗迹精灵（巨化）", isUniversal = "FALSE", unitType = "elite"},
    n056 = {id = "n056", name = "穆戈尔精英", isUniversal = "FALSE", unitType = "elite"},
    h00Y = {id = "h00Y", name = "穆戈尔投掷者", isUniversal = "FALSE", unitType = "elite"},
    n01V = {
        id = "n01V",
        name = "狼人首领",
        level = 20,
        itemIds = "I056:1;I05B:1;I002:1;I054:0.8;I056:0.5",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    nsbm = {
        id = "nsbm",
        name = "血浴之母",
        level = 16,
        itemIds = "I04W:1;I03Q:1;I03P:1;I03R:1;I03T:1;I03S:1;I03U:1;I03O:1;I03N:1;I03M:1",
        picks = 3,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    nsc3 = {
        id = "nsc3",
        name = "蜘蛛螃蟹巨兽",
        level = 11,
        itemIds = "I02P:1;I02N:1;I02I:1;I02K:1;I02O:0.3",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    nggr = {
        id = "nggr",
        name = "花岗岩傀儡",
        level = 15,
        itemIds = "I02S:1;I02R:1;I02T:1;I02J:1;I02Q:0.3",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    ngnv = {
        id = "ngnv",
        name = "豺狼首领",
        level = 10,
        itemIds = "I01C:1;I01U:1;I01R:1;I01Q:1;I01T:1;I01S:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    ngnw = {
        id = "ngnw",
        name = "豺狼守望者",
        level = 10,
        itemIds = "I01E:1;I01D:1;I01K:1;I01U:1;I01T:1;I01S:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    nhrq = {
        id = "nhrq",
        name = "女妖女皇",
        level = 20,
        itemIds = "I05C:1;I05D:1;I053:0.5;I04Q:1;I04S:1;",
        picks = 4,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    nsll = {
        id = "nsll",
        name = "蜥蜴领主",
        level = 26,
        itemIds = "I061:1;I062:1;I063:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    nerw = {
        id = "nerw",
        name = "埃瑞达法师",
        level = 35,
        itemIds = "I07L:1;I07C:1;I07Q:1;I07N:1;I07P:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    N03A = {
        id = "N03A",
        name = "恶魔使者",
        level = 35,
        itemIds = "I081:1;I084:1;I083:1;I080:1;I082:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    N039 = {
        id = "N039",
        name = "恶魔大统领",
        level = 35,
        itemIds = "I087:1;I088:1;I08O:1;I086:1;I08O:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "elite"
    },
    N03B = {
        id = "N03B",
        name = "熔岩恶魔",
        level = 35,
        itemIds = "I06H:1;I06R:1;I06S:1;I085:0.25",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "Boss"
    },
    O002 = {
        id = "O002",
        name = "黑暗恶魔军官",
        level = 37,
        itemIds = "I07F:1;I07E:1;I07D:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "Boss"
    },
    N03G = {
        id = "N03G",
        name = "熔岩恶魔王",
        level = 40,
        itemIds = "I08E:1;I08F:1;I08D:1;I085:0.25;I08B:always",
        picks = 3,
        isUniversal = "FALSE",
        unitType = "Boss"
    },
    N045 = {
        id = "N045",
        name = "幽冥巫师",
        level = 40,
        itemIds = "I095:1;I08Q:1;I08R:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "Boss"
    },
    N03O = {
        id = "N03O",
        name = "恶魔领袖|cffff0000（Boss）LV45|r",
        level = 45,
        itemIds = "I07Z:1;I07Y:1;I07T:1",
        picks = 2,
        isUniversal = "FALSE",
        unitType = "Boss"
    }
}
____exports.default = ____exports["装备掉落表"]
return ____exports]=]

P['系统/装备/装备排泄.lua'] = [=[--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local registerItemForCleanup, jass
function registerItemForCleanup(item)
    if item == nil then
        return
    end
    if type(jass.CreateTrigger) ~= "function" then
        return
    end
    local trig = jass.CreateTrigger()
    if not trig then
        return
    end
    if type(jass.TriggerRegisterDeathEvent) ~= "function" then
        return
    end
    jass.TriggerRegisterDeathEvent(trig, item)
    local capturedItem = item
    local taHandle = nil
    local function onDeath()
        if type(jass.RemoveItem) == "function" then
            jass.RemoveItem(capturedItem)
        end
        if taHandle ~= nil and type(jass.TriggerRemoveAction) == "function" then
            jass.TriggerRemoveAction(trig, taHandle)
        end
        if type(jass.DestroyTrigger) == "function" then
            jass.DestroyTrigger(trig)
        end
    end
    if type(jass.TriggerAddAction) == "function" then
        taHandle = jass.TriggerAddAction(trig, onDeath)
    end
end
jass = require("jass.common")
local _lastCreatedItem = nil
--- 模拟 JASS GetLastCreatedItem —— 返回最近一次通过 setLastCreatedItem 登记的物品。
function ____exports.GetLastCreatedItem(self)
    return _lastCreatedItem
end
--- 在 CreateItemLoc/CreateItem 后立刻调用，自动：
--   1. 记录为 lastCreatedItem
--   2. 注册死亡清理（RemoveItem + DestroyTrigger）
function ____exports.setLastCreatedItem(self, item)
    _lastCreatedItem = item
    registerItemForCleanup(item)
end
return ____exports]=]

P['系统/装备/装备提取.lua'] = [[local ____lualib = require("lualib_bundle")
local __TS__ObjectKeys = ____lualib.__TS__ObjectKeys
local __TS__Number = ____lualib.__TS__Number
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local ____exports = {}
local jass = require("jass.common")
local g = require("jass.globals")
local mod = require("系统.装备.装备数据")
local itemsData = mod.items or mod.default or ({})
local _seedCnt = 0
local DEBUG = false
local ITEM_TRIGGER = "tret"
local function stringToFourCC(self, s)
    local b1 = string.byte(s, 1)
    local b2 = string.byte(s, 2)
    local b3 = string.byte(s, 3)
    local b4 = string.byte(s, 4)
    return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4
end
local function getItemsByScoreRange(self, minScore, maxScore)
    local min = minScore or 0
    local max = maxScore or 0
    local result = {}
    for ____, id in ipairs(__TS__ObjectKeys(itemsData)) do
        do
            local __continue4
            repeat
                if type(id) ~= "string" or #id ~= 4 then
                    __continue4 = true
                    break
                end
                local entry = itemsData[id]
                if not entry then
                    __continue4 = true
                    break
                end
                local score = entry.score
                if score ~= nil and score >= min and score <= max then
                    result[#result + 1] = id
                end
                __continue4 = true
            until true
            if not __continue4 then
                break
            end
        end
    end
    return result
end
local function EquipExtract_CreateByLevel(self)
    local ____this_1
    ____this_1 = _G
    local ____opt_0 = ____this_1.print
    if ____opt_0 ~= nil then
        _G.print("[装备提取] EquipExtract_CreateByLevel 被调用")
    end
    jass.DisplayTimedTextToPlayer(
        jass.Player(0),
        0,
        0,
        10,
        "[装备提取] 执行中"
    )
    _seedCnt = _seedCnt + 1
    math.randomseed(_seedCnt)
    local ____opt_2 = jass.YDLocal1Get
    local inputMin = ____opt_2 and ____opt_2(jass, "integer", "EquipExtract_MinScore")
    local ____opt_4 = jass.YDLocal1Get
    local inputMax = ____opt_4 and ____opt_4(jass, "integer", "EquipExtract_MaxScore")
    local minS = type(inputMin) == "number" and inputMin or (__TS__Number(g.udg_TempScoreMin) or 0)
    local maxS = type(inputMax) == "number" and inputMax or (__TS__Number(g.udg_TempScoreMax) or 0)
    if minS <= 0 and maxS <= 0 then
        minS = 200
        maxS = 250
    end
    local candidates = getItemsByScoreRange(nil, minS, maxS)
    local ____this_7
    ____this_7 = jass
    local ____opt_6 = ____this_7.STES_GetTriggerPlayer
    if ____opt_6 ~= nil then
        ____opt_6 = ____opt_6(____this_7)
    end
    local ____opt_6_10 = ____opt_6
    if ____opt_6_10 == nil then
        local ____opt_8 = jass.GetTriggerPlayer
        ____opt_6_10 = ____opt_8 and ____opt_8(jass)
    end
    local ____opt_6_10_11 = ____opt_6_10
    if ____opt_6_10_11 == nil then
        ____opt_6_10_11 = jass.Player(0)
    end
    local player = ____opt_6_10_11
    if #candidates == 0 then
        g.udg_TempItemType = 0
        if DEBUG then
            jass.DisplayTimedTextToPlayer(
                player,
                0,
                0,
                8,
                (("TempItemType=0 无候选 min=" .. tostring(minS)) .. " max=") .. tostring(maxS)
            )
        end
        return
    end
    local arr = __TS__ArraySlice(candidates)
    do
        local i = #arr - 1
        while i > 0 do
            local j = math.floor(math.random() * (i + 1))
            local ____temp_12 = {arr[j + 1], arr[i + 1]}
            arr[i + 1] = ____temp_12[1]
            arr[j + 1] = ____temp_12[2]
            i = i - 1
        end
    end
    local itemId = arr[1]
    g.udg_TempItemType = type(itemId) == "string" and #itemId == 4 and stringToFourCC(nil, itemId) or 0
    local ____this_14
    ____this_14 = _G
    local ____opt_13 = ____this_14.print
    if ____opt_13 ~= nil then
        ____opt_13(
            ____this_14,
            (("TempItemType=" .. tostring(g.udg_TempItemType)) .. " itemId=") .. itemId
        )
    end
    if DEBUG then
        jass.DisplayTimedTextToPlayer(
            jass.Player(0),
            0,
            0,
            10,
            (("TempItemType=" .. tostring(g.udg_TempItemType)) .. " itemId=") .. itemId
        )
    end
end
local function dbg(self, msg)
    if DEBUG then
        jass.DisplayTimedTextToPlayer(
            jass.Player(0),
            0,
            0,
            10,
            "[装备提取] " .. msg
        )
    end
end
local function onTrigger(self)
    local evt = jass.GetTriggerEventId()
    local ____opt_15 = jass.GetTriggerPlayer
    local ____temp_17 = ____opt_15 and ____opt_15(jass)
    if ____temp_17 == nil then
        ____temp_17 = jass.Player(0)
    end
    local player = ____temp_17
    if evt == jass.EVENT_PLAYER_UNIT_PICKUP_ITEM then
        local item = jass.GetManipulatedItem()
        local tid = jass.GetItemTypeId(item)
        if tid ~= stringToFourCC(nil, ITEM_TRIGGER) then
            return
        end
        if DEBUG then
            jass.DisplayTimedTextToPlayer(
                player,
                0,
                0,
                8,
                "物品ID正确"
            )
        end
    end
    EquipExtract_CreateByLevel(nil)
end
local function init(self)
    _G.EquipExtract_CreateByLevel = EquipExtract_CreateByLevel
    local trig = jass.CreateTrigger()
    do
        local i = 0
        while i < 4 do
            jass.TriggerRegisterPlayerUnitEvent(
                trig,
                jass.Player(i),
                jass.EVENT_PLAYER_UNIT_PICKUP_ITEM,
                nil
            )
            i = i + 1
        end
    end
    jass.TriggerAddAction(trig, onTrigger)
    local evtTrig = jass.CreateTrigger()
    jass.TriggerAddAction(
        evtTrig,
        function() return EquipExtract_CreateByLevel(nil) end
    )
    local ____jass_STES_Register_18 = jass.STES_Register
    if ____jass_STES_Register_18 == nil then
        ____jass_STES_Register_18 = g.STES_Register
    end
    local ____jass_STES_Register_18_19 = ____jass_STES_Register_18
    if ____jass_STES_Register_18_19 == nil then
        ____jass_STES_Register_18_19 = _G.STES_Register
    end
    local STES_Reg = ____jass_STES_Register_18_19
    if type(STES_Reg) == "function" then
        STES_Reg(evtTrig, "提取物品事件")
        dbg(nil, "已通过 STES_Register 注册事件 提取物品事件")
    else
        g.udg_RegTrigger = evtTrig
        g.udg_RegEventStr = "提取物品事件"
        jass.ExecuteFunc("Bridge_STES_Register")
    end
end
init(nil)
____exports.EquipExtract_CreateByLevel = EquipExtract_CreateByLevel
return ____exports]]

P['系统/装备/装备数据.lua'] = [=[--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports.items = {}
____exports.items.I00V = {
    type = "主武器",
    name = "精灵铁剑",
    goldPrice = 100,
    score = 216,
    level = "E-",
    dmg = 8
}
____exports.items.I00E = {
    type = "道具/戒指/饰品",
    name = "生命树枝",
    goldPrice = 100,
    score = 220,
    level = "E-",
    hp = 200,
    hpRegen = 1
}
____exports.items.I00T = {
    type = "主武器",
    name = "小法杖",
    goldPrice = 100,
    score = 222,
    level = "E-",
    dmg = 6,
    int = 1
}
____exports.items.I00S = {
    type = "道具/戒指/饰品",
    name = "恢复指环",
    goldPrice = 50,
    score = 250,
    level = "E-",
    hp = 50
}
____exports.items.I00P = {
    type = "道具/戒指/饰品",
    name = "树枝",
    goldPrice = 100,
    score = 295,
    level = "E-",
    dmg = 2,
    all = 2
}
____exports.items.I01K = {
    type = "道具/戒指/饰品",
    name = "初心戒指",
    goldPrice = 240,
    score = 392,
    level = "E-",
    int = 5,
    hp = 50,
    hpRegen = 2
}
____exports.items.I06X = {
    type = "道具/戒指/饰品",
    name = "初始魔法药水",
    goldPrice = 50,
    score = 400,
    level = "E",
    hot = "100mp",
    abilList = "A08C"
}
____exports.items.I06Y = {
    type = "道具/戒指/饰品",
    name = "初始生命药水",
    goldPrice = 50,
    score = 400,
    level = "E",
    hot = "200hp",
    abilList = "A08C"
}
____exports.items.I00D = {
    type = "道具/戒指/饰品",
    name = "魔力树枝",
    goldPrice = 100,
    score = 414,
    level = "E-",
    int = 5,
    mp = 150,
    mpRegen = 0.5
}
____exports.items.I027 = {
    type = "副武器",
    name = "小盾牌",
    goldPrice = 250,
    score = 417,
    level = "E",
    armor = 3,
    hp = 100
}
____exports.items.I01X = {
    type = "头盔",
    name = "地精防炸帽",
    goldPrice = 100,
    score = 425,
    level = "E",
    magicResist = 0.2,
    armor = 5
}
____exports.items.I00C = {
    type = "道具/戒指/饰品",
    name = "树枝骨干",
    goldPrice = 200,
    score = 481,
    level = "E",
    all = 4
}
____exports.items.I0CN = {
    type = "道具/戒指/饰品",
    name = "异端审查证",
    goldPrice = 1000,
    score = 489,
    level = "E-",
    hp = 200,
    accuracy = 0.1,
    stunResist = 0.2
}
____exports.items.I070 = {
    type = "道具/戒指/饰品",
    name = "元素能量碎片（水）",
    goldPrice = 240,
    score = 544,
    level = "E+",
    magicDmg = 0.3,
    abilList = "A0LH"
}
____exports.items.I00O = {
    type = "道具/戒指/饰品",
    name = "狂暴树枝",
    goldPrice = 200,
    score = 551,
    level = "E+",
    dmg = 15,
    abilList = "A03J"
}
____exports.items.I01T = {
    type = "头盔",
    name = "狼皮帽",
    goldPrice = 200,
    score = 570,
    level = "E+",
    dmg = 10,
    hp = 100
}
____exports.items.I00U = {
    type = "鞋子",
    name = "速度之靴",
    goldPrice = 100,
    score = 585,
    level = "E++",
    movespeed2 = 60
}
____exports.items.I00K = {
    type = "道具/戒指/饰品",
    name = "树枝骨干+1",
    goldPrice = 300,
    score = 675,
    level = "E+",
    dmg = 4,
    all = 4
}
____exports.items.I022 = {
    type = "主武器",
    name = "地精长矛",
    goldPrice = 100,
    score = 710,
    level = "E+",
    dmg = 20,
    armorPierce = 0.2
}
____exports.items.I00I = {
    type = "道具/戒指/饰品",
    name = "生机树枝",
    goldPrice = 100,
    score = 750,
    level = "E++",
    hp = 450,
    hpRegen = 2,
    mp = 300,
    mpRegen = 2
}
____exports.items.I01D = {
    type = "道具/戒指/饰品",
    name = "守望者护符",
    goldPrice = 250,
    score = 752,
    level = "E++",
    dmg = 6,
    mp = 300,
    magicDmg = 0.05,
    abilList = "A02D"
}
____exports.items.I00X = {
    type = "道具/戒指/饰品",
    name = "医疗剂（小）",
    goldPrice = 100,
    score = 800,
    level = "E++",
    hot = "400hp",
    abilList = "A08C"
}
____exports.items.I010 = {
    type = "道具/戒指/饰品",
    name = "魔法药水（小）",
    goldPrice = 100,
    score = 800,
    level = "E++",
    hot = "200mp",
    abilList = "A08C"
}
____exports.items.I021 = {
    type = "道具/戒指/饰品",
    name = "地精肩甲",
    goldPrice = 100,
    score = 809,
    level = "E++",
    hp = 100,
    physResist = 0.1
}
____exports.items.I01E = {
    type = "主武器",
    name = "魔力雷锤",
    goldPrice = 100,
    score = 827,
    level = "E++",
    dmg = 10,
    magicDmg = 0.1
}
____exports.items.I01F = {
    type = "鞋子",
    name = "森林之靴",
    goldPrice = 100,
    score = 839,
    level = "E++",
    hpRegen = 5,
    mpRegen = 1.5,
    movespeed2 = 75
}
____exports.items.I01Y = {
    type = "裤子",
    name = "草裤",
    goldPrice = 200,
    score = 840,
    level = "E++",
    armor = 5,
    hp = 450,
    hpRegen = 10
}
____exports.items.I00L = {
    type = "道具/戒指/饰品",
    name = "树枝骨干+2",
    goldPrice = 400,
    score = 875,
    level = "E++",
    dmg = 6,
    all = 6
}
____exports.items.I00M = {
    type = "道具/戒指/饰品",
    name = "树枝骨干+3",
    goldPrice = 500,
    score = 937,
    level = "E++",
    dmg = 8,
    all = 6
}
____exports.items.I01U = {
    type = "衣服",
    name = "豺狼皮甲",
    goldPrice = 500,
    score = 1002,
    level = "D-",
    armor = 10,
    hp = 300
}
____exports.items.I03O = {
    type = "道具/戒指/饰品",
    name = "血浴之母的第一条右腿",
    goldPrice = 1000,
    score = 1031,
    level = "D-",
    dmg = 30
}
____exports.items.I03Q = {
    type = "道具/戒指/饰品",
    name = "血浴之母的第二条右腿",
    goldPrice = 100,
    score = 1031,
    level = "D-",
    hp = 800
}
____exports.items.I03P = {
    type = "道具/戒指/饰品",
    name = "血浴之母的第二条左腿",
    goldPrice = 100,
    score = 1033,
    level = "D-",
    hp = 800
}
____exports.items.I020 = {
    type = "衣服",
    name = "地精大衣",
    goldPrice = 200,
    score = 1040,
    level = "D-",
    str = 8,
    hp = 450
}
____exports.items.I00Q = {
    type = "副武器",
    name = "袖箭",
    goldPrice = 200,
    score = 1053,
    level = "D-",
    agi = 15
}
____exports.items.I01Z = {
    type = "衣服",
    name = "地精战衣",
    goldPrice = 500,
    score = 1072,
    level = "D-",
    dmg = 15,
    armor = 3,
    hp = 500
}
____exports.items.I02N = {
    type = "副武器",
    name = "蟹钳",
    goldPrice = 100,
    score = 1080,
    level = "D-",
    dmg = 25,
    abilList = "A04B"
}
____exports.items.I03N = {
    type = "道具/戒指/饰品",
    name = "血浴之母的第一条左腿",
    goldPrice = 100,
    score = 1080,
    level = "D-",
    dmg = 30
}
____exports.items.I04Y = {
    type = "道具/戒指/饰品",
    name = "毒囊道具",
    goldPrice = 350,
    score = 1120,
    level = "D-",
    dmg = 15,
    magicResist = 0.1,
    hp = 450
}
____exports.items.I01S = {
    type = "鞋子",
    name = "狼皮之鞋",
    goldPrice = 100,
    score = 1124,
    level = "D-",
    armor = 5,
    hp = 100,
    hpRegen = 5,
    movespeed2 = 75
}
____exports.items.I00H = {
    type = "主武器",
    name = "树枝法杖（主武器）",
    goldPrice = 250,
    score = 1157,
    level = "D-",
    int = 15,
    mp = 300,
    mpRegen = 2
}
____exports.items.I01C = {
    type = "主武器",
    name = "首领大锤",
    goldPrice = 100,
    score = 1157,
    level = "D-",
    dmg = 25,
    str = 8
}
____exports.items.I02D = {
    type = "衣服",
    name = "毛绒风衣",
    goldPrice = 500,
    score = 1168,
    level = "D-",
    agi = 10,
    armor = 5,
    hp = 500
}
____exports.items.I03U = {
    type = "道具/戒指/饰品",
    name = "血浴之母的第四条左腿",
    goldPrice = 100,
    score = 1181,
    level = "D-"
}
____exports.items.I03R = {
    type = "道具/戒指/饰品",
    name = "血浴之母的第三条右腿",
    goldPrice = 100,
    score = 1203,
    level = "D-",
    all = 10
}
____exports.items.I02G = {
    type = "裤子",
    name = "皮裤",
    goldPrice = 100,
    score = 1210,
    level = "D-",
    agi = 15,
    hp = 500
}
____exports.items.I02C = {
    type = "主武器",
    name = "地精大剑",
    goldPrice = 100,
    score = 1231,
    level = "D-",
    dmg = 35,
    critRate = 0.25
}
____exports.items.I02B = {
    type = "副武器",
    name = "精致木盾",
    goldPrice = 500,
    score = 1241,
    level = "D-",
    armor = 5,
    hp = 500
}
____exports.items.I0CV = {
    type = "道具/戒指/饰品",
    name = "史莱姆抗链",
    goldPrice = 700,
    score = 1244,
    level = "D-",
    critRate = -0.2,
    magicResist = 0.1,
    armor = 5,
    hp = 450,
    hpRegen = 20,
    critRateTaken = -0.2
}
____exports.items.I02E = {
    type = "道具/戒指/饰品",
    name = "皮手套",
    goldPrice = 100,
    score = 1253,
    level = "D-",
    dmg = 6,
    hp = 450,
    hpRegen = 5
}
____exports.items.I03T = {
    type = "道具/戒指/饰品",
    name = "血浴之母的第三条左腿",
    goldPrice = 100,
    score = 1299,
    level = "D-",
    hpRegen = 40,
    mp = 300,
    mpRegen = 5
}
____exports.items.I00J = {
    type = "道具/戒指/饰品",
    name = "史莱姆粘液瓶",
    goldPrice = 600,
    score = 1300,
    level = "D-",
    armor = 5,
    abilList = "A03I"
}
____exports.items.I01G = {
    type = "鞋子",
    name = "剑客鞋",
    goldPrice = 150,
    score = 1349,
    level = "D-",
    dmg = 15,
    armor = 3,
    hp = 500,
    abilList = "A03A"
}
____exports.items.I044 = {
    type = "主武器",
    name = "指挥之剑",
    goldPrice = 5000,
    score = 1365,
    level = "C-",
    dmg = 100,
    abilList = "A06C,A06D"
}
____exports.items.I00F = {
    type = "主武器",
    name = "树枝剑（主武器）",
    goldPrice = 250,
    score = 1367,
    level = "D-",
    dmg = 15,
    all = 8
}
____exports.items.I02R = {
    type = "主武器",
    name = "傀岩杖",
    goldPrice = 200,
    score = 1373,
    level = "D-",
    dmg = 25,
    mp = 300
}
____exports.items.I01Q = {
    type = "鞋子",
    name = "豺狼王靴",
    goldPrice = 200,
    score = 1376,
    level = "D-",
    dmg = 6,
    str = 8,
    movespeed2 = 75
}
____exports.items.I01R = {
    type = "道具/戒指/饰品",
    name = "首领号角",
    goldPrice = 250,
    score = 1377,
    level = "D-",
    abilList = "A03S,A03R"
}
____exports.items.I00N = {
    type = "道具/戒指/饰品",
    name = "树枝骨干MAX",
    goldPrice = 600,
    score = 1413,
    level = "D-",
    dmg = 10,
    all = 8,
    PowerUP = "10all;time3",
    abilList = "A03H"
}
____exports.items.I0CU = {
    type = "道具/戒指/饰品",
    name = "史莱姆瓶",
    goldPrice = 700,
    score = 1423,
    level = "D-",
    armor = 5,
    hp = 300,
    accuracy = 0.2,
    woodDmg = 0.12,
    dmgReduction = 35
}
____exports.items.I025 = {
    type = "主武器",
    name = "铁矛",
    goldPrice = 100,
    score = 1433,
    level = "D-",
    dmg = 35,
    armorPierce = 0.5
}
____exports.items.I05G = {
    type = "道具/戒指/饰品",
    name = "蝎王腰带",
    goldPrice = 600,
    score = 1434,
    level = "D-",
    dmg = 20,
    hp = 150,
    hpRegen = 15,
    abilList = "A075"
}
____exports.items.I02S = {
    type = "鞋子",
    name = "山地跑鞋",
    goldPrice = 100,
    score = 1441,
    level = "D",
    armor = 8,
    hp = 300,
    hpRegen = 5,
    movespeed2 = 75
}
____exports.items.I01H = {
    type = "主武器",
    name = "祭祀之杖",
    goldPrice = 1000,
    score = 1450,
    level = "D",
    dmg = 25,
    magicDmg = 0.2,
    abilList = "A03G"
}
____exports.items.I01J = {
    type = "头盔",
    name = "|cff993366祭祀面具（唯一）|r",
    goldPrice = 5000,
    score = 1450,
    level = "D",
    int = 25
}
____exports.items.I01V = {
    type = "鞋子",
    name = "草鞋",
    goldPrice = 250,
    score = 1450,
    level = "D",
    mpRegen = 5,
    cdReduction = 0.2,
    movespeed2 = 75
}
____exports.items.I02F = {
    type = "头盔",
    name = "皮风帽",
    goldPrice = 100,
    score = 1452,
    level = "D-",
    dmg = 4,
    armor = 10,
    hp = 450
}
____exports.items.I05E = {
    type = "副武器",
    name = "蝎王双钳",
    goldPrice = 200,
    score = 1459,
    level = "D",
    dmg = 20,
    str = 5,
    armor = 3,
    hp = 300
}
____exports.items.I02T = {
    type = "衣服",
    name = "岩石大衣",
    goldPrice = 400,
    score = 1478,
    level = "D",
    armor = 10,
    hp = 600,
    hpRegen = 25
}
____exports.items.I02L = {
    type = "道具/戒指/饰品",
    name = "蟹壳护肩",
    goldPrice = 200,
    score = 1480,
    level = "D-",
    armor = 20
}
____exports.items.I03S = {
    type = "道具/戒指/饰品",
    name = "血浴之母的第四条右腿",
    goldPrice = 100,
    score = 1497,
    level = "D-",
    agi = 15
}
____exports.items.I09N = {
    type = "道具/戒指/饰品",
    name = "初级地精勋章",
    goldPrice = 1000,
    score = 1565,
    level = "D",
    int = 12,
    expGainRate = 0.2
}
____exports.items.I03K = {
    type = "头盔",
    name = "灵巧头巾",
    goldPrice = 1850,
    score = 1588,
    level = "D",
    dmg = 15,
    critDmg = 0.25,
    atkSpeed = 0.25,
    hp = 300,
    critDmgTaken = -0.4
}
____exports.items.I02P = {
    type = "鞋子",
    name = "斯鞋",
    goldPrice = 100,
    score = 1590,
    level = "D",
    magicResist = 0.15,
    hp = 500,
    mp = 300,
    movespeed2 = 80
}
____exports.items.I03E = {
    type = "道具/戒指/饰品",
    name = "银魔手套|cffcc99ff（唯一）|r",
    goldPrice = 5000,
    score = 1597,
    level = "D",
    magicDmg = 0.2
}
____exports.items.I03J = {
    type = "鞋子",
    name = "沙漠之靴",
    goldPrice = 500,
    score = 1600,
    level = "D",
    armor = 8,
    hp = 450,
    movespeed2 = 75
}
____exports.items.I0CZ = {
    type = "鞋子",
    name = "沙漠之靴",
    goldPrice = 800,
    score = 1600,
    level = "D",
    armor = 8,
    hp = 450,
    movespeed2 = 75
}
____exports.items.I03C = {
    type = "主武器",
    name = "黑牧杖|cffffff00（唯一）|r",
    goldPrice = 3500,
    score = 1605,
    level = "D",
    dmg = 30,
    mp = 300
}
____exports.items.I057 = {
    type = "主武器",
    name = "狼人大刀",
    goldPrice = 1000,
    score = 1620,
    level = "D",
    dmg = 60
}
____exports.items.I09V = {
    type = "道具/戒指/饰品",
    name = "防御蜘蛛项链",
    goldPrice = 1000,
    score = 1630,
    level = "D",
    hp = 600
}
____exports.items.I09S = {
    type = "道具/戒指/饰品",
    name = "金光戒指",
    goldPrice = 5000,
    score = 1640,
    level = "D",
    hpRegen = 75,
    mpRegen = 10
}
____exports.items.I02U = {
    type = "灵魂",
    name = "沙漠蜥蜴之魂",
    goldPrice = 1000,
    score = 1643,
    level = "D",
    dmg = 40
}
____exports.items.I03F = {
    type = "主武器",
    name = "战士铁斧",
    goldPrice = 2500,
    score = 1669,
    level = "D-",
    dmg = 35,
    str = 12
}
____exports.items.I02O = {
    type = "主武器",
    name = "钳枪",
    goldPrice = 100,
    score = 1675,
    level = "D",
    dmg = 25,
    armorPierce = 0.25,
    abilList = "A04C"
}
____exports.items.I03D = {
    type = "副武器",
    name = "小颅盾（唯一）",
    goldPrice = 3000,
    score = 1692,
    level = "D",
    armor = 8,
    hp = 600
}
____exports.items.I0AK = {
    type = "道具/戒指/饰品",
    name = "炽热蜘蛛项链",
    goldPrice = 1000,
    score = 1712,
    level = "D",
    dmg = 50
}
____exports.items.I03H = {
    type = "衣服",
    name = "战士风衣",
    goldPrice = 2500,
    score = 1824,
    level = "D+",
    dmg = 25,
    hp = 450,
    abilList = "A03A"
}
____exports.items.I026 = {
    type = "主武器",
    name = "火药弓",
    goldPrice = 1250,
    score = 1826,
    level = "D+",
    dmg = 50
}
____exports.items.I03G = {
    type = "衣服",
    name = "战士大衣",
    goldPrice = 2500,
    score = 1850,
    level = "D+",
    dmg = 30,
    hp = 500
}
____exports.items.I04X = {
    type = "衣服",
    name = "蝎甲",
    goldPrice = 500,
    score = 1889,
    level = "D+",
    armor = 15,
    hp = 1200
}
____exports.items.I09U = {
    type = "道具/戒指/饰品",
    name = "生命蜘蛛项链",
    goldPrice = 1000,
    score = 2048,
    level = "D+",
    all = 10,
    hpRegen = 30,
    mp = 250,
    mpRegen = 5
}
____exports.items.I056 = {
    type = "主武器",
    name = "高原大刀",
    goldPrice = 1500,
    score = 2149,
    level = "D+",
    dmg = 65
}
____exports.items.I0CL = {
    type = "道具/戒指/饰品",
    name = "兽人战鼓",
    goldPrice = 1500,
    score = 2186,
    level = "D++",
    dmg = 30,
    cdReduction = 0.2,
    abilList = "A0IB"
}
____exports.items.I09X = {
    type = "道具/戒指/饰品",
    name = "追击蜘蛛项链",
    goldPrice = 1000,
    score = 2390,
    level = "D++",
    agi = 15
}
____exports.items.I09O = {
    type = "道具/戒指/饰品",
    name = "中级地精勋章",
    goldPrice = 2000,
    score = 2400,
    level = "D++",
    int = 30,
    expGainRate = 0.2,
    cdReduction = 0.05
}
____exports.items.I04W = {
    type = "衣服",
    name = "毒之铠甲",
    goldPrice = 1000,
    score = 2429,
    level = "D++",
    armor = 10,
    hp = 800
}
____exports.items.I051 = {
    type = "主武器",
    name = "闪电权杖",
    goldPrice = 800,
    score = 2450,
    level = "D++",
    dmg = 50,
    magicDmg = 0.2,
    thunderDmg = 0.1
}
____exports.items.I05B = {
    type = "裤子",
    name = "狼人皮裤",
    goldPrice = 1000,
    score = 2479,
    level = "D++",
    dmg = 25,
    armor = 8,
    hp = 1200,
    hpRegen = 15
}
____exports.items.I00R = {
    type = "道具/戒指/饰品",
    name = "闪避腰带",
    goldPrice = 100,
    score = 2570,
    level = "D++",
    dmg = 10,
    armor = 10,
    dodge = 0.4
}
____exports.items.I052 = {
    type = "副武器",
    name = "高原魔力灯笼",
    goldPrice = 750,
    score = 2594,
    level = "D++",
    int = 20,
    hpRegen = 15,
    mpRegen = 5
}
____exports.items.I0DE = {
    type = "鞋子",
    name = "|cffffcc99沙漠武鞋|r",
    goldPrice = 10000,
    score = 2618,
    level = "D++",
    dmg = 60,
    armor = 5,
    armorPierce = 0.2,
    movespeed2 = 55
}
____exports.items.I054 = {
    type = "鞋子",
    name = "高原行者鞋",
    goldPrice = 1500,
    score = 2623,
    level = "D++",
    armor = 8,
    hp = 800,
    hpRegen = 40,
    movespeed2 = 75
}
____exports.items.I055 = {
    type = "头盔",
    name = "高原皮帽",
    goldPrice = 1000,
    score = 2650,
    level = "D++",
    all = 15,
    armor = 8,
    hp = 150,
    physResist = 0.15
}
____exports.items.afac = {
    type = "道具/戒指/饰品",
    name = "|cffff9900阿利亚之笛|r",
    goldPrice = 10000,
    score = 2650,
    level = "C-",
    dmg = 60,
    abilList = "A06M,AIar"
}
____exports.items.I0CK = {
    type = "道具/戒指/饰品",
    name = "风暴狮角",
    goldPrice = 1500,
    score = 2675,
    level = "D++",
    all = 8,
    mpRegen = 10,
    cdReduction = 0.2,
    abilList = "A0IA"
}
____exports.items.I05D = {
    type = "副武器",
    name = "风鸟之爪",
    goldPrice = 650,
    score = 2708,
    level = "D++",
    dmg = 65,
    agi = 15,
    armorPierce = 0.25,
    magicPierce = 0.25
}
____exports.items.I04Z = {
    type = "道具/戒指/饰品",
    name = "风之饰品",
    goldPrice = 1000,
    score = 2718,
    level = "D++",
    agi = 20
}
____exports.items.I002 = {
    type = "衣服",
    name = "首领护甲",
    goldPrice = 200,
    score = 2720,
    level = "D++",
    dmg = 20,
    armor = 10,
    hp = 1000,
    abilList = "A072"
}
____exports.items.I089 = {
    type = "道具/戒指/饰品",
    name = "|cffffcc99烈凯肩甲|r",
    goldPrice = 1000,
    score = 2745,
    level = "D++",
    str = 7,
    agi = 10,
    all = 6,
    hp = 300,
    hpRegen = 50,
    magicDmg = 0.05,
    primaryBonus = "力量+7/敏捷+10/魔法伤害+5%"
}
____exports.items.I0DD = {
    type = "鞋子",
    name = "|cffff9900沙漠光鞋|r",
    goldPrice = 10000,
    score = 2756,
    level = "C-",
    dmg = 40,
    critRate = 0.15,
    hp = 800,
    physDmg = 0.15,
    movespeed2 = 55
}
____exports.items.I0D1 = {
    type = "裤子",
    name = "|cffff9900烈魔之裤|r",
    goldPrice = 1500,
    score = 2764,
    level = "D++",
    critRate = 0.1,
    magicResist = 0.25,
    armor = 15,
    hp = 1500,
    magicDmg = 0.1,
    primaryBonus = "暴击率+10%/暴击率+10%/魔法伤害+10%"
}
____exports.items.I048 = {
    type = "副武器",
    name = "守护之盾",
    goldPrice = 5000,
    score = 2800,
    level = "C-",
    armor = 20,
    hp = 600,
    abilList = "A06A"
}
____exports.items.I046 = {
    type = "副武器",
    name = "回沙之书",
    goldPrice = 5000,
    score = 2849,
    level = "C-",
    dmg = 75,
    magicDmg = 0.2
}
____exports.items.I05A = {
    type = "主武器",
    name = "狼人匕首",
    goldPrice = 1000,
    score = 2884,
    level = "C-",
    dmg = 35,
    agi = 20,
    armorPierce = 0.35,
    abilList = "A0EJ"
}
____exports.items.I045 = {
    type = "主武器",
    name = "怒杀大剑",
    goldPrice = 4000,
    score = 2903,
    level = "C-",
    dmg = 85,
    critRate = 0.25,
    critDmg = 0.35
}
____exports.items.I047 = {
    type = "副武器",
    name = "德素之书",
    goldPrice = 5000,
    score = 2904,
    level = "C-",
    dmg = 80,
    skillHeal = 0.25,
    magicDmg = 0.2
}
____exports.items.I058 = {
    type = "衣服",
    name = "高原战衣",
    goldPrice = 800,
    score = 2919,
    level = "C-",
    critDmg = -0.3,
    armor = 15,
    hp = 1900,
    hpRegen = 15
}
____exports.items.I04M = {
    type = "衣服",
    name = "矮人火枪披风",
    goldPrice = 1800,
    score = 3062,
    level = "C-",
    armor = 20,
    hp = 1200,
    dodge = 0.1,
    abilList = "A03A"
}
____exports.items.I05C = {
    type = "灵魂",
    name = "风鸟之心",
    goldPrice = 1000,
    score = 3150,
    level = "C-",
    int = 35,
    mp = 1000,
    accuracy = 0.05,
    magicPierce = 0.35
}
____exports.items.I037 = {
    type = "灵魂",
    name = "水元素精魂",
    goldPrice = 1000,
    score = 3179,
    level = "C",
    hp = 1500,
    mp = 1500
}
____exports.items.I04K = {
    type = "主武器",
    name = "矮人燧发枪",
    goldPrice = 5000,
    score = 3195,
    level = "C-",
    dmg = 85
}
____exports.items.I04L = {
    type = "主武器",
    name = "矮人火炮",
    goldPrice = 5000,
    score = 3236,
    level = "C-",
    dmg = 85
}
____exports.items.I0AM = {
    type = "道具/戒指/饰品",
    name = "炽热生物挂坠",
    goldPrice = 2500,
    score = 3300,
    level = "C",
    armor = 15,
    hp = 2000
}
____exports.items.I0BE = {
    type = "副武器",
    name = "德鲁伊指引灯笼（魔猎）",
    goldPrice = 10000,
    score = 3331,
    level = "C",
    int = 25,
    atkSpeed = 0.85,
    antMastery = 0.2
}
____exports.items.I041 = {
    type = "主武器",
    name = "狂暴沙斧",
    goldPrice = 5000,
    score = 3350,
    level = "C",
    dmg = 50,
    str = 20,
    critRate = 0.25,
    critDmg = 0.2
}
____exports.items.I0BD = {
    type = "副武器",
    name = "德鲁伊指引灯笼（净化）",
    goldPrice = 10000,
    score = 3363,
    level = "C",
    int = 35,
    hpRegen = 35,
    skillHeal = 0.15,
    mpRegen = 15,
    stunResist = 0.35
}
____exports.items.I043 = {
    type = "主武器",
    name = "守卫大剑",
    goldPrice = 5000,
    score = 3400,
    level = "C-",
    dmg = 75,
    armor = 20,
    abilList = "A06B"
}
____exports.items.I0BF = {
    type = "副武器",
    name = "德鲁伊指引灯笼（智识）",
    goldPrice = 10000,
    score = 3400,
    level = "C",
    int = 45,
    mpRegen = 30,
    mpCost = -0.2,
    cdReduction = 0.15
}
____exports.items.I053 = {
    type = "道具/戒指/饰品",
    name = "风之精华",
    goldPrice = 1000,
    score = 3414,
    level = "C-",
    int = 15,
    abilList = "A06T,A06R"
}
____exports.items.I0A6 = {
    type = "鞋子",
    name = "水龙浴鞋",
    goldPrice = 10000,
    score = 3475,
    level = "C",
    hp = 2000,
    skillHeal = 0.25,
    mpRegenPct = 0.02,
    cdReduction = 0.1,
    movespeed2 = 75
}
____exports.items.I0DC = {
    type = "主武器",
    name = "|cffffcc99蛇人战枪|r",
    goldPrice = 20000,
    score = 3481,
    level = "C",
    dmg = 100,
    critRate = 0.25,
    accuracy = 0.25,
    dodge = 0.1
}
____exports.items.I09B = {
    type = "副武器",
    name = "炽热之弹矢",
    goldPrice = 3000,
    score = 3496,
    level = "C",
    dmg = 110,
    accuracy = 0.1,
    abilList = "A03K"
}
____exports.items.I04B = {
    type = "主武器",
    name = "沙之魔弓",
    goldPrice = 5000,
    score = 3499,
    level = "C-",
    dmg = 100,
    critRate = 0.15
}
____exports.items.I02Q = {
    type = "灵魂",
    name = "灵石",
    goldPrice = 1000,
    score = 3500,
    level = "C",
    armor = 20,
    hpRegen = 40
}
____exports.items.I03A = {
    type = "衣服",
    name = "龙虾硬甲",
    goldPrice = 5000,
    score = 3535,
    level = "C-",
    armor = 30,
    hp = 1500
}
____exports.items.I05N = {
    type = "道具/戒指/饰品",
    name = "荣誉勋章",
    goldPrice = 10000,
    score = 3566,
    level = "C",
    all = 25,
    magicResist = 0.25,
    hp = 200,
    mp = 200
}
____exports.items.I0B7 = {
    type = "裤子",
    name = "|Cff9000FF幽暗沙裤|r",
    goldPrice = 1500,
    score = 3572,
    level = "C",
    agi = 35,
    atkSpeed = 0.35,
    armor = 10,
    hp = 800,
    accuracy = 0.1,
    dodge = 0.05
}
____exports.items.I0B6 = {
    type = "裤子",
    name = "|CffFFFF00暴金沙裤|r",
    goldPrice = 1500,
    score = 3586,
    level = "C",
    str = 40,
    critRate = 0.2,
    critDmg = 0.3,
    armor = 15,
    hp = 500
}
____exports.items.I04A = {
    type = "主武器",
    name = "沙之猎弓",
    goldPrice = 5000,
    score = 3620,
    level = "C",
    dmg = 100,
    critRate = 0.3
}
____exports.items.I0DF = {
    type = "鞋子",
    name = "|cffff6600精粹沙鞋|r",
    goldPrice = 10000,
    score = 3701,
    level = "C",
    dmg = 75,
    critRate = 0.15,
    hp = 800,
    physDmg = 0.15,
    movespeed2 = 55
}
____exports.items.I0DG = {
    type = "道具/戒指/饰品",
    name = "|cffff6600风土戒指|r",
    goldPrice = 10000,
    score = 3712,
    level = "C",
    dmg = 100,
    accuracy = 0.1,
    woodDmg = 0.2,
    fireDmg = 0.2,
    stunResist = 0.3,
    hpPct = 0.1
}
____exports.items.I09W = {
    type = "道具/戒指/饰品",
    name = "远古巫术项链",
    goldPrice = 2500,
    score = 3726,
    level = "C",
    hpRegenPct = 0.04,
    skillHeal = 0.25,
    mp = 2000,
    mpRegenPct = 0.02
}
____exports.items.I042 = {
    type = "主武器",
    name = "精致沙斧",
    goldPrice = 6500,
    score = 3744,
    level = "C",
    dmg = 40,
    str = 20,
    hot = "600hp",
    abilList = "A002"
}
____exports.items.I038 = {
    type = "衣服",
    name = "湖之袍",
    goldPrice = 5000,
    score = 3754,
    level = "C",
    armor = 30,
    hp = 1500,
    hpRegen = 35
}
____exports.items.I0B5 = {
    type = "裤子",
    name = "|CffFFFF00黄金沙裤|r",
    goldPrice = 1500,
    score = 3769,
    level = "C",
    int = 12,
    armor = 15,
    hp = 300,
    hpRegen = 70,
    accuracy = 0.15,
    magicDmg = 0.28
}
____exports.items.I040 = {
    type = "主武器",
    name = "精沙战斧",
    goldPrice = 6500,
    score = 3788,
    level = "C",
    dmg = 50,
    str = 20,
    hpRegen = 30
}
____exports.items.I0AL = {
    type = "道具/戒指/饰品",
    name = "远古血巫项链",
    goldPrice = 2500,
    score = 3798,
    level = "C",
    dmg = 80,
    critRate = 0.2,
    hpRegen = 50,
    magicDmg = 0.15
}
____exports.items.I0AY = {
    type = "裤子",
    name = "|CffC06000德里法围|r",
    goldPrice = 2500,
    score = 3813,
    level = "C",
    int = 40,
    hp = 1800,
    movespeed2 = 60
}
____exports.items.I0A5 = {
    type = "鞋子",
    name = "水龙灵鞋",
    goldPrice = 10000,
    score = 3821,
    level = "C",
    armor = 15,
    hp = 2000,
    mpRegenPct = 0.02,
    waterDmg = 0.15,
    movespeed2 = 75
}
____exports.items.I03B = {
    type = "道具/戒指/饰品",
    name = "灵息戒指（唯一）",
    goldPrice = 8000,
    score = 3830,
    level = "C",
    all = 25,
    hpRegenEff = 0.5,
    mpCost = -0.2,
    movespeed = 20
}
____exports.items.I0B2 = {
    type = "裤子",
    name = "|CffC06000蜘皇下裤|r",
    goldPrice = 2500,
    score = 3840,
    level = "C",
    str = 30,
    critRate = 0.25,
    armor = 5,
    hp = 1500
}
____exports.items.I0AZ = {
    type = "衣服",
    name = "|CffC06000德里狂披|r",
    goldPrice = 2500,
    score = 3868,
    level = "C",
    str = 25,
    armor = 5,
    hp = 2000,
    movespeed2 = 45
}
____exports.items.I0AX = {
    type = "衣服",
    name = "|CffC06000德里披风|r",
    goldPrice = 2500,
    score = 3961,
    level = "C",
    agi = 35,
    hp = 2000,
    movespeed2 = 60
}
____exports.items.I0C0 = {
    type = "道具/戒指/饰品",
    name = "木之符蚀",
    goldPrice = 1000,
    score = 4023,
    level = "C",
    int = 35,
    hp = 1200,
    mpRegen = 10,
    cdReduction = 0.1,
    accuracy = 0.15,
    woodDmg = 0.15
}
____exports.items.I0AJ = {
    type = "道具/戒指/饰品",
    name = "远古毒咒护符",
    goldPrice = 2500,
    score = 4047,
    level = "C",
    dmg = 110,
    cdReduction = 0.15,
    abilList = "A0F0"
}
____exports.items.I05F = {
    type = "道具/戒指/饰品",
    name = "看守者护肩",
    goldPrice = 20000,
    score = 4066,
    level = "C+",
    armor = 15,
    hp = 2000,
    hpRegen = 100
}
____exports.items.I0BS = {
    type = "副武器",
    name = "熊王粗爪",
    goldPrice = 1500,
    score = 4113,
    level = "C+",
    dmg = 60,
    str = 25,
    critRate = 0.15,
    critDmg = 0.4,
    armorPierce = 0.15
}
____exports.items.I0B1 = {
    type = "裤子",
    name = "|CffC06000蜘皇下装|r",
    goldPrice = 2500,
    score = 4120,
    level = "C",
    dmg = 60,
    hp = 1500,
    hpRegen = 50
}
____exports.items.I0BZ = {
    type = "道具/戒指/饰品",
    name = "木之饰品",
    goldPrice = 1000,
    score = 4121,
    level = "C",
    int = 40,
    skillHeal = 0.2,
    healReceived = 0.2,
    accuracy = 0.15
}
____exports.items.I0BR = {
    type = "道具/戒指/饰品",
    name = "熊王腰带",
    goldPrice = 1500,
    score = 4210,
    level = "C+",
    armor = 20,
    hp = 1200
}
____exports.items.I049 = {
    type = "双手武器",
    name = "格挡大盾",
    goldPrice = 7500,
    score = 4274,
    level = "C+",
    armor = 20,
    hp = 2500
}
____exports.items.I039 = {
    type = "主武器",
    name = "湖之龙枪",
    goldPrice = 5000,
    score = 4326,
    level = "C+",
    dmg = 125
}
____exports.items.I09P = {
    type = "道具/戒指/饰品",
    name = "高级地精勋章",
    goldPrice = 4000,
    score = 4337,
    level = "C+",
    int = 50,
    expGainRate = 0.2,
    cdReduction = 0.1
}
____exports.items.I0B0 = {
    type = "主武器",
    name = "|CffC06000蛛皇法杖|r",
    goldPrice = 2500,
    score = 4353,
    level = "C+",
    dmg = 100,
    int = 12,
    magicDmg = 0.1,
    abilList = "A0EZ"
}
____exports.items.I0A4 = {
    type = "头盔",
    name = "水龙灵盔",
    goldPrice = 10000,
    score = 4401,
    level = "C+",
    int = 25,
    armor = 20,
    hp = 1500,
    magicDmg = 0.2
}
____exports.items.I0DA = {
    type = "主武器",
    name = "|cffffffcc西里尔魔法书|r",
    goldPrice = 100,
    score = 4418,
    level = "C+",
    dmg = 100,
    armor = -25,
    accuracy = 0.15,
    baseDmgPct = 0.4
}
____exports.items.I0BY = {
    type = "道具/戒指/饰品",
    name = "|cffff9900食人花精粹品|r",
    goldPrice = 1000,
    score = 4500,
    level = "C+",
    dmg = 60,
    hpRegenPct = 0.01,
    mpRegenPct = 0.01,
    cdReduction = 0.1,
    abilList = "A0HJ"
}
____exports.items.I0BX = {
    type = "道具/戒指/饰品",
    name = "|cffcc99ff食人花能量精粹品|r",
    goldPrice = 1000,
    score = 4540,
    level = "C+",
    hp = 200,
    hpRegenPct = 0.01,
    hpRegenEff = 0.1,
    skillHeal = 0.15,
    mpRegenPct = 0.01,
    mpCost = -0.1,
    cdReduction = 0.1,
    hot = "650hp;400mp",
    abilList = "A015"
}
____exports.items.I0BV = {
    type = "道具/戒指/饰品",
    name = "|cff00ccff食人花魔力精粹品|r",
    goldPrice = 1000,
    score = 4674,
    level = "C+",
    hp = 1800,
    skillHeal = 0.15,
    mpRegenPct = 0.02,
    mpCost = -0.2,
    cdReduction = 0.1,
    hot = "800mp",
    abilList = "A015"
}
____exports.items.I0BQ = {
    type = "灵魂",
    name = "咆哮之心",
    goldPrice = 1000,
    score = 4750,
    level = "C+",
    dmg = 50,
    armor = 20,
    hpRegen = 75,
    abilList = "A0HF"
}
____exports.items.I0C4 = {
    type = "副武器",
    name = "森魔连弩",
    goldPrice = 1500,
    score = 4757,
    level = "C+",
    dmg = 25,
    all = 25,
    armorPierce = 0.35
}
____exports.items.I0C2 = {
    type = "裤子",
    name = "|cff00ccff森息下裤|r",
    goldPrice = 1500,
    score = 4861,
    level = "C++",
    agi = 45,
    armor = 10,
    hp = 1150
}
____exports.items.I0C1 = {
    type = "道具/戒指/饰品",
    name = "巨魔爆炸桶",
    goldPrice = 1000,
    score = 4875,
    level = "C+",
    dmg = 25,
    armor = 20,
    hp = 1500,
    dmgReduction = 45,
    abilList = "A0HK"
}
____exports.items.I0C6 = {
    type = "头盔",
    name = "充盈篷帽",
    goldPrice = 2000,
    score = 4894,
    level = "C+",
    armor = 15,
    hp = 1200,
    hpRegen = 100,
    physResist = 0.1,
    woodResist = 0.1
}
____exports.items.I0BH = {
    type = "副武器",
    name = "德鲁伊指引灯笼（引导）",
    goldPrice = 10000,
    score = 4961,
    level = "C+",
    int = 50,
    hpRegen = 35,
    skillHeal = 0.25,
    mpRegen = 15,
    stunResist = 0.45
}
____exports.items.I0BI = {
    type = "副武器",
    name = "德鲁伊指引灯笼（魔狩）",
    goldPrice = 10000,
    score = 5128,
    level = "C++",
    int = 50,
    atkSpeed = 1,
    atkDmg = 0.2,
    magicAtkDmg = 0.2,
    antMastery = 0.3
}
____exports.items.I0BW = {
    type = "道具/戒指/饰品",
    name = "|cff00ff00食人花生命精粹品|r",
    goldPrice = 1000,
    score = 5200,
    level = "C++",
    hp = 1000,
    hpRegenPct = 0.02,
    hpRegenEff = 0.1,
    skillHeal = 0.15,
    hot = "666hp",
    abilList = "A015"
}
____exports.items.I0C8 = {
    type = "道具/戒指/饰品",
    name = "|cffccffff锋利巨魔爪（只能携带一件）|n|r",
    goldPrice = 350,
    score = 5200,
    level = "C++",
    dmg = 100,
    hp = 150,
    armorPierce = 0.35,
    enhanceDmg = 0.25,
    onlyone = true
}
____exports.items.I059 = {
    type = "主武器",
    name = "蛇人标枪",
    goldPrice = 30000,
    score = 5213,
    level = "C++",
    dmg = 175,
    armorPierce = 0.5
}
____exports.items.I0BJ = {
    type = "副武器",
    name = "德鲁伊指引灯笼（远见）",
    goldPrice = 10000,
    score = 5224,
    level = "C++",
    int = 75,
    mpRegen = 35,
    mpCost = -0.4,
    cdReduction = 0.15
}
____exports.items.I0C9 = {
    type = "主武器",
    name = "巨魔战剑",
    goldPrice = 2500,
    score = 5337,
    level = "C++",
    dmg = 125,
    hp = 600
}
____exports.items.I0C5 = {
    type = "头盔",
    name = "森魔篷帽",
    goldPrice = 2000,
    score = 5871,
    level = "C++",
    critRate = 0.1,
    atkSpeed = 0.6,
    magicResist = 0.25,
    armor = 10,
    hp = 1850,
    hpRegen = 20,
    movespeed2 = 0.12,
    abilList = "A0B1"
}
____exports.items.I0C7 = {
    type = "道具/戒指/饰品",
    name = "|cff993300巨魔头颅|r",
    goldPrice = 350,
    score = 5896,
    level = "B-",
    dmg = 100,
    critRate = 0.1,
    hp = 800,
    physDmg = 0.2
}
____exports.items.I011 = {
    type = "道具/戒指/饰品",
    name = "生命之吻",
    goldPrice = 300,
    score = 6000,
    level = "B-",
    hpRegenPct = 0.01
}
____exports.items.I0CA = {
    type = "主武器",
    name = "|cffff6600巨魔大剑（唯一）|r",
    goldPrice = 2500,
    score = 6000,
    level = "B-",
    dmg = 150,
    critDmg = 0.3,
    cdReduction = 0.15
}
____exports.items.I000 = {type = "主武器", name = "精灵藤杖", goldPrice = 0}
____exports.items.I001 = {type = "主武器", name = "精灵魔杖", goldPrice = 0}
____exports.items.I003 = {type = "鞋子", name = "精灵鞋", goldPrice = 0}
____exports.items.I004 = {type = "主武器", name = "精灵剑", goldPrice = 0}
____exports.items.I005 = {type = "主武器", name = "银斧", goldPrice = 0}
____exports.items.I006 = {type = "主武器", name = "火焰剑", goldPrice = 0}
____exports.items.I007 = {type = "道具/戒指/饰品", name = "火焰晶石", goldPrice = 400}
____exports.items.I008 = {type = "主武器", name = "火鸟剑", goldPrice = 0}
____exports.items.I009 = {type = "主武器", name = "火龙剑", goldPrice = 0}
____exports.items.I00A = {type = "主武器", name = "深渊领主枪", goldPrice = 0}
____exports.items.I00B = {type = "材料", name = "史莱姆粘液", goldPrice = 50}
____exports.items.I00G = {
    type = "提升属性的物品",
    name = "魔物精华（史莱姆）",
    goldPrice = 0,
    PowerUP = "200exp",
    abilList = "A0LH"
}
____exports.items.I00W = {
    type = "主武器",
    name = "精灵战斧",
    goldPrice = 100,
    level = "E",
    dmg = 10,
    str = 1
}
____exports.items.I00Y = {type = "材料", name = "|cFF800000触手残片|r", goldPrice = 150}
____exports.items.I012 = {type = "任务", name = "猎杀豺狼人", goldPrice = 0}
____exports.items.I013 = {type = "任务", name = "采集荧光草", goldPrice = 0}
____exports.items.I014 = {type = "道具/戒指/饰品", name = "鱼竿", goldPrice = 150, abilList = "A017"}
____exports.items.I015 = {type = "主武器", name = "盗贼刀", goldPrice = 0}
____exports.items.I016 = {type = "主武器", name = "蛇缠剑", goldPrice = 0}
____exports.items.I017 = {type = "材料", name = "蛇鳞片", goldPrice = 0}
____exports.items.I018 = {type = "主武器", name = "银蛇剑", goldPrice = 0}
____exports.items.I019 = {type = "主武器", name = "蛇包剑", goldPrice = 0}
____exports.items.I01A = {type = "材料", name = "合成|打造", goldPrice = 0}
____exports.items.I01B = {type = "神符", name = "盗贼神符（魔抗）", goldPrice = 0}
____exports.items.I01I = {
    type = "灵魂",
    name = "邪恶之心（死亡掉落）",
    goldPrice = 1000,
    level = "D",
    dmg = 40,
    hp = 1500,
    lifeSteal = 0.05,
    magicLifeSteal = 0.05,
    onlyone = true
}
____exports.items.I01L = {
    type = "神符",
    name = "金币+200",
    goldPrice = 0,
    PowerUP = "200gold",
    abilList = "A03O"
}
____exports.items.I01M = {
    type = "神符",
    name = "金币+400",
    goldPrice = 0,
    PowerUP = "400gold",
    abilList = "A03P"
}
____exports.items.I01N = {
    type = "神符",
    name = "金币+600",
    goldPrice = 0,
    PowerUP = "600gold",
    abilList = "A03Q"
}
____exports.items.I01O = {type = "材料", name = "豺狼皮", goldPrice = 50}
____exports.items.I01P = {type = "材料", name = "炸药粉", goldPrice = 50}
____exports.items.I023 = {type = "材料", name = "铁块", goldPrice = 500}
____exports.items.I024 = {type = "材料", name = "木材", goldPrice = 150}
____exports.items.I028 = {
    type = "图纸",
    name = "精致木盾",
    goldPrice = 300,
    armor = 5,
    hp = 500
}
____exports.items.I029 = {type = "图纸", name = "火药弓图纸", goldPrice = 400, dmg = 35}
____exports.items.I02A = {
    type = "图纸",
    name = "铁矛图纸",
    goldPrice = 400,
    dmg = 25,
    armorPierce = 0.5
}
____exports.items.I02H = {
    type = "材料",
    name = "螃蟹肉（生）",
    goldPrice = 50,
    hot = "200hp",
    recipe = "h00C:10->I02H*2:5",
    abilList = "A002"
}
____exports.items.I02I = {
    type = "药剂/食品",
    name = "螃蟹肉",
    goldPrice = 50,
    hot = "1500hp",
    abilList = "A002"
}
____exports.items.I02J = {type = "材料", name = "石头", goldPrice = 50}
____exports.items.I02K = {type = "材料", name = "螃蟹壳", goldPrice = 50}
____exports.items.I02M = {type = "道具/戒指/饰品", name = "篝火", goldPrice = 0, abilList = "A049"}
____exports.items.I02W = {type = "材料", name = "淡水鱼（普通）", goldPrice = 100}
____exports.items.I02X = {type = "材料", name = "淡水鱼（小）", goldPrice = 50}
____exports.items.I02Y = {type = "材料", name = "淡水鱼（大）", goldPrice = 200, recipe = "h00C:10->I032*1:5"}
____exports.items.I02Z = {type = "材料", name = "淡水鱼（超大）", goldPrice = 200, recipe = "h00C:10->I032*2:5"}
____exports.items.I030 = {type = "材料", name = "白鳍鱼", goldPrice = 50, recipe = "h00C:10->I033*1:5"}
____exports.items.I031 = {type = "材料", name = "黄金鱼", goldPrice = 50, recipe = "h00C:20->I034*1;20%I036*1:5"}
____exports.items.I032 = {
    type = "药剂/食品",
    name = "烤鱼",
    goldPrice = 50,
    level = "E",
    hot = "30%hp;300mp+300mp",
    abilList = "A015,A08C"
}
____exports.items.I033 = {
    type = "药剂/食品",
    name = "烤白鳍鱼",
    goldPrice = 50,
    level = "E",
    hot = "50%hp;600mp+600mp",
    abilList = "A015,A08C"
}
____exports.items.I034 = {
    type = "药剂/食品",
    name = "烤黄金鱼",
    goldPrice = 50,
    level = "E",
    hot = "50%hpLost;50%mpLost",
    abilList = "A015,A08C"
}
____exports.items.I035 = {
    type = "鞋子",
    name = "元素灵鞋",
    goldPrice = 100,
    level = "G++",
    magicResist = 0.15,
    hp = 300,
    mp = 300,
    movespeed2 = 45
}
____exports.items.I036 = {type = "材料", name = "金块", goldPrice = 10000}
____exports.items.I03I = {type = "任务", name = "获取蜘蛛毒液", goldPrice = 0}
____exports.items.I03L = {type = "材料", name = "蜘蛛体液", goldPrice = 100}
____exports.items.I03M = {type = "材料", name = "异常蜘蛛毒素", goldPrice = 500}
____exports.items.I03V = {
    type = "提升属性的物品",
    name = "赛坦之果",
    goldPrice = 500,
    PowerUP = "50hp",
    abilList = "A0LH"
}
____exports.items.I03W = {
    type = "提升属性的物品",
    name = "伊达之果",
    goldPrice = 1000,
    PowerUP = "3all",
    abilList = "A0LH"
}
____exports.items.I03X = {
    type = "提升属性的物品",
    name = "斯托之果",
    goldPrice = 500,
    PowerUP = "50mp",
    abilList = "A0LH"
}
____exports.items.I03Y = {type = "材料", name = "蝎壳", goldPrice = 50}
____exports.items.I03Z = {type = "材料", name = "蝎肉", goldPrice = 50, recipe = "h00C:10->I0AB*1:5"}
____exports.items.I04C = {type = "任务", name = "情报", goldPrice = 300}
____exports.items.I04D = {type = "药剂/食品", name = "抗毒药水", goldPrice = 1000, abilList = "A060"}
____exports.items.I04E = {
    type = "道具/戒指/饰品",
    name = "魔法药水（中）",
    goldPrice = 300,
    level = "D",
    hot = "600mp",
    abilList = "A08C"
}
____exports.items.I04G = {
    type = "道具/戒指/饰品",
    name = "医疗剂（中）",
    goldPrice = 200,
    level = "D",
    hot = "1200hp",
    abilList = "A08C"
}
____exports.items.I04I = {
    type = "主武器",
    name = "熔岩权杖",
    goldPrice = 8000,
    level = "E+++",
    dmg = 150,
    magicDmg = 0.2
}
____exports.items.I04J = {type = "灵魂", name = "亡灵能量", goldPrice = 1000}
____exports.items.I04N = {type = "图纸", name = "矮人火炮图纸", goldPrice = 2000, dmg = 75}
____exports.items.I04O = {type = "图纸", name = "矮人燧发枪图纸", goldPrice = 2000, dmg = 75}
____exports.items.I04P = {
    type = "图纸",
    name = "矮人火枪风衣图纸",
    goldPrice = 2000,
    level = "F",
    armor = 20,
    hp = 1200,
    dodge = 0.1
}
____exports.items.I04Q = {type = "材料", name = "风之能量", goldPrice = 150}
____exports.items.I04R = {type = "材料", name = "毒囊", goldPrice = 200}
____exports.items.I04S = {type = "材料", name = "鸟人羽毛", goldPrice = 150}
____exports.items.I04T = {type = "材料", name = "高原狼皮", goldPrice = 50}
____exports.items.I04U = {type = "材料", name = "合成|打造", goldPrice = 0}
____exports.items.I04V = {type = "材料", name = "铁块", goldPrice = 200}
____exports.items.I050 = {
    type = "衣服",
    name = "异雷法袍",
    goldPrice = 800,
    level = "E+",
    magicResist = 0.2,
    hp = 1000,
    mp = 500
}
____exports.items.I05H = {type = "其他", name = "游戏伤害类型介绍", goldPrice = 2000, abilList = "A0LH"}
____exports.items.I05I = {type = "其他", name = "游戏伤害机制介绍", goldPrice = 2000, abilList = "A0LH"}
____exports.items.I05J = {type = "其他", name = "游戏属性介绍", goldPrice = 2000, abilList = "A0LH"}
____exports.items.I05K = {type = "其他", name = "游戏特殊介绍", goldPrice = 2000, abilList = "A0LH"}
____exports.items.I05L = {type = "其他", name = "攻击特效介绍", goldPrice = 2000}
____exports.items.I05M = {type = "其他", name = "脱战状态介绍", goldPrice = 2000, abilList = "A0LH"}
____exports.items.I05O = {type = "材料", name = "尘土之影", goldPrice = 0}
____exports.items.I05P = {
    type = "鞋子",
    name = "熔岩灵鞋",
    goldPrice = 500,
    level = "E",
    hp = 450,
    hpRegen = 25,
    fireResist = 0.2,
    movespeed2 = 75
}
____exports.items.I05Q = {
    type = "道具/戒指/饰品",
    name = "火焰护身符",
    goldPrice = 500,
    level = "E",
    hp = 800,
    hpRegen = 30,
    fireResist = 0.1
}
____exports.items.I05S = {
    type = "道具/戒指/饰品",
    name = "改良版医疗剂（中）",
    goldPrice = 300,
    level = "D",
    hot = "1400hp",
    abilList = "A08C"
}
____exports.items.I05U = {
    type = "道具/戒指/饰品",
    name = "改良版魔法药水（中）",
    goldPrice = 300,
    hot = "750mp",
    abilList = "A08C"
}
____exports.items.I05V = {type = "材料", name = "熔岩能量", goldPrice = 50}
____exports.items.I05W = {
    type = "道具/戒指/饰品",
    name = "|cffff0000熔岩宝石|r|cffffffcc（只可佩戴一件)|r",
    goldPrice = 900,
    level = "D-",
    hp = 600,
    magicDmg = 0.2,
    onlyone = true
}
____exports.items.I05X = {type = "任务", name = "希望获得品质不错的道具饰品", goldPrice = 0}
____exports.items.I05Y = {type = "材料", name = "熔岩能量", goldPrice = 0}
____exports.items.I05Z = {type = "药剂/食品", name = "熔岩魔力药剂", goldPrice = 1000, abilList = "A07N"}
____exports.items.I060 = {
    type = "主武器",
    name = "火焰段刃",
    goldPrice = 2000,
    level = "E+",
    dmg = 50,
    magicDmg = 0.15
}
____exports.items.I061 = {
    type = "主武器",
    name = "比安断刃",
    goldPrice = 1000,
    level = "E+",
    dmg = 50,
    str = 20,
    critRate = 0.15
}
____exports.items.I062 = {
    type = "衣服",
    name = "熔岩之袍",
    goldPrice = 500,
    level = "E+",
    magicResist = 0.1,
    hp = 800,
    magicDmg = 0.1
}
____exports.items.I063 = {
    type = "道具/戒指/饰品",
    name = "|cffff9900火焰宝石饰品|r",
    goldPrice = 300,
    level = "E",
    dmg = 20,
    all = 5,
    hpRegen = 20,
    mpRegen = 5,
    magicDmg = 0.05
}
____exports.items.I064 = {
    type = "道具/戒指/饰品",
    name = "食尸鬼头颅",
    goldPrice = 1250,
    level = "E",
    dmg = 25,
    hp = 1000,
    lifeSteal = 0.2,
    atkLifeSteal = 0.2
}
____exports.items.I065 = {type = "材料", name = "熔岩能量（极致）", goldPrice = 50}
____exports.items.I066 = {type = "材料", name = "恶魔能量", goldPrice = 50}
____exports.items.I067 = {
    type = "头盔",
    name = "恶魔羽翼",
    goldPrice = 2500,
    level = "D",
    dmg = 50,
    dodge = 0.05,
    movespeed2 = 0.2,
    abilList = "A07T,A07S"
}
____exports.items.I068 = {
    type = "道具/戒指/饰品",
    name = "|cffffcc99比安之戒|r",
    goldPrice = 1000,
    level = "C-",
    dmg = 25,
    accuracy = 0.05,
    magicDmg = 0.2,
    physDmg = 0.2
}
____exports.items.I069 = {
    type = "神符",
    name = "治疗神符",
    goldPrice = 0,
    hot = "1500hp",
    abilList = "A0B8"
}
____exports.items.I06A = {
    type = "道具/戒指/饰品",
    name = "|cffff0000熔岩腰带|r",
    goldPrice = 900,
    level = "D-",
    dmg = 30,
    critRate = 0.1,
    critDmg = 0.15,
    magicResist = 0.1,
    physResist = 0.1
}
____exports.items.I06B = {
    type = "鞋子",
    name = "安恶之鞋",
    goldPrice = 1000,
    level = "D-",
    dmg = 35,
    armor = 10,
    hp = 1000,
    fireResist = 0.2,
    movespeed2 = 75
}
____exports.items.I06C = {
    type = "主武器",
    name = "瑟尔之弓",
    goldPrice = 2000,
    dmg = 65,
    critRate = 0.25
}
____exports.items.I06D = {
    type = "主武器",
    name = "狱炽之刃",
    goldPrice = 2000,
    level = "D-",
    dmg = 100,
    critRate = 0.25
}
____exports.items.I06E = {
    type = "衣服",
    name = "狱炽之甲",
    goldPrice = 1250,
    level = "D",
    armor = 15,
    hp = 1500,
    hpRegen = 15
}
____exports.items.I06F = {
    type = "道具/戒指/饰品",
    name = "|cffff0000炽热肩甲|r",
    goldPrice = 1000,
    level = "D",
    dmg = 20,
    armor = 10,
    hp = 800,
    hpRegen = 10
}
____exports.items.I06G = {
    type = "道具/戒指/饰品",
    name = "比安吊坠",
    goldPrice = 1250,
    level = "D",
    dmg = 25,
    hp = 450,
    magicPierce = 0.3,
    magicDmg = 0.2
}
____exports.items.I06H = {
    type = "灵魂",
    name = "斯尔能量之心",
    goldPrice = 2500,
    level = "D+",
    dmg = 75,
    hp = 1500,
    mp = 1000,
    onlyone = true,
    abilList = "A0EH"
}
____exports.items.I06I = {
    type = "道具/戒指/饰品",
    name = "|cffff0000熔岩地狱之敲钟|r",
    goldPrice = 2000,
    level = "D+",
    hp = 800,
    hpRegenPct = 0.01,
    cdReduction = 0.2,
    skillDmg = 0.15,
    onlyone = true,
    abilList = "A07Y"
}
____exports.items.I06J = {
    type = "道具/戒指/饰品",
    name = "|cffcc99ff阴暗之敲钟|r",
    goldPrice = 1500,
    level = "D+",
    hp = 800,
    hpRegenPct = 0.01,
    cdReduction = 0.2,
    skillDmg = 0.15,
    onlyone = true,
    abilList = "A07Y"
}
____exports.items.I06K = {
    type = "道具/戒指/饰品",
    name = "|cffff6800地狱火护肩|r",
    goldPrice = 1500,
    level = "D",
    str = 20,
    armor = 15,
    hp = 1500
}
____exports.items.I06L = {
    type = "道具/戒指/饰品",
    name = "|cffff6800地狱火手套|r",
    goldPrice = 1000,
    level = "D",
    dmg = 30,
    str = 20,
    critDmg = 0.35
}
____exports.items.I06M = {
    type = "道具/戒指/饰品",
    name = "|cffff6800地狱火卡牌|r|cffff0000（幸运）|r",
    goldPrice = 1000,
    level = "D+",
    critRate = 0.25,
    hp = 1000,
    cdReduction = 0.1,
    accuracy = 0.1,
    dodge = 0.05
}
____exports.items.I06N = {
    type = "道具/戒指/饰品",
    name = "|cffff6800地狱火卡牌|r|cff00ffff（魔法）|r",
    goldPrice = 1000,
    level = "D+",
    hp = 1000,
    magicPierce = 0.2,
    magicDmg = 0.2
}
____exports.items.I06O = {
    type = "道具/戒指/饰品",
    name = "|cffff6800地狱火卡牌|r|cffffcc99（攻击）|r",
    goldPrice = 2000,
    level = "D+",
    dmg = 50,
    all = 10,
    hp = 1000,
    abilList = "A0EM"
}
____exports.items.I06P = {
    type = "道具/戒指/饰品",
    name = "|cffff6800地狱火卡牌|r|cffcc99ff（能量）|r",
    goldPrice = 1500,
    level = "D+",
    hp = 1500,
    hpRegen = 50,
    mpRegen = 25
}
____exports.items.I06Q = {
    type = "灵魂",
    name = "|cffff6600焰混能量体|r",
    goldPrice = 20000,
    level = "D",
    dmg = 40,
    mpRegen = -10,
    abilList = "A083"
}
____exports.items.I06R = {
    type = "道具/戒指/饰品",
    name = "|cffff0000血祭骷髅殇|r",
    goldPrice = 5000,
    level = "D+",
    dmg = 60,
    all = 20,
    hp = -500,
    lifeSteal = 0.1
}
____exports.items.I06S = {
    type = "道具/戒指/饰品",
    name = "|cff800000破血之戒|r",
    goldPrice = 1750,
    level = "D",
    hp = 1000,
    hpRegen = 50,
    cdReduction = 0.2,
    enhanceDmg = 0.3,
    abilList = "A086"
}
____exports.items.I06T = {
    type = "裤子",
    name = "斯尔之裤",
    goldPrice = 1500,
    level = "D",
    str = 20,
    armor = 15,
    hp = 1000
}
____exports.items.I06U = {
    type = "衣服",
    name = "|cffccffff斯尔法袍|r",
    goldPrice = 2000,
    level = "D-",
    int = 20,
    magicResist = 0.2,
    armor = 20,
    hp = 1000,
    mpRegen = 10
}
____exports.items.I06V = {
    type = "衣服",
    name = "|cff800080恶荣胸甲|r",
    goldPrice = 1500,
    level = "D-",
    dmg = 15,
    critRate = 0.05,
    armor = 20,
    hp = 1500
}
____exports.items.I06W = {
    type = "衣服",
    name = "|cff339966恶斯胸甲|r",
    goldPrice = 1000,
    level = "D-",
    hp = 2500,
    hpRegen = 25,
    abilList = "A089"
}
____exports.items.I06Z = {type = "其他", name = "|CffD8D800传送门：|r|Cffff0000万浴熔灵|r", goldPrice = 1000}
____exports.items.I071 = {
    type = "衣服",
    name = "狱妖长袍",
    goldPrice = 1500,
    level = "C-",
    magicResist = 0.3,
    armor = 30,
    hpRegen = 250
}
____exports.items.I072 = {
    type = "道具/戒指/饰品",
    name = "恶狱腰带",
    goldPrice = 2000,
    level = "C-",
    str = 35,
    magicResist = 0.1,
    hp = 500,
    hpRegen = 30
}
____exports.items.I073 = {
    type = "鞋子",
    name = "|cffcc99ff安恶之鞋|r",
    goldPrice = 1200,
    level = "D+",
    armor = 20,
    dodge = 0.1,
    movespeed2 = 100
}
____exports.items.I074 = {
    type = "裤子",
    name = "|cffff0000狱魔下裤|r",
    goldPrice = 1500,
    level = "C-",
    str = 35,
    armor = 30,
    hp = 300,
    dmgReduction = 50
}
____exports.items.I075 = {
    type = "头盔",
    name = "|cffccffcc女妖头饰|r",
    goldPrice = 1000,
    level = "D++",
    armor = 20,
    hp = 1000,
    magicDmg = 0.15
}
____exports.items.I076 = {
    type = "头盔",
    name = "|cffccffcc女妖头饰-|cff00ff00强化|r|r",
    goldPrice = 1750,
    level = "D++",
    armor = 20,
    hp = 1000,
    magicDmg = 0.2
}
____exports.items.I077 = {
    type = "头盔",
    name = "狱生面具",
    goldPrice = 1000,
    level = "D++",
    all = 25,
    critDmg = -0.5,
    critDmgTaken = -0.5
}
____exports.items.I078 = {
    type = "头盔",
    name = "狱生面具（强化）",
    goldPrice = 1500,
    level = "C-",
    all = 25,
    critDmg = -0.5,
    critDmgTaken = -0.5
}
____exports.items.I079 = {
    type = "道具/戒指/饰品",
    name = "地底先知之戒",
    goldPrice = 1500,
    level = "D++",
    str = 15,
    hp = 1000,
    hpRegen = 20,
    magicDmg = 0.2
}
____exports.items.I07A = {
    type = "道具/戒指/饰品",
    name = "邪恶之熔戒",
    goldPrice = 1000,
    level = "C-",
    hp = 1500,
    magicDmg = 0.1
}
____exports.items.I07B = {
    type = "主武器",
    name = "先祖之狱杖",
    goldPrice = 1500,
    level = "C-",
    dmg = 80,
    int = 35,
    magicDmg = 0.1,
    darkDmg = 0.25,
    abilList = "A0B4"
}
____exports.items.I07C = {
    type = "道具/戒指/饰品",
    name = "熔灵宝石之戒",
    goldPrice = 1000,
    level = "C-",
    dmg = 60,
    lifeSteal = 0.05,
    atkLifeSteal = 0.05,
    abilList = "A0AZ"
}
____exports.items.I07D = {
    type = "主武器",
    name = "恶狱断刃",
    goldPrice = 1500,
    level = "D",
    dmg = 75,
    critRate = 0.25,
    magicDmg = 0.2
}
____exports.items.I07E = {
    type = "主武器",
    name = "嗜狱恶剑",
    goldPrice = 500,
    level = "C-",
    dmg = 100,
    critDmg = 0.2,
    abilList = "A09C"
}
____exports.items.I07F = {
    type = "主武器",
    name = "熔灵大剑",
    goldPrice = 3000,
    level = "D+++",
    dmg = 80,
    atkSpeed = 0.6
}
____exports.items.I07G = {
    type = "主武器",
    name = "狱妖魔盾",
    goldPrice = 1500,
    level = "C-",
    dmg = 40,
    armor = 40,
    abilList = "A09D"
}
____exports.items.I07H = {
    type = "主武器",
    name = "狂暴熔刃",
    goldPrice = 2000,
    level = "C-",
    dmg = 110,
    atkSpeed = 0.5
}
____exports.items.I07I = {
    type = "主武器",
    name = "狱之刺刃",
    goldPrice = 1500,
    level = "C-",
    dmg = 50,
    agi = 45,
    atkSpeed = 0.5
}
____exports.items.I07J = {
    type = "主武器",
    name = "狱魔短匕",
    goldPrice = 1500,
    level = "C-",
    dmg = 1,
    all = 1,
    hpRegen = 1,
    mpRegen = 1,
    magicDmg = 0.45
}
____exports.items.I07K = {
    type = "衣服",
    name = "女妖魔甲",
    goldPrice = 1250,
    level = "C-",
    magicResist = 0.1,
    hpRegenPct = 0.02,
    mpRegenPct = 0.01,
    magicDmg = 0.25,
    abilList = "A0AX"
}
____exports.items.I07L = {
    type = "主武器",
    name = "|cffff0000汭冥血杖|r",
    goldPrice = 1800,
    dmg = 125,
    int = 25,
    magicDmg = 0.2,
    abilList = "A0AP"
}
____exports.items.I07M = {
    type = "主武器",
    name = "|cffff0000汭冥血杖-强化|r",
    goldPrice = 2500,
    dmg = 125,
    int = 25,
    magicDmg = 0.2,
    abilList = "A0AQ"
}
____exports.items.I07N = {
    type = "衣服",
    name = "艾瑞达法袍",
    goldPrice = 1500,
    magicResist = 0.2,
    armor = 20,
    hp = 2500,
    magicDmg = 0.15
}
____exports.items.I07O = {
    type = "衣服",
    name = "冥炎之裙",
    goldPrice = 1750,
    dmg = 40,
    all = 15,
    hp = 1500,
    mp = 1000,
    abilList = "A09Y"
}
____exports.items.I07P = {
    type = "道具/戒指/饰品",
    name = "|cffff0000瑞冥戒指|r",
    goldPrice = 1000,
    dmg = 50,
    magicDmg = 0.2
}
____exports.items.I07Q = {type = "材料", name = "|cffff6800汭冥符文|r", goldPrice = 1000, fireDmg = 0.4}
____exports.items.I07R = {
    type = "道具/戒指/饰品",
    name = "|cffffcc99淬火|r|cffccffff精铁护腕|r",
    goldPrice = 1000,
    dmg = 50,
    armor = 10,
    hp = 1000,
    armorPierce = 0.15
}
____exports.items.I07S = {
    type = "道具/戒指/饰品",
    name = "|cffff6800熔火|r|cffccffff精铁护腕|r",
    goldPrice = 2500,
    dmg = 40,
    str = 25,
    critRate = 0.15,
    armor = 20
}
____exports.items.I07T = {
    type = "道具/戒指/饰品",
    name = "|cffff0000极火|r|cffccffff精铁护腕|r",
    goldPrice = 5000,
    dmg = 40,
    critRate = 0.2,
    critDmg = 0.25,
    armor = 20,
    critRateTaken = -0.05
}
____exports.items.I07U = {
    type = "主武器",
    name = "魔古战刃",
    goldPrice = 2000,
    dmg = 100,
    str = 35,
    critRate = 0.25,
    armor = 15,
    abilList = "A0AW"
}
____exports.items.I07V = {
    type = "主武器",
    name = "淬血战刃",
    goldPrice = 1500,
    dmg = 125,
    critRate = 0.05,
    atkSpeed = 0.4,
    magicDmg = 0.2
}
____exports.items.I07W = {
    type = "主武器",
    name = "看守者战刃",
    goldPrice = 15000,
    dmg = 150,
    str = 35,
    armor = 35,
    armorPierce = 0.3
}
____exports.items.I07X = {
    type = "道具/戒指/饰品",
    name = "看守者腰带",
    goldPrice = 10000,
    dmg = 80,
    hp = 2500,
    hpRegenPct = 0.02
}
____exports.items.I07Y = {
    type = "主武器",
    name = "史诗远古魔刃",
    goldPrice = 3000,
    dmg = 150,
    armorPierce = 0.5,
    abilList = "A0B0"
}
____exports.items.I07Z = {
    type = "道具/戒指/饰品",
    name = "恶魔领袖腰带",
    goldPrice = 1000,
    dmg = 75,
    critRate = 0.15,
    hp = 1200,
    lifeSteal = 0.1,
    atkLifeSteal = 0.1
}
____exports.items.I080 = {
    type = "主武器",
    name = "|cffff00ff使者精神魔杖|r",
    goldPrice = 2000,
    int = 80,
    mpRegenPct = 0.01,
    cdReduction = 0.2,
    summonDmg = 0.35,
    abilList = "A0AR"
}
____exports.items.I081 = {
    type = "主武器",
    name = "使者统治法杖",
    goldPrice = 1000,
    dmg = 100,
    cdReduction = 0.15,
    magicPierce = 0.15,
    magicDmg = 0.25
}
____exports.items.I082 = {
    type = "道具/戒指/饰品",
    name = "使者魔轮",
    goldPrice = 1500,
    hp = 1500,
    hpRegen = 50,
    mpRegen = 25,
    abilList = "A0B5"
}
____exports.items.I083 = {
    type = "副武器",
    name = "|cffcc99ff使者魔炉|r",
    goldPrice = 1000,
    int = 20,
    mpRegenPct = 0.01,
    cdReduction = 0.25,
    magicDmg = 0.15,
    abilList = "A0AN,A0AM,A0AL"
}
____exports.items.I084 = {
    type = "道具/戒指/饰品",
    name = "|cffcc99ff恶魔铃铛|r",
    goldPrice = 1000,
    armor = 35,
    cdReduction = 0.2,
    dmgReduction = 100,
    abilList = "A0AI,A0AH"
}
____exports.items.I085 = {
    type = "灵魂",
    name = "焰虚宝珠",
    goldPrice = 1000,
    all = 40,
    skillHeal = 0.35,
    abilList = "A0B2"
}
____exports.items.I086 = {
    type = "衣服",
    name = "统领之甲",
    goldPrice = 2000,
    armor = 25,
    hp = 2500
}
____exports.items.I087 = {
    type = "头盔",
    name = "|cff666699统领战盔|r",
    goldPrice = 1250,
    armor = 30,
    hp = 1500,
    hpRegen = 35,
    darkDmg = 0.25,
    abilList = "A0AA"
}
____exports.items.I088 = {
    type = "道具/戒指/饰品",
    name = "统领护腕",
    goldPrice = 1000,
    critDmg = -0.2,
    magicResist = 0.15,
    armor = 15,
    hp = 1800,
    critDmgTaken = -0.2
}
____exports.items.I08A = {
    type = "灵魂",
    name = "|cffff9900熔魔内核|r",
    goldPrice = 10000,
    hpRegenPct = 0.02,
    hpRegenEff = 0.35,
    skillHeal = 0.35,
    healReceived = 0.35,
    cdReduction = 0.2
}
____exports.items.I08B = {
    type = "头盔",
    name = "|cff666699熔岩恶魔之|r|cffffffcc灵眼|r",
    goldPrice = 30000,
    int = 50,
    accuracy = 0.2,
    magicPierce = 0.5,
    abilList = "A0AE,A0A9,A0A8"
}
____exports.items.I08C = {
    type = "鞋子",
    name = "熔岩恶魔羽翼",
    goldPrice = 2000,
    agi = 35,
    atkSpeed = 0.5,
    accuracy = 0.05,
    dodge = 0.03,
    movespeed2 = 120,
    abilList = "A0AY"
}
____exports.items.I08D = {
    type = "鞋子",
    name = "熔岩恶魔王翼",
    goldPrice = 2500,
    dmg = 100,
    critRate = 0.15,
    hp = 1000,
    accuracy = 0.25,
    movespeed2 = 120
}
____exports.items.I08E = {
    type = "主武器",
    name = "|cff993300恶魔王爪|r",
    goldPrice = 30000,
    dmg = 200,
    critRate = 0.03,
    hpRegen = 50,
    abilList = "A0AC"
}
____exports.items.I08F = {
    type = "道具/戒指/饰品",
    name = "|cffff9900熔岩令牌|r",
    goldPrice = 30000,
    dmg = 125,
    hp = 2500,
    abilList = "A0AT,A0AS"
}
____exports.items.I08G = {
    type = "道具/戒指/饰品",
    name = "双翼恶魔雕像",
    goldPrice = 1000,
    agi = 50,
    dodge = 0.1,
    movespeed2 = 0.15,
    abilList = "A0B1,A06R"
}
____exports.items.I08H = {
    type = "副武器",
    name = "双翼恶魔之爪牙",
    goldPrice = 1000,
    dmg = 60,
    critRate = 0.1,
    movespeed2 = 100
}
____exports.items.I08I = {
    type = "主武器",
    name = "双翼恶魔之利刃",
    goldPrice = 1000,
    dmg = 50,
    agi = 35,
    accuracy = 0.1
}
____exports.items.I08J = {
    type = "道具/戒指/饰品",
    name = "远古铁甲手套",
    goldPrice = 1000,
    dmg = 80,
    armor = 35
}
____exports.items.I08K = {
    type = "道具/戒指/饰品",
    name = "|cffcc99ff黑暗猎人手套|r",
    goldPrice = 1000,
    dmg = 30,
    str = 35
}
____exports.items.I08L = {
    type = "道具/戒指/饰品",
    name = "|cffcc99ff黑暗猎人手套|r",
    goldPrice = 1000,
    dmg = 65,
    magicResist = 0.1,
    darkDmg = 0.25,
    abilList = "A09Q"
}
____exports.items.I08M = {
    type = "鞋子",
    name = "黑暗猎人护鞋",
    goldPrice = 1000,
    str = 35,
    armor = 15,
    hp = 1500,
    movespeed2 = 75
}
____exports.items.I08N = {
    type = "衣服",
    name = "虚空板甲",
    goldPrice = 2500,
    critDmg = -0.35,
    armor = 40,
    hp = 3000,
    magicDmg = 0.2,
    critDmgTaken = -0.35
}
____exports.items.I08O = {
    type = "衣服",
    name = "虚空银甲",
    goldPrice = 2500,
    armor = 20,
    hp = 2500,
    hpRegenPct = 0.02,
    skillHeal = 0.35,
    healReceived = 0.35,
    magicDmg = 0.2
}
____exports.items.I08P = {
    type = "主武器",
    name = "|cff333399虚空猎锤|r",
    goldPrice = 2500,
    dmg = 150,
    armor = 15,
    hp = 150
}
____exports.items.I08Q = {
    type = "主武器",
    name = "|cff339966熔亡权杖|r",
    goldPrice = 3000,
    int = 60,
    mpRegen = 25,
    magicPierce = 0.35,
    magicDmg = 0.25,
    wound = 0.35
}
____exports.items.I08R = {
    type = "衣服",
    name = "熔亡法袍",
    goldPrice = 1250,
    int = 40,
    magicResist = 0.2,
    armor = 20,
    hp = 2000
}
____exports.items.I08S = {
    type = "鞋子",
    name = "|cff993366亡灵魔鞋|r",
    goldPrice = 2000,
    magicResist = 0.1,
    armor = 5,
    magicDmg = 0.2,
    movespeed2 = 80,
    abilList = "A0EK"
}
____exports.items.I08T = {
    type = "衣服",
    name = "熔亡之拥",
    goldPrice = 1000,
    int = 60,
    mpRegen = 25,
    magicPierce = 0.35,
    magicDmg = 0.25,
    wound = 0.35
}
____exports.items.I08U = {
    type = "道具/戒指/饰品",
    name = "熔墓之戒",
    goldPrice = 1000,
    hp = 1200,
    magicDmg = 0.25
}
____exports.items.I08V = {
    type = "道具/戒指/饰品",
    name = "灵墓之戒",
    goldPrice = 2000,
    int = 25,
    mp = 500,
    mpRegenPct = 0.02,
    cdReduction = 0.15
}
____exports.items.I08W = {
    type = "道具/戒指/饰品",
    name = "|cff800080熔墓守卫护符|r",
    goldPrice = 2000,
    magicDmg = 0.2,
    darkDmg = 0.25
}
____exports.items.I08X = {
    type = "主武器",
    name = "|cff339966守墓人亡杖|r",
    goldPrice = 2500,
    int = 50,
    mpRegen = 25,
    cdReduction = 0.05,
    magicDmg = 0.2,
    abilList = "A09K"
}
____exports.items.I08Y = {type = "材料", name = "|cff993300火魔之息|r", goldPrice = 300}
____exports.items.I08Z = {type = "材料", name = "|cffff6800炽热能量|r", goldPrice = 300}
____exports.items.I090 = {type = "材料", name = "|cffcc99ff恶魔残魂|r", goldPrice = 300}
____exports.items.I091 = {type = "材料", name = "|cffcc99ff恶魔结晶|r", goldPrice = 300}
____exports.items.I092 = {type = "材料", name = "|cffcc99ff火焰元素|r", goldPrice = 300}
____exports.items.I093 = {type = "材料", name = "|cffcc99ff恶魔精魄|r", goldPrice = 300}
____exports.items.I094 = {
    type = "副武器",
    name = "|cffcc99ff熔灵亡盾|r",
    goldPrice = 1000,
    dmg = 50,
    magicResist = -0.15,
    armor = 50,
    abilList = "A09S"
}
____exports.items.I095 = {
    type = "主武器",
    name = "|cff00ccff幽冥法杖|r",
    goldPrice = 3000,
    dmg = 80,
    int = 50,
    magicDmg = 0.2,
    abilList = "A09G"
}
____exports.items.I096 = {
    type = "道具/戒指/饰品",
    name = "灵亡之戒",
    goldPrice = 1000,
    critRate = 0.2,
    atkSpeed = 0.5,
    hpRegen = 100,
    magicDmg = 0.2
}
____exports.items.I097 = {
    type = "道具/戒指/饰品",
    name = "|cffcc99ff暗幽亡戒|r",
    goldPrice = 1750,
    dmg = 40,
    magicDmg = 0.2,
    lifeSteal = 0.05,
    abilList = "A0AG"
}
____exports.items.I098 = {
    type = "道具/戒指/饰品",
    name = "|cff33cccc亡之魔杯|r",
    goldPrice = 2000,
    magicResist = 0.1,
    armor = 35,
    mp = 2000,
    cdReduction = 0.15
}
____exports.items.I099 = {type = "其他", name = "游戏额外设定介绍", goldPrice = 2000, abilList = "A0LH"}
____exports.items.I09A = {type = "材料", name = "合成|打造", goldPrice = 0}
____exports.items.I09C = {
    type = "道具/戒指/饰品",
    name = "熔颅护肩（唯一）",
    goldPrice = 50000,
    dmg = 75,
    magicResist = 0.1,
    armor = 35,
    hpRegen = 150
}
____exports.items.I09D = {
    type = "衣服",
    name = "|cffff0000浴灵魔披（唯一）|r",
    goldPrice = 55000,
    agi = 75,
    hpRegen = 100,
    lifeSteal = 0.15,
    atkLifeSteal = 0.15
}
____exports.items.I09E = {
    type = "道具/戒指/饰品",
    name = "熔狱头骷",
    goldPrice = 3000,
    dmg = 80,
    hp = 1500,
    lifeSteal = 0.2,
    atkLifeSteal = 0.2
}
____exports.items.I09F = {
    type = "衣服",
    name = "虚空装甲",
    goldPrice = 2500,
    critDmg = -0.3,
    magicResist = 0.25,
    armor = 50,
    hp = 3500,
    critDmgTaken = -0.3,
    movespeed2 = -0.15,
    abilList = "A0BB"
}
____exports.items.I09G = {
    type = "道具/戒指/饰品",
    name = "亡墓恶戒",
    goldPrice = 3000,
    dmg = 80,
    hp = 1500
}
____exports.items.I09H = {
    type = "道具/戒指/饰品",
    name = "陨石之球",
    goldPrice = 3000,
    dmg = 40,
    hp = 1500,
    magicDmg = 0.25,
    fireDmg = 0.25,
    abilList = "A0BC"
}
____exports.items.I09I = {
    type = "道具/戒指/饰品",
    name = "浴魔药剂",
    goldPrice = 1000,
    hot = "1250mp",
    abilList = "A0B8"
}
____exports.items.I09J = {
    type = "道具/戒指/饰品",
    name = "浴血药剂",
    goldPrice = 1000,
    hot = "2500hp",
    abilList = "A002"
}
____exports.items.I09K = {
    type = "道具/戒指/饰品",
    name = "浴灵药剂",
    goldPrice = 1000,
    hot = "2000hp",
    abilList = "A015"
}
____exports.items.I09L = {type = "材料", name = "药水合成", goldPrice = 0, abilList = "A0LH"}
____exports.items.I09M = {
    type = "提升属性的物品",
    name = "伊达灵果",
    goldPrice = 1000,
    PowerUP = "8all",
    abilList = "A0LH"
}
____exports.items.I09Q = {type = "道具/戒指/饰品", name = "商人之书", goldPrice = 3000, abilList = "A0EL"}
____exports.items.I09R = {type = "任务道具", name = "地精钥匙", goldPrice = 500, abilList = "A0EO"}
____exports.items.I09T = {type = "材料", name = "委托编织", goldPrice = 0}
____exports.items.I09Y = {
    type = "双手武器",
    name = "比安血爪",
    goldPrice = 5000,
    dmg = 125,
    str = 25,
    hpRegenPct = 0.01
}
____exports.items.I09Z = {type = "任务", name = "收集豺狼皮", goldPrice = 0}
____exports.items.I0A0 = {
    type = "材料",
    name = "|cffff00ff聚灵花|r",
    goldPrice = 3000,
    PowerUP = "8000exp",
    abilList = "A0LH"
}
____exports.items.I0A1 = {type = "任务", name = "寻找聚灵花", goldPrice = 0}
____exports.items.I0A2 = {
    type = "材料",
    name = "|cff99cc00曼陀罗草|r",
    goldPrice = 800,
    PowerUP = "2000exp",
    abilList = "A0LH"
}
____exports.items.I0A3 = {type = "任务", name = "有提高视力的道具吗", goldPrice = 0}
____exports.items.I0A7 = {type = "任务", name = "收集20个蝎肉", goldPrice = 0, int = 5}
____exports.items.I0A8 = {
    type = "提升属性的物品",
    name = "沙漠苹果",
    goldPrice = 1500,
    hot = "1000mp:wait3",
    abilList = "A0LF"
}
____exports.items.I0A9 = {
    type = "提升属性的物品",
    name = "沙漠萝卜",
    goldPrice = 1500,
    PowerUP = "20str;time20",
    abilList = "A0LH"
}
____exports.items.I0AA = {
    type = "提升属性的物品",
    name = "沙漠葡萄",
    goldPrice = 1500,
    PowerUP = "20agi;time20",
    abilList = "A0LH"
}
____exports.items.I0AB = {
    type = "提升属性的物品",
    name = "沙漠蝎肉",
    goldPrice = 500,
    level = "E",
    hot = "15%hp;1000hp",
    abilList = "A08C"
}
____exports.items.I0AC = {
    type = "提升属性的物品",
    name = "沙漠魔瓜",
    goldPrice = 1500,
    PowerUP = "20int;time20",
    abilList = "A0LH"
}
____exports.items.I0AD = {
    type = "提升属性的物品",
    name = "沙漠桃子",
    goldPrice = 2000,
    PowerUP = "1700exp",
    abilList = "A0LH"
}
____exports.items.I0AE = {
    type = "提升属性的物品",
    name = "熔岩魔果",
    goldPrice = 10000,
    PowerUP = "2dmg",
    abilList = "A0LH"
}
____exports.items.I0AF = {type = "任务", name = "7个蝎壳", goldPrice = 0}
____exports.items.I0AG = {type = "任务", name = "|cffc0c0c0藏宝图第一张|r", goldPrice = 100}
____exports.items.I0AH = {type = "任务", name = "|cffc0c0c0藏宝图第二张|r", goldPrice = 100}
____exports.items.I0AI = {type = "任务", name = "|cffc0c0c0藏宝图第三张|r", goldPrice = 100}
____exports.items.I0AN = {type = "任务", name = "送信", goldPrice = 0}
____exports.items.I0AO = {type = "材料", name = "信件", goldPrice = 100}
____exports.items.I0AP = {type = "材料", name = "高原狼肉", goldPrice = 200}
____exports.items.I0AQ = {
    type = "药剂/食品",
    name = "高原狼肉",
    goldPrice = 500,
    hot = "1500hp",
    abilList = "A08C"
}
____exports.items.I0AR = {
    type = "药剂/食品",
    name = "恶魔犬肉",
    goldPrice = 750,
    hot = "2500hp;500mp",
    abilList = "A08C"
}
____exports.items.I0AS = {type = "材料", name = "恶魔犬肉", goldPrice = 200}
____exports.items.I0AT = {type = "材料", name = "|CffFF8000赤魔鱼|r", goldPrice = 50}
____exports.items.I0AU = {type = "材料", name = "|CffFF8000熔岩食鱼|r", goldPrice = 50}
____exports.items.I0AV = {type = "材料", name = "|CffFF8000熔岩灵鱼|r", goldPrice = 50}
____exports.items.I0AW = {type = "材料", name = "|CffFF8000熔岩焰鱼|r", goldPrice = 50}
____exports.items.I0B3 = {
    type = "提升属性的物品",
    name = "能力卡牌",
    goldPrice = 500,
    PowerUP = "3all",
    abilList = "A0LH"
}
____exports.items.I0B4 = {
    type = "神符",
    name = "金币+5000",
    goldPrice = 0,
    PowerUP = "5000gold",
    abilList = "A0F1"
}
____exports.items.I0B8 = {type = "其他", name = "阅读描述的内容（其三）|cffff0000LV45|r", goldPrice = 0}
____exports.items.I0B9 = {type = "其他", name = "阅读描述的内容（其四）|cffff0000LV55|r", goldPrice = 0}
____exports.items.I0BA = {type = "其他", name = "阅读描述的内容（其一）|cffff0000LV25|r", goldPrice = 0}
____exports.items.I0BB = {type = "其他", name = "阅读描述的内容（其二）|cffff0000LV35|r", goldPrice = 0}
____exports.items.I0BC = {type = "任务", name = "净化狂暴之熊", goldPrice = 0}
____exports.items.I0BG = {type = "任务", name = "净化精英狂暴之熊", goldPrice = 0}
____exports.items.I0BK = {
    type = "任务",
    name = "接受试炼（阿尔文）",
    goldPrice = 0,
    hpRegenPct = 0.001,
    mpRegenPct = 0.003
}
____exports.items.I0BL = {
    type = "任务",
    name = "接受试炼（血精灵大法师）",
    goldPrice = 0,
    int = 2,
    mp = 200,
    magicDmg = 0.01
}
____exports.items.I0BM = {
    type = "任务",
    name = "接受试炼（卡金德）",
    goldPrice = 0,
    atkSpeed = 0.03,
    cdReduction = 0.01,
    movespeed2 = 1
}
____exports.items.I0BN = {type = "任务", name = "给予圣果", goldPrice = 0}
____exports.items.I0BO = {type = "任务", name = "补充生命力", goldPrice = 0, abilList = "A0LH"}
____exports.items.I0BP = {type = "任务", name = "帮助被驱逐的水怪（|cffff000040级战斗事件|r）", goldPrice = 0}
____exports.items.I0BT = {type = "材料", name = "|cffff6600狂之气息|r", goldPrice = 400}
____exports.items.I0BU = {
    type = "副武器",
    name = "|cffccffcc翠玉之盾|r",
    goldPrice = 1000,
    level = "C++",
    armor = 40,
    hp = 1000,
    hpRegen = 50,
    woodDmg = 0.25,
    woodResist = 0.2
}
____exports.items.I0C3 = {
    type = "主武器",
    name = "森魔战斧",
    goldPrice = 2500,
    level = "C++",
    dmg = 75,
    str = 30,
    critRate = 0.25,
    accuracy = 1,
    armorPierce = 0.5
}
____exports.items.I0CB = {
    type = "道具/戒指/饰品",
    name = "精灵号角",
    goldPrice = 42500,
    armor = 20,
    hpRegen = 100,
    cdReduction = 0.2,
    stunResist = 0.3,
    abilList = "A0HO,A0HN,A0HP"
}
____exports.items.I0CC = {
    type = "道具/戒指/饰品",
    name = "|cff808040双蛇印章|r",
    goldPrice = 55000,
    dmg = 100,
    critRate = 0.15,
    magicResist = 0.3,
    accuracy = 0.25,
    dodge = 0.1
}
____exports.items.I0CD = {
    type = "鞋子",
    name = "金光灰鞋",
    goldPrice = 47500,
    armor = 20,
    hp = 1000,
    hpRegen = 100,
    magicDmg = 0.2,
    lightDmg = 0.2,
    movespeed2 = 60
}
____exports.items.I0CE = {
    type = "鞋子",
    name = "精光中鞋",
    goldPrice = 30000,
    dmg = 25,
    armor = 20,
    hp = 1000,
    accuracy = 0.1,
    movespeed2 = 60
}
____exports.items.I0CF = {
    type = "衣服",
    name = "光精之甲",
    goldPrice = 30000,
    magicResist = 0.15,
    armor = 30,
    hp = 2500,
    hpRegen = 50,
    skillHeal = 0.15,
    accuracy = 0.1
}
____exports.items.I0CG = {
    type = "主武器",
    name = "齿轮符剑",
    goldPrice = 30000,
    dmg = 150,
    atkSpeed = 0.35,
    magicResist = -0.1,
    armor = 15
}
____exports.items.I0CH = {
    type = "主武器",
    name = "精粹法刺",
    goldPrice = 30000,
    dmg = 150,
    armor = -15,
    cdReduction = 15,
    accuracy = -0.15
}
____exports.items.I0CI = {type = "任务", name = "消失的笛子", goldPrice = 0, dmg = 12}
____exports.items.I0CJ = {
    type = "任务",
    name = "|cffff0000失踪的精灵村民（Boss战任务）|r",
    goldPrice = 0,
    critRate = 1,
    critDmg = 0.01
}
____exports.items.I0CM = {type = "任务", name = "|cffff9900协助异端调查|r（|cffff00008级精英战斗任务|r）", goldPrice = 0}
____exports.items.I0CO = {
    type = "提升属性的物品",
    name = "学识书",
    goldPrice = 0,
    PowerUP = "900exp;2dmg",
    abilList = "A0LH"
}
____exports.items.I0CP = {type = "任务", name = "|cffff00ff暗狱之书|r|cffffff00（寻找物品任务）|r", goldPrice = 0}
____exports.items.I0CQ = {type = "任务", name = "|cffcc99ff暗狱之书|r", goldPrice = 0}
____exports.items.I0CR = {type = "任务", name = "收集|cff99cc00有毒杂草|r", goldPrice = 0}
____exports.items.I0CS = {type = "材料", name = "有毒杂草", goldPrice = 150}
____exports.items.I0CT = {
    type = "任务",
    name = "|cff99ccff驱散灵树邪气|r（|cffff000015级精英战斗|r）",
    goldPrice = 0,
    int = 1,
    mpRegen = 1
}
____exports.items.I0CW = {type = "任务", name = "领取技能", goldPrice = 2000}
____exports.items.I0CX = {type = "任务", name = "领悟暗之力", goldPrice = 2000}
____exports.items.I0CY = {type = "材料", name = "荧光草", goldPrice = 0}
____exports.items.I0D0 = {type = "任务", name = "接受任务-|cffff0000狩猎食人魔（等级24）|r", goldPrice = 0}
____exports.items.I0D2 = {
    type = "道具/戒指/饰品",
    name = "|cffcc99ff黑暗猎人手套|r",
    goldPrice = 1000,
    dmg = 65,
    magicResist = 0.1,
    darkDmg = 0.25,
    abilList = "A09Q"
}
____exports.items.I0D3 = {
    type = "主武器",
    name = "|cffffcc99沙烈魔斧|r",
    goldPrice = 2000,
    level = "C",
    dmg = 75,
    str = 16,
    agi = 20,
    int = 20,
    critDmg = 0.2,
    accuracy = 0.1,
    primaryBonus = "力量+16/敏捷+20/智力+20"
}
____exports.items.I0D4 = {type = "道具/戒指/饰品", name = "食人魔头颅", goldPrice = 1000}
____exports.items.I0D5 = {type = "材料", name = "|cff3366ff魔力源石|r", goldPrice = 50, mpRegenPct = 0.03}
____exports.items.I0D6 = {type = "材料", name = "|cff00ff00夜光翡翠|r", goldPrice = 50}
____exports.items.I0D7 = {type = "任务", name = "圣物封印钥匙", goldPrice = 0}
____exports.items.I0D8 = {type = "图纸", name = "|cffffff00森灵圣枪|r|cff999999打造图纸|r", goldPrice = 2000}
____exports.items.I0D9 = {
    type = "主武器",
    name = "|cff339966自然魔书|r",
    goldPrice = 100,
    dmg = 75,
    hpRegen = 100,
    hpRegenEff = 0.3,
    mpRegen = 20,
    woodDmg = 0.15
}
____exports.items.I0DB = {
    type = "道具/戒指/饰品",
    name = "沙之饰品",
    goldPrice = 2000,
    armor = 10,
    hp = 800,
    cdReduction = 0.05,
    movespeed2 = 45,
    hot = "750mp",
    abilList = "A0LF"
}
____exports.items.I0DH = {
    type = "任务",
    name = "|cffffffcc交换：『聚灵花』换『精粹沙鞋』|r",
    goldPrice = 0,
    dmg = 75,
    critRate = 0.15,
    hp = 1000,
    physDmg = 0.15,
    movespeed2 = 55
}
____exports.items.I0DI = {
    type = "任务",
    name = "|cffffffcc交换：『沙漠母虫尸体』和『蜘蛛女皇尸体』换『风土戒指』|r",
    goldPrice = 0,
    dmg = 100,
    accuracy = 0.1,
    stunResist = 0.3,
    hpPct = 0.1
}
____exports.items.I0DJ = {type = "材料", name = "沙漠母虫尸体", goldPrice = 1000}
____exports.items.I0DK = {type = "材料", name = "沙漠蜘蛛女皇尸体", goldPrice = 1000}
____exports.items.I0DL = {
    type = "主武器",
    name = "|cff339966森灵圣枪|r",
    goldPrice = 10000,
    dmg = 150,
    int = 30,
    accuracy = 0.3,
    magicPierce = 0.5,
    magicDmg = 0.1
}
____exports.items.I0DM = {type = "任务", name = "游戏胜利", goldPrice = 2000}
____exports.items.I0DN = {
    type = "提升属性的物品",
    name = "经验之书（等级+1）",
    goldPrice = 0,
    PowerUP = "1level",
    abilList = "A0LH"
}
____exports.items.azhr = {type = "道具/戒指/饰品", name = "火把", goldPrice = 200, abilList = "A0HC"}
____exports.items.ches = {
    type = "药剂/食品",
    name = "奶酪",
    goldPrice = 0,
    level = "C+",
    PowerUP = "10all",
    abilList = "A0LH"
}
____exports.items.gmfr = {type = "货币", name = "帝国货币", goldPrice = 1000}
____exports.items.gold = {type = "神符", name = "金币", goldPrice = 0, PowerUP = "500-7500gold"}
____exports.items.manh = {type = "道具/戒指/饰品", name = "生命手册", goldPrice = 0, PowerUP = "50hp"}
____exports.items.rdis = {type = "神符", name = "盗贼神符（护甲）", goldPrice = 0, PowerUP = "15armor;time10"}
____exports.items.rump = {
    type = "副武器",
    name = "|cffffcc99沙漠矿铲|r",
    goldPrice = 100,
    dmg = 35,
    abilList = "A0EU,A02L"
}
____exports.items.shwd = {type = "材料", name = "荧光草", goldPrice = 0}
____exports.items.stel = {type = "道具/戒指/饰品", name = "传送权杖", goldPrice = 0}
____exports.items.tdex = {
    type = "提升属性的物品",
    name = "敏捷之书",
    goldPrice = 0,
    PowerUP = "1agi",
    abilList = "A0LH"
}
____exports.items.tdx2 = {
    type = "提升属性的物品",
    name = "敏捷之书 +2",
    goldPrice = 0,
    PowerUP = "2agi",
    abilList = "A0LH"
}
____exports.items.tin2 = {
    type = "提升属性的物品",
    name = "智力之书 +2",
    goldPrice = 0,
    PowerUP = "2int",
    abilList = "A0LH"
}
____exports.items.tint = {
    type = "提升属性的物品",
    name = "智力之书",
    goldPrice = 0,
    PowerUP = "1int",
    abilList = "A0LH"
}
____exports.items.tpow = {
    type = "提升属性的物品",
    name = "知识之书",
    goldPrice = 0,
    PowerUP = "1all",
    abilList = "A0LH"
}
____exports.items.tstr = {
    type = "提升属性的物品",
    name = "力量之书",
    goldPrice = 0,
    PowerUP = "1str",
    abilList = "A0LH"
}
____exports.items.tst2 = {
    type = "提升属性的物品",
    name = "力量之书 +2",
    goldPrice = 0,
    PowerUP = "2str",
    abilList = "A0LH"
}
____exports.default = ____exports.items
return ____exports]=]

P['系统/装备/装备移速.lua'] = [[local ____lualib = require("lualib_bundle")
local __TS__StringTrim = ____lualib.__TS__StringTrim
local ____exports = {}
local fourCCToString, getMaxMovespeed2Info, jass, itemsData
function fourCCToString(self, fourcc)
    local c1 = string.char(fourcc % 256)
    local c2 = string.char(math.floor(fourcc / 256) % 256)
    local c3 = string.char(math.floor(fourcc / 65536) % 256)
    local c4 = string.char(math.floor(fourcc / 16777216) % 256)
    return ((c4 .. c3) .. c2) .. c1
end
function getMaxMovespeed2Info(self, unit, ignoreItem)
    local max = 0
    local name = ""
    local count = 0
    if type(jass.UnitItemInSlot) ~= "function" then
        return {value = 0, name = "", count = 0}
    end
    if type(jass.GetItemTypeId) ~= "function" then
        return {value = 0, name = "", count = 0}
    end
    do
        local slot = 0
        while slot <= 5 do
            do
                local __continue9
                repeat
                    local item = jass.UnitItemInSlot(unit, slot)
                    if not item then
                        __continue9 = true
                        break
                    end
                    if ignoreItem and item == ignoreItem then
                        __continue9 = true
                        break
                    end
                    local tid = jass.GetItemTypeId(item)
                    local idStr = fourCCToString(nil, tid)
                    local entry = itemsData[idStr]
                    local typ = entry and entry.type
                    if typ == "任务" or typ == "药剂" or typ == "食品" then
                        __continue9 = true
                        break
                    end
                    local v = entry and entry.movespeed2
                    if type(v) == "number" and v > 0 then
                        count = count + 1
                    end
                    if type(v) == "number" and v > max then
                        max = v
                        name = (entry and entry.name) ~= nil and __TS__StringTrim(tostring(entry.name)) or "" or "未知"
                    end
                    __continue9 = true
                until true
                if not __continue9 then
                    break
                end
            end
            slot = slot + 1
        end
    end
    return {value = max, name = name, count = count}
end
jass = require("jass.common")
itemsData = require("系统.装备.装备数据").default
--- 单位已应用的 movespeed2 值（仅用于 SGSS 先减后加）
local applied = {}
local function getUnitKey(self, unit)
    return tostring(unit)
end
local function getMaxMovespeed2(self, unit, ignoreItem)
    local info = getMaxMovespeed2Info(nil, unit, ignoreItem)
    return info.value
end
local function applyMovespeed2(self, unit, newSpeed)
    local key = getUnitKey(nil, unit)
    local oldSpeed = applied[key] ~= nil and applied[key] or 0
    if newSpeed == oldSpeed then
        return
    end
    jass.udg_TempUnit[1] = unit
    if oldSpeed ~= 0 then
        jass.udg_TempReal[1] = -oldSpeed
        jass.ExecuteFunc("movespeed2")
    end
    if newSpeed ~= 0 then
        jass.udg_TempReal[1] = newSpeed
        jass.ExecuteFunc("movespeed2")
    end
    applied[key] = newSpeed
end
local function onItemChange(self)
    local unit = jass.GetManipulatingUnit()
    if not unit then
        return
    end
    if type(jass.IsUnitType) == "function" and jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED) then
        return
    end
    if type(jass.IsUnitIllusionBJ) == "function" and jass.IsUnitIllusionBJ(unit) then
        return
    end
    local eventId = jass.GetTriggerEventId()
    local ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_6 = jass.EVENT_PLAYER_UNIT_PICKUP_ITEM
    if ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_6 == nil then
        ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_6 = 38
    end
    local isPickup = eventId == ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_6
    local ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_7 = jass.EVENT_PLAYER_UNIT_DROP_ITEM
    if ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_7 == nil then
        ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_7 = 39
    end
    local isDrop = eventId == ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_7
    local ____temp_8
    if type(jass.GetManipulatedItem) == "function" then
        ____temp_8 = jass.GetManipulatedItem()
    else
        ____temp_8 = nil
    end
    local manipulated = ____temp_8
    local newSpeed = isDrop and getMaxMovespeed2(nil, unit, manipulated) or getMaxMovespeed2(nil, unit)
    local key = getUnitKey(nil, unit)
    local cur = applied[key] ~= nil and applied[key] or 0
    if isPickup and newSpeed <= cur then
        return
    end
    applyMovespeed2(nil, unit, newSpeed)
end
local function init(self)
    local trig = jass.CreateTrigger()
    local ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_9 = jass.EVENT_PLAYER_UNIT_PICKUP_ITEM
    if ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_9 == nil then
        ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_9 = 38
    end
    local pickup = ____jass_EVENT_PLAYER_UNIT_PICKUP_ITEM_9
    local ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_10 = jass.EVENT_PLAYER_UNIT_DROP_ITEM
    if ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_10 == nil then
        ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_10 = 39
    end
    local drop = ____jass_EVENT_PLAYER_UNIT_DROP_ITEM_10
    do
        local i = 0
        while i <= 7 do
            jass.TriggerRegisterPlayerUnitEvent(
                trig,
                jass.Player(i),
                pickup,
                nil
            )
            jass.TriggerRegisterPlayerUnitEvent(
                trig,
                jass.Player(i),
                drop,
                nil
            )
            i = i + 1
        end
    end
    local ____this_12
    ____this_12 = jass
    local ____opt_11 = ____this_12.Player
    if ____opt_11 ~= nil then
        ____opt_11 = ____opt_11(____this_12, 13)
    end
    local p13 = ____opt_11
    if p13 ~= nil then
        jass.TriggerRegisterPlayerUnitEvent(trig, p13, pickup, nil)
        jass.TriggerRegisterPlayerUnitEvent(trig, p13, drop, nil)
    end
    jass.TriggerAddAction(trig, onItemChange)
end
init(nil)
____exports.getMaxMovespeed2Info = getMaxMovespeed2Info
return ____exports]]

P['系统/装备/装备系统.lua'] = [[local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
--- 为 true 时在屏幕显示装备限制与 DROP 跳过调试；排查完可设为 true
local jass = require("jass.common")
local g = require("jass.globals")
local items = require("系统.装备.装备数据").default
local equipLimit = require("系统.装备.装备限制")
local equipShared = equipLimit.equipShared
local equipMovespeed = require("系统.装备.装备移速")
local function fourCCToString(self, fourcc)
    local c1 = string.char(fourcc % 256)
    local c2 = string.char(math.floor(fourcc / 256) % 256)
    local c3 = string.char(math.floor(fourcc / 65536) % 256)
    local c4 = string.char(math.floor(fourcc / 16777216) % 256)
    return ((c4 .. c3) .. c2) .. c1
end
--- 属性配置：显示名 -> itemData key，udg 为 JASS 全局时填写。新增属性只需在此加一行，primaryBonus 即可用该显示名
local STAT_CONFIG = {
    {name = "生命值", key = "hp", udg = "udg_TempHp"},
    {name = "魔法值", key = "mp", udg = "udg_TempMp"},
    {name = "攻击力", key = "dmg", udg = "udg_TempDmg"},
    {name = "护甲", key = "armor", udg = "udg_TempArmor"},
    {name = "攻速", key = "atkSpeed", udg = "udg_TempAtkSpeed"},
    {name = "叠加移动速度", key = "movespeed"},
    {name = "力量", key = "str", udg = "udg_TempStr"},
    {name = "敏捷", key = "agi", udg = "udg_TempAgi"},
    {name = "智力", key = "int", udg = "udg_TempInt"},
    {name = "全属性", key = "all", udg = "udg_TempAll"},
    {name = "暴击率", key = "critRate"},
    {name = "暴击伤害", key = "critDmg"},
    {name = "魔抗", key = "magicResist"},
    {name = "生命恢复", key = "hpRegen"},
    {name = "生命恢复%", key = "hpRegenPct"},
    {name = "生命恢复效率", key = "hpRegenEff"},
    {name = "技能治疗率", key = "skillHeal"},
    {name = "受到的治疗率", key = "healReceived"},
    {name = "重伤", key = "wound"},
    {name = "魔法恢复", key = "mpRegen"},
    {name = "魔法恢复%", key = "mpRegenPct"},
    {name = "魔法消耗", key = "mpCost"},
    {name = "冷却缩减", key = "cdReduction"},
    {name = "命中率", key = "accuracy"},
    {name = "闪避率", key = "dodge"},
    {name = "护甲穿透", key = "armorPierce"},
    {name = "魔法穿透", key = "magicPierce"},
    {name = "技能伤害", key = "skillDmg"},
    {name = "技能抗性", key = "skillResist"},
    {name = "魔法伤害", key = "magicDmg"},
    {name = "物理伤害", key = "physDmg"},
    {name = "物理抗性", key = "physResist"},
    {name = "强化伤害", key = "enhanceDmg"},
    {name = "普攻伤害", key = "atkDmg"},
    {name = "普攻抗性", key = "atkResist"},
    {name = "光属性伤害", key = "lightDmg"},
    {name = "光属性抗性", key = "lightResist"},
    {name = "暗属性伤害", key = "darkDmg"},
    {name = "暗属性抗性", key = "darkResist"},
    {name = "木属性伤害", key = "woodDmg"},
    {name = "木属性抗性", key = "woodResist"},
    {name = "火属性伤害", key = "fireDmg"},
    {name = "火属性抗性", key = "fireResist"},
    {name = "雷属性伤害", key = "thunderDmg"},
    {name = "雷属性抗性", key = "thunderResist"},
    {name = "水属性伤害", key = "waterDmg"},
    {name = "水属性抗性", key = "waterResist"},
    {name = "金属性抗性", key = "MetalResist"},
    {name = "召唤物伤害", key = "summonDmg"},
    {name = "召唤物抗性", key = "summonResist"},
    {name = "伤害减少", key = "dmgReduction"},
    {name = "伤害减少%", key = "dmgReductionPct"},
    {name = "伤害吸血", key = "lifeSteal"},
    {name = "魔法伤害吸血", key = "magicLifeSteal"},
    {name = "普攻伤害吸血", key = "atkLifeSteal"},
    {name = "被暴击率", key = "critRateTaken"},
    {name = "被暴击伤害", key = "critDmgTaken"},
    {name = "眩晕抗性", key = "stunResist"},
    {name = "魔法普攻伤害", key = "magicAtkDmg"},
    {name = "蝼蚁专精", key = "antMastery"},
    {name = "移动速度", key = "movespeed2"},
    {name = "伤害%", key = "dmgBonus"},
    {name = "最终伤害%", key = "finalDmgBonus"},
    {name = "经验获取率", key = "expGainRate"},
    {name = "最大生命值%", key = "hpPct"},
    {name = "基础攻击力%", key = "baseDmgPct"}
}
local NAME_TO_KEY = {}
for ____, e in ipairs(STAT_CONFIG) do
    NAME_TO_KEY[e.name] = e.key
end
if not NAME_TO_KEY["移速"] then
    NAME_TO_KEY["移速"] = "moveSpeed"
end
--- 解析 primaryBonus：格式 "力量+7/敏捷+10/智力+5,魔法伤害+5%"，按主属性 1/2/3 取对应段，段内可用逗号多属性。返回 key->数值
local function parsePrimaryBonus(self, s, mainAttr)
    local out = {}
    if not s or mainAttr < 1 or mainAttr > 3 then
        return out
    end
    local segments = __TS__StringSplit(s, "/")
    local seg = __TS__StringTrim(segments[mainAttr] or "")
    if not seg then
        return out
    end
    local parts = __TS__StringSplit(seg, ",")
    for ____, p in ipairs(parts) do
        do
            local __continue9
            repeat
                local idx = (string.find(p, "+", nil, true) or 0) - 1
                if idx < 0 then
                    __continue9 = true
                    break
                end
                local name = __TS__StringTrim(__TS__StringSubstring(p, 0, idx))
                local valStr = __TS__StringTrim(__TS__StringSubstring(p, idx + 1))
                local key = NAME_TO_KEY[name]
                if not key then
                    __continue9 = true
                    break
                end
                local isPct = (string.find(valStr, "%", nil, true) or 0) - 1 >= 0
                local num = __TS__ParseFloat(valStr) or 0
                out[key] = (out[key] or 0) + (isPct and num / 100 or num)
                __continue9 = true
            until true
            if not __continue9 then
                break
            end
        end
    end
    return out
end
local percentNames = {
    "暴击率",
    "暴击伤害",
    "命中率",
    "护甲穿透",
    "魔法穿透",
    "技能伤害",
    "闪避率",
    "魔抗",
    "冷却缩减",
    "伤害吸血",
    "魔法伤害吸血",
    "普攻伤害吸血",
    "攻速",
    "生命恢复%",
    "魔法恢复%",
    "技能治疗率",
    "受到的治疗率",
    "魔法消耗",
    "重伤",
    "技能抗性",
    "魔法伤害",
    "物理伤害",
    "物理抗性",
    "强化伤害",
    "普攻伤害",
    "普攻抗性",
    "光属性伤害",
    "光属性抗性",
    "暗属性伤害",
    "暗属性抗性",
    "木属性伤害",
    "木属性抗性",
    "火属性伤害",
    "火属性抗性",
    "雷属性伤害",
    "雷属性抗性",
    "水属性伤害",
    "水属性抗性",
    "金属性抗性",
    "召唤物伤害",
    "召唤物抗性",
    "伤害减少%",
    "被暴击率",
    "被暴击伤害",
    "眩晕抗性",
    "魔法普攻伤害",
    "蝼蚁专精",
    "伤害%",
    "最终伤害%",
    "经验获取率",
    "最大生命值%",
    "基础攻击力%"
}
local function initEvents(self)
    local trig = jass.CreateTrigger()
    do
        local i = 0
        while i <= 7 do
            jass.TriggerRegisterPlayerUnitEvent(
                trig,
                jass.Player(i),
                jass.EVENT_PLAYER_UNIT_PICKUP_ITEM,
                nil
            )
            jass.TriggerRegisterPlayerUnitEvent(
                trig,
                jass.Player(i),
                jass.EVENT_PLAYER_UNIT_DROP_ITEM,
                nil
            )
            i = i + 1
        end
    end
    jass.TriggerRegisterPlayerUnitEvent(
        trig,
        jass.Player(13),
        jass.EVENT_PLAYER_UNIT_PICKUP_ITEM,
        nil
    )
    jass.TriggerRegisterPlayerUnitEvent(
        trig,
        jass.Player(13),
        jass.EVENT_PLAYER_UNIT_DROP_ITEM,
        nil
    )
    jass.TriggerAddAction(
        trig,
        function()
            local item = jass.GetManipulatedItem()
            local unit = jass.GetManipulatingUnit()
            if not unit or not item then
                return
            end
            if jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED) then
                return
            end
            if type(jass.IsUnitIllusionBJ) == "function" and jass.IsUnitIllusionBJ(unit) then
                return
            end
            if type(jass.IsUnitIllusion) == "function" and jass.IsUnitIllusion(unit) then
                return
            end
            local player = jass.GetOwningPlayer(unit)
            local itemId = jass.GetItemTypeId(item)
            local event = jass.GetTriggerEventId()
            local isDrop = event == jass.EVENT_PLAYER_UNIT_DROP_ITEM
            local skipFlag = equipShared.skipNextDrop
            if isDrop and skipFlag then
                equipShared.skipNextDrop = false
                return
            end
            local idStr = fourCCToString(nil, itemId)
            local itemData = items[idStr]
            if not itemData then
                if event == jass.EVENT_PLAYER_UNIT_PICKUP_ITEM then
                    local ____temp_2 = type(slk) ~= "nil" and slk.item
                    if ____temp_2 then
                        local ____opt_0 = slk.item[idStr]
                        ____temp_2 = ____opt_0 and ____opt_0.name
                    end
                    local displayName = ____temp_2 or idStr
                    local border = "|cff606060────────────────────────|r"
                    local msg = (((((((border .. "\n|cffffff00『系统消息』：|r") .. "检测到|cFF87CEEB【装备】|r") .. "|cFFFFD700") .. "『") .. displayName) .. "』") .. "|r不在装备数据内，可以的话请加作者|cFF00D7FFQ2376886288|r反馈bug和问题，多谢。\n") .. border
                    jass.DisplayTimedTextToPlayer(
                        player,
                        0,
                        0.01,
                        10,
                        msg
                    )
                end
                return
            end
            local skipType = itemData.type
            if skipType == "任务" or skipType == "药剂" or skipType == "食品" then
                return
            end
            if isDrop and itemData.hot then
                return
            end
            if event == jass.EVENT_PLAYER_UNIT_PICKUP_ITEM and type(equipLimit.equipLimitWouldAllowPickup) == "function" and not equipLimit:equipLimitWouldAllowPickup(unit, item) then
                return
            end
            local charges = jass.GetItemCharges(item)
            local mult = charges > 0 and charges or 1
            jass.udg_TempUnit[1] = unit
            g.udg_TempIsAdd = event == jass.EVENT_PLAYER_UNIT_PICKUP_ITEM
            local primaryBonus = itemData.primaryBonus
            local primary = {}
            if primaryBonus and type(jass.ExecuteFunc) == "function" then
                jass.ExecuteFunc("GetHeroMainAttribute")
                local ____temp_3
                if g.udg_TempInteger ~= nil and g.udg_TempInteger[1] ~= nil then
                    ____temp_3 = g.udg_TempInteger[1]
                else
                    ____temp_3 = 0
                end
                local mainAttr = ____temp_3
                primary = parsePrimaryBonus(nil, primaryBonus, mainAttr)
            end
            local merged = {}
            for ____, e in ipairs(STAT_CONFIG) do
                local ____e_key_5 = e.key
                local ____itemData_e_key_4 = itemData[e.key]
                if ____itemData_e_key_4 == nil then
                    ____itemData_e_key_4 = 0
                end
                merged[____e_key_5] = ____itemData_e_key_4 + (primary[e.key] or 0)
            end
            merged.moveSpeed = (itemData.moveSpeed or 0) + (primary.moveSpeed or 0)
            g.udg_TempHp = merged.hp or 0
            g.udg_TempMp = merged.mp or 0
            g.udg_TempDmg = merged.dmg or 0
            g.udg_TempArmor = merged.armor or 0
            g.udg_TempAtkSpeed = merged.atkSpeed or 0
            g.udg_TempMoveSpeed = merged.moveSpeed or 0
            g.udg_TempStr = merged.str or 0
            g.udg_TempAgi = merged.agi or 0
            g.udg_TempInt = merged.int or 0
            g.udg_TempAll = merged.all or 0
            local ____itemData_score_6 = itemData.score
            if ____itemData_score_6 == nil then
                ____itemData_score_6 = 0
            end
            g.udg_TempScore = ____itemData_score_6
            local playerStats = {}
            local isAdd = g.udg_TempIsAdd
            local function addStat(____, val, name)
                if val == nil or val == 0 then
                    return
                end
                local value = val * mult
                if not isAdd then
                    value = -value
                end
                playerStats[#playerStats + 1] = {name = name, value = value}
            end
            for ____, e in ipairs(STAT_CONFIG) do
                addStat(nil, merged[e.key], e.name)
            end
            g.udg_TempString = {}
            g.udg_TempAmount = {}
            g.udg_TempStatCount = #playerStats
            do
                local i = 0
                while i < #playerStats do
                    g.udg_TempString[i + 1] = playerStats[i + 1].name
                    g.udg_TempAmount[i + 1] = playerStats[i + 1].value
                    i = i + 1
                end
            end
            local owner = jass.GetOwningPlayer(unit)
            local ____temp_7
            if type(jass.GetPlayerName) == "function" then
                ____temp_7 = jass.GetPlayerName(owner)
            else
                ____temp_7 = ""
            end
            local ____temp_7_8 = ____temp_7
            if ____temp_7_8 == nil then
                ____temp_7_8 = ""
            end
            local playerName = ____temp_7_8
            local actionText = g.udg_TempIsAdd and "获得" or "丢弃"
            local levelText = itemData.level or ""
            local levelColor
            if levelText == "E-" or levelText == "E" then
                levelColor = "|cFF808080"
            elseif levelText == "D" then
                levelColor = "|cFF00FF00"
            elseif levelText == "C" then
                levelColor = "|cFF0000FF"
            elseif levelText == "B" then
                levelColor = "|cFF800080"
            elseif levelText == "A" then
                levelColor = "|cFFFFA500"
            elseif levelText == "S" then
                levelColor = "|cFFFF0000"
            else
                levelColor = "|cFFFFFFFF"
            end
            local coloredLevel = (levelColor .. levelText) .. "|r"
            local coloredName = ("|cFFFFD700" .. (itemData.name or "未知")) .. "|r"
            local msg = (((((((("|cffffff00『系统消息』：|r" .. "|cFF87CEEB【装备】|r ") .. actionText) .. "[") .. coloredLevel) .. "]") .. "级") .. "『") .. coloredName) .. "』"
            for ____, stat in ipairs(playerStats) do
                local sign = stat.value > 0 and "+" or ""
                local isPct = __TS__ArrayIndexOf(percentNames, stat.name) >= 0
                local v = isPct and stat.value * 100 or stat.value
                local nearZero = v > -0.000001 and v < 0.000001
                local vStr = nearZero and "0" or tostring(v)
                msg = msg .. (((" " .. stat.name) .. sign) .. vStr) .. (isPct and "%" or "")
            end
            jass.DisplayTimedTextToPlayer(
                player,
                0,
                0.01,
                5,
                msg
            )
            jass.ExecuteFunc("ApplyItemBonus")
            local tempRead = g.udg_TempReadValue
            local test5Parts = {}
            do
                local i = 0
                while i < #playerStats do
                    do
                        local __continue47
                        repeat
                            local idx = i + 1
                            local statName = g.udg_TempString[idx]
                            if statName == "移动速度" then
                                __continue47 = true
                                break
                            end
                            local ____temp_9
                            if tempRead ~= nil and tempRead[idx] ~= nil then
                                ____temp_9 = tempRead[idx]
                            else
                                ____temp_9 = 0
                            end
                            local val = ____temp_9
                            local num = __TS__Number(val)
                            local isPct = __TS__ArrayIndexOf(percentNames, statName) >= 0
                            local nearZero = num > -0.000001 and num < 0.000001
                            local valStr = isPct and (nearZero and "0%" or tostring(math.floor(num * 1000 + 0.5) / 10
                            ) .. "%") or (nearZero and "0" or tostring(num))
                            test5Parts[#test5Parts + 1] = (tostring(statName) .. "为：") .. valStr
                            __continue47 = true
                        until true
                        if not __continue47 then
                            break
                        end
                    end
                    i = i + 1
                end
            end
            local hasMovespeed2 = itemData.movespeed2 ~= nil
            if hasMovespeed2 and unit ~= nil and type(equipMovespeed.getMaxMovespeed2Info) == "function" then
                local ____equipMovespeed_getMaxMovespeed2Info_11 = equipMovespeed.getMaxMovespeed2Info
                local ____isDrop_10
                if isDrop then
                    ____isDrop_10 = item
                else
                    ____isDrop_10 = nil
                end
                local ms = ____equipMovespeed_getMaxMovespeed2Info_11(equipMovespeed, unit, ____isDrop_10)
                if ms.value > 0 then
                    test5Parts[#test5Parts + 1] = "移动速度为：" .. tostring(ms.value)
                end
                if ms.value > 0 and ms.name ~= "" and ms.count >= 2 then
                    jass.DisplayTimedTextToPlayer(
                        owner,
                        0,
                        0.02,
                        5,
                        ("|cffffff00『系统提示』：|r有多个不可叠加移速装备，当前只生效|cff00bfff『" .. ms.name) .. "』|r"
                    )
                end
            end
            if #test5Parts > 0 then
                jass.DisplayTimedTextToPlayer(
                    owner,
                    0,
                    0.02,
                    5,
                    (("|cffffff00『系统消息』：|r" .. tostring(playerName)) .. "的当前装备加成") .. table.concat(test5Parts, "，")
                )
            end
        end
    )
end
initEvents(nil)
return ____exports]]

P['系统/装备/装备限制.lua'] = [[local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringAccess = ____lualib.__TS__StringAccess
local __TS__StringTrim = ____lualib.__TS__StringTrim
local ____exports = {}
local jass = require("jass.common")
local g = require("jass.globals")
local itemsData = require("系统.装备.装备数据").default or ({})
--- 与装备系统共用：装备限制 UnitRemoveItem 前设为 true，装备系统 DROP 时跳过扣属性
____exports.equipShared = {skipNextDrop = false}
local ONE_PER_SLOT = {
    "主武器",
    "副武器",
    "衣服",
    "鞋子",
    "裤子",
    "头盔",
    "灵魂"
}
local TWO_HANDED = "双手武器"
local CONFLICT_WITH_TWO_HANDED = {"主武器", "副武器"}
local PREFIX = "|cffffff00『系统提示』：|r"
local COLOR_TYPE = "|cff00ff00"
local COLOR_NAME = "|cff00bfff"
local COLOR_ERR = "|cffff0000"
local function fourCCToString(self, four)
    local a = math.floor(four / 16777216) % 256
    local b = math.floor(four / 65536) % 256
    local c = math.floor(four / 256) % 256
    local d = four % 256
    return string.char(a, b, c, d)
end
local function getEntry(self, itemTypeId)
    local id = fourCCToString(nil, itemTypeId)
    return itemsData[id]
end
local function safeGetItemTypeId(self, it)
    local fn = jass.GetItemTypeId
    if type(fn) ~= "function" then
        return nil
    end
    local a = jass.GetItemTypeId(it)
    if type(a) == "number" then
        return a
    end
    local b = fn(nil, jass, it)
    if type(b) == "number" then
        return b
    end
    local c = fn(nil, nil, it)
    if type(c) == "number" then
        return c
    end
    return nil
end
local function safeUnitItemInSlot(self, unit, slot)
    local fn = jass.UnitItemInSlot
    if type(fn) ~= "function" then
        return nil
    end
    local a = jass.UnitItemInSlot(unit, slot)
    if a then
        return a
    end
    local b = fn(nil, jass, unit, slot)
    if b then
        return b
    end
    local c = fn(nil, nil, unit, slot)
    if c then
        return c
    end
    return nil
end
--- 仅判断：该拾取是否会被装备限制拒绝（true=允许保留，false=会被丢出）。供装备系统在加属性前调用。
-- 事件触发时物品可能尚未入背包，故把“当前拾取的这件”也计入数量。
function ____exports.equipLimitWouldAllowPickup(self, unit, item)
    if Itmeboolean then
        return true
    end
    if not unit or not item then
        return true
    end
    local pickedTypeId = safeGetItemTypeId(nil, item)
    if pickedTypeId == nil then
        return true
    end
    local entry = getEntry(nil, pickedTypeId)
    if not entry then
        return true
    end
    local pickedSlotType = entry.type
    local onlyOne = entry.onlyone == true or entry.onlyone == "TRUE"
    local sameIdCount = 0
    local sameSlotTypeCount = 0
    local hasTwoHanded = false
    local hasMain = false
    local hasSub = false
    do
        local i = 0
        while i <= 5 do
            do
                local __continue20
                repeat
                    local it = safeUnitItemInSlot(nil, unit, i)
                    if not it or it == item then
                        __continue20 = true
                        break
                    end
                    local itTypeId = safeGetItemTypeId(nil, it)
                    if itTypeId == nil then
                        __continue20 = true
                        break
                    end
                    local e = getEntry(nil, itTypeId)
                    if not e then
                        __continue20 = true
                        break
                    end
                    if itTypeId == pickedTypeId then
                        sameIdCount = sameIdCount + 1
                    end
                    if pickedSlotType ~= nil and e.type == pickedSlotType then
                        sameSlotTypeCount = sameSlotTypeCount + 1
                    end
                    if e.type == TWO_HANDED then
                        hasTwoHanded = true
                    end
                    if e.type == "主武器" then
                        hasMain = true
                    end
                    if e.type == "副武器" then
                        hasSub = true
                    end
                    __continue20 = true
                until true
                if not __continue20 then
                    break
                end
            end
            i = i + 1
        end
    end
    sameIdCount = sameIdCount + 1
    sameSlotTypeCount = sameSlotTypeCount + 1
    if pickedSlotType == "主武器" then
        hasMain = true
    end
    if pickedSlotType == "副武器" then
        hasSub = true
    end
    if pickedSlotType == TWO_HANDED then
        hasTwoHanded = true
    end
    local msg = ""
    if pickedSlotType == TWO_HANDED then
        if hasMain or hasSub then
            msg = "x"
        end
    elseif pickedSlotType and __TS__ArrayIndexOf(CONFLICT_WITH_TWO_HANDED, pickedSlotType) >= 0 then
        if hasTwoHanded then
            msg = "x"
        end
    end
    if msg == "" and onlyOne and sameIdCount > 1 then
        msg = "x"
    end
    if msg == "" and pickedSlotType and __TS__ArrayIndexOf(ONE_PER_SLOT, pickedSlotType) >= 0 and sameSlotTypeCount > 1 then
        msg = "x"
    end
    return msg == ""
end
local function onPickup(self)
    if Itmeboolean then
        return
    end
    local ____opt_0 = jass.GetManipulatingUnit
    local ____temp_4 = ____opt_0 and ____opt_0(jass)
    if ____temp_4 == nil then
        local ____opt_2 = jass.GetTriggerUnit
        ____temp_4 = ____opt_2 and ____opt_2(jass)
    end
    local unit = ____temp_4
    local ____opt_5 = jass.GetManipulatedItem
    local item = ____opt_5 and ____opt_5(jass)
    if not unit or not item then
        return
    end
    if not jass.IsUnitType(unit, jass.UNIT_TYPE_HERO) then
        return
    end
    if jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED) then
        return
    end
    if type(jass.IsUnitIllusionBJ) == "function" and jass.IsUnitIllusionBJ(unit) then
        return
    end
    if type(jass.IsUnitIllusion) == "function" and jass.IsUnitIllusion(unit) then
        return
    end
    local pickedTypeId = safeGetItemTypeId(nil, item)
    if pickedTypeId == nil then
        return
    end
    local entry = getEntry(nil, pickedTypeId)
    if not entry then
        return
    end
    local pickedSlotType = entry.type
    local onlyOne = entry.onlyone == true or entry.onlyone == "TRUE"
    local name = entry.name ~= nil and tostring(entry.name) or ""
    local function stripColor(____, s)
        local out = ""
        local i = 0
        while i < #s do
            do
                local __continue48
                repeat
                    if __TS__StringSubstring(s, i, i + 2) == "|r" then
                        i = i + 2
                        __continue48 = true
                        break
                    end
                    if __TS__StringSubstring(s, i, i + 2) == "|c" and i + 10 <= #s then
                        local hex = true
                        do
                            local j = i + 2
                            while j < i + 10 and hex do
                                hex = (string.find(
                                    "0123456789aAbBcCdDeEfF",
                                    __TS__StringAccess(s, j),
                                    nil,
                                    true
                                ) or 0) - 1 >= 0
                                j = j + 1
                            end
                        end
                        if hex then
                            i = i + 10
                            __continue48 = true
                            break
                        end
                    end
                    out = out .. __TS__StringAccess(s, i)
                    i = i + 1
                    __continue48 = true
                until true
                if not __continue48 then
                    break
                end
            end
        end
        return out
    end
    name = __TS__StringTrim(stripColor(nil, name))
    local nameColored = ((COLOR_NAME .. "『") .. name) .. "』|r"
    local msg = ""
    local player = jass.Player(0)
    if type(jass.GetOwningPlayer) == "function" then
        local p = jass.GetOwningPlayer(unit)
        if p then
            player = p
        end
    end
    local sameIdCount = 0
    local sameSlotTypeCount = 0
    local hasTwoHanded = false
    local hasMain = false
    local hasSub = false
    do
        local i = 0
        while i <= 5 do
            do
                local __continue57
                repeat
                    local it = safeUnitItemInSlot(nil, unit, i)
                    if not it then
                        __continue57 = true
                        break
                    end
                    local itTypeId = safeGetItemTypeId(nil, it)
                    if itTypeId == nil then
                        __continue57 = true
                        break
                    end
                    local e = getEntry(nil, itTypeId)
                    if not e then
                        __continue57 = true
                        break
                    end
                    if itTypeId == pickedTypeId then
                        sameIdCount = sameIdCount + 1
                    end
                    if pickedSlotType ~= nil and e.type == pickedSlotType then
                        sameSlotTypeCount = sameSlotTypeCount + 1
                    end
                    if e.type == TWO_HANDED then
                        hasTwoHanded = true
                    end
                    if e.type == "主武器" then
                        hasMain = true
                    end
                    if e.type == "副武器" then
                        hasSub = true
                    end
                    __continue57 = true
                until true
                if not __continue57 then
                    break
                end
            end
            i = i + 1
        end
    end
    if pickedSlotType == TWO_HANDED then
        if hasMain or hasSub then
            msg = (PREFIX .. COLOR_ERR) .. "双手武器与主武器/副武器不能同时装备！|r"
        end
    elseif pickedSlotType and __TS__ArrayIndexOf(CONFLICT_WITH_TWO_HANDED, pickedSlotType) >= 0 then
        if hasTwoHanded then
            msg = (PREFIX .. COLOR_ERR) .. "双手武器与主武器/副武器不能同时装备！|r"
        end
    end
    if msg == "" and onlyOne and sameIdCount > 1 then
        msg = (((PREFIX .. COLOR_ERR) .. "该物品") .. nameColored) .. "只能装备一件！|r"
    end
    if msg == "" and pickedSlotType and __TS__ArrayIndexOf(ONE_PER_SLOT, pickedSlotType) >= 0 and sameSlotTypeCount > 1 then
        msg = (((((PREFIX .. COLOR_TYPE) .. pickedSlotType) .. "|r物品：") .. nameColored) .. COLOR_ERR) .. "只能装备一件！|r"
    end
    if msg == "" then
        return
    end
    ____exports.equipShared.skipNextDrop = true
    if type(jass.UnitRemoveItem) == "function" then
        jass.UnitRemoveItem(unit, item)
    else
        local UnitDropItemPoint = jass.UnitDropItemPoint
        local GetUnitX = jass.GetUnitX
        local GetUnitY = jass.GetUnitY
        if type(UnitDropItemPoint) == "function" and type(GetUnitX) == "function" and type(GetUnitY) == "function" then
            UnitDropItemPoint(
                nil,
                unit,
                item,
                GetUnitX(nil, unit),
                GetUnitY(nil, unit)
            )
        end
    end
    jass.DisplayTimedTextToPlayer(
        player,
        0,
        0,
        6,
        msg
    )
end
local function isHeroCond(self)
    local ____opt_7 = jass.GetTriggerUnit
    local ____temp_11 = ____opt_7 and ____opt_7(jass)
    if ____temp_11 == nil then
        local ____this_10
        ____this_10 = jass
        local ____opt_9 = ____this_10.GetManipulatingUnit
        if ____opt_9 ~= nil then
            ____opt_9 = ____opt_9(____this_10)
        end
        ____temp_11 = ____opt_9
    end
    local u = ____temp_11
    return u ~= nil and jass.IsUnitType(u, jass.UNIT_TYPE_HERO)
end
local function init(self)
    local trig = jass.CreateTrigger()
    local eventId = jass.EVENT_PLAYER_UNIT_PICKUP_ITEM
    do
        local i = 0
        while i < 4 do
            jass.TriggerRegisterPlayerUnitEvent(
                trig,
                jass.Player(i),
                eventId,
                nil
            )
            i = i + 1
        end
    end
    local cond = jass.Condition
    if type(cond) == "function" then
        jass.TriggerAddCondition(
            trig,
            cond(nil, isHeroCond)
        )
    end
    jass.TriggerAddAction(trig, onPickup)
end
init(nil)
return ____exports]]

--[==[
dofile('origwar3map.lua')
local __main = main
]==]--
function main()
    xpcall(function()
        --[==[
        __main()
        ]==]--
        dofile('main.lua')
    end, function(msg)
        local handler = geterrorhandler()
        if handler and msg then
            return handler(msg)
        end
    end)
end


main()


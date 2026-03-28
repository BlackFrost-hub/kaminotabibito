--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
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
    "DzF2I",
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
return ____exports

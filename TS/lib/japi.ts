/* eslint-disable @typescript-eslint/no-explicit-any */

/**
 * TS 版本 hjapi（给 TSTL 编译用）
 *
 * 注意：
 * - 依赖运行时提供的全局：JassJapi / cj / DEBUGGING / echo / print / math
 * - 大部分 API 只是薄封装：hjapi.exec("NativeName", ...)
 */

declare const DEBUGGING: boolean | undefined;
declare const echo: ((msg: string) => void) | undefined;
declare const print: ((...args: any[]) => void) | undefined;
declare const JassJapi: Record<string, any> | undefined;
declare const cj: Record<string, any> | undefined;
declare const math: { floor: (n: number) => number } | undefined;

type TipsMap = Record<string, 1>;
type CacheMap = Record<string, any>;

export type HJAPI = {
  _lib?: any;
  _tips: TipsMap;
  _cache: CacheMap;
  echo: (msg: string) => void;
  has: (method: string) => boolean;
  exec: (method: string, ...args: any[]) => any;
  [k: string]: any;
};

const g = globalThis as any;

export const hjapi: HJAPI = (g.hjapi as HJAPI) ?? (g.hjapi = ({} as any));

hjapi._tips = (hjapi._tips ?? {}) as TipsMap;
hjapi._cache =
  (hjapi._cache as CacheMap) ??
  (hjapi._cache = {
    DzLoadToc: {},
    Z: {},
    FrameTagIndex: 0,
    IsWideScreen: false,
    FrameBlackTop: 0.02,
    FrameBlackBottom: 0.13,
    FrameInnerHeight: 0.45,
  } as any);

hjapi.echo = (msg: string): void => {
  if (typeof msg !== "string") return;
  if (hjapi._tips[msg] == null) {
    hjapi._tips[msg] = 1;
    // 运行时输出在 TSTL 下容易被“隐式 this 参数”污染（变成 fn(nil, ...)），
    // 这里仅做去重标记，不强行输出，避免影响调用侧。
    void DEBUGGING;
  }
};

hjapi.has = (method: string): boolean => {
  if (typeof method !== "string") return false;
  const lib = JassJapi as any;
  return !!lib && typeof lib[method] === "function";
};

hjapi.exec = (method: string, ...args: any[]): any => {
  if (typeof method !== "string") return false;
  const lib = JassJapi as any;
  if (!lib || typeof lib[method] !== "function") {
    hjapi.echo(method + " function does not exist!");
    return false;
  }
  // 注意：不要把 lib[method] 赋给局部变量再调用（TSTL 会改写调用形态）
  return lib[method](...args);
};

// --------------------------------------------------------------------------------------
// DzAPI / Dz 系列（常用优先；其余可按同样方式继续补）
// --------------------------------------------------------------------------------------

hjapi.DzAPI_Map_SaveServerValue = (whichPlayer: any, key: string, value: string): boolean => {
  return !!hjapi.exec("DzAPI_Map_SaveServerValue", whichPlayer, key, value);
};

hjapi.DzAPI_Map_GetServerValue = (whichPlayer: any, key: string): string => {
  return hjapi.exec("DzAPI_Map_GetServerValue", whichPlayer, key);
};

hjapi.DzAPI_Map_GetServerValueErrorCode = (whichPlayer: any): number => {
  return hjapi.exec("DzAPI_Map_GetServerValueErrorCode", whichPlayer);
};

hjapi.GetPlayerServerValueSuccess = (whichPlayer: any): boolean => {
  const res = hjapi.DzAPI_Map_GetServerValueErrorCode(whichPlayer);
  // Lua 里是 floor(res)==0；这里保持一致
  const mf = math && typeof math.floor === "function" ? math.floor : undefined;
  const v = typeof mf === "function" ? mf(res) : Math.floor(res);
  return v === 0;
};

hjapi.DzAPI_Map_IsRPGLadder = (): boolean => {
  // 原 lua 传 nil 占位；这里也传 undefined（编译成 nil）
  return !!hjapi.exec("DzAPI_Map_IsRPGLadder", undefined as any);
};

hjapi.DzAPI_Map_IsRPGLobby = (): boolean => {
  return !!hjapi.exec("DzAPI_Map_IsRPGLobby", undefined as any);
};

hjapi.DzAPI_Map_GetGameStartTime = (): number => {
  return hjapi.exec("DzAPI_Map_GetGameStartTime", undefined as any);
};

hjapi.DzAPI_Map_GetActivityData = (): string => {
  return hjapi.exec("DzAPI_Map_GetActivityData", undefined as any);
};

hjapi.DzAPI_Map_GetMatchType = (): number => {
  return hjapi.exec("DzAPI_Map_GetMatchType", undefined as any);
};

hjapi.DzAPI_Map_Ladder_SetStat = (whichPlayer: any, key: string, value: string): void => {
  hjapi.exec("DzAPI_Map_Ladder_SetStat", whichPlayer, key, value);
};

hjapi.DzAPI_Map_Stat_SetStat = (whichPlayer: any, key: string, value: string): void => {
  hjapi.exec("DzAPI_Map_Stat_SetStat", whichPlayer, key, value);
};

hjapi.DzLoadToc = (fileName: string): void => {
  hjapi.exec("DzLoadToc", fileName);
};

hjapi.DzFrameFindByName = (name: string, id: number): number => {
  return hjapi.exec("DzFrameFindByName", name, id);
};

hjapi.DzCreateFrame = (frame: string, parent: number, id: number): number => {
  return hjapi.exec("DzCreateFrame", frame, parent, id);
};

hjapi.DzCreateSimpleFrame = (frame: string, parent: number, id: number): number => {
  return hjapi.exec("DzCreateSimpleFrame", frame, parent, id);
};

hjapi.DzDestroyFrame = (frame: number): void => {
  hjapi.exec("DzDestroyFrame", frame);
};

hjapi.DzFrameShow = (frame: number, enable: boolean): void => {
  hjapi.exec("DzFrameShow", frame, enable);
};

hjapi.DzFrameSetText = (frame: number, text: string): void => {
  hjapi.exec("DzFrameSetText", frame, text);
};

hjapi.DzFrameGetText = (frame: number): string => {
  return hjapi.exec("DzFrameGetText", frame);
};

hjapi.DzFrameSetPoint = (
  frame: number,
  point: number,
  relativeFrame: number,
  relativePoint: number,
  x: number,
  y: number,
): void => {
  hjapi.exec("DzFrameSetPoint", frame, point, relativeFrame, relativePoint, x, y);
};

hjapi.DzFrameSetAbsolutePoint = (frame: number, point: number, x: number, y: number): void => {
  hjapi.exec("DzFrameSetAbsolutePoint", frame, point, x, y);
};

hjapi.DzFrameClearAllPoints = (frame: number): void => {
  hjapi.exec("DzFrameClearAllPoints", frame);
};

hjapi.DzFrameSetSize = (frame: number, w: number, h: number): void => {
  hjapi.exec("DzFrameSetSize", frame, w, h);
};

hjapi.DzGetGameUI = (): number => {
  return hjapi.exec("DzGetGameUI", undefined as any);
};

hjapi.DzGetClientWidth = (): number => {
  return hjapi.exec("DzGetClientWidth", undefined as any);
};

hjapi.DzGetClientHeight = (): number => {
  return hjapi.exec("DzGetClientHeight", undefined as any);
};

hjapi.DzGetMouseXRelative = (): number => {
  return hjapi.exec("DzGetMouseXRelative", undefined as any);
};

hjapi.DzGetMouseYRelative = (): number => {
  return hjapi.exec("DzGetMouseYRelative", undefined as any);
};

// --------------------------------------------------------------------------------------
// 实用：Z / 像素比例换算（按原 lua 逻辑移植）
// --------------------------------------------------------------------------------------

hjapi.Z = (x: number, y: number): number => {
  if (typeof x === "number" && typeof y === "number") {
    const mf = math && typeof math.floor === "function" ? math.floor : undefined;
    const xx = typeof mf === "function" ? mf(x) : Math.floor(x);
    const yy = typeof mf === "function" ? mf(y) : Math.floor(y);
    const k = String(xx) + "_" + String(yy);
    if (hjapi._cache.Z[k] == null) {
      if (!cj || typeof cj.Location !== "function" || typeof cj.GetLocationZ !== "function" || typeof cj.RemoveLocation !== "function") {
        return 0;
      }
      const loc = cj.Location(xx, yy);
      const z = cj.GetLocationZ(loc);
      cj.RemoveLocation(loc);
      hjapi._cache.Z[k] = z;
    }
    return hjapi._cache.Z[k];
  }
  return 0;
};

hjapi.PX = (x: number): number => {
  return hjapi.DzGetClientWidth() * x / 0.8;
};

hjapi.PY = (y: number): number => {
  return hjapi.DzGetClientHeight() * y / 0.6;
};

hjapi.RX = (x: number): number => {
  return x / hjapi.DzGetClientWidth() * 0.8;
};

hjapi.RY = (y: number): number => {
  return y / hjapi.DzGetClientHeight() * 0.6;
};

hjapi.MousePX = (): number => {
  return hjapi.DzGetMouseXRelative();
};

hjapi.MousePY = (): number => {
  return hjapi.DzGetClientHeight() - hjapi.DzGetMouseYRelative();
};

hjapi.MouseRX = (): number => {
  return hjapi.RX(hjapi.MousePX());
};

hjapi.MouseRY = (): number => {
  return hjapi.RY(hjapi.MousePY());
};

hjapi.InWindow = (rx: number, ry: number): boolean => {
  return rx > 0 && rx < 0.8 && ry > 0 && ry < 0.6;
};

hjapi.InWindowMouse = (): boolean => {
  return hjapi.InWindow(hjapi.MouseRX(), hjapi.MouseRY());
};

// --------------------------------------------------------------------------------------
// 自动补齐：把原版 `TS/lib/japi.lua` 中的 hjapi 方法名全部挂到 TS 版上
// - 已手写的实现（如 Z/PX/...）会被保留
// - 其余方法默认走 hjapi.exec("Name", ...args)
// --------------------------------------------------------------------------------------

const AUTO_METHODS: string[] = [
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
  "IsEventAttackType",
];

for (let i = 0; i < AUTO_METHODS.length; i++) {
  const name = AUTO_METHODS[i];
  if (typeof (hjapi as any)[name] !== "function") {
    (hjapi as any)[name] = (...args: any[]) => hjapi.exec(name, ...args);
  }
}

export default hjapi;


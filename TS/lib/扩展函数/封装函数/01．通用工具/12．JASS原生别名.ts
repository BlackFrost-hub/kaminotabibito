/** @noSelfInFile */
/**
 * 小范围复用的 JASS 原生别名。
 *
 * 只收敛高频、稳定、纯函数式调用的 common.j 原生，
 * 避免每个业务文件重复声明同一批局部别名。
 */

const jass = require("jass.common") as any;
const {
  TriggerRegisterEnterRectSimple: BJTriggerRegisterEnterRectSimple,
} = require("lib.扩展函数.BJ函数.01．触发与事件") as {
  TriggerRegisterEnterRectSimple: (this: void, trig: any, r: any) => any;
};
const { GetUnitsInRectMatching: BJGetUnitsInRectMatching } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetUnitsInRectMatching: (this: void, r: any, filter: any) => any;
};

export const AddSpecialEffect = jass.AddSpecialEffect as (this: void, modelName: string, x: number, y: number) => any;
export const Condition = jass.Condition as (this: void, func: (this: void) => boolean) => any;
export const CreateFogModifierRect = jass.CreateFogModifierRect as (
  this: void,
  whichPlayer: any,
  whichState: any,
  where: any,
  useSharedVision: boolean,
  afterUnits: boolean,
) => any;
export const CreateItem = jass.CreateItem as (this: void, itemId: number, x: number, y: number) => any;
export const CreateTrigger = jass.CreateTrigger as (this: void) => any;
export const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
export const DestroyGroup = jass.DestroyGroup as (this: void, whichGroup: any) => void;
export const FirstOfGroup = jass.FirstOfGroup as (this: void, whichGroup: any) => any;
export const FogModifierStart = jass.FogModifierStart as (this: void, whichFog: any) => void;
export const GetEnumUnit = jass.GetEnumUnit as (this: void) => any;
export const GetFilterUnit = jass.GetFilterUnit as (this: void) => any;
export const GetRandomReal = jass.GetRandomReal as (this: void, lowBound: number, highBound: number) => number;
export const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
export const GetUnitTypeId = jass.GetUnitTypeId as (this: void, whichUnit: any) => number;
export const GetUnitX = jass.GetUnitX as (this: void, whichUnit: any) => number;
export const GetUnitY = jass.GetUnitY as (this: void, whichUnit: any) => number;
export const GetUnitsInRectMatching = BJGetUnitsInRectMatching;
export const GroupRemoveUnit = jass.GroupRemoveUnit as (this: void, whichGroup: any, whichUnit: any) => void;
export const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
export const IsUnitInGroup = jass.IsUnitInGroup as (this: void, whichUnit: any, whichGroup: any) => boolean;
export const Location = jass.Location as (this: void, x: number, y: number) => any;
export const PauseUnit = jass.PauseUnit as (this: void, whichUnit: any, flag: boolean) => void;
export const Player = jass.Player as (this: void, whichPlayer: number) => any;
export const RemoveLocation = jass.RemoveLocation as (this: void, whichLocation: any) => void;
export const RemoveRect = jass.RemoveRect as (this: void, whichRect: any) => void;
export const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;
export const SetUnitFacingTimed = jass.SetUnitFacingTimed as (this: void, whichUnit: any, facing: number, duration: number) => void;
export const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;
export const SetUnitOwner = jass.SetUnitOwner as (this: void, whichUnit: any, whichPlayer: any, changeColor: boolean) => void;
export const StopMusic = jass.StopMusic as (this: void, fadeOut: boolean) => void;
export const TriggerAddAction = jass.TriggerAddAction as (this: void, trig: any, action: (this: void) => void) => any;
export const TriggerRegisterEnterRectSimple = BJTriggerRegisterEnterRectSimple;

export const FOG_OF_WAR_VISIBLE = jass.FOG_OF_WAR_VISIBLE as number;
export const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;

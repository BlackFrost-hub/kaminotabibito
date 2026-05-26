/** @noSelfInFile */

const jass = require("jass.common") as any;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { 按名字反查Boss单位ID } = require("系统.01．单位系统.08．单位配置表.02．Boss配置表") as {
  按名字反查Boss单位ID: (this: void, name: string) => string | undefined;
};
const { TriggerRegisterUnitInRangeSimple } = require("lib.扩展函数.BJ函数.01．触发与事件") as {
  TriggerRegisterUnitInRangeSimple: (this: void, trig: any, range: number, whichUnit: any) => any;
};

import { 写入当前剧情动作上下文 } from "./01．剧情动作上下文";
import { 读取剧情进度 } from "./01．剧情动作上下文";

const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const GetTriggeringTrigger = jass.GetTriggeringTrigger as (this: void) => any;
const PauseUnit = jass.PauseUnit as (this: void, whichUnit: any, flag: boolean) => void;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;
const StopMusic = jass.StopMusic as (this: void, fadeOut: boolean) => void;
const TriggerAddAction = jass.TriggerAddAction as (this: void, trig: any, action: (this: void) => void) => any;

interface 剧情Boss范围预置触发配置 {
  配置名: string;
  剧情片段ID?: string;
  Boss键?: string;
  需要剧情进度?: number;
}

interface 剧情Boss预置参数 {
  Boss键?: string;
  Boss名: string;
  X: number;
  Y: number;
  朝向?: number;
  注册范围?: number;
  预创建后暂停?: boolean;
  预创建后无敌?: boolean;
  范围触发配置名?: string;
  范围触发剧情片段ID?: string;
  需要剧情进度?: number;
}

const 范围预置触发配置表: Record<number, 剧情Boss范围预置触发配置> = {};

function 解析Boss表键(this: void, boss键: string | undefined): { 表名: string; 键名: string } {
  if (boss键 == null || boss键 === "") return { 表名: "Boss", 键名: "" };
  const splitIndex = boss键.indexOf(".");
  if (splitIndex < 0) return { 表名: "Boss", 键名: boss键 };
  return {
    表名: boss键.substring(0, splitIndex),
    键名: boss键.substring(splitIndex + 1),
  };
}

function on剧情Boss范围预置触发(this: void): void {
  const trigger = GetTriggeringTrigger();
  if (trigger == null || trigger === 0) return;

  const 配置 = 范围预置触发配置表[GetHandleId(trigger)];
  if (配置 == null) return;
  if (配置.需要剧情进度 != null && 读取剧情进度() !== 配置.需要剧情进度) return;

  写入当前剧情动作上下文({
    片段ID: 配置.剧情片段ID,
    触发配置名: 配置.配置名,
    触发单位: GetTriggerUnit(),
  });
  if (配置.剧情片段ID != null && 配置.剧情片段ID !== "") {
    const { 播放主线剧情片段 } = require("../02．剧情步骤") as {
      播放主线剧情片段: (this: void, 片段ID: string) => boolean;
    };
    播放主线剧情片段(配置.剧情片段ID);
  }
}

export function 注册剧情Boss范围预置触发器(
  this: void,
  bossUnit: any,
  注册范围: number,
  配置名: string,
  剧情片段ID?: string,
  Boss键?: string,
  需要剧情进度?: number,
): any {
  if (bossUnit == null || bossUnit === 0) return null;
  if (!(注册范围 > 0)) return null;

  const trigger = CreateTrigger();
  TriggerAddAction(trigger, on剧情Boss范围预置触发);
  TriggerRegisterUnitInRangeSimple(trigger, 注册范围, bossUnit);
  范围预置触发配置表[GetHandleId(trigger)] = {
    配置名,
    剧情片段ID,
    Boss键,
    需要剧情进度,
  };
  return trigger;
}

export function 创建并冻结剧情Boss预置(this: void, 参数: 剧情Boss预置参数): any {
  const rawId = 按名字反查Boss单位ID(参数.Boss名);
  const unitTypeId = stringToFourCCSafe(rawId);
  if (!(unitTypeId > 0)) return null;

  StopMusic(false);

  const bossUnit = CreateUnit(Player(15), unitTypeId, 参数.X, 参数.Y, 参数.朝向 ?? 0);
  if (bossUnit == null || bossUnit === 0) return null;

  if (参数.预创建后暂停 === true) {
    PauseUnit(bossUnit, true);
  }
  if (参数.预创建后无敌 === true) {
    SetUnitInvulnerable(bossUnit, true);
  }

  const 键信息 = 解析Boss表键(参数.Boss键);
  if (键信息.键名 !== "") {
    YDUserDataSetSafe("string", 键信息.表名, 键信息.键名, "unit", bossUnit);
  }

  if ((参数.注册范围 ?? 0) > 0) {
    注册剧情Boss范围预置触发器(
      bossUnit,
      参数.注册范围 ?? 0,
      参数.范围触发配置名 ?? `${参数.Boss名}范围预置触发`,
      参数.范围触发剧情片段ID,
      参数.Boss键,
      参数.需要剧情进度,
    );
  }

  return bossUnit;
}

/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (h: any) => number;
const SetUnitX = jass.SetUnitX as (whichUnit: any, newX: number) => void;
const SetUnitY = jass.SetUnitY as (whichUnit: any, newY: number) => void;
const ShowUnit = jass.ShowUnit as (whichUnit: any, show: boolean) => void;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD;

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

export interface 隐藏移动再出现参数 {
  单位: any;
  目标X: number;
  目标Y: number;
  隐藏时间秒: number;
  on隐藏?: (this: void, 单位: any) => void;
  on出现?: (this: void, 单位: any) => void;
  on取消?: (this: void, 单位: any) => void;
}

interface 隐藏移动任务 {
  单位: any;
  到期时间Ms: number;
  on出现?: (this: void, 单位: any) => void;
  on取消?: (this: void, 单位: any) => void;
}

let 隐藏移动驱动ID = 0;
const 隐藏移动任务表: Record<number, 隐藏移动任务> = {};

function 确保隐藏移动驱动(this: void): void {
  if (隐藏移动驱动ID !== 0) return;
  隐藏移动驱动ID = addPeriodicCallback(50, on隐藏移动再出现Tick);
}

function 尝试停止隐藏移动驱动(this: void): void {
  for (const key in 隐藏移动任务表) {
    if (隐藏移动任务表[key] != null) return;
  }
  if (隐藏移动驱动ID !== 0) {
    removePeriodicCallback(隐藏移动驱动ID);
    隐藏移动驱动ID = 0;
  }
}

function on隐藏移动再出现Tick(this: void): void {
  const now = getServerTime();
  for (const key in 隐藏移动任务表) {
    const 任务 = 隐藏移动任务表[key];
    if (任务 == null || now < 任务.到期时间Ms) continue;

    const 单位 = 任务.单位;
    delete 隐藏移动任务表[key];
    if (单位 == null || 单位 === 0 || IsUnitType(单位, UNIT_TYPE_DEAD)) {
      if (任务.on取消 != null) 任务.on取消(单位);
      continue;
    }

    ShowUnit(单位, true);
    if (任务.on出现 != null) 任务.on出现(单位);
  }
  尝试停止隐藏移动驱动();
}

export function 隐藏移动再出现(this: void, 参数: 隐藏移动再出现参数): void {
  const 单位 = 参数.单位;
  if (单位 == null || 单位 === 0 || IsUnitType(单位, UNIT_TYPE_DEAD)) return;

  const 单位ID = GetHandleId(单位);
  if (隐藏移动任务表[单位ID] != null) {
    const 旧任务 = 隐藏移动任务表[单位ID];
    delete 隐藏移动任务表[单位ID];
    ShowUnit(单位, true);
    if (旧任务.on取消 != null) 旧任务.on取消(单位);
  }

  ShowUnit(单位, false);
  SetUnitX(单位, 参数.目标X);
  SetUnitY(单位, 参数.目标Y);
  if (参数.on隐藏 != null) 参数.on隐藏(单位);

  隐藏移动任务表[单位ID] = {
    单位,
    到期时间Ms: getServerTime() + 参数.隐藏时间秒 * 1000,
    on出现: 参数.on出现,
    on取消: 参数.on取消,
  };
  确保隐藏移动驱动();
}

export function 取消隐藏移动再出现(this: void, 单位: any, 是否显示: boolean = true): void {
  if (单位 == null || 单位 === 0) return;
  const 单位ID = GetHandleId(单位);
  const 任务 = 隐藏移动任务表[单位ID];
  if (任务 == null) return;
  delete 隐藏移动任务表[单位ID];
  if (是否显示) ShowUnit(单位, true);
  if (任务.on取消 != null) 任务.on取消(单位);
  尝试停止隐藏移动驱动();
}

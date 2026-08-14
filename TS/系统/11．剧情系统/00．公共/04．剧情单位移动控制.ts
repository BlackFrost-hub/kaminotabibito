/** @noSelfInFile */

const jass = require("jass.common") as any;
const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};

const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, unit: any, order: string) => boolean;
const IssuePointOrder = jass.IssuePointOrder as (this: void, unit: any, order: string, x: number, y: number) => boolean;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;

export interface 剧情单位移动配置 {
  单位: any;
  目标X: number;
  目标Y: number;
  到达距离?: number;
  检查间隔毫秒?: number;
  移动命令?: string;
  /** 默认持续补发移动命令，避免中立单位的原生游荡逻辑重新接管。 */
  补发移动命令?: boolean;
  /** 默认抵达后发布 holdposition；传入 false 可关闭。 */
  到达命令?: string | false;
  到达朝向?: number;
  /** 返回 false 时立即中止并排泄周期任务。 */
  是否继续?: (this: void, unit: any) => boolean;
  到达回调?: (this: void, unit: any) => void;
  中止回调?: (this: void, unit: any) => void;
}

export interface 剧情单位移动控制器 {
  取消(this: void): void;
  是否运行(this: void): boolean;
  是否到达(this: void): boolean;
}

interface 运行中移动任务 {
  配置: 剧情单位移动配置;
  控制器: 剧情单位移动控制器;
  回调ID: number;
  运行中: boolean;
  已到达: boolean;
}

const 运行中移动任务列表: 运行中移动任务[] = [];

function 单位可移动(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitTypeId(unit) !== 0 && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 从运行列表移除(this: void, 任务: 运行中移动任务): void {
  const index = 运行中移动任务列表.indexOf(任务);
  if (index >= 0) 运行中移动任务列表.splice(index, 1);
}

function 停止移动任务(this: void, 任务: 运行中移动任务, 执行中止回调: boolean): void {
  if (!任务.运行中) return;
  任务.运行中 = false;
  if (任务.回调ID !== 0) {
    removePeriodicCallback(任务.回调ID);
    任务.回调ID = 0;
  }
  从运行列表移除(任务);
  if (执行中止回调 && 任务.配置.中止回调 != null) 任务.配置.中止回调(任务.配置.单位);
}

function on剧情单位移动Tick(this: void, variable?: any): void {
  const 任务 = variable as 运行中移动任务 | undefined;
  if (任务 == null || !任务.运行中) return;

  const 配置 = 任务.配置;
  if (!单位可移动(配置.单位) || (配置.是否继续 != null && !配置.是否继续(配置.单位))) {
    停止移动任务(任务, true);
    return;
  }

  const dx = GetUnitX(配置.单位) - 配置.目标X;
  const dy = GetUnitY(配置.单位) - 配置.目标Y;
  const 到达距离 = 配置.到达距离 ?? 96;
  if (dx * dx + dy * dy <= 到达距离 * 到达距离) {
    任务.已到达 = true;
    const 到达命令 = 配置.到达命令 === undefined ? "holdposition" : 配置.到达命令;
    if (到达命令 !== false) IssueImmediateOrder(配置.单位, 到达命令);
    if (配置.到达朝向 != null) SetUnitFacing(配置.单位, 配置.到达朝向);
    停止移动任务(任务, false);
    if (配置.到达回调 != null) 配置.到达回调(配置.单位);
    return;
  }

  if (配置.补发移动命令 !== false) {
    IssuePointOrder(配置.单位, 配置.移动命令 ?? "move", 配置.目标X, 配置.目标Y);
  }
}

/**
 * 驱动剧情单位走到目标并可靠停留。同一单位开始新任务时会自动取消旧任务，
 * 所有完成、失效和手动取消路径都会注销中心计时器回调。
 */
export function 开始剧情单位保持移动(this: void, 配置: 剧情单位移动配置): 剧情单位移动控制器 | undefined {
  if (!单位可移动(配置.单位)) return undefined;

  for (let i = 运行中移动任务列表.length - 1; i >= 0; i--) {
    const 旧任务 = 运行中移动任务列表[i];
    if (旧任务.配置.单位 === 配置.单位) 停止移动任务(旧任务, false);
  }

  const 任务 = {} as 运行中移动任务;
  const 控制器: 剧情单位移动控制器 = {
    取消: () => 停止移动任务(任务, false),
    是否运行: () => 任务.运行中,
    是否到达: () => 任务.已到达,
  };
  任务.配置 = 配置;
  任务.控制器 = 控制器;
  任务.回调ID = 0;
  任务.运行中 = true;
  任务.已到达 = false;
  运行中移动任务列表.push(任务);

  IssuePointOrder(配置.单位, 配置.移动命令 ?? "move", 配置.目标X, 配置.目标Y);
  任务.回调ID = addPeriodicCallback(配置.检查间隔毫秒 ?? 400, on剧情单位移动Tick, 任务);
  return 控制器;
}

export {};

/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { 是否黑天 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.05．昼夜状态") as {
  是否黑天: (this: void) => boolean;
};
const { 转四位ID } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  转四位ID: (this: void, rawIdText: string) => number;
};
const { 创建周期机制调度器 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.17．周期机制调度器") as {
  创建周期机制调度器: (this: void, 参数: any) => 周期机制调度器;
};
const { 取单位ID, 单位未标记死亡 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  取单位ID: (this: void, unit: any) => number;
  单位未标记死亡: (this: void, unit: any) => boolean;
};
const { 赫萝单位技能配置 } = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.02．赫萝.00．配置") as {
  赫萝单位技能配置: {
    单位ID: string;
    检查间隔Ms: number;
    黑夜单位状态值: number;
    白天单位状态值: number;
    黑夜移速: number;
    白天移速: number;
  };
};

const GetUnitTypeId = jass.GetUnitTypeId as (whichUnit: any) => number;
const SetUnitStateJapi = japi.SetUnitState as (whichUnit: any, whichUnitState: number, value: number) => void;
const SetUnitMoveSpeed = jass.SetUnitMoveSpeed as (whichUnit: any, newSpeed: number) => void;
const ConvertUnitState = jass.ConvertUnitState as (state: number) => number;

const 赫萝单位类型ID = 转四位ID(赫萝单位技能配置.单位ID);
interface 赫萝昼夜被动单位记录 {
  句柄ID: number;
  单位: any;
}

interface 赫萝昼夜被动上下文 {
  单位列表: 赫萝昼夜被动单位记录[];
}

interface 周期机制调度器 {
  启动(): void;
  停止(): void;
  是否运行中(): boolean;
}

const 赫萝昼夜被动上下文: 赫萝昼夜被动上下文 = { 单位列表: [] };
const 赫萝昼夜被动上下文列表 = [赫萝昼夜被动上下文];
let 赫萝昼夜被动调度器: 周期机制调度器 | undefined;

function 应用赫萝昼夜状态(this: void, unit: any): void {
  if (!单位未标记死亡(unit)) return;
  if (GetUnitTypeId(unit) !== 赫萝单位类型ID) return;

  if (是否黑天()) {
    SetUnitStateJapi(unit, ConvertUnitState(0x25), 赫萝单位技能配置.黑夜单位状态值);
    SetUnitMoveSpeed(unit, 赫萝单位技能配置.黑夜移速);
  } else {
    SetUnitStateJapi(unit, ConvertUnitState(0x25), 赫萝单位技能配置.白天单位状态值);
    SetUnitMoveSpeed(unit, 赫萝单位技能配置.白天移速);
  }
}

function 处理赫萝昼夜被动Tick(this: void): void {
  const list = 赫萝昼夜被动上下文.单位列表;
  for (let i = list.length - 1; i >= 0; i--) {
    const record = list[i];
    if (!单位未标记死亡(record.单位)) {
      list.splice(i, 1);
      continue;
    }
    应用赫萝昼夜状态(record.单位);
  }

  if (list.length === 0) 赫萝昼夜被动调度器?.停止();
}

export function 启动赫萝昼夜被动(this: void, unit: any): void {
  if (unit == null || unit === 0) return;
  if (GetUnitTypeId(unit) !== 赫萝单位类型ID) return;

  const handleId = 取单位ID(unit);
  if (handleId === 0) return;

  const list = 赫萝昼夜被动上下文.单位列表;
  let found = false;
  for (let i = 0; i < list.length; i++) {
    if (list[i].句柄ID !== handleId) continue;
    list[i].单位 = unit;
    found = true;
    break;
  }
  if (!found) list.push({ 句柄ID: handleId, 单位: unit });
  if (赫萝昼夜被动调度器 == null) {
    赫萝昼夜被动调度器 = 创建周期机制调度器({
      名称: "赫萝-昼夜被动",
      间隔毫秒: 赫萝单位技能配置.检查间隔Ms,
      自动启动: false,
      取上下文列表: function 取赫萝昼夜被动上下文列表(this: void): 赫萝昼夜被动上下文[] {
        return 赫萝昼夜被动上下文列表;
      },
      可执行: function 赫萝昼夜被动可执行(this: void, context: 赫萝昼夜被动上下文): boolean {
        return context.单位列表.length > 0;
      },
      执行: function 执行赫萝昼夜被动Tick(this: void, _context: 赫萝昼夜被动上下文): void {
        处理赫萝昼夜被动Tick();
      },
    });
  }
  if (!赫萝昼夜被动调度器.是否运行中()) 赫萝昼夜被动调度器.启动();
  应用赫萝昼夜状态(unit);
}

export function 停止赫萝昼夜被动(this: void, unit: any): void {
  const handleId = 取单位ID(unit);
  if (handleId === 0) return;

  const list = 赫萝昼夜被动上下文.单位列表;
  for (let i = list.length - 1; i >= 0; i--) {
    if (list[i].句柄ID === handleId) list.splice(i, 1);
  }
  if (list.length === 0) 赫萝昼夜被动调度器?.停止();
}

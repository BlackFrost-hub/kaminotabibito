/** @noSelfInFile */

import { 创建机制清理篮子, 机制清理篮子 } from "../../../00．技能模板+函数/04．机制组件/06．机制清理";
import { 设置单位技能壳普通提示 } from "../../../00．技能模板+函数/02．通用函数/15．单位技能壳提示";
import { 巴尔扎罗斯场地矩形组, 创建巴尔扎罗斯战斗区域组, 清理巴尔扎罗斯战斗区域组 } from "./01．场地配置";
import { 巴尔扎罗斯单位技能配置 } from "./00．配置";

const jass = require("jass.common") as any;
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;

export type 巴尔扎罗斯阶段 = 1 | 2 | 3;

export interface 巴尔扎罗斯运行时上下文 {
  Boss单位: any;
  阶段: 巴尔扎罗斯阶段;
  开战时间Ms: number;
  清理: 机制清理篮子;
  战斗区域组: 巴尔扎罗斯场地矩形组;
  护卫机制已初始化: boolean;
  格鲁姆技能已初始化: boolean;
  塞拉技能已初始化: boolean;
  格鲁姆?: any;
  塞拉?: any;
  塞拉当前形态?: "火焰" | "冰霜";
  熔核封印已解除: boolean;
  地核召唤节点已初始化: boolean;
  熔岩护盾节点已初始化: boolean;
  末日熔爆节点已初始化: boolean;
  末日熔爆引导中: boolean;
  末日熔爆下一次允许Ms: number;
  已触发低血量末日熔爆: boolean;
  元素安全印记列表: Array<{ X: number; Y: number }>;
  测试固定安全区配置表?: Array<{ ID?: string; 名称?: string; 左: number; 右: number; 下: number; 上: number }>;
  恶魔咆哮波命中记录: Record<number, number>;
  王者天罚命中记录: Record<number, number>;
}

const 巴尔扎罗斯上下文表: Record<number, 巴尔扎罗斯运行时上下文 | undefined> = {};

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

export function 获取巴尔扎罗斯上下文(this: void, boss: any): 巴尔扎罗斯运行时上下文 | undefined {
  const id = 取单位ID(boss);
  return id === 0 ? undefined : 巴尔扎罗斯上下文表[id];
}

export function 获取或创建巴尔扎罗斯上下文(this: void, boss: any): 巴尔扎罗斯运行时上下文 | undefined {
  const id = 取单位ID(boss);
  if (id === 0) return undefined;
  let context = 巴尔扎罗斯上下文表[id];
  if (context != null) return context;

  context = {
    Boss单位: boss,
    阶段: 1,
    开战时间Ms: getServerTime(),
    清理: 创建机制清理篮子("巴尔扎罗斯"),
    战斗区域组: 创建巴尔扎罗斯战斗区域组(),
    护卫机制已初始化: false,
    格鲁姆技能已初始化: false,
    塞拉技能已初始化: false,
    熔核封印已解除: false,
    地核召唤节点已初始化: false,
    熔岩护盾节点已初始化: false,
    末日熔爆节点已初始化: false,
    末日熔爆引导中: false,
    末日熔爆下一次允许Ms: 0,
    已触发低血量末日熔爆: false,
    元素安全印记列表: [],
    恶魔咆哮波命中记录: {},
    王者天罚命中记录: {},
  };
  设置单位技能壳普通提示(boss, 巴尔扎罗斯单位技能配置.主动技能提示);
  巴尔扎罗斯上下文表[id] = context;
  return context;
}

export function 清理巴尔扎罗斯上下文(this: void, boss: any): void {
  const id = 取单位ID(boss);
  if (id === 0) return;
  const context = 巴尔扎罗斯上下文表[id];
  if (context == null) return;
  context.清理.清理全部();
  清理巴尔扎罗斯战斗区域组(context.战斗区域组);
  delete 巴尔扎罗斯上下文表[id];
}

export function 注册巴尔扎罗斯运行时(this: void): void {
  // 后续接入 Boss 战启动/AI 时再注册周期推进，当前只落结构。
}

export function 记录巴尔扎罗斯元素安全印记(this: void, boss: any, x: number, y: number): void {
  const context = 获取或创建巴尔扎罗斯上下文(boss);
  if (context == null) return;
  context.元素安全印记列表.push({ X: x, Y: y });
}

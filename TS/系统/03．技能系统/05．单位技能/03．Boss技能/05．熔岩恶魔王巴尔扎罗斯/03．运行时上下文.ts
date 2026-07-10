/** @noSelfInFile */

import type { 机制清理篮子 } from "../../../00．技能模板+函数/04．机制组件/06．机制清理";
import { 创建单位运行时上下文工厂 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/15．单位运行时上下文工厂";
import { 巴尔扎罗斯场地矩形组, 创建巴尔扎罗斯战斗区域组, 清理巴尔扎罗斯战斗区域组 } from "./01．场地配置";
import { 巴尔扎罗斯单位技能配置 } from "./00．配置";
import { 播放巴尔扎罗斯台词 } from "./14．台词播放";
import { stringToFourCC } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const jass = require("jass.common") as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const 巴尔扎罗斯单位类型ID = stringToFourCC(巴尔扎罗斯单位技能配置.单位ID);

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
  阶段3台词最早Ms: number;
}

function 创建巴尔扎罗斯上下文(this: void, boss: any, 清理: 机制清理篮子): 巴尔扎罗斯运行时上下文 {
  const context: 巴尔扎罗斯运行时上下文 = {
    Boss单位: boss,
    阶段: 1,
    开战时间Ms: getServerTime(),
    清理,
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
    阶段3台词最早Ms: 0,
  };
  播放巴尔扎罗斯台词(boss, "开场", 0);
  return context;
}

const 巴尔扎罗斯上下文工厂 = 创建单位运行时上下文工厂<巴尔扎罗斯运行时上下文>({
  名称: "巴尔扎罗斯",
  主动技能提示: 巴尔扎罗斯单位技能配置.主动技能提示,
  创建上下文: 创建巴尔扎罗斯上下文,
  on清理: function 巴尔扎罗斯上下文清理战斗区域(this: void, context: 巴尔扎罗斯运行时上下文): void {
    清理巴尔扎罗斯战斗区域组(context.战斗区域组);
  },
});

export function 获取巴尔扎罗斯上下文(this: void, boss: any): 巴尔扎罗斯运行时上下文 | undefined {
  return 巴尔扎罗斯上下文工厂.获取(boss);
}

export function 获取或创建巴尔扎罗斯上下文(this: void, boss: any): 巴尔扎罗斯运行时上下文 | undefined {
  return 巴尔扎罗斯上下文工厂.获取或创建(boss);
}

export function 清理巴尔扎罗斯上下文(this: void, boss: any): void {
  巴尔扎罗斯上下文工厂.清理上下文(boss);
}

let 巴尔扎罗斯死亡台词监听已注册 = false;

function on巴尔扎罗斯死亡台词(this: void, dyingUnit: any): void {
  if (GetUnitTypeId(dyingUnit) !== 巴尔扎罗斯单位类型ID) return;
  播放巴尔扎罗斯台词(dyingUnit, "死亡", 0);
}

export function 注册巴尔扎罗斯运行时(this: void): void {
  if (巴尔扎罗斯死亡台词监听已注册) return;
  巴尔扎罗斯死亡台词监听已注册 = true;
  registerDeathListener(on巴尔扎罗斯死亡台词);
}

export function 记录巴尔扎罗斯元素安全印记(this: void, boss: any, x: number, y: number): void {
  const context = 获取或创建巴尔扎罗斯上下文(boss);
  if (context == null) return;
  context.元素安全印记列表.push({ X: x, Y: y });
}

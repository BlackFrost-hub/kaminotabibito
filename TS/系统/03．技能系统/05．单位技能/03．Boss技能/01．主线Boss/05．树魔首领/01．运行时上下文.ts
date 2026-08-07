/** @noSelfInFile */

import type { 机制清理篮子 } from "../../../../00．技能模板+函数/04．机制组件/06．机制清理";
import { 创建召唤物组状态, 召唤物组状态 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/03．召唤物组状态管理";
import { 创建单位运行时上下文工厂 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/15．单位运行时上下文工厂";
import { 播放树魔首领台词 } from "./08．台词播放";

const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
export type 树魔首领阶段 = 1 | 2 | 3;

export interface 树魔首领运行时上下文 {
  Boss单位: any;
  阶段: 树魔首领阶段;
  开战时间Ms: number;
  清理: 机制清理篮子;
  随从组: 召唤物组状态;
  随从特性已初始化: boolean;
  剧情带入随从已登记: boolean;
  当前随从数量: number;
  当前兽群层数: number;
  兽群攻击力增量: number;
  无从暴怒中: boolean;
  暴怒持续特效: any;
  暴怒攻速增量: number;
  暴怒移速增量: number;
  下一次召唤Ms: number;
  已初始化: boolean;
}

function 创建树魔首领上下文(this: void, boss: any, 清理: 机制清理篮子): 树魔首领运行时上下文 {
  播放树魔首领台词(boss, "开场", 0);
  return {
    Boss单位: boss,
    阶段: 1,
    开战时间Ms: getServerTime(),
    清理,
    随从组: 创建召唤物组状态({
      清理,
      名称: "树魔首领随从组",
      全灭延迟秒: 0,
      全灭后保留死亡记录: false,
    }),
    随从特性已初始化: false,
    剧情带入随从已登记: false,
    当前随从数量: 0,
    当前兽群层数: 0,
    兽群攻击力增量: 0,
    无从暴怒中: false,
    暴怒持续特效: null,
    暴怒攻速增量: 0,
    暴怒移速增量: 0,
    下一次召唤Ms: 0,
    已初始化: false,
  };
}

const 树魔首领上下文工厂 = 创建单位运行时上下文工厂<树魔首领运行时上下文>({
  名称: "树魔首领",
  创建上下文: 创建树魔首领上下文,
  on单位死亡: on树魔首领死亡台词,
  死亡时自动清理: true,
});

export function 获取树魔首领上下文(this: void, boss: any): 树魔首领运行时上下文 | undefined {
  return 树魔首领上下文工厂.获取(boss);
}

export function 获取或创建树魔首领上下文(this: void, boss: any): 树魔首领运行时上下文 | undefined {
  return 树魔首领上下文工厂.获取或创建(boss);
}

export function 清理树魔首领上下文(this: void, boss: any): void {
  树魔首领上下文工厂.清理上下文(boss);
}

export function 获取全部树魔首领上下文(this: void): 树魔首领运行时上下文[] {
  return 树魔首领上下文工厂.获取全部();
}

function on树魔首领死亡台词(this: void, _context: 树魔首领运行时上下文, dyingUnit: any, _killingUnit: any): void {
  播放树魔首领台词(dyingUnit, "死亡", 0);
}

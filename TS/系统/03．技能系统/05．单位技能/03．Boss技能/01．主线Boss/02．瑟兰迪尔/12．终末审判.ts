/** @noSelfInFile */

import { 单位存活 as 单位有效, 距离平方XY as 距离平方 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 瑟兰迪尔运行时上下文 } from "./03．运行时上下文";
import { 瑟兰迪尔数值与表现配置 } from "./02．数值与表现配置";
import { 播放瑟兰迪尔台词 } from "./15．台词播放";
import { 执行BossAOE技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
import { 创建固定组合技能执行器 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器";
import { 创建固定时间轴阶段列表, type 固定时间轴事件 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/02．固定时间轴阶段工厂";
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 开始硬直 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, durationSec: number) => void;
};
const { 显示大招吟唱条, 关闭吟唱条 } = require("系统.09．表现系统.08．吟唱条.06．对外接口") as {
  显示大招吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.index") as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number, model?: any) => any;
};

const { 创建独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  创建独立技能伤害实例: (this: void, 参数?: any) => number;
};
const jass = require("jass.common") as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;

function 播放点特效(this: void, model: string, x: number, y: number, duration = 1, scale = 1): void {
  创建点特效({ 模型路径: model, X: x, Y: y, 缩放: scale, 持续秒: duration });
}

function 播放Boss蓄力Tick(this: void, boss: any): void {
  const config = 瑟兰迪尔数值与表现配置.终末审判;
  const x = GetUnitX(boss);
  const y = GetUnitY(boss);
  SetUnitTimeScale(boss, config.蓄力动画速度);
  SetUnitAnimationByIndex(boss, config.蓄力动画编号);
  播放点特效(config.蓄力特效, x, y, 0.6, config.蓄力法阵缩放);
  播放点特效(config.法阵叠加特效, x, y, 0.6, config.蓄力法阵缩放);
}

function 创建终末审判爆炸特效(this: void, x: number, y: number): void {
  const config = 瑟兰迪尔数值与表现配置.终末审判;
  播放点特效(config.爆炸特效, x, y, 2);
  播放点特效(config.爆炸特效2, x, y, 2);
  播放点特效(config.爆炸特效3, x, y, 2);
}

function 播放终末审判主结算音效(this: void, x: number, y: number): void {
  const config = 瑟兰迪尔数值与表现配置.终末审判;
  Sound3DII_CooPlayReuse(config.结算主冲击音效, x, y, 0, config.结算音效裁断距离);
}

function 播放终末审判扩散音效(this: void, x: number, y: number): void {
  const config = 瑟兰迪尔数值与表现配置.终末审判;
  Sound3DII_CooPlayReuse(config.结算扩散音效, x, y, 0, config.结算音效裁断距离);
}

function 计算爆炸特效前置延迟毫秒(this: void): number {
  const config = 瑟兰迪尔数值与表现配置.终末审判;
  const delayMs = config.爆炸延迟秒 * 1000 - config.爆炸特效提前毫秒;
  if (delayMs < 0) return 0;
  return delayMs;
}

function 创建终末审判时间轴事件(this: void, context: 瑟兰迪尔运行时上下文): 固定时间轴事件[] {
  const config = 瑟兰迪尔数值与表现配置.终末审判;
  const boss = context.Boss单位;
  const 引导毫秒 = config.引导秒 * 1000;
  const 爆炸毫秒 = 引导毫秒 + config.爆炸延迟秒 * 1000;
  const 事件列表: 固定时间轴事件[] = [];
  const xs: number[] = [];
  const ys: number[] = [];
  const targets: any[] = [];
  let 技能实例ID = 0;
  let 结算X = 0;
  let 结算Y = 0;

  for (let 时点毫秒 = 0; 时点毫秒 < 引导毫秒; 时点毫秒 += config.蓄力Tick毫秒) {
    事件列表.push({
      时点毫秒,
      名称: "终末审判蓄力",
      执行: function 瑟兰迪尔终末审判蓄力Tick(this: void): void {
        if (单位有效(boss)) 播放Boss蓄力Tick(boss);
      },
    });
  }

  事件列表.splice(0, 0, {
    时点毫秒: 0,
    名称: "终末审判开始",
    执行: function 瑟兰迪尔终末审判开始(this: void): void {
      if (!单位有效(boss)) return;
      技能实例ID = 创建独立技能伤害实例({
        来源类型: "Boss技能",
        标签: "瑟兰迪尔终末审判",
        持续时间秒: config.引导秒 + config.爆炸延迟秒 + 2,
      });
      播放瑟兰迪尔台词(boss, "终末审判");
      开始硬直(boss, config.引导秒);
      显示大招吟唱条({
        总时长: config.引导秒,
        颜色ID: config.吟唱条颜色ID,
        标题文本: config.吟唱条标题文本,
        提示文本: config.吟唱条提示文本,
      });
    },
  });

  事件列表.push({
    时点毫秒: 引导毫秒,
    名称: "终末审判布阵",
    执行: function 瑟兰迪尔终末审判布阵(this: void): void {
      关闭吟唱条("大招");
      if (!单位有效(boss)) return;
      SetUnitTimeScale(boss, config.结算动画速度);
      SetUnitAnimationByIndex(boss, config.结算动画编号);
      结算X = GetUnitX(boss);
      结算Y = GetUnitY(boss);
      播放点特效(config.蓄力完成特效, 结算X, 结算Y, 2, config.蓄力完成冲击缩放);
      播放点特效(config.警示特效, 结算X, 结算Y, config.爆炸延迟秒 + 0.5, config.场地法阵缩放);
      播放点特效(config.法阵叠加特效, 结算X, 结算Y, config.爆炸延迟秒 + 0.5, config.场地法阵缩放);
      创建技能提示圈({
        类型: "白色安全圆",
        X: 结算X,
        Y: 结算Y,
        半径: config.安全区半径,
        持续时间: config.爆炸延迟秒 + 0.5,
      });
      const heroes = 获取Boss技能敌对英雄列表(boss);
      for (let i = 0; i < heroes.length; i++) {
        const target = heroes[i];
        xs.push(GetUnitX(target));
        ys.push(GetUnitY(target));
        targets.push(target);
      }
    },
  });

  事件列表.push({
    时点毫秒: 引导毫秒 + config.恢复动作延迟Ms,
    名称: "终末审判恢复动作",
    执行: function 瑟兰迪尔终末审判恢复动作(this: void): void {
      if (!单位有效(boss)) return;
      SetUnitTimeScale(boss, config.恢复动画速度);
      SetUnitAnimationByIndex(boss, config.恢复动画编号);
    },
  });

  事件列表.push({
    时点毫秒: 引导毫秒 + 计算爆炸特效前置延迟毫秒(),
    名称: "终末审判爆炸预表现",
    执行: function 瑟兰迪尔终末审判爆炸预表现(this: void): void {
      if (!单位有效(boss)) return;
      for (let i = 0; i < targets.length; i++) {
        if (!单位有效(targets[i])) continue;
        创建终末审判爆炸特效(xs[i], ys[i]);
      }
    },
  });

  事件列表.push({
    时点毫秒: 爆炸毫秒,
    名称: "终末审判伤害结算",
    执行: function 瑟兰迪尔终末审判伤害结算(this: void): void {
      if (!单位有效(boss)) return;
      const bossX = GetUnitX(boss);
      const bossY = GetUnitY(boss);
      结算X = bossX;
      结算Y = bossY;
      播放终末审判主结算音效(bossX, bossY);
      const safeRadius2 = config.安全区半径 * config.安全区半径;
      for (let i = 0; i < targets.length; i++) {
        const target = targets[i];
        if (!单位有效(target)) continue;
        if (距离平方(GetUnitX(target), GetUnitY(target), bossX, bossY) > safeRadius2) {
          执行BossAOE技能伤害({
            来源: boss,
            目标: target,
            伤害公式: {
              来源攻击力比例: config.爆炸伤害Boss攻击力比例,
              目标最大生命比例: config.爆炸伤害目标最大生命比例,
              总倍率: config.爆炸伤害总倍率,
            },
            attack: false,
            ranged: false,
            attackType: jass.ATTACK_TYPE_NORMAL,
            伤害类型: jass.DAMAGE_TYPE_MAGIC,
            weaponType: jass.WEAPON_TYPE_WHOKNOWS,
            技能实例ID,
            标签: "瑟兰迪尔终末审判",
          });
        }
      }
    },
  });

  事件列表.push({
    时点毫秒: 爆炸毫秒 + config.结算扩散音效延迟毫秒,
    名称: "终末审判扩散音效",
    执行: function 瑟兰迪尔终末审判扩散音效(this: void): void {
      if (单位有效(boss)) 播放终末审判扩散音效(结算X, 结算Y);
    },
  });
  return 事件列表;
}

export function 释放瑟兰迪尔终末审判(this: void, context: 瑟兰迪尔运行时上下文): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return false;
  const config = 瑟兰迪尔数值与表现配置.终末审判;
  if (context.终末审判组合执行器 == null) {
    context.终末审判组合执行器 = 创建固定组合技能执行器<瑟兰迪尔运行时上下文>({
      名称: "瑟兰迪尔-终末审判",
      清理: context.清理,
      互斥组: "瑟兰迪尔大型技能",
    });
  }
  const 执行ID = context.终末审判组合执行器.开始({
    key: "终末审判",
    单位: boss,
    上下文: context,
    最大持续毫秒: (config.引导秒 + config.爆炸延迟秒) * 1000 + config.结算扩散音效延迟毫秒 + 1000,
    阶段列表: 创建固定时间轴阶段列表(创建终末审判时间轴事件(context)),
    结束回调: function 瑟兰迪尔终末审判组合结束(this: void, event): void {
      if (event.原因 === "完成") return;
      关闭吟唱条("大招");
      if (!单位有效(boss)) return;
      SetUnitTimeScale(boss, config.恢复动画速度);
      SetUnitAnimationByIndex(boss, config.恢复动画编号);
    },
  });
  return 执行ID !== 0;
}

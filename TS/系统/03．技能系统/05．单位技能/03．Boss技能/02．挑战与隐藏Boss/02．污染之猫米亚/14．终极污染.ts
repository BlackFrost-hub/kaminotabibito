/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效, 取单位ID } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 米亚运行时上下文 } from "./03．运行时上下文";
import { 取米亚平台中心配置, 取米亚平台中心X, 取米亚平台中心Y } from "./01．场地配置";
import { 米亚单位技能配置 } from "./00．配置";
import { 米亚技能数值配置, 米亚腐化感染配置, 米亚音效配置 } from "./02．数值与表现配置";
import { 添加米亚腐化感染 } from "./04．腐化感染";
import { 播放米亚台词 } from "./15．台词播放";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 创建固定组合技能执行器 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器";
import { 创建固定时间轴阶段列表, type 固定时间轴事件 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/02．固定时间轴阶段工厂";
import { 创建限时摧毁目标组, type 限时摧毁目标组实例 } from "../../../../00．技能模板+函数/04．机制组件/05．机制单位/02．限时摧毁目标组";
import type { 可攻击机制单位参数, 可攻击机制单位结束原因 } from "../../../../00．技能模板+函数/04．机制组件/05．机制单位/01．可攻击机制单位";
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 开始硬直 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, durationSec: number) => void;
};
const { 显示致命惩罚吟唱条, 关闭吟唱条 } = require("系统.09．表现系统.08．吟唱条.06．对外接口") as {
  显示致命惩罚吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
};
const { 创建点特效, 创建循环点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  创建循环点特效: (this: void, 参数: any) => any;
};
const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const KillUnit = jass.KillUnit as (unit: any) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

interface 终极污染核心点 {
  x: number;
  y: number;
}

function 取核心出生点表(this: void): 终极污染核心点[] {
  const config = 米亚技能数值配置.终极污染;
  const inset = config.核心内缩距离;
  const platform = 取米亚平台中心配置();
  return [
    { x: platform.左 + inset, y: platform.下 + inset },
    { x: platform.右 - inset, y: platform.下 + inset },
    { x: platform.左 + inset, y: platform.上 - inset },
    { x: platform.右 - inset, y: platform.上 - inset },
  ];
}

function 播放终极污染引导表现(this: void, context: 米亚运行时上下文): void {
  const boss = context.Boss单位;
  const seconds = 米亚技能数值配置.终极污染.引导秒;
  创建循环点特效({
    模型路径: 米亚单位技能配置.特效.终极污染Boss引导,
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    Z: 20,
    缩放: 3.2,
    总持续秒: seconds,
    重建间隔秒: 3,
    单次持续秒: 2.9,
    存活条件: function 米亚终极污染Boss引导存活(this: void): boolean {
      return context.终极污染引导中 && 单位有效(context.Boss单位);
    },
  });
  创建循环点特效({
    模型路径: 米亚单位技能配置.特效.终极污染中心柱,
    X: 取米亚平台中心X(),
    Y: 取米亚平台中心Y(),
    Z: 0,
    缩放: 2.4,
    总持续秒: seconds,
    重建间隔秒: 3,
    单次持续秒: 2.9,
    存活条件: function 米亚终极污染中心柱存活(this: void): boolean {
      return context.终极污染引导中 && 单位有效(context.Boss单位);
    },
  });
  创建循环点特效({
    模型路径: "war3mapImported\\[ake]gaopin.mdx",
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    Z: 80,
    缩放: 1.1,
    总持续秒: seconds,
    重建间隔秒: 3,
    单次持续秒: 2.9,
    存活条件: function 米亚终极污染高频存活(this: void): boolean {
      return context.终极污染引导中 && 单位有效(context.Boss单位);
    },
  });
}

function 创建终极污染核心组(this: void, context: 米亚运行时上下文): void {
  const config = 米亚技能数值配置.终极污染;
  const maxLife = GetUnitStateJapi(context.Boss单位, UNIT_STATE_MAX_LIFE);
  const hp = maxLife * config.核心生命Boss最大生命比例;
  const points = 取核心出生点表();
  const count = config.核心数量 < points.length ? config.核心数量 : points.length;
  const 目标列表: 可攻击机制单位参数[] = [];
  for (let i = 0; i < count; i++) {
    const point = points[i];
    目标列表.push({
      主人单位: context.Boss单位,
      所属玩家: GetOwningPlayer(context.Boss单位),
      单位类型: 米亚单位技能配置.腐化核心单位ID,
      单位名称: "米亚腐化核心",
      模型路径: 米亚单位技能配置.特效.终极污染核心模型,
      X: point.x,
      Y: point.y,
      持续时间: config.引导秒 + 2,
      飞行高度: config.核心浮空高度,
      生命值: hp,
      生命值受小怪倍率: false,
      固定站桩: true,
      禁止普攻: true,
      攻击范围: 0,
      索敌范围: 0,
      缩放: config.核心缩放,
    });
  }
  const 核心组 = 创建限时摧毁目标组({
    名称: "米亚-终极污染核心组",
    清理: context.清理,
    持续秒: config.引导秒,
    目标列表,
    on目标结束: function 米亚终极污染核心结束(this: void, _目标: any, 原因: 可攻击机制单位结束原因): void {
      if (!context.终极污染引导中) return;
      if (原因 === "被击杀" || 原因 === "自然到期") 播放米亚台词(context.Boss单位, "终极污染", 6);
      if (context.终极污染核心组 != null && context.终极污染核心组.取剩余数量() === 1) {
        播放米亚台词(context.Boss单位, "终极污染", 7);
      }
    },
    on全部摧毁: function 米亚终极污染核心全灭(this: void): void {
      打断终极污染(context);
    },
  });
  context.终极污染核心组 = 核心组;
  for (let i = 0; i < 核心组.目标单位列表.length; i++) {
    const core = 核心组.目标单位列表[i];
    const point = points[i];
    创建循环点特效({
      模型路径: 米亚单位技能配置.特效.终极污染核心附着,
      X: point.x,
      Y: point.y,
      Z: config.核心浮空高度,
      缩放: 1,
      总持续秒: config.引导秒,
      重建间隔秒: 1,
      单次持续秒: 0.9,
      存活条件: function 米亚终极污染核心附着存活(this: void): boolean {
        return context.终极污染引导中 && core.是否存活();
      },
    });
  }
  广播单位提示(context.Boss单位, `终极污染开始，引导${config.引导秒}秒，每秒全场增加${config.每秒全场腐化层数}层腐化感染（${config.引导秒}秒内击破全部${config.核心数量}个腐化核心即可打断！）`, 4200);
  播放米亚台词(context.Boss单位, "终极污染", 2);
}

function 记录终极污染叠层(this: void, context: 米亚运行时上下文, target: any, count: number): void {
  const id = 取单位ID(target);
  if (id === 0) return;
  context.终极污染本次叠层表[id] = (context.终极污染本次叠层表[id] ?? 0) + count;
}

function 清退终极污染本次叠层(this: void, context: 米亚运行时上下文): void {
  const heroes = 获取Boss技能敌对英雄列表(context.Boss单位);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    const id = 取单位ID(hero);
    const count = context.终极污染本次叠层表[id] ?? 0;
    if (count > 0) context.腐化层数控制器.减少(hero, count, "终极污染打断清退");
  }
  context.终极污染本次叠层表 = {};
}

function 清理终极污染核心(this: void, context: 米亚运行时上下文): void {
  const 核心组 = context.终极污染核心组;
  context.终极污染核心组 = undefined;
  if (核心组 != null) 核心组.结束(false, "机制清理");
}

export function 清理米亚终极污染(this: void, context: 米亚运行时上下文): void {
  context.终极污染引导中 = false;
  context.终极污染组合执行器?.停止(undefined, "中断");
  清理终极污染核心(context);
  context.终极污染本次叠层表 = {};
  关闭吟唱条("致命惩罚");
}

function 执行终极污染打断(this: void, context: 米亚运行时上下文): void {
  if (!context.终极污染引导中) return;
  context.终极污染引导中 = false;
  关闭吟唱条("致命惩罚");
  清退终极污染本次叠层(context);
  清理终极污染核心(context);
  if (单位有效(context.Boss单位)) {
    SetUnitTimeScale(context.Boss单位, 米亚技能数值配置.终极污染.恢复动画速度);
    开始硬直(context.Boss单位, 米亚技能数值配置.终极污染.打断Boss虚弱秒);
    播放米亚台词(context.Boss单位, "终极污染", 8);
  }
}

function 打断终极污染(this: void, context: 米亚运行时上下文): void {
  if (!context.终极污染引导中) return;
  if (context.终极污染组合执行器?.停止(undefined, "中断") === true) return;
  执行终极污染打断(context);
}

function 终极污染每秒叠层(this: void, context: 米亚运行时上下文): void {
  if (!context.终极污染引导中 || !单位有效(context.Boss单位)) return;
  const config = 米亚技能数值配置.终极污染;
  const heroes = 获取Boss技能敌对英雄列表(context.Boss单位);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    添加米亚腐化感染(context, hero, config.每秒全场腐化层数, "终极污染引导");
    记录终极污染叠层(context, hero, config.每秒全场腐化层数);
  }
}

function 完成终极污染(this: void, context: 米亚运行时上下文): void {
  if (!context.终极污染引导中 || !单位有效(context.Boss单位)) return;
  context.终极污染引导中 = false;
  关闭吟唱条("致命惩罚");
  清理终极污染核心(context);
  SetUnitTimeScale(context.Boss单位, 米亚技能数值配置.终极污染.恢复动画速度);
  播放米亚台词(context.Boss单位, "终极污染", 9);
  播放Boss坐标音效(米亚音效配置.终极污染.引导完成, 取米亚平台中心X(), 取米亚平台中心Y(), 米亚音效配置.默认裁断距离);
  创建点特效({ 模型路径: 米亚单位技能配置.特效.终极污染完成冲击, X: 取米亚平台中心X(), Y: 取米亚平台中心Y(), Z: 0, 缩放: 4, 持续秒: 2 });
  创建点特效({ 模型路径: 米亚单位技能配置.特效.终极污染完成毒爆, X: 取米亚平台中心X(), Y: 取米亚平台中心Y(), Z: 60, 缩放: 1.5, 持续秒: 2 });

  const heroes = 获取Boss技能敌对英雄列表(context.Boss单位);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    context.腐化层数控制器.设置(hero, 米亚腐化感染配置.最大层数, "终极污染完成");
    if (GetUnitState(hero, UNIT_STATE_LIFE) > 0) KillUnit(hero);
  }
  context.终极污染本次叠层表 = {};
}

function 创建终极污染时间轴事件(this: void, context: 米亚运行时上下文): 固定时间轴事件[] {
  const config = 米亚技能数值配置.终极污染;
  const 事件列表: 固定时间轴事件[] = [];
  for (let 秒数 = 1; 秒数 <= config.引导秒; 秒数++) {
    事件列表.push({
      时点毫秒: 秒数 * 1000,
      名称: "终极污染第" + 秒数 + "秒叠层",
      执行: function 米亚终极污染每秒(this: void): void {
        终极污染每秒叠层(context);
      },
    });
  }
  for (let i = 0; i < config.引导台词时点.length; i++) {
    const 台词事件 = config.引导台词时点[i];
    事件列表.push({
      时点毫秒: 台词事件.时点Ms,
      名称: "终极污染引导台词",
      执行: function 米亚终极污染引导台词(this: void): void {
        if (context.终极污染引导中) 播放米亚台词(context.Boss单位, "终极污染", 台词事件.台词序号);
      },
    });
  }
  for (let i = 0; i < config.动画重播时点Ms.length; i++) {
    事件列表.push({
      时点毫秒: config.动画重播时点Ms[i],
      名称: "终极污染重播动作",
      执行: function 米亚终极污染重播动作(this: void): void {
        if (!context.终极污染引导中 || !单位有效(context.Boss单位)) return;
        SetUnitTimeScale(context.Boss单位, config.引导动画速度);
        SetUnitAnimationByIndex(context.Boss单位, config.引导动画编号);
      },
    });
  }
  事件列表.push({
    时点毫秒: config.引导秒 * 1000,
    名称: "终极污染完成",
    执行: function 米亚终极污染完成(this: void): void {
      完成终极污染(context);
    },
  });
  return 事件列表;
}

function 启动终极污染时间轴(this: void, context: 米亚运行时上下文): boolean {
  const config = 米亚技能数值配置.终极污染;
  if (context.终极污染组合执行器 == null) {
    context.终极污染组合执行器 = 创建固定组合技能执行器<米亚运行时上下文>({
      名称: "米亚-终极污染",
      清理: context.清理,
      互斥组: "米亚大型技能",
    });
  }
  const 执行ID = context.终极污染组合执行器.开始({
    key: "终极污染",
    单位: context.Boss单位,
    上下文: context,
    最大持续毫秒: config.引导秒 * 1000 + 1000,
    阶段列表: 创建固定时间轴阶段列表(创建终极污染时间轴事件(context)),
    结束回调: function 米亚终极污染组合结束(this: void, event): void {
      if (event.原因 !== "完成" && context.终极污染引导中) 执行终极污染打断(context);
    },
  });
  return 执行ID !== 0;
}

function 启动终极污染(this: void, context: 米亚运行时上下文): boolean {
  if (context.终极污染引导中 || !单位有效(context.Boss单位)) return false;
  const config = 米亚技能数值配置.终极污染;
  if (!启动终极污染时间轴(context)) return false;
  context.终极污染引导中 = true;
  context.终极污染本次叠层表 = {};

  SetUnitTimeScale(context.Boss单位, config.引导动画速度);
  SetUnitAnimationByIndex(context.Boss单位, config.引导动画编号);
  开始硬直(context.Boss单位, config.引导秒);
  显示致命惩罚吟唱条({
    总时长: config.引导秒,
    颜色ID: 4,
    标题文本: "终极污染",
    提示文本: `引导${config.引导秒}秒，每秒全场增加${config.每秒全场腐化层数}层腐化感染；击破全部${config.核心数量}个核心即可打断（优先击破核心）。`,
  });
  播放米亚台词(context.Boss单位, "终极污染", 0);
  播放终极污染引导表现(context);
  创建终极污染核心组(context);
  播放Boss坐标音效(米亚音效配置.终极污染.开始引导, 取米亚平台中心X(), 取米亚平台中心Y(), 米亚音效配置.默认裁断距离);
  return true;
}

export function 触发米亚终极污染(this: void, context: 米亚运行时上下文, 阈值序号: 0 | 1): boolean {
  if (context.阶段 !== 3 || context.终极污染引导中) return false;
  if (阈值序号 === 0 && context.已触发终极污染30) return false;
  if (阈值序号 === 1 && context.已触发终极污染15) return false;
  if (!启动终极污染(context)) return false;
  if (阈值序号 === 0) context.已触发终极污染30 = true;
  else context.已触发终极污染15 = true;
  return true;
}

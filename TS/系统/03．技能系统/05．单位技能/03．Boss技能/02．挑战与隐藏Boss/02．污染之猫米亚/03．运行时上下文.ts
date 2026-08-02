/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 创建Buff层数状态, type Buff层数状态控制器 } from "../../../../00．技能模板+函数/04．机制组件/01．层数状态/06．Buff层数状态";
import { 米亚安全域运行时矩形组, 创建米亚安全域矩形组, 清理米亚安全域矩形组, 取米亚单位所在安全域, 取米亚平台中心X, 取米亚平台中心Y } from "./01．场地配置";
import { 米亚单位技能配置 } from "./00．配置";
import { 米亚腐化感染配置, 米亚阶段阈值, 米亚音效配置, 米亚运行时配置 } from "./02．数值与表现配置";
import { 同步米亚腐化感染治疗属性 } from "./04．腐化感染";
import { 刷新米亚污染标记 } from "./08．污染标记";
import { 刷新米亚腐化转移污染平台 } from "./11．腐化转移";
import { 刷新米亚平台超载惩罚 } from "./12．平台超载惩罚";
import { 刷新米亚腐化黏液涂层被动状态 } from "./13．腐化黏液涂层";
import { 清理米亚终极污染 } from "./14．终极污染";
import { 播放米亚台词 } from "./15．台词播放";
import { 延迟播放Boss坐标音效, 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import type { 机制清理篮子 } from "../../../../00．技能模板+函数/04．机制组件/06．机制清理/01．机制清理篮子";
import { 创建单位运行时上下文工厂 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/15．单位运行时上下文工厂";
import { 创建周期机制调度器 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/17．周期机制调度器';
import { 创建阶段上下文, type 阶段上下文 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/01．阶段上下文";
import type { 固定组合技能执行器 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器";
import type { 限时摧毁目标组实例 } from "../../../../00．技能模板+函数/04．机制组件/05．机制单位/02．限时摧毁目标组";

const jass = require("jass.common") as any;
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

export type 米亚阶段 = 1 | 2 | 3;

export interface 米亚运行时上下文 {
  Boss单位: any;
  阶段: 米亚阶段;
  开战时间Ms: number;
  清理: 机制清理篮子;
  阶段上下文: 阶段上下文;
  安全域区域组: 米亚安全域运行时矩形组;
  腐化层数控制器: Buff层数状态控制器;
  已触发分身80: boolean;
  已触发分身50: boolean;
  污染标记目标?: any;
  上次污染标记低频台词Ms: number;
  已触发终极污染30: boolean;
  已触发终极污染15: boolean;
  上次污染标记Ms: number;
  上次平台超载检测Ms: number;
  污染脉冲组合执行器?: 固定组合技能执行器<米亚运行时上下文>;
  腐化转移污染平台ID?: string;
  腐化转移污染结束Ms: number;
  腐化转移下次叠层Ms: number;
  腐化转移施法中: boolean;
  超载平台ID表: Record<string, boolean | undefined>;
  超载平台下次叠层Ms表: Record<string, number | undefined>;
  上次平台超载台词Ms: number;
  腐化黏液近战冷却表: Record<number, number | undefined>;
  腐化黏液上次受伤提示Ms: number;
  终极污染引导中: boolean;
  终极污染组合执行器?: 固定组合技能执行器<米亚运行时上下文>;
  终极污染核心组?: 限时摧毁目标组实例;
  终极污染本次叠层表: Record<number, number | undefined>;
}

let 米亚运行时已注册 = false;

function 取米亚腐化感染Buff持续秒(this: void): number {
  const 普通等待秒 = 米亚腐化感染配置.普通衰减等待秒;
  const 安全平台等待秒 = 米亚腐化感染配置.安全平台衰减等待秒;
  const 最大等待秒 = 普通等待秒 > 安全平台等待秒 ? 普通等待秒 : 安全平台等待秒;
  return 最大等待秒 + 0.5;
}

function 创建米亚腐化层数控制器(this: void, context: 米亚运行时上下文): Buff层数状态控制器 {
  return 创建Buff层数状态({
    名称: "米亚-腐化感染",
    清理: context.清理,
    BuffID: 米亚单位技能配置.BuffID.腐化感染,
    Buff持续秒: 取米亚腐化感染Buff持续秒(),
    取Buff显示值: function 取米亚腐化感染伤害显示值(this: void, _单位: any, _层数: number): number {
      return 米亚腐化感染配置.每层米亚相关伤害提高 * 100;
    },
    取Buff附加参数: function 取米亚腐化感染治疗显示值(this: void, _单位: any, _层数: number): any {
      return {
        effectValue2: 米亚腐化感染配置.每层受到治疗降低 * 100,
        sourceUnit: context.Boss单位,
      };
    },
    层数配置: {
      状态ID: "mia-corruption",
      最大层数: 米亚腐化感染配置.最大层数,
      on层数变化: 同步米亚腐化感染治疗属性,
      衰减: {
        等待秒: 米亚腐化感染配置.普通衰减等待秒,
        间隔秒: 米亚腐化感染配置.普通衰减间隔秒,
        每次减少层数: 1,
        加速条件: function 米亚腐化安全平台加速条件(this: void, 单位: any): boolean {
          const 区域 = 取米亚单位所在安全域(单位, context.安全域区域组);
          if (区域 == null) return false;
          const id = 区域.配置.ID ?? 区域.配置.名称 ?? "";
          if (id !== "" && context.腐化转移污染平台ID === id) return false;
          if (id !== "" && context.超载平台ID表[id] === true) return false;
          return true;
        },
        加速等待秒: 米亚腐化感染配置.安全平台衰减等待秒,
        加速间隔秒: 米亚腐化感染配置.安全平台衰减间隔秒,
      },
      表现档位: [
        { 键: "低层", 最小层数: 1, 最大层数: 6 },
        { 键: "中层", 最小层数: 7, 最大层数: 11 },
        { 键: "高层", 最小层数: 12, 最大层数: 15 },
      ],
    },
  });
}

function 创建米亚上下文(this: void, boss: any, 清理: 机制清理篮子): 米亚运行时上下文 {
  const context: 米亚运行时上下文 = {
    Boss单位: boss,
    阶段: 1,
    开战时间Ms: getServerTime(),
    清理,
    阶段上下文: undefined as any,
    安全域区域组: 创建米亚安全域矩形组(),
    腐化层数控制器: undefined as any,
    已触发分身80: false,
    已触发分身50: false,
    污染标记目标: null,
    上次污染标记低频台词Ms: 0,
    已触发终极污染30: false,
    已触发终极污染15: false,
    上次污染标记Ms: 0,
    上次平台超载检测Ms: 0,
    腐化转移污染平台ID: "",
    腐化转移污染结束Ms: 0,
    腐化转移下次叠层Ms: 0,
    腐化转移施法中: false,
    超载平台ID表: {},
    超载平台下次叠层Ms表: {},
    上次平台超载台词Ms: 0,
    腐化黏液近战冷却表: {},
    腐化黏液上次受伤提示Ms: 0,
    终极污染引导中: false,
    终极污染核心组: undefined,
    终极污染本次叠层表: {},
  };
  context.腐化层数控制器 = 创建米亚腐化层数控制器(context);
  context.阶段上下文 = 创建米亚阶段上下文(context);
  播放米亚台词(boss, "开场", 0);
  return context;
}

function 创建米亚阶段上下文(this: void, context: 米亚运行时上下文): 阶段上下文 {
  const boss = context.Boss单位;
  return 创建阶段上下文({
    清理: context.清理,
    名称: "米亚",
    单位: boss,
    初始阶段ID: "P1",
    Tick间隔毫秒: 米亚运行时配置.推进间隔毫秒,
    阶段列表: [{
      ID: "P1",
    }, {
      ID: "P2",
      血量百分比: 米亚阶段阈值.第二阶段生命比例,
      on进入: function 米亚进入P2(this: void): void {
        context.阶段 = 2;
        播放Boss坐标音效(米亚音效配置.转阶段2.跳入水池, GetUnitX(boss), GetUnitY(boss), 米亚音效配置.默认裁断距离);
        延迟播放Boss坐标音效(米亚音效配置.转阶段2.毒水喷涌, 取米亚平台中心X(), 取米亚平台中心Y(), 米亚音效配置.转阶段2.毒水喷涌延迟Ms, 米亚音效配置.默认裁断距离);
        播放米亚台词(boss, "转阶段2", 0);
      },
    }, {
      ID: "P3",
      血量百分比: 米亚阶段阈值.第三阶段生命比例,
      on进入: function 米亚进入P3(this: void): void {
        context.阶段 = 3;
        播放米亚台词(boss, "转阶段3", 0);
      },
    }],
  });
}

function 清理米亚上下文机制(this: void, context: 米亚运行时上下文): void {
  清理米亚终极污染(context);
  context.腐化层数控制器.销毁();
  清理米亚安全域矩形组(context.安全域区域组);
}

const 米亚上下文工厂 = 创建单位运行时上下文工厂<米亚运行时上下文>({
  名称: "米亚",
  主动技能提示: 米亚单位技能配置.主动技能提示,
  创建上下文: 创建米亚上下文,
  on清理: 清理米亚上下文机制,
});

export function 获取米亚上下文(this: void, boss: any): 米亚运行时上下文 | undefined {
  return 米亚上下文工厂.获取(boss);
}

export function 获取或创建米亚上下文(this: void, boss: any): 米亚运行时上下文 | undefined {
  return 米亚上下文工厂.获取或创建(boss);
}

export function 获取全部米亚上下文(this: void): 米亚运行时上下文[] {
  return 米亚上下文工厂.获取全部();
}

export function 清理米亚上下文(this: void, boss: any): void {
  米亚上下文工厂.清理上下文(boss);
}

function 推进米亚运行时(this: void, context: 米亚运行时上下文, nowMs: number): void {
  if (!单位有效(context.Boss单位)) {
    清理米亚上下文(context.Boss单位);
    return;
  }
  刷新米亚污染标记(context, nowMs);
  刷新米亚腐化转移污染平台(context, nowMs);
  刷新米亚平台超载惩罚(context, nowMs);
  刷新米亚腐化黏液涂层被动状态(context);
}

export function 注册米亚运行时(this: void): void {
  if (米亚运行时已注册) return;
  米亚运行时已注册 = true;
  创建周期机制调度器({
    名称: '米亚-运行时推进',
    间隔毫秒: 米亚运行时配置.推进间隔毫秒,
    取当前时间: getServerTime,
    取上下文列表: 米亚上下文工厂.获取全部,
    执行: 推进米亚运行时,
  });
}

export function 给单位添加米亚腐化层数(this: void, context: 米亚运行时上下文, 单位: any, 层数: number, 原因: string): number {
  return context.腐化层数控制器.增加(单位, 层数, 原因);
}

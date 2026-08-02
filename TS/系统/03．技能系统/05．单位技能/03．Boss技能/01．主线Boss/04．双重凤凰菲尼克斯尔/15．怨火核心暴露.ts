/** @noSelfInFile */

import type { 菲尼克斯尔运行时上下文 } from "./03．运行时上下文";
import { 菲尼克斯尔单位技能配置 } from "./00．配置";
import { 菲尼克斯尔场地配置 } from "./01．场地配置";
import { 菲尼克斯尔数值与表现配置, 菲尼克斯尔音效配置 } from "./02．数值与表现配置";
import { 播放菲尼克斯尔台词 } from "./17．台词播放";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import {
  延迟,
  周期,
  单位存活,
  取最大生命,
  创建菲尼克斯尔机制单位,
  播放点特效,
  取单位X,
  取单位Y,
  设置单位动画,
} from "./19．公共工具";
import { 提交预计算Boss单体技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";

const jass = require("jass.common") as any;
const RemoveUnit = jass.RemoveUnit as (whichUnit: any) => void;
const DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND as any;

const { 减少生命值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少生命值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string, 最低保留生命?: number) => number;
};

function on菲尼克斯尔怨火核心死亡(this: void, context: 菲尼克斯尔运行时上下文, unit: any, killer: any): void {
  context.怨火核心暴露中 = false;
  const damage = 取最大生命(context.Boss) * 菲尼克斯尔数值与表现配置.机制.怨火核心摧毁Boss最大生命伤害比例;
  if (killer != null && killer !== 0) {
    const 结果 = 提交预计算Boss单体技能伤害({
      来源: killer,
      目标: context.Boss,
      伤害: damage,
      伤害类型: DAMAGE_TYPE_MIND,
      来源类型: "其他",
      标签: "菲尼克斯尔-摧毁怨火核心",
      参与技能伤害加成: false,
    });
    if (!结果.是否造成伤害) 减少生命值(context.Boss, damage);
  } else {
    减少生命值(context.Boss, damage);
  }
  播放点特效(菲尼克斯尔数值与表现配置.特效.核心暴露, 取单位X(unit), 取单位Y(unit), 1800);
}

function 创建怨火核心死亡回调(this: void, context: 菲尼克斯尔运行时上下文): (this: void, unit: any, killer: any) => void {
  return function 菲尼克斯尔怨火核心死亡(this: void, unit: any, killer: any): void {
    on菲尼克斯尔怨火核心死亡(context, unit, killer);
  };
}

export function 触发菲尼克斯尔怨火核心暴露(this: void, context: 菲尼克斯尔运行时上下文): void {
  if (context.怨火核心暴露中 || context.当前形态 !== "第二形态" || !单位存活(context.Boss)) return;
  context.怨火核心暴露中 = true;
  设置单位动画(context.Boss, 菲尼克斯尔数值与表现配置.动画.第二形态.施法.编号, 菲尼克斯尔数值与表现配置.动画.第二形态.施法.倍速);
  播放菲尼克斯尔台词(context.Boss, "怨火核心暴露");
  const center = 菲尼克斯尔场地配置.中心点;
  context.怨火核心 = 创建菲尼克斯尔机制单位(
    context,
    菲尼克斯尔单位技能配置.机制单位ID.怨火核心,
    "怨火核心",
    菲尼克斯尔单位技能配置.模型.怨火核心,
    center.x,
    center.y,
    取最大生命(context.Boss) * 菲尼克斯尔数值与表现配置.机制.怨火核心生命Boss最大生命比例,
    创建怨火核心死亡回调(context)
  );
  播放点特效(菲尼克斯尔数值与表现配置.特效.核心暴露, center.x, center.y, 2500);
  播放Boss坐标音效(菲尼克斯尔音效配置.怨火核心.暴露, center.x, center.y, 菲尼克斯尔音效配置.默认裁断距离);
  延迟(菲尼克斯尔数值与表现配置.机制.怨火核心暴露持续秒 * 1000, function 菲尼克斯尔怨火核心暴露结束(this: void): void {
    if (单位存活(context.怨火核心)) {
      RemoveUnit(context.怨火核心);
      context.怨火核心 = undefined;
    }
    context.怨火核心暴露中 = false;
  });
}

export function 初始化菲尼克斯尔怨火核心暴露节点(this: void, context: 菲尼克斯尔运行时上下文): void {
  if (context.怨火核心暴露已初始化) return;
  context.怨火核心暴露已初始化 = true;
  const timerId = 周期(菲尼克斯尔数值与表现配置.机制.怨火核心周期暴露秒 * 1000, function 菲尼克斯尔怨火核心周期暴露(this: void): void {
    触发菲尼克斯尔怨火核心暴露(context);
  });
  context.清理.登记周期回调("菲尼克斯尔-怨火核心周期暴露", timerId);
}

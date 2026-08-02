/** @noSelfInFile */

import type { 菲尼克斯尔运行时上下文, 菲尼克斯尔元素类型 } from "./03．运行时上下文";
import { 菲尼克斯尔场地配置 } from "./01．场地配置";
import { 菲尼克斯尔数值与表现配置, 菲尼克斯尔音效配置 } from "./02．数值与表现配置";
import { 播放菲尼克斯尔台词 } from "./17．台词播放";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 创建点特效 } from "../../../../../../lib/扩展函数/封装函数/01．通用工具/03．特效";
import {
  周期,
  延迟,
  停止周期,
  单位存活,
  取菲尼克斯尔敌对目标列表,
  两点距离,
  取单位X,
  取单位Y,
  创建安全圆,
  显示大招读条,
  设置单位动画,
  开始施法硬直,
  添加元素层数,
  创建菲尼克斯尔独立伤害上下文,
} from "./19．公共工具";
import { 执行BossAOE技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
import { 触发菲尼克斯尔怨火核心暴露 } from "./15．怨火核心暴露";

const jass = require("jass.common") as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
function 取玩家安全区元素(this: void, unit: any): 菲尼克斯尔元素类型 | undefined {
  const points = 菲尼克斯尔场地配置.挽歌安全区点位;
  const radius = 菲尼克斯尔数值与表现配置.凤凰挽歌.安全区半径;
  for (let i = 0; i < points.length; i++) {
    const p = points[i];
    if (两点距离(取单位X(unit), 取单位Y(unit), p.x, p.y) <= radius) return p.元素 as 菲尼克斯尔元素类型;
  }
  return undefined;
}

export function 释放菲尼克斯尔凤凰挽歌(this: void, context: 菲尼克斯尔运行时上下文): void {
  if (context.当前形态 !== "第二形态" || !单位存活(context.Boss)) {
    return;
  }
  const config = 菲尼克斯尔数值与表现配置.凤凰挽歌;
  const 伤害上下文 = 创建菲尼克斯尔独立伤害上下文("菲尼克斯尔凤凰挽歌", config.引导秒 + 2);
  播放菲尼克斯尔台词(context.Boss, "凤凰挽歌");
  开始施法硬直(context.Boss, config.引导秒);
  设置单位动画(context.Boss, 菲尼克斯尔数值与表现配置.动画.第二形态.施法.编号, 菲尼克斯尔数值与表现配置.动画.第二形态.施法.倍速);
  显示大招读条(config.引导秒, config.吟唱条颜色ID, config.吟唱条标题文本, config.吟唱条提示文本);
  创建点特效({
    模型路径: 菲尼克斯尔数值与表现配置.特效.凤凰挽歌主体,
    X: 取单位X(context.Boss),
    Y: 取单位Y(context.Boss),
    持续秒: config.引导秒,
    缩放: config.主体特效缩放,
  });
  播放Boss坐标音效(菲尼克斯尔音效配置.凤凰挽歌.引导开始, 取单位X(context.Boss), 取单位Y(context.Boss), 菲尼克斯尔音效配置.默认裁断距离);
  const points = 菲尼克斯尔场地配置.挽歌安全区点位;
  for (let i = 0; i < points.length; i++) {
    创建安全圆(points[i].x, points[i].y, config.安全区半径, config.引导秒);
    创建点特效({
      模型路径: 菲尼克斯尔数值与表现配置.特效.凤凰挽歌安全区,
      X: points[i].x,
      Y: points[i].y,
      持续秒: config.引导秒,
      缩放: config.安全区特效缩放,
    });
  }
  const tick = 周期(config.Tick秒 * 1000, function 菲尼克斯尔凤凰挽歌Tick(this: void): void {
    const heroes = 取菲尼克斯尔敌对目标列表(context.Boss);
    for (let i = 0; i < heroes.length; i++) {
      const hero = heroes[i];
      const 安全区元素 = 取玩家安全区元素(hero);
      if (安全区元素 !== undefined) {
        添加元素层数(hero, 安全区元素, config.规避叠层);
        continue;
      }
      if (单位存活(context.Boss) && 单位存活(hero)) {
        执行BossAOE技能伤害({
          技能实例ID: 伤害上下文?.技能实例ID,
          标签: 伤害上下文?.标签,
          来源: context.Boss,
          目标: hero,
          伤害公式: {
            目标当前生命比例: config.当前生命损失比例,
          },
          ranged: true,
          attackType: ATTACK_TYPE_NORMAL,
          伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
          weaponType: WEAPON_TYPE_WHOKNOWS,
        });
      }
      添加元素层数(hero, "暗", config.规避叠层);
      创建点特效({
        模型路径: 菲尼克斯尔数值与表现配置.特效.凤凰挽歌叠加,
        X: 取单位X(hero),
        Y: 取单位Y(hero),
        Z: config.圈外命中特效高度,
        持续秒: config.Tick秒,
        缩放: config.圈外命中特效缩放,
      });
    }
  });
  context.清理.登记周期回调("菲尼克斯尔凤凰挽歌Tick", tick);
  延迟(config.引导秒 * 1000, function 菲尼克斯尔凤凰挽歌结束(this: void): void {
    停止周期(tick);
    触发菲尼克斯尔怨火核心暴露(context);
  });
}

export function 初始化菲尼克斯尔凤凰挽歌节点(this: void, context: 菲尼克斯尔运行时上下文): void {
  const timerId = 周期(36000, function 菲尼克斯尔凤凰挽歌周期(this: void): void {
    释放菲尼克斯尔凤凰挽歌(context);
  });
  context.清理.登记周期回调("菲尼克斯尔-凤凰挽歌", timerId);
}

export function 注册菲尼克斯尔凤凰挽歌(this: void): void {
  // 第二形态周期机制，由转阶段时初始化。
}


/** @noSelfInFile */

import type { 菲尼克斯尔运行时上下文 } from "./03．运行时上下文";
import { 菲尼克斯尔场地配置 } from "./01．场地配置";
import { 菲尼克斯尔数值与表现配置 } from "./02．数值与表现配置";
import { 播放菲尼克斯尔台词 } from "./17．台词播放";
import {
  周期,
  延迟,
  停止周期,
  单位存活,
  取菲尼克斯尔玩家英雄列表,
  两点距离,
  取单位X,
  取单位Y,
  创建安全圆,
  播放点特效,
  显示大招读条,
  设置单位动画,
  开始施法硬直,
  添加元素层数,
  造成暗火伤害,
  取当前生命,
} from "./19．公共工具";
import { 触发菲尼克斯尔怨火核心暴露 } from "./15．怨火核心暴露";

function 玩家在安全区(this: void, unit: any): boolean {
  const points = 菲尼克斯尔场地配置.挽歌安全区点位;
  const radius = 菲尼克斯尔数值与表现配置.凤凰挽歌.安全区半径;
  for (let i = 0; i < points.length; i++) {
    const p = points[i];
    if (两点距离(取单位X(unit), 取单位Y(unit), p.x, p.y) <= radius) return true;
  }
  return false;
}

export function 释放菲尼克斯尔凤凰挽歌(this: void, context: 菲尼克斯尔运行时上下文): void {
  if (context.当前形态 !== "第二形态" || !单位存活(context.Boss)) return;
  const config = 菲尼克斯尔数值与表现配置.凤凰挽歌;
  播放菲尼克斯尔台词(context.Boss, "凤凰挽歌");
  开始施法硬直(context.Boss, config.引导秒);
  设置单位动画(context.Boss, 菲尼克斯尔数值与表现配置.动画.第二形态.哀鸣引导.编号, 菲尼克斯尔数值与表现配置.动画.第二形态.哀鸣引导.倍速);
  显示大招读条(config.引导秒, config.吟唱条颜色ID, config.吟唱条标题文本, config.吟唱条提示文本);
  播放点特效(菲尼克斯尔数值与表现配置.特效.凤凰挽歌主体, 取单位X(context.Boss), 取单位Y(context.Boss), config.引导秒 * 1000);
  const points = 菲尼克斯尔场地配置.挽歌安全区点位;
  for (let i = 0; i < points.length; i++) {
    创建安全圆(points[i].x, points[i].y, config.安全区半径, config.引导秒);
    播放点特效(菲尼克斯尔数值与表现配置.特效.凤凰挽歌安全区, points[i].x, points[i].y, config.引导秒 * 1000);
  }
  const tick = 周期(config.Tick秒 * 1000, function 菲尼克斯尔凤凰挽歌Tick(this: void): void {
    const heroes = 取菲尼克斯尔玩家英雄列表();
    for (let i = 0; i < heroes.length; i++) {
      const hero = heroes[i];
      if (玩家在安全区(hero)) continue;
      造成暗火伤害(context.Boss, hero, 取当前生命(hero) * config.当前生命损失比例);
      添加元素层数(hero, "暗", config.规避叠层);
      播放点特效(菲尼克斯尔数值与表现配置.特效.凤凰挽歌叠加, 取单位X(hero), 取单位Y(hero), 1200);
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


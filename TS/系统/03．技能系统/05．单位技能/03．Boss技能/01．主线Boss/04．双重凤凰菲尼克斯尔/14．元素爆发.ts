/** @noSelfInFile */

import type { 菲尼克斯尔运行时上下文, 菲尼克斯尔元素类型 } from "./03．运行时上下文";
import { 菲尼克斯尔数值与表现配置, 菲尼克斯尔音效配置 } from "./02．数值与表现配置";
import { 播放菲尼克斯尔台词 } from "./17．台词播放";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import {
  周期,
  延迟,
  单位存活,
  取菲尼克斯尔敌对目标列表,
  取最高元素,
  减少元素层数,
  显示场地读条,
  播放点特效,
  取单位X,
  取单位Y,
  造成火焰伤害,
  造成冰霜伤害,
  造成毒火伤害,
  造成暗火伤害,
  创建菲尼克斯尔独立伤害上下文,
  计算攻击最大生命伤害,
  计算攻击已损失伤害,
  取最大生命,
  设置单位动画,
  开始施法硬直,
} from "./19．公共工具";

function 取元素特效(this: void, 元素: 菲尼克斯尔元素类型): string {
  if (元素 === "冰") return 菲尼克斯尔数值与表现配置.特效.元素爆发冰;
  if (元素 === "毒") return 菲尼克斯尔数值与表现配置.特效.元素爆发毒;
  if (元素 === "暗") return 菲尼克斯尔数值与表现配置.特效.元素爆发暗;
  return 菲尼克斯尔数值与表现配置.特效.元素爆发火;
}

function 取元素音效(this: void, 元素: 菲尼克斯尔元素类型): string {
  if (元素 === "冰") return 菲尼克斯尔音效配置.元素爆发.冰;
  if (元素 === "毒") return 菲尼克斯尔音效配置.元素爆发.毒;
  if (元素 === "暗") return 菲尼克斯尔音效配置.元素爆发.暗;
  return 菲尼克斯尔音效配置.元素爆发.火;
}

export function 结算菲尼克斯尔元素爆发(this: void, context: 菲尼克斯尔运行时上下文): void {
  if (context.当前形态 !== "第二形态" || !单位存活(context.Boss)) return;
  const config = 菲尼克斯尔数值与表现配置.元素爆发;
  const 伤害上下文 = 创建菲尼克斯尔独立伤害上下文("菲尼克斯尔元素爆发", config.吟唱秒 + 2);
  开始施法硬直(context.Boss, config.吟唱秒);
  设置单位动画(context.Boss, 菲尼克斯尔数值与表现配置.动画.第二形态.施法.编号, 菲尼克斯尔数值与表现配置.动画.第二形态.施法.倍速);
  播放菲尼克斯尔台词(context.Boss, "元素爆发");
  显示场地读条(config.吟唱秒, config.吟唱条颜色ID, config.吟唱条标题文本, config.吟唱条提示文本);
  延迟(config.吟唱秒 * 1000, function 菲尼克斯尔元素爆发结算(this: void): void {
    if (context.当前形态 !== "第二形态" || !单位存活(context.Boss)) return;
    const heroes = 取菲尼克斯尔敌对目标列表(context.Boss);
    for (let i = 0; i < heroes.length; i++) {
      const hero = heroes[i];
      const top = 取最高元素(hero);
      if (top.层数 <= 0) continue;
      const x = 取单位X(hero);
      const y = 取单位Y(hero);
      播放点特效(取元素特效(top.元素), x, y, 1800);
      播放Boss坐标音效(取元素音效(top.元素), x, y, 菲尼克斯尔音效配置.默认裁断距离);
      if (top.元素 === "冰") {
        造成冰霜伤害(context.Boss, hero, 计算攻击最大生命伤害(context.Boss, hero, config.冰伤害Boss攻击力比例, config.冰伤害目标最大生命比例), "AOE", 伤害上下文);
      } else if (top.元素 === "毒") {
        造成毒火伤害(context.Boss, hero, (取最大生命(hero) - 0) * 0 + 计算攻击已损失伤害(context.Boss, hero, 0, config.毒伤害目标已损失生命比例), "AOE", 伤害上下文);
      } else if (top.元素 === "暗") {
        造成暗火伤害(context.Boss, hero, 计算攻击最大生命伤害(context.Boss, hero, config.暗伤害Boss攻击力比例, config.暗伤害目标最大生命比例), "AOE", 伤害上下文);
      } else {
        造成火焰伤害(context.Boss, hero, 计算攻击最大生命伤害(context.Boss, hero, config.火伤害Boss攻击力比例, config.火伤害目标最大生命比例), "AOE", 伤害上下文);
      }
      减少元素层数(hero, top.元素, config.结算后最高层降低);
    }
  });
}

export function 初始化菲尼克斯尔元素爆发节点(this: void, context: 菲尼克斯尔运行时上下文): void {
  if (context.元素爆发已初始化) return;
  context.元素爆发已初始化 = true;
  const timerId = 周期(菲尼克斯尔数值与表现配置.元素爆发.周期秒 * 1000, function 菲尼克斯尔元素爆发周期(this: void): void {
    结算菲尼克斯尔元素爆发(context);
  });
  context.清理.登记周期回调("菲尼克斯尔-元素爆发", timerId);
}

export function 注册菲尼克斯尔元素爆发(this: void): void {
  // 第二形态周期机制，由转阶段时初始化。
}


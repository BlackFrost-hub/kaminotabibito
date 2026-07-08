/** @noSelfInFile */

import type { 菲尼克斯尔运行时上下文 } from "./03．运行时上下文";
import { 菲尼克斯尔数值与表现配置, 菲尼克斯尔音效配置 } from "./02．数值与表现配置";
import { 播放菲尼克斯尔台词 } from "./17．台词播放";
import { 播放Boss坐标音效, 延迟播放Boss坐标音效 } from "../00．公共/00．Boss音效播放";
import {
  周期,
  延迟,
  单位存活,
  取单位X,
  取单位Y,
  取随机玩家英雄,
  播放点特效,
  创建预警圆,
  范围敌人,
  计算攻击最大生命伤害,
  造成暗火伤害,
  创建菲尼克斯尔独立伤害上下文,
  添加元素层数,
  设置单位动画,
  显示常规读条,
  开始施法硬直,
} from "./19．公共工具";

export function 释放菲尼克斯尔骸骨弹幕(this: void, context: 菲尼克斯尔运行时上下文): void {
  if (context.当前形态 !== "第二形态" || !单位存活(context.Boss)) return;
  const config = 菲尼克斯尔数值与表现配置.骸骨弹幕;
  const 伤害上下文 = 创建菲尼克斯尔独立伤害上下文("菲尼克斯尔骸骨弹幕", config.读条秒 + config.波次数 * config.波次间隔秒 + 2);
  播放菲尼克斯尔台词(context.Boss, "骸骨弹幕");
  开始施法硬直(context.Boss, config.读条秒);
  设置单位动画(context.Boss, 菲尼克斯尔数值与表现配置.动画.第二形态.弹幕解体.编号, 菲尼克斯尔数值与表现配置.动画.第二形态.弹幕解体.倍速);
  显示常规读条(config.读条秒, config.吟唱条颜色ID, config.吟唱条标题文本, config.吟唱条提示文本);
  延迟(config.读条秒 * 1000, function 菲尼克斯尔骸骨弹幕开始(this: void): void {
    播放Boss坐标音效(菲尼克斯尔音效配置.骸骨弹幕.起手层, 取单位X(context.Boss), 取单位Y(context.Boss), 菲尼克斯尔音效配置.默认裁断距离);
    延迟播放Boss坐标音效(菲尼克斯尔音效配置.骸骨弹幕.飞射层, 取单位X(context.Boss), 取单位Y(context.Boss), 菲尼克斯尔音效配置.骸骨弹幕.飞射层延迟Ms, 菲尼克斯尔音效配置.默认裁断距离);
    for (let wave = 0; wave < config.波次数; wave++) {
      延迟(wave * config.波次间隔秒 * 1000, function 菲尼克斯尔骸骨弹幕波次(this: void): void {
        const target = 取随机玩家英雄();
        if (!单位存活(target)) return;
        const x = 取单位X(target);
        const y = 取单位Y(target);
        创建预警圆(x, y, config.半径 * 0.18, 0.35);
        播放点特效(菲尼克斯尔数值与表现配置.特效.骨羽, x, y, 1000);
        const enemies = 范围敌人(context.Boss, x, y, config.半径 * 0.18);
        for (let i = 0; i < enemies.length; i++) {
          const u = enemies[i];
          造成暗火伤害(context.Boss, u, 计算攻击最大生命伤害(context.Boss, u, config.伤害Boss攻击力比例, config.伤害目标最大生命比例), "AOE", 伤害上下文);
          添加元素层数(u, "暗", config.怨火层数);
        }
      });
    }
  });
}

export function 初始化菲尼克斯尔骸骨弹幕节点(this: void, context: 菲尼克斯尔运行时上下文): void {
  const timerId = 周期(14000, function 菲尼克斯尔骸骨弹幕周期(this: void): void {
    释放菲尼克斯尔骸骨弹幕(context);
  });
  context.清理.登记周期回调("菲尼克斯尔-骸骨弹幕", timerId);
}

export function 注册菲尼克斯尔骸骨弹幕(this: void): void {
  // 第二形态周期机制，由转阶段时初始化。
}


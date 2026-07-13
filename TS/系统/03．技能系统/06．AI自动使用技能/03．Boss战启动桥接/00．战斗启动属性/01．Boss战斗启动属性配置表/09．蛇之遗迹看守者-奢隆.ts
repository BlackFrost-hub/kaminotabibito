/** @noSelfInFile */

import type { 战斗启动属性配置, Boss战斗启动护卫配置 } from "../00．配置类型";
import { 默认Boss弱点数量基础值 } from "../00．配置类型";

export const 单位o000战斗启动属性配置: 战斗启动属性配置 = {
    归类: "Boss",
    单位ID: "o000",
    单位名: "蛇之遗迹看守者-奢隆",
    战斗音乐变量名: "gg_snd_battle002",
    胜利音乐变量名: "gg_snd_shengliBgm",
    地点变量名: "gg_rct______________047",
    转换场景: true,
    BS移动X轴: 27768.10,
    BS移动Y轴: 12959.30,
    玩家移动X轴: 29751.80,
    玩家移动Y轴: 11901.60,
    命中率: 0.25,
    护甲穿透: 0.50,
    弱点数量基础值: 默认Boss弱点数量基础值,
    弱点数量每层N增量: 0,
    天生弱点数: 2,
    枪弱: true,
    暗弱: true,
    器弱伤害需求生命百分比: 0.03,
    护盾基础值: 8,
    护盾每层N增量: 2,
  };

export const 单位o000战斗启动护卫配置: Boss战斗启动护卫配置 = {
    Boss单位ID: "o000",
    Boss单位名: "蛇之遗迹看守者-奢隆",
    护卫血条归属类型: "独立",
    初始护卫批次: {
      广播说话者: "Boss",
      广播文案池: ["上！阻止任何想进入神殿的入侵者"],
      单位列表: [
        {
          单位ID: "nbds",
          单位名: "蛇之看守者(精英)",
          X: 27930.90,
          Y: 13411.40,
          面向: 270.00,
          出生特效模型: "Abilities\\Spells\\Demon\\DarkConversion\\ZombifyTarget.mdl",
          出生特效持续秒: 1.50,
          主Boss死亡时立刻死亡: true,

          显示护卫血条: true,
        },
        {
          单位ID: "nbds",
          单位名: "蛇之看守者(精英)",
          X: 28982.10,
          Y: 13233.30,
          面向: 270.00,
          出生特效模型: "Abilities\\Spells\\Demon\\DarkConversion\\ZombifyTarget.mdl",
          出生特效持续秒: 1.50,
          主Boss死亡时立刻死亡: true,

          显示护卫血条: true,
        },
      ],
    },
  };

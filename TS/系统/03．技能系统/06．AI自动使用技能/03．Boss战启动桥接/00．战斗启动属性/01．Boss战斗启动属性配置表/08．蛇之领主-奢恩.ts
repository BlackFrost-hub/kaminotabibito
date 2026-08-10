/** @noSelfInFile */

import type { 战斗启动属性配置, Boss战斗启动护卫配置 } from "../00．配置类型";
import { 默认Boss弱点数量基础值 } from "../00．配置类型";

export const 单位nbdo战斗启动属性配置: 战斗启动属性配置 = {
    归类: "Boss",
    单位ID: "nbdo",
    单位名: "蛇之领主-奢恩",
    战斗音乐变量名: "gg_snd_battle002",
    胜利音乐变量名: "gg_snd_shengliBgm",
    地点区域名称: "沙漠区域.Boss战区域",
    转换场景: true,
    BS移动X轴: 27768.10,
    BS移动Y轴: 12959.30,
    玩家移动X轴: 29751.80,
    玩家移动Y轴: 11901.60,
    暴击率: 0.40,
    护甲穿透: 0.50,
    弱点数量基础值: 默认Boss弱点数量基础值,
    弱点数量每层N增量: 0,
    天生弱点数: 2,
    额外随机弱点数: 1,
    剑弱: true,
    暗弱: true,
    器弱伤害需求生命百分比: 0.03,
    护盾基础值: 7,
    护盾每层N增量: 2,
  };

export const 单位nbdo战斗启动护卫配置: Boss战斗启动护卫配置 = {
    Boss单位ID: "nbdo",
    Boss单位名: "蛇之领主-奢恩",
    护卫血条归属类型: "独立",
    初始护卫批次: {
      单位列表: [
        {
          单位ID: "nbdw",
          单位名: "蛇之护卫",
          X: 27930.90,
          Y: 13411.40,
          面向: 270.00,
          额外最大生命: 2000,
          出生特效模型: "Abilities\\Spells\\Demon\\DarkConversion\\ZombifyTarget.mdl",
          出生特效持续秒: 1.00,
          主Boss死亡时立刻死亡: true,

          护卫血条优先级: 100,
        },
        {
          单位ID: "nbdw",
          单位名: "蛇之护卫",
          X: 28982.10,
          Y: 13233.30,
          面向: 270.00,
          额外最大生命: 2000,
          出生特效模型: "Abilities\\Spells\\Demon\\DarkConversion\\ZombifyTarget.mdl",
          出生特效持续秒: 1.00,
          主Boss死亡时立刻死亡: true,

          护卫血条优先级: 100,
        },
      ],
    },
    周期护卫批次: {
      间隔毫秒: 42500,
      广播说话者: "护卫",
      广播文案池: [
        "进攻！粉碎入侵者",
        "奢恩大人，我们来帮助你赶跑入侵者",
      ],
      单位列表: [
        {
          单位ID: "nbdw",
          单位名: "蛇之护卫",
          X: 27930.90,
          Y: 13411.40,
          面向: 270.00,
          额外最大生命: 2000,
          出生特效模型: "Abilities\\Spells\\Demon\\DarkConversion\\ZombifyTarget.mdl",
          出生特效持续秒: 1.00,
          主Boss死亡时立刻死亡: true,
        },
        {
          单位ID: "nbds",
          单位名: "蛇之看守者(精英)",
          X: 28982.10,
          Y: 13233.30,
          面向: 270.00,
          额外最大生命: 2000,
          出生特效模型: "Abilities\\Spells\\Demon\\DarkConversion\\ZombifyTarget.mdl",
          出生特效持续秒: 1.00,
          主Boss死亡时立刻死亡: true,
        },
      ],
    },
  };

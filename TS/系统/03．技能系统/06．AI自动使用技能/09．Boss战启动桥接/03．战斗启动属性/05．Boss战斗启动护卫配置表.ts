/** @noSelfInFile */

export interface Boss战斗启动护卫单位配置 {
  单位ID: string;
  单位名?: string;
  X: number;
  Y: number;
  面向?: number;
  额外最大生命?: number;
  出生特效模型?: string;
  出生特效持续秒?: number;
  暴击率?: number;
  普攻伤害吸血?: number;
  主Boss死亡时立刻死亡?: boolean;
}

export interface Boss战斗启动护卫对白配置 {
  延迟毫秒: number;
  说话者: "Boss" | "护卫";
  文案池: string[];
}

export interface Boss战斗启动护卫批次配置 {
  间隔毫秒?: number;
  广播说话者?: "Boss" | "护卫";
  广播文案池?: string[];
  后续对白?: Boss战斗启动护卫对白配置[];
  单位列表: Boss战斗启动护卫单位配置[];
}

export interface Boss战斗启动护卫配置 {
  Boss单位ID: string;
  Boss单位名?: string;
  初始护卫批次?: Boss战斗启动护卫批次配置;
  周期护卫批次?: Boss战斗启动护卫批次配置;
}

export const Boss战斗启动护卫配置表: Boss战斗启动护卫配置[] = [
  {
    Boss单位ID: "o000",
    Boss单位名: "蛇之遗迹看守者-奢隆",
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
        },
      ],
    },
  },
  {
    Boss单位ID: "nbdo",
    Boss单位名: "蛇之领主-奢恩",
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
  },
  {
    Boss单位ID: "N03O",
    Boss单位名: "恶魔领袖",
    初始护卫批次: {
      广播说话者: "护卫",
      广播文案池: [
        "大人，我们来助您一臂之力。",
        "大人，这里的麻烦交给我们处理。",
        "大人，察觉您这边有变，我们立刻赶回来了。",
      ],
      后续对白: [
        {
          延迟毫秒: 3000,
          说话者: "Boss",
          文案池: [
            "很好，你们来得正是时候。此战若胜，少不了你们的奖赏。",
          ],
        },
        {
          延迟毫秒: 5000,
          说话者: "护卫",
          文案池: [
            "愿为大人效死力。",
          ],
        },
      ],
      单位列表: [
        {
          单位ID: "n03N",
          单位名: "恶魔队长",
          X: 26803.00,
          Y: 20921.80,
          面向: 270.00,
          暴击率: 0.40,
          普攻伤害吸血: 0.75,
          主Boss死亡时立刻死亡: false,
        },
        {
          单位ID: "n03N",
          单位名: "恶魔队长",
          X: 26203.00,
          Y: 20921.80,
          面向: 270.00,
          暴击率: 0.40,
          普攻伤害吸血: 0.75,
          主Boss死亡时立刻死亡: false,
        },
      ],
    },
  },
];

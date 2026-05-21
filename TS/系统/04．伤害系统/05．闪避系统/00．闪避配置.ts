/** @noSelfInFile */

export const 闪避系统配置 = {
  生效最低伤害: 1.10,
  最大生命伤害比例门槛: 0.70,
  玩家闪避率上限: 0.25,
  敌人闪避后承伤比例: 0.30,
  闪避文本: "闪避",
  漂浮文字: {
    size: 10,
    red: 128,
    green: 3,
    blue: 3,
    alpha: 204,
    duration: 0.8,
    speedX: 0,
    speedY: 0.07,
    height: 20,
  },
} as const;

export {};

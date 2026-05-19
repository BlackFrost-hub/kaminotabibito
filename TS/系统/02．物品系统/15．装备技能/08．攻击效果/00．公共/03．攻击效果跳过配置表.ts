/** @noSelfInFile */

export interface 攻击效果跳过配置项 {
  来源单位ID?: string;
  需要普通攻击类型?: boolean;
  需要神圣伤害?: boolean;
}

export const 攻击效果跳过配置表: 攻击效果跳过配置项[] = [
  { 来源单位ID: "H015", 需要普通攻击类型: true, 需要神圣伤害: true },
  { 来源单位ID: "E05V", 需要普通攻击类型: true },
];

export {};

/**
 * 召唤物系统 - 输入与规范化类型
 */

export interface 召唤物输入参数 {
  主人单位?: any;
  Master?: any;
  所属玩家?: any;
  player?: any;

  单位类型?: string | number;
  unitType?: string | number;
  uid?: string | number;
  召唤物单位?: any;
  Summon?: any;

  X?: number;
  Y?: number;
  x?: number;
  y?: number;
  位置?: any;
  loc?: any;

  朝向?: number;
  面向?: number;
  facing?: number;
  fac?: number;
  持续时间?: number;
  time?: number;

  飞行高度?: number;
  z?: number;
  moveHeight?: number;
  MoveHeight?: number;

  模型文件?: string;
  模型路径?: string;
  ModelFileID?: string;

  生命值?: number;
  HP?: number;
  生命恢复?: number;
  regenHP?: number;
  攻击力?: number;
  AttackPower?: number;
  攻击间隔?: number;
  atkCd?: number;
  攻击范围?: number;
  射程?: number;
  range?: number;
  Rng?: number;
  普攻弹道模型?: string;
  弹道模型?: string;
  missileModel?: string;
  普攻弹道弧度?: number;
  弹道弧度?: number;
  missileArc?: number;
  普攻弹道速度?: number;
  弹道速度?: number;
  missileSpeed?: number;
  普攻弹道自导?: boolean;
  弹道自导?: boolean;
  missileHoming?: boolean;
  索敌范围?: number;
  主动攻击范围?: number;
  acquireRange?: number;
  acquire?: number;
  护甲?: number;
  def?: number;
  缩放?: number;
  size?: number;

  透明度?: number;
  alpha?: number;
  红?: number;
  red?: number;
  绿?: number;
  green?: number;
  蓝?: number;
  blue?: number;

  是否移除地点?: boolean;
  removeLoc?: boolean;
  b?: boolean;
}

export interface 规范化召唤物参数 {
  主人单位?: any;
  所属玩家?: any;
  单位类型?: number;
  召唤物单位?: any;

  X: number;
  Y: number;
  位置?: any;
  朝向?: number;
  持续时间?: number;
  飞行高度?: number;

  模型文件?: string;
  生命值?: number;
  生命恢复?: number;
  攻击力?: number;
  攻击间隔?: number;
  攻击范围?: number;
  普攻弹道模型?: string;
  普攻弹道弧度?: number;
  普攻弹道速度?: number;
  普攻弹道自导?: boolean;
  索敌范围?: number;
  护甲?: number;
  缩放?: number;

  透明度?: number;
  红?: number;
  绿?: number;
  蓝?: number;

  是否移除地点?: boolean;
}

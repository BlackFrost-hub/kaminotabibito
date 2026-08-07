/** @noSelfInFile */

export type 封印守卫战敌人类型 =
  | "失控英灵"
  | "夺灵祭司"
  | "锚蚀兽"
  | "断誓猎手"
  | "黑暗残响"
  | "裂誓重卫"
  | "失律号令者"
  | "潮蚀巡鳞者"
  | "碎礁投石手"
  | "灵潮祭司"
  | "金鳞执刑官"
  | "深渊鳞将";

export interface 封印守卫战锚点状态 {
  编号: number;
  X: number;
  Y: number;
  已完成: boolean;
  已压制: boolean;
}

export interface 封印守卫战第三章技能环境 {
  读取能量核心(this: void): any;
  读取锚点状态(this: void, 锚点编号: number): 封印守卫战锚点状态 | undefined;
  设置锚点压制(this: void, 锚点编号: number, 已压制: boolean): void;
  读取玩家英雄列表(this: void): any[];
  读取正在修复锚点的英雄列表(this: void): any[];
}

export interface 封印守卫战敌人记录 {
  单位: any;
  句柄ID: number;
  类型: 封印守卫战敌人类型;
  下次AI毫秒: number;
  下次技能毫秒: number;
  充能ID: number;
  当前目标?: any;
  锚点编号: number;
  正在压制锚点: boolean;
  压制特效?: any;
  普攻计数: number;
  上次被动毫秒: number;
  号令结束毫秒: number;
  号令属性已施加: boolean;
  号令移动速度增量: number;
  附加状态?: Record<string, any>;
}

export interface 封印守卫战敌人机制状态 {
  运行中: boolean;
  环境?: 封印守卫战第三章技能环境;
  敌人列表: 封印守卫战敌人记录[];
  敌人映射: Record<number, 封印守卫战敌人记录 | undefined>;
  锚点压制数量: number[];
}

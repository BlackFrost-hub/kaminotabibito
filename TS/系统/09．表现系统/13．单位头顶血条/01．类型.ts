/** @noSelfInFile */

export interface 单位血条帧组 {
  槽位: number;
  root: number;
  lifeLag: number;
  life: number;
  shields: number[];
  mana: number;
  name: number;
}

export interface 单位血条绑定 {
  单位: any;
  单位ID: number;
  帧: 单位血条帧组;
  最大生命缓存: number;
  最大魔法缓存: number;
  是否英雄: boolean;
  生命贴图缓存: string;
  生命缓降比例: number;
  护盾贴图缓存: string[];
}

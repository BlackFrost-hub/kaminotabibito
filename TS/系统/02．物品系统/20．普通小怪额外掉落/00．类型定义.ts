/** @noSelfInFile */

export type 普通小怪掉落章节 = 1 | 2 | 3;

export interface 章节额外掉落装备 {
  物品ID: string;
  评分: number;
}

export interface 普通小怪掉落资格 {
  章节: 普通小怪掉落章节;
  最高可掉评分: number;
}


/** @noSelfInFile */

import type { 测试二维点, 测试矩形配置 } from "../00．测试系统辅助函数";

export interface Boss测试场地定义 {
  正式中心: 测试二维点;
  测试空地中心: 测试二维点;
  正式战斗矩形?: 测试矩形配置;
  正式安全区矩形列表?: 测试矩形配置[];
}

export interface Boss测试技能命令 {
  序号: number;
  名称: string;
  执行: (this: void, player: any, context: any) => void;
}

export interface Boss测试注册配置 {
  命令单位名: string;
  Boss名称: string;
  场地?: Boss测试场地定义;
  创建或获取上下文: (this: void, player: any) => any;
  清理上下文: (this: void, player: any, context: any) => void;
  技能命令列表: Boss测试技能命令[];
}

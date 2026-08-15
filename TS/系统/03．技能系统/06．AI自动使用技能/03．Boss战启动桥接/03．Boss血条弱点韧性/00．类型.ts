/** @noSelfInFile */

import type { Boss战运行上下文 } from "../01．Boss战运行/01．Boss战运行上下文";

export type Boss弱点类别 = "武器" | "属性";
export type Boss血条显示类型 = "主Boss" | "护卫";
export type Boss护卫血条归属类型 = "共享" | "独立";
export type Boss弱点调查原因 =
  | "成功"
  | "单位无效"
  | "Boss状态不存在"
  | "弱点机制未启用"
  | "弱点UI尚未注册"
  | "弱点结算尚未注册"
  | "护盾破碎中"
  | "没有未显现弱点";

export interface Boss弱点调查结果 {
  成功: boolean;
  原因: Boss弱点调查原因;
  弱点索引: number;
  弱点键: string;
  当前护盾值: number;
  是否护盾破碎中: boolean;
}

export interface Boss弱点定义 {
  弱点键: string;
  类别: Boss弱点类别;
  贴图路径: string;
  显示名: string;
  提示颜色: string;
}

export interface Boss弱点韧性配置 {
  配置键: string;
  Boss单位名?: string;
  Boss引用键?: string;
  天生弱点数?: number;
  弱点列表: Boss弱点定义[];
  初始护盾值?: number;
  弱点伤害需求?: number;
  弱点冷却毫秒?: number;
  护盾冷却毫秒?: number;
  弱点发现音效路径?: string;
  弱点击中音效路径?: string;
  护盾破碎音效路径?: string;
  弱点发现提示启用?: boolean;
  护盾命中削减值?: number;
  弱点命中表现毫秒?: number;
  弱点命中伤害加成?: number;
  破盾控制Buff类型?: number;
  破盾控制持续秒?: number;
  破盾伤害倍率?: number;
  破碎护盾显示毫秒?: number;
}

export interface Boss血条弱点韧性运行状态 {
  Boss句柄ID: number;
  Boss单位: any;
  运行上下文: Boss战运行上下文;
  配置?: Boss弱点韧性配置;
  显示类型: Boss血条显示类型;
  所属主Boss句柄ID: number;
  护卫血条归属类型: Boss护卫血条归属类型;
  是否启用机制UI: boolean;
  是否血条已注册: boolean;
  是否弱点已注册: boolean;
  是否伤害结算已注册: boolean;
  是否已结束: boolean;
  血条槽位索引: number;
  护卫槽位索引: number;
  血条Frame: number;
  损失血条Frame: number;
  头像Frame: number;
  头像覆盖贴图路径: string;
  血量文本Frame: number;
  护盾框Frame: number;
  护盾填充Frame: number;
  弱点UIFrame列表: number[];
  弱点问号Frame列表: number[];
  弱点图标Frame列表: number[];
  弱点X轴列表: number[];
  弱点已暴露列表: boolean[];
  弱点保护列表: boolean[];
  弱点保护截止毫秒列表: number[];
  弱点命中表现截止毫秒列表: number[];
  武器弱点伤害累计: number;
  待处理弱点命中索引: number;
  当前护盾值: number;
  最大护盾值: number;
  是否护盾破碎中: boolean;
  护盾破碎切灰截止毫秒: number;
  护盾恢复截止毫秒: number;
  护盾图标Frame: number;
  灰色护盾Frame: number;
  破碎护盾Frame: number;
  护盾文本Frame: number;
  护盾说明按钮Frame: number;
  护盾提示文本框Frame: number;
  护盾提示文本Frame: number;
}

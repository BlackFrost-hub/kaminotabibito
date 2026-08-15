/** @noSelfInFile */
// 塞拉斯 D：天赋技「调查 Boss 弱点」（A0JP）。
// 只调用 Boss 弱点公共接口 调查Boss弱点()；不复制旧 JASS 的 YD 弱点字段、
// 保护护盾切换和 10 点裸伤害触发逻辑。接口为同步玩法逻辑，禁止放入本地分支。

import { 塞拉斯技能配置 } from "./00．配置";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;

const { 调查Boss弱点 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.03．Boss血条弱点韧性.08．对外接口") as {
  调查Boss弱点: (this: void, Boss单位: any, 来源单位?: any) => {
    成功: boolean;
    原因: string;
    弱点索引: number;
    弱点键: string;
    当前护盾值: number;
    是否护盾破碎中: boolean;
  };
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};

const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetLocalPlayer = jass.GetLocalPlayer as (this: void) => any;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (
  this: void,
  player: any,
  x: number,
  y: number,
  duration: number,
  message: string,
) => void;

const 配置 = 塞拉斯技能配置;
const 英雄单位类型ID = 配置.单位类型ID;

interface D上下文 {
  施法者: any;
}

function 获取或创建D上下文(this: void, unit: any): D上下文 | undefined {
  if (unit == null || unit === 0) return undefined;
  return { 施法者: unit };
}

function 本地提示施法者(this: void, caster: any, 文本: string): void {
  const owner = GetOwningPlayer(caster);
  if (owner == null || owner === 0) return;
  // 仅本地表现：文字提示允许本地分支
  if (GetLocalPlayer() === owner) {
    DisplayTimedTextToPlayer(owner, 0, 0, 配置.D.提示持续秒, 文本);
  }
}

function 释放D调查弱点(this: void, _context: D上下文, caster: any): void {
  const target = GetSpellTargetUnit();
  if (target == null || target === 0) return;

  // 目标校验：必须是当前 Boss 战单位（与源 JASS 对齐）
  const 当前Boss单位 = YDUserDataGetSafe("string", "Boss战", "单位", "unit");
  if (当前Boss单位 == null || 当前Boss单位 === 0 || 当前Boss单位 !== target) {
    本地提示施法者(caster, 配置.D.错误提示);
    return;
  }

  // 播放点与源 JASS 对齐：校验通过后立即在施法者身上播放 D 音效
  Sound3DII_UnitPlayReuse(配置.D.音效.路径, caster, 配置.D.音效.裁断距离);

  // 调用 Boss 弱点公共接口：显现未显现弱点并削盾 1 点（接口内部播放弱点发现音效，不重复播放）
  const result = 调查Boss弱点(target, caster);
  if (!result.成功) {
    // 没有未显现弱点/破盾中/状态未注册：不对 Boss 造成任何额外伤害或状态修改
    本地提示施法者(caster, "调查结果：" + result.原因);
  }
}

export function 注册塞拉斯D(this: void): void {
  注册单位技能壳监听({
    名称: "塞拉斯-天赋技调查（D）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 配置.D.技能ID,
    获取或创建上下文: 获取或创建D上下文,
    释放技能: 释放D调查弱点,
    创建独立技能实例: false,
  });
}

注册塞拉斯D();

export const 塞拉斯D技能状态 = {
  已完成设计: true,
  已完成实现: true,
  伤害形态: "无伤害",
  效果: "调用 调查Boss弱点() 显现一个未显现弱点并削盾 1 点",
  失败分支: "单位无效/Boss状态不存在/弱点机制未启用/护盾破碎中/没有未显现弱点 → 本地提示",
} as const;

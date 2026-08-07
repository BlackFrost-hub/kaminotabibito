/** @noSelfInFile */

const jass = require("jass.common") as any;

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, 施法单位: any, 技能ID: number) => void) => void;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, 单位: any) => boolean;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, 原始ID: string | undefined | null) => number;
};
const { 启动剧情Boss战 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接") as {
  启动剧情Boss战: (this: void, Boss单位: any, 参数?: { 触发单位?: any }) => boolean;
};
const { 读取卡瑟拉单位, 是否卡瑟拉入口对白已完成 } = require("系统.11．剧情系统.02．支线任务.01．被驱逐的水怪.00．入口配置") as {
  读取卡瑟拉单位: (this: void) => any;
  是否卡瑟拉入口对白已完成: (this: void) => boolean;
};

import { 挑战技能配置表, type 挑战技能配置 } from "./00．挑战技能配置";

const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, 单位: any) => number;

let 已初始化挑战技能 = false;
let 卡瑟拉Boss战已启动 = false;

function 读取挑战技能配置(this: void, 技能ID: number): 挑战技能配置 | null {
  for (const 配置 of 挑战技能配置表) {
    if (stringToFourCCSafe(配置.技能ID) === 技能ID) return 配置;
  }
  return null;
}

function on挑战技能生效(this: void, 施法单位: any, 技能ID: number): void {
  if (卡瑟拉Boss战已启动 || 施法单位 == null || 施法单位 === 0) return;

  const 配置 = 读取挑战技能配置(技能ID);
  if (配置 == null || !是玩家英雄组单位(施法单位)) return;

  const 目标单位 = GetSpellTargetUnit();
  const 卡瑟拉 = 读取卡瑟拉单位();
  // 卡瑟拉只会在任务接取后的动作中创建；存在即代表该全局入口已解锁。
  if (目标单位 == null || 目标单位 === 0 || 卡瑟拉 == null || 卡瑟拉 === 0) return;
  if (!是否卡瑟拉入口对白已完成()) return;
  if (目标单位 !== 卡瑟拉) return;
  if (GetUnitTypeId(目标单位) !== stringToFourCCSafe(配置.目标单位ID)) return;

  if (启动剧情Boss战(卡瑟拉, { 触发单位: 施法单位 })) {
    卡瑟拉Boss战已启动 = true;
  }
}

export function init挑战技能(this: void): void {
  if (已初始化挑战技能) return;
  已初始化挑战技能 = true;
  registerSpellEffectListener(on挑战技能生效);
}

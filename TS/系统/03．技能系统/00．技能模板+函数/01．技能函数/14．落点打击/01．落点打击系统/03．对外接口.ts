/** @noSelfInFile */
/**
 * 落点打击系统 - 定时器管理、实例生命周期与对外接口
 */

import {
  type 落点打击参数, type 落点打击内部实例,
  落点打击实例表, 推进下一个落点打击ID,
} from "./00．共享";
import { 创建落点列表 } from "./01．落点生成";
import { 结算单次落点伤害, 创建落点提示特效 } from "./02．特效与伤害";

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

const { 创建命中规则状态 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.10．命中规则") as {
  创建命中规则状态: (this: void, 参数?: any) => any;
};

const 落点打击计时检查间隔毫秒 = 10;
const 待结算实例ID列表: number[] = [];
const 待结算落点序号列表: number[] = [];
const 待结算到期毫秒列表: number[] = [];
let 落点打击计时检查回调ID = 0;

function 结束落点打击实例(实例ID: number): void {
  const 实例 = 落点打击实例表[实例ID];
  if (实例 == null) {
    return;
  }

  delete 落点打击实例表[实例ID];
  实例.参数.on全部完成?.(实例ID);
}

function 结算到时落点(实例ID: number, 落点序号: number): void {
  const 实例 = 落点打击实例表[实例ID];
  if (实例 == null) {
    return;
  }

  结算单次落点伤害(实例, 落点序号);
  实例.剩余落点数 -= 1;
  if (实例.剩余落点数 <= 0) {
    结束落点打击实例(实例.id);
  }
}

function 停止落点打击计时检查(): void {
  if (落点打击计时检查回调ID <= 0) return;
  removePeriodicCallback(落点打击计时检查回调ID);
  落点打击计时检查回调ID = 0;
}

function on落点打击计时检查(this: void): void {
  const now = getServerTime();
  let writeIndex = 0;
  for (let i = 0; i < 待结算实例ID列表.length; i++) {
    if (now >= 待结算到期毫秒列表[i]) {
      结算到时落点(待结算实例ID列表[i], 待结算落点序号列表[i]);
    } else {
      待结算实例ID列表[writeIndex] = 待结算实例ID列表[i];
      待结算落点序号列表[writeIndex] = 待结算落点序号列表[i];
      待结算到期毫秒列表[writeIndex] = 待结算到期毫秒列表[i];
      writeIndex += 1;
    }
  }

  for (let i = 待结算实例ID列表.length - 1; i >= writeIndex; i--) {
    待结算实例ID列表.pop();
    待结算落点序号列表.pop();
    待结算到期毫秒列表.pop();
  }

  if (待结算实例ID列表.length <= 0) {
    停止落点打击计时检查();
  }
}

function 确保落点打击计时检查(): void {
  if (落点打击计时检查回调ID > 0) return;
  落点打击计时检查回调ID = addPeriodicCallback(落点打击计时检查间隔毫秒, on落点打击计时检查);
}

function 启动单个落点计时器(实例ID: number, 落点序号: number, 延迟: number): void {
  待结算实例ID列表.push(实例ID);
  待结算落点序号列表.push(落点序号);
  待结算到期毫秒列表.push(getServerTime() + (延迟 > 0 ? 延迟 * 1000 : 0));
  确保落点打击计时检查();
}

export function 创建落点打击(参数: 落点打击参数): number {
  if (参数.伤害半径 <= 0) {
    return 0;
  }

  const 落点列表 = 创建落点列表(参数);
  if (落点列表.length <= 0) {
    return 0;
  }

  const 实例ID = 推进下一个落点打击ID();

  const 实例: 落点打击内部实例 = {
    id: 实例ID,
    参数,
    落点列表,
    剩余落点数: 落点列表.length,
    命中规则状态: 创建命中规则状态({
      每单位最大命中次数: 参数.每单位最大命中次数,
    }),
  };
  落点打击实例表[实例ID] = 实例;

  let i = 0;
  while (i < 落点列表.length) {
    const 落点 = 落点列表[i];
    创建落点提示特效(参数, 落点);
    启动单个落点计时器(实例ID, i, 落点.触发延迟 > 0 ? 落点.触发延迟 : 0);
    i += 1;
  }

  return 实例ID;
}

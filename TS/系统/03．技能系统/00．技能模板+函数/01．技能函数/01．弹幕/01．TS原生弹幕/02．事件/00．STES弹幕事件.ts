/** @noSelfInFile */
/**
 * TS 原生弹幕 - STES 事件传参
 *
 * 子触发可通过 YDLocal5Get 读取：
 * 弹幕ID、弹幕单位、来源单位、目标单位、伤害值、剩余生命、结束原因。
 */

import type { 原生弹幕内部实例, 原生弹幕结束原因 } from "../00．类型";

const jass = require("jass.common") as any;
const { STES_GetTable } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
  STES_GetTable: (this: void, self: any) => any;
};
const { YDLocalExecuteTrigger, YDTriggerExecuteTrigger, saveParentIndex } = require("lib.扩展函数.YDWE函数.04．YDWE_trigger") as {
  YDLocalExecuteTrigger: (this: void, trg: any) => void;
  YDTriggerExecuteTrigger: (this: void, trg: any, flag: boolean) => void;
  saveParentIndex: (this: void, trg: any) => void;
};
const { YDLocal5Set, flushYDLocal5ParamPage, _indexStack, getG_SIndex, setG_SIndex, setG_LIndex } = require("lib.扩展函数.YDWE函数.02．YDLocal兼容") as {
  YDLocal5Set: (this: void, type: any, name: string, value: any) => void;
  flushYDLocal5ParamPage: (this: void) => void;
  _indexStack: number[];
  getG_SIndex: (this: void) => number;
  setG_SIndex: (this: void, v: number) => void;
  setG_LIndex: (this: void, v: number) => void;
};

const StringHash = jass.StringHash as (s: string) => number;
const LoadInteger = jass.LoadInteger as (h: any, parentKey: number, childKey: number) => number;
const LoadTriggerHandle = jass.LoadTriggerHandle as (h: any, parentKey: number, childKey: number) => any;

const skey_index = StringHash("index");

export interface 原生弹幕事件载荷 {
  目标单位?: any;
  来源单位?: any;
  伤害值?: number;
  结束原因?: 原生弹幕结束原因;
}

function 写入弹幕YDLocal5参数(this: void, 实例: 原生弹幕内部实例, 载荷: 原生弹幕事件载荷): void {
  YDLocal5Set("integer", "弹幕ID", 实例.id);
  YDLocal5Set("unit", "弹幕单位", 实例.弹幕单位);
  YDLocal5Set("unit", "来源单位", 实例.参数.所有者);
  YDLocal5Set("unit", "目标单位", 载荷.目标单位 ?? null);
  YDLocal5Set("unit", "阻挡来源单位", 载荷.来源单位 ?? null);
  YDLocal5Set("real", "伤害值", 载荷.伤害值 ?? 实例.当前伤害值);
  YDLocal5Set("real", "剩余生命", 实例.剩余生命);
  YDLocal5Set("string", "结束原因", 载荷.结束原因 ?? "");
}

export function 触发原生弹幕STES事件(this: void, 事件名: string | undefined, 实例: 原生弹幕内部实例, 载荷: 原生弹幕事件载荷 = {}): void {
  if (事件名 == null || 事件名 === "") return;

  const ht = STES_GetTable(null);
  if (ht == null || ht === 0) return;

  const hash = StringHash(事件名);
  const count = LoadInteger(ht, hash, skey_index);
  if (count <= 0) return;

  _indexStack.push(getG_SIndex());
  for (let i = 0; i < count; i++) {
    const trg = LoadTriggerHandle(ht, hash, i);
    if (trg != null && trg !== 0) {
      YDLocalExecuteTrigger(trg);
      saveParentIndex(trg);
      写入弹幕YDLocal5参数(实例, 载荷);
      YDTriggerExecuteTrigger(trg, false);
      flushYDLocal5ParamPage();
    }
  }

  const prevIndex = _indexStack.length > 0 ? _indexStack.pop()! : 0;
  setG_SIndex(prevIndex);
  setG_LIndex(prevIndex);
}

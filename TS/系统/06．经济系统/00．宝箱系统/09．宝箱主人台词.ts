/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;
const GetRandomInt = jass.GetRandomInt as (lowBound: number, highBound: number) => number;
const GetUnitName = jass.GetUnitName as (whichUnit: any) => string;
const GetOwningPlayer = jass.GetOwningPlayer as (whichUnit: any) => any;
const GetPlayerName = jass.GetPlayerName as (whichPlayer: any) => string;

const { 注册宝箱准备开启回调 } = require("系统.06．经济系统.00．宝箱系统.04．准备开启回调") as {
  注册宝箱准备开启回调: (this: void, callback: (unit: any, target: any, progressBar: any, openTime: number, chestConfig: any, ownerUnit?: any) => void) => void;
};
const { 注册宝箱开启完成回调 } = require("系统.06．经济系统.00．宝箱系统.06．开启完成回调") as {
  注册宝箱开启完成回调: (this: void, callback: (unit: any, target: any, progressBar: any, openTime: number, chestConfig: any, ownerUnit?: any) => void) => void;
};
const { 广播宝箱主人提示, 广播单位类型提示 } = require("系统.06．经济系统.00．宝箱系统.07．主人广播") as {
  广播宝箱主人提示: (this: void, 主人单位: any, 文本: string, 持续时间?: number) => void;
  广播单位类型提示: (this: void, 单位类型ID: number, 文本: string, 持续时间?: number) => void;
};
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  stringToFourCC: (this: void, s: string) => number;
};
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

type 阶段 = "prepare" | "complete";
const 准备开启持续毫秒 = 4800;
const 开启完成持续毫秒 = 4800;

interface 台词配置 {
  准备开启: string[];
  开启完成: string[];
  冷却秒数: number;
}

const 宝箱台词配置 = new Map<string, 台词配置>([
  ["LTbs", {
    准备开启: [
      "小老鼠，{开启者}，也太目中无人了吧？",
      "嘿，贪婪的家伙{开启者}，休想从我这儿轻松得手！",
    ],
    开启完成: [
      "{玩家名}，还真被你得手了，可恶！（莫斯特永久提高3%基础攻击力）",
      "我的珍藏！{玩家名}，你成功惹怒了我！（莫斯特永久提高3%基础攻击力）",
    ],
    冷却秒数: 5,
  }],
]);

const 冷却表 = new Map<string, boolean>();
const 冷却检查间隔毫秒 = 100;
let 冷却检查回调ID = 0;
const 冷却键列表: string[] = [];
const 冷却到期毫秒列表: number[] = [];

function 构造冷却键(this: void, 阶段名: 阶段, 开启者: any, 主人单位: any, 宝箱配置: any): string {
  const openerId = 开启者 ? GetHandleId(开启者) : 0;
  const ownerId = 主人单位 ? GetHandleId(主人单位) : 0;
  const chestType = 宝箱配置?.destructableType ?? "";
  return `${阶段名}:${chestType}:${openerId}:${ownerId}`;
}

function 取随机台词(this: void, 列表: string[]): string | undefined {
  if (列表.length === 0) return undefined;
  if (列表.length === 1) return 列表[0];
  const index = GetRandomInt(1, 列表.length) - 1;
  return 列表[index];
}

function 替换台词变量(this: void, 模板: string, 开启者: any): string {
  let 文本 = 模板;
  const 开启者名字 = 开启者 ? GetUnitName(开启者) : "有人";
  const 玩家名字 = 开启者 ? GetPlayerName(GetOwningPlayer(开启者)) : "有人";
  文本 = 文本.replace("{开启者}", `（${开启者名字}）`);
  文本 = 文本.replace("{玩家名}", 玩家名字);
  return 文本;
}

function 冷却结束回调(this: void): void {
  const now = getServerTime();
  let writeIndex = 0;
  for (let i = 0; i < 冷却键列表.length; i++) {
    const key = 冷却键列表[i];
    const dueMs = 冷却到期毫秒列表[i];
    if (now >= dueMs) {
      冷却表.delete(key);
    } else {
      冷却键列表[writeIndex] = key;
      冷却到期毫秒列表[writeIndex] = dueMs;
      writeIndex++;
    }
  }
  for (let i = 冷却键列表.length - 1; i >= writeIndex; i--) {
    冷却键列表.pop();
    冷却到期毫秒列表.pop();
  }
  if (冷却键列表.length === 0 && 冷却检查回调ID !== 0) {
    removePeriodicCallback(冷却检查回调ID);
    冷却检查回调ID = 0;
  }
}

function 启动冷却检查(this: void): void {
  if (冷却检查回调ID !== 0) return;
  冷却检查回调ID = addPeriodicCallback(冷却检查间隔毫秒, 冷却结束回调);
}

function 记录冷却(this: void, key: string, cooldownSeconds: number): void {
  冷却表.set(key, true);
  冷却键列表.push(key);
  冷却到期毫秒列表.push(getServerTime() + cooldownSeconds * 1000);
  启动冷却检查();
}

function 尝试广播主人台词(this: void, 阶段名: 阶段, 开启者: any, 宝箱配置: any, 主人单位?: any): void {
  const chestType = 宝箱配置?.destructableType;
  if (!chestType) return;
  const 配置 = 宝箱台词配置.get(chestType);
  if (!配置) return;

  const key = 构造冷却键(阶段名, 开启者, 主人单位, 宝箱配置);
  if (冷却表.has(key)) return;

  const 候选 = 阶段名 === "prepare" ? 配置.准备开启 : 配置.开启完成;
  const 模板 = 取随机台词(候选);
  if (!模板) return;

  const 文本 = 替换台词变量(模板, 开启者);
  if (阶段名 === "complete") {
    if (主人单位) {
      广播宝箱主人提示(主人单位, 文本, 开启完成持续毫秒);
    } else if (宝箱配置?.主人配置?.单位类型) {
      广播单位类型提示(stringToFourCC(宝箱配置.主人配置.单位类型), 文本, 开启完成持续毫秒);
    } else {
      return;
    }
  } else if (主人单位) {
    广播宝箱主人提示(主人单位, 文本, 准备开启持续毫秒);
  } else if (宝箱配置?.主人配置?.单位类型) {
    广播单位类型提示(stringToFourCC(宝箱配置.主人配置.单位类型), 文本, 准备开启持续毫秒);
  } else {
    return;
  }

  记录冷却(key, 配置.冷却秒数);
}

function onChestPrepare(this: void, unit: any, _target: any, _progressBar: any, _openTime: number, chestConfig: any, ownerUnit?: any): void {
  尝试广播主人台词("prepare", unit, chestConfig, ownerUnit);
}

function onChestComplete(this: void, unit: any, _target: any, _progressBar: any, _openTime: number, chestConfig: any, ownerUnit?: any): void {
  尝试广播主人台词("complete", unit, chestConfig, ownerUnit);
}

注册宝箱准备开启回调(onChestPrepare);
注册宝箱开启完成回调(onChestComplete);

export {};

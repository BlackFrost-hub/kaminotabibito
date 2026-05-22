/** @noSelfInFile */
/**
 * Boss 自动技能启动桥接
 *
 * 当前仅做壳子：
 * - 监听 STES「Boss战启动」
 * - 优先读 STES 里的 `Boss`
 * - 若没有，则延迟一帧后读 `Boss战.单位` 与 `Boss战.绑定单位`
 * - 读到 Boss 后仅登记到本地注册表，真正的 Boss 主动施法逻辑后续再接
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { registerStesListener } = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具") as {
  registerStesListener: (this: void, eventName: string, callback: () => void) => any | null;
};
const {
  ydlStes_syncTriggerStep,
  ydlStes_finishChildCleanup,
  ydlStes_readUnit5,
} = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具") as {
  ydlStes_syncTriggerStep: (this: void, self: any) => void;
  ydlStes_finishChildCleanup: (this: void, self: any) => void;
  ydlStes_readUnit5: (this: void, self: any, name: string) => any;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const {
  Boss战启动STES事件名,
  Boss战表名,
  Boss战单位字段,
  Boss战绑定单位字段,
  Boss战启动桥接模块名,
  Boss战启动延迟毫秒,
} = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.00．常量定义") as {
  Boss战启动STES事件名: string;
  Boss战表名: string;
  Boss战单位字段: string;
  Boss战绑定单位字段: string;
  Boss战启动桥接模块名: string;
  Boss战启动延迟毫秒: number;
};
const {
  记录Boss自动技能启动,
  是否已登记Boss自动技能,
} = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.01．Boss自动技能注册表") as {
  记录Boss自动技能启动: (this: void, unit: any, source: "STES.Boss" | "Boss战.单位" | "Boss战.绑定单位") => any;
  是否已登记Boss自动技能: (this: void, unit: any) => boolean;
};

const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;
const GetUnitName = jass.GetUnitName as (whichUnit: any) => string;
const LoadInteger = jass.LoadInteger as (table: any, parentKey: number, childKey: number) => number;
const StringHash = jass.StringHash as (value: string) => number;

let Boss战启动Stes触发器: any | null = null;

const REG_GUARD = "__syzl_boss_ai_start_registered";
const TRIG_KEY = "__syzl_boss_ai_start_trig";
const ATTEMPT_KEY = "__syzl_boss_ai_start_reg_attempt";
const MAX_REG_ATTEMPTS = 30;
const RETRY_DELAY_MS = 100;

const 待补读Boss句柄表: Record<number, true | undefined> = {};

function jassStesHashtable(this: void): any {
  const cands = [jglobals.STES___HT, jglobals.STES_HT, jglobals.udg_STES___HT, jglobals.udg_STES_HT];
  for (let i = 0; i < cands.length; i++) {
    const ht = cands[i];
    if (ht != null && ht !== 0) return ht;
  }
  return null;
}

function countOnJassStesTable(this: void, eventName: string): number {
  const ht = jassStesHashtable();
  if (ht == null || ht === 0) return -1;
  return LoadInteger(ht, StringHash(eventName), StringHash("index"));
}

function 打印Boss战启动跳过(this: void, reason: string): void {
  debugLogForce(Boss战启动桥接模块名, "跳过", reason);
}

function 读取Boss战YD变量单位(this: void): any {
  return YDUserDataGetSafe("string", Boss战表名, Boss战单位字段, "unit");
}

function 读取Boss战YD绑定单位(this: void): any {
  return YDUserDataGetSafe("string", Boss战表名, Boss战绑定单位字段, "unit");
}

function 登记Boss自动技能启动(this: void, bossUnit: any, source: "STES.Boss" | "Boss战.单位" | "Boss战.绑定单位"): void {
  if (bossUnit == null || bossUnit === 0) return;
  if (是否已登记Boss自动技能(bossUnit)) {
    debugLogForce(Boss战启动桥接模块名, "已登记，跳过重复注册", "source=", source, "name=", GetUnitName(bossUnit));
    return;
  }
  记录Boss自动技能启动(bossUnit, source);
  debugLogForce(Boss战启动桥接模块名, "登记Boss自动技能壳子", "source=", source, "name=", GetUnitName(bossUnit));
}

function 尝试从YDUserData补读Boss(this: void, bossHandleId: number): void {
  待补读Boss句柄表[bossHandleId] = undefined;

  const bossUnit = 读取Boss战YD变量单位();
  if (bossUnit != null && bossUnit !== 0) {
    登记Boss自动技能启动(bossUnit, "Boss战.单位");
    return;
  }

  const bindUnit = 读取Boss战YD绑定单位();
  if (bindUnit != null && bindUnit !== 0) {
    登记Boss自动技能启动(bindUnit, "Boss战.绑定单位");
    return;
  }

  打印Boss战启动跳过("STES 已触发，但 Boss / 绑定单位 均为空");
}

function onBoss战启动延迟补读(this: void): void {
  const 列表 = Object.keys(待补读Boss句柄表);
  for (let i = 0; i < 列表.length; i++) {
    const handleId = Number(列表[i]) || 0;
    if (handleId > 0 && 待补读Boss句柄表[handleId]) {
      尝试从YDUserData补读Boss(handleId);
    }
  }
}

function 安排一帧后补读Boss(this: void): void {
  addDelayedCallback(Boss战启动延迟毫秒, onBoss战启动延迟补读);
}

function 处理Boss战启动Stes(this: void): void {
  try {
    ydlStes_syncTriggerStep(undefined);

    const stesBoss = ydlStes_readUnit5(undefined, "Boss");
    if (stesBoss != null && stesBoss !== 0) {
      登记Boss自动技能启动(stesBoss, "STES.Boss");
      return;
    }

    const handleId = GetHandleId(jass.GetTriggeringTrigger());
    待补读Boss句柄表[handleId] = true;
    安排一帧后补读Boss();
  } finally {
    ydlStes_finishChildCleanup(undefined);
  }
}

function onBoss战启动Stes事件Action(this: void): void {
  处理Boss战启动Stes();
}

function onRetryRegisterBoss战启动Stes(this: void): void {
  tryRegisterBoss战启动Stes();
}

function scheduleRetry(this: void): void {
  addDelayedCallback(RETRY_DELAY_MS, onRetryRegisterBoss战启动Stes);
}

function tryRegisterBoss战启动Stes(this: void): void {
  const g = globalThis as any;
  if (g[REG_GUARD]) return;

  if (g[TRIG_KEY] == null) {
    Boss战启动Stes触发器 = registerStesListener(Boss战启动STES事件名, onBoss战启动Stes事件Action);
    g[TRIG_KEY] = Boss战启动Stes触发器;
  } else {
    Boss战启动Stes触发器 = g[TRIG_KEY];
  }

  const jCount = countOnJassStesTable(Boss战启动STES事件名);
  const attempt = (g[ATTEMPT_KEY] as number) || 0;
  g[ATTEMPT_KEY] = attempt + 1;

  if (jCount >= 1) {
    g[REG_GUARD] = true;
    debugLogForce(Boss战启动桥接模块名, "注册成功", "event=", Boss战启动STES事件名, "count=", jCount);
    return;
  }

  if (g[ATTEMPT_KEY] >= MAX_REG_ATTEMPTS) {
    debugLogForce(Boss战启动桥接模块名, "注册失败", "event=", Boss战启动STES事件名, "最后计数=", jCount);
    return;
  }

  scheduleRetry();
}

export function 注册Boss战启动Stes桥接(this: void): void {
  tryRegisterBoss战启动Stes();
}

注册Boss战启动Stes桥接();

/** @noSelfInFile */
/**
 * 技能自我打断预留接口
 *
 * 说明：
 * 1. 这里只维护“可自我打断技能阶段”的登记与上报，不直接绑定命令事件
 * 2. 未来若要接“单位发布打断命令 / 按下 S”，命令系统只需要调用 `报告单位自我打断`
 * 3. 当前硬直使用 `EXPauseUnit`，暂停中的单位能否稳定发出命令还需游戏内继续验证
 */

const jass = require("jass.common") as any;
let japi: any = null;
try {
  japi = require("jass.japi") as any;
} catch (_e) {
  japi = null;
}

const { DzTriggerRegisterKeyEventTrg } = require("lib.扩展函数.KK扩展API.index") as {
  DzTriggerRegisterKeyEventTrg: (trg: any, status: number, btn: number | string) => void;
};
const { KEY, KEY_STATE } = require("lib.扩展函数.封装函数.04．硬件输入.index") as {
  KEY: { S: number };
  KEY_STATE: { DOWN: number; UP: number };
};
const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataGet: (tableTypeName: string, tableKey: any, attr: string, valueTypeName: "unit") => any;
};
const 选中单位事件中心 = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心") as {
  getSoleSelectedUnitForPlayer?: (this: void, playerId: number) => any | null;
};

const GetHandleId = jass.GetHandleId as (h: any) => number;
const GetPlayerId = jass.GetPlayerId as (p: any) => number;
const TriggerAddAction = jass.TriggerAddAction as (trg: any, action: () => void) => void;
const CreateTrigger = jass.CreateTrigger as () => any;

export type 技能自我打断方式 = "停止命令" | "打断命令" | "按下S" | "未知";
export type 技能自我打断回调 = (this: void, 单位: any, 阶段ID: number, 方式: 技能自我打断方式) => void;

interface 技能自我打断监听 {
  单位: any;
  阶段ID: number;
  回调: 技能自我打断回调;
}

const 阶段监听表: Record<number, 技能自我打断监听 | undefined> = {};
const 单位监听表: Record<number, number[]> = {};
let 自我打断S键已初始化 = false;
let 自我打断S键触发器: any = null;

function 取句柄ID(h: any): number {
  return (h != null && h !== 0 ? GetHandleId(h) : 0) || 0;
}

export function 注册技能自我打断监听(单位: any, 阶段ID: number, 回调: 技能自我打断回调): void {
  const 单位ID = 取句柄ID(单位);
  if (单位ID === 0 || 阶段ID <= 0 || 回调 == null) return;

  阶段监听表[阶段ID] = { 单位, 阶段ID, 回调 };

  const 列表 = 单位监听表[单位ID] ?? [];
  if (列表.indexOf(阶段ID) < 0) {
    列表.push(阶段ID);
  }
  单位监听表[单位ID] = 列表;
}

export function 取消技能自我打断监听(阶段ID: number): void {
  const 监听 = 阶段监听表[阶段ID];
  if (监听 == null) return;

  delete 阶段监听表[阶段ID];

  const 单位ID = 取句柄ID(监听.单位);
  const 列表 = 单位监听表[单位ID];
  if (列表 == null) return;

  const 索引 = 列表.indexOf(阶段ID);
  if (索引 >= 0) {
    列表.splice(索引, 1);
  }
  if (列表.length === 0) {
    delete 单位监听表[单位ID];
  }
}

export function 单位是否存在可自我打断技能阶段(单位: any): boolean {
  const 单位ID = 取句柄ID(单位);
  if (单位ID === 0) return false;
  const 列表 = 单位监听表[单位ID];
  return 列表 != null && 列表.length > 0;
}

export function 报告单位自我打断(单位: any, 方式: 技能自我打断方式 = "未知"): void {
  const 单位ID = 取句柄ID(单位);
  if (单位ID === 0) return;

  const 列表 = 单位监听表[单位ID];
  if (列表 == null || 列表.length === 0) return;

  const 阶段ID列表 = 列表.slice();
  for (const 阶段ID of 阶段ID列表) {
    const 监听 = 阶段监听表[阶段ID];
    if (监听 != null) {
      监听.回调(单位, 阶段ID, 方式);
    }
  }
}

function 获取玩家当前可打断单位(玩家: any): any {
  if (玩家 == null || 玩家 === 0) return null;

  const 玩家ID = GetPlayerId(玩家);
  const getSoleSelectedUnitForPlayer = 选中单位事件中心.getSoleSelectedUnitForPlayer;
  if (typeof getSoleSelectedUnitForPlayer === "function") {
    const 选中单位 = getSoleSelectedUnitForPlayer(玩家ID);
    if (选中单位 != null && 单位是否存在可自我打断技能阶段(选中单位)) {
      return 选中单位;
    }
  }

  const 英雄 = YDUserDataGet("player", 玩家, "英雄", "unit");
  if (英雄 != null && 英雄 !== 0 && 单位是否存在可自我打断技能阶段(英雄)) {
    return 英雄;
  }

  return null;
}

function on技能自我打断_S键按下(): void {
  if (japi == null || typeof japi.DzGetTriggerKeyPlayer !== "function") return;

  const 按键玩家 = japi.DzGetTriggerKeyPlayer();
  const 单位 = 获取玩家当前可打断单位(按键玩家);
  if (单位 == null || 单位 === 0) return;

  报告单位自我打断(单位, "按下S");
}

export function 初始化技能自我打断_S键监听(): void {
  if (自我打断S键已初始化) return;
  自我打断S键已初始化 = true;

  自我打断S键触发器 = CreateTrigger();
  if (自我打断S键触发器 == null || 自我打断S键触发器 === 0) return;

  DzTriggerRegisterKeyEventTrg(自我打断S键触发器, KEY_STATE.DOWN, KEY.S);
  TriggerAddAction(自我打断S键触发器, on技能自我打断_S键按下);
}

初始化技能自我打断_S键监听();

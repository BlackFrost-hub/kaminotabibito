/** @noSelfInFile */
/**
 * 杀敌金币平分系统 - 金币获取回调
 *
 * 功能：
 * 1. 处理金币获取率加成
 * 2. 触发STES数值显示事件
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const {
  GOLD_RATE_THRESHOLD,
  EVENT_VALUE_DISPLAY,
  YDLOCAL_VAR_UNIT,
  YDLOCAL_VAR_REAL,
  YDLOCAL_VAR_BLUE,
  YDLOCAL_VAR_SIZE,
  YDLOCAL_VAR_STRING,
  DEFAULT_BLUE,
  DEFAULT_TEXT_SIZE,
  GOLD_STRING_INDEX,
} = require("系统.06．经济系统.01．杀敌金币平分.00．常量定义") as typeof import("./00．常量定义");

const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
};

const {
  YDLocalExecuteTrigger,
  saveParentIndex,
  YDTriggerExecuteTrigger,
} = require("lib.扩展函数.YDWE函数.04．YDWE_trigger") as {
  YDLocalExecuteTrigger: (trg: any) => void;
  saveParentIndex: (trg: any) => void;
  YDTriggerExecuteTrigger: (trg: any, flag: boolean) => void;
};

const { YDLocal5Set } = require("lib.扩展函数.YDWE函数.02．YDLocal兼容") as {
  YDLocal5Set: (type: string, name: string, value: any) => void;
};

const { STES_GetTable } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
  STES_GetTable: (self: any) => any;
};

const { AdjustPlayerStateBJ } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  AdjustPlayerStateBJ: (delta: number, whichPlayer: any, whichPlayerState: any) => void;
};

const { registerGoldGainCallback } = require("系统.06．经济系统.01．杀敌金币平分.01．核心功能") as {
  registerGoldGainCallback: (cb: (params: { unit: any; player: any; baseGold: number; isShared: boolean }) => number) => void;
};

// ==========================================================================================
// 工具函数
// ==========================================================================================

/** 获取玩家金币获取率 */
function getPlayerGoldRate(this: void, player: any): number {
  const rate = YDUserDataGet("player", player, "金币获取率", "real");
  return typeof rate === "number" ? rate : 0;
}

// ==========================================================================================
// STES事件触发
// ==========================================================================================

function fireStesEvent(this: void, unit: any, gold: number): void {
  const ht = STES_GetTable(undefined);
  if (!ht) return;

  const hash = jass.StringHash(EVENT_VALUE_DISPLAY);
  const skeyIndex = jass.StringHash("index");
  const count = jass.LoadInteger(ht, hash, skeyIndex);

  for (let i = 0; i < count; i++) {
    const trg = jass.LoadTriggerHandle(ht, hash, i);
    if (trg) {
      YDLocalExecuteTrigger(trg);
      saveParentIndex(trg);

      YDLocal5Set("unit", YDLOCAL_VAR_UNIT, unit);
      YDLocal5Set("real", YDLOCAL_VAR_REAL, gold);
      YDLocal5Set("real", YDLOCAL_VAR_BLUE, DEFAULT_BLUE);
      YDLocal5Set("real", YDLOCAL_VAR_SIZE, DEFAULT_TEXT_SIZE);

      const string48 = jglobals?.udg_String?.[GOLD_STRING_INDEX];
      if (string48 != null) {
        YDLocal5Set("string", YDLOCAL_VAR_STRING, string48);
      }

      YDTriggerExecuteTrigger(trg, false);
    }
  }
}

// ==========================================================================================
// 金币获取回调
// ==========================================================================================

/**
 * 处理金币获取率加成并给予金币
 */
function goldGainCallback(params: { unit: any; player: any; baseGold: number; isShared: boolean }): number {
  const { unit, player, baseGold } = params;

  // 计算金币获取率加成
  const goldRate = getPlayerGoldRate(player);
  let finalGold = baseGold;

  if (goldRate >= GOLD_RATE_THRESHOLD) {
    finalGold = jass.R2I(baseGold * (1 + goldRate));
  }

  // 给予金币
  AdjustPlayerStateBJ(finalGold, player, jass.PLAYER_STATE_RESOURCE_GOLD);

  // 触发STES事件（数值显示）
  fireStesEvent(unit, finalGold);

  return finalGold;
}

// ==========================================================================================
// 自动注册
// ==========================================================================================

registerGoldGainCallback(goldGainCallback);

export {
  EVENT_VALUE_DISPLAY,
  YDLOCAL_VAR_UNIT,
  YDLOCAL_VAR_REAL,
  YDLOCAL_VAR_BLUE,
  YDLOCAL_VAR_SIZE,
  YDLOCAL_VAR_STRING,
};

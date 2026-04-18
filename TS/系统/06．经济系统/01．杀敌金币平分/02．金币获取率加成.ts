/** @noSelfInFile */
/**
 * 杀敌金币平分系统 - 金币获取率加成
 *
 * 功能：处理金币获取率加成
 */

const { GOLD_RATE_THRESHOLD } = require("系统.06．经济系统.01．杀敌金币平分.00．常量定义") as typeof import("./00．常量定义");

const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
};

const { registerGoldGainCallback } = require("系统.06．经济系统.01．杀敌金币平分.01．核心功能") as {
  registerGoldGainCallback: (cb: (params: any) => any) => void;
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
// 金币获取率回调
// ==========================================================================================

/**
 * 处理金币获取率加成
 */
function goldRateCallback(params: any): any {
  const { player, baseGold } = params;

  // 计算金币获取率加成
  const goldRate = getPlayerGoldRate(player);
  let finalGold = baseGold;

  if (goldRate >= GOLD_RATE_THRESHOLD) {
    finalGold = Math.floor(baseGold * (1 + goldRate));
  }

  return { ...params, finalGold };
}

registerGoldGainCallback(goldRateCallback);

export {};

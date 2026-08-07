/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { registerUnitInRangeTrigger } = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
  registerUnitInRangeTrigger: (this: void, trigger: any, unit: any, range: number, filter?: any, once?: boolean) => () => void;
};
const { safeTriggerAddAction, safeDestroyTrigger } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTriggerAddAction: (this: void, trigger: any, callback: (this: void) => void) => { readonly id: number } | null;
  safeDestroyTrigger: (this: void, trigger: any) => void;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 发送剧情任务消息 } from "../../00．剧情系统核心工具/02．剧情动作桥接";
import { 注册剧情运行时单位, 读取剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";
export { 克林姆德国王委托剧情片段 } from "../02．第二章/24．克林姆德王接见";

const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const RemoveDestructable = jass.RemoveDestructable as (this: void, whichDestructable: any) => void;
const PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;
const PauseUnit = jass.PauseUnit as (this: void, whichUnit: any, flag: boolean) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;

const bj_QUESTMESSAGE_ITEMACQUIRED = jglobals.bj_QUESTMESSAGE_ITEMACQUIRED as number;

interface 巨魔猎头者入口状态 {
  触发器: any;
  取消监听: () => void;
  已触发: boolean;
}

let 巨魔猎头者入口: 巨魔猎头者入口状态 | undefined;

function 清理巨魔猎头者范围监听(this: void): void {
  const 状态 = 巨魔猎头者入口;
  if (状态 == null) return;
  状态.取消监听();
  safeDestroyTrigger(状态.触发器);
  巨魔猎头者入口 = undefined;
}

function 执行移除巨魔路线阻挡(this: void): void {
  const 阻挡 = jglobals.gg_dest_Dofw_5490;
  if (阻挡 == null || 阻挡 === 0) {
    const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
      debugLogForce: (this: void, module: string, ...args: any[]) => void;
    };
    debugLogForce("剧情24-25", "路线阻挡句柄缺失", "gg_dest_Dofw_5490");
    return;
  }
  RemoveDestructable(阻挡);
}

function on巨魔猎头者范围触发(this: void): void {
  const 状态 = 巨魔猎头者入口;
  if (状态 == null || 状态.已触发 || 读取剧情进度() !== 25) return;
  const 触发单位 = GetTriggerUnit();
  if (触发单位 == null || 触发单位 === 0 || !是玩家英雄组单位(触发单位)) return;
  const { 播放主线剧情片段 } = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器") as {
    播放主线剧情片段: (this: void, 片段ID: string, 上下文?: any) => boolean;
  };
  状态.已触发 = true;
  const 已播放 = 播放主线剧情片段("elven_city_troll_guard_start", {
    片段ID: "elven_city_troll_guard_start",
    触发配置名: "巨魔猎头者400范围入口",
    触发单位,
  });
  if (已播放) 清理巨魔猎头者范围监听();
  else 状态.已触发 = false;
}

function 执行创建巨魔猎头者入口(this: void): void {
  const 已有单位 = 读取剧情运行时单位("剧情运行时.巨魔猎头者守卫");
  if (已有单位 != null && 已有单位 !== 0) return;
  const 猎头者类型ID = stringToFourCCSafe("ohun");
  if (!(猎头者类型ID > 0)) return;
  const 猎头者 = 创建单位并登记排泄安全(
    Player(PLAYER_NEUTRAL_AGGRESSIVE),
    猎头者类型ID,
    -2910.1,
    -14065.8,
    180,
  );
  if (猎头者 == null || 猎头者 === 0) return;
  PauseUnit(猎头者, true);
  SetUnitInvulnerable(猎头者, true);
  注册剧情运行时单位("剧情运行时.巨魔猎头者守卫", 猎头者);

  清理巨魔猎头者范围监听();
  const trigger = CreateTrigger();
  if (safeTriggerAddAction(trigger, on巨魔猎头者范围触发) == null) {
    safeDestroyTrigger(trigger);
    return;
  }
  const 取消监听 = registerUnitInRangeTrigger(trigger, 猎头者, 400, null, false);
  巨魔猎头者入口 = { 触发器: trigger, 取消监听, 已触发: false };
}

export function 执行接见金币提示(this: void, 参数: 剧情动作参数表): void {
  发送剧情任务消息({
    消息类型: bj_QUESTMESSAGE_ITEMACQUIRED,
    文本: String(参数.提示文本 ?? "|cffffff00『系统提示』：|r所有英雄收到了|cffffff0015000金币！|r"),
  });
}

export const 克林姆德王接见剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵城_接见金币提示": 执行接见金币提示,
  "JLC精灵城_创建巨魔猎头者入口": 执行创建巨魔猎头者入口,
  "JLC精灵城_移除巨魔路线阻挡": 执行移除巨魔路线阻挡,
};

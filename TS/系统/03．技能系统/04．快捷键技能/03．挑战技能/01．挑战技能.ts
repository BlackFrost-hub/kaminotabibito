/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

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
const { 广播单位提示, 播放广播对白序列 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
  播放广播对白序列: (this: void, 配置: any) => void;
};
const { 记录Boss自动技能启动, 是否已登记Boss自动技能 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表") as {
  记录Boss自动技能启动: (this: void, 单位: any, 来源: "STES.Boss" | "Boss战.单位" | "Boss战.绑定单位" | "Boss测试") => any;
  是否已登记Boss自动技能: (this: void, 单位: any) => boolean;
};
const { 应用Boss战启动属性配置 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用") as {
  应用Boss战启动属性配置: (this: void, 单位: any) => void;
};
const { 启动Boss战运行 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.03．Boss战运行驱动") as {
  启动Boss战运行: (this: void, Boss单位: any) => void;
};
const { 读取卡瑟拉单位, 是否卡瑟拉入口对白已完成 } = require("系统.11．剧情系统.02．支线任务.01．被驱逐的水怪.00．入口配置") as {
  读取卡瑟拉单位: (this: void) => any;
  是否卡瑟拉入口对白已完成: (this: void) => boolean;
};
const { YDUserDataGetSafe, YDUserDataSetSafe, YDUserDataClearSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  YDUserDataClearSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
};
const { YDWEAngleBetweenUnitsSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWEAngleBetweenUnitsSafe: (this: void, 起点单位: any, 终点单位: any) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, 回调: (this: void, 死亡单位: any, 击杀单位: any) => void) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const 挑战技能模块名 = "挑战技能";
import { 挑战技能配置表, type 挑战技能配置 } from "./00．挑战技能配置";

const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, 单位: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, 单位: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, 单位: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, 单位: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, 玩家: any) => number;
const Player = jass.Player as (this: void, 玩家ID: number) => any;
const RemoveUnit = jass.RemoveUnit as (this: void, 单位: any) => void;
const TriggerRegisterUnitEvent = jass.TriggerRegisterUnitEvent as (
  this: void,
  触发器: any,
  单位: any,
  事件: any,
) => void;

let 已初始化挑战技能 = false;
let 卡瑟拉Boss战已启动 = false;
let 嗜血兽人挑战已完成 = false;
let 当前嗜血兽人Boss: any = null;
let 当前嗜血兽人挑战英雄: any = null;

// 支线任务10019：嗜血兽人伪装成兽人探险家，挑战成功后原地现身并交由旧触发器接管战斗。
const 嗜血兽人任务ID = 10019;
const 嗜血兽人Boss单位类型ID = stringToFourCCSafe("O008");
const 兽人探险家单位类型ID = stringToFourCCSafe("ogru");
const 中立被动玩家ID = 15;
const Boss002触发名 = "gg_trg_______Boss002";
const BossTS触发名 = "gg_trg_______Boss____________TS";

function 读取挑战技能配置列表(this: void, 技能ID: number): 挑战技能配置[] {
  const 结果: 挑战技能配置[] = [];
  for (const 配置 of 挑战技能配置表) {
    if (stringToFourCCSafe(配置.技能ID) === 技能ID) 结果.push(配置);
  }
  return 结果;
}

function 读取嗜血兽人伪装单位(this: void): any {
  return YDUserDataGetSafe("string", "支线敌人", "嗜血兽人", "unit");
}

function 注册嗜血兽人旧触发器单位事件(this: void, boss: any): void {
  const 旧触发Boss002 = (jglobals as Record<string, any>)[Boss002触发名];
  const 旧触发BossTS = (jglobals as Record<string, any>)[BossTS触发名];
  if (旧触发Boss002 != null && 旧触发Boss002 !== 0) {
    TriggerRegisterUnitEvent(旧触发Boss002, boss, jass.EVENT_UNIT_SPELL_EFFECT as any);
  }
  if (旧触发BossTS != null && 旧触发BossTS !== 0) {
    TriggerRegisterUnitEvent(旧触发BossTS, boss, jass.EVENT_UNIT_SPELL_CAST as any);
  }
}

function 读取嗜血兽人发现对白单位(this: void, 说话者键: string): any {
  return 说话者键 === "Boss" ? 当前嗜血兽人Boss : 当前嗜血兽人挑战英雄;
}

function 开始嗜血兽人战斗(this: void): void {
  const Boss单位 = 当前嗜血兽人Boss;
  if (Boss单位 == null || Boss单位 === 0) return;
  if (!是否已登记Boss自动技能(Boss单位)) {
    记录Boss自动技能启动(Boss单位, "Boss战.绑定单位");
  }
  应用Boss战启动属性配置(Boss单位);
  启动Boss战运行(Boss单位);
}

function on嗜血兽人Boss死亡(this: void, 死亡单位: any, _击杀者: any): void {
  if (当前嗜血兽人Boss == null || 死亡单位 !== 当前嗜血兽人Boss) return;
  当前嗜血兽人Boss = null;
  YDUserDataClearSafe("string", "支线敌人", "嗜血兽人", "unit");
}

function 播放嗜血兽人发现对白(this: void, 英雄: any, boss: any): void {
  当前嗜血兽人挑战英雄 = 英雄;
  当前嗜血兽人Boss = boss;
  播放广播对白序列({
    对白列表: [
      { 说话者键: "玩家", 文本: "原来如此，看来造成这一切的生灵，就是你这家伙。", 停留毫秒: 2000 },
      { 说话者键: "Boss", 文本: "哦？被发现了吗，那又怎么样，成为我的鲜血吧！", 停留毫秒: 2000 },
    ],
    读取说话单位: 读取嗜血兽人发现对白单位,
    播放单句: 广播单位提示,
    播放完成: 开始嗜血兽人战斗,
  });
}

function 执行嗜血兽人挑战变形(this: void, 施法单位: any, 目标单位: any): boolean {
  if (嗜血兽人挑战已完成) return false;
  if (GetUnitTypeId(目标单位) !== 兽人探险家单位类型ID) {
    debugLogForce(挑战技能模块名, "嗜血兽人挑战被拒", "目标类型不匹配", GetUnitTypeId(目标单位), "需要=", 兽人探险家单位类型ID);
    return false;
  }
  const 伪装单位 = 读取嗜血兽人伪装单位();
  if (伪装单位 !== 目标单位) {
    debugLogForce(挑战技能模块名, "嗜血兽人挑战被拒", "目标非YD伪装单位", "YD=", 伪装单位, "目标=", 目标单位);
    return false;
  }
  const 玩家ID = GetPlayerId(GetOwningPlayer(施法单位));
  const 已接取标记 = YDUserDataGetSafe("string", "失踪的精灵村民", "任务状态", "boolean");
  if (已接取标记 !== true) {
    debugLogForce(挑战技能模块名, "嗜血兽人挑战被拒", "任务状态标记未激活", 玩家ID);
    return false;
  }

  const X = GetUnitX(目标单位);
  const Y = GetUnitY(目标单位);
  const 朝向玩家 = YDWEAngleBetweenUnitsSafe(目标单位, 施法单位);
  const Boss单位 = 创建单位并登记排泄安全(Player(中立被动玩家ID), 嗜血兽人Boss单位类型ID, X, Y, 朝向玩家);
  if (Boss单位 == null || Boss单位 === 0) {
    debugLogForce(挑战技能模块名, "嗜血兽人Boss创建失败");
    return false;
  }

  嗜血兽人挑战已完成 = true;
  RemoveUnit(目标单位);
  注册嗜血兽人旧触发器单位事件(Boss单位);
  debugLogForce(挑战技能模块名, "嗜血兽人挑战变形完成", "BossHid=", jass.GetHandleId(Boss单位));
  播放嗜血兽人发现对白(施法单位, Boss单位);
  return true;
}

function on挑战技能生效(this: void, 施法单位: any, 技能ID: number): void {
  if (施法单位 == null || 施法单位 === 0 || !是玩家英雄组单位(施法单位)) return;

  const 配置列表 = 读取挑战技能配置列表(技能ID);
  if (配置列表.length === 0) return;
  const 目标单位 = GetSpellTargetUnit();
  if (目标单位 == null || 目标单位 === 0) return;

  for (let i = 0; i < 配置列表.length; i++) {
    const 配置 = 配置列表[i];
    if (配置.任务ID === 嗜血兽人任务ID) {
      执行嗜血兽人挑战变形(施法单位, 目标单位);
      continue;
    }

    if (卡瑟拉Boss战已启动) continue;
    const 卡瑟拉 = 读取卡瑟拉单位();
    // 卡瑟拉只会在任务接取后的动作中创建；存在即代表该全局入口已解锁。
    if (卡瑟拉 == null || 卡瑟拉 === 0) continue;
    if (!是否卡瑟拉入口对白已完成()) continue;
    if (目标单位 !== 卡瑟拉) continue;
    if (GetUnitTypeId(目标单位) !== stringToFourCCSafe(配置.目标单位ID)) continue;

    if (启动剧情Boss战(卡瑟拉, { 触发单位: 施法单位 })) {
      卡瑟拉Boss战已启动 = true;
    }
  }
}

export function init挑战技能(this: void): void {
  if (已初始化挑战技能) return;
  已初始化挑战技能 = true;
  registerSpellEffectListener(on挑战技能生效);
  registerDeathListener(on嗜血兽人Boss死亡);
}

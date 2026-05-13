/** @noSelfInFile */
/**
 * 英雄技能记录测试
 *
 * 输入 "1024"：
 * 1. 打印当前测试英雄的 Q/W/E/R/D 记录
 * 2. 给测试英雄挂一个 SPELL_EFFECT 监听
 * 3. 之后每次施法，打印本次技能与当前整套记录
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { [key: string]: any };

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const fourCCTools = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  fourCCToString: (self: any, four: number) => string;
};
const fourCCToStringRaw: any = fourCCTools.fourCCToString;
const heroSkillRecord = require("系统.03．技能系统.05．动态技能说明.05．英雄技能记录") as {
  registerHeroSkillRecordHero: (this: void, whichHero: any) => void;
  getHeroRecordedSkill: (this: void, whichHero: any, hotkey: "Q" | "W" | "E" | "R" | "D") => number;
};
const commandBarAbility = require("系统.03．技能系统.05．动态技能说明.07．命令卡技能槽位") as {
  读取命令卡按钮能力Id: (this: void, x: number, y: number) => number;
};
const ydweAbility = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  ABILITY_DATA_HOTKEY: number;
  YDWEGetUnitAbilityDataString: (u: any, abilcode: number, level: number, dataType: number) => string;
};
const { YDWEGetUnitAbilityDataString } = ydweAbility;
const unitSpecificEventCenter = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
  registerUnitEventTrigger: (this: void, trigger: any, unit: any, eventId: any, once?: boolean) => () => void;
};

const CreateTrigger = jass.CreateTrigger as () => any;
const TriggerRegisterPlayerChatEvent = jass.TriggerRegisterPlayerChatEvent as (trig: any, whichPlayer: any, chatMessageToDetect: string, exactMatchOnly: boolean) => void;
const TriggerAddAction = jass.TriggerAddAction as (trig: any, action: () => void) => void;
const Player = jass.Player as (playerId: number) => any;

const 模块名 = "英雄技能记录测试";
const 测试命令 = "1024";
let 已注册聊天 = false;
let 技能监听触发器: any = null;
let 已挂监听英雄id = 0;

function 取技能rawcode文本(this: void, abilityId: number): string {
  if (abilityId === 0) return "0";
  return fourCCToStringRaw(fourCCTools, abilityId);
}

function 取技能热键文本(this: void, whichHero: any, abilityId: number): string {
  if (whichHero == null || whichHero === 0 || abilityId === 0) return "-";
  return YDWEGetUnitAbilityDataString(whichHero, abilityId, 1, ydweAbility.ABILITY_DATA_HOTKEY) || "-";
}

function 取命令卡槽位技能(this: void, x: number, y: number): number {
  return commandBarAbility.读取命令卡按钮能力Id(x, y);
}

function 打印命令卡槽位(this: void): void {
  debugLogForce(
    模块名,
    "命令卡槽位：",
    "Q=", 取技能rawcode文本(取命令卡槽位技能(0, 2)),
    "W=", 取技能rawcode文本(取命令卡槽位技能(1, 2)),
    "E=", 取技能rawcode文本(取命令卡槽位技能(2, 2)),
    "R=", 取技能rawcode文本(取命令卡槽位技能(3, 2)),
    "D=", 取技能rawcode文本(取命令卡槽位技能(0, 1)),
  );
}

function 打印当前记录(this: void, whichHero: any): void {
  const q = heroSkillRecord.getHeroRecordedSkill(whichHero, "Q");
  const w = heroSkillRecord.getHeroRecordedSkill(whichHero, "W");
  const e = heroSkillRecord.getHeroRecordedSkill(whichHero, "E");
  const r = heroSkillRecord.getHeroRecordedSkill(whichHero, "R");
  const d = heroSkillRecord.getHeroRecordedSkill(whichHero, "D");

  debugLogForce(
    模块名,
    "当前记录：",
    "Q=", 取技能rawcode文本(q),
    "W=", 取技能rawcode文本(w),
    "E=", 取技能rawcode文本(e),
    "R=", 取技能rawcode文本(r),
    "D=", 取技能rawcode文本(d),
  );
}

function 打印冷却显示快照(this: void): void {
  debugLogForce(模块名, "冷却显示快照：", require("系统.03．技能系统.01．技能冷却.03．QWERD冷却显示").获取QWERD冷却调试快照());
}

function on测试英雄施法(this: void): void {
  const whichHero = jass.GetTriggerUnit();
  if (whichHero == null || whichHero === 0) return;

  const abilityId = (jass.GetSpellAbilityId() as number) || 0;
  if (abilityId === 0) return;
  debugLogForce(
    模块名,
    "本次施法：ability=",
    取技能rawcode文本(abilityId),
    "hotkey=",
    取技能热键文本(whichHero, abilityId),
  );
  打印命令卡槽位();
  打印当前记录(whichHero);
  打印冷却显示快照();
}

function 挂接测试英雄监听(this: void, whichHero: any): void {
  if (whichHero == null || whichHero === 0) return;

  const heroId = (jass.GetHandleId(whichHero) as number) || 0;
  if (heroId === 0) return;
  if (已挂监听英雄id === heroId) return;

  if (技能监听触发器 == null) {
    技能监听触发器 = CreateTrigger();
    TriggerAddAction(技能监听触发器, on测试英雄施法);
  }

  unitSpecificEventCenter.registerUnitEventTrigger(技能监听触发器, whichHero, jass.EVENT_UNIT_SPELL_EFFECT);
  已挂监听英雄id = heroId;
}

function on聊天测试(): void {
  const 英雄 = g.gg_unit_Hamg_0002;
  if (英雄 == null || 英雄 === 0) {
    debugLogForce(模块名, "错误：未找到 gg_unit_Hamg_0002");
    return;
  }

  heroSkillRecord.registerHeroSkillRecordHero(英雄);
  挂接测试英雄监听(英雄);

  debugLogForce(模块名, "===== 英雄技能记录测试 =====");
  debugLogForce(模块名, "测试英雄handle：", 英雄);
  debugLogForce(模块名, "提示：现在施放任意技能，会打印本次技能与当前Q/W/E/R/D记录");
  打印命令卡槽位();
  打印当前记录(英雄);
  打印冷却显示快照();
}

function 注册聊天测试(): void {
  if (已注册聊天) return;
  已注册聊天 = true;

  const trig = CreateTrigger();
  TriggerRegisterPlayerChatEvent(trig, Player(0), 测试命令, true);
  TriggerAddAction(trig, on聊天测试);
  debugLogForce(模块名, "已注册测试：输入", 测试命令);
}

注册聊天测试();

export {};

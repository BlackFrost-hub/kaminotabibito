/**
 * 控制抗性系统初始化
 *
 * 注册技能施放事件，监听控制技能
 */

const jass = require("jass.common") as any;
const { TriggerRegisterPlayerUnitEventSimple } = require("lib.扩展函数.BJ函数.index") as {
  TriggerRegisterPlayerUnitEventSimple: (trig: any, player: any, event: number) => any;
};
const { GetSpellAbilityId } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetSpellAbilityId: () => number;
};
const { isExcludedFromControlResist, isControlAbility, isUnitControlled } = require("系统.05．Buff系统.01．控制抗性.01．控制检测") as {
  isExcludedFromControlResist: (unit: any) => boolean;
  isControlAbility: (abilityId: number) => boolean;
  isUnitControlled: (unit: any) => boolean;
};
const { calcReducedControlTime } = require("系统.05．Buff系统.04．控制抗性.02．控制时间计算") as {
  calcReducedControlTime: (target: any, abilityId: number) => number;
};
const { recastControlAbility } = require("系统.05．Buff系统.04．控制抗性.03．控制重施放") as {
  recastControlAbility: (caster: any, target: any, abilityId: number, duration: number) => void;
};

/** 触发器 */
let controlTrigger: any = null;

/**
 * 控制抗性事件处理函数
 */
function onSpellChannel(): void {
  const caster = jass.GetTriggerUnit();
  const target = jass.GetSpellTargetUnit();
  const abilityId = GetSpellAbilityId();

  // 检查排除单位
  if (isExcludedFromControlResist(caster)) return;

  // 检查是否有目标
  if (target == null) return;

  // 检查是否为控制技能
  if (!isControlAbility(abilityId)) return;

  // 检查目标是否被控制
  if (!isUnitControlled(target)) return;

  // 计算削减后的控制时间
  const duration = calcReducedControlTime(target, abilityId);

  // 创建0秒计时器延迟处理（等待控制技能生效）
  const timer = jass.CreateTimer();
  jass.TimerStart(timer, 0, false, () => {
    // 再次检查控制状态
    if (isUnitControlled(target)) {
      recastControlAbility(caster, target, abilityId, duration);
    }
    jass.DestroyTimer(timer);
  });
}

/**
 * 初始化控制抗性系统
 */
export function initControlResist(): void {
  if (controlTrigger != null) return;

  controlTrigger = jass.CreateTrigger();

  // 玩家1-4 (Player 0-3)
  for (let i = 0; i <= 3; i++) {
    TriggerRegisterPlayerUnitEventSimple(
      controlTrigger,
      jass.Player(i),
      jass.EVENT_PLAYER_UNIT_SPELL_CHANNEL
    );
  }
  // 玩家7 (Player 6)
  TriggerRegisterPlayerUnitEventSimple(
    controlTrigger,
    jass.Player(6),
    jass.EVENT_PLAYER_UNIT_SPELL_CHANNEL
  );
  // 玩家8 (Player 7)
  TriggerRegisterPlayerUnitEventSimple(
    controlTrigger,
    jass.Player(7),
    jass.EVENT_PLAYER_UNIT_SPELL_CHANNEL
  );
  // 中立敌对
  TriggerRegisterPlayerUnitEventSimple(
    controlTrigger,
    jass.Player(jass.PLAYER_NEUTRAL_AGGRESSIVE),
    jass.EVENT_PLAYER_UNIT_SPELL_CHANNEL
  );

  // 注册动作
  jass.TriggerAddAction(controlTrigger, onSpellChannel);
}

export {};

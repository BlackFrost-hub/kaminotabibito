/**
 * 任意测试文件
 */

const jass = require("jass.common") as any;

const { fourCCToString, printToPlayer } = require("系统.00．核心系统.01．封装函数") as {
  fourCCToString: (fourcc: number) => string;
  printToPlayer: (player: any, msg: string, duration?: number) => void;
};

const { TriggerRegisterAnyUnitEventBJ, OrderIdToString } = require("lib.扩展函数.03．BJ函数") as {
  TriggerRegisterAnyUnitEventBJ: (trig: any, whichEvent: number) => void;
  OrderIdToString: (orderId: number) => string;
};

/**
 * 测试技能命令ID捕获
 * 监听所有玩家使用技能事件，捕获命令ID
 */
function testSpellOrderCapture(): void {
  const trig = typeof jass.CreateTrigger === "function" ? jass.CreateTrigger() : null;
  if (!trig) return;

  const ev = jass.EVENT_PLAYER_UNIT_SPELL_EFFECT;
  if (!ev) return;

  TriggerRegisterAnyUnitEventBJ(trig, ev);

  jass.TriggerAddAction(trig, () => {
    const triggerUnit = typeof jass.GetTriggerUnit === "function" ? jass.GetTriggerUnit() : null;
    if (!triggerUnit) return;

    const orderId = typeof jass.GetUnitCurrentOrder === "function" ? jass.GetUnitCurrentOrder(triggerUnit) : 0;
    const orderIdStr = OrderIdToString(orderId);

    const abilityId = typeof jass.GetSpellAbilityId === "function" ? jass.GetSpellAbilityId() : 0;
    const abilityIdStr = fourCCToString(abilityId);

    const unitName = typeof jass.GetUnitName === "function" ? jass.GetUnitName(triggerUnit) : "未知单位";

    const ITEM_USE_MIN = 852008;
    const ITEM_USE_MAX = 852013;
    const isUsingItem = orderId >= ITEM_USE_MIN && orderId <= ITEM_USE_MAX;

    const msg = `使用技能! 单位: ${unitName} 命令ID: ${orderId} (${orderIdStr}) 技能ID: ${abilityId} (${abilityIdStr}) ${isUsingItem ? "【使用物品】" : ""}`;

    printToPlayer(jass.Player(0), msg, 5);
  });
}

// ---------- 启动技能命令ID捕获测试 ----------
testSpellOrderCapture();

// ---------- 验证单位存在 ----------
const t = jass.CreateTimer();
jass.TimerStart(t, 1.0, false, () => {
  const u = (jass as any).gg_unit_Hamg_0002;
  if (u) {
    jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 10, "单位存在! Hamg Primary: " + (jass as any).GetUnitName(u));
  } else {
    jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 10, "gg_unit_Hamg_0002 不存在!");
  }
  (jass as any).DestroyTimer(t);
});

const t2 = jass.CreateTimer();
jass.TimerStart(t2, 1.0, false, () => {
  const u = (jass as any).gg_unit_htow_0030;
  if (u) {
    jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 10, "gg_unit_htow_0030 存在!");
  } else {
    jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 10, "gg_unit_htow_0030 不存在!");
  }
  (jass as any).DestroyTimer(t2);
});

export {};

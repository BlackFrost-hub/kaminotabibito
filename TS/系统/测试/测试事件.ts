// 测试事件 - 注册自定义事件「测试事件」，被触发时发送文本 2222
const jass = require("jass.common") as JassCommon;
const g = require("jass.globals") as { udg_RegTrigger?: any; udg_RegEventStr?: string; gg_unit_Hamg_0002?: any; [key: string]: any };

function onTestEvent(): void {
  (globalThis as any).print?.("2222 [TestEvent] step2");
  jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 8, "2222");
  jass.QuestMessageBJ(jass.GetPlayersAll(), jass.bj_QUESTMESSAGE_UPDATED, "2222");
  // 在 trigger 回调里访问 g/jass 可能不返回，用 Timer 延后到下一帧执行
  const t = (jass as any).CreateTimer();
  (jass as any).TimerStart(t, 0, false, () => {
    let out = "";
    const [ok, err] = pcall(() => {
      const u = g.gg_unit_Hamg_0002;
      const hasSet = !!(jass as any).Ir_SetUnitAttackType;
      out = "u=" + tostring(!!u) + " hasSet=" + tostring(hasSet);
      if (u && hasSet) {
        const hasGet = !!(jass as any).Ir_GetUnitAttackType;
        const before = hasGet ? (jass as any).Ir_GetUnitAttackType(u) : -1;
        (jass as any).Ir_SetUnitAttackType(u, 5);
        const after = hasGet ? (jass as any).Ir_GetUnitAttackType(u) : -1;
        out = "before=" + tostring(before) + " after=" + tostring(after);
      }
    });
    if (!ok) out = "pcall err: " + tostring(err);
    const line = "[TestEvent] " + out;
    (globalThis as any).print?.(line);
    jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 15, line);
  });
}

function init(): void {
  const evtTrig = jass.CreateTrigger();
  jass.TriggerAddAction(evtTrig, onTestEvent);
  const STES_Reg = (jass as any).STES_Register ?? (g as any).STES_Register ?? (globalThis as any).STES_Register;
  if (typeof STES_Reg === "function") {
    STES_Reg(evtTrig, "测试事件");
  } else {
    (g as any).udg_RegTrigger = evtTrig;
    (g as any).udg_RegEventStr = "测试事件";
    jass.ExecuteFunc("Bridge_STES_Register");
  }
}
init();
export {};

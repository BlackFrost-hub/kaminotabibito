const jass = require("jass.common") as JassCommon;
const { getObjectProperty, ObjectType } = require("系统.00．核心系统.12．YDWE函数") as {
  getObjectProperty: (objectType: number, objectId: string | number, property: string) => string;
  ObjectType: { UNIT: number };
};

const t = jass.CreateTimer();
jass.TimerStart(t, 1.0, false, () => {
  const u = (jass as any).gg_unit_Hamg_0002;
  if (u) {
    const primary = getObjectProperty(ObjectType.UNIT, "Hamg", "Primary");
    jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 10, "单位存在! Hamg Primary: " + primary);
  } else {
    jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 10, "gg_unit_Hamg_0002 不存在!");
  }
  (jass as any).DestroyTimer(t);
});
export {};

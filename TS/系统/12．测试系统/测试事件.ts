const jass = require("jass.common") as any;
// const { Ir_SetUnitAttackType, Ir_GetUnitAttackType } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
//   Ir_SetUnitAttackType: (u: any, atp: number) => void;
//   Ir_GetUnitAttackType: (u: any) => number;
// };
// const {
//   EXGetUnitAbilityByIndex,
//   EXGetAbilityId,
//   YDWESetUnitAbilityDataString,
//   YDWESetUnitAbilityDataReal,
//   ABILITY_DATA_NAME,
//   ABILITY_DATA_TIP,
//   ABILITY_DATA_DUR,
//   ABILITY_DATA_HERODUR
// } = require("系统.00．核心系统.07．技能函数") as any;

const trg = jass.CreateTrigger();
const redPlayer = jass.Player(0);
jass.TriggerRegisterPlayerUnitEvent(
  trg,
  redPlayer,
  jass.EVENT_PLAYER_UNIT_SELECTED,
  null
);
jass.TriggerAddAction(trg, () => {
  const u = jass.GetTriggerUnit();
  if (!u) return;

  // const beforeAtp = Ir_GetUnitAttackType(u);
  // Ir_SetUnitAttackType(u, 5);
  // const afterAtp = Ir_GetUnitAttackType(u);

  // const line = "[SelectEvent] 单位=" + jass.GetUnitName(u) + " 攻击类型: " + beforeAtp + " -> " + afterAtp;
  // jass.DisplayTimedTextToPlayer(redPlayer, 0, 0, 15, line);

  // let found = false;
  // let ok1 = false;
  // let ok2 = false;
  // let okDur1 = false;
  // let okDur2 = false;
  // let okDur3 = false;
  // let abilId = 0;

  // for (let i = 0; i <= 15; i++) {
  //   const a = EXGetUnitAbilityByIndex(u, i);
  //   if (a) {
  //     const id = EXGetAbilityId(a);
  //     if (id === 1095268197) {
  //       found = true;
  //       abilId = id;
  //       break;
  //     }
  //   }
  // }

  // if (found) {
  //   ok1 = YDWESetUnitAbilityDataString(u, abilId, 1, ABILITY_DATA_NAME, "测试");
  //   ok2 = YDWESetUnitAbilityDataString(u, abilId, 1, ABILITY_DATA_TIP, "测试");
  //   
  //   okDur1 = YDWESetUnitAbilityDataReal(u, abilId, 1, ABILITY_DATA_DUR, 3);
  //   okDur2 = YDWESetUnitAbilityDataReal(u, abilId, 2, ABILITY_DATA_DUR, 3);
  //   okDur3 = YDWESetUnitAbilityDataReal(u, abilId, 3, ABILITY_DATA_DUR, 3);
  //   
  //   YDWESetUnitAbilityDataReal(u, abilId, 1, ABILITY_DATA_HERODUR, 3);
  //   YDWESetUnitAbilityDataReal(u, abilId, 2, ABILITY_DATA_HERODUR, 3);
  //   YDWESetUnitAbilityDataReal(u, abilId, 3, ABILITY_DATA_HERODUR, 3);
  // }

  // const line = "[SelectEvent] 单位=" + jass.GetUnitName(u) + " 找到=" + found + " 文本=" + ok1 + "," + ok2 + " 持续时间=" + okDur1 + "," + okDur2 + "," + okDur3;
  // jass.DisplayTimedTextToPlayer(redPlayer, 0, 0, 15, line);
});

export {};

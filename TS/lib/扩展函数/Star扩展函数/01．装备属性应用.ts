/** @noSelfInFile */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { [k: string]: any };
const { YDUserDataGet2, YDUserDataSet2 } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet2: (tableTypeName: string, tableKey: any, attr: string, valueTypeName: any) => any;
  YDUserDataSet2: (tableTypeName: string, tableKey: any, attr: string, valueTypeName: any, value: any) => void;
};
const { SGSS_SetState, SGSS_SetStatePercentumEX2 } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, u: any, id: number, v: number) => void;
  SGSS_SetStatePercentumEX2: (this: void, u: any, id: number, v: number) => void;
};
const { applyDynamicPercentProperty } = require("lib.扩展函数.Star扩展函数.03．动态百分比属性") as {
  applyDynamicPercentProperty: (this: void, unit: any, statName: string, value: number) => boolean;
};

export interface EquipStatEntry {
  name: string;
  value: number;
}

function applyBaseState(unit: any, name: string, value: number): void {
  if (name === "攻击力") SGSS_SetState(unit, 1, value);
  else if (name === "护甲") SGSS_SetState(unit, 2, value);
  else if (name === "力量") SGSS_SetState(unit, 3, value);
  else if (name === "敏捷") SGSS_SetState(unit, 4, value);
  else if (name === "智力") SGSS_SetState(unit, 5, value);
  else if (name === "全属性") SGSS_SetState(unit, 6, value);
  else if (name === "生命值") SGSS_SetState(unit, 7, value);
  else if (name === "魔法值") SGSS_SetState(unit, 8, value);
  else if (name === "叠加移动速度") SGSS_SetState(unit, 9, value);
  else if (name === "攻速") SGSS_SetState(unit, 10, value);
  else if (name === "视野") SGSS_SetState(unit, 11, value);
}

function getHeroGroup(): any {
  try {
    return YDUserDataGet2("string", "玩家英雄", "单位组", "group");
  } catch (_e) {
    return null;
  }
}

export function applyEquipStatsTS(this: void, unit: any, stats: EquipStatEntry[]): Record<string, number> {
  const readBack: Record<string, number> = {};
  if (!unit || !stats || stats.length === 0) return readBack;

  const owner = jass.GetOwningPlayer(unit);
  const heroGroup = getHeroGroup();
  const isHeroByGroup = !!(heroGroup && jass.IsUnitInGroup(unit, heroGroup));
  const isHeroByType = !!(jass.IsUnitType(unit, jass.UNIT_TYPE_HERO));
  // 与 JASS 逻辑保持一致：优先用“玩家英雄”分组判断；分组缺失时回退到英雄类型判断。
  const isHero = isHeroByGroup || (!heroGroup && isHeroByType);

  for (const s of stats) {
    const name = s.name;
    const value = Number(s.value) || 0;
    if (value === 0) {
      readBack[name] = 0;
      continue;
    }

    // 基础绿字属性直接作用到单位
    applyBaseState(unit, name, value);

    if (!isHero) {
      const cur = Number(YDUserDataGet2("unit", unit, name, "real")) || 0;
      const next = cur + value;
      YDUserDataSet2("unit", unit, name, "real", next);
      readBack[name] = next;
      continue;
    }

    if (name !== "移动速度" && owner) {
      const cur = Number(YDUserDataGet2("player", owner, name, "real")) || 0;
      const next = cur + value;
      YDUserDataSet2("player", owner, name, "real", next);
      readBack[name] = next;
    }

    if (applyDynamicPercentProperty(unit, name, value)) {
      // 已由统一动态百分比处理器消费
    } else if (name === "经验获取率" && owner) {
      const t = Number(g.udg_T) || 1;
      const base = 0.35 + 0.65 * t;
      // 经验倍率 = base * (1 + 累计加成)。此处用覆盖式 SetPlayerHandicapXP，
      // 务必基于“写入后的累计值”计算：拾取 +0.2 → base*1.2；丢弃 → base*1.0 回到正常。
      const 累计加成 = Number(YDUserDataGet2("player", owner, name, "real")) || 0;
      jass.SetPlayerHandicapXP(owner, base * (1 + 累计加成));
    }
  }

  return readBack;
}

export {};

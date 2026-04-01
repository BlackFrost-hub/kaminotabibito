const jass = require("jass.common") as any;

export function getPlayerFirstHero(player: any): any {
  const g = jass.CreateGroup();
  jass.GroupEnumUnitsOfPlayer(g, player, null);
  let hero: any = null;
  let firstUnit: any = jass.FirstOfGroup(g);
  while (firstUnit) {
    if (jass.IsUnitType(firstUnit, jass.UNIT_TYPE_HERO)) {
      hero = firstUnit;
      break;
    }
    jass.GroupRemoveUnit(g, firstUnit);
    firstUnit = jass.FirstOfGroup(g);
  }
  jass.DestroyGroup(g);
  return hero;
}

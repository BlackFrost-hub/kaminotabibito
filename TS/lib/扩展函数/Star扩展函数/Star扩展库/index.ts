export * from "./00．镜头函数";
export * from "./01．SDR调试计时器";
export * from "./02．Star自定义事件";
export * from "./03．硬直暂停系统";
export * from "./04．快速Buff系统";
export * from "./05．移动速度突破系统";
export * from "./06．X库函数";
export * from "./07．特效组系统";
export * from "./08．单位判定与筛选函数";
export * from "./09．单位基础与生命周期函数";
export * from "./10．单位属性方位与攻击函数";
export * from "./11．物品技能事件";
export * from "./12．StarBase基础函数";

import * as cameraFunc from "./00．镜头函数";
import * as sdrDebug from "./01．SDR调试计时器";
import * as starEvent from "./02．Star自定义事件";
import * as suspend from "./03．硬直暂停系统";
import * as fastBuff from "./04．快速Buff系统";
import * as overSpeed from "./05．移动速度突破系统";
import * as xLib from "./06．X库函数";
import * as effectGroup from "./07．特效组系统";
import * as unitCondition from "./08．单位判定与筛选函数";
import * as unitBase from "./09．单位基础与生命周期函数";
import * as unitAttr from "./10．单位属性方位与攻击函数";
import * as itemAbility from "./11．物品技能事件";
import * as starBase from "./12．StarBase基础函数";

function expose(name: string, fn: any): void {
  if (typeof fn !== "function") return;
  const g = globalThis as any;
  if (typeof g[name] === "function") return;
  g[name] = fn;
}

export function registerBridge(): void {
  expose("StarOther_PanCameraToTimedUnitForPlayer", cameraFunc.StarOther_PanCameraToTimedUnitForPlayer);
  expose("StarOther_PanCameraToTimedForPlayer", cameraFunc.StarOther_PanCameraToTimedForPlayer);
  expose("SDR_DebugTimer", sdrDebug.SDR_DebugTimer);
  expose("STES_Register", starEvent.STES_Register);
  expose("STES_RegisterEx", starEvent.STES_RegisterEx);
  expose("STES_GetTable", starEvent.STES_GetTable);
  expose("STES_Fire", starEvent.STES_Fire);
  expose("STES_FireWithReal11Step", starEvent.STES_FireWithReal11Step);
  expose("STES_Execute", starEvent.STES_Execute);
  expose("STES_GetUnitEvent", starEvent.STES_GetUnitEvent);
  expose("STES_RemoveEvent", starEvent.STES_RemoveEvent);
  expose("STES_Remove", starEvent.STES_Remove);
  // 硬直暂停系统
  expose("GS_Suspend", suspend.GS_Suspend);
  expose("GS_IsUnitSuspending", suspend.GS_IsUnitSuspending);
  expose("GS_LoadSuspend", suspend.GS_LoadSuspend);
  expose("GS_UnitSuspend", suspend.GS_UnitSuspend);
  // 快速Buff系统
  expose("SFB_setBuff", fastBuff.SFB_setBuff);
  expose("SFB_setSlow", fastBuff.SFB_setSlow);
  expose("SFB_Init", fastBuff.SFB_Init);
  // 移动速度突破系统
  expose("SOS_SetUnitSpeed", overSpeed.SOS_SetUnitSpeed);
  expose("SOS_SetUnitSpeedTemp", overSpeed.SOS_SetUnitSpeedTemp);
  expose("SOS_GetUnitSpeed", overSpeed.SOS_GetUnitSpeed);
  expose("SOS_UnSetUnitSpeed", overSpeed.SOS_UnSetUnitSpeed);
  // X库函数
  expose("X_IsTerrainWalkable", xLib.X_IsTerrainWalkable);
  expose("X_IsUnitTerrainWalkable", xLib.X_IsUnitTerrainWalkable);
  expose("X_GetAbleX", xLib.X_GetAbleX);
  expose("X_GetAbleY", xLib.X_GetAbleY);
  expose("X_IsTerrainDeepWater", xLib.X_IsTerrainDeepWater);
  expose("X_IsTerrainShallowWater", xLib.X_IsTerrainShallowWater);
  expose("X_IsTerrainLand", xLib.X_IsTerrainLand);
  expose("X_IsTerrainPlatform", xLib.X_IsTerrainPlatform);
  expose("X_SetUnitMovable", xLib.X_SetUnitMovable);
  expose("X_GDBC", xLib.X_GDBC);
  expose("X_GAFC", xLib.X_GAFC);
  expose("X_R2I2", xLib.X_R2I2);
  // 特效组系统
  expose("EG_CreateEffectGroup", effectGroup.EG_CreateEffectGroup);
  expose("EG_RemoveGroup", effectGroup.EG_RemoveGroup);
  expose("EG_ClearGroup", effectGroup.EG_ClearGroup);
  expose("EG_GroupAddEffect", effectGroup.EG_GroupAddEffect);
  expose("EG_GroupAddEffectEx", effectGroup.EG_GroupAddEffectEx);
  expose("EG_RemoveEffectOfGroup", effectGroup.EG_RemoveEffectOfGroup);
  expose("EG_ForGroup", effectGroup.EG_ForGroup);
  expose("EG_GetFirstOfGroup", effectGroup.EG_GetFirstOfGroup);
  expose("EG_GetRandomOfGroup", effectGroup.EG_GetRandomOfGroup);
  expose("EG_IsEffectOnGroup", effectGroup.EG_IsEffectOnGroup);
  expose("EG_IsGroupHaveEffect", effectGroup.EG_IsGroupHaveEffect);
  expose("EG_IsGroupEmpty", effectGroup.EG_IsGroupEmpty);
  expose("EG_GetCount", effectGroup.EG_GetCount);
  expose("EG_GetAt", effectGroup.EG_GetAt);
  expose("EG_GroupAddGroup", effectGroup.EG_GroupAddGroup);
  expose("EG_I2EG", effectGroup.EG_I2EG);
  expose("EG_EG2I", effectGroup.EG_EG2I);
  // 单位判定与筛选函数
  expose("SUC_IsValidUnit", unitCondition.SUC_IsValidUnit);
  expose("SUC_GetFilterUnitOrNull", unitCondition.SUC_GetFilterUnitOrNull);
  expose("SUC_GetUnitLife", unitCondition.SUC_GetUnitLife);
  expose("SUC_IsUnitAlive", unitCondition.SUC_IsUnitAlive);
  expose("SUC_IsUnitStructure", unitCondition.SUC_IsUnitStructure);
  expose("SUC_IsUnitInvincible", unitCondition.SUC_IsUnitInvincible);
  expose("SUC_IsUnitEnemyToUnit", unitCondition.SUC_IsUnitEnemyToUnit);
  expose("SUC_IsUnitAllyToUnit", unitCondition.SUC_IsUnitAllyToUnit);
  expose("SUC_MatchBasicTarget", unitCondition.SUC_MatchBasicTarget);
  expose("SUF_Base_1", unitCondition.SUF_Base_1);
  expose("SUF_Base_2", unitCondition.SUF_Base_2);
  expose("SUF_Base_3", unitCondition.SUF_Base_3);
  // 单位基础与生命周期函数
  expose("SU_IsUnitInvincible", unitBase.SU_IsUnitInvincible);
  expose("SU_SetUnitFlyHeight", unitBase.SU_SetUnitFlyHeight);
  expose("SU_GetHeroAllState", unitBase.SU_GetHeroAllState);
  expose("SU_GetUnitLostHPPercent", unitBase.SU_GetUnitLostHPPercent);
  expose("SU_GetUnitLostHP", unitBase.SU_GetUnitLostHP);
  expose("UnitAddHp", unitBase.UnitAddHp);
  expose("SU_IsUnitDie", unitBase.SU_IsUnitDie);
  expose("SU_ShowOrHideUnit", unitBase.SU_ShowOrHideUnit);
  expose("IsWaterElement", unitBase.IsWaterElement);
  expose("GetUnitTimedLifeID", unitBase.GetUnitTimedLifeID);
  expose("I2TimedLifeID", unitBase.I2TimedLifeID);
  // 单位属性方位与攻击函数
  expose("SU_GetUnitModel", unitAttr.SU_GetUnitModel);
  expose("SU_GetHeroParmary", unitAttr.SU_GetHeroParmary);
  expose("SU_AddHeroState", unitAttr.SU_AddHeroState);
  expose("SU_GetHeroParmaryValue", unitAttr.SU_GetHeroParmaryValue);
  expose("SU_AddHeroAllState", unitAttr.SU_AddHeroAllState);
  expose("SU_SetHeroParmaryValue", unitAttr.SU_SetHeroParmaryValue);
  expose("SU_HeroISParmary", unitAttr.SU_HeroISParmary);
  expose("SU_DotBehindUnit", unitAttr.SU_DotBehindUnit);
  expose("SU_GetUnitOfUnit", unitAttr.SU_GetUnitOfUnit);
  expose("SU_IsUnitInfrontUnit2", unitAttr.SU_IsUnitInfrontUnit2);
  expose("SU_IsUnitInfrontUnit", unitAttr.SU_IsUnitInfrontUnit);
  expose("SU_IsUnitBehindUnit", unitAttr.SU_IsUnitBehindUnit);
  expose("SU_GetUnitWhiteAtk", unitAttr.SU_GetUnitWhiteAtk);
  // 物品技能事件
  expose("SU_AddItemAbilityEvent", itemAbility.SU_AddItemAbilityEvent);
  expose("SU_InititemAbilityListener", itemAbility.SU_InititemAbilityListener);
  expose("SU_GetLastSpellItemAbility", itemAbility.SU_GetLastSpellItemAbility);
  expose("SU_GetLastSpellItemAbilityTargetX", itemAbility.SU_GetLastSpellItemAbilityTargetX);
  expose("SU_GetLastSpellItemAbilityTargetY", itemAbility.SU_GetLastSpellItemAbilityTargetY);
  expose("SU_GetLastSpellItemAbilityTargetUnit", itemAbility.SU_GetLastSpellItemAbilityTargetUnit);
  expose("SU_GetLastSpellItemAbilityTargetPoint", itemAbility.SU_GetLastSpellItemAbilityTargetPoint);
  // StarBase基础函数
  expose("Star_CoordinateX", starBase.Star_CoordinateX);
  expose("Star_CoordinateY", starBase.Star_CoordinateY);
  expose("Star_GetLocZ", starBase.Star_GetLocZ);
  expose("GetRectByHandle", starBase.GetRectByHandle);
}

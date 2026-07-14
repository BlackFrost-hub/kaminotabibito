export * from "./00．镜头函数";
export * from "./01．SDR调试计时器";
export * from "./02．Star自定义事件";
export * from "./03．硬直暂停系统";
export * from "./04．快速Buff系统";
export * from "./05．移动速度突破系统";
export * from "./06．X库函数";
export * from "./06A．X库函数安全版";
export * from "./07．特效组系统";
export * from "./08．单位判定与筛选函数";
export * from "./09．单位基础与生命周期函数";
export * from "./10．英雄属性与攻击力函数";
export * from "./11．方位判断函数";
export * from "./12．StarBase基础函数";

import * as cameraFunc from "./00．镜头函数";
import * as sdrDebug from "./01．SDR调试计时器";
import * as starEvent from "./02．Star自定义事件";
import * as suspend from "./03．硬直暂停系统";
import * as fastBuff from "./04．快速Buff系统";
import * as overSpeed from "./05．移动速度突破系统";
import * as xLib from "./06．X库函数";
import * as xLibSafe from "./06A．X库函数安全版";
import * as effectGroup from "./07．特效组系统";
import * as unitCondition from "./08．单位判定与筛选函数";
import * as unitBase from "./09．单位基础与生命周期函数";
import * as heroAttr from "./10．英雄属性与攻击力函数";
import * as dirFunc from "./11．方位判断函数";
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
  expose("添加单位暂停", suspend.添加单位暂停);
  expose("移除单位暂停", suspend.移除单位暂停);
  expose("设置单位暂停时间", suspend.设置单位暂停时间);
  expose("增加单位暂停时间", suspend.增加单位暂停时间);
  expose("减少单位暂停时间", suspend.减少单位暂停时间);
  expose("单位是否暂停", suspend.单位是否暂停);
  expose("获取单位暂停剩余时间", suspend.获取单位暂停剩余时间);
  expose("GS_AcquireUnitPause", suspend.申请单位暂停占用);
  expose("GS_ReleaseUnitPause", suspend.释放单位暂停占用);
  expose("GS_AcquireUnitPauseUnique", suspend.申请单位暂停独立占用);
  expose("GS_SetUnitPauseUnique", suspend.设置单位暂停独立占用);
  expose("GS_ReleaseUnitPauseSourceAll", suspend.释放单位暂停来源全部);
  expose("GS_ClearUnitPauseAll", suspend.清除单位全部暂停占用);
  expose("GS_AcquireUnitPauseTimed", suspend.申请单位暂停占用定时);
  expose("GS_CancelUnitPauseTimed", suspend.取消单位暂停占用定时);
  expose("GS_HasUnitPauseOccupancy", suspend.单位是否存在暂停占用);
  expose("GS_HasOtherUnitPauseOccupancy", suspend.单位是否存在其他暂停占用);
  expose("GS_GetUnitPauseOccupancyCount", suspend.获取单位暂停占用总数);
  expose("GS_GetUnitPauseSourceCount", suspend.获取单位暂停来源计数);
  expose("GS_GetUnitPauseSources", suspend.获取单位暂停来源列表);
  expose("GS_GetUnitPauseSnapshot", suspend.获取单位暂停快照);
  expose("GS_RefreshUnitPauseState", suspend.刷新单位暂停底层状态);
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
  expose("X_IsTerrainWalkable", xLibSafe.X_IsTerrainWalkableSafe);
  expose("X_IsTerrainWalkableSafe", xLibSafe.X_IsTerrainWalkableSafe);
  expose("X_IsUnitTerrainWalkable", xLibSafe.X_IsUnitTerrainWalkableSafe);
  expose("X_IsUnitTerrainWalkableSafe", xLibSafe.X_IsUnitTerrainWalkableSafe);
  expose("X_GetAbleX", xLibSafe.X_GetAbleXSafe);
  expose("X_GetAbleXSafe", xLibSafe.X_GetAbleXSafe);
  expose("X_GetAbleY", xLibSafe.X_GetAbleYSafe);
  expose("X_GetAbleYSafe", xLibSafe.X_GetAbleYSafe);
  expose("X_IsTerrainDeepWater", xLibSafe.X_IsTerrainDeepWaterSafe);
  expose("X_IsTerrainDeepWaterSafe", xLibSafe.X_IsTerrainDeepWaterSafe);
  expose("X_IsTerrainShallowWater", xLibSafe.X_IsTerrainShallowWaterSafe);
  expose("X_IsTerrainShallowWaterSafe", xLibSafe.X_IsTerrainShallowWaterSafe);
  expose("X_IsTerrainLand", xLibSafe.X_IsTerrainLandSafe);
  expose("X_IsTerrainLandSafe", xLibSafe.X_IsTerrainLandSafe);
  expose("X_IsTerrainPlatform", xLibSafe.X_IsTerrainPlatformSafe);
  expose("X_IsTerrainPlatformSafe", xLibSafe.X_IsTerrainPlatformSafe);
  expose("X_SetUnitMovable", xLibSafe.X_SetUnitMovableSafe);
  expose("X_SetUnitMovableSafe", xLibSafe.X_SetUnitMovableSafe);
  expose("X_FixUnitStandingSafe", xLibSafe.X_FixUnitStandingSafe);
  expose("X_RestoreUnitStandingSafe", xLibSafe.X_RestoreUnitStandingSafe);
  expose("X_GDBC", xLibSafe.X_GDBCSafe);
  expose("X_GDBCSafe", xLibSafe.X_GDBCSafe);
  expose("X_GAFC", xLibSafe.X_GAFCSafe);
  expose("X_GAFCSafe", xLibSafe.X_GAFCSafe);
  expose("X_R2I2", xLibSafe.X_R2I2Safe);
  expose("X_R2I2Safe", xLibSafe.X_R2I2Safe);
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
  // 英雄属性与攻击力函数
  expose("SU_GetUnitModel", heroAttr.SU_GetUnitModel);
  expose("SU_GetHeroParmary", heroAttr.SU_GetHeroParmary);
  expose("SU_AddHeroState", heroAttr.SU_AddHeroState);
  expose("SU_GetHeroParmaryValue", heroAttr.SU_GetHeroParmaryValue);
  expose("SU_AddHeroAllState", heroAttr.SU_AddHeroAllState);
  expose("SU_SetHeroParmaryValue", heroAttr.SU_SetHeroParmaryValue);
  expose("SU_HeroISParmary", heroAttr.SU_HeroISParmary);
  expose("SU_GetUnitWhiteAtk", heroAttr.SU_GetUnitWhiteAtk);
  // 方位判断函数（新）
  expose("是否在指定角度范围内", dirFunc.是否在指定角度范围内);
  expose("是否在前方角度内", dirFunc.是否在前方角度内);
  expose("是否在后方角度内", dirFunc.是否在后方角度内);
  expose("是否在正前方", dirFunc.是否在正前方);
  expose("是否在正后方", dirFunc.是否在正后方);
  expose("是否在左侧", dirFunc.是否在左侧);
  expose("是否在右侧", dirFunc.是否在右侧);
  expose("是否在前方", dirFunc.是否在前方);
  expose("是否在后方", dirFunc.是否在后方);
  expose("获取方位区间", dirFunc.获取方位区间);
  // 旧函数兼容
  expose("SU_DotBehindUnit", dirFunc.SU_DotBehindUnit);
  expose("SU_GetUnitOfUnit", dirFunc.SU_GetUnitOfUnit);
  expose("SU_IsUnitInfrontUnit2", dirFunc.SU_IsUnitInfrontUnit2);
  expose("SU_IsUnitInfrontUnit", dirFunc.SU_IsUnitInfrontUnit);
  expose("SU_IsUnitBehindUnit", dirFunc.SU_IsUnitBehindUnit);
  // StarBase基础函数
  expose("Star_CoordinateX", starBase.Star_CoordinateX);
  expose("Star_CoordinateY", starBase.Star_CoordinateY);
  expose("Star_GetLocZ", starBase.Star_GetLocZ);
  expose("GetRectByHandle", starBase.GetRectByHandle);
}

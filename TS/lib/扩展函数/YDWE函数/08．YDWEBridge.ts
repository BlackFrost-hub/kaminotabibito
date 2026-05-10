/** @noSelfInFile */
import * as ydweFunc from "./00．YDWE函数";
import * as ydCompat from "./01．YDUserData兼容";
import * as ydLocal from "./02．YDLocal兼容";
import * as ydweMacro from "./03．YDWE_Base";
import * as ydTrigger from "./04．YDWE_trigger";

function expose(name: string, fn: any): void {
  if (typeof fn !== "function") return;
  const g = globalThis as any;
  if (typeof g[name] === "function") return;
  g[name] = fn;
}

export function registerBridge(): void {
  expose("YDWEDistanceBetweenUnits", ydweFunc.YDWEDistanceBetweenUnits);
  expose("YDWEAngleBetweenUnits", ydweFunc.YDWEAngleBetweenUnits);

  expose("YDUserDataGet", ydCompat.YDUserDataGet);
  expose("YDUserDataSet", ydCompat.YDUserDataSet);
  expose("YDUserDataGet2", ydCompat.YDUserDataGet2);
  expose("YDUserDataSet2", ydCompat.YDUserDataSet2);
  expose("YDUserDataClearTable", ydCompat.YDUserDataClearTable);
  expose("YDUserDataClear", ydCompat.YDUserDataClear);
  expose("YDUserDataClear2", ydCompat.YDUserDataClear2);
  expose("YDUserDataHas", ydCompat.YDUserDataHas);
  expose("YDUserDataHas2", ydCompat.YDUserDataHas2);

  expose("YDLocalInitialize", ydLocal.YDLocalInitialize);
  expose("YDLocal1Release", ydLocal.YDLocal1Release);
  expose("YDLocal1Get", ydLocal.YDLocal1Get);
  expose("YDLocal1Set", ydLocal.YDLocal1Set);
  expose("YDLocalSet", ydLocal.YDLocalSet);
  expose("YDLocal5Set", ydLocal.YDLocal5Set);
  expose("YDLocal5Get", ydLocal.YDLocal5Get);
  expose("flushYDLocal5ParamPage", ydLocal.flushYDLocal5ParamPage);
  expose("YDLocal7Set", ydLocal.YDLocal7Set);
  expose("YDLocal7Get", ydLocal.YDLocal7Get);
  expose("clearStar_PIndex", ydLocal.clearStar_PIndex);
  expose("getSKey_PIndex", ydLocal.getSKey_PIndex);
  expose("getSKey_Trigger", ydLocal.getSKey_Trigger);

  expose("OperatorDegreeAdd", ydweMacro.OperatorDegreeAdd);
  expose("OperatorDegreeSubtract", ydweMacro.OperatorDegreeSubtract);
  expose("OperatorDegreeMultiply", ydweMacro.OperatorDegreeMultiply);
  expose("OperatorDegreeDivide", ydweMacro.OperatorDegreeDivide);
  expose("OperatorRadianAdd", ydweMacro.OperatorRadianAdd);
  expose("OperatorRadianSubtract", ydweMacro.OperatorRadianSubtract);
  expose("OperatorRadianMultiply", ydweMacro.OperatorRadianMultiply);
  expose("OperatorRadianDivide", ydweMacro.OperatorRadianDivide);
  expose("OperatorIntegerAdd", ydweMacro.OperatorIntegerAdd);
  expose("OperatorIntegerSubtract", ydweMacro.OperatorIntegerSubtract);
  expose("OperatorIntegerMultiply", ydweMacro.OperatorIntegerMultiply);
  expose("OperatorIntegerDivide", ydweMacro.OperatorIntegerDivide);
  expose("OperatorRealAdd", ydweMacro.OperatorRealAdd);
  expose("OperatorRealSubtract", ydweMacro.OperatorRealSubtract);
  expose("OperatorRealMultiply", ydweMacro.OperatorRealMultiply);
  expose("OperatorRealDivide", ydweMacro.OperatorRealDivide);
  expose("YDWEOperatorInt3", ydweMacro.YDWEOperatorInt3);
  expose("YDWEOperatorReal3", ydweMacro.YDWEOperatorReal3);
  expose("YDWEOperatorString3", ydweMacro.YDWEOperatorString3);
  expose("YDWER2Rad", ydweMacro.YDWER2Rad);
  expose("YDWER2Deg", ydweMacro.YDWER2Deg);
  expose("YDWEDeg2R", ydweMacro.YDWEDeg2R);
  expose("YDWERad2R", ydweMacro.YDWERad2R);
  expose("YDWEInitHashtable", ydweMacro.YDWEInitHashtable);
  expose("YDWEIsTriggerEventId", ydweMacro.YDWEIsTriggerEventId);
  expose("YDWEH2I", ydweMacro.YDWEH2I);
  expose("YDWEGetUnitID", ydweMacro.YDWEGetUnitID);
  expose("YDWEGetItemID", ydweMacro.YDWEGetItemID);
  expose("YDWEGetPlayerID", ydweMacro.YDWEGetPlayerID);
  expose("YDWEGetTimerID", ydweMacro.YDWEGetTimerID);
  expose("YDWEGetTriggerID", ydweMacro.YDWEGetTriggerID);
  expose("YDWEGetGroupID", ydweMacro.YDWEGetGroupID);
  expose("YDWEGetLocationID", ydweMacro.YDWEGetLocationID);
  expose("YDWEGetMultiboardID", ydweMacro.YDWEGetMultiboardID);
  expose("YDWEGetMultiboardItemID", ydweMacro.YDWEGetMultiboardItemID);
  expose("YDWEGetTextTagID", ydweMacro.YDWEGetTextTagID);
  expose("YDWEGetLightningID", ydweMacro.YDWEGetLightningID);
  expose("YDWEGetRegionID", ydweMacro.YDWEGetRegionID);
  expose("YDWEGetRectID", ydweMacro.YDWEGetRectID);
  expose("YDWEGetLeaderboardID", ydweMacro.YDWEGetLeaderboardID);
  expose("YDWEGetEffectID", ydweMacro.YDWEGetEffectID);
  expose("YDWEGetDestructableID", ydweMacro.YDWEGetDestructableID);
  expose("YDWEGetTriggerConditionID", ydweMacro.YDWEGetTriggerConditionID);
  expose("YDWEGetTriggerActionID", ydweMacro.YDWEGetTriggerActionID);
  expose("YDWEGetTriggerEventID", ydweMacro.YDWEGetTriggerEventID);
  expose("YDWEGetForceID", ydweMacro.YDWEGetForceID);
  expose("YDWEGetBoolexprID", ydweMacro.YDWEGetBoolexprID);
  expose("YDWEGetSoundID", ydweMacro.YDWEGetSoundID);
  expose("YDWEGetTimerDialogID", ydweMacro.YDWEGetTimerDialogID);
  expose("YDWEGetTrackableID", ydweMacro.YDWEGetTrackableID);
  expose("YDWEGetDialogID", ydweMacro.YDWEGetDialogID);
  expose("YDWEGetButtonID", ydweMacro.YDWEGetButtonID);
  expose("YDWEConvert", ydweMacro.YDWEConvert);
  expose("YDWEGetUnitTypeID", ydweMacro.YDWEGetUnitTypeID);
  expose("YDWEGetAbilityTypeID", ydweMacro.YDWEGetAbilityTypeID);
  expose("YDWEGetItemTypeID", ydweMacro.YDWEGetItemTypeID);
  expose("YDWEConverUnitcodeToInt", ydweMacro.YDWEConverUnitcodeToInt);
  expose("YDWEConverItemcodeToInt", ydweMacro.YDWEConverItemcodeToInt);
  expose("YDWEConverAbilcodeToInt", ydweMacro.YDWEConverAbilcodeToInt);
  expose("YDWEConverOrdercodeToInt", ydweMacro.YDWEConverOrdercodeToInt);
  expose("YDWEUOrderId2OrderId", ydweMacro.YDWEUOrderId2OrderId);
  expose("YDWEPOrderId2OrderId", ydweMacro.YDWEPOrderId2OrderId);
  expose("YDWEDOrderId2OrderId", ydweMacro.YDWEDOrderId2OrderId);
  expose("YDWEIOrderId2OrderId", ydweMacro.YDWEIOrderId2OrderId);
  expose("YDWENOrderId2OrderId", ydweMacro.YDWENOrderId2OrderId);
  expose("YDLocalExecuteTrigger", ydTrigger.YDLocalExecuteTrigger);
  expose("YDTriggerExecuteTrigger", ydTrigger.YDTriggerExecuteTrigger);
  expose("saveParentIndex", ydTrigger.saveParentIndex);
  expose("removeParentIndex", ydTrigger.removeParentIndex);

  expose("YDWEI2UnitId", ydweMacro.YDWEI2UnitId);
  expose("YDWEI2ItemId", ydweMacro.YDWEI2ItemId);
  expose("YDWETimerDestroyEffect", ydweFunc.YDWETimerDestroyEffect);
}

const fs = require("fs");
const path = require("path");

const root = "C:/Users/Administrator/Desktop/syzl";
const newText = fs.readFileSync(path.join(root, "新japi表.txt"), "utf8");
const oldText = fs.readFileSync(path.join(root, "japi表.txt"), "utf8");

const newNames = [...new Set(newText.replace(/^\[japi\]\s*list=/, " ").split(",").map(s => s.trim()).filter(Boolean))];
const oldNames = [...new Set((oldText.match(/\b(?:Dz[A-Za-z0-9_]+|EX[A-Za-z0-9_]+|Ex[A-Za-z0-9_]+|KK[A-Za-z0-9_]+|RequestExtra[A-Za-z0-9_]+|GetEventDamage|GetUnitState|SetUnitState)\b/g) || []))];
const allNames = [...newNames];
for (const name of oldNames) {
  if (!allNames.includes(name)) allNames.push(name);
}

const constNames = new Set(oldNames.filter(name => name.startsWith("DzEvent_")));

const overrides = {
  DzAPI_Map_GetGameStartTime: "\u5730\u56fe_\u53d6\u5f00\u5c40\u65f6\u95f4",
  DzAPI_Map_GetActivityData: "\u5730\u56fe_\u53d6\u6d3b\u52a8\u6570\u636e",
  DzAPI_Map_MissionComplete: "\u5730\u56fe_\u4efb\u52a1\u5b8c\u6210",
  DzAPI_Map_GetServerArchiveDrop: "\u5730\u56fe_\u53d6\u670d\u52a1\u5668\u5b58\u6863\u6389\u843d",
  DzAPI_Map_GetMapLevel: "\u5730\u56fe_\u53d6\u5730\u56fe\u7b49\u7ea7",
  DzAPI_Map_IsRPGLobby: "\u5730\u56fe_\u662f\u5426RPG\u5927\u5385",
  DzAPI_Map_GetPublicArchive: "\u5730\u56fe_\u53d6\u516c\u5171\u5b58\u6863",
  DzAPI_Map_Ladder_SetStat: "\u5730\u56fe_\u5929\u68af\u8bbe\u7f6e\u7edf\u8ba1",
  DzAPI_Map_IsBlueVIP: "\u5730\u56fe_\u662f\u5426\u84ddV",
  DzAPI_Map_SaveServerValue: "\u5730\u56fe_\u4fdd\u5b58\u670d\u52a1\u5668\u503c",
  DzAPI_Map_GetServerValue: "\u5730\u56fe_\u53d6\u670d\u52a1\u5668\u503c",
  DzAPI_Map_Stat_SetStat: "\u5730\u56fe_\u7edf\u8ba1\u8bbe\u7f6e\u7edf\u8ba1",
  DzAPI_Map_Ladder_SetPlayerStat: "\u5730\u56fe_\u5929\u68af\u8bbe\u7f6e\u73a9\u5bb6\u7edf\u8ba1",
  DzAPI_Map_IsRPGLadder: "\u5730\u56fe_\u662f\u5426RPG\u5929\u68af",
  DzAPI_Map_GetMatchType: "\u5730\u56fe_\u53d6\u5339\u914d\u7c7b\u578b",
  DzAPI_Map_UpdatePlayerHero: "\u5730\u56fe_\u66f4\u65b0\u73a9\u5bb6\u82f1\u96c4",
  DzAPI_Map_GetLadderLevel: "\u5730\u56fe_\u53d6\u5929\u68af\u7b49\u7ea7",
  DzAPI_Map_IsRedVIP: "\u5730\u56fe_\u662f\u5426\u7ea2V",
  DzAPI_Map_GetLadderRank: "\u5730\u56fe_\u53d6\u5929\u68af\u6392\u540d",
  DzAPI_Map_GetMapLevelRank: "\u5730\u56fe_\u53d6\u5730\u56fe\u7b49\u7ea7\u6392\u540d",
  DzAPI_Map_GetServerValueErrorCode: "\u5730\u56fe_\u53d6\u670d\u52a1\u5668\u503c\u9519\u8bef\u7801",
  DzAPI_Map_GetGuildName: "\u5730\u56fe_\u53d6\u516c\u4f1a\u540d",
  DzAPI_Map_GetServerArchiveEquip: "\u5730\u56fe_\u53d6\u670d\u52a1\u5668\u5b58\u6863\u88c5\u5907",
  DzAPI_Map_GetGuildRole: "\u5730\u56fe_\u53d6\u516c\u4f1a\u89d2\u8272",
  DzAPI_Map_GetMapConfig: "\u5730\u56fe_\u53d6\u5730\u56fe\u914d\u7f6e",
  DzAPI_Map_HasMallItem: "\u5730\u56fe_\u662f\u5426\u62e5\u6709\u5546\u57ce\u7269\u54c1",
  DzAPI_Map_ChangeStoreItemCoolDown: "\u5730\u56fe_\u4fee\u6539\u5546\u5e97\u7269\u54c1\u51b7\u5374",
  DzAPI_Map_ToggleStore: "\u5730\u56fe_\u5207\u6362\u5546\u5e97",
  DzAPI_Map_OrpgTrigger: "\u5730\u56fe_\u8c03\u7528ORPG\u89e6\u53d1",
  DzAPI_Map_GetUserID: "\u5730\u56fe_\u53d6\u7528\u6237ID",
  DzAPI_Map_GetPlatformVIP: "\u5730\u56fe_\u53d6\u5e73\u53f0VIP",
  DzAPI_Map_SavePublicArchive: "\u5730\u56fe_\u4fdd\u5b58\u516c\u5171\u5b58\u6863",
  DzAPI_Map_UseConsumablesItem: "\u5730\u56fe_\u4f7f\u7528\u6d88\u8017\u54c1",
  DzAPI_Map_ChangeStoreItemCount: "\u5730\u56fe_\u4fee\u6539\u5546\u5e97\u7269\u54c1\u6570\u91cf",
  DzAPI_Map_Statistics: "\u5730\u56fe_\u7edf\u8ba1\u4e0a\u62a5",
  DzLoadToc: "\u52a0\u8f7dToc",
  DzSyncData: "\u540c\u6b65\u6570\u636e",
  DzSyncDataImmediately: "\u7acb\u5373\u540c\u6b65\u6570\u636e",
  DzGetTriggerKeyPlayer: "\u53d6\u89e6\u53d1\u6309\u952e\u73a9\u5bb6",
  DzGetTriggerKey: "\u53d6\u89e6\u53d1\u6309\u952e",
  DzGetGameUI: "\u53d6\u6e38\u620f\u754c\u9762",
  GetEventDamage: "\u53d6\u4e8b\u4ef6\u4f24\u5bb3",
  GetUnitState: "\u53d6\u5355\u4f4d\u72b6\u6001",
  SetUnitState: "\u8bbe\u5355\u4f4d\u72b6\u6001"
};

const tokenMap = {
  Dz:"\u5e73\u53f0", API:"\u63a5\u53e3", Map:"\u5730\u56fe", Ladder:"\u5929\u68af", Stat:"\u7edf\u8ba1", Player:"\u73a9\u5bb6", Hero:"\u82f1\u96c4",
  Unit:"\u5355\u4f4d", Item:"\u7269\u54c1", Frame:"\u754c\u9762", Trigger:"\u89e6\u53d1", Mouse:"\u9f20\u6807", Wheel:"\u6eda\u8f6e", Move:"\u79fb\u52a8",
  Window:"\u7a97\u53e3", Resize:"\u5c3a\u5bf8\u53d8\u5316", Sync:"\u540c\u6b65", Data:"\u6570\u636e", Buffer:"\u7f13\u51b2", Get:"\u53d6", Set:"\u8bbe\u7f6e",
  Is:"\u662f\u5426", Has:"\u6709", Update:"\u66f4\u65b0", Change:"\u4fee\u6539", Toggle:"\u5207\u6362", Save:"\u4fdd\u5b58", Use:"\u4f7f\u7528",
  Register:"\u6ce8\u518c", Create:"\u521b\u5efa", Destroy:"\u9500\u6bc1", Clear:"\u6e05\u7a7a", Enable:"\u542f\u7528", Disable:"\u7981\u7528", Click:"\u70b9\u51fb",
  Load:"\u52a0\u8f7d", Execute:"\u6267\u884c", Convert:"\u8f6c\u6362", Edit:"\u7f16\u8f91", Show:"\u663e\u793a", Hide:"\u9690\u85cf", Bind:"\u7ed1\u5b9a",
  UnBind:"\u89e3\u7ed1", Unbind:"\u89e3\u7ed1", Add:"\u6dfb\u52a0", Remove:"\u79fb\u9664", Open:"\u6253\u5f00", Close:"\u5173\u95ed", Reverse:"\u53cd\u8f6c",
  Force:"\u5f3a\u5236", Keyboard:"\u952e\u76d8", Screen:"\u5c4f\u5e55", World:"\u4e16\u754c", Terrain:"\u5730\u5f62", X:"X", Y:"Y", Z:"Z", UI:"\u754c\u9762",
  Game:"\u6e38\u620f", Client:"\u5ba2\u6237\u7aef", Local:"\u672c\u5730", Recipient:"\u63a5\u6536\u8005", System:"\u7cfb\u7edf", Metrics:"\u6307\u6807", Focus:"\u7126\u70b9",
  Under:"\u4e0b", Color:"\u989c\u8272", Alpha:"\u900f\u660e\u5ea6", Vertex:"\u9876\u70b9", Text:"\u6587\u672c", Texture:"\u8d34\u56fe", Font:"\u5b57\u4f53",
  Tooltip:"\u63d0\u793a", Point:"\u70b9", Relative:"\u76f8\u5bf9", Absolute:"\u7edd\u5bf9", Parent:"\u7236\u5e27", Children:"\u5b50\u9879\u6570", Child:"\u5b50\u9879",
  Name:"\u540d\u5b57", Size:"\u5927\u5c0f", Width:"\u5bbd\u5ea6", Height:"\u9ad8\u5ea6", Value:"\u503c", Min:"\u6700\u5c0f", Max:"\u6700\u5927", Step:"\u6b65\u8fdb",
  Model:"\u6a21\u578b", Camera:"\u955c\u5934", Source:"\u6e90", Target:"\u76ee\u6807", Portrait:"\u5934\u50cf", Chat:"\u804a\u5929", Message:"\u6d88\u606f", Top:"\u9876\u90e8",
  Upper:"\u4e0a\u65b9", Lower:"\u4e0b\u65b9", Command:"\u547d\u4ee4", Bar:"\u680f", Button:"\u6309\u94ae", Number:"\u7f16\u53f7", Overlay:"\u8986\u76d6", Info:"\u4fe1\u606f",
  Mana:"\u84dd\u6761", HP:"\u8840\u6761", Hp:"\u8840\u6761", Black:"\u9ed1", Borders:"\u8fb9\u6846", Key:"\u6309\u952e", Selected:"\u5df2\u9009", Select:"\u9009\u62e9",
  Locale:"\u8bed\u8a00", Original:"\u539f\u7248", Params:"\u53c2\u6570", Destructable:"\u53ef\u7834\u574f\u7269", Memory:"\u5185\u5b58", War3:"\u9b54\u517d3",
  Silence:"\u6c89\u9ed8", Inventory:"\u80cc\u5305", Dota:"\u5200\u5854", Platform:"\u5e73\u53f0", Learning:"\u5b66\u4e60", Skill:"\u6280\u80fd", Effect:"\u7279\u6548",
  Mat:"\u77e9\u9635", Reset:"\u91cd\u7f6e", Speed:"\u901f\u5ea6", Scale:"\u7f29\u653e", Rotate:"\u65cb\u8f6c", Facing:"\u671d\u5411", Pause:"\u6682\u505c",
  Collision:"\u78b0\u649e", Integer:"\u6574\u6570", String:"\u5b57\u7b26\u4e32", Real:"\u5b9e\u6570", Array:"\u6570\u7ec4", Ability:"\u6280\u80fd", State:"\u72b6\u6001",
  Buff:"Buff", Damage:"\u4f24\u5bb3", Event:"\u4e8b\u4ef6", Script:"\u811a\u672c", Display:"\u663e\u793a", Blend:"\u6df7\u5408", Declare:"\u58f0\u660e", Dclare:"\u58f0\u660e",
  Widget:"\u63a7\u4ef6", FPS:"\u5e27\u7387", Spell:"\u6cd5\u672f", Book:"\u4e66", Missile:"\u6295\u5c04\u7269", Homing:"\u8ffd\u8e2a", Arc:"\u5f27\u5ea6", Cache:"\u7f13\u5b58",
  Hook:"\u94a9\u5b50", Code:"\u4ee3\u7801", Boolean:"\u5e03\u5c14", Void:"\u7a7a\u8fd4\u56de", Handle:"\u53e5\u67c4", Order:"\u6307\u4ee4", Orders:"\u6307\u4ee4\u961f\u5217",
  Neutral:"\u4e2d\u7acb", Group:"\u5355\u4f4d\u7ec4", Queue:"\u961f\u5217", Build:"\u5efa\u9020", Attack:"\u653b\u51fb", Instant:"\u77ac\u53d1", Immediate:"\u7acb\u5373",
  Tech:"\u79d1\u6280", Req:"\u9700\u6c42", Level:"\u7b49\u7ea7", Art:"\u7f8e\u672f", Cool:"\u51b7\u5374", Cost:"\u6d88\u8017", Area:"\u8303\u56f4", Range:"\u5c04\u7a0b",
  Duration:"\u6301\u7eed\u65f6\u95f4", HeroDuration:"\u82f1\u96c4\u6301\u7eed\u65f6\u95f4", Cast:"\u65bd\u6cd5", Time:"\u65f6\u95f4", Tip:"\u63d0\u793a", Uber:"\u6269\u5c55",
  Engineering:"\u5de5\u7a0b", Upgrade:"\u5347\u7ea7", Cancel:"\u53d6\u6d88", Reach:"\u8fbe\u6210", Hotkey:"\u70ed\u952e", Back:"\u80cc", Swing:"\u6447",
  BuildOrder:"\u5efa\u9020\u5e8f\u53f7", UnitId:"\u5355\u4f4dID", Targs:"\u76ee\u6807\u7c7b\u578b", Count:"\u6570\u91cf", MaxCool:"\u6700\u5927\u51b7\u5374",
  MaxDamage:"\u6700\u5927\u4f24\u5bb3", CoolDown:"\u51b7\u5374", Projectile:"\u6295\u5c04\u7269", Pojectile:"\u6295\u5c04\u7269", Launch:"\u53d1\u5c04",
  Description:"\u8bf4\u660e", Life:"\u751f\u547d", Regen:"\u56de\u590d", ManaRegen:"\u9b54\u6cd5\u56de\u590d", CastPoint:"\u65bd\u6cd5\u524d\u6447",
  AttackTarget:"\u653b\u51fb\u76ee\u6807", HeroPrimary:"\u82f1\u96c4\u4e3b\u5c5e\u6027", Attribute:"\u5c5e\u6027", Plus:"\u52a0\u503c", Hashtable:"\u54c8\u5e0c\u8868",
  Null:"\u7a7a", Fix:"\u4fee\u6b63", Leak:"\u6cc4\u6f0f", Illusion:"\u5e7b\u8c61", Active:"\u6fc0\u6d3b", Async:"\u5f02\u6b65", Visible:"\u53ef\u89c1",
  Clip:"\u88c1\u526a", Rect:"\u77e9\u5f62", Particle:"\u7c92\u5b50", Shadow:"\u9634\u5f71", Start:"\u5f00\u59cb", FontSpacing:"\u5b57\u4f53\u95f4\u8ddd",
  IgnoreTrackEvents:"\u5ffd\u7565\u8f68\u8ff9\u4e8b\u4ef6", Simple:"\u7b80\u5355", Glue:"\u9ecf\u9644", EditBox:"\u7f16\u8f91\u6846", Context:"\u4e0a\u4e0b\u6587",
  Draw:"\u7ed8\u5236", Preselect:"\u9884\u9009", ToggleFPS:"\u5207\u6362\u5e27\u7387", TeamColor:"\u961f\u4f0d\u989c\u8272", Clipboard:"\u526a\u8d34\u677f",
  Revive:"\u590d\u6d3b", TypeId:"\u7c7b\u578bID", Position:"\u4f4d\u7f6e", Trim:"\u88c1\u526a\u7a7a\u767d", Left:"\u5de6", Right:"\u53f3", Find:"\u67e5\u627e",
  First:"\u9996\u4e2a", Last:"\u672b\u4e2a", Replace:"\u66ff\u6362", Contains:"\u5305\u542b", Insert:"\u63d2\u5165", Bit:"\u4f4d", And:"\u4e0e", Or:"\u6216",
  Xor:"\u5f02\u6216", Shift:"\u79fb\u4f4d", Byte:"\u5b57\u8282", Xlsx:"\u8868\u683c", Worksheet:"\u5de5\u4f5c\u8868", Row:"\u884c", Column:"\u5217",
  Cell:"\u5355\u5143\u683c", Float:"\u6d6e\u70b9", Request:"\u8bf7\u6c42", Extra:"\u989d\u5916"
};

function splitCamel(text) {
  return text.match(/[A-Z]+(?![a-z])|[A-Z]?[a-z]+|[0-9]+/g) || [text];
}

function translateWord(word) {
  return tokenMap[word] || word;
}

function translateBody(text) {
  return text
    .split("_")
    .filter(Boolean)
    .map(part => splitCamel(part).map(translateWord).join(""))
    .join("_");
}

function classify(name) {
  if (name.startsWith("DzAPI_Map_")) return ["\u5730\u56fe", name.slice("DzAPI_Map_".length), "\u5730\u56fe_"];
  if (name.startsWith("DzEvent_")) return ["\u4e8b\u4ef6", name.slice("DzEvent_".length), "\u4e8b\u4ef6_"];
  if (name.startsWith("DzDotaInfo_")) return ["\u5200\u5854\u4fe1\u606f", name.slice("DzDotaInfo_".length), "\u5200\u5854\u4fe1\u606f_"];
  if (name.startsWith("DzPlatform_")) return ["\u5e73\u53f0", name.slice("DzPlatform_".length), "\u5e73\u53f0_"];
  if (name.startsWith("DzFrame")) return ["\u754c\u9762\u5e27", name.slice(7), "\u754c\u9762_"];
  if (name.startsWith("DzSimple")) return ["\u7b80\u5355\u754c\u9762", name.slice(8), "\u7b80\u5355\u754c\u9762_"];
  if (name.startsWith("DzTriggerRegister")) return ["\u4e8b\u4ef6\u6ce8\u518c", name.slice("DzTriggerRegister".length), "\u6ce8\u518c_"];
  if (name.startsWith("DzTrigger")) return ["\u89e6\u53d1\u5668", name.slice(9), "\u89e6\u53d1\u5668_"];
  if (name.startsWith("DzGet")) return ["\u83b7\u53d6", name.slice(5), "\u53d6"];
  if (name.startsWith("DzSet")) return ["\u8bbe\u7f6e", name.slice(5), "\u8bbe\u7f6e_"];
  if (name.startsWith("DzIs")) return ["\u5224\u5b9a", name.slice(4), "\u662f\u5426_"];
  if (name.startsWith("DzEnable")) return ["\u542f\u7528\u7981\u7528", name.slice(8), "\u542f\u7528_"];
  if (name.startsWith("DzDisable")) return ["\u542f\u7528\u7981\u7528", name.slice(9), "\u7981\u7528_"];
  if (name.startsWith("DzCreate")) return ["\u521b\u5efa\u9500\u6bc1", name.slice(8), "\u521b\u5efa_"];
  if (name.startsWith("DzDestroy")) return ["\u521b\u5efa\u9500\u6bc1", name.slice(9), "\u9500\u6bc1_"];
  if (name.startsWith("DzLoad")) return ["\u52a0\u8f7d", name.slice(6), "\u52a0\u8f7d_"];
  if (name.startsWith("DzClick")) return ["\u4ea4\u4e92", name.slice(7), "\u70b9\u51fb_"];
  if (name.startsWith("DzConvert")) return ["\u8f6c\u6362", name.slice(9), "\u8f6c\u6362_"];
  if (name.startsWith("DzString")) return ["\u5b57\u7b26\u4e32", name.slice(8), "\u5b57\u7b26\u4e32_"];
  if (name.startsWith("DzBit")) return ["\u4f4d\u8fd0\u7b97", name.slice(5), "\u4f4d\u8fd0\u7b97_"];
  if (name.startsWith("DzXlsx")) return ["\u8868\u683c", name.slice(6), "\u8868\u683c_"];
  if (name.startsWith("DzDoodad")) return ["\u88c5\u9970\u7269", name.slice(8), "\u88c5\u9970\u7269_"];
  if (name.startsWith("DzItem")) return ["\u7269\u54c1", name.slice(6), "\u7269\u54c1_"];
  if (name.startsWith("DzUnit")) return ["\u5355\u4f4d", name.slice(6), "\u5355\u4f4d_"];
  if (name.startsWith("DzTextTag")) return ["\u6f02\u6d6e\u5b57", name.slice(9), "\u6f02\u6d6e\u5b57_"];
  if (name.startsWith("DzModel")) return ["\u6a21\u578b", name.slice(7), "\u6a21\u578b_"];
  if (name.startsWith("DzWindow")) return ["\u7a97\u53e3", name.slice(8), "\u7a97\u53e3_"];
  if (name.startsWith("DzQueue")) return ["\u961f\u5217\u547d\u4ee4", name.slice(7), "\u961f\u5217\u547d\u4ee4_"];
  if (name.startsWith("DzLaunch")) return ["\u53d1\u5c04", name.slice(8), "\u53d1\u5c04_"];
  if (/^EX(?:Effect|SetEffect|GetEffect)/.test(name)) return ["\u7279\u6548\u6269\u5c55", name.replace(/^EX(?:Effect|SetEffect|GetEffect)/, ""), "\u7279\u6548\u6269\u5c55_"];
  if (/^(?:EXGetUnit|EXSetUnit|EXPauseUnit|ExGetUnit)/.test(name)) return ["\u5355\u4f4d\u6269\u5c55", name.replace(/^EX(?:GetUnit|SetUnit)|^EXPauseUnit|^ExGetUnit/, ""), "\u5355\u4f4d\u6269\u5c55_"];
  if (/^(?:EXGetAbility|EXSetAbility|EXGetUnitAbility|EXSetBuff)/.test(name)) return ["\u6280\u80fd\u6269\u5c55", name.replace(/^EX(?:GetAbility|SetAbility|GetUnitAbility|SetBuff)/, ""), name.startsWith("EXSetBuff") ? "Buff\u6269\u5c55_" : "\u6280\u80fd\u6269\u5c55_"];
  if (/^(?:EXGetItem|EXSetItem)/.test(name)) return ["\u7269\u54c1\u6269\u5c55", name.replace(/^EX(?:GetItem|SetItem)/, ""), "\u7269\u54c1\u6269\u5c55_"];
  if (/^(?:EXGetEventDamage|EXSetEventDamage)/.test(name)) return ["\u4f24\u5bb3\u6269\u5c55", name.replace(/^EX(?:GetEventDamage|SetEventDamage)/, ""), "\u4f24\u5bb3\u6269\u5c55_"];
  if (name.startsWith("EXExecute")) return ["\u811a\u672c\u6269\u5c55", name.slice(2), "\u811a\u672c\u6269\u5c55_"];
  if (/^(?:EXDisplay|EXDclare|EXBlend)/.test(name)) return ["\u663e\u793a\u6269\u5c55", name.slice(2), "\u663e\u793a\u6269\u5c55_"];
  if (/^(?:KKCommand|KKCreateCommandButton|KKDestroyCommandButton|KKSetCommandUnitAbility|KKCommandButton)/.test(name)) return ["KK\u547d\u4ee4\u6309\u94ae", name.slice(2), "KK\u547d\u4ee4\u6309\u94ae_"];
  if (name.startsWith("KKHookCode")) return ["KK\u94a9\u5b50", name.slice(2), "KK\u94a9\u5b50_"];
  if (name.startsWith("RequestExtra")) return ["\u989d\u5916\u6570\u636e", name.slice("RequestExtra".length), "\u989d\u5916\u6570\u636e_"];
  return ["\u5176\u4ed6\u5e73\u53f0", name.replace(/^Dz/, ""), "\u5e73\u53f0_"];
}

function buildChineseName(name) {
  if (overrides[name]) return overrides[name];
  const [, body, prefix] = classify(name);
  return (prefix + translateBody(body))
    .replace(/__+/g, "_")
    .replace(/^_+|_+$/g, "")
    .replace(/^\u53d6_/, "\u53d6")
    .replace(/^\u8bbe\u7f6e_\u8bbe\u7f6e/, "\u8bbe\u7f6e")
    .replace(/^\u662f\u5426_\u662f\u5426/, "\u662f\u5426")
    .replace(/^\u521b\u5efa_\u521b\u5efa/, "\u521b\u5efa")
    .replace(/^\u9500\u6bc1_\u9500\u6bc1/, "\u9500\u6bc1");
}

const used = new Map();
const entries = allNames.map(name => {
  let cn = buildChineseName(name);
  const count = used.get(cn) || 0;
  used.set(cn, count + 1);
  if (count > 0) cn = `${cn}_${count + 1}`;
  const [group] = classify(name);
  return { name, cn, group, isConst: constNames.has(name) };
});

const groupOrder = [
  "\u5730\u56fe", "\u4e8b\u4ef6", "\u5200\u5854\u4fe1\u606f", "\u5e73\u53f0", "\u754c\u9762\u5e27", "\u7b80\u5355\u754c\u9762", "\u4e8b\u4ef6\u6ce8\u518c", "\u89e6\u53d1\u5668",
  "\u83b7\u53d6", "\u8bbe\u7f6e", "\u5224\u5b9a", "\u542f\u7528\u7981\u7528", "\u521b\u5efa\u9500\u6bc1", "\u52a0\u8f7d", "\u4ea4\u4e92", "\u8f6c\u6362",
  "\u5b57\u7b26\u4e32", "\u4f4d\u8fd0\u7b97", "\u8868\u683c", "\u88c5\u9970\u7269", "\u7269\u54c1", "\u5355\u4f4d", "\u6f02\u6d6e\u5b57", "\u6a21\u578b",
  "\u7a97\u53e3", "\u961f\u5217\u547d\u4ee4", "\u53d1\u5c04", "\u7279\u6548\u6269\u5c55", "\u5355\u4f4d\u6269\u5c55", "\u6280\u80fd\u6269\u5c55", "\u7269\u54c1\u6269\u5c55",
  "\u4f24\u5bb3\u6269\u5c55", "\u811a\u672c\u6269\u5c55", "\u663e\u793a\u6269\u5c55", "KK\u547d\u4ee4\u6309\u94ae", "KK\u94a9\u5b50", "\u989d\u5916\u6570\u636e", "\u5176\u4ed6\u5e73\u53f0"
];

const grouped = new Map(groupOrder.map(group => [group, []]));
for (const entry of entries) {
  if (!grouped.has(entry.group)) grouped.set(entry.group, []);
  grouped.get(entry.group).push(entry);
}

const lines = [];
lines.push("/** @noSelfInFile */");
lines.push("");
lines.push("/**");
lines.push(" * 由 `新japi表.txt` 全量函数表生成，并补入 `japi表.txt` 的旧表独有项。");
lines.push(" *");
lines.push(" * 约定：");
lines.push(" * - 可调用平台接口统一包装为 `export function 中文名(...参数)`；");
lines.push(" * - 旧表里的 `DzEvent_*` 常量保留为 `export const 中文名`；");
lines.push(" * - 内部统一通过字符串索引调用原生表，避免方法调用形态漂移。");
lines.push(" */");
lines.push("");
lines.push("type 原生可调用 = (...参数: any[]) => any;");
lines.push("type 原生表 = Record<string, any>;");
lines.push("");
lines.push("const 平台扩展 = require(\"jass.japi\") as 原生表;");
lines.push("const 原生函数表 = 平台扩展 as Record<string, 原生可调用>;");
lines.push("const 原生值表 = 平台扩展 as 原生表;");
lines.push("");

for (const group of groupOrder) {
  const list = grouped.get(group) || [];
  if (list.length === 0) continue;
  lines.push(`// ${group}`);
  for (const entry of list) {
    lines.push(`/** 原名: ${entry.name} */`);
    if (entry.isConst) {
      lines.push(`export const ${entry.cn} = 原生值表[\"${entry.name}\"];`);
    } else {
      lines.push(`export function ${entry.cn}(...参数: any[]): any { return 原生函数表[\"${entry.name}\"](...参数); }`);
    }
    lines.push("");
  }
}

fs.writeFileSync(path.join(root, "TS", "平台扩展API.ts"), lines.join("\n"), "utf8");

const collisions = [...used.entries()].filter(([, count]) => count > 1);
console.log(JSON.stringify({
  total: entries.length,
  functions: entries.filter(v => !v.isConst).length,
  constants: entries.filter(v => v.isConst).length,
  collisions: collisions.length,
  file: "TS/平台扩展API.ts"
}, null, 2));
